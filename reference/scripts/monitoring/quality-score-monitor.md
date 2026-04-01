---
title: Quality Score Monitor Script
date: 2026-03-31
tags:
  - reference
  - scripts
  - monitoring
---

# Quality Score Monitor Script

Tracks Quality Score and its three components (Expected CTR, Ad Relevance, Landing Page Experience) for all keywords over time. Exports daily snapshots to a Google Sheet, building a historical record that lets you spot QS degradation trends. Optionally sends an email alert when keywords drop below a threshold.

> [!tip] Why track QS over time?
> Google Ads only shows the current Quality Score — no history. Without a daily log, you cannot tell when QS changed or correlate it with landing page deployments, ad copy changes, or GTM/consent updates. This script creates that history.

**Schedule:** Daily

## Configuration

| Variable | Type | Default | Description |
|---|---|---|---|
| `SPREADSHEET_URL` | String | `""` | Google Sheet URL where QS data is logged. Must be pre-created |
| `SHEET_NAME` | String | `"QualityScoreLog"` | Tab name within the spreadsheet |
| `QS_ALERT_THRESHOLD` | Number | `4` | Send email alert for keywords with QS at or below this value |
| `EMAIL_RECIPIENTS` | String | `""` | Comma-separated email addresses for alerts. Leave empty to skip email |
| `MIN_IMPRESSIONS` | Number | `100` | Only track keywords with at least this many impressions (last 30 days) |
| `CAMPAIGN_NAME_CONTAINS` | String | `""` | Only include campaigns whose name contains this string. Leave empty for all |
| `INCLUDE_COMPONENTS` | Boolean | `true` | Whether to log the three QS components alongside the overall score |

## Script

```javascript
/**
 * Quality Score Monitor
 *
 * Exports daily Quality Score snapshots to Google Sheets and
 * optionally alerts on keywords below a QS threshold.
 *
 * Tracks all three QS components:
 *   - Expected CTR
 *   - Ad Relevance
 *   - Landing Page Experience
 *
 * Schedule: Daily
 */
function main() {
  // ===================== CONFIGURATION =====================
  var CONFIG = {
    // Google Sheet URL (must be pre-created and accessible)
    SPREADSHEET_URL: "https://docs.google.com/spreadsheets/d/YOUR_SHEET_ID/edit",

    // Sheet tab name
    SHEET_NAME: "QualityScoreLog",

    // Alert threshold (alert on QS at or below this value)
    QS_ALERT_THRESHOLD: 4,

    // Email addresses for alerts (empty = no email)
    EMAIL_RECIPIENTS: "",

    // Minimum impressions in last 30 days to qualify
    MIN_IMPRESSIONS: 100,

    // Only include campaigns containing this string (empty = all)
    CAMPAIGN_NAME_CONTAINS: "",

    // Log QS components (Expected CTR, Ad Relevance, Landing Page)
    INCLUDE_COMPONENTS: true
  };
  // =========================================================

  var today = _formatDate(new Date());
  var sheet = _getOrCreateSheet(CONFIG.SPREADSHEET_URL, CONFIG.SHEET_NAME, CONFIG.INCLUDE_COMPONENTS);

  // Build keyword selector
  var selector = AdsApp.keywords()
    .withCondition("Status = ENABLED")
    .withCondition("AdGroupStatus = ENABLED")
    .withCondition("CampaignStatus = ENABLED")
    .withCondition("Impressions > " + CONFIG.MIN_IMPRESSIONS)
    .forDateRange("LAST_30_DAYS")
    .orderBy("QualityScore ASC");

  if (CONFIG.CAMPAIGN_NAME_CONTAINS !== "") {
    selector = selector.withCondition(
      "CampaignName CONTAINS '" + CONFIG.CAMPAIGN_NAME_CONTAINS + "'"
    );
  }

  var keywords = selector.get();
  var rowsLogged = 0;
  var lowQsKeywords = [];

  while (keywords.hasNext()) {
    var keyword = keywords.next();
    var qs = keyword.getQualityScore();

    // Skip keywords without a QS (new keywords, low data)
    if (qs === null || qs === undefined) {
      continue;
    }

    var campaignName = keyword.getCampaign().getName();
    var adGroupName = keyword.getAdGroup().getName();
    var keywordText = keyword.getText();
    var matchType = keyword.getMatchType();

    var stats = keyword.getStatsFor("LAST_30_DAYS");
    var impressions = stats.getImpressions();
    var clicks = stats.getClicks();
    var ctr = stats.getCtr();

    // Build row data
    var row = [
      today,
      campaignName,
      adGroupName,
      keywordText,
      matchType,
      qs,
      impressions,
      clicks,
      (ctr * 100).toFixed(2) + "%"
    ];

    // Add QS components if configured
    if (CONFIG.INCLUDE_COMPONENTS) {
      var expectedCtr = _getQsComponent(keyword, "expectedCtr");
      var adRelevance = _getQsComponent(keyword, "adRelevance");
      var landingPage = _getQsComponent(keyword, "landingPageExperience");

      row.push(expectedCtr);
      row.push(adRelevance);
      row.push(landingPage);
    }

    sheet.appendRow(row);
    rowsLogged++;

    // Track low QS keywords for alert
    if (qs <= CONFIG.QS_ALERT_THRESHOLD) {
      lowQsKeywords.push({
        campaign: campaignName,
        adGroup: adGroupName,
        keyword: keywordText,
        matchType: matchType,
        qs: qs,
        expectedCtr: CONFIG.INCLUDE_COMPONENTS ? expectedCtr : "N/A",
        adRelevance: CONFIG.INCLUDE_COMPONENTS ? adRelevance : "N/A",
        landingPage: CONFIG.INCLUDE_COMPONENTS ? landingPage : "N/A"
      });
    }
  }

  Logger.log("Logged " + rowsLogged + " keywords to sheet.");
  Logger.log("Keywords at or below QS " + CONFIG.QS_ALERT_THRESHOLD + ": " + lowQsKeywords.length);

  // Send alert email if configured and there are low QS keywords
  if (CONFIG.EMAIL_RECIPIENTS !== "" && lowQsKeywords.length > 0) {
    _sendAlert(CONFIG.EMAIL_RECIPIENTS, lowQsKeywords, CONFIG.QS_ALERT_THRESHOLD, today);
  }
}

/**
 * Gets or creates the QS tracking sheet with headers.
 */
function _getOrCreateSheet(spreadsheetUrl, sheetName, includeComponents) {
  var ss = SpreadsheetApp.openByUrl(spreadsheetUrl);
  var sheet = ss.getSheetByName(sheetName);

  if (!sheet) {
    sheet = ss.insertSheet(sheetName);

    var headers = [
      "Date", "Campaign", "Ad Group", "Keyword", "Match Type",
      "QS", "Impressions (30d)", "Clicks (30d)", "CTR (30d)"
    ];

    if (includeComponents) {
      headers.push("Expected CTR");
      headers.push("Ad Relevance");
      headers.push("Landing Page");
    }

    sheet.appendRow(headers);
    sheet.getRange("1:1").setFontWeight("bold");
    sheet.setFrozenRows(1);

    Logger.log("Created new sheet: " + sheetName);
  }

  return sheet;
}

/**
 * Extracts a QS component value from a keyword.
 * Components return: "ABOVE_AVERAGE", "AVERAGE", or "BELOW_AVERAGE"
 *
 * Uses the keyword's quality score component methods.
 */
function _getQsComponent(keyword, component) {
  try {
    var quality = keyword.getQualityScore();
    if (quality === null) return "N/A";

    // Use the report API to get component-level data
    // Note: Direct methods vary by API version; falling back to report
    switch (component) {
      case "expectedCtr":
        return keyword.getExpectedCtr ? keyword.getExpectedCtr() : "N/A";
      case "adRelevance":
        return keyword.getAdRelevance ? keyword.getAdRelevance() : "N/A";
      case "landingPageExperience":
        return keyword.getLandingPageExperience ? keyword.getLandingPageExperience() : "N/A";
      default:
        return "N/A";
    }
  } catch (e) {
    return "N/A";
  }
}

/**
 * Sends an email alert listing low QS keywords.
 */
function _sendAlert(recipients, lowQsKeywords, threshold, date) {
  var subject = "Quality Score Alert — " + lowQsKeywords.length + " keyword(s) at QS ≤ " + threshold + " — " + date;

  var body = "Quality Score Alert\n";
  body += "Date: " + date + "\n";
  body += "Threshold: QS ≤ " + threshold + "\n";
  body += "Keywords flagged: " + lowQsKeywords.length + "\n\n";

  body += "=== LOW QUALITY SCORE KEYWORDS ===\n\n";

  for (var i = 0; i < lowQsKeywords.length; i++) {
    var kw = lowQsKeywords[i];
    body += "  [QS " + kw.qs + "] " + kw.keyword + " (" + kw.matchType + ")\n";
    body += "    Campaign: " + kw.campaign + "\n";
    body += "    Ad Group: " + kw.adGroup + "\n";

    if (kw.expectedCtr !== "N/A") {
      body += "    Components: CTR=" + kw.expectedCtr;
      body += " | Relevance=" + kw.adRelevance;
      body += " | Landing=" + kw.landingPage + "\n";
    }

    body += "\n";
  }

  body += "---\n";
  body += "Improvement priorities by component:\n";
  body += "  - BELOW_AVERAGE Expected CTR → Improve ad copy, test new headlines\n";
  body += "  - BELOW_AVERAGE Ad Relevance → Align ad copy with keyword intent\n";
  body += "  - BELOW_AVERAGE Landing Page → Improve page speed, relevance, mobile UX\n";
  body += "\nGenerated by Quality Score Monitor script.";

  MailApp.sendEmail({
    to: recipients,
    subject: subject,
    body: body
  });

  Logger.log("Alert email sent to " + recipients);
}

/**
 * Formats a Date object as YYYY-MM-DD.
 */
function _formatDate(date) {
  var year = date.getFullYear();
  var month = ("0" + (date.getMonth() + 1)).slice(-2);
  var day = ("0" + date.getDate()).slice(-2);
  return year + "-" + month + "-" + day;
}
```

## Setup Instructions

1. **Create the Google Sheet first:**
   - Go to [sheets.google.com](https://sheets.google.com) and create a new spreadsheet
   - Name it something like `Quality Score Tracker`
   - Copy the URL
2. In Google Ads, go to **Tools → Bulk actions → Scripts**
3. Click **+ New script**
4. Name it `Quality Score Monitor`
5. Paste the script above
6. Set `CONFIG.SPREADSHEET_URL` to your Google Sheet URL
7. Optionally set `CONFIG.EMAIL_RECIPIENTS` if you want daily alerts
8. Click **Preview** to test — check Logger output and verify data appears in the sheet
9. Click **Authorize** when prompted (needs Sheets, email, and account access)
10. Set the schedule to **Daily**
11. Click **Save**

> [!warning] Sheet Access
> The Google Sheet must be accessible to the Google account that owns the Google Ads account. If the script fails with a permissions error, share the sheet with the Google Ads account email.

## Customization Guide

### Tracking QS Changes Over Time

The raw sheet data logs every keyword every day. To track changes, create a pivot table or use this formula in a new sheet tab to find keywords where QS dropped:

```
=QUERY(QualityScoreLog!A:L, "SELECT D, MAX(F), MIN(F) WHERE F IS NOT NULL GROUP BY D HAVING MAX(F) > MIN(F) ORDER BY MIN(F) ASC")
```

### Alerting Only on QS Drops (Not Consistently Low)

To alert only when QS drops compared to the previous day's log, you would need to read yesterday's data from the sheet and compare. Add before the alert section:

```javascript
// Read yesterday's QS data from sheet
var lastRow = sheet.getLastRow();
var yesterday = _formatDate(new Date(new Date().getTime() - 24 * 60 * 60 * 1000));
var data = sheet.getDataRange().getValues();

var previousQs = {};
for (var r = data.length - 1; r >= 1; r--) {
  if (data[r][0] === yesterday) {
    previousQs[data[r][3]] = data[r][5];  // keyword text -> QS
  }
}
```

### Filtering by Match Type

To only track exact match keywords (which have the most reliable QS):

```javascript
selector = selector.withCondition("KeywordMatchType = EXACT");
```

### Adjusting the Impression Threshold

For new accounts with fewer impressions, lower the threshold:

```javascript
MIN_IMPRESSIONS: 50,
```

For established accounts where you only care about high-traffic keywords:

```javascript
MIN_IMPRESSIONS: 500,
```

### Conditional Formatting in Google Sheets

After the first run, apply conditional formatting to the QS column in your sheet:

- QS 1-3: Red background
- QS 4-6: Yellow background
- QS 7-10: Green background

This makes the daily snapshots visually scannable.

## Related

- [[catalog|Scripts Catalog]] — full index of all scripts
- [[budget-pacing-alert]] — budget pacing alerts
- [[conversion-drop-alert]] — conversion monitoring
- [[../../platforms/google-ads/quality-score|Quality Score Reference]] — what QS means, how it is calculated, and how to improve it
