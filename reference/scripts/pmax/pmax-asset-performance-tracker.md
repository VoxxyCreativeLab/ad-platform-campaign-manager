---
title: "PMax Asset Performance Tracker"
date: 2026-03-31
tags:
  - reference
  - scripts
  - pmax
---

# PMax Asset Performance Tracker

Tracks Performance Max asset performance ratings over time and exports to Google Sheets. PMax assigns each asset a performance rating (Low, Good, Best, or Learning) but the Google Ads UI only shows the current rating — not how it changed over time. This script snapshots ratings weekly so you can spot trends and replace underperforming assets before they drag down campaign performance.

**Source pattern:** agencysavvy/pmax
**Schedule:** Weekly
**Runtime:** ~2–5 minutes

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `SPREADSHEET_URL` | `""` | Google Sheets URL for output. **Required** — create a sheet first for historical tracking. |
| `SHEET_NAME` | `"Asset Performance"` | Tab name within the spreadsheet. |
| `CAMPAIGN_NAME_CONTAINS` | `""` | Filter to PMax campaigns matching this string. Empty = all PMax campaigns. |
| `INCLUDE_LEARNING` | `true` | Include assets still in "Learning" status. |
| `EMAIL_RECIPIENTS` | `""` | Comma-separated email addresses for alerts on low-performing assets. |
| `ALERT_ON_LOW` | `true` | Send email only when assets with "Low" rating are found. |

## Script

```javascript
/**
 * PMax Asset Performance Tracker
 *
 * Snapshots Performance Max asset performance ratings to a Google Sheet.
 * Tracks how ratings change over time so you can replace underperforming
 * assets proactively.
 *
 * Source pattern: agencysavvy/pmax
 * Schedule: Weekly
 */

// ============================================================
// CONFIGURATION — Edit these values
// ============================================================
var CONFIG = {
  SPREADSHEET_URL: "",
  SHEET_NAME: "Asset Performance",
  CAMPAIGN_NAME_CONTAINS: "",
  INCLUDE_LEARNING: true,
  EMAIL_RECIPIENTS: "",
  ALERT_ON_LOW: true
};

function main() {
  if (!CONFIG.SPREADSHEET_URL) {
    Logger.log("ERROR: SPREADSHEET_URL is required. Create a Google Sheet and paste the URL.");
    return;
  }

  var spreadsheet = SpreadsheetApp.openByUrl(CONFIG.SPREADSHEET_URL);
  var sheet = getOrCreateSheet(spreadsheet, CONFIG.SHEET_NAME);

  // Set up header if the sheet is new
  if (sheet.getLastRow() === 0) {
    setupSheet(sheet);
  }

  var today = Utilities.formatDate(new Date(), "GMT", "yyyy-MM-dd");

  // GAQL query for asset group assets with performance ratings
  var query =
    "SELECT " +
    "  campaign.name, " +
    "  campaign.id, " +
    "  asset_group.name, " +
    "  asset_group.id, " +
    "  asset_group_asset.asset, " +
    "  asset_group_asset.field_type, " +
    "  asset_group_asset.performance_label, " +
    "  asset_group_asset.status, " +
    "  asset.name, " +
    "  asset.type, " +
    "  asset.text_asset.text, " +
    "  asset.image_asset.full_size.url, " +
    "  asset.youtube_video_asset.youtube_video_id " +
    "FROM asset_group_asset " +
    "WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX' " +
    "  AND asset_group_asset.status != 'REMOVED'";

  if (CONFIG.CAMPAIGN_NAME_CONTAINS) {
    query += " AND campaign.name LIKE '%" + CONFIG.CAMPAIGN_NAME_CONTAINS + "%'";
  }

  if (!CONFIG.INCLUDE_LEARNING) {
    query += " AND asset_group_asset.performance_label != 'LEARNING'";
  }

  // Execute query
  var results;
  try {
    results = AdsApp.search(query);
  } catch (e) {
    Logger.log("Error running GAQL query: " + e.message);
    return;
  }

  var rows = [];
  var lowPerformingAssets = [];

  while (results.hasNext()) {
    var row = results.next();

    var assetContent = getAssetContent(row);
    var perfLabel = row.assetGroupAsset.performanceLabel || "UNSPECIFIED";

    var assetRow = {
      date: today,
      campaignName: row.campaign.name,
      campaignId: row.campaign.id,
      assetGroupName: row.assetGroup.name,
      assetGroupId: row.assetGroup.id,
      assetType: row.asset.type || "UNKNOWN",
      fieldType: row.assetGroupAsset.fieldType || "UNKNOWN",
      assetContent: assetContent,
      performanceLabel: perfLabel,
      status: row.assetGroupAsset.status
    };

    rows.push(assetRow);

    if (perfLabel === "LOW") {
      lowPerformingAssets.push(assetRow);
    }
  }

  // Write rows to sheet
  writeRows(sheet, rows);

  Logger.log("Tracked " + rows.length + " assets. " + lowPerformingAssets.length + " rated LOW.");

  // Email alert for low-performing assets
  if (CONFIG.EMAIL_RECIPIENTS && CONFIG.ALERT_ON_LOW && lowPerformingAssets.length > 0) {
    var lowList = lowPerformingAssets.map(function(a) {
      return "  - [" + a.fieldType + "] " + a.assetContent.substring(0, 60) +
             " (Campaign: " + a.campaignName + ", Group: " + a.assetGroupName + ")";
    }).join("\n");

    MailApp.sendEmail({
      to: CONFIG.EMAIL_RECIPIENTS,
      subject: "PMax Low-Performing Assets: " + lowPerformingAssets.length + " found",
      body: lowPerformingAssets.length + " assets are rated LOW in your PMax campaigns.\n\n" +
            "Low-performing assets:\n" + lowList + "\n\n" +
            "Consider replacing these assets with new variations.\n\n" +
            "Full report: " + spreadsheet.getUrl()
    });
  }
}

/**
 * Extracts a human-readable content string from an asset row.
 */
function getAssetContent(row) {
  // Text assets (headlines, descriptions)
  if (row.asset.textAsset && row.asset.textAsset.text) {
    return row.asset.textAsset.text;
  }
  // Image assets
  if (row.asset.imageAsset && row.asset.imageAsset.fullSize && row.asset.imageAsset.fullSize.url) {
    return row.asset.imageAsset.fullSize.url;
  }
  // YouTube video assets
  if (row.asset.youtubeVideoAsset && row.asset.youtubeVideoAsset.youtubeVideoId) {
    return "youtube.com/watch?v=" + row.asset.youtubeVideoAsset.youtubeVideoId;
  }
  // Asset name fallback
  if (row.asset.name) {
    return row.asset.name;
  }
  return "(unknown content)";
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
    "Snapshot Date",
    "Campaign",
    "Campaign ID",
    "Asset Group",
    "Asset Group ID",
    "Asset Type",
    "Field Type",
    "Asset Content",
    "Performance Rating",
    "Status"
  ]);
  sheet.getRange("1:1").setFontWeight("bold");
  sheet.setFrozenRows(1);
}

/**
 * Appends data rows to the sheet.
 */
function writeRows(sheet, rows) {
  if (rows.length === 0) {
    Logger.log("No PMax assets found matching criteria.");
    return;
  }

  for (var i = 0; i < rows.length; i++) {
    var r = rows[i];
    sheet.appendRow([
      r.date,
      r.campaignName,
      r.campaignId,
      r.assetGroupName,
      r.assetGroupId,
      r.assetType,
      r.fieldType,
      r.assetContent,
      r.performanceLabel,
      r.status
    ]);
  }
}
```

## Setup Instructions

1. **Create a Google Sheet** — the script needs a persistent sheet to build historical data
2. **Copy the Sheet URL** and paste it into `SPREADSHEET_URL`
3. **Create the script:** Google Ads → Tools & Settings → Bulk Actions → Scripts → New Script
4. **Paste the code** and update the `CONFIG` object
5. **Authorize** when prompted
6. **Preview** first to verify asset data is being read correctly
7. **Schedule** to run weekly

> [!info] Performance Rating Lifecycle
> New assets start with `LEARNING` and transition to `LOW`, `GOOD`, or `BEST` after enough data. This typically takes 1–2 weeks. The script captures these transitions over time so you can see how ratings evolve.

## Customization Guide

### Performance rating meanings

| Rating | Meaning | Action |
|--------|---------|--------|
| `LEARNING` | Not enough data yet. | Wait 1–2 weeks. |
| `LOW` | Underperforming compared to other assets in the group. | Replace with a new variation. |
| `GOOD` | Average performance. | Keep, but consider testing alternatives. |
| `BEST` | Top performer in the group. | Keep. Create similar variations. |

### Building historical trends

Run the script weekly with the same spreadsheet. Each run appends new rows with the snapshot date. Build a pivot table in Sheets:

- **Rows:** Asset Content
- **Columns:** Snapshot Date
- **Values:** Performance Rating

This shows you how each asset's rating changes over time.

### Alert only on LOW

Set `ALERT_ON_LOW` to `true` (default) to receive email only when at least one asset is rated LOW. This avoids email noise on weeks where everything is performing well.

### Filter assets still learning

Set `INCLUDE_LEARNING` to `false` to exclude assets that haven't been rated yet. Useful if you want a cleaner view of only evaluated assets.

### What to do with LOW assets

1. **Don't remove immediately** — assets need a few weeks to stabilize
2. **Create replacement variations** that test different angles (different headlines, different images)
3. **Check asset group health** — you need minimum 3 headlines, 1 long headline, 2 descriptions, and 1 image per group
4. **Review by field type** — a LOW headline matters more than a LOW image for Search placements

> [!warning] Read-Only Script
> This script **never modifies** assets. It only reads performance data and logs it. You decide when and how to replace underperforming assets.

## Related Reference

- [[catalog|Scripts Catalog]] — full index of available scripts
- [[asset-requirements|PMax Asset Requirements]] — minimum and recommended asset counts
- [[pmax-metrics|PMax Metrics]] — understanding PMax performance data
- [[pmax-search-terms-extractor|PMax Search Terms Extractor]] — extract search term categories
