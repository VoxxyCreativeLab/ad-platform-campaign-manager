---
title: "Zero Impression Keyword Cleaner"
date: 2026-03-31
tags:
  - reference
  - scripts
  - cleanup
---

# Zero Impression Keyword Cleaner

Identifies enabled keywords that have received zero impressions over a configurable lookback period (default 30 days). Zero-impression keywords clutter the account, make reporting harder, and signal structural issues (too restrictive match types, low search volume, or negative keyword conflicts).

**Schedule:** Monthly
**Runtime:** ~2–5 minutes

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `LOOKBACK_DAYS` | `30` | Number of days to check for impressions. Keywords with 0 impressions over this period are flagged. |
| `ACTION` | `"REPORT"` | What to do with zero-impression keywords. Options: `"REPORT"` (log only) or `"PAUSE"` (pause and log). |
| `SPREADSHEET_URL` | `""` | Google Sheets URL for output. Leave empty to create a new sheet. |
| `EMAIL_RECIPIENTS` | `""` | Comma-separated email addresses for notification. |
| `CAMPAIGN_NAME_CONTAINS` | `""` | Filter to specific campaigns. Empty = all. |
| `CAMPAIGN_NAME_DOES_NOT_CONTAIN` | `""` | Exclude campaigns matching this string. |
| `EXCLUDE_RECENTLY_ADDED_DAYS` | `14` | Skip keywords added within this many days (they haven't had a fair chance yet). |
| `LABEL_NAME` | `"Zero Impressions — Flagged"` | Label applied to flagged/paused keywords. |

## Script

```javascript
/**
 * Zero Impression Keyword Cleaner
 *
 * Finds enabled keywords with zero impressions over a configurable
 * lookback period. Can report only or pause the keywords.
 *
 * Schedule: Monthly
 */

// ============================================================
// CONFIGURATION — Edit these values
// ============================================================
var CONFIG = {
  LOOKBACK_DAYS: 30,
  ACTION: "REPORT",               // "REPORT" or "PAUSE"
  SPREADSHEET_URL: "",
  EMAIL_RECIPIENTS: "",
  CAMPAIGN_NAME_CONTAINS: "",
  CAMPAIGN_NAME_DOES_NOT_CONTAIN: "",
  EXCLUDE_RECENTLY_ADDED_DAYS: 14,
  LABEL_NAME: "Zero Impressions — Flagged"
};

function main() {
  var spreadsheet = getOrCreateSpreadsheet();
  var sheet = spreadsheet.getActiveSheet();
  setupSheet(sheet);

  // Calculate date range for lookback
  var today = new Date();
  var startDate = new Date(today.getTime() - (CONFIG.LOOKBACK_DAYS * 24 * 60 * 60 * 1000));
  var dateRange = formatDate(startDate) + "," + formatDate(today);

  // Calculate cutoff for recently added keywords
  var recentCutoff = new Date(today.getTime() - (CONFIG.EXCLUDE_RECENTLY_ADDED_DAYS * 24 * 60 * 60 * 1000));

  // Ensure the label exists if we're pausing
  if (CONFIG.ACTION === "PAUSE") {
    ensureLabelExists(CONFIG.LABEL_NAME);
  }

  // Build selector: enabled keywords with zero impressions in the lookback window
  var selector = AdsApp.keywords()
    .withCondition("Status = ENABLED")
    .withCondition("CampaignStatus = ENABLED")
    .withCondition("AdGroupStatus = ENABLED")
    .withCondition("Impressions = 0")
    .forDateRange(dateRange);

  if (CONFIG.CAMPAIGN_NAME_CONTAINS) {
    selector = selector.withCondition("CampaignName CONTAINS '" + CONFIG.CAMPAIGN_NAME_CONTAINS + "'");
  }
  if (CONFIG.CAMPAIGN_NAME_DOES_NOT_CONTAIN) {
    selector = selector.withCondition("CampaignName DOES_NOT_CONTAIN '" + CONFIG.CAMPAIGN_NAME_DOES_NOT_CONTAIN + "'");
  }

  var iterator = selector.get();
  var flaggedKeywords = [];

  while (iterator.hasNext()) {
    var kw = iterator.next();

    // Skip recently added keywords
    var creationDate = parseAdWordsDate(kw.getStatsFor("ALL_TIME"));
    // Fallback: use ALL_TIME impressions to determine if truly dormant
    var allTimeStats = kw.getStatsFor("ALL_TIME");

    var keywordInfo = {
      text: kw.getText(),
      matchType: kw.getMatchType(),
      campaignName: kw.getCampaign().getName(),
      adGroupName: kw.getAdGroup().getName(),
      allTimeImpressions: allTimeStats.getImpressions(),
      allTimeClicks: allTimeStats.getClicks(),
      qualityScore: kw.getQualityScore() || "—",
      firstPageCpc: formatBid(kw.getFirstPageCpc()),
      action: "REPORTED"
    };

    if (CONFIG.ACTION === "PAUSE") {
      kw.pause();
      kw.applyLabel(CONFIG.LABEL_NAME);
      keywordInfo.action = "PAUSED";
    }

    flaggedKeywords.push(keywordInfo);
  }

  // Write results
  writeResults(sheet, flaggedKeywords);

  Logger.log("Found " + flaggedKeywords.length + " zero-impression keywords (" + CONFIG.ACTION + " mode).");

  // Email notification
  if (CONFIG.EMAIL_RECIPIENTS && flaggedKeywords.length > 0) {
    var actionVerb = CONFIG.ACTION === "PAUSE" ? "paused" : "flagged";
    MailApp.sendEmail({
      to: CONFIG.EMAIL_RECIPIENTS,
      subject: "Zero Impression Keywords: " + flaggedKeywords.length + " " + actionVerb,
      body: flaggedKeywords.length + " keywords with zero impressions over the last " +
            CONFIG.LOOKBACK_DAYS + " days were " + actionVerb + ".\n\n" +
            "View the full report: " + spreadsheet.getUrl()
    });
  }
}

/**
 * Formats a bid value, handling null/undefined.
 */
function formatBid(bid) {
  if (bid === null || bid === undefined) return "—";
  return bid.toFixed(2);
}

/**
 * Formats a Date object as YYYYMMDD for AdsApp date ranges.
 */
function formatDate(date) {
  var year = date.getFullYear();
  var month = ("0" + (date.getMonth() + 1)).slice(-2);
  var day = ("0" + date.getDate()).slice(-2);
  return year + month + day;
}

/**
 * Creates the label if it doesn't already exist.
 */
function ensureLabelExists(labelName) {
  var labels = AdsApp.labels().withCondition("Name = '" + labelName + "'").get();
  if (!labels.hasNext()) {
    AdsApp.createLabel(labelName, "Keywords with zero impressions flagged by script", "#FFAA00");
  }
}

/**
 * Creates or opens the output spreadsheet.
 */
function getOrCreateSpreadsheet() {
  if (CONFIG.SPREADSHEET_URL) {
    return SpreadsheetApp.openByUrl(CONFIG.SPREADSHEET_URL);
  }
  var ss = SpreadsheetApp.create("Zero Impression Keywords — " + Utilities.formatDate(new Date(), "GMT", "yyyy-MM-dd"));
  Logger.log("Created new spreadsheet: " + ss.getUrl());
  return ss;
}

/**
 * Sets up the sheet header row.
 */
function setupSheet(sheet) {
  sheet.clear();
  sheet.appendRow([
    "Action",
    "Keyword",
    "Match Type",
    "Campaign",
    "Ad Group",
    "Quality Score",
    "First Page CPC",
    "All-Time Impressions",
    "All-Time Clicks"
  ]);
  sheet.getRange("1:1").setFontWeight("bold");
}

/**
 * Writes flagged keyword results to the sheet.
 */
function writeResults(sheet, keywords) {
  if (keywords.length === 0) {
    sheet.appendRow(["No zero-impression keywords found in the lookback period."]);
    return;
  }

  for (var i = 0; i < keywords.length; i++) {
    var kw = keywords[i];
    sheet.appendRow([
      kw.action,
      kw.text,
      kw.matchType,
      kw.campaignName,
      kw.adGroupName,
      kw.qualityScore,
      kw.firstPageCpc,
      kw.allTimeImpressions,
      kw.allTimeClicks
    ]);
  }
}
```

## Setup Instructions

1. **Create the script:** Google Ads → Tools & Settings → Bulk Actions → Scripts → New Script
2. **Paste the code** and update the `CONFIG` object
3. **Authorize** when prompted
4. **Run in REPORT mode first** (`ACTION: "REPORT"`) — review the sheet before enabling pausing
5. **Set `ACTION` to `"PAUSE"`** once satisfied with the preview
6. **Schedule** to run monthly

> [!warning] Pause Mode
> When `ACTION` is `"PAUSE"`, this script pauses keywords. Always run in `"REPORT"` mode first. Keywords can be re-enabled by filtering on the label in the Google Ads UI.

## Customization Guide

### Extend the lookback period

Increase `LOOKBACK_DAYS` to `60` or `90` to be more conservative. A 30-day window may miss seasonal keywords that only get traffic in certain months.

### Protect new keywords

`EXCLUDE_RECENTLY_ADDED_DAYS` defaults to `14` to avoid flagging keywords that were just added. Increase to `30` for accounts where new keywords take longer to ramp up.

### Diagnosing zero-impression keywords

The output includes Quality Score and First Page CPC to help diagnose *why* a keyword has no impressions:

| QS | First Page CPC | Likely Cause |
|----|----------------|--------------|
| — (no QS) | High | Low search volume or keyword not yet evaluated |
| 1–3 | High | Poor ad/landing page relevance; bid too low for first page |
| 5+ | Low | Likely blocked by a negative keyword or another keyword in the account |

### Pause vs. remove

This script pauses rather than removes keywords. This preserves the keyword history and lets you re-enable later. If you want to do a harder cleanup, manually remove paused keywords after reviewing the report.

> [!tip] Check for Negative Conflicts First
> Before pausing zero-impression keywords, run the [[negative-keyword-conflict-checker|Negative Keyword Conflict Checker]] to see if negatives are blocking them. Removing the blocking negative may be a better fix than pausing the keyword.

## Related Reference

- [[catalog|Scripts Catalog]] — full index of available scripts
- [[negative-keyword-conflict-checker|Negative Keyword Conflict Checker]] — check if negatives are the cause
- [[ads-scripts-api|Google Ads Scripts API Reference]] — API quick reference
