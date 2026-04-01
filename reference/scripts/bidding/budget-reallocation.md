---
title: "Budget Reallocation"
date: 2026-03-31
tags:
  - reference
  - scripts
  - bidding
---

# Budget Reallocation

Moves unspent budget from underperforming campaigns to top performers based on CPA or ROAS. Ensures daily budget is allocated where it delivers the most value.

- **Schedule:** Daily
- **Runtime:** ~3 minutes for accounts with <50 campaigns

> [!info] How It Works
> The script compares each campaign's daily spend pace against its budget. Campaigns spending below their budget with poor CPA/ROAS lose a portion of budget. That freed-up budget is redistributed proportionally to high-performing campaigns that are hitting their budget caps. All changes are capped per run to prevent drastic swings.

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `PERFORMANCE_METRIC` | `"CPA"` | Primary metric: `"CPA"` (lower is better) or `"ROAS"` (higher is better) |
| `LOOKBACK_DAYS` | `14` | Days of data for performance evaluation |
| `MIN_CONVERSIONS` | `5` | Minimum conversions in lookback period before a campaign is evaluated |
| `MAX_REALLOCATION_PCT` | `0.25` | Maximum % of a campaign's budget that can be moved in a single run (25%) |
| `UNDERPERFORM_THRESHOLD` | `1.50` | CPA multiplier vs account average to qualify as underperformer (1.5x = 50% worse). For ROAS mode, campaigns below `1/threshold` of average are underperformers |
| `OVERPERFORM_THRESHOLD` | `0.75` | CPA multiplier vs account average to qualify as top performer (0.75x = 25% better). For ROAS mode, campaigns above `1/threshold` of average are top performers |
| `MIN_DAILY_BUDGET` | `5.00` | Minimum daily budget a campaign can be reduced to (currency units) |
| `PACE_THRESHOLD` | `0.85` | Campaigns spending less than 85% of budget are considered underspending |
| `CAMPAIGN_LABEL` | `"BudgetPool"` | Only campaigns with this label participate. Set to `""` for all enabled campaigns |
| `SPREADSHEET_URL` | `""` | Optional Google Sheets URL for logging. Leave empty to skip |
| `EMAIL_RECIPIENT` | `""` | Optional email for summary. Leave empty to skip |

## Script

```javascript
/**
 * Budget Reallocation Script
 *
 * Identifies underperforming campaigns that are underspending,
 * moves a portion of their budget to top performers that are
 * budget-capped. All moves are logged and capped per run.
 *
 * Schedule: Daily
 */

// ── Configuration ──────────────────────────────────────────────
var CONFIG = {
  PERFORMANCE_METRIC:     "CPA",
  LOOKBACK_DAYS:          14,
  MIN_CONVERSIONS:        5,
  MAX_REALLOCATION_PCT:   0.25,
  UNDERPERFORM_THRESHOLD: 1.50,
  OVERPERFORM_THRESHOLD:  0.75,
  MIN_DAILY_BUDGET:       5.00,
  PACE_THRESHOLD:         0.85,
  CAMPAIGN_LABEL:         "BudgetPool",
  SPREADSHEET_URL:        "",
  EMAIL_RECIPIENT:        ""
};

// ── Main ───────────────────────────────────────────────────────
function main() {
  var campaignData = collectCampaignData();

  if (campaignData.length === 0) {
    Logger.log("No eligible campaigns found. Exiting.");
    return;
  }

  var accountAvg = calculateAccountAverage(campaignData);
  Logger.log("Account average " + CONFIG.PERFORMANCE_METRIC + ": " +
    accountAvg.toFixed(2));

  var underperformers = identifyUnderperformers(campaignData, accountAvg);
  var topPerformers = identifyTopPerformers(campaignData, accountAvg);

  Logger.log("Underperformers: " + underperformers.length);
  Logger.log("Top performers: " + topPerformers.length);

  if (underperformers.length === 0 || topPerformers.length === 0) {
    Logger.log("Cannot reallocate — need both donors and recipients. Exiting.");
    return;
  }

  var changes = reallocateBudget(underperformers, topPerformers);

  applyBudgetChanges(changes);

  if (CONFIG.SPREADSHEET_URL) {
    logToSpreadsheet(changes);
  }

  if (CONFIG.EMAIL_RECIPIENT) {
    sendSummaryEmail(changes, accountAvg);
  }

  Logger.log("Budget reallocation complete. " + changes.length + " changes applied.");
}

// ── Data Collection ────────────────────────────────────────────
function collectCampaignData() {
  var selector = AdsApp.campaigns()
    .withCondition("Status = ENABLED")
    .withCondition("AdvertisingChannelType = SEARCH");

  if (CONFIG.CAMPAIGN_LABEL) {
    selector = selector.withCondition(
      "LabelNames CONTAINS_ANY ['" + CONFIG.CAMPAIGN_LABEL + "']"
    );
  }

  var campaigns = selector.get();
  var data = [];
  var dateRange = getDateRangeString(CONFIG.LOOKBACK_DAYS);

  while (campaigns.hasNext()) {
    var campaign = campaigns.next();
    var stats = campaign.getStatsFor(dateRange.start, dateRange.end);
    var budget = campaign.getBudget().getAmount();
    var todayStats = campaign.getStatsFor("TODAY");

    var conversions = stats.getConversions();
    var cost = stats.getCost();
    var todayCost = todayStats.getCost();

    // Skip campaigns without enough conversion data
    if (conversions < CONFIG.MIN_CONVERSIONS) {
      Logger.log("  Skipping " + campaign.getName() +
        " — only " + conversions + " conversions (min: " +
        CONFIG.MIN_CONVERSIONS + ")");
      continue;
    }

    var cpa = conversions > 0 ? cost / conversions : Infinity;
    // Estimate ROAS: use conversion value if available, else skip
    var conversionValue = stats.getConversionValue
      ? stats.getConversionValue() : 0;
    var roas = cost > 0 ? conversionValue / cost : 0;

    var paceRatio = budget > 0 ? todayCost / budget : 0;

    data.push({
      campaign: campaign,
      name: campaign.getName(),
      budget: budget,
      cost: cost,
      todayCost: todayCost,
      conversions: conversions,
      cpa: cpa,
      roas: roas,
      paceRatio: paceRatio,
      metric: CONFIG.PERFORMANCE_METRIC === "CPA" ? cpa : roas
    });
  }

  return data;
}

// ── Analysis ───────────────────────────────────────────────────
function calculateAccountAverage(data) {
  var totalCost = 0;
  var totalConversions = 0;
  var totalValue = 0;

  for (var i = 0; i < data.length; i++) {
    totalCost += data[i].cost;
    totalConversions += data[i].conversions;
    totalValue += data[i].roas * data[i].cost; // Reconstruct value
  }

  if (CONFIG.PERFORMANCE_METRIC === "CPA") {
    return totalConversions > 0 ? totalCost / totalConversions : 0;
  } else {
    return totalCost > 0 ? totalValue / totalCost : 0;
  }
}

function identifyUnderperformers(data, accountAvg) {
  var result = [];

  for (var i = 0; i < data.length; i++) {
    var entry = data[i];
    var isUnderperforming = false;

    if (CONFIG.PERFORMANCE_METRIC === "CPA") {
      // CPA higher than threshold × average = bad
      isUnderperforming = entry.cpa > accountAvg * CONFIG.UNDERPERFORM_THRESHOLD;
    } else {
      // ROAS lower than average / threshold = bad
      isUnderperforming = entry.roas < accountAvg / CONFIG.UNDERPERFORM_THRESHOLD;
    }

    // Must also be underspending (pacing below threshold)
    var isUnderspending = entry.paceRatio < CONFIG.PACE_THRESHOLD;

    if (isUnderperforming && isUnderspending) {
      result.push(entry);
      Logger.log("  Underperformer: " + entry.name +
        " (" + CONFIG.PERFORMANCE_METRIC + ": " +
        entry.metric.toFixed(2) + ", pace: " +
        (entry.paceRatio * 100).toFixed(0) + "%)");
    }
  }

  return result;
}

function identifyTopPerformers(data, accountAvg) {
  var result = [];

  for (var i = 0; i < data.length; i++) {
    var entry = data[i];
    var isTopPerforming = false;

    if (CONFIG.PERFORMANCE_METRIC === "CPA") {
      // CPA lower than threshold × average = good
      isTopPerforming = entry.cpa < accountAvg * CONFIG.OVERPERFORM_THRESHOLD;
    } else {
      // ROAS higher than average / threshold = good
      isTopPerforming = entry.roas > accountAvg / CONFIG.OVERPERFORM_THRESHOLD;
    }

    // Should be spending at or near budget (budget-constrained)
    var isBudgetCapped = entry.paceRatio >= CONFIG.PACE_THRESHOLD;

    if (isTopPerforming && isBudgetCapped) {
      result.push(entry);
      Logger.log("  Top performer: " + entry.name +
        " (" + CONFIG.PERFORMANCE_METRIC + ": " +
        entry.metric.toFixed(2) + ", pace: " +
        (entry.paceRatio * 100).toFixed(0) + "%)");
    }
  }

  return result;
}

// ── Reallocation ───────────────────────────────────────────────
function reallocateBudget(donors, recipients) {
  var changes = [];
  var totalFreed = 0;

  // Step 1: Calculate how much each donor gives up
  for (var i = 0; i < donors.length; i++) {
    var donor = donors[i];
    var maxDonation = donor.budget * CONFIG.MAX_REALLOCATION_PCT;
    var newBudget = Math.max(donor.budget - maxDonation, CONFIG.MIN_DAILY_BUDGET);
    var actualDonation = donor.budget - newBudget;

    if (actualDonation > 0) {
      changes.push({
        name: donor.name,
        campaign: donor.campaign,
        oldBudget: donor.budget,
        newBudget: newBudget,
        delta: -actualDonation,
        role: "donor"
      });
      totalFreed += actualDonation;
    }
  }

  if (totalFreed === 0) {
    Logger.log("No budget to free up (all donors at minimum). Exiting.");
    return changes;
  }

  Logger.log("Total budget freed: " + totalFreed.toFixed(2));

  // Step 2: Distribute freed budget proportionally to recipients
  // Weight by inverse CPA (lower CPA gets more) or by ROAS (higher ROAS gets more)
  var totalWeight = 0;
  for (var j = 0; j < recipients.length; j++) {
    if (CONFIG.PERFORMANCE_METRIC === "CPA") {
      recipients[j].weight = recipients[j].cpa > 0 ? 1 / recipients[j].cpa : 0;
    } else {
      recipients[j].weight = recipients[j].roas;
    }
    totalWeight += recipients[j].weight;
  }

  for (var k = 0; k < recipients.length; k++) {
    var recipient = recipients[k];
    var share = totalWeight > 0 ? (recipient.weight / totalWeight) * totalFreed : 0;

    // Cap individual increase at MAX_REALLOCATION_PCT of their current budget
    var maxIncrease = recipient.budget * CONFIG.MAX_REALLOCATION_PCT;
    share = Math.min(share, maxIncrease);

    if (share > 0.01) { // Only apply changes above 1 cent
      changes.push({
        name: recipient.name,
        campaign: recipient.campaign,
        oldBudget: recipient.budget,
        newBudget: recipient.budget + share,
        delta: share,
        role: "recipient"
      });
    }
  }

  return changes;
}

// ── Apply Changes ──────────────────────────────────────────────
function applyBudgetChanges(changes) {
  for (var i = 0; i < changes.length; i++) {
    var change = changes[i];
    var roundedBudget = Math.round(change.newBudget * 100) / 100;
    change.campaign.getBudget().setAmount(roundedBudget);
    Logger.log("  " + change.name + ": " +
      change.oldBudget.toFixed(2) + " → " +
      roundedBudget.toFixed(2) +
      " (" + (change.delta > 0 ? "+" : "") + change.delta.toFixed(2) + ")");
  }
}

// ── Logging ────────────────────────────────────────────────────
function logToSpreadsheet(changes) {
  var ss = SpreadsheetApp.openByUrl(CONFIG.SPREADSHEET_URL);
  var sheet = ss.getSheetByName("BudgetReallocation") ||
    ss.insertSheet("BudgetReallocation");

  if (sheet.getLastRow() === 0) {
    sheet.appendRow([
      "Date", "Campaign", "Role", "Old Budget",
      "New Budget", "Delta"
    ]);
  }

  var today = Utilities.formatDate(
    new Date(),
    AdsApp.currentAccount().getTimeZone(),
    "yyyy-MM-dd"
  );

  for (var i = 0; i < changes.length; i++) {
    sheet.appendRow([
      today,
      changes[i].name,
      changes[i].role,
      changes[i].oldBudget,
      changes[i].newBudget,
      changes[i].delta
    ]);
  }
}

function sendSummaryEmail(changes, accountAvg) {
  var body = "Budget Reallocation Summary\n";
  body += "Date: " + new Date().toISOString().split("T")[0] + "\n";
  body += "Metric: " + CONFIG.PERFORMANCE_METRIC + "\n";
  body += "Account average: " + accountAvg.toFixed(2) + "\n\n";

  var totalFreed = 0;
  var totalAdded = 0;

  body += "DONORS (budget reduced):\n";
  for (var i = 0; i < changes.length; i++) {
    if (changes[i].role === "donor") {
      body += "  " + changes[i].name + ": " +
        changes[i].oldBudget.toFixed(2) + " → " +
        changes[i].newBudget.toFixed(2) + "\n";
      totalFreed += Math.abs(changes[i].delta);
    }
  }

  body += "\nRECIPIENTS (budget increased):\n";
  for (var j = 0; j < changes.length; j++) {
    if (changes[j].role === "recipient") {
      body += "  " + changes[j].name + ": " +
        changes[j].oldBudget.toFixed(2) + " → " +
        changes[j].newBudget.toFixed(2) + "\n";
      totalAdded += changes[j].delta;
    }
  }

  body += "\nTotal freed: " + totalFreed.toFixed(2);
  body += "\nTotal redistributed: " + totalAdded.toFixed(2);

  MailApp.sendEmail({
    to: CONFIG.EMAIL_RECIPIENT,
    subject: "Budget Reallocation — " + new Date().toISOString().split("T")[0],
    body: body
  });
}

// ── Utilities ──────────────────────────────────────────────────
function getDateRangeString(daysBack) {
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

1. **Label your campaigns** — Create a label called `BudgetPool` in Google Ads and apply it to campaigns that should share budget. Only campaigns in the same label pool trade budget with each other.

2. **Choose your metric** — Set `PERFORMANCE_METRIC` to `"CPA"` (if optimizing for cost per conversion) or `"ROAS"` (if optimizing for return on ad spend). ROAS mode requires conversion values to be tracked.

3. **Create the script** — Google Ads → Tools → Bulk actions → Scripts → New script. Paste the full script.

4. **Review thresholds** — The defaults are moderate. For your first run:
   - `MAX_REALLOCATION_PCT: 0.15` (move at most 15% per run)
   - `MIN_CONVERSIONS: 10` (require more data before acting)

5. **Preview first** — Always click "Preview" before scheduling. The Logger output shows exactly which campaigns would donate and receive budget, and how much.

6. **Schedule** — Run daily, early in the day so budgets are set before peak traffic.

> [!warning] Shared Budgets
> This script modifies individual campaign budgets via `getBudget().setAmount()`. If your campaigns use shared budgets in Google Ads, this script will modify the shared budget object, affecting all campaigns in that shared budget. Use individual budgets for campaigns in the reallocation pool.

> [!tip] Start Small
> Begin with 3-5 campaigns in the label pool. Monitor daily for a week via the spreadsheet log before expanding to the full account.

## Customization Guide

### Switching Between CPA and ROAS

Change `PERFORMANCE_METRIC` to toggle behavior. The thresholds automatically adjust their direction:

- **CPA mode:** Underperformers have CPA > 1.5x account average. Top performers have CPA < 0.75x average.
- **ROAS mode:** Underperformers have ROAS < average / 1.5. Top performers have ROAS > average / 0.75.

### Adding Minimum Budget Protection

The `MIN_DAILY_BUDGET` prevents campaigns from being reduced below a floor. Increase this for campaigns that need minimum visibility:

```javascript
MIN_DAILY_BUDGET: 10.00,  // Never go below 10/day
```

### Excluding Campaign Types

The default filters to `SEARCH` campaigns only. To include Display or Shopping, remove or modify the `AdvertisingChannelType` condition:

```javascript
// Include Search and Shopping
var selector = AdsApp.campaigns()
  .withCondition("Status = ENABLED")
  .withCondition("AdvertisingChannelType IN [SEARCH, SHOPPING]");
```

### Weighted Redistribution

The default distributes freed budget proportionally by performance (inverse CPA or raw ROAS). To use equal distribution instead, replace the weight calculation:

```javascript
// Equal distribution among all recipients
recipients[j].weight = 1;
```

### Dry Run Mode

Add a `DRY_RUN` flag to test without making changes:

```javascript
DRY_RUN: true,  // Add to CONFIG

// Replace applyBudgetChanges with:
function applyBudgetChanges(changes) {
  for (var i = 0; i < changes.length; i++) {
    var change = changes[i];
    if (CONFIG.DRY_RUN) {
      Logger.log("  [DRY RUN] " + change.name + ": " +
        change.oldBudget.toFixed(2) + " → would become " +
        change.newBudget.toFixed(2));
    } else {
      change.campaign.getBudget().setAmount(
        Math.round(change.newBudget * 100) / 100
      );
    }
  }
}
```

## Related

- [[catalog|Scripts Catalog]] — Full script index
- [[ads-scripts-api|Google Ads Scripts API Reference]] — API documentation
- [[bidding-strategies|Bidding Strategies]] — Strategy selection guide
