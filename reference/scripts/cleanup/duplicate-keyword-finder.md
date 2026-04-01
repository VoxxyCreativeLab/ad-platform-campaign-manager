---
title: "Duplicate Keyword Finder"
date: 2026-03-31
tags:
  - reference
  - scripts
  - cleanup
---

# Duplicate Keyword Finder

Finds duplicate keywords across ad groups and campaigns. Duplicate keywords compete against each other in the auction, inflating CPCs and fragmenting quality score data. This script identifies exact duplicates and cross-match-type duplicates so you can consolidate.

**Schedule:** Monthly
**Runtime:** ~5–15 minutes depending on account size

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `SPREADSHEET_URL` | `""` | Google Sheets URL for output. Leave empty to create a new sheet. |
| `EMAIL_RECIPIENTS` | `""` | Comma-separated email addresses for notification. |
| `CAMPAIGN_NAME_CONTAINS` | `""` | Filter to campaigns matching this string. Empty = all. |
| `CAMPAIGN_NAME_DOES_NOT_CONTAIN` | `""` | Exclude campaigns matching this string. |
| `CHECK_CROSS_MATCH_TYPE` | `true` | Flag keywords with same text but different match types as duplicates. |
| `CHECK_CROSS_CAMPAIGN` | `true` | Check for duplicates across campaigns (not just within a campaign). |
| `INCLUDE_PAUSED` | `false` | Include paused keywords in the duplicate check. |
| `MIN_IMPRESSIONS` | `0` | Only flag duplicates where at least one instance has this many impressions. |

## Script

```javascript
/**
 * Duplicate Keyword Finder
 *
 * Scans the account for keywords that appear in multiple ad groups
 * or campaigns. Flags exact text duplicates and optionally cross-match-type
 * duplicates (e.g., "running shoes" as broad and exact in different ad groups).
 *
 * Schedule: Monthly
 */

// ============================================================
// CONFIGURATION — Edit these values
// ============================================================
var CONFIG = {
  SPREADSHEET_URL: "",
  EMAIL_RECIPIENTS: "",
  CAMPAIGN_NAME_CONTAINS: "",
  CAMPAIGN_NAME_DOES_NOT_CONTAIN: "",
  CHECK_CROSS_MATCH_TYPE: true,
  CHECK_CROSS_CAMPAIGN: true,
  INCLUDE_PAUSED: false,
  MIN_IMPRESSIONS: 0
};

var DATE_RANGE = "LAST_30_DAYS";

function main() {
  var spreadsheet = getOrCreateSpreadsheet();
  var sheet = spreadsheet.getActiveSheet();
  setupSheet(sheet);

  // Build keyword map: normalized text → array of keyword info objects
  var keywordMap = {};
  var selector = buildSelector();
  var iterator = selector.get();
  var totalKeywords = 0;

  while (iterator.hasNext()) {
    var kw = iterator.next();
    totalKeywords++;

    var text = kw.getText().toLowerCase().trim();
    var matchType = kw.getMatchType();
    var stats = kw.getStatsFor(DATE_RANGE);

    // Normalize the key based on settings
    var key = CONFIG.CHECK_CROSS_MATCH_TYPE ? text : text + "||" + matchType;

    if (!keywordMap[key]) {
      keywordMap[key] = [];
    }

    keywordMap[key].push({
      text: kw.getText(),
      matchType: matchType,
      campaignName: kw.getCampaign().getName(),
      adGroupName: kw.getAdGroup().getName(),
      status: kw.isEnabled() ? "Enabled" : "Paused",
      impressions: stats.getImpressions(),
      clicks: stats.getClicks(),
      cost: stats.getCost(),
      conversions: stats.getConversions(),
      qualityScore: kw.getQualityScore() || "—"
    });
  }

  Logger.log("Scanned " + totalKeywords + " keywords.");

  // Find duplicates (keys with more than one entry)
  var duplicateGroups = [];
  var duplicateCount = 0;

  for (var key in keywordMap) {
    var entries = keywordMap[key];
    if (entries.length < 2) continue;

    // If not checking cross-campaign, filter to only same-campaign duplicates
    if (!CONFIG.CHECK_CROSS_CAMPAIGN) {
      var byCampaign = {};
      for (var i = 0; i < entries.length; i++) {
        var camp = entries[i].campaignName;
        if (!byCampaign[camp]) byCampaign[camp] = [];
        byCampaign[camp].push(entries[i]);
      }
      for (var campName in byCampaign) {
        if (byCampaign[campName].length >= 2) {
          // Check min impressions filter
          if (meetsImpressionThreshold(byCampaign[campName])) {
            duplicateGroups.push(byCampaign[campName]);
            duplicateCount += byCampaign[campName].length;
          }
        }
      }
    } else {
      if (meetsImpressionThreshold(entries)) {
        duplicateGroups.push(entries);
        duplicateCount += entries.length;
      }
    }
  }

  // Write results
  writeResults(sheet, duplicateGroups);
  Logger.log("Found " + duplicateGroups.length + " duplicate groups (" + duplicateCount + " total keywords).");

  // Send email notification
  if (CONFIG.EMAIL_RECIPIENTS && duplicateGroups.length > 0) {
    MailApp.sendEmail({
      to: CONFIG.EMAIL_RECIPIENTS,
      subject: "Duplicate Keywords Found: " + duplicateGroups.length + " groups",
      body: "Found " + duplicateGroups.length + " duplicate keyword groups " +
            "(" + duplicateCount + " keywords total).\n\n" +
            "View the full report: " + spreadsheet.getUrl()
    });
  }
}

/**
 * Checks if at least one keyword in the group meets the min impressions threshold.
 */
function meetsImpressionThreshold(entries) {
  if (CONFIG.MIN_IMPRESSIONS === 0) return true;
  for (var i = 0; i < entries.length; i++) {
    if (entries[i].impressions >= CONFIG.MIN_IMPRESSIONS) return true;
  }
  return false;
}

/**
 * Builds the keyword selector with configured filters.
 */
function buildSelector() {
  var selector = AdsApp.keywords()
    .withCondition("CampaignStatus = ENABLED")
    .withCondition("AdGroupStatus = ENABLED");

  if (!CONFIG.INCLUDE_PAUSED) {
    selector = selector.withCondition("Status = ENABLED");
  }
  if (CONFIG.CAMPAIGN_NAME_CONTAINS) {
    selector = selector.withCondition("CampaignName CONTAINS '" + CONFIG.CAMPAIGN_NAME_CONTAINS + "'");
  }
  if (CONFIG.CAMPAIGN_NAME_DOES_NOT_CONTAIN) {
    selector = selector.withCondition("CampaignName DOES_NOT_CONTAIN '" + CONFIG.CAMPAIGN_NAME_DOES_NOT_CONTAIN + "'");
  }

  return selector.forDateRange(DATE_RANGE);
}

/**
 * Creates or opens the output spreadsheet.
 */
function getOrCreateSpreadsheet() {
  if (CONFIG.SPREADSHEET_URL) {
    return SpreadsheetApp.openByUrl(CONFIG.SPREADSHEET_URL);
  }
  var ss = SpreadsheetApp.create("Duplicate Keywords — " + Utilities.formatDate(new Date(), "GMT", "yyyy-MM-dd"));
  Logger.log("Created new spreadsheet: " + ss.getUrl());
  return ss;
}

/**
 * Sets up the sheet header row.
 */
function setupSheet(sheet) {
  sheet.clear();
  sheet.appendRow([
    "Duplicate Group",
    "Keyword",
    "Match Type",
    "Campaign",
    "Ad Group",
    "Status",
    "Impressions",
    "Clicks",
    "Cost",
    "Conversions",
    "Quality Score"
  ]);
  sheet.getRange("1:1").setFontWeight("bold");
}

/**
 * Writes duplicate groups to the sheet. Groups are separated by a blank row
 * and numbered for easy identification.
 */
function writeResults(sheet, duplicateGroups) {
  if (duplicateGroups.length === 0) {
    sheet.appendRow(["No duplicates found."]);
    return;
  }

  for (var g = 0; g < duplicateGroups.length; g++) {
    var group = duplicateGroups[g];

    // Sort within group: most impressions first (likely the "keeper")
    group.sort(function(a, b) { return b.impressions - a.impressions; });

    for (var i = 0; i < group.length; i++) {
      var kw = group[i];
      sheet.appendRow([
        "Group " + (g + 1),
        kw.text,
        kw.matchType,
        kw.campaignName,
        kw.adGroupName,
        kw.status,
        kw.impressions,
        kw.clicks,
        kw.cost.toFixed(2),
        kw.conversions,
        kw.qualityScore
      ]);
    }

    // Blank separator row between groups
    sheet.appendRow([]);
  }
}
```

## Setup Instructions

1. **Create the script:** Google Ads → Tools & Settings → Bulk Actions → Scripts → New Script
2. **Paste the code** and update the `CONFIG` object at the top
3. **Authorize** when prompted (needs Sheets access)
4. **Preview** first to review the output — this script never modifies keywords
5. **Schedule** to run monthly

> [!tip] Resolving Duplicates
> The output sheet sorts each duplicate group by impressions (highest first). The top entry in each group is usually the "keeper" — it has the most data. Pause or remove the others and let the keeper accumulate all the quality score signals.

## Customization Guide

### Same-campaign duplicates only

Set `CHECK_CROSS_CAMPAIGN` to `false`. The script will only flag keywords that are duplicated within the same campaign (across different ad groups). This is the most common cleanup scenario.

### Strict match type checking

Set `CHECK_CROSS_MATCH_TYPE` to `false`. The script will only flag keywords with identical text AND identical match type. Use this when you intentionally run broad + exact match strategies for the same keyword.

### Include paused keywords

Set `INCLUDE_PAUSED` to `true` to catch cases where a keyword is active in one ad group but paused in another. Useful for cleaning up old paused keywords that clutter the account.

### Filter by minimum impressions

Set `MIN_IMPRESSIONS` to a threshold (e.g., `50`) to only flag duplicate groups where at least one instance has meaningful traffic. This helps ignore brand-new or irrelevant duplicates.

> [!warning] Read-Only Script
> This script **never modifies** keywords. It reports duplicates so you can decide which to keep, pause, or remove.

## Related Reference

- [[catalog|Scripts Catalog]] — full index of available scripts
- [[account-structure|Account Structure]] — best practices for campaign/ad group organization
- [[ads-scripts-api|Google Ads Scripts API Reference]] — API quick reference
