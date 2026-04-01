---
title: Broken URL Checker Script
date: 2026-03-31
tags:
  - reference
  - scripts
  - monitoring
---

# Broken URL Checker Script

Checks all ad final URLs and sitelink URLs in the account for HTTP errors (404, 500, timeouts). Sends an email report listing every broken URL with its associated campaign, ad group, and the HTTP status code. Prevents wasted ad spend on clicks that land on error pages.

> [!info] Source
> Adapted from the [Brainlabs-Digital/Google-Ads-Scripts](https://github.com/Brainlabs-Digital/Google-Ads-Scripts) URL checking pattern.

**Schedule:** Weekly (URL changes are less frequent; weekly avoids hitting UrlFetchApp limits)

## Configuration

| Variable | Type | Default | Description |
|---|---|---|---|
| `EMAIL_RECIPIENTS` | String | `""` | Comma-separated email addresses to receive the broken URL report |
| `CHECK_SITELINKS` | Boolean | `true` | Whether to also check sitelink extension URLs |
| `CHECK_AD_URLS` | Boolean | `true` | Whether to check ad final URLs |
| `TIMEOUT_MS` | Number | `10000` | HTTP request timeout in milliseconds |
| `CAMPAIGN_LABEL` | String | `""` | Only check campaigns with this label. Leave empty for all enabled campaigns |
| `MUTEHTTP_EXCEPTIONS` | Boolean | `true` | Prevent UrlFetchApp from throwing on HTTP errors (required for status code checking) |
| `LOG_HEALTHY_URLS` | Boolean | `false` | Whether to log URLs that return 200 OK (verbose mode) |

## Script

```javascript
/**
 * Broken URL Checker
 *
 * Fetches all ad final URLs and sitelink URLs, checks each for HTTP errors,
 * and sends an email report listing broken URLs.
 *
 * Adapted from Brainlabs-Digital/Google-Ads-Scripts URL checking pattern.
 *
 * Schedule: Weekly
 *
 * Note: Google Ads Scripts has a limit of 50 UrlFetchApp calls per execution.
 * For large accounts, use CAMPAIGN_LABEL to check in batches.
 */
function main() {
  // ===================== CONFIGURATION =====================
  var CONFIG = {
    // Email addresses to receive the report
    EMAIL_RECIPIENTS: "you@example.com",

    // What to check
    CHECK_AD_URLS: true,
    CHECK_SITELINKS: true,

    // HTTP request timeout (ms)
    TIMEOUT_MS: 10000,

    // Only check campaigns with this label (empty = all enabled)
    CAMPAIGN_LABEL: "",

    // Prevent UrlFetchApp from throwing on HTTP errors
    MUTEHTTP_EXCEPTIONS: true,

    // Log healthy URLs (for debugging)
    LOG_HEALTHY_URLS: false
  };
  // =========================================================

  var urlsToCheck = {};  // URL -> array of {type, campaign, adGroup, entity}
  var fetchCount = 0;
  var MAX_FETCHES = 50;  // Google Ads Scripts limit

  // ------ Collect URLs from Ads ------
  if (CONFIG.CHECK_AD_URLS) {
    var adSelector = AdsApp.ads()
      .withCondition("Status = ENABLED")
      .withCondition("AdGroupStatus = ENABLED")
      .withCondition("CampaignStatus = ENABLED");

    if (CONFIG.CAMPAIGN_LABEL !== "") {
      adSelector = adSelector.withCondition(
        "LabelNames CONTAINS_ANY ['" + CONFIG.CAMPAIGN_LABEL + "']"
      );
    }

    var ads = adSelector.get();
    while (ads.hasNext()) {
      var ad = ads.next();
      var urls = ad.urls();

      if (urls && urls.getFinalUrl()) {
        var finalUrl = urls.getFinalUrl();
        _addUrl(urlsToCheck, finalUrl, {
          type: "Ad Final URL",
          campaign: ad.getCampaign().getName(),
          adGroup: ad.getAdGroup().getName(),
          entity: ad.getHeadlinePart1 ? ad.getHeadlinePart1() : "RSA"
        });
      }
    }
  }

  // ------ Collect URLs from Sitelinks ------
  if (CONFIG.CHECK_SITELINKS) {
    var campaignSelector = AdsApp.campaigns()
      .withCondition("Status = ENABLED");

    if (CONFIG.CAMPAIGN_LABEL !== "") {
      campaignSelector = campaignSelector.withCondition(
        "LabelNames CONTAINS_ANY ['" + CONFIG.CAMPAIGN_LABEL + "']"
      );
    }

    var campaigns = campaignSelector.get();
    while (campaigns.hasNext()) {
      var campaign = campaigns.next();
      var campaignName = campaign.getName();

      var sitelinks = campaign.extensions().sitelinks().get();
      while (sitelinks.hasNext()) {
        var sitelink = sitelinks.next();
        var slUrls = sitelink.urls();

        if (slUrls && slUrls.getFinalUrl()) {
          _addUrl(urlsToCheck, slUrls.getFinalUrl(), {
            type: "Sitelink",
            campaign: campaignName,
            adGroup: "(campaign-level)",
            entity: sitelink.getLinkText()
          });
        }
      }
    }
  }

  // ------ Deduplicate and Check URLs ------
  var uniqueUrls = Object.keys(urlsToCheck);
  Logger.log("Found " + uniqueUrls.length + " unique URLs to check.");

  if (uniqueUrls.length > MAX_FETCHES) {
    Logger.log("WARNING: " + uniqueUrls.length + " URLs exceed the " + MAX_FETCHES +
               " fetch limit. Only the first " + MAX_FETCHES + " will be checked.");
    Logger.log("Use CAMPAIGN_LABEL to check in batches.");
  }

  var brokenUrls = [];

  for (var i = 0; i < uniqueUrls.length && fetchCount < MAX_FETCHES; i++) {
    var url = uniqueUrls[i];
    var result = _checkUrl(url, CONFIG.TIMEOUT_MS, CONFIG.MUTEHTTP_EXCEPTIONS);
    fetchCount++;

    if (result.ok) {
      if (CONFIG.LOG_HEALTHY_URLS) {
        Logger.log("OK [" + result.statusCode + "] " + url);
      }
    } else {
      Logger.log("BROKEN [" + result.statusCode + "] " + url + " — " + result.error);

      // Attach all entities using this URL
      var entities = urlsToCheck[url];
      for (var j = 0; j < entities.length; j++) {
        brokenUrls.push({
          url: url,
          statusCode: result.statusCode,
          error: result.error,
          type: entities[j].type,
          campaign: entities[j].campaign,
          adGroup: entities[j].adGroup,
          entity: entities[j].entity
        });
      }
    }
  }

  // ------ Report ------
  Logger.log("Checked " + fetchCount + " URLs. Broken: " + brokenUrls.length);

  if (brokenUrls.length === 0) {
    Logger.log("All checked URLs are healthy. No email sent.");
    return;
  }

  var subject = "Broken URL Report — " + brokenUrls.length + " issue(s) — " + _formatDate(new Date());
  var body = "Broken URL Checker Report\n";
  body += "Checked " + fetchCount + " unique URLs\n";
  body += "Found " + brokenUrls.length + " broken URL reference(s)\n\n";

  body += "=== BROKEN URLS ===\n\n";

  for (var k = 0; k < brokenUrls.length; k++) {
    var b = brokenUrls[k];
    body += "  URL: " + b.url + "\n";
    body += "  Status: " + b.statusCode + " — " + b.error + "\n";
    body += "  Type: " + b.type + "\n";
    body += "  Campaign: " + b.campaign + "\n";
    body += "  Ad Group: " + b.adGroup + "\n";
    body += "  Entity: " + b.entity + "\n\n";
  }

  body += "---\n";
  body += "Action required: Fix or replace broken URLs to stop wasting ad spend.\n";
  body += "\nGenerated by Broken URL Checker script.";

  MailApp.sendEmail({
    to: CONFIG.EMAIL_RECIPIENTS,
    subject: subject,
    body: body
  });

  Logger.log("Report sent to " + CONFIG.EMAIL_RECIPIENTS);
}

/**
 * Adds a URL and its associated entity to the URL map.
 * Groups multiple entities under the same URL.
 */
function _addUrl(urlMap, url, entityInfo) {
  if (!urlMap[url]) {
    urlMap[url] = [];
  }
  urlMap[url].push(entityInfo);
}

/**
 * Checks a single URL for HTTP errors.
 * Returns {ok: boolean, statusCode: number, error: string}
 */
function _checkUrl(url, timeoutMs, muteExceptions) {
  try {
    var response = UrlFetchApp.fetch(url, {
      muteHttpExceptions: muteExceptions,
      followRedirects: true,
      validateHttpsCertificates: false,
      method: "get",
      headers: {
        "User-Agent": "Mozilla/5.0 (Google Ads Scripts URL Checker)"
      }
    });

    var statusCode = response.getResponseCode();

    if (statusCode >= 200 && statusCode < 400) {
      return { ok: true, statusCode: statusCode, error: "" };
    } else {
      return { ok: false, statusCode: statusCode, error: _httpStatusText(statusCode) };
    }
  } catch (e) {
    return { ok: false, statusCode: 0, error: "Fetch error: " + e.message };
  }
}

/**
 * Returns a human-readable HTTP status text.
 */
function _httpStatusText(code) {
  var statuses = {
    400: "Bad Request",
    401: "Unauthorized",
    403: "Forbidden",
    404: "Not Found",
    410: "Gone",
    500: "Internal Server Error",
    502: "Bad Gateway",
    503: "Service Unavailable",
    504: "Gateway Timeout"
  };
  return statuses[code] || "HTTP " + code;
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
3. Name it `Broken URL Checker`
4. Paste the script above
5. Update `CONFIG.EMAIL_RECIPIENTS` with your actual email address(es)
6. Click **Preview** to test — check Logger output for any broken URLs
7. Click **Authorize** when prompted (the script needs URL fetch and email permissions)
8. Set the schedule to **Weekly**
9. Click **Save**

> [!danger] UrlFetchApp Limit
> Google Ads Scripts limits you to **50 URL fetch calls per execution**. If your account has more than 50 unique URLs, use `CAMPAIGN_LABEL` to check campaigns in batches across multiple script instances (e.g., `URL-Check-Batch-1`, `URL-Check-Batch-2`).

## Customization Guide

### Batch Checking for Large Accounts

Create multiple copies of the script, each filtering a different label:

- Script 1: `CAMPAIGN_LABEL: "URL-Check-A"` (runs Monday)
- Script 2: `CAMPAIGN_LABEL: "URL-Check-B"` (runs Tuesday)

Apply the labels to your campaigns to distribute the work.

### Checking Only Landing Pages (Skip Sitelinks)

```javascript
CHECK_AD_URLS: true,
CHECK_SITELINKS: false,
```

### Exporting to Google Sheets

Add a Sheets export alongside the email. After the `brokenUrls` loop, append:

```javascript
var ss = SpreadsheetApp.openByUrl("YOUR_SHEET_URL");
var sheet = ss.getSheetByName("BrokenURLs") || ss.insertSheet("BrokenURLs");

// Header row (only if sheet is empty)
if (sheet.getLastRow() === 0) {
  sheet.appendRow(["Date", "URL", "Status", "Type", "Campaign", "Ad Group", "Entity"]);
}

for (var m = 0; m < brokenUrls.length; m++) {
  var b = brokenUrls[m];
  sheet.appendRow([
    _formatDate(new Date()), b.url, b.statusCode,
    b.type, b.campaign, b.adGroup, b.entity
  ]);
}
```

### HEAD Requests for Faster Checking

Some servers respond faster to HEAD requests. Change the method:

```javascript
var response = UrlFetchApp.fetch(url, {
  muteHttpExceptions: muteExceptions,
  followRedirects: true,
  method: "head",  // Faster, but some servers block HEAD
});
```

> [!warning] HEAD Request Caveat
> Some web servers return 405 (Method Not Allowed) or 403 for HEAD requests. If you see false positives, switch back to `"get"`.

## Related

- [[catalog|Scripts Catalog]] — full index of all scripts
- [[budget-pacing-alert]] — budget monitoring
- [[conversion-drop-alert]] — conversion tracking alerts
- [[../../platforms/google-ads/ad-extensions|Ad Extensions Reference]] — sitelink configuration
