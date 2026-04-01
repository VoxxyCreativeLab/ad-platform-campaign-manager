---
title: Budget Pacing Alert Script
date: 2026-03-31
tags:
  - reference
  - scripts
  - monitoring
---

# Budget Pacing Alert Script

Sends an email alert when campaigns are over-pacing or under-pacing against their daily budget. Compares actual spend to expected spend based on the fraction of the day elapsed (or fraction of the month elapsed for monthly budgets). Helps catch runaway spend or stalled campaigns before they waste budget or miss goals.

> [!info] Source
> Adapted from the [Brainlabs-Digital/Google-Ads-Scripts](https://github.com/Brainlabs-Digital/Google-Ads-Scripts) budget monitoring pattern.

**Schedule:** Daily (recommended: run at 14:00 or later so enough of the day has elapsed for meaningful comparison)

## Configuration

| Variable | Type | Default | Description |
|---|---|---|---|
| `OVERPACE_THRESHOLD` | Number | `1.2` | Alert when spend exceeds this fraction of expected pace (1.2 = 120%) |
| `UNDERPACE_THRESHOLD` | Number | `0.5` | Alert when spend is below this fraction of expected pace (0.5 = 50%) |
| `EMAIL_RECIPIENTS` | String | `""` | Comma-separated email addresses to receive alerts |
| `CAMPAIGN_LABEL` | String | `""` | Only check campaigns with this label. Leave empty for all enabled campaigns |
| `INCLUDE_PAUSED` | Boolean | `false` | Whether to include paused campaigns in the check |
| `DATE_RANGE_DAYS` | Number | `1` | Number of days to look back for spend data (1 = today only) |

## Script

```javascript
/**
 * Budget Pacing Alert
 *
 * Compares actual campaign spend against expected daily pacing.
 * Sends an email alert listing campaigns that are significantly
 * over-pacing or under-pacing their budget.
 *
 * Adapted from Brainlabs-Digital/Google-Ads-Scripts budget monitoring pattern.
 *
 * Schedule: Daily (ideally afternoon, after enough spend data accumulates)
 */
function main() {
  // ===================== CONFIGURATION =====================
  var CONFIG = {
    // Alert when spend exceeds this fraction of expected pace (1.2 = 120%)
    OVERPACE_THRESHOLD: 1.2,

    // Alert when spend is below this fraction of expected pace (0.5 = 50%)
    UNDERPACE_THRESHOLD: 0.5,

    // Comma-separated email addresses
    EMAIL_RECIPIENTS: "you@example.com",

    // Only check campaigns with this label (empty = all enabled campaigns)
    CAMPAIGN_LABEL: "",

    // Include paused campaigns in the check
    INCLUDE_PAUSED: false,

    // Days to look back (1 = today only)
    DATE_RANGE_DAYS: 1
  };
  // =========================================================

  var now = new Date();
  var hourOfDay = now.getHours();
  var fractionOfDay = hourOfDay / 24;

  // Avoid divide-by-zero early in the day
  if (fractionOfDay < 0.1) {
    Logger.log("Too early in the day for meaningful pacing data. Exiting.");
    return;
  }

  var overpaced = [];
  var underpaced = [];

  // Build campaign selector
  var selector = AdsApp.campaigns()
    .withCondition("Status = ENABLED");

  if (!CONFIG.INCLUDE_PAUSED) {
    selector = selector.withCondition("CampaignStatus = ENABLED");
  }

  if (CONFIG.CAMPAIGN_LABEL !== "") {
    selector = selector.withCondition("LabelNames CONTAINS_ANY ['" + CONFIG.CAMPAIGN_LABEL + "']");
  }

  var campaigns = selector.get();

  while (campaigns.hasNext()) {
    var campaign = campaigns.next();
    var campaignName = campaign.getName();
    var budget = campaign.getBudget().getAmount();

    // Get today's stats
    var stats = campaign.getStatsFor("TODAY");
    var spend = stats.getCost();

    // Calculate expected spend based on time of day
    var expectedSpend = budget * fractionOfDay;

    // Skip campaigns with no budget set
    if (budget <= 0) {
      Logger.log("Skipping " + campaignName + " — no budget set.");
      continue;
    }

    var paceRatio = spend / expectedSpend;

    if (paceRatio > CONFIG.OVERPACE_THRESHOLD) {
      overpaced.push({
        name: campaignName,
        budget: budget,
        spend: spend,
        expected: expectedSpend,
        pacePercent: Math.round(paceRatio * 100)
      });
    } else if (paceRatio < CONFIG.UNDERPACE_THRESHOLD && spend > 0) {
      underpaced.push({
        name: campaignName,
        budget: budget,
        spend: spend,
        expected: expectedSpend,
        pacePercent: Math.round(paceRatio * 100)
      });
    }
  }

  // Build alert email
  if (overpaced.length === 0 && underpaced.length === 0) {
    Logger.log("All campaigns are pacing normally.");
    return;
  }

  var subject = "Google Ads Budget Pacing Alert — " + _formatDate(now);
  var body = "Budget Pacing Alert\n";
  body += "Checked at " + now.toLocaleTimeString() + " (" + Math.round(fractionOfDay * 100) + "% of day elapsed)\n\n";

  if (overpaced.length > 0) {
    body += "=== OVERPACING CAMPAIGNS ===\n\n";
    for (var i = 0; i < overpaced.length; i++) {
      var o = overpaced[i];
      body += "  " + o.name + "\n";
      body += "    Budget: " + _currency(o.budget) + " | Spend: " + _currency(o.spend);
      body += " | Expected: " + _currency(o.expected) + " | Pace: " + o.pacePercent + "%\n\n";
    }
  }

  if (underpaced.length > 0) {
    body += "=== UNDERPACING CAMPAIGNS ===\n\n";
    for (var j = 0; j < underpaced.length; j++) {
      var u = underpaced[j];
      body += "  " + u.name + "\n";
      body += "    Budget: " + _currency(u.budget) + " | Spend: " + _currency(u.spend);
      body += " | Expected: " + _currency(u.expected) + " | Pace: " + u.pacePercent + "%\n\n";
    }
  }

  body += "---\nGenerated by Budget Pacing Alert script.";

  MailApp.sendEmail({
    to: CONFIG.EMAIL_RECIPIENTS,
    subject: subject,
    body: body
  });

  Logger.log("Alert sent to " + CONFIG.EMAIL_RECIPIENTS);
  Logger.log("Overpaced: " + overpaced.length + " | Underpaced: " + underpaced.length);
}

/**
 * Formats a number as currency string.
 */
function _currency(amount) {
  return "€" + amount.toFixed(2);
}

/**
 * Formats a Date object as YYYY-MM-DD.
 */
function _formatDate(date) {
  var year = date.getFullYear();
  var month = ("0" + (date.getMonth() + 1)).slice(-2);
  var day = ("0" + date.getDate()).slice(-2);
  return year + "-" + month + "-" + day;
}
```

## Setup Instructions

1. In Google Ads, go to **Tools → Bulk actions → Scripts**
2. Click **+ New script**
3. Name it `Budget Pacing Alert`
4. Paste the script above
5. Update `CONFIG.EMAIL_RECIPIENTS` with your actual email address(es)
6. Optionally set `CONFIG.CAMPAIGN_LABEL` if you only want to monitor specific campaigns
7. Click **Preview** to test the script without sending emails (check Logger output)
8. Click **Authorize** when prompted to grant email and account access
9. Set the schedule to **Daily** at a time after noon (e.g., 14:00)
10. Click **Save**

> [!warning] First Run
> On the first run, Google will ask you to authorize the script to access your Google Ads data and send emails. Review and accept the permissions.

## Customization Guide

### Adjusting Thresholds

The default thresholds (120% overpace, 50% underpace) are conservative starting points. For high-budget campaigns where even small deviations matter, tighten them:

```javascript
OVERPACE_THRESHOLD: 1.1,   // Alert at 110% of expected pace
UNDERPACE_THRESHOLD: 0.7,  // Alert at 70% of expected pace
```

### Label Filtering

To monitor only specific campaigns, apply a label in Google Ads (e.g., `Monitor-Budget`) and set:

```javascript
CAMPAIGN_LABEL: "Monitor-Budget",
```

### Adding Slack Notifications

Replace the `MailApp.sendEmail` call with a Slack webhook:

```javascript
var payload = JSON.stringify({ text: body });
UrlFetchApp.fetch("https://hooks.slack.com/services/YOUR/WEBHOOK/URL", {
  method: "post",
  contentType: "application/json",
  payload: payload
});
```

### Currency Symbol

The `_currency()` helper defaults to `€`. Change to your local currency:

```javascript
function _currency(amount) {
  return "$" + amount.toFixed(2);
}
```

## Related

- [[catalog|Scripts Catalog]] — full index of all scripts
- [[quality-score-monitor]] — another daily monitoring script
- [[conversion-drop-alert]] — alerts on conversion drops
