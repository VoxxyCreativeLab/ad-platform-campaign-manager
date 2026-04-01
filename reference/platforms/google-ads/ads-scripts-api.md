---
title: Google Ads Scripts — API Quick Reference
date: 2026-04-01
tags:
  - reference
  - google-ads
---

# Google Ads Scripts — API Quick Reference

## What Are Google Ads Scripts?

JavaScript code that runs inside Google Ads to automate tasks. Scripts have direct access to your Google Ads data and can make changes, send emails, read spreadsheets, and more.

## Where to Create Scripts

Google Ads → Tools → Bulk actions → Scripts → New script

## Runtime Environment

- **Language:** JavaScript (ES5-like with some ES6)
- **Execution limit:** 30 minutes per run
- **Scheduling:** Hourly, daily, weekly, monthly
- **Output:** Logger (console), email, Google Sheets
- **Access:** Full read/write to the Google Ads account

## Core Objects

### AdsApp
Top-level object for accessing account data.

```javascript
// Campaigns
var campaigns = AdsApp.campaigns()
  .withCondition("Status = ENABLED")
  .orderBy("Impressions DESC")
  .forDateRange("LAST_30_DAYS")
  .get();

while (campaigns.hasNext()) {
  var campaign = campaigns.next();
  Logger.log(campaign.getName());
  Logger.log(campaign.getStatsFor("LAST_30_DAYS").getImpressions());
}

// Ad Groups
var adGroups = AdsApp.adGroups()
  .withCondition("CampaignName = 'My Campaign'")
  .get();

// Keywords
var keywords = AdsApp.keywords()
  .withCondition("Impressions > 100")
  .forDateRange("LAST_7_DAYS")
  .get();

// Ads
var ads = AdsApp.ads()
  .withCondition("Type = RESPONSIVE_SEARCH_AD")
  .get();
```

### Selectors & Iterators

All entity collections use the selector/iterator pattern:

```javascript
var selector = AdsApp.keywords()
  .withCondition("Status = ENABLED")
  .withCondition("QualityScore < 5")
  .orderBy("Impressions DESC")
  .withLimit(50)
  .forDateRange("LAST_30_DAYS");

var iterator = selector.get();
while (iterator.hasNext()) {
  var keyword = iterator.next();
  // Process keyword
}
```

### Common Conditions
```javascript
// Status
.withCondition("Status = ENABLED")
.withCondition("CampaignStatus = ENABLED")

// Metrics
.withCondition("Impressions > 100")
.withCondition("Ctr < 0.02")
.withCondition("Cost > 50")
.withCondition("Conversions > 0")

// Properties
.withCondition("CampaignName CONTAINS 'Brand'")
.withCondition("Name STARTS_WITH 'Product'")
.withCondition("QualityScore < 5")
```

> [!info] `.withCondition()` accepts both AWQL field names (`CampaignName`, `Impressions`) and GAQL names (`campaign.name`, `metrics.impressions`) — AWQL names still work via auto-translation, but GAQL names are the modern standard for new code.

### Stats Object
```javascript
var stats = entity.getStatsFor("LAST_30_DAYS");
stats.getImpressions();
stats.getClicks();
stats.getCtr();
stats.getCost();
stats.getConversions();
stats.getConversionRate();
stats.getAverageCpc();
stats.getAverageCpm();
```

## Common Operations

### Pause/Enable Entities
```javascript
keyword.pause();
keyword.enable();
adGroup.pause();
campaign.pause();
```

### Add Negative Keywords
```javascript
// Ad group level
adGroup.createNegativeKeyword("[exact negative]");
adGroup.createNegativeKeyword("broad negative");

// Campaign level
campaign.createNegativeKeyword('"phrase negative"');
```

### Change Bids
```javascript
keyword.bidding().setCpc(1.50);  // Set to €1.50
adGroup.bidding().setCpc(2.00);
```

## External Services

### Google Sheets
```javascript
var spreadsheet = SpreadsheetApp.openByUrl("https://docs.google.com/spreadsheets/d/...");
var sheet = spreadsheet.getActiveSheet();

// Read
var data = sheet.getDataRange().getValues();

// Write
sheet.appendRow(["Campaign", "Clicks", "Cost"]);
sheet.getRange("A1").setValue("Hello");
```

### Email
```javascript
MailApp.sendEmail({
  to: "you@example.com",
  subject: "Google Ads Alert",
  body: "Campaign X exceeded budget"
});
```

### URL Fetch (HTTP requests)
```javascript
var response = UrlFetchApp.fetch("https://api.example.com/data");
var json = JSON.parse(response.getContentText());
```

### BigQuery
```javascript
var results = BigQuery.Jobs.query({
  query: "SELECT * FROM dataset.table LIMIT 10",
  useLegacySql: false
}, "project-id");
```

## Reporting API (GAQL)

Use `AdsApp.search()` with Google Ads Query Language (GAQL). This replaces the legacy `AdsApp.report()` with AWQL.

```javascript
var results = AdsApp.search(
  "SELECT campaign.name, metrics.impressions, metrics.clicks, metrics.cost_micros " +
  "FROM campaign " +
  "WHERE metrics.impressions > 0 " +
  "AND segments.date DURING LAST_30_DAYS"
);

while (results.hasNext()) {
  var row = results.next();
  Logger.log(row.campaign.name + ": " + row.metrics.clicks + " clicks");
}
```

### Legacy Reporting (AWQL — deprecated)

`AdsApp.report()` with AWQL still works via auto-translation but is deprecated. Migrate to `AdsApp.search()` with GAQL for new scripts.

```javascript
// Legacy — still functional but deprecated
var report = AdsApp.report(
  "SELECT CampaignName, Impressions, Clicks, Cost " +
  "FROM CAMPAIGN_PERFORMANCE_REPORT " +
  "WHERE Impressions > 0 " +
  "DURING LAST_30_DAYS"
);

var rows = report.rows();
while (rows.hasNext()) {
  var row = rows.next();
  Logger.log(row["CampaignName"] + ": " + row["Clicks"] + " clicks");
}

// Export to Sheets (only available with AdsApp.report)
report.exportToSheet(sheet);
```

## Script Template

```javascript
function main() {
  // Configuration
  var CONFIG = {
    SPREADSHEET_URL: "https://docs.google.com/spreadsheets/d/...",
    EMAIL: "you@example.com",
    DATE_RANGE: "LAST_7_DAYS"
  };

  // Your logic here

  Logger.log("Script completed successfully");
}
```

## Limits

- 30-minute execution time
- 250,000 entity *reads* per execution (via selectors/iterators)
- ~10,000 entity *mutations* (get/mutate operations for writes) per execution
- 20,000 UrlFetchApp calls per day (across all script executions in the account)
- 100 email recipients per day
- Scripts can only access the account they're created in (or MCC child accounts)
