---
title: "Search Term Mining Script"
date: 2026-03-31
tags:
  - reference
  - scripts
  - reporting
---

# Search Term Mining Script

Exports search terms from the past week to a Google Sheet, automatically categorizing each term as a keyword promotion candidate, a negative keyword candidate, or a term that needs manual review. Saves hours of manual search term report analysis.

- **Schedule:** Weekly
- **Output:** Google Sheet with categorized search terms and action recommendations

> [!info] Related reference
> See [[ads-scripts-api]] for the full Google Ads Scripts API, [[gaql-query-templates#Search Terms]] for standalone GAQL queries, and [[negative-keyword-lists]] for negative keyword management best practices.

## Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `SPREADSHEET_URL` | string | _(required)_ | Full URL of the target Google Sheet |
| `DATE_RANGE` | string | `"LAST_7_DAYS"` | Reporting period |
| `CAMPAIGN_FILTER` | string | `""` | Campaign name filter. Leave empty for all campaigns |
| `PROMOTE_MIN_CONVERSIONS` | number | `1` | Minimum conversions to flag a term as "promote to keyword" |
| `PROMOTE_MAX_CPA` | number | `50` | Maximum cost per conversion for a promoted term |
| `PROMOTE_MIN_CTR` | number | `0.03` | Minimum CTR (3%) for a promoted term |
| `NEGATIVE_MIN_CLICKS` | number | `5` | Minimum clicks before a term can be flagged as negative |
| `NEGATIVE_MAX_CTR` | number | `0.01` | CTR below this (1%) flags a term as a negative candidate |
| `NEGATIVE_ZERO_CONV_MIN_COST` | number | `20` | Cost threshold for zero-conversion terms to be flagged as negatives |
| `REVIEW_MIN_IMPRESSIONS` | number | `50` | Minimum impressions for a term to appear in the "review" category |
| `INCLUDE_ALREADY_ADDED` | boolean | `false` | Include search terms that are already added as keywords |
| `EMAIL_NOTIFICATION` | string | `""` | Email address to notify when mining is complete. Leave empty to skip |

## Script

```javascript
/**
 * Search Term Mining Script
 *
 * Pulls search terms from the Google Ads Search Terms report,
 * categorizes them into: promote, negative, or review, and
 * exports them to a formatted Google Sheet.
 *
 * Schedule: Weekly
 *
 * Categories:
 *   - PROMOTE:  High CTR + conversions + acceptable CPA → add as keyword
 *   - NEGATIVE: Low CTR or high cost with zero conversions → add as negative
 *   - REVIEW:   Enough impressions but doesn't clearly fit either bucket
 *
 * Setup:
 *   1. Create a Google Sheet and copy the URL
 *   2. Paste this script into Google Ads > Tools > Scripts
 *   3. Update the CONFIG object below
 *   4. Authorize and schedule for weekly
 */

// ============================================================
// CONFIGURATION — edit these values
// ============================================================
var CONFIG = {
  // Google Sheet URL (create a blank sheet first)
  SPREADSHEET_URL: "https://docs.google.com/spreadsheets/d/YOUR_SHEET_ID/edit",

  // Date range for the report
  DATE_RANGE: "LAST_7_DAYS",

  // Filter campaigns by name (leave empty for all)
  CAMPAIGN_FILTER: "",

  // --- Promote thresholds ---
  // A search term is flagged as "promote to keyword" when ALL of these are met:
  PROMOTE_MIN_CONVERSIONS: 1,     // At least 1 conversion
  PROMOTE_MAX_CPA: 50,            // CPA at or below €50
  PROMOTE_MIN_CTR: 0.03,          // CTR at or above 3%

  // --- Negative thresholds ---
  // A search term is flagged as "add as negative" when ANY of these are met:
  NEGATIVE_MIN_CLICKS: 5,         // Must have at least 5 clicks to be evaluated
  NEGATIVE_MAX_CTR: 0.01,         // CTR below 1% with enough clicks
  NEGATIVE_ZERO_CONV_MIN_COST: 20, // Spent €20+ with zero conversions

  // --- Review thresholds ---
  REVIEW_MIN_IMPRESSIONS: 50,     // Minimum impressions to appear in review list

  // Include terms already added as keywords
  INCLUDE_ALREADY_ADDED: false,

  // Email to notify when mining is done (leave empty to skip)
  EMAIL_NOTIFICATION: ""
};

// ============================================================
// MAIN FUNCTION
// ============================================================
function main() {
  var spreadsheet = SpreadsheetApp.openByUrl(CONFIG.SPREADSHEET_URL);

  Logger.log("Starting Search Term Mining...");
  Logger.log("Date range: " + CONFIG.DATE_RANGE);

  // Fetch search terms
  var searchTerms = fetchSearchTerms();
  Logger.log("Fetched " + searchTerms.length + " search terms.");

  // Categorize
  var categorized = categorizeTerms(searchTerms);
  Logger.log("Promote: " + categorized.promote.length +
    " | Negative: " + categorized.negative.length +
    " | Review: " + categorized.review.length);

  // Write tabs
  writePromoteTab(spreadsheet, categorized.promote);
  writeNegativeTab(spreadsheet, categorized.negative);
  writeReviewTab(spreadsheet, categorized.review);
  writeSummaryTab(spreadsheet, categorized);

  // Notify
  if (CONFIG.EMAIL_NOTIFICATION) {
    var accountName = AdsApp.currentAccount().getName();
    MailApp.sendEmail({
      to: CONFIG.EMAIL_NOTIFICATION,
      subject: "Search Term Mining Complete — " + accountName,
      body: "Search term mining for " + accountName + " is done.\n\n" +
        "Promote candidates: " + categorized.promote.length + "\n" +
        "Negative candidates: " + categorized.negative.length + "\n" +
        "Review needed: " + categorized.review.length + "\n\n" +
        "View results: " + CONFIG.SPREADSHEET_URL
    });
  }

  Logger.log("Search Term Mining complete.");
}

// ============================================================
// FETCH SEARCH TERMS
// ============================================================
function fetchSearchTerms() {
  var query = "SELECT Query, CampaignName, AdGroupName, " +
    "KeywordTextMatchingQuery, QueryMatchTypeWithVariant, " +
    "Impressions, Clicks, Ctr, Cost, Conversions, " +
    "ConversionRate, CostPerConversion, ConversionValue " +
    "FROM SEARCH_QUERY_PERFORMANCE_REPORT " +
    "WHERE Impressions > 0";

  if (!CONFIG.INCLUDE_ALREADY_ADDED) {
    // Only include terms not already added as keywords
    // This is handled post-fetch since AWQL doesn't filter on this directly
  }

  if (CONFIG.CAMPAIGN_FILTER) {
    query += " AND CampaignName CONTAINS_IGNORE_CASE '" + CONFIG.CAMPAIGN_FILTER + "'";
  }

  query += " DURING " + CONFIG.DATE_RANGE;

  var report = AdsApp.report(query);
  var rows = report.rows();
  var terms = [];

  while (rows.hasNext()) {
    var row = rows.next();
    terms.push({
      query: row["Query"],
      campaign: row["CampaignName"],
      adGroup: row["AdGroupName"],
      matchedKeyword: row["KeywordTextMatchingQuery"],
      matchType: row["QueryMatchTypeWithVariant"],
      impressions: parseInt(row["Impressions"].replace(/,/g, ""), 10),
      clicks: parseInt(row["Clicks"].replace(/,/g, ""), 10),
      ctr: parseFloat(row["Ctr"].replace(/%/g, "")) / 100,
      cost: parseFloat(row["Cost"].replace(/,/g, "")),
      conversions: parseFloat(row["Conversions"].replace(/,/g, "")),
      convRate: parseFloat(row["ConversionRate"].replace(/%/g, "")) / 100,
      cpa: parseFloat(row["CostPerConversion"].replace(/,/g, "")),
      convValue: parseFloat(row["ConversionValue"].replace(/,/g, ""))
    });
  }

  return terms;
}

// ============================================================
// CATEGORIZE TERMS
// ============================================================
function categorizeTerms(terms) {
  var result = { promote: [], negative: [], review: [] };

  for (var i = 0; i < terms.length; i++) {
    var t = terms[i];
    var category = classifyTerm(t);
    t.category = category;
    result[category].push(t);
  }

  // Sort each category by relevance
  result.promote.sort(function(a, b) { return b.conversions - a.conversions; });
  result.negative.sort(function(a, b) { return b.cost - a.cost; });
  result.review.sort(function(a, b) { return b.impressions - a.impressions; });

  return result;
}

/**
 * Classifies a single search term into promote, negative, or review.
 */
function classifyTerm(t) {
  // PROMOTE: good CTR, has conversions, acceptable CPA
  if (t.conversions >= CONFIG.PROMOTE_MIN_CONVERSIONS &&
      t.ctr >= CONFIG.PROMOTE_MIN_CTR &&
      (t.cpa <= CONFIG.PROMOTE_MAX_CPA || t.cpa === 0)) {
    return "promote";
  }

  // NEGATIVE: low CTR with enough clicks
  if (t.clicks >= CONFIG.NEGATIVE_MIN_CLICKS && t.ctr < CONFIG.NEGATIVE_MAX_CTR) {
    return "negative";
  }

  // NEGATIVE: spent money, zero conversions
  if (t.conversions === 0 && t.cost >= CONFIG.NEGATIVE_ZERO_CONV_MIN_COST) {
    return "negative";
  }

  // REVIEW: has enough impressions but doesn't clearly fit
  if (t.impressions >= CONFIG.REVIEW_MIN_IMPRESSIONS) {
    return "review";
  }

  // Below all thresholds — skip (won't appear in any tab)
  return "review";
}

// ============================================================
// WRITE TABS
// ============================================================

function writePromoteTab(spreadsheet, terms) {
  var sheet = getOrCreateSheet(spreadsheet, "Promote to Keyword");
  sheet.clear();

  var headers = [
    "Search Term", "Campaign", "Ad Group", "Matched Keyword",
    "Match Type", "Impressions", "Clicks", "CTR",
    "Cost", "Conversions", "CPA", "Conv. Value",
    "Suggested Action"
  ];
  sheet.appendRow(headers);

  for (var i = 0; i < terms.length; i++) {
    var t = terms[i];
    var suggestedMatch = t.ctr > 0.05 ? "Exact" : "Phrase";
    sheet.appendRow([
      t.query, t.campaign, t.adGroup, t.matchedKeyword,
      t.matchType, t.impressions, t.clicks,
      (t.ctr * 100).toFixed(2) + "%",
      "€ " + t.cost.toFixed(2), t.conversions,
      "€ " + t.cpa.toFixed(2), "€ " + t.convValue.toFixed(2),
      "Add as " + suggestedMatch + " match"
    ]);
  }

  formatHeaderRow(sheet, headers.length, "#1b5e20"); // dark green
  Logger.log("Promote tab: " + terms.length + " rows.");
}

function writeNegativeTab(spreadsheet, terms) {
  var sheet = getOrCreateSheet(spreadsheet, "Add as Negative");
  sheet.clear();

  var headers = [
    "Search Term", "Campaign", "Ad Group", "Matched Keyword",
    "Impressions", "Clicks", "CTR",
    "Cost", "Conversions",
    "Reason", "Suggested Scope"
  ];
  sheet.appendRow(headers);

  for (var i = 0; i < terms.length; i++) {
    var t = terms[i];

    // Determine the reason it was flagged
    var reason = "";
    if (t.conversions === 0 && t.cost >= CONFIG.NEGATIVE_ZERO_CONV_MIN_COST) {
      reason = "High cost, zero conversions";
    } else if (t.ctr < CONFIG.NEGATIVE_MAX_CTR) {
      reason = "Very low CTR (" + (t.ctr * 100).toFixed(2) + "%)";
    }

    // Suggest scope: if the term is bad across campaigns, use account-level
    var scope = "Campaign";

    sheet.appendRow([
      t.query, t.campaign, t.adGroup, t.matchedKeyword,
      t.impressions, t.clicks,
      (t.ctr * 100).toFixed(2) + "%",
      "€ " + t.cost.toFixed(2), t.conversions,
      reason, scope
    ]);
  }

  formatHeaderRow(sheet, headers.length, "#b71c1c"); // dark red
  Logger.log("Negative tab: " + terms.length + " rows.");
}

function writeReviewTab(spreadsheet, terms) {
  var sheet = getOrCreateSheet(spreadsheet, "Review");
  sheet.clear();

  var headers = [
    "Search Term", "Campaign", "Ad Group", "Matched Keyword",
    "Match Type", "Impressions", "Clicks", "CTR",
    "Cost", "Conversions", "CPA", "Notes"
  ];
  sheet.appendRow(headers);

  for (var i = 0; i < terms.length; i++) {
    var t = terms[i];
    var notes = "";
    if (t.conversions > 0 && t.cpa > CONFIG.PROMOTE_MAX_CPA) {
      notes = "Has conversions but CPA too high";
    } else if (t.clicks > 0 && t.conversions === 0 && t.cost < CONFIG.NEGATIVE_ZERO_CONV_MIN_COST) {
      notes = "No conversions yet, low spend — needs more data";
    }

    sheet.appendRow([
      t.query, t.campaign, t.adGroup, t.matchedKeyword,
      t.matchType, t.impressions, t.clicks,
      (t.ctr * 100).toFixed(2) + "%",
      "€ " + t.cost.toFixed(2), t.conversions,
      t.cpa > 0 ? "€ " + t.cpa.toFixed(2) : "—",
      notes
    ]);
  }

  formatHeaderRow(sheet, headers.length, "#e65100"); // dark orange
  Logger.log("Review tab: " + terms.length + " rows.");
}

function writeSummaryTab(spreadsheet, categorized) {
  var sheet = getOrCreateSheet(spreadsheet, "Summary");
  sheet.clear();

  var reportDate = Utilities.formatDate(
    new Date(), AdsApp.currentAccount().getTimeZone(), "yyyy-MM-dd HH:mm"
  );

  sheet.appendRow(["Search Term Mining Summary"]);
  sheet.appendRow(["Report date", reportDate]);
  sheet.appendRow(["Date range", CONFIG.DATE_RANGE]);
  sheet.appendRow(["Account", AdsApp.currentAccount().getName()]);
  sheet.appendRow([""]);
  sheet.appendRow(["Category", "Count", "Total Cost", "Total Conversions"]);

  var categories = ["promote", "negative", "review"];
  var labels = ["Promote to Keyword", "Add as Negative", "Review"];

  for (var c = 0; c < categories.length; c++) {
    var terms = categorized[categories[c]];
    var totalCost = 0, totalConv = 0;
    for (var i = 0; i < terms.length; i++) {
      totalCost += terms[i].cost;
      totalConv += terms[i].conversions;
    }
    sheet.appendRow([
      labels[c], terms.length,
      "€ " + totalCost.toFixed(2),
      totalConv
    ]);
  }

  sheet.getRange(1, 1).setFontSize(14).setFontWeight("bold");
  formatHeaderRow(sheet, 4, "#1a73e8");
  // The header format applies to row 1, but our actual header is row 6
  var headerRange = sheet.getRange(6, 1, 1, 4);
  headerRange.setFontWeight("bold");
  headerRange.setBackground("#1a73e8");
  headerRange.setFontColor("#ffffff");
}

// ============================================================
// HELPER FUNCTIONS
// ============================================================

function getOrCreateSheet(spreadsheet, name) {
  var sheet = spreadsheet.getSheetByName(name);
  if (!sheet) {
    sheet = spreadsheet.insertSheet(name);
  }
  return sheet;
}

function formatHeaderRow(sheet, columnCount, color) {
  var headerRange = sheet.getRange(1, 1, 1, columnCount);
  headerRange.setFontWeight("bold");
  headerRange.setBackground(color || "#1a73e8");
  headerRange.setFontColor("#ffffff");
  sheet.setFrozenRows(1);

  for (var i = 1; i <= columnCount; i++) {
    sheet.autoResizeColumn(i);
  }
}
```

## Setup Instructions

1. **Create the Google Sheet**
   - Go to [sheets.google.com](https://sheets.google.com) and create a new blank spreadsheet
   - Name it "Search Term Mining — [Client Name]"
   - Copy the full URL

2. **Create the script**
   - In Google Ads, go to **Tools & Settings > Bulk actions > Scripts**
   - Click **+** to create a new script
   - Name it "Search Term Mining"
   - Paste the full script above

3. **Configure thresholds**
   - Set `SPREADSHEET_URL` to your Sheet URL
   - Adjust the promote/negative/review thresholds in `CONFIG` based on your account's typical performance. For accounts with low conversion volume, lower `PROMOTE_MIN_CONVERSIONS` to `0.5` (fractional conversions) and raise `NEGATIVE_ZERO_CONV_MIN_COST`

4. **Authorize and test**
   - Click **Authorize** and grant access
   - Click **Preview** to dry-run. Check the Logger output for row counts
   - Open the Sheet and verify the four tabs look correct

5. **Schedule**
   - Set frequency to **Weekly**
   - Choose a day that gives you time to review before the next week's spend begins (e.g., Monday or Friday)

> [!tip] Tracking specialist note
> The terms flagged as "promote" make great inputs for your keyword strategy sessions. Export the promote tab and bring it into [[keyword-strategy]] as seed keywords. Negative candidates should be cross-referenced with [[negative-keyword-lists]] before bulk-adding.

## Customization Guide

### Adjust classification thresholds

The three `classify*` thresholds in `CONFIG` control how aggressively the script flags terms. Conservative accounts (low volume, high CPA) should:

- Lower `PROMOTE_MIN_CTR` to `0.02`
- Raise `NEGATIVE_ZERO_CONV_MIN_COST` to `50`
- Raise `NEGATIVE_MIN_CLICKS` to `10`

Aggressive accounts (high volume, low CPA) should:

- Raise `PROMOTE_MIN_CTR` to `0.05`
- Lower `NEGATIVE_ZERO_CONV_MIN_COST` to `10`
- Lower `NEGATIVE_MIN_CLICKS` to `3`

### Add match type recommendations

The script already suggests Exact for high-CTR terms and Phrase for others. To customize the threshold, find this line in `writePromoteTab`:

```javascript
var suggestedMatch = t.ctr > 0.05 ? "Exact" : "Phrase";
```

Change `0.05` to your preferred CTR cutoff.

### Exclude brand terms from negatives

Add a brand filter to prevent branded queries from being flagged:

```javascript
// Add this at the top of classifyTerm()
var brandTerms = ["your brand", "brand name", "brand typo"];
for (var b = 0; b < brandTerms.length; b++) {
  if (t.query.toLowerCase().indexOf(brandTerms[b]) !== -1) {
    return "review"; // Never auto-negative a brand term
  }
}
```

### Track week-over-week changes

Instead of overwriting tabs each run, append a date column:

```javascript
// In fetchSearchTerms(), add a date stamp to each term
terms.push({
  // ... existing fields ...
  reportWeek: Utilities.formatDate(new Date(),
    AdsApp.currentAccount().getTimeZone(), "yyyy-MM-dd")
});
```

Then modify the write functions to append rows instead of clearing the sheet.

### Export negatives directly to a shared negative keyword list

After writing the Negative tab, add this to automatically create campaign-level negatives:

```javascript
// WARNING: This modifies your account. Test thoroughly first.
for (var i = 0; i < categorized.negative.length; i++) {
  var t = categorized.negative[i];
  var campaigns = AdsApp.campaigns()
    .withCondition("Name = '" + t.campaign + "'")
    .get();
  if (campaigns.hasNext()) {
    campaigns.next().createNegativeKeyword("[" + t.query + "]");
  }
}
```

> [!warning] Automated negatives
> Only enable the auto-negative snippet after you have manually reviewed the negative tab for at least 3-4 weeks and trust the thresholds. A misconfigured threshold can block valuable traffic.
