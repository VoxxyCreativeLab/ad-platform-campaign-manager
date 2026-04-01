---
title: "Automated Bid Rules"
date: 2026-03-31
tags:
  - reference
  - scripts
  - bidding
---

# Automated Bid Rules

Pauses or reduces bids on keywords that have accumulated significant cost without generating any conversions. Acts as a safety net to stop budget waste on non-converting keywords.

- **Schedule:** Daily
- **Runtime:** ~2-5 minutes depending on keyword count

> [!info] How It Works
> The script scans all enabled keywords across targeted campaigns. For each keyword, it checks whether the cost in the lookback window exceeds a threshold while conversions remain at zero. If a keyword qualifies, the script either pauses it or reduces its bid by a configurable percentage. A minimum impressions gate prevents acting on keywords that haven't had enough exposure.

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `COST_THRESHOLD` | `50.00` | Minimum cost (currency units) with zero conversions before action is taken |
| `LOOKBACK_DAYS` | `30` | Number of days to evaluate keyword performance |
| `MIN_IMPRESSIONS` | `200` | Minimum impressions before a keyword is eligible for action. Prevents pausing keywords that haven't had fair exposure |
| `ACTION` | `"PAUSE"` | What to do with qualifying keywords: `"PAUSE"` or `"LOWER_BID"` |
| `BID_REDUCTION_PCT` | `0.40` | When ACTION is `"LOWER_BID"`, reduce CPC by this percentage (40%) |
| `MIN_BID` | `0.10` | Minimum CPC bid after reduction (currency units). Prevents bids from going to zero |
| `CAMPAIGN_LABEL` | `""` | Only process keywords in campaigns with this label. Set to `""` for all enabled campaigns |
| `EXCLUDE_LABEL` | `"BidRuleExclude"` | Keywords with this label are never touched. Use for brand terms or strategic keywords |
| `SPREADSHEET_URL` | `""` | Optional Google Sheets URL for logging all actions. Leave empty to skip |
| `EMAIL_RECIPIENT` | `""` | Optional email address for summary alert. Leave empty to skip |
| `MAX_ACTIONS_PER_RUN` | `100` | Safety limit: maximum number of keywords to act on per execution. Prevents runaway changes |

## Script

```javascript
/**
 * Automated Bid Rules — Zero Conversion Keyword Manager
 *
 * Identifies keywords with high cost and zero conversions,
 * then pauses them or reduces their bids. Includes safety
 * gates for minimum impressions and a per-run action cap.
 *
 * Schedule: Daily
 */

// ── Configuration ──────────────────────────────────────────────
var CONFIG = {
  COST_THRESHOLD:      50.00,
  LOOKBACK_DAYS:       30,
  MIN_IMPRESSIONS:     200,
  ACTION:              "PAUSE",       // "PAUSE" or "LOWER_BID"
  BID_REDUCTION_PCT:   0.40,
  MIN_BID:             0.10,
  CAMPAIGN_LABEL:      "",
  EXCLUDE_LABEL:       "BidRuleExclude",
  SPREADSHEET_URL:     "",
  EMAIL_RECIPIENT:     "",
  MAX_ACTIONS_PER_RUN: 100
};

// ── Main ───────────────────────────────────────────────────────
function main() {
  var dateRange = getDateRange(CONFIG.LOOKBACK_DAYS);
  var keywords = getEligibleKeywords(dateRange);
  var actionLog = [];
  var actionCount = 0;

  Logger.log("Scanning keywords for zero-conversion waste...");
  Logger.log("Lookback: " + CONFIG.LOOKBACK_DAYS + " days");
  Logger.log("Cost threshold: " + CONFIG.COST_THRESHOLD);
  Logger.log("Min impressions: " + CONFIG.MIN_IMPRESSIONS);
  Logger.log("Action: " + CONFIG.ACTION);

  while (keywords.hasNext() && actionCount < CONFIG.MAX_ACTIONS_PER_RUN) {
    var keyword = keywords.next();
    var stats = keyword.getStatsFor(dateRange.start, dateRange.end);

    var impressions = stats.getImpressions();
    var clicks = stats.getClicks();
    var cost = stats.getCost();
    var conversions = stats.getConversions();

    // Safety gate: skip keywords without enough exposure
    if (impressions < CONFIG.MIN_IMPRESSIONS) {
      continue;
    }

    // Core rule: high cost + zero conversions
    if (cost >= CONFIG.COST_THRESHOLD && conversions === 0) {
      // Check for exclude label
      if (hasExcludeLabel(keyword)) {
        Logger.log("  Excluded (label): " + keyword.getText());
        continue;
      }

      var entry = {
        keyword: keyword.getText(),
        matchType: keyword.getMatchType(),
        campaign: keyword.getCampaign().getName(),
        adGroup: keyword.getAdGroup().getName(),
        impressions: impressions,
        clicks: clicks,
        cost: cost,
        action: CONFIG.ACTION,
        oldBid: 0,
        newBid: 0
      };

      if (CONFIG.ACTION === "PAUSE") {
        entry.oldBid = keyword.bidding().getCpc();
        entry.newBid = entry.oldBid; // Bid unchanged
        keyword.pause();
        Logger.log("  PAUSED: " + keyword.getText() +
          " (" + cost.toFixed(2) + " cost, 0 conversions)");
      } else if (CONFIG.ACTION === "LOWER_BID") {
        var currentBid = keyword.bidding().getCpc();
        var newBid = currentBid * (1 - CONFIG.BID_REDUCTION_PCT);
        newBid = Math.max(newBid, CONFIG.MIN_BID);
        newBid = Math.round(newBid * 100) / 100;

        entry.oldBid = currentBid;
        entry.newBid = newBid;

        keyword.bidding().setCpc(newBid);
        Logger.log("  BID LOWERED: " + keyword.getText() +
          " (" + currentBid.toFixed(2) + " → " + newBid.toFixed(2) +
          ", cost: " + cost.toFixed(2) + ", 0 conversions)");
      }

      actionLog.push(entry);
      actionCount++;
    }
  }

  // Summary
  Logger.log("\n── Summary ──");
  Logger.log("Keywords scanned: complete");
  Logger.log("Actions taken: " + actionLog.length);

  if (actionCount >= CONFIG.MAX_ACTIONS_PER_RUN) {
    Logger.log("WARNING: Hit max actions limit (" +
      CONFIG.MAX_ACTIONS_PER_RUN +
      "). More keywords may qualify — run again or increase limit.");
  }

  if (CONFIG.SPREADSHEET_URL) {
    logToSpreadsheet(actionLog);
  }

  if (CONFIG.EMAIL_RECIPIENT) {
    sendSummaryEmail(actionLog);
  }

  Logger.log("Automated bid rules complete.");
}

// ── Keyword Selection ──────────────────────────────────────────
function getEligibleKeywords(dateRange) {
  // Build the selector step by step
  var selector = AdsApp.keywords()
    .withCondition("Status = ENABLED")
    .withCondition("CampaignStatus = ENABLED")
    .withCondition("AdGroupStatus = ENABLED")
    .withCondition("Conversions = 0")
    .withCondition("Cost > " + CONFIG.COST_THRESHOLD)
    .withCondition("Impressions > " + CONFIG.MIN_IMPRESSIONS)
    .forDateRange(dateRange.start, dateRange.end)
    .orderBy("Cost DESC");

  // Optionally filter by campaign label
  if (CONFIG.CAMPAIGN_LABEL) {
    selector = selector.withCondition(
      "CampaignName CONTAINS_ANY ['" + CONFIG.CAMPAIGN_LABEL + "']"
    );
  }

  return selector.get();
}

function hasExcludeLabel(keyword) {
  if (!CONFIG.EXCLUDE_LABEL) {
    return false;
  }

  var labels = keyword.labels()
    .withCondition("Name = '" + CONFIG.EXCLUDE_LABEL + "'")
    .get();

  return labels.hasNext();
}

// ── Logging ────────────────────────────────────────────────────
function logToSpreadsheet(actionLog) {
  var ss = SpreadsheetApp.openByUrl(CONFIG.SPREADSHEET_URL);
  var sheet = ss.getSheetByName("BidRules") || ss.insertSheet("BidRules");

  // Write header if empty
  if (sheet.getLastRow() === 0) {
    sheet.appendRow([
      "Date", "Keyword", "Match Type", "Campaign", "Ad Group",
      "Impressions", "Clicks", "Cost", "Action", "Old Bid", "New Bid"
    ]);
  }

  var today = Utilities.formatDate(
    new Date(),
    AdsApp.currentAccount().getTimeZone(),
    "yyyy-MM-dd"
  );

  for (var i = 0; i < actionLog.length; i++) {
    var entry = actionLog[i];
    sheet.appendRow([
      today,
      entry.keyword,
      entry.matchType,
      entry.campaign,
      entry.adGroup,
      entry.impressions,
      entry.clicks,
      entry.cost,
      entry.action,
      entry.oldBid,
      entry.newBid
    ]);
  }
}

function sendSummaryEmail(actionLog) {
  var body = "Automated Bid Rules — Daily Report\n";
  body += "Date: " + new Date().toISOString().split("T")[0] + "\n";
  body += "Action: " + CONFIG.ACTION + "\n";
  body += "Lookback: " + CONFIG.LOOKBACK_DAYS + " days\n";
  body += "Cost threshold: " + CONFIG.COST_THRESHOLD + "\n\n";

  if (actionLog.length === 0) {
    body += "No keywords qualified for action today.\n";
  } else {
    body += "Keywords affected: " + actionLog.length + "\n\n";

    var totalWastedCost = 0;
    for (var i = 0; i < actionLog.length; i++) {
      var entry = actionLog[i];
      totalWastedCost += entry.cost;

      body += (i + 1) + ". [" + entry.matchType + "] " + entry.keyword + "\n";
      body += "   Campaign: " + entry.campaign + "\n";
      body += "   Ad Group: " + entry.adGroup + "\n";
      body += "   Cost: " + entry.cost.toFixed(2) + " | ";
      body += "Clicks: " + entry.clicks + " | ";
      body += "Impressions: " + entry.impressions + "\n";

      if (CONFIG.ACTION === "LOWER_BID") {
        body += "   Bid: " + entry.oldBid.toFixed(2) + " → " +
          entry.newBid.toFixed(2) + "\n";
      }
      body += "\n";
    }

    body += "Total wasted cost (zero conversions): " +
      totalWastedCost.toFixed(2) + "\n";
  }

  MailApp.sendEmail({
    to: CONFIG.EMAIL_RECIPIENT,
    subject: "Bid Rules: " + actionLog.length + " keywords actioned — " +
      new Date().toISOString().split("T")[0],
    body: body
  });
}

// ── Utilities ──────────────────────────────────────────────────
function getDateRange(daysBack) {
  var endDate = new Date();
  var startDate = new Date();
  startDate.setDate(startDate.getDate() - daysBack);

  var format = function(date) {
    var yyyy = date.getFullYear();
    var mm = ("0" + (date.getMonth() + 1)).slice(-2);
    var dd = ("0" + date.getDate()).slice(-2);
    return yyyy + mm + dd;
  };

  return { start: format(startDate), end: format(endDate) };
}
```

## Setup Instructions

1. **Create the script** — Google Ads → Tools → Bulk actions → Scripts → New script. Paste the full script.

2. **Set your cost threshold** — The `COST_THRESHOLD` determines when a keyword is considered wasteful. Start higher than you think:
   - Low-CPA accounts (CPA < 20): set `COST_THRESHOLD` to `40` (2x target CPA)
   - Medium-CPA accounts (CPA 20-50): set to `75-100`
   - High-CPA accounts (CPA > 50): set to `150+`

3. **Protect brand keywords** — Create a label called `BidRuleExclude` and apply it to branded keywords and any strategic terms you never want paused, regardless of performance.

4. **Choose your action** — Start with `"LOWER_BID"` if you are cautious. Pausing is more aggressive but stops waste immediately.

5. **Preview first** — Click "Preview" in the script editor. Check the Logger output to see which keywords would be affected. Verify you are comfortable with the list before scheduling.

6. **Schedule** — Run daily. The script is idempotent — if a keyword was already paused yesterday, it will be skipped today.

> [!warning] Conversion Tracking Dependency
> This script relies on conversion data being accurate. If your conversion tracking has gaps (broken tags, consent mode blocking too aggressively, missing server-side events), the script may incorrectly identify converting keywords as non-converters. Verify your tracking setup with `/ad-platform-campaign-manager:conversion-tracking` before enabling this script.

> [!tip] Recovery Process
> If you need to re-enable paused keywords later, use the spreadsheet log to identify what was paused and when. Filter by date to find keywords paused in the last run. In Google Ads, filter keywords by status = Paused and re-enable selectively.

## Customization Guide

### Escalating Actions

Instead of immediately pausing, use a two-tier approach: first lower the bid, then pause if the keyword still doesn't convert. Implement by checking the current bid:

```javascript
// Replace the ACTION block in main() with:
var currentBid = keyword.bidding().getCpc();

if (currentBid <= CONFIG.MIN_BID) {
  // Already at minimum bid and still no conversions — pause it
  keyword.pause();
  entry.action = "PAUSE (escalated)";
  Logger.log("  PAUSED (at min bid): " + keyword.getText());
} else {
  // First offense — lower the bid
  var newBid = Math.max(currentBid * (1 - CONFIG.BID_REDUCTION_PCT), CONFIG.MIN_BID);
  keyword.bidding().setCpc(Math.round(newBid * 100) / 100);
  entry.action = "LOWER_BID";
  Logger.log("  BID LOWERED: " + keyword.getText());
}
```

### Cost-Per-Click Adjusted Thresholds

For accounts with wide CPC variation, a flat cost threshold may be too aggressive for high-CPC keywords and too lenient for low-CPC ones. Use a click-based threshold instead:

```javascript
// Replace the cost check with a click-based equivalent:
// "If 20+ clicks and zero conversions, act"
var CLICK_THRESHOLD = 20;

if (clicks >= CLICK_THRESHOLD && conversions === 0) {
  // Act on this keyword
}
```

### Match Type Specific Rules

Apply different thresholds based on match type. Broad match keywords get more leeway because they cover more search intent:

```javascript
// Different thresholds by match type
var thresholds = {
  "EXACT":   40.00,   // Strict — exact match should convert
  "PHRASE":  60.00,   // Moderate
  "BROAD":   80.00    // Lenient — broad needs more data
};

var matchType = keyword.getMatchType();
var threshold = thresholds[matchType] || CONFIG.COST_THRESHOLD;

if (cost >= threshold && conversions === 0) {
  // Act on this keyword
}
```

### Adding a Conversion Lag Buffer

Some industries have long conversion cycles (B2B, high-ticket items). Add a buffer by excluding recent clicks:

```javascript
// In CONFIG:
CONVERSION_LAG_DAYS: 7,  // Ignore the last 7 days of data

// In getDateRange, adjust the end date:
endDate.setDate(endDate.getDate() - CONFIG.CONVERSION_LAG_DAYS);
```

This ensures you only evaluate keywords where conversions have had time to register.

### Label-Based Action Override

Tag keywords with different labels to control the action per keyword:

```javascript
// Check for action override labels
function getKeywordAction(keyword) {
  var pauseLabels = keyword.labels()
    .withCondition("Name = 'ForcePause'").get();
  if (pauseLabels.hasNext()) return "PAUSE";

  var lowerLabels = keyword.labels()
    .withCondition("Name = 'ForceLowerBid'").get();
  if (lowerLabels.hasNext()) return "LOWER_BID";

  return CONFIG.ACTION; // Fall back to default
}
```

## Related

- [[catalog|Scripts Catalog]] — Full script index
- [[ads-scripts-api|Google Ads Scripts API Reference]] — API documentation
- [[conversion-actions|Conversion Actions]] — Setting up conversion tracking
- [[common-mistakes|Common Google Ads Mistakes]] — Avoiding budget waste patterns
