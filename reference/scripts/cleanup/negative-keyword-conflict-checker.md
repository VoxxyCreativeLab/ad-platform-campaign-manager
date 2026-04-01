---
title: "Negative Keyword Conflict Checker"
date: 2026-03-31
tags:
  - reference
  - scripts
  - cleanup
---

# Negative Keyword Conflict Checker

Identifies negative keywords that are blocking your positive (bidding) keywords. When a negative keyword matches a positive keyword, the positive keyword can never trigger — wasting your keyword research and potentially missing valuable traffic.

**Source pattern:** Brainlabs-Digital/Google-Ads-Scripts
**Schedule:** Monthly
**Runtime:** ~5–15 minutes depending on account size

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `SPREADSHEET_URL` | `""` | Google Sheets URL for output. Leave empty to create a new sheet. |
| `EMAIL_RECIPIENTS` | `""` | Comma-separated email addresses for notification. Leave empty to skip email. |
| `CAMPAIGN_NAME_CONTAINS` | `""` | Filter to specific campaigns. Empty string = all campaigns. |
| `CAMPAIGN_NAME_DOES_NOT_CONTAIN` | `""` | Exclude campaigns matching this string. |
| `CHECK_CAMPAIGN_LEVEL_NEGATIVES` | `true` | Include campaign-level negative keywords in the check. |
| `CHECK_AD_GROUP_LEVEL_NEGATIVES` | `true` | Include ad-group-level negative keywords in the check. |
| `CHECK_NEGATIVE_LISTS` | `true` | Include shared negative keyword lists in the check. |
| `INCLUDE_PAUSED_KEYWORDS` | `false` | Whether to check paused positive keywords for conflicts. |

## Script

```javascript
/**
 * Negative Keyword Conflict Checker
 *
 * Compares all negative keywords against positive keywords in the same
 * campaign (or ad group) to find conflicts where a negative blocks a
 * positive keyword from triggering.
 *
 * Outputs results to a Google Sheet and optionally sends an email alert.
 *
 * Source pattern: Brainlabs-Digital/Google-Ads-Scripts
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
  CHECK_CAMPAIGN_LEVEL_NEGATIVES: true,
  CHECK_AD_GROUP_LEVEL_NEGATIVES: true,
  CHECK_NEGATIVE_LISTS: true,
  INCLUDE_PAUSED_KEYWORDS: false
};

function main() {
  var spreadsheet = getOrCreateSpreadsheet();
  var sheet = spreadsheet.getActiveSheet();
  setupSheet(sheet);

  var conflicts = [];

  // Gather all positive keywords
  var positiveKeywords = getPositiveKeywords();
  Logger.log("Found " + positiveKeywords.length + " positive keywords to check.");

  // Gather all negative keywords by scope
  var campaignNegatives = {};
  var adGroupNegatives = {};
  var sharedListNegatives = {};

  if (CONFIG.CHECK_CAMPAIGN_LEVEL_NEGATIVES) {
    campaignNegatives = getCampaignNegatives();
  }
  if (CONFIG.CHECK_AD_GROUP_LEVEL_NEGATIVES) {
    adGroupNegatives = getAdGroupNegatives();
  }
  if (CONFIG.CHECK_NEGATIVE_LISTS) {
    sharedListNegatives = getSharedListNegatives();
  }

  // Check each positive keyword against applicable negatives
  for (var i = 0; i < positiveKeywords.length; i++) {
    var pos = positiveKeywords[i];
    var campaignName = pos.campaignName;
    var adGroupName = pos.adGroupName;

    // Check campaign-level negatives
    if (campaignNegatives[campaignName]) {
      var campNegs = campaignNegatives[campaignName];
      for (var j = 0; j < campNegs.length; j++) {
        if (doesNegativeBlock(campNegs[j], pos)) {
          conflicts.push({
            campaignName: campaignName,
            adGroupName: adGroupName,
            positiveKeyword: pos.text,
            positiveMatchType: pos.matchType,
            negativeKeyword: campNegs[j].text,
            negativeMatchType: campNegs[j].matchType,
            negativeLevel: "Campaign"
          });
        }
      }
    }

    // Check ad-group-level negatives
    var agKey = campaignName + "||" + adGroupName;
    if (adGroupNegatives[agKey]) {
      var agNegs = adGroupNegatives[agKey];
      for (var k = 0; k < agNegs.length; k++) {
        if (doesNegativeBlock(agNegs[k], pos)) {
          conflicts.push({
            campaignName: campaignName,
            adGroupName: adGroupName,
            positiveKeyword: pos.text,
            positiveMatchType: pos.matchType,
            negativeKeyword: agNegs[k].text,
            negativeMatchType: agNegs[k].matchType,
            negativeLevel: "Ad Group"
          });
        }
      }
    }

    // Check shared negative lists applied to this campaign
    if (sharedListNegatives[campaignName]) {
      var sharedNegs = sharedListNegatives[campaignName];
      for (var m = 0; m < sharedNegs.length; m++) {
        if (doesNegativeBlock(sharedNegs[m], pos)) {
          conflicts.push({
            campaignName: campaignName,
            adGroupName: adGroupName,
            positiveKeyword: pos.text,
            positiveMatchType: pos.matchType,
            negativeKeyword: sharedNegs[m].text,
            negativeMatchType: sharedNegs[m].matchType,
            negativeLevel: "Shared List (" + sharedNegs[m].listName + ")"
          });
        }
      }
    }
  }

  // Write results
  writeResults(sheet, conflicts);
  Logger.log("Found " + conflicts.length + " conflicts.");

  // Send email if configured
  if (CONFIG.EMAIL_RECIPIENTS && conflicts.length > 0) {
    MailApp.sendEmail({
      to: CONFIG.EMAIL_RECIPIENTS,
      subject: "Negative Keyword Conflicts Found: " + conflicts.length,
      body: "Found " + conflicts.length + " negative keyword conflicts.\n\n" +
            "View the full report: " + spreadsheet.getUrl()
    });
  }
}

/**
 * Determines if a negative keyword would block a positive keyword.
 * Handles exact, phrase, and broad match negative types.
 */
function doesNegativeBlock(negative, positive) {
  var negText = negative.text.toLowerCase().trim();
  var posText = positive.text.toLowerCase().trim();

  // Negative exact match: blocks only if the positive keyword text matches exactly
  if (negative.matchType === "EXACT") {
    return posText === negText;
  }

  // Negative phrase match: blocks if the negative phrase appears as a
  // contiguous sequence within the positive keyword
  if (negative.matchType === "PHRASE") {
    var posWords = posText.split(/\s+/);
    var negWords = negText.split(/\s+/);
    for (var i = 0; i <= posWords.length - negWords.length; i++) {
      var match = true;
      for (var j = 0; j < negWords.length; j++) {
        if (posWords[i + j] !== negWords[j]) {
          match = false;
          break;
        }
      }
      if (match) return true;
    }
    return false;
  }

  // Negative broad match: blocks if ALL words in the negative appear
  // anywhere in the positive keyword (order does not matter)
  var negBroadWords = negText.split(/\s+/);
  var posWordSet = posText.split(/\s+/);
  for (var w = 0; w < negBroadWords.length; w++) {
    if (posWordSet.indexOf(negBroadWords[w]) === -1) {
      return false;
    }
  }
  return true;
}

/**
 * Retrieves all enabled positive keywords, optionally including paused.
 */
function getPositiveKeywords() {
  var keywords = [];
  var conditions = ["CampaignStatus = ENABLED", "AdGroupStatus = ENABLED"];
  if (!CONFIG.INCLUDE_PAUSED_KEYWORDS) {
    conditions.push("Status = ENABLED");
  }
  if (CONFIG.CAMPAIGN_NAME_CONTAINS) {
    conditions.push("CampaignName CONTAINS '" + CONFIG.CAMPAIGN_NAME_CONTAINS + "'");
  }
  if (CONFIG.CAMPAIGN_NAME_DOES_NOT_CONTAIN) {
    conditions.push("CampaignName DOES_NOT_CONTAIN '" + CONFIG.CAMPAIGN_NAME_DOES_NOT_CONTAIN + "'");
  }

  var selector = AdsApp.keywords();
  for (var i = 0; i < conditions.length; i++) {
    selector = selector.withCondition(conditions[i]);
  }

  var iterator = selector.get();
  while (iterator.hasNext()) {
    var kw = iterator.next();
    keywords.push({
      text: kw.getText(),
      matchType: kw.getMatchType(),
      campaignName: kw.getCampaign().getName(),
      adGroupName: kw.getAdGroup().getName()
    });
  }
  return keywords;
}

/**
 * Retrieves campaign-level negative keywords grouped by campaign name.
 */
function getCampaignNegatives() {
  var negatives = {};
  var campaigns = getCampaignSelector().get();
  while (campaigns.hasNext()) {
    var campaign = campaigns.next();
    var campName = campaign.getName();
    negatives[campName] = [];
    var negIterator = campaign.negativeKeywords().get();
    while (negIterator.hasNext()) {
      var neg = negIterator.next();
      negatives[campName].push({
        text: neg.getText(),
        matchType: neg.getMatchType()
      });
    }
  }
  return negatives;
}

/**
 * Retrieves ad-group-level negative keywords grouped by
 * "campaignName||adGroupName".
 */
function getAdGroupNegatives() {
  var negatives = {};
  var adGroups = AdsApp.adGroups()
    .withCondition("CampaignStatus = ENABLED")
    .withCondition("Status = ENABLED")
    .get();
  while (adGroups.hasNext()) {
    var ag = adGroups.next();
    var key = ag.getCampaign().getName() + "||" + ag.getName();
    negatives[key] = [];
    var negIterator = ag.negativeKeywords().get();
    while (negIterator.hasNext()) {
      var neg = negIterator.next();
      negatives[key].push({
        text: neg.getText(),
        matchType: neg.getMatchType()
      });
    }
  }
  return negatives;
}

/**
 * Retrieves shared negative keyword list entries grouped by campaign name.
 */
function getSharedListNegatives() {
  var negatives = {};
  var lists = AdsApp.negativeKeywordLists().get();
  while (lists.hasNext()) {
    var list = lists.next();
    var listName = list.getName();
    var negKeywords = [];
    var negIterator = list.negativeKeywords().get();
    while (negIterator.hasNext()) {
      var neg = negIterator.next();
      negKeywords.push({
        text: neg.getText(),
        matchType: neg.getMatchType(),
        listName: listName
      });
    }

    // Map list to campaigns that use it
    var campaignIterator = list.campaigns().get();
    while (campaignIterator.hasNext()) {
      var campaign = campaignIterator.next();
      var campName = campaign.getName();
      if (!negatives[campName]) {
        negatives[campName] = [];
      }
      negatives[campName] = negatives[campName].concat(negKeywords);
    }
  }
  return negatives;
}

/**
 * Returns a campaign selector with optional name filters.
 */
function getCampaignSelector() {
  var selector = AdsApp.campaigns().withCondition("Status = ENABLED");
  if (CONFIG.CAMPAIGN_NAME_CONTAINS) {
    selector = selector.withCondition("Name CONTAINS '" + CONFIG.CAMPAIGN_NAME_CONTAINS + "'");
  }
  if (CONFIG.CAMPAIGN_NAME_DOES_NOT_CONTAIN) {
    selector = selector.withCondition("Name DOES_NOT_CONTAIN '" + CONFIG.CAMPAIGN_NAME_DOES_NOT_CONTAIN + "'");
  }
  return selector;
}

/**
 * Creates or opens the output spreadsheet.
 */
function getOrCreateSpreadsheet() {
  if (CONFIG.SPREADSHEET_URL) {
    return SpreadsheetApp.openByUrl(CONFIG.SPREADSHEET_URL);
  }
  var ss = SpreadsheetApp.create("Negative Keyword Conflicts — " + Utilities.formatDate(new Date(), "GMT", "yyyy-MM-dd"));
  Logger.log("Created new spreadsheet: " + ss.getUrl());
  return ss;
}

/**
 * Sets up the sheet header row.
 */
function setupSheet(sheet) {
  sheet.clear();
  sheet.appendRow([
    "Campaign",
    "Ad Group",
    "Positive Keyword",
    "Positive Match Type",
    "Conflicting Negative",
    "Negative Match Type",
    "Negative Level"
  ]);
  sheet.getRange("1:1").setFontWeight("bold");
}

/**
 * Writes conflict results to the sheet.
 */
function writeResults(sheet, conflicts) {
  if (conflicts.length === 0) {
    sheet.appendRow(["No conflicts found."]);
    return;
  }
  for (var i = 0; i < conflicts.length; i++) {
    var c = conflicts[i];
    sheet.appendRow([
      c.campaignName,
      c.adGroupName,
      c.positiveKeyword,
      c.positiveMatchType,
      c.negativeKeyword,
      c.negativeMatchType,
      c.negativeLevel
    ]);
  }
}
```

## Setup Instructions

1. **Create the script:** Google Ads → Tools & Settings → Bulk Actions → Scripts → New Script
2. **Paste the code** and update the `CONFIG` object at the top
3. **Authorize** the script when prompted (needs Sheets and email access)
4. **Preview** the script first — it only reads data and writes to Sheets, never modifies keywords
5. **Schedule** to run monthly

> [!tip] Output Spreadsheet
> If you leave `SPREADSHEET_URL` empty, the script creates a new Google Sheet each run. For ongoing tracking, create a dedicated sheet and paste its URL into the config.

## Customization Guide

### Filter to specific campaigns

Set `CAMPAIGN_NAME_CONTAINS` to a string that appears in your target campaign names. For example, `"Search"` will only check campaigns with "Search" in the name.

### Check only campaign-level negatives

Set `CHECK_AD_GROUP_LEVEL_NEGATIVES` and `CHECK_NEGATIVE_LISTS` to `false`. This is useful if you want a quick check of just the campaign-level negatives.

### Include paused keywords

Set `INCLUDE_PAUSED_KEYWORDS` to `true` if you want to catch conflicts on paused keywords too — useful before re-enabling a batch of keywords.

### Handling false positives

The script uses a conservative matching algorithm: broad match negatives block if ALL negative words appear in the positive keyword. In practice, Google's actual matching can be slightly different (close variants, stemming). Review flagged conflicts manually before removing negatives.

> [!warning] Read-Only Script
> This script **never modifies** keywords. It only reports conflicts. You decide which negatives to remove or which positives to restructure.

## Related Reference

- [[catalog|Scripts Catalog]] — full index of available scripts
- [[negative-keyword-lists|Negative Keyword Lists]] — audit checklist for negative keyword management
- [[ads-scripts-api|Google Ads Scripts API Reference]] — API quick reference
