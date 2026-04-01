---
title: "Low Quality Score Keyword Pauser"
date: 2026-03-31
tags:
  - reference
  - scripts
  - cleanup
---

# Low Quality Score Keyword Pauser

Pauses keywords with a Quality Score below a configurable threshold, but only after they have accumulated enough impressions to make the score statistically meaningful. Prevents wasting spend on keywords that Google considers poor matches for their search queries and landing pages.

**Schedule:** Weekly
**Runtime:** ~2–5 minutes

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `QS_THRESHOLD` | `3` | Pause keywords with Quality Score at or below this value (1–10 scale). |
| `MIN_IMPRESSIONS` | `100` | Minimum impressions before the script considers pausing. Prevents pausing keywords that haven't had a fair chance. |
| `DATE_RANGE` | `"ALL_TIME"` | Date range for the impressions check. Use `"ALL_TIME"` for lifetime or `"LAST_30_DAYS"` for recent. |
| `SPREADSHEET_URL` | `""` | Google Sheets URL to log paused keywords. Leave empty to create a new sheet. |
| `EMAIL_RECIPIENTS` | `""` | Comma-separated email addresses for notification. |
| `CAMPAIGN_NAME_CONTAINS` | `""` | Filter to specific campaigns. Empty = all. |
| `DRY_RUN` | `true` | When `true`, only reports — does not actually pause keywords. **Set to `false` to enable pausing.** |
| `LABEL_NAME` | `"Low QS — Paused by Script"` | Label applied to paused keywords for easy filtering in the UI. |

## Script

```javascript
/**
 * Low Quality Score Keyword Pauser
 *
 * Identifies and pauses keywords with Quality Score below a threshold
 * after they've received a minimum number of impressions. Logs all
 * actions to a Google Sheet.
 *
 * IMPORTANT: Runs in DRY_RUN mode by default. Set DRY_RUN to false
 * after reviewing the preview output.
 *
 * Schedule: Weekly
 */

// ============================================================
// CONFIGURATION — Edit these values
// ============================================================
var CONFIG = {
  QS_THRESHOLD: 3,
  MIN_IMPRESSIONS: 100,
  DATE_RANGE: "ALL_TIME",
  SPREADSHEET_URL: "",
  EMAIL_RECIPIENTS: "",
  CAMPAIGN_NAME_CONTAINS: "",
  DRY_RUN: true,
  LABEL_NAME: "Low QS — Paused by Script"
};

function main() {
  var spreadsheet = getOrCreateSpreadsheet();
  var sheet = spreadsheet.getActiveSheet();
  setupSheet(sheet);

  // Ensure the label exists
  if (!CONFIG.DRY_RUN) {
    ensureLabelExists(CONFIG.LABEL_NAME);
  }

  // Find low QS keywords with sufficient impressions
  var selector = AdsApp.keywords()
    .withCondition("Status = ENABLED")
    .withCondition("CampaignStatus = ENABLED")
    .withCondition("AdGroupStatus = ENABLED")
    .withCondition("QualityScore <= " + CONFIG.QS_THRESHOLD)
    .withCondition("Impressions >= " + CONFIG.MIN_IMPRESSIONS)
    .forDateRange(CONFIG.DATE_RANGE)
    .orderBy("QualityScore ASC");

  if (CONFIG.CAMPAIGN_NAME_CONTAINS) {
    selector = selector.withCondition("CampaignName CONTAINS '" + CONFIG.CAMPAIGN_NAME_CONTAINS + "'");
  }

  var iterator = selector.get();
  var pausedKeywords = [];
  var totalFound = 0;

  while (iterator.hasNext()) {
    var kw = iterator.next();
    totalFound++;

    var stats = kw.getStatsFor(CONFIG.DATE_RANGE);
    var keywordInfo = {
      text: kw.getText(),
      matchType: kw.getMatchType(),
      qualityScore: kw.getQualityScore(),
      campaignName: kw.getCampaign().getName(),
      adGroupName: kw.getAdGroup().getName(),
      impressions: stats.getImpressions(),
      clicks: stats.getClicks(),
      cost: stats.getCost(),
      conversions: stats.getConversions(),
      ctr: stats.getCtr()
    };

    if (!CONFIG.DRY_RUN) {
      kw.pause();
      kw.applyLabel(CONFIG.LABEL_NAME);
      keywordInfo.action = "PAUSED";
    } else {
      keywordInfo.action = "WOULD PAUSE (dry run)";
    }

    pausedKeywords.push(keywordInfo);
  }

  // Write results
  writeResults(sheet, pausedKeywords);

  var modeLabel = CONFIG.DRY_RUN ? " (DRY RUN)" : "";
  Logger.log("Found " + totalFound + " low QS keywords." + modeLabel);
  if (!CONFIG.DRY_RUN) {
    Logger.log("Paused " + pausedKeywords.length + " keywords.");
  }

  // Email notification
  if (CONFIG.EMAIL_RECIPIENTS && pausedKeywords.length > 0) {
    var actionVerb = CONFIG.DRY_RUN ? "flagged" : "paused";
    MailApp.sendEmail({
      to: CONFIG.EMAIL_RECIPIENTS,
      subject: "Low QS Keywords " + actionVerb + ": " + pausedKeywords.length + modeLabel,
      body: pausedKeywords.length + " keywords with Quality Score <= " + CONFIG.QS_THRESHOLD +
            " were " + actionVerb + ".\n\n" +
            "View the full report: " + spreadsheet.getUrl()
    });
  }
}

/**
 * Creates the label if it doesn't already exist.
 */
function ensureLabelExists(labelName) {
  var labels = AdsApp.labels().withCondition("Name = '" + labelName + "'").get();
  if (!labels.hasNext()) {
    AdsApp.createLabel(labelName, "Keywords paused by Low QS script", "#FF6666");
  }
}

/**
 * Creates or opens the output spreadsheet.
 */
function getOrCreateSpreadsheet() {
  if (CONFIG.SPREADSHEET_URL) {
    return SpreadsheetApp.openByUrl(CONFIG.SPREADSHEET_URL);
  }
  var ss = SpreadsheetApp.create("Low QS Keywords — " + Utilities.formatDate(new Date(), "GMT", "yyyy-MM-dd"));
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
    "Quality Score",
    "Campaign",
    "Ad Group",
    "Impressions",
    "Clicks",
    "CTR",
    "Cost",
    "Conversions"
  ]);
  sheet.getRange("1:1").setFontWeight("bold");
}

/**
 * Writes keyword results to the sheet.
 */
function writeResults(sheet, keywords) {
  if (keywords.length === 0) {
    sheet.appendRow(["No keywords below QS threshold with sufficient impressions."]);
    return;
  }

  for (var i = 0; i < keywords.length; i++) {
    var kw = keywords[i];
    sheet.appendRow([
      kw.action,
      kw.text,
      kw.matchType,
      kw.qualityScore,
      kw.campaignName,
      kw.adGroupName,
      kw.impressions,
      kw.clicks,
      (kw.ctr * 100).toFixed(2) + "%",
      kw.cost.toFixed(2),
      kw.conversions
    ]);
  }
}
```

## Setup Instructions

1. **Create the script:** Google Ads → Tools & Settings → Bulk Actions → Scripts → New Script
2. **Paste the code** and update the `CONFIG` object
3. **Authorize** when prompted
4. **Run in DRY_RUN mode first** (`DRY_RUN: true`) — review the output sheet to confirm the keywords it would pause look correct
5. **Set `DRY_RUN` to `false`** once satisfied with the preview
6. **Schedule** to run weekly

> [!danger] Destructive Action
> When `DRY_RUN` is set to `false`, this script **pauses keywords**. Always preview with `DRY_RUN: true` first. Paused keywords can be re-enabled from the Google Ads UI by filtering on the label.

## Customization Guide

### Adjust the quality score threshold

The default threshold of `3` is aggressive — it only pauses truly poor-performing keywords. Common settings:

- **QS <= 3:** Conservative. Only pauses the worst performers.
- **QS <= 4:** Moderate. Catches more underperformers.
- **QS <= 5:** Aggressive. Pauses anything below average. Use with caution.

### Require more data before pausing

Increase `MIN_IMPRESSIONS` to require more data before acting. For low-volume accounts, `500` or `1000` may be more appropriate than `100`.

### Limit to recent performance

Change `DATE_RANGE` from `"ALL_TIME"` to `"LAST_30_DAYS"` or `"LAST_90_DAYS"` if you want to base the decision on recent quality scores only. Useful in accounts where landing pages or ads have been recently updated.

### Re-enable paused keywords

All paused keywords are tagged with the label configured in `LABEL_NAME`. In the Google Ads UI, filter by this label to find and re-enable keywords after improving their landing pages or ad relevance.

> [!tip] What Is a Good Quality Score?
> QS of 7+ is considered good. QS of 5–6 is average. Below 5 means Google thinks your keyword, ad, or landing page is a poor match for the searcher's intent. Focus on ad relevance and landing page experience to improve QS.

## Related Reference

- [[catalog|Scripts Catalog]] — full index of available scripts
- [[quality-score|Quality Score Reference]] — understanding QS components
- [[ads-scripts-api|Google Ads Scripts API Reference]] — API quick reference
