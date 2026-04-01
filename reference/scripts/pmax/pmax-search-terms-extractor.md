---
title: "PMax Search Terms Extractor"
date: 2026-03-31
tags:
  - reference
  - scripts
  - pmax
---

# PMax Search Terms Extractor

Extracts Performance Max search term categories to a Google Sheet for analysis. PMax campaigns don't expose individual search terms, but they do report **search term categories** (grouped themes). This script pulls those categories with performance metrics so you can identify what PMax is actually bidding on and where to add negative keywords or create dedicated Search campaigns.

**Source pattern:** agencysavvy/pmax
**Schedule:** Weekly
**Runtime:** ~2–5 minutes

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `SPREADSHEET_URL` | `""` | Google Sheets URL for output. **Required** — create a sheet first so data accumulates over time. |
| `SHEET_NAME` | `"Search Terms"` | Tab name within the spreadsheet. |
| `CAMPAIGN_NAME_CONTAINS` | `""` | Filter to PMax campaigns matching this string. Empty = all PMax campaigns. |
| `DATE_RANGE` | `"LAST_7_DAYS"` | Date range for metrics. Matches the weekly schedule. |
| `MIN_IMPRESSIONS` | `10` | Minimum impressions for a category to be included. Filters out noise. |
| `EMAIL_RECIPIENTS` | `""` | Comma-separated email addresses for weekly digest. |
| `INCLUDE_HISTORICAL` | `true` | When true, appends new rows (building history). When false, overwrites each run. |

## Script

```javascript
/**
 * PMax Search Terms Extractor
 *
 * Extracts search term categories from Performance Max campaigns
 * to a Google Sheet. PMax does not expose individual search terms,
 * but search term categories (grouped themes) are available via
 * the reporting API.
 *
 * Source pattern: agencysavvy/pmax
 * Schedule: Weekly
 */

// ============================================================
// CONFIGURATION — Edit these values
// ============================================================
var CONFIG = {
  SPREADSHEET_URL: "",
  SHEET_NAME: "Search Terms",
  CAMPAIGN_NAME_CONTAINS: "",
  DATE_RANGE: "LAST_7_DAYS",
  MIN_IMPRESSIONS: 10,
  EMAIL_RECIPIENTS: "",
  INCLUDE_HISTORICAL: true
};

function main() {
  if (!CONFIG.SPREADSHEET_URL) {
    Logger.log("ERROR: SPREADSHEET_URL is required. Create a Google Sheet and paste the URL.");
    return;
  }

  var spreadsheet = SpreadsheetApp.openByUrl(CONFIG.SPREADSHEET_URL);
  var sheet = getOrCreateSheet(spreadsheet, CONFIG.SHEET_NAME);

  // Set up header if new sheet
  if (sheet.getLastRow() === 0 || !CONFIG.INCLUDE_HISTORICAL) {
    setupSheet(sheet);
  }

  var today = Utilities.formatDate(new Date(), "GMT", "yyyy-MM-dd");

  // Build GAQL query for PMax search term insights
  var query =
    "SELECT " +
    "  campaign.name, " +
    "  campaign.id, " +
    "  campaign_search_term_insight.category_label, " +
    "  metrics.impressions, " +
    "  metrics.clicks, " +
    "  metrics.cost_micros, " +
    "  metrics.conversions, " +
    "  metrics.conversions_value " +
    "FROM campaign_search_term_insight " +
    "WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX' " +
    "  AND metrics.impressions >= " + CONFIG.MIN_IMPRESSIONS;

  if (CONFIG.CAMPAIGN_NAME_CONTAINS) {
    query += " AND campaign.name LIKE '%" + CONFIG.CAMPAIGN_NAME_CONTAINS + "%'";
  }

  query += " ORDER BY metrics.impressions DESC";

  // Execute query
  var results;
  try {
    results = AdsApp.search(query);
  } catch (e) {
    Logger.log("Error running GAQL query: " + e.message);
    Logger.log("Falling back to report-based extraction...");
    results = null;
  }

  var rows = [];

  if (results) {
    while (results.hasNext()) {
      var row = results.next();
      var costMicros = row.metrics.costMicros || 0;
      var cost = costMicros / 1000000;
      var impressions = row.metrics.impressions || 0;
      var clicks = row.metrics.clicks || 0;
      var conversions = row.metrics.conversions || 0;
      var convValue = row.metrics.conversionsValue || 0;

      rows.push({
        date: today,
        dateRange: CONFIG.DATE_RANGE,
        campaignName: row.campaign.name,
        campaignId: row.campaign.id,
        category: row.campaignSearchTermInsight.categoryLabel,
        impressions: impressions,
        clicks: clicks,
        ctr: impressions > 0 ? (clicks / impressions) : 0,
        cost: cost,
        conversions: conversions,
        conversionValue: convValue,
        costPerConversion: conversions > 0 ? (cost / conversions) : 0,
        roas: cost > 0 ? (convValue / cost) : 0
      });
    }
  }

  // Write rows to sheet
  writeRows(sheet, rows);

  Logger.log("Extracted " + rows.length + " search term categories from PMax campaigns.");

  // Email digest
  if (CONFIG.EMAIL_RECIPIENTS && rows.length > 0) {
    var topCategories = rows.slice(0, 10).map(function(r) {
      return "  - " + r.category + " (" + r.impressions + " impr, " + r.clicks + " clicks)";
    }).join("\n");

    MailApp.sendEmail({
      to: CONFIG.EMAIL_RECIPIENTS,
      subject: "PMax Search Terms: " + rows.length + " categories extracted",
      body: "Extracted " + rows.length + " search term categories from PMax campaigns.\n\n" +
            "Top categories:\n" + topCategories + "\n\n" +
            "Full report: " + spreadsheet.getUrl()
    });
  }
}

/**
 * Gets or creates a named sheet tab.
 */
function getOrCreateSheet(spreadsheet, sheetName) {
  var sheet = spreadsheet.getSheetByName(sheetName);
  if (!sheet) {
    sheet = spreadsheet.insertSheet(sheetName);
  }
  return sheet;
}

/**
 * Sets up the header row.
 */
function setupSheet(sheet) {
  sheet.clear();
  sheet.appendRow([
    "Extract Date",
    "Date Range",
    "Campaign",
    "Campaign ID",
    "Search Term Category",
    "Impressions",
    "Clicks",
    "CTR",
    "Cost",
    "Conversions",
    "Conv. Value",
    "Cost/Conv.",
    "ROAS"
  ]);
  sheet.getRange("1:1").setFontWeight("bold");
  sheet.setFrozenRows(1);
}

/**
 * Appends data rows to the sheet.
 */
function writeRows(sheet, rows) {
  if (rows.length === 0) {
    Logger.log("No search term categories found matching criteria.");
    return;
  }

  for (var i = 0; i < rows.length; i++) {
    var r = rows[i];
    sheet.appendRow([
      r.date,
      r.dateRange,
      r.campaignName,
      r.campaignId,
      r.category,
      r.impressions,
      r.clicks,
      (r.ctr * 100).toFixed(2) + "%",
      r.cost.toFixed(2),
      r.conversions.toFixed(1),
      r.conversionValue.toFixed(2),
      r.costPerConversion.toFixed(2),
      r.roas.toFixed(2)
    ]);
  }
}
```

## Setup Instructions

1. **Create a Google Sheet** — the script needs a persistent sheet to accumulate weekly data
2. **Copy the Sheet URL** and paste it into `SPREADSHEET_URL`
3. **Create the script:** Google Ads → Tools & Settings → Bulk Actions → Scripts → New Script
4. **Paste the code** and update the `CONFIG` object
5. **Authorize** when prompted (needs Sheets access)
6. **Preview** first to verify data extraction works
7. **Schedule** to run weekly (e.g., Monday morning)

> [!info] GAQL Search Term Insights
> This script uses the `campaign_search_term_insight` GAQL resource, which provides **category-level** search term data for PMax. Individual search terms are not available — Google only exposes grouped categories. This is still the most granular PMax search data you can get programmatically.

## Customization Guide

### Build a historical trend

Keep `INCLUDE_HISTORICAL` as `true` (default). Each weekly run appends new rows with the extract date. Over time, you can build pivot tables to track how search term categories shift week over week.

### Filter to specific PMax campaigns

Set `CAMPAIGN_NAME_CONTAINS` to target specific campaigns. For example, `"PMax — Brand"` would only extract from campaigns with "PMax — Brand" in the name.

### Adjust the noise filter

`MIN_IMPRESSIONS` defaults to `10`. Lower it to `1` if you want to catch every category, or raise it to `50` to focus on high-volume terms only.

### What to do with the data

Use the extracted categories to:

1. **Add account-level negative keywords** for irrelevant categories
2. **Create dedicated Search campaigns** for high-performing categories (gives you more control)
3. **Adjust audience signals** based on which categories are driving the most traffic
4. **Identify brand cannibalization** where PMax is capturing searches your Brand campaign should handle

> [!tip] Pair with Category Labeling
> Use the [[pmax-category-label-script|PMax Category Label Script]] to automatically label PMax campaigns based on their top search term categories. This makes filtering and reporting in the Google Ads UI much easier.

## Related Reference

- [[catalog|Scripts Catalog]] — full index of available scripts
- [[pmax-metrics|PMax Metrics]] — understanding PMax performance data
- [[pmax-category-label-script|PMax Category Label Script]] — auto-label by search categories
- [[gaql-reference|GAQL Reference]] — Google Ads Query Language reference
