---
title: "Day Parting Bid Adjustments"
date: 2026-03-31
tags:
  - reference
  - scripts
  - bidding
---

# Day Parting Bid Adjustments

Analyzes hourly and day-of-week performance data, then applies ad schedule bid modifiers to campaigns. Shifts budget toward hours and days that convert best.

- **Source:** Adapted from Czarto/Adwords-Scripts bidding patterns
- **Schedule:** Daily
- **Runtime:** ~5 minutes for accounts with <50 campaigns

> [!info] How It Works
> The script pulls performance stats per hour-of-day and day-of-week over a configurable lookback period, calculates a performance index (conversion rate relative to account average), then translates that index into a bid modifier. Modifiers are capped to prevent extreme swings.

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `LOOKBACK_DAYS` | `30` | Days of historical data to analyze |
| `MAX_BID_INCREASE` | `0.50` | Maximum positive bid adjustment (50%) |
| `MAX_BID_DECREASE` | `-0.30` | Maximum negative bid adjustment (-30%) |
| `MIN_IMPRESSIONS` | `100` | Minimum impressions per time slot before applying adjustment |
| `MIN_CLICKS` | `10` | Minimum clicks per time slot before applying adjustment |
| `CAMPAIGN_LABEL` | `"DayParting"` | Only campaigns with this label are affected. Set to `""` to target all enabled campaigns |
| `SPREADSHEET_URL` | `""` | Optional Google Sheets URL for logging adjustments. Leave empty to skip logging |
| `EMAIL_RECIPIENT` | `""` | Optional email address for summary report. Leave empty to skip |

## Script

```javascript
/**
 * Day Parting Bid Adjustments
 *
 * Analyzes hourly performance over a lookback window and sets
 * ad schedule bid modifiers per campaign. Campaigns must have
 * the configured label (or leave CAMPAIGN_LABEL empty for all).
 *
 * Adapted from Czarto/Adwords-Scripts bidding patterns.
 *
 * Schedule: Daily
 */

// ── Configuration ──────────────────────────────────────────────
var CONFIG = {
  LOOKBACK_DAYS:     30,
  MAX_BID_INCREASE:  0.50,   // +50%
  MAX_BID_DECREASE:  -0.30,  // -30%
  MIN_IMPRESSIONS:   100,
  MIN_CLICKS:        10,
  CAMPAIGN_LABEL:    "DayParting",
  SPREADSHEET_URL:   "",
  EMAIL_RECIPIENT:   ""
};

// ── Main ───────────────────────────────────────────────────────
function main() {
  var campaigns = getCampaigns();
  var adjustmentLog = [];

  while (campaigns.hasNext()) {
    var campaign = campaigns.next();
    var campaignName = campaign.getName();
    Logger.log("Processing campaign: " + campaignName);

    var hourlyStats = getHourlyStats(campaign);
    var accountAvgCvr = calculateAccountAverageCvr(hourlyStats);

    if (accountAvgCvr === 0) {
      Logger.log("  Skipping — no conversions in lookback window");
      continue;
    }

    var adjustments = calculateAdjustments(hourlyStats, accountAvgCvr);
    applyAdScheduleModifiers(campaign, adjustments);

    for (var key in adjustments) {
      adjustmentLog.push({
        campaign: campaignName,
        dayHour: key,
        modifier: adjustments[key]
      });
    }
  }

  if (CONFIG.SPREADSHEET_URL) {
    logToSpreadsheet(adjustmentLog);
  }

  if (CONFIG.EMAIL_RECIPIENT) {
    sendSummaryEmail(adjustmentLog);
  }

  Logger.log("Day parting adjustments complete. " +
    adjustmentLog.length + " modifiers set.");
}

// ── Campaign Selection ─────────────────────────────────────────
function getCampaigns() {
  var selector = AdsApp.campaigns()
    .withCondition("Status = ENABLED");

  if (CONFIG.CAMPAIGN_LABEL) {
    selector = selector.withCondition(
      "LabelNames CONTAINS_ANY ['" + CONFIG.CAMPAIGN_LABEL + "']"
    );
  }

  return selector.get();
}

// ── Performance Data ───────────────────────────────────────────
function getHourlyStats(campaign) {
  var dateRange = getDateRange(CONFIG.LOOKBACK_DAYS);
  var query =
    "SELECT HourOfDay, DayOfWeek, Impressions, Clicks, Conversions, Cost " +
    "FROM CAMPAIGN_PERFORMANCE_REPORT " +
    "WHERE CampaignId = " + campaign.getId() + " " +
    "DURING " + dateRange;

  var report = AdsApp.report(query);
  var rows = report.rows();
  var stats = {};

  while (rows.hasNext()) {
    var row = rows.next();
    var key = row["DayOfWeek"] + "_" + row["HourOfDay"];

    if (!stats[key]) {
      stats[key] = {
        impressions: 0,
        clicks: 0,
        conversions: 0,
        cost: 0,
        day: row["DayOfWeek"],
        hour: parseInt(row["HourOfDay"], 10)
      };
    }

    stats[key].impressions += parseInt(row["Impressions"], 10);
    stats[key].clicks += parseInt(row["Clicks"], 10);
    stats[key].conversions += parseFloat(row["Conversions"]);
    stats[key].cost += parseFloat(row["Cost"].replace(/,/g, ""));
  }

  return stats;
}

// ── Calculations ───────────────────────────────────────────────
function calculateAccountAverageCvr(hourlyStats) {
  var totalClicks = 0;
  var totalConversions = 0;

  for (var key in hourlyStats) {
    totalClicks += hourlyStats[key].clicks;
    totalConversions += hourlyStats[key].conversions;
  }

  return totalClicks > 0 ? totalConversions / totalClicks : 0;
}

function calculateAdjustments(hourlyStats, accountAvgCvr) {
  var adjustments = {};

  for (var key in hourlyStats) {
    var slot = hourlyStats[key];

    // Skip time slots without enough data
    if (slot.impressions < CONFIG.MIN_IMPRESSIONS ||
        slot.clicks < CONFIG.MIN_CLICKS) {
      continue;
    }

    var slotCvr = slot.clicks > 0 ? slot.conversions / slot.clicks : 0;

    // Performance index: how this slot compares to account average
    // 1.0 = average, 1.5 = 50% better, 0.7 = 30% worse
    var performanceIndex = slotCvr / accountAvgCvr;

    // Convert index to bid modifier
    // performanceIndex of 1.0 → 0% adjustment
    // performanceIndex of 1.5 → +50% (capped)
    // performanceIndex of 0.5 → -50% (capped to MAX_BID_DECREASE)
    var modifier = performanceIndex - 1.0;

    // Apply caps
    modifier = Math.min(modifier, CONFIG.MAX_BID_INCREASE);
    modifier = Math.max(modifier, CONFIG.MAX_BID_DECREASE);

    // Round to 2 decimal places
    modifier = Math.round(modifier * 100) / 100;

    adjustments[key] = modifier;
  }

  return adjustments;
}

// ── Apply Modifiers ────────────────────────────────────────────
function applyAdScheduleModifiers(campaign, adjustments) {
  // Map day names to AdsApp day constants
  var dayMap = {
    "Monday": "MONDAY",
    "Tuesday": "TUESDAY",
    "Wednesday": "WEDNESDAY",
    "Thursday": "THURSDAY",
    "Friday": "FRIDAY",
    "Saturday": "SATURDAY",
    "Sunday": "SUNDAY"
  };

  // Remove existing ad schedules first
  var existingSchedules = campaign.targeting().adSchedules().get();
  while (existingSchedules.hasNext()) {
    existingSchedules.next().remove();
  }

  // Group adjustments by day, then set schedules per hour block
  var dayHours = {};
  for (var key in adjustments) {
    var parts = key.split("_");
    var day = parts[0];
    var hour = parseInt(parts[1], 10);

    if (!dayHours[day]) {
      dayHours[day] = {};
    }
    dayHours[day][hour] = adjustments[key];
  }

  for (var day in dayHours) {
    for (var hour in dayHours[day]) {
      var hourInt = parseInt(hour, 10);
      var modifier = dayHours[day][hour];

      // Bid modifier is expressed as multiplier (1.0 = no change)
      var bidModifier = 1.0 + modifier;

      campaign.addAdSchedule({
        dayOfWeek: dayMap[day],
        startHour: hourInt,
        startMinute: 0,
        endHour: (hourInt + 1) % 24,
        endMinute: 0,
        bidModifier: bidModifier
      });
    }
  }

  Logger.log("  Applied " + Object.keys(adjustments).length + " schedule modifiers");
}

// ── Logging ────────────────────────────────────────────────────
function logToSpreadsheet(adjustmentLog) {
  var ss = SpreadsheetApp.openByUrl(CONFIG.SPREADSHEET_URL);
  var sheet = ss.getSheetByName("DayParting") || ss.insertSheet("DayParting");

  // Write header if sheet is empty
  if (sheet.getLastRow() === 0) {
    sheet.appendRow(["Date", "Campaign", "Day_Hour", "Modifier"]);
  }

  var today = Utilities.formatDate(new Date(), AdsApp.currentAccount().getTimeZone(), "yyyy-MM-dd");

  for (var i = 0; i < adjustmentLog.length; i++) {
    sheet.appendRow([
      today,
      adjustmentLog[i].campaign,
      adjustmentLog[i].dayHour,
      adjustmentLog[i].modifier
    ]);
  }
}

function sendSummaryEmail(adjustmentLog) {
  var body = "Day Parting Bid Adjustments Summary\n";
  body += "Date: " + new Date().toISOString().split("T")[0] + "\n";
  body += "Lookback: " + CONFIG.LOOKBACK_DAYS + " days\n\n";

  var campaigns = {};
  for (var i = 0; i < adjustmentLog.length; i++) {
    var entry = adjustmentLog[i];
    if (!campaigns[entry.campaign]) {
      campaigns[entry.campaign] = 0;
    }
    campaigns[entry.campaign]++;
  }

  for (var name in campaigns) {
    body += name + ": " + campaigns[name] + " modifiers applied\n";
  }

  MailApp.sendEmail({
    to: CONFIG.EMAIL_RECIPIENT,
    subject: "Day Parting Adjustments — " + new Date().toISOString().split("T")[0],
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

  return format(startDate) + "," + format(endDate);
}
```

## Setup Instructions

1. **Label your campaigns** — In Google Ads, create a label called `DayParting` and apply it to campaigns you want to manage. Or set `CAMPAIGN_LABEL` to `""` to target all enabled campaigns.

2. **Create the script** — Go to Google Ads → Tools → Bulk actions → Scripts → New script. Paste the full script above.

3. **Set the CONFIG values** — At minimum, review `MAX_BID_INCREASE` and `MAX_BID_DECREASE` to match your risk tolerance. For new accounts, start conservative: `+0.30` / `-0.20`.

4. **Optional: Create a log spreadsheet** — Create a new Google Sheet, copy its URL into `SPREADSHEET_URL`. The script will create a "DayParting" tab automatically.

5. **Preview first** — Click "Preview" in the script editor to see what changes the script would make without applying them. Review the Logger output.

6. **Schedule** — Set to run daily, ideally early morning before the new day's traffic starts.

> [!warning] First Run
> The first run removes all existing ad schedules on targeted campaigns and replaces them with performance-based modifiers. If you have manually set ad schedules, back them up first.

## Customization Guide

### Adjusting Aggressiveness

The `MAX_BID_INCREASE` and `MAX_BID_DECREASE` caps control how far the script will push modifiers. Conservative settings for new implementations:

```javascript
MAX_BID_INCREASE:  0.25,   // +25% max
MAX_BID_DECREASE:  -0.15,  // -15% max
```

Aggressive settings for mature accounts with stable data:

```javascript
MAX_BID_INCREASE:  0.75,   // +75% max
MAX_BID_DECREASE:  -0.50,  // -50% max
```

### Changing the Performance Metric

The default uses conversion rate (CVR) as the performance index. To use ROAS instead, modify `calculateAdjustments`:

```javascript
// Replace slotCvr calculation with ROAS
var slotRoas = slot.cost > 0 ? (slot.conversions * YOUR_AVG_CONV_VALUE) / slot.cost : 0;
var performanceIndex = slotRoas / accountAvgRoas;
```

### Excluding Specific Hours

To completely pause ads during certain hours (e.g., 1am–5am), add a blackout list in the CONFIG and set modifier to `-1.0` for those hours:

```javascript
BLACKOUT_HOURS: [1, 2, 3, 4],  // Add to CONFIG

// Then in calculateAdjustments, before the modifier calculation:
if (CONFIG.BLACKOUT_HOURS.indexOf(slot.hour) !== -1) {
  adjustments[key] = -1.0;  // -100% = no serving
  continue;
}
```

### Campaign-Level vs Account-Level Analysis

The default analyzes each campaign individually. For accounts with low-volume campaigns, you may get better data by analyzing at the account level. Change `getHourlyStats` to remove the `CampaignId` filter and apply the same modifiers to all campaigns.

## Related

- [[catalog|Scripts Catalog]] — Full script index
- [[ads-scripts-api|Google Ads Scripts API Reference]] — API documentation
- [[bidding-strategies|Bidding Strategies]] — When to use manual vs automated bidding
