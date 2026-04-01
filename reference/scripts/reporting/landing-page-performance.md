---
title: "Landing Page Performance Report"
date: 2026-03-31
tags:
  - reference
  - scripts
  - reporting
---

# Landing Page Performance Report

Generates a monthly report of landing page performance metrics grouped by URL. Compares each page's conversion rate against account-wide benchmarks and flags underperformers. Useful for tracking specialists who need to connect ad performance back to on-site behavior.

- **Schedule:** Monthly (1st of the month)
- **Output:** Google Sheet with landing page metrics, benchmark comparison, and flagged pages

> [!info] Related reference
> See [[ads-scripts-api]] for the full Google Ads Scripts API, [[gaql-query-templates#Landing Page]] for the standalone GAQL query, and [[gtm-to-gads]] for how GTM conversion tracking feeds into these metrics.

## Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `SPREADSHEET_URL` | string | _(required)_ | Full URL of the target Google Sheet |
| `DATE_RANGE` | string | `"LAST_30_DAYS"` | Reporting period. Use `LAST_30_DAYS` or `LAST_MONTH` for monthly runs |
| `MIN_CLICKS` | number | `10` | Minimum clicks for a landing page to appear in the report. Filters out pages with too little data |
| `CAMPAIGN_FILTER` | string | `""` | Campaign name filter. Leave empty for all campaigns |
| `INCLUDE_PAUSED` | boolean | `false` | Whether to include paused campaigns |
| `BENCHMARK_CONV_RATE` | number | `0` | Conversion rate benchmark (e.g., `0.03` for 3%). Set to `0` to auto-calculate from account average |
| `BENCHMARK_CTR` | number | `0` | CTR benchmark. Set to `0` to auto-calculate from account average |
| `FLAG_THRESHOLD_PCT` | number | `0.5` | Flag pages performing below this fraction of the benchmark. `0.5` = flag if below 50% of average |
| `GROUP_BY_PATH` | boolean | `false` | Group URLs by path (ignoring query parameters) |
| `EMAIL_NOTIFICATION` | string | `""` | Email address to notify when report is ready. Leave empty to skip |

## Script

```javascript
/**
 * Landing Page Performance Report
 *
 * Pulls landing page metrics from Google Ads, groups by URL,
 * calculates account-wide benchmarks, and flags underperformers.
 * Exports everything to a formatted Google Sheet.
 *
 * Schedule: Monthly (1st of the month)
 *
 * Setup:
 *   1. Create a Google Sheet and copy the URL
 *   2. Paste this script into Google Ads > Tools > Scripts
 *   3. Update the CONFIG object below
 *   4. Authorize and schedule for monthly
 */

// ============================================================
// CONFIGURATION — edit these values
// ============================================================
var CONFIG = {
  // Google Sheet URL (create a blank sheet first)
  SPREADSHEET_URL: "https://docs.google.com/spreadsheets/d/YOUR_SHEET_ID/edit",

  // Date range for the report
  // For monthly runs: LAST_30_DAYS or LAST_MONTH
  DATE_RANGE: "LAST_30_DAYS",

  // Minimum clicks for a landing page to appear
  MIN_CLICKS: 10,

  // Filter campaigns by name (leave empty for all)
  CAMPAIGN_FILTER: "",

  // Include paused campaigns
  INCLUDE_PAUSED: false,

  // Benchmarks — set to 0 to auto-calculate from account data
  BENCHMARK_CONV_RATE: 0,  // e.g., 0.03 for 3%
  BENCHMARK_CTR: 0,        // e.g., 0.04 for 4%

  // Flag pages below this fraction of the benchmark
  // 0.5 = flag if conversion rate is less than 50% of average
  FLAG_THRESHOLD_PCT: 0.5,

  // Group URLs by path, ignoring query parameters
  GROUP_BY_PATH: false,

  // Email notification (leave empty to skip)
  EMAIL_NOTIFICATION: ""
};

// ============================================================
// MAIN FUNCTION
// ============================================================
function main() {
  var spreadsheet = SpreadsheetApp.openByUrl(CONFIG.SPREADSHEET_URL);

  Logger.log("Starting Landing Page Performance Report...");
  Logger.log("Date range: " + CONFIG.DATE_RANGE);
  Logger.log("Min clicks: " + CONFIG.MIN_CLICKS);

  // Fetch landing page data
  var pages = fetchLandingPages();
  Logger.log("Fetched " + pages.length + " landing pages with " +
    CONFIG.MIN_CLICKS + "+ clicks.");

  // Calculate benchmarks
  var benchmarks = calculateBenchmarks(pages);
  Logger.log("Benchmarks — CTR: " + (benchmarks.ctr * 100).toFixed(2) +
    "%, Conv Rate: " + (benchmarks.convRate * 100).toFixed(2) + "%");

  // Flag underperformers
  flagPages(pages, benchmarks);

  // Write tabs
  writeDetailTab(spreadsheet, pages, benchmarks);
  writeSummaryTab(spreadsheet, pages, benchmarks);
  writeFlaggedTab(spreadsheet, pages, benchmarks);

  // Notify
  if (CONFIG.EMAIL_NOTIFICATION) {
    var accountName = AdsApp.currentAccount().getName();
    var flaggedCount = pages.filter(function(p) { return p.flagged; }).length;
    MailApp.sendEmail({
      to: CONFIG.EMAIL_NOTIFICATION,
      subject: "Landing Page Report Ready — " + accountName,
      body: "Monthly landing page report for " + accountName + ".\n\n" +
        "Total pages: " + pages.length + "\n" +
        "Flagged underperformers: " + flaggedCount + "\n" +
        "Avg conversion rate: " + (benchmarks.convRate * 100).toFixed(2) + "%\n\n" +
        "View report: " + CONFIG.SPREADSHEET_URL
    });
  }

  Logger.log("Landing Page Performance Report complete.");
}

// ============================================================
// FETCH LANDING PAGES
// ============================================================
function fetchLandingPages() {
  var query = "SELECT UnexpandedFinalUrlString, " +
    "Impressions, Clicks, Ctr, Cost, " +
    "Conversions, ConversionRate, CostPerConversion, ConversionValue " +
    "FROM LANDING_PAGE_REPORT " +
    "WHERE Clicks >= " + CONFIG.MIN_CLICKS;

  if (!CONFIG.INCLUDE_PAUSED) {
    query += " AND CampaignStatus = ENABLED";
  }

  if (CONFIG.CAMPAIGN_FILTER) {
    query += " AND CampaignName CONTAINS_IGNORE_CASE '" + CONFIG.CAMPAIGN_FILTER + "'";
  }

  query += " DURING " + CONFIG.DATE_RANGE;

  var report = AdsApp.report(query);
  var rows = report.rows();
  var pageMap = {};

  while (rows.hasNext()) {
    var row = rows.next();
    var url = row["UnexpandedFinalUrlString"];

    // Optionally strip query parameters to group by path
    if (CONFIG.GROUP_BY_PATH) {
      url = stripQueryParams(url);
    }

    if (pageMap[url]) {
      // Aggregate if grouping by path causes duplicates
      var existing = pageMap[url];
      existing.impressions += parseInt(row["Impressions"].replace(/,/g, ""), 10);
      existing.clicks += parseInt(row["Clicks"].replace(/,/g, ""), 10);
      existing.cost += parseFloat(row["Cost"].replace(/,/g, ""));
      existing.conversions += parseFloat(row["Conversions"].replace(/,/g, ""));
      existing.convValue += parseFloat(row["ConversionValue"].replace(/,/g, ""));
    } else {
      pageMap[url] = {
        url: url,
        impressions: parseInt(row["Impressions"].replace(/,/g, ""), 10),
        clicks: parseInt(row["Clicks"].replace(/,/g, ""), 10),
        cost: parseFloat(row["Cost"].replace(/,/g, "")),
        conversions: parseFloat(row["Conversions"].replace(/,/g, "")),
        convValue: parseFloat(row["ConversionValue"].replace(/,/g, "")),
        flagged: false,
        flagReasons: []
      };
    }
  }

  // Convert map to array and recalculate derived metrics
  var pages = [];
  for (var url in pageMap) {
    var p = pageMap[url];
    p.ctr = p.impressions > 0 ? p.clicks / p.impressions : 0;
    p.convRate = p.clicks > 0 ? p.conversions / p.clicks : 0;
    p.cpa = p.conversions > 0 ? p.cost / p.conversions : 0;
    p.roas = p.cost > 0 ? p.convValue / p.cost : 0;
    p.avgCpc = p.clicks > 0 ? p.cost / p.clicks : 0;
    pages.push(p);
  }

  // Sort by cost descending
  pages.sort(function(a, b) { return b.cost - a.cost; });

  return pages;
}

// ============================================================
// CALCULATE BENCHMARKS
// ============================================================
function calculateBenchmarks(pages) {
  var totalImpressions = 0, totalClicks = 0;
  var totalConversions = 0, totalCost = 0, totalConvValue = 0;

  for (var i = 0; i < pages.length; i++) {
    totalImpressions += pages[i].impressions;
    totalClicks += pages[i].clicks;
    totalConversions += pages[i].conversions;
    totalCost += pages[i].cost;
    totalConvValue += pages[i].convValue;
  }

  return {
    ctr: CONFIG.BENCHMARK_CTR > 0
      ? CONFIG.BENCHMARK_CTR
      : (totalImpressions > 0 ? totalClicks / totalImpressions : 0),
    convRate: CONFIG.BENCHMARK_CONV_RATE > 0
      ? CONFIG.BENCHMARK_CONV_RATE
      : (totalClicks > 0 ? totalConversions / totalClicks : 0),
    avgCpa: totalConversions > 0 ? totalCost / totalConversions : 0,
    avgRoas: totalCost > 0 ? totalConvValue / totalCost : 0,
    totalPages: pages.length,
    totalClicks: totalClicks,
    totalConversions: totalConversions,
    totalCost: totalCost,
    totalConvValue: totalConvValue
  };
}

// ============================================================
// FLAG UNDERPERFORMERS
// ============================================================
function flagPages(pages, benchmarks) {
  var threshold = CONFIG.FLAG_THRESHOLD_PCT;

  for (var i = 0; i < pages.length; i++) {
    var p = pages[i];
    p.flagReasons = [];

    // Flag low conversion rate (only if page has enough clicks)
    if (p.clicks >= CONFIG.MIN_CLICKS * 2 && benchmarks.convRate > 0) {
      if (p.convRate < benchmarks.convRate * threshold) {
        p.flagReasons.push("Conv rate " + (p.convRate * 100).toFixed(2) +
          "% vs benchmark " + (benchmarks.convRate * 100).toFixed(2) + "%");
      }
    }

    // Flag low CTR
    if (p.impressions >= 100 && benchmarks.ctr > 0) {
      if (p.ctr < benchmarks.ctr * threshold) {
        p.flagReasons.push("CTR " + (p.ctr * 100).toFixed(2) +
          "% vs benchmark " + (benchmarks.ctr * 100).toFixed(2) + "%");
      }
    }

    // Flag zero conversions with significant spend
    if (p.conversions === 0 && p.cost > benchmarks.avgCpa) {
      p.flagReasons.push("Zero conversions with €" + p.cost.toFixed(2) + " spend");
    }

    // Flag high CPA (more than 2x average)
    if (p.conversions > 0 && benchmarks.avgCpa > 0 && p.cpa > benchmarks.avgCpa * 2) {
      p.flagReasons.push("CPA €" + p.cpa.toFixed(2) +
        " is " + (p.cpa / benchmarks.avgCpa).toFixed(1) + "x average");
    }

    p.flagged = p.flagReasons.length > 0;
  }
}

// ============================================================
// WRITE DETAIL TAB
// ============================================================
function writeDetailTab(spreadsheet, pages, benchmarks) {
  var sheet = getOrCreateSheet(spreadsheet, "Landing Page Detail");
  sheet.clear();

  var headers = [
    "Landing Page URL", "Impressions", "Clicks", "CTR",
    "Cost", "Avg CPC", "Conversions", "Conv. Rate",
    "CPA", "Conv. Value", "ROAS",
    "vs Benchmark CTR", "vs Benchmark Conv Rate", "Flagged"
  ];
  sheet.appendRow(headers);

  for (var i = 0; i < pages.length; i++) {
    var p = pages[i];

    // Calculate performance vs benchmark
    var ctrVsBenchmark = benchmarks.ctr > 0
      ? ((p.ctr / benchmarks.ctr - 1) * 100).toFixed(1) + "%"
      : "—";
    var convVsBenchmark = benchmarks.convRate > 0
      ? ((p.convRate / benchmarks.convRate - 1) * 100).toFixed(1) + "%"
      : "—";

    sheet.appendRow([
      p.url,
      p.impressions,
      p.clicks,
      (p.ctr * 100).toFixed(2) + "%",
      "€ " + p.cost.toFixed(2),
      "€ " + p.avgCpc.toFixed(2),
      p.conversions,
      (p.convRate * 100).toFixed(2) + "%",
      p.conversions > 0 ? "€ " + p.cpa.toFixed(2) : "—",
      "€ " + p.convValue.toFixed(2),
      p.roas > 0 ? p.roas.toFixed(2) + "x" : "—",
      ctrVsBenchmark,
      convVsBenchmark,
      p.flagged ? "YES" : ""
    ]);
  }

  formatHeaderRow(sheet, headers.length, "#1a73e8");

  // Highlight flagged rows in light red
  for (var j = 0; j < pages.length; j++) {
    if (pages[j].flagged) {
      var rowRange = sheet.getRange(j + 2, 1, 1, headers.length);
      rowRange.setBackground("#fce4ec");
    }
  }

  Logger.log("Detail tab: " + pages.length + " rows.");
}

// ============================================================
// WRITE SUMMARY TAB
// ============================================================
function writeSummaryTab(spreadsheet, pages, benchmarks) {
  var sheet = getOrCreateSheet(spreadsheet, "Summary");
  sheet.clear();

  var reportDate = Utilities.formatDate(
    new Date(), AdsApp.currentAccount().getTimeZone(), "yyyy-MM-dd HH:mm"
  );

  var flaggedCount = pages.filter(function(p) { return p.flagged; }).length;

  sheet.appendRow(["Landing Page Performance Summary"]);
  sheet.appendRow(["Report date", reportDate]);
  sheet.appendRow(["Date range", CONFIG.DATE_RANGE]);
  sheet.appendRow(["Account", AdsApp.currentAccount().getName()]);
  sheet.appendRow(["Min clicks threshold", CONFIG.MIN_CLICKS]);
  sheet.appendRow([""]);

  // Benchmark section
  sheet.appendRow(["Account Benchmarks"]);
  sheet.appendRow(["Metric", "Value"]);
  sheet.appendRow(["Average CTR", (benchmarks.ctr * 100).toFixed(2) + "%"]);
  sheet.appendRow(["Average Conversion Rate", (benchmarks.convRate * 100).toFixed(2) + "%"]);
  sheet.appendRow(["Average CPA", "€ " + benchmarks.avgCpa.toFixed(2)]);
  sheet.appendRow(["Average ROAS", benchmarks.avgRoas.toFixed(2) + "x"]);
  sheet.appendRow([""]);

  // Totals section
  sheet.appendRow(["Totals"]);
  sheet.appendRow(["Metric", "Value"]);
  sheet.appendRow(["Total landing pages", benchmarks.totalPages]);
  sheet.appendRow(["Total clicks", benchmarks.totalClicks]);
  sheet.appendRow(["Total conversions", benchmarks.totalConversions]);
  sheet.appendRow(["Total cost", "€ " + benchmarks.totalCost.toFixed(2)]);
  sheet.appendRow(["Total conversion value", "€ " + benchmarks.totalConvValue.toFixed(2)]);
  sheet.appendRow(["Flagged underperformers", flaggedCount]);

  // Format section headers
  sheet.getRange(1, 1).setFontSize(14).setFontWeight("bold");
  sheet.getRange(7, 1).setFontSize(12).setFontWeight("bold");
  sheet.getRange(13, 1).setFontSize(12).setFontWeight("bold");

  // Format sub-headers
  sheet.getRange(8, 1, 1, 2).setFontWeight("bold").setBackground("#e8eaf6");
  sheet.getRange(14, 1, 1, 2).setFontWeight("bold").setBackground("#e8eaf6");

  sheet.autoResizeColumn(1);
  sheet.autoResizeColumn(2);

  Logger.log("Summary tab written.");
}

// ============================================================
// WRITE FLAGGED TAB
// ============================================================
function writeFlaggedTab(spreadsheet, pages, benchmarks) {
  var sheet = getOrCreateSheet(spreadsheet, "Flagged Pages");
  sheet.clear();

  var flagged = pages.filter(function(p) { return p.flagged; });

  var headers = [
    "Landing Page URL", "Clicks", "Conv. Rate",
    "CPA", "Cost", "Conversions",
    "Flag Reasons", "Suggested Action"
  ];
  sheet.appendRow(headers);

  for (var i = 0; i < flagged.length; i++) {
    var p = flagged[i];

    // Generate a suggested action based on the flags
    var action = suggestAction(p, benchmarks);

    sheet.appendRow([
      p.url,
      p.clicks,
      (p.convRate * 100).toFixed(2) + "%",
      p.conversions > 0 ? "€ " + p.cpa.toFixed(2) : "—",
      "€ " + p.cost.toFixed(2),
      p.conversions,
      p.flagReasons.join("; "),
      action
    ]);
  }

  formatHeaderRow(sheet, headers.length, "#c62828");

  Logger.log("Flagged tab: " + flagged.length + " rows.");
}

/**
 * Suggests an action based on the page's performance issues.
 */
function suggestAction(page, benchmarks) {
  if (page.conversions === 0 && page.cost > benchmarks.avgCpa * 2) {
    return "Pause ads to this page or redesign landing page";
  }
  if (page.conversions === 0) {
    return "Review page for conversion barriers (forms, CTAs, load speed)";
  }
  if (page.cpa > benchmarks.avgCpa * 2) {
    return "High CPA — test alternative landing page or tighten keyword targeting";
  }
  if (page.ctr < benchmarks.ctr * CONFIG.FLAG_THRESHOLD_PCT) {
    return "Low CTR — review ad copy relevance to this page";
  }
  if (page.convRate < benchmarks.convRate * CONFIG.FLAG_THRESHOLD_PCT) {
    return "Low conv rate — check page speed, mobile UX, and form completion flow";
  }
  return "Investigate further";
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

/**
 * Strips query parameters from a URL.
 * "https://example.com/page?utm_source=google" → "https://example.com/page"
 */
function stripQueryParams(url) {
  var qIndex = url.indexOf("?");
  if (qIndex !== -1) {
    return url.substring(0, qIndex);
  }
  return url;
}
```

## Setup Instructions

1. **Create the Google Sheet**
   - Go to [sheets.google.com](https://sheets.google.com) and create a new blank spreadsheet
   - Name it "Landing Page Performance — [Client Name]"
   - Copy the full URL

2. **Create the script**
   - In Google Ads, go to **Tools & Settings > Bulk actions > Scripts**
   - Click **+** to create a new script
   - Name it "Landing Page Performance Report"
   - Paste the full script above

3. **Configure**
   - Set `SPREADSHEET_URL` to your Sheet URL
   - Set `MIN_CLICKS` — for smaller accounts, lower to `5`; for high-traffic accounts, raise to `25` to focus on statistically meaningful pages
   - Set benchmark overrides if you have industry-specific targets, or leave at `0` for auto-calculation

4. **Authorize and test**
   - Click **Authorize** and grant access
   - Click **Preview** to dry-run. Check the Logger for page counts and benchmark values
   - Verify the four tabs in the Sheet: Landing Page Detail, Summary, Flagged Pages

5. **Schedule**
   - Set frequency to **Monthly**
   - The script works best on the 1st of the month with `DATE_RANGE: "LAST_MONTH"` for clean month-over-month comparison

> [!tip] Tracking specialist note
> Landing page performance is where your tracking expertise directly impacts campaign decisions. If conversion rates look off, check whether the GTM container on that landing page is firing correctly. Use [[gtm-to-gads]] to verify the full conversion path from page view through to Google Ads conversion action.

## Customization Guide

### Use `LAST_MONTH` for clean monthly reports

Change `DATE_RANGE` to `"LAST_MONTH"` so each report covers an exact calendar month. This makes month-over-month comparison straightforward.

### Group pages by domain or path segment

Enable `GROUP_BY_PATH: true` to strip query parameters (UTM tags, session IDs, etc.). For grouping by path prefix (e.g., `/products/` vs `/blog/`), replace the `stripQueryParams` function:

```javascript
function stripQueryParams(url) {
  // Strip query params
  var qIndex = url.indexOf("?");
  if (qIndex !== -1) {
    url = url.substring(0, qIndex);
  }
  // Group by first path segment
  try {
    var parts = url.split("/");
    // Keep scheme + domain + first path segment
    return parts.slice(0, 4).join("/") + "/";
  } catch (e) {
    return url;
  }
}
```

### Add page speed indicators

Google Ads doesn't expose page speed in its reporting API, but you can add a column that flags known slow pages from an external source:

```javascript
// Add a "slow pages" list to CONFIG
var SLOW_PAGES = [
  "https://example.com/heavy-page",
  "https://example.com/old-landing-page"
];

// In writeDetailTab, check against the list
var isSlowPage = SLOW_PAGES.indexOf(p.url) !== -1;
// Add "SLOW" to the flagReasons if applicable
```

For automated page speed checks, use `UrlFetchApp` to call the PageSpeed Insights API:

```javascript
function checkPageSpeed(url) {
  var apiUrl = "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=" +
    encodeURIComponent(url) + "&strategy=mobile";
  var response = UrlFetchApp.fetch(apiUrl);
  var data = JSON.parse(response.getContentText());
  return data.lighthouseResult.categories.performance.score * 100;
}
```

> [!warning] API limits
> Google Ads Scripts allow 50 `UrlFetchApp` calls per execution. If you have more than 50 landing pages, either sample the top pages by cost or run the speed check as a separate script.

### Add historical tracking

To track landing page performance over time, modify the script to append monthly snapshots instead of overwriting:

```javascript
// Replace getOrCreateSheet calls with date-stamped tabs
var monthLabel = Utilities.formatDate(new Date(),
  AdsApp.currentAccount().getTimeZone(), "yyyy-MM");
var sheet = spreadsheet.insertSheet("Detail — " + monthLabel);
```

This creates a new tab each month (e.g., "Detail — 2026-03"), preserving historical data for trend analysis.

### Connect to GTM/sGTM health checks

As a tracking specialist, you can cross-reference flagged pages with your GTM container. Pages with zero conversions but healthy click volume often indicate a tracking problem rather than a landing page problem. Check:

1. Is the GTM container snippet present on the page?
2. Is the conversion tag firing in GTM debug mode?
3. Is the sGTM endpoint receiving the conversion event?
4. Is consent mode blocking the tag for some users?

See [[gtm-to-gads]] and [[sgtm-to-gads]] for the full diagnostic flow.
