---
title: "PMax Category Label Script"
date: 2026-03-31
tags:
  - reference
  - scripts
  - pmax
---

# PMax Category Label Script

Auto-labels Performance Max campaigns based on their top search term categories. Since PMax campaigns are opaque by design, labels provide a way to quickly see what each campaign is actually targeting in the Google Ads UI — without opening a report every time.

**Source pattern:** agencysavvy/pmax
**Schedule:** Daily
**Runtime:** ~1–3 minutes

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `CAMPAIGN_NAME_CONTAINS` | `""` | Filter to PMax campaigns matching this string. Empty = all PMax campaigns. |
| `LABEL_PREFIX` | `"PMax: "` | Prefix for auto-generated labels. E.g., `"PMax: running shoes"`. |
| `MAX_LABELS_PER_CAMPAIGN` | `3` | Maximum number of category labels to apply per campaign. Uses the top N categories by impressions. |
| `MIN_IMPRESSION_SHARE` | `0.05` | Minimum share of total campaign impressions for a category to get a label (0.05 = 5%). |
| `DATE_RANGE` | `"LAST_7_DAYS"` | Date range for determining top categories. |
| `CLEAN_OLD_LABELS` | `true` | Remove previously applied category labels before applying new ones. Keeps labels current. |
| `SPREADSHEET_URL` | `""` | Optional Google Sheets URL to log label changes. Leave empty to skip logging. |
| `EMAIL_RECIPIENTS` | `""` | Comma-separated email addresses for notification. |

## Script

```javascript
/**
 * PMax Category Label Script
 *
 * Auto-labels PMax campaigns based on their top search term categories.
 * Labels are visible in the Google Ads UI, making it easy to see at a
 * glance what each PMax campaign is targeting.
 *
 * Source pattern: agencysavvy/pmax
 * Schedule: Daily
 */

// ============================================================
// CONFIGURATION — Edit these values
// ============================================================
var CONFIG = {
  CAMPAIGN_NAME_CONTAINS: "",
  LABEL_PREFIX: "PMax: ",
  MAX_LABELS_PER_CAMPAIGN: 3,
  MIN_IMPRESSION_SHARE: 0.05,
  DATE_RANGE: "LAST_7_DAYS",
  CLEAN_OLD_LABELS: true,
  SPREADSHEET_URL: "",
  EMAIL_RECIPIENTS: ""
};

function main() {
  var sheet = null;
  if (CONFIG.SPREADSHEET_URL) {
    var spreadsheet = SpreadsheetApp.openByUrl(CONFIG.SPREADSHEET_URL);
    sheet = getOrCreateSheet(spreadsheet, "Label Changes");
    if (sheet.getLastRow() === 0) {
      setupSheet(sheet);
    }
  }

  var today = Utilities.formatDate(new Date(), "GMT", "yyyy-MM-dd");

  // Step 1: Get search term categories per PMax campaign
  var campaignCategories = getCampaignCategories();

  // Step 2: For each campaign, determine top categories and apply labels
  var changes = [];

  for (var campaignName in campaignCategories) {
    var categories = campaignCategories[campaignName];
    var campaignId = categories.campaignId;

    // Calculate total impressions for this campaign's categories
    var totalImpressions = 0;
    for (var i = 0; i < categories.data.length; i++) {
      totalImpressions += categories.data[i].impressions;
    }

    // Sort by impressions descending
    categories.data.sort(function(a, b) {
      return b.impressions - a.impressions;
    });

    // Select top categories that meet the impression share threshold
    var topCategories = [];
    for (var j = 0; j < categories.data.length && topCategories.length < CONFIG.MAX_LABELS_PER_CAMPAIGN; j++) {
      var cat = categories.data[j];
      var share = totalImpressions > 0 ? cat.impressions / totalImpressions : 0;
      if (share >= CONFIG.MIN_IMPRESSION_SHARE) {
        topCategories.push({
          category: cat.category,
          impressions: cat.impressions,
          share: share
        });
      }
    }

    // Get the campaign object
    var campaignIterator = AdsApp.campaigns()
      .withCondition("Name = '" + escapeQuotes(campaignName) + "'")
      .get();

    if (!campaignIterator.hasNext()) continue;
    var campaign = campaignIterator.next();

    // Clean old category labels if configured
    if (CONFIG.CLEAN_OLD_LABELS) {
      var existingLabels = campaign.labels().get();
      while (existingLabels.hasNext()) {
        var label = existingLabels.next();
        if (label.getName().indexOf(CONFIG.LABEL_PREFIX) === 0) {
          campaign.removeLabel(label.getName());
          changes.push({
            date: today,
            campaign: campaignName,
            action: "REMOVED",
            label: label.getName(),
            reason: "Cleaning old label"
          });
        }
      }
    }

    // Apply new category labels
    for (var k = 0; k < topCategories.length; k++) {
      var labelName = CONFIG.LABEL_PREFIX + topCategories[k].category;

      // Ensure the label exists in the account
      ensureLabelExists(labelName);

      // Apply to campaign
      campaign.applyLabel(labelName);

      changes.push({
        date: today,
        campaign: campaignName,
        action: "APPLIED",
        label: labelName,
        reason: topCategories[k].impressions + " impr (" +
                (topCategories[k].share * 100).toFixed(1) + "% share)"
      });
    }

    // Log campaigns with no qualifying categories
    if (topCategories.length === 0) {
      changes.push({
        date: today,
        campaign: campaignName,
        action: "NO LABELS",
        label: "—",
        reason: "No categories met the " + (CONFIG.MIN_IMPRESSION_SHARE * 100) + "% impression share threshold"
      });
    }
  }

  // Write log to sheet
  if (sheet) {
    writeChanges(sheet, changes);
  }

  Logger.log("Processed " + Object.keys(campaignCategories).length + " PMax campaigns. " +
             changes.length + " label changes.");

  // Email notification
  if (CONFIG.EMAIL_RECIPIENTS && changes.length > 0) {
    var appliedChanges = changes.filter(function(c) { return c.action === "APPLIED"; });
    var summary = appliedChanges.map(function(c) {
      return "  - " + c.campaign + " → " + c.label + " (" + c.reason + ")";
    }).join("\n");

    MailApp.sendEmail({
      to: CONFIG.EMAIL_RECIPIENTS,
      subject: "PMax Labels Updated: " + appliedChanges.length + " labels applied",
      body: "Updated PMax campaign labels based on search term categories.\n\n" +
            "Labels applied:\n" + (summary || "  (none)") + "\n\n" +
            (CONFIG.SPREADSHEET_URL ? "Full log: " + CONFIG.SPREADSHEET_URL : "")
    });
  }
}

/**
 * Retrieves search term categories grouped by PMax campaign.
 */
function getCampaignCategories() {
  var query =
    "SELECT " +
    "  campaign.name, " +
    "  campaign.id, " +
    "  campaign_search_term_insight.category_label, " +
    "  metrics.impressions " +
    "FROM campaign_search_term_insight " +
    "WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX' " +
    "  AND metrics.impressions > 0";

  if (CONFIG.CAMPAIGN_NAME_CONTAINS) {
    query += " AND campaign.name LIKE '%" + CONFIG.CAMPAIGN_NAME_CONTAINS + "%'";
  }

  query += " ORDER BY metrics.impressions DESC";

  var campaignCategories = {};

  try {
    var results = AdsApp.search(query);
    while (results.hasNext()) {
      var row = results.next();
      var campName = row.campaign.name;

      if (!campaignCategories[campName]) {
        campaignCategories[campName] = {
          campaignId: row.campaign.id,
          data: []
        };
      }

      campaignCategories[campName].data.push({
        category: row.campaignSearchTermInsight.categoryLabel,
        impressions: row.metrics.impressions || 0
      });
    }
  } catch (e) {
    Logger.log("Error querying search term insights: " + e.message);
  }

  return campaignCategories;
}

/**
 * Creates a label if it doesn't already exist.
 */
function ensureLabelExists(labelName) {
  var labels = AdsApp.labels().withCondition("Name = '" + escapeQuotes(labelName) + "'").get();
  if (!labels.hasNext()) {
    AdsApp.createLabel(labelName, "Auto-generated PMax category label", "#4285F4");
  }
}

/**
 * Escapes single quotes for use in AdsApp conditions.
 */
function escapeQuotes(str) {
  return str.replace(/'/g, "\\'");
}

/**
 * Gets or creates a named sheet tab.
 */
function getOrCreateSheet(spreadsheet, sheetName) {
  var sheet = spreadsheet.getSheetByName(sheetName);
  if (!sheet) {
    sheet = spreadsheet.insertSheet(sheetName);
  }
  return sheet;
}

/**
 * Sets up the log sheet header row.
 */
function setupSheet(sheet) {
  sheet.clear();
  sheet.appendRow([
    "Date",
    "Campaign",
    "Action",
    "Label",
    "Reason"
  ]);
  sheet.getRange("1:1").setFontWeight("bold");
  sheet.setFrozenRows(1);
}

/**
 * Writes label change log entries to the sheet.
 */
function writeChanges(sheet, changes) {
  for (var i = 0; i < changes.length; i++) {
    var c = changes[i];
    sheet.appendRow([
      c.date,
      c.campaign,
      c.action,
      c.label,
      c.reason
    ]);
  }
}
```

## Setup Instructions

1. **Create the script:** Google Ads → Tools & Settings → Bulk Actions → Scripts → New Script
2. **Paste the code** and update the `CONFIG` object
3. **Authorize** when prompted
4. **(Optional)** Create a Google Sheet for logging and paste the URL into `SPREADSHEET_URL`
5. **Preview** first to see which labels would be applied
6. **Schedule** to run daily

> [!tip] Labels in the Google Ads UI
> After the script runs, you'll see labels like `PMax: running shoes` and `PMax: winter jackets` on your campaigns. Use the label filter in the campaign view to group campaigns by their actual search focus — much more useful than just the campaign name.

## Customization Guide

### Label naming

Change `LABEL_PREFIX` to customize the label format. Examples:
- `"PMax: "` → `PMax: running shoes`
- `"Category: "` → `Category: running shoes`
- `"[auto] "` → `[auto] running shoes`

### Control label count

`MAX_LABELS_PER_CAMPAIGN` limits how many category labels each campaign gets. The default of `3` keeps things clean. Set to `1` for a single "primary category" label, or `5` for more detail.

### Impression share threshold

`MIN_IMPRESSION_SHARE` prevents labeling campaigns with low-volume categories. At `0.05` (5%), a category needs at least 5% of the campaign's total category impressions to qualify. Lower to `0.01` for granularity, raise to `0.10` for only dominant categories.

### Keep historical labels

Set `CLEAN_OLD_LABELS` to `false` if you want to see ALL categories a campaign has ever targeted (labels accumulate). This can get noisy but shows category drift over time.

### Daily vs. weekly schedule

Running daily keeps labels current — useful when PMax campaigns shift targeting frequently. If your campaigns are stable, weekly is sufficient and reduces API calls.

> [!info] How This Differs from the Extractor
> The [[pmax-search-terms-extractor|Search Terms Extractor]] dumps all categories with full metrics to a spreadsheet for analysis. This script takes the **top categories** and applies them as **labels visible in the Google Ads UI** for quick reference. Use both together for maximum visibility.

## Related Reference

- [[catalog|Scripts Catalog]] — full index of available scripts
- [[pmax-search-terms-extractor|PMax Search Terms Extractor]] — full category data extraction
- [[pmax-metrics|PMax Metrics]] — understanding PMax performance data
- [[audience-signals|PMax Audience Signals]] — optimizing audience targeting
