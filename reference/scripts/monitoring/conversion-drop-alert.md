---
title: Conversion Drop Alert Script
date: 2026-03-31
tags:
  - reference
  - scripts
  - monitoring
---

# Conversion Drop Alert Script

Compares today's conversions against the same day last week for each campaign. Sends an email alert when conversions drop below a configurable threshold. Catches tracking breakage, landing page issues, or sudden performance shifts before they burn through budget.

> [!tip] Tracking specialist context
> Conversion drops often signal a tracking problem (tag misconfiguration, consent mode change, sGTM container issue) rather than a campaign performance issue. This script helps you detect tracking breakage early. Cross-reference alerts with GTM version history and sGTM logs.

**Schedule:** Daily (recommended: run in the evening after most daily traffic has occurred)

## Configuration

| Variable | Type | Default | Description |
|---|---|---|---|
| `DROP_THRESHOLD` | Number | `0.30` | Alert when conversions drop by more than this fraction vs last week (0.30 = 30% drop) |
| `MIN_CONVERSIONS_LAST_WEEK` | Number | `5` | Minimum conversions last week to qualify (avoids false alerts on low-volume campaigns) |
| `EMAIL_RECIPIENTS` | String | `""` | Comma-separated email addresses to receive alerts |
| `CAMPAIGN_NAME_CONTAINS` | String | `""` | Only check campaigns whose name contains this string. Leave empty for all |
| `CAMPAIGN_NAME_EXCLUDES` | String | `""` | Exclude campaigns whose name contains this string. Leave empty to exclude nothing |
| `INCLUDE_ZERO_TODAY` | Boolean | `true` | Whether to alert on campaigns with zero conversions today (if they had conversions last week) |

## Script

```javascript
/**
 * Conversion Drop Alert
 *
 * Compares today's conversions with the same day last week.
 * Alerts when any campaign shows a significant drop, which
 * may indicate tracking issues or performance problems.
 *
 * Schedule: Daily (evening recommended)
 */
function main() {
  // ===================== CONFIGURATION =====================
  var CONFIG = {
    // Alert when conversions drop by more than this fraction (0.30 = 30%)
    DROP_THRESHOLD: 0.30,

    // Minimum conversions last week to be eligible for alerting
    MIN_CONVERSIONS_LAST_WEEK: 5,

    // Comma-separated email addresses
    EMAIL_RECIPIENTS: "you@example.com",

    // Only check campaigns whose name contains this string (empty = all)
    CAMPAIGN_NAME_CONTAINS: "",

    // Exclude campaigns whose name contains this string (empty = exclude none)
    CAMPAIGN_NAME_EXCLUDES: "",

    // Alert on campaigns with zero conversions today
    INCLUDE_ZERO_TODAY: true
  };
  // =========================================================

  var today = new Date();
  var todayFormatted = _formatDate(today);

  // Calculate same day last week
  var lastWeek = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
  var lastWeekFormatted = _formatDate(lastWeek);

  Logger.log("Comparing: " + todayFormatted + " vs " + lastWeekFormatted);

  // Collect today's conversions by campaign
  var todayData = _getCampaignConversions(todayFormatted, todayFormatted);
  var lastWeekData = _getCampaignConversions(lastWeekFormatted, lastWeekFormatted);

  var alerts = [];

  // Compare each campaign
  for (var campaignName in lastWeekData) {
    // Apply name filters
    if (CONFIG.CAMPAIGN_NAME_CONTAINS !== "" &&
        campaignName.indexOf(CONFIG.CAMPAIGN_NAME_CONTAINS) === -1) {
      continue;
    }
    if (CONFIG.CAMPAIGN_NAME_EXCLUDES !== "" &&
        campaignName.indexOf(CONFIG.CAMPAIGN_NAME_EXCLUDES) !== -1) {
      continue;
    }

    var lastWeekConversions = lastWeekData[campaignName];
    var todayConversions = todayData[campaignName] || 0;

    // Skip low-volume campaigns
    if (lastWeekConversions < CONFIG.MIN_CONVERSIONS_LAST_WEEK) {
      continue;
    }

    // Skip zero-today if not configured to alert
    if (todayConversions === 0 && !CONFIG.INCLUDE_ZERO_TODAY) {
      continue;
    }

    // Calculate drop percentage
    var dropFraction = (lastWeekConversions - todayConversions) / lastWeekConversions;

    if (dropFraction >= CONFIG.DROP_THRESHOLD) {
      alerts.push({
        name: campaignName,
        today: todayConversions,
        lastWeek: lastWeekConversions,
        dropPercent: Math.round(dropFraction * 100)
      });
    }
  }

  // Send alert if drops detected
  if (alerts.length === 0) {
    Logger.log("No significant conversion drops detected.");
    return;
  }

  // Sort by severity (biggest drop first)
  alerts.sort(function(a, b) { return b.dropPercent - a.dropPercent; });

  var subject = "Conversion Drop Alert — " + alerts.length + " campaign(s) — " + todayFormatted;
  var body = "Conversion Drop Alert\n";
  body += "Comparing " + todayFormatted + " vs " + lastWeekFormatted + "\n";
  body += "Threshold: " + Math.round(CONFIG.DROP_THRESHOLD * 100) + "% drop\n\n";

  body += "=== CAMPAIGNS WITH CONVERSION DROPS ===\n\n";

  for (var i = 0; i < alerts.length; i++) {
    var a = alerts[i];
    body += "  " + a.name + "\n";
    body += "    Today: " + a.today + " | Last week: " + a.lastWeek;
    body += " | Drop: " + a.dropPercent + "%\n";

    if (a.today === 0) {
      body += "    *** ZERO conversions today — possible tracking breakage ***\n";
    }
    body += "\n";
  }

  body += "---\n";
  body += "Troubleshooting steps:\n";
  body += "1. Check GTM container for recent version changes\n";
  body += "2. Verify sGTM container is running and receiving events\n";
  body += "3. Check Google Ads conversion action status\n";
  body += "4. Review landing page for errors or consent banner changes\n";
  body += "\nGenerated by Conversion Drop Alert script.";

  MailApp.sendEmail({
    to: CONFIG.EMAIL_RECIPIENTS,
    subject: subject,
    body: body
  });

  Logger.log("Alert sent. " + alerts.length + " campaigns with conversion drops.");
}

/**
 * Fetches conversion data for all enabled campaigns in a date range.
 * Returns an object mapping campaign name to conversion count.
 */
function _getCampaignConversions(startDate, endDate) {
  var data = {};

  var report = AdsApp.report(
    "SELECT CampaignName, Conversions " +
    "FROM CAMPAIGN_PERFORMANCE_REPORT " +
    "WHERE CampaignStatus = ENABLED " +
    "DURING " + startDate.replace(/-/g, "") + "," + endDate.replace(/-/g, "")
  );

  var rows = report.rows();
  while (rows.hasNext()) {
    var row = rows.next();
    var name = row["CampaignName"];
    var conversions = parseFloat(row["Conversions"]) || 0;
    data[name] = conversions;
  }

  return data;
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

1. In Google Ads, go to **Tools → Bulk actions → Scripts**
2. Click **+ New script**
3. Name it `Conversion Drop Alert`
4. Paste the script above
5. Update `CONFIG.EMAIL_RECIPIENTS` with your actual email address(es)
6. Optionally set `CONFIG.CAMPAIGN_NAME_CONTAINS` to limit scope (e.g., `"Brand"` to only check brand campaigns)
7. Click **Preview** to test — check the Logger output for detected drops
8. Click **Authorize** when prompted
9. Set the schedule to **Daily** at a time after peak traffic (e.g., 21:00)
10. Click **Save**

> [!warning] Day-of-Week Patterns
> Some businesses have natural day-of-week variance (e.g., B2B drops on weekends). Comparing same-day-last-week handles this automatically. If you still get false positives, increase `MIN_CONVERSIONS_LAST_WEEK` or `DROP_THRESHOLD`.

## Customization Guide

### Adjusting Sensitivity

For high-volume accounts where a 30% drop is very significant:

```javascript
DROP_THRESHOLD: 0.20,           // Alert at 20% drop
MIN_CONVERSIONS_LAST_WEEK: 10,  // Only campaigns with 10+ conversions
```

For low-volume accounts where variance is normal:

```javascript
DROP_THRESHOLD: 0.50,           // Only alert at 50%+ drops
MIN_CONVERSIONS_LAST_WEEK: 3,   // Include smaller campaigns
```

### Comparing Against Longer Baselines

To compare against a 7-day average instead of a single day, replace `_getCampaignConversions` with a version that pulls `LAST_14_DAYS` and divides by 14. This smooths out daily variance but requires more careful date math.

### Adding Campaign-Level Detail

To include cost and click data alongside conversions, extend the report query:

```javascript
var report = AdsApp.report(
  "SELECT CampaignName, Conversions, Cost, Clicks " +
  "FROM CAMPAIGN_PERFORMANCE_REPORT " +
  "WHERE CampaignStatus = ENABLED " +
  "DURING " + startDate.replace(/-/g, "") + "," + endDate.replace(/-/g, "")
);
```

### Sending to Google Sheets Instead of Email

Replace the `MailApp.sendEmail` block with:

```javascript
var ss = SpreadsheetApp.openByUrl("YOUR_SHEET_URL");
var sheet = ss.getSheetByName("ConversionAlerts") || ss.insertSheet("ConversionAlerts");

for (var i = 0; i < alerts.length; i++) {
  var a = alerts[i];
  sheet.appendRow([todayFormatted, a.name, a.today, a.lastWeek, a.dropPercent + "%"]);
}
```

## Related

- [[catalog|Scripts Catalog]] — full index of all scripts
- [[budget-pacing-alert]] — complementary budget monitoring
- [[quality-score-monitor]] — tracks QS degradation over time
- [[../../platforms/google-ads/conversion-actions|Conversion Actions Reference]] — understand what conversion actions are being tracked
