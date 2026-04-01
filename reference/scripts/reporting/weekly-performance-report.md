---
title: "Weekly Performance Report to Sheets"
date: 2026-03-31
tags:
  - reference
  - scripts
  - reporting
---

# Weekly Performance Report to Sheets

Exports campaign, keyword, and ad performance data to a formatted Google Sheet every Monday morning. Creates three tabs with headers, formatting, and conditional highlighting so the sheet is client-ready without manual work.

- **Schedule:** Weekly (Monday morning)
- **Source pattern:** pamnard/Google-Ads-Scripts
- **Output:** Google Sheet with three tabs

> [!info] Related reference
> See [[ads-scripts-api]] for the full Google Ads Scripts API and [[gaql-query-templates]] for standalone GAQL queries.

## Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `SPREADSHEET_URL` | string | _(required)_ | Full URL of the target Google Sheet |
| `DATE_RANGE` | string | `"LAST_7_DAYS"` | Reporting period. Valid: `LAST_7_DAYS`, `LAST_14_DAYS`, `LAST_30_DAYS`, `THIS_MONTH`, `LAST_MONTH` |
| `CAMPAIGN_FILTER` | string | `""` | Campaign name filter. Leave empty for all campaigns. Supports `CONTAINS` matching |
| `INCLUDE_PAUSED` | boolean | `false` | Whether to include paused campaigns in the report |
| `CURRENCY_SYMBOL` | string | `"€"` | Currency symbol for formatted cost columns |
| `MIN_IMPRESSIONS` | number | `0` | Minimum impressions for a row to appear in the report |
| `EMAIL_NOTIFICATION` | string | `""` | Email address to notify when report is ready. Leave empty to skip |

## Script

```javascript
/**
 * Weekly Performance Report to Google Sheets
 *
 * Exports campaign, keyword, and ad performance data to a formatted
 * Google Sheet. Creates three tabs: Campaign Summary, Keyword Detail,
 * and Ad Performance.
 *
 * Schedule: Weekly (Monday morning)
 * Source pattern: pamnard/Google-Ads-Scripts
 *
 * Setup:
 *   1. Create a Google Sheet and copy the URL
 *   2. Paste this script into Google Ads > Tools > Scripts
 *   3. Update the CONFIG object below
 *   4. Authorize and schedule for weekly (Monday)
 */

// ============================================================
// CONFIGURATION — edit these values
// ============================================================
var CONFIG = {
  // Google Sheet URL (create a blank sheet first)
  SPREADSHEET_URL: "https://docs.google.com/spreadsheets/d/YOUR_SHEET_ID/edit",

  // Date range for the report
  // Options: LAST_7_DAYS, LAST_14_DAYS, LAST_30_DAYS, THIS_MONTH, LAST_MONTH
  DATE_RANGE: "LAST_7_DAYS",

  // Filter campaigns by name (leave empty for all campaigns)
  // Example: "Brand" will match campaigns containing "Brand"
  CAMPAIGN_FILTER: "",

  // Include paused campaigns in the report
  INCLUDE_PAUSED: false,

  // Currency symbol for formatted columns
  CURRENCY_SYMBOL: "€",

  // Minimum impressions for a row to appear
  MIN_IMPRESSIONS: 0,

  // Email to notify when the report is ready (leave empty to skip)
  EMAIL_NOTIFICATION: ""
};

// ============================================================
// MAIN FUNCTION
// ============================================================
function main() {
  var spreadsheet = SpreadsheetApp.openByUrl(CONFIG.SPREADSHEET_URL);

  Logger.log("Starting Weekly Performance Report...");
  Logger.log("Date range: " + CONFIG.DATE_RANGE);

  // Build each tab
  buildCampaignSummary(spreadsheet);
  buildKeywordDetail(spreadsheet);
  buildAdPerformance(spreadsheet);

  // Send notification email if configured
  if (CONFIG.EMAIL_NOTIFICATION) {
    var accountName = AdsApp.currentAccount().getName();
    MailApp.sendEmail({
      to: CONFIG.EMAIL_NOTIFICATION,
      subject: "Weekly Ads Report Ready — " + accountName,
      body: "The weekly performance report for " + accountName +
            " has been updated.\n\n" +
            "Date range: " + CONFIG.DATE_RANGE + "\n" +
            "View it here: " + CONFIG.SPREADSHEET_URL
    });
    Logger.log("Notification sent to " + CONFIG.EMAIL_NOTIFICATION);
  }

  Logger.log("Report complete.");
}

// ============================================================
// CAMPAIGN SUMMARY TAB
// ============================================================
function buildCampaignSummary(spreadsheet) {
  var sheet = getOrCreateSheet(spreadsheet, "Campaign Summary");
  sheet.clear();

  // Header row
  var headers = [
    "Campaign", "Status", "Type",
    "Impressions", "Clicks", "CTR",
    "Cost", "Avg CPC",
    "Conversions", "Conv. Rate", "Cost/Conv.",
    "Conv. Value", "ROAS"
  ];
  sheet.appendRow(headers);

  // Build AWQL query
  var query = "SELECT CampaignName, CampaignStatus, AdvertisingChannelType, " +
    "Impressions, Clicks, Ctr, Cost, AverageCpc, " +
    "Conversions, ConversionRate, CostPerConversion, " +
    "ConversionValue " +
    "FROM CAMPAIGN_PERFORMANCE_REPORT " +
    "WHERE Impressions > " + CONFIG.MIN_IMPRESSIONS;

  if (!CONFIG.INCLUDE_PAUSED) {
    query += " AND CampaignStatus = ENABLED";
  }

  if (CONFIG.CAMPAIGN_FILTER) {
    query += " AND CampaignName CONTAINS_IGNORE_CASE '" + CONFIG.CAMPAIGN_FILTER + "'";
  }

  query += " DURING " + CONFIG.DATE_RANGE;

  var report = AdsApp.report(query);
  var rows = report.rows();
  var dataRows = [];

  while (rows.hasNext()) {
    var row = rows.next();
    var cost = parseFloat(row["Cost"].replace(/,/g, ""));
    var convValue = parseFloat(row["ConversionValue"].replace(/,/g, ""));
    var roas = cost > 0 ? (convValue / cost).toFixed(2) : "—";

    dataRows.push([
      row["CampaignName"],
      row["CampaignStatus"],
      row["AdvertisingChannelType"],
      parseInt(row["Impressions"].replace(/,/g, ""), 10),
      parseInt(row["Clicks"].replace(/,/g, ""), 10),
      row["Ctr"],
      CONFIG.CURRENCY_SYMBOL + " " + cost.toFixed(2),
      CONFIG.CURRENCY_SYMBOL + " " + parseFloat(row["AverageCpc"].replace(/,/g, "")).toFixed(2),
      parseFloat(row["Conversions"].replace(/,/g, "")),
      row["ConversionRate"],
      CONFIG.CURRENCY_SYMBOL + " " + parseFloat(row["CostPerConversion"].replace(/,/g, "")).toFixed(2),
      CONFIG.CURRENCY_SYMBOL + " " + convValue.toFixed(2),
      roas
    ]);
  }

  // Sort by cost descending
  dataRows.sort(function(a, b) {
    return parseFloat(b[6].replace(/[^0-9.-]/g, "")) -
           parseFloat(a[6].replace(/[^0-9.-]/g, ""));
  });

  // Write data rows
  for (var i = 0; i < dataRows.length; i++) {
    sheet.appendRow(dataRows[i]);
  }

  // Format header row
  formatHeaderRow(sheet, headers.length);

  Logger.log("Campaign Summary: " + dataRows.length + " rows written.");
}

// ============================================================
// KEYWORD DETAIL TAB
// ============================================================
function buildKeywordDetail(spreadsheet) {
  var sheet = getOrCreateSheet(spreadsheet, "Keyword Detail");
  sheet.clear();

  var headers = [
    "Campaign", "Ad Group", "Keyword", "Match Type", "QS",
    "Impressions", "Clicks", "CTR",
    "Cost", "Avg CPC",
    "Conversions", "Conv. Rate", "Cost/Conv."
  ];
  sheet.appendRow(headers);

  var query = "SELECT CampaignName, AdGroupName, Criteria, KeywordMatchType, " +
    "QualityScore, Impressions, Clicks, Ctr, Cost, AverageCpc, " +
    "Conversions, ConversionRate, CostPerConversion " +
    "FROM KEYWORDS_PERFORMANCE_REPORT " +
    "WHERE Impressions > " + CONFIG.MIN_IMPRESSIONS +
    " AND AdGroupStatus = ENABLED" +
    " AND Status = ENABLED";

  if (!CONFIG.INCLUDE_PAUSED) {
    query += " AND CampaignStatus = ENABLED";
  }

  if (CONFIG.CAMPAIGN_FILTER) {
    query += " AND CampaignName CONTAINS_IGNORE_CASE '" + CONFIG.CAMPAIGN_FILTER + "'";
  }

  query += " DURING " + CONFIG.DATE_RANGE;

  var report = AdsApp.report(query);
  var rows = report.rows();
  var dataRows = [];

  while (rows.hasNext()) {
    var row = rows.next();
    dataRows.push([
      row["CampaignName"],
      row["AdGroupName"],
      row["Criteria"],
      row["KeywordMatchType"],
      row["QualityScore"] || "—",
      parseInt(row["Impressions"].replace(/,/g, ""), 10),
      parseInt(row["Clicks"].replace(/,/g, ""), 10),
      row["Ctr"],
      CONFIG.CURRENCY_SYMBOL + " " + parseFloat(row["Cost"].replace(/,/g, "")).toFixed(2),
      CONFIG.CURRENCY_SYMBOL + " " + parseFloat(row["AverageCpc"].replace(/,/g, "")).toFixed(2),
      parseFloat(row["Conversions"].replace(/,/g, "")),
      row["ConversionRate"],
      CONFIG.CURRENCY_SYMBOL + " " + parseFloat(row["CostPerConversion"].replace(/,/g, "")).toFixed(2)
    ]);
  }

  // Sort by cost descending
  dataRows.sort(function(a, b) {
    return parseFloat(b[8].replace(/[^0-9.-]/g, "")) -
           parseFloat(a[8].replace(/[^0-9.-]/g, ""));
  });

  for (var i = 0; i < dataRows.length; i++) {
    sheet.appendRow(dataRows[i]);
  }

  formatHeaderRow(sheet, headers.length);

  Logger.log("Keyword Detail: " + dataRows.length + " rows written.");
}

// ============================================================
// AD PERFORMANCE TAB
// ============================================================
function buildAdPerformance(spreadsheet) {
  var sheet = getOrCreateSheet(spreadsheet, "Ad Performance");
  sheet.clear();

  var headers = [
    "Campaign", "Ad Group", "Ad Type", "Headlines (first 3)",
    "Impressions", "Clicks", "CTR",
    "Cost", "Conversions", "Conv. Rate"
  ];
  sheet.appendRow(headers);

  var query = "SELECT CampaignName, AdGroupName, AdType, HeadlinePart1, " +
    "HeadlinePart2, Description, " +
    "Impressions, Clicks, Ctr, Cost, Conversions, ConversionRate " +
    "FROM AD_PERFORMANCE_REPORT " +
    "WHERE Impressions > " + CONFIG.MIN_IMPRESSIONS +
    " AND AdGroupStatus = ENABLED";

  if (!CONFIG.INCLUDE_PAUSED) {
    query += " AND CampaignStatus = ENABLED";
  }

  if (CONFIG.CAMPAIGN_FILTER) {
    query += " AND CampaignName CONTAINS_IGNORE_CASE '" + CONFIG.CAMPAIGN_FILTER + "'";
  }

  query += " DURING " + CONFIG.DATE_RANGE;

  var report = AdsApp.report(query);
  var rows = report.rows();
  var dataRows = [];

  while (rows.hasNext()) {
    var row = rows.next();
    // Combine headline parts for readability
    var headlines = [row["HeadlinePart1"], row["HeadlinePart2"]]
      .filter(function(h) { return h && h !== "--"; })
      .join(" | ");

    dataRows.push([
      row["CampaignName"],
      row["AdGroupName"],
      row["AdType"],
      headlines,
      parseInt(row["Impressions"].replace(/,/g, ""), 10),
      parseInt(row["Clicks"].replace(/,/g, ""), 10),
      row["Ctr"],
      CONFIG.CURRENCY_SYMBOL + " " + parseFloat(row["Cost"].replace(/,/g, "")).toFixed(2),
      parseFloat(row["Conversions"].replace(/,/g, "")),
      row["ConversionRate"]
    ]);
  }

  // Sort by impressions descending
  dataRows.sort(function(a, b) { return b[4] - a[4]; });

  for (var i = 0; i < dataRows.length; i++) {
    sheet.appendRow(dataRows[i]);
  }

  formatHeaderRow(sheet, headers.length);

  Logger.log("Ad Performance: " + dataRows.length + " rows written.");
}

// ============================================================
// HELPER FUNCTIONS
// ============================================================

/**
 * Gets an existing sheet by name or creates a new one.
 * Avoids duplicates on re-runs.
 */
function getOrCreateSheet(spreadsheet, name) {
  var sheet = spreadsheet.getSheetByName(name);
  if (!sheet) {
    sheet = spreadsheet.insertSheet(name);
  }
  return sheet;
}

/**
 * Formats the first row as a styled header:
 * bold, white text on dark blue background, frozen row.
 */
function formatHeaderRow(sheet, columnCount) {
  var headerRange = sheet.getRange(1, 1, 1, columnCount);
  headerRange.setFontWeight("bold");
  headerRange.setBackground("#1a73e8");
  headerRange.setFontColor("#ffffff");
  sheet.setFrozenRows(1);

  // Auto-resize columns for readability
  for (var i = 1; i <= columnCount; i++) {
    sheet.autoResizeColumn(i);
  }
}
```

## Setup Instructions

1. **Create the Google Sheet**
   - Go to [sheets.google.com](https://sheets.google.com) and create a new blank spreadsheet
   - Name it something like "Weekly Ads Report — [Client Name]"
   - Copy the full URL from the browser address bar

2. **Create the script**
   - In Google Ads, go to **Tools & Settings > Bulk actions > Scripts**
   - Click the **+** button to create a new script
   - Name it "Weekly Performance Report"
   - Delete the default `function main() {}` and paste the full script above

3. **Configure**
   - Replace `SPREADSHEET_URL` with your Sheet URL
   - Adjust `DATE_RANGE`, `CAMPAIGN_FILTER`, and other variables in the `CONFIG` object
   - If you want email alerts, fill in `EMAIL_NOTIFICATION`

4. **Authorize**
   - Click **Authorize** when prompted — the script needs access to Google Sheets and your Ads account
   - Click **Preview** to do a dry run and check Logger output

5. **Schedule**
   - Click **Frequency** and set to **Weekly — Monday**
   - Choose a time (e.g., 06:00) so the report is ready at the start of the week

> [!warning] First run
> The first run creates the three tabs. Subsequent runs overwrite them entirely. If you need historical data, make a copy of the sheet before the next run or add date-stamped tab names in the script.

## Customization Guide

### Change which metrics appear

Edit the `headers` array and the matching AWQL `SELECT` fields in each `build*` function. Available fields are listed in [[ads-scripts-api#Reporting API]].

### Add a "Totals" row at the bottom

After the data-writing loop in any `build*` function, sum the numeric columns:

```javascript
// Example: add totals row to Campaign Summary
var totalImpressions = 0, totalClicks = 0, totalCost = 0;
for (var i = 0; i < dataRows.length; i++) {
  totalImpressions += dataRows[i][3];
  totalClicks += dataRows[i][4];
  totalCost += parseFloat(dataRows[i][6].replace(/[^0-9.-]/g, ""));
}
sheet.appendRow(["TOTAL", "", "", totalImpressions, totalClicks, "",
  CONFIG.CURRENCY_SYMBOL + " " + totalCost.toFixed(2),
  "", "", "", "", "", ""]);
```

### Filter to specific campaigns

Set `CAMPAIGN_FILTER` to a string that appears in the campaign names you want. For multiple filters, duplicate the query condition:

```javascript
query += " AND CampaignName CONTAINS_IGNORE_CASE 'Brand'";
query += " AND CampaignName DOES_NOT_CONTAIN_IGNORE_CASE 'Test'";
```

### Add date-stamped tabs instead of overwriting

Replace the `getOrCreateSheet` call with a date suffix:

```javascript
var today = Utilities.formatDate(new Date(), AdsApp.currentAccount().getTimeZone(), "yyyy-MM-dd");
var sheet = spreadsheet.insertSheet("Campaign Summary — " + today);
```

### Add conditional formatting for low CTR or high CPA

After writing data, apply a conditional rule:

```javascript
var ctrRange = sheet.getRange(2, 6, dataRows.length, 1); // CTR column
var rule = SpreadsheetApp.newConditionalFormatRule()
  .whenNumberLessThan(0.02)
  .setBackground("#fce4ec") // light red
  .setRanges([ctrRange])
  .build();
sheet.setConditionalFormatRules([rule]);
```
