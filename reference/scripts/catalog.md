---
title: Google Ads Scripts Catalog
date: 2026-03-28
tags:
  - reference
  - scripts
---

# Google Ads Scripts Catalog

Categorized index of useful Google Ads Scripts. Each script can be customized via `/ad-platform-campaign-manager:ads-scripts`.

## Monitoring & Alerts

### Budget Pacing Alert
Sends email when a campaign is over/under pacing against daily budget.
- **Source:** Brainlabs-Digital/Google-Ads-Scripts
- **Schedule:** Daily
- **Customization:** Threshold percentages, email recipients

### Conversion Drop Alert
Alerts when conversions drop below a threshold compared to the same day last week.
- **Schedule:** Daily
- **Customization:** Drop threshold (e.g., 30%), campaign filters

### Broken URL Checker
Checks all ad final URLs and sitelink URLs for 404 errors.
- **Source:** Brainlabs-Digital/Google-Ads-Scripts
- **Schedule:** Weekly
- **Customization:** URL check method, error notification

### Quality Score Monitor
Tracks Quality Score changes over time and exports to Google Sheets.
- **Schedule:** Daily
- **Customization:** QS threshold, sheet URL

## Bidding & Budget

### Day Parting Bid Adjustments
Adjusts bids based on hour-of-day and day-of-week performance data.
- **Source:** Czarto/Adwords-Scripts
- **Schedule:** Daily
- **Customization:** Performance lookback period, adjustment caps

### Budget Reallocation
Moves unspent budget from underperforming campaigns to top performers.
- **Schedule:** Daily
- **Customization:** Minimum performance thresholds, max reallocation %

### Automated Bid Rules
Pauses keywords with high cost and zero conversions after a threshold.
- **Schedule:** Daily
- **Customization:** Cost threshold, lookback window, action (pause vs lower bid)

## Reporting

### Weekly Performance Report to Sheets
Exports campaign/keyword performance to a formatted Google Sheet.
- **Source:** pamnard/Google-Ads-Scripts
- **Schedule:** Weekly (Monday morning)
- **Customization:** Metrics selection, date range, sheet URL

### Search Term Mining
Exports search terms to Sheets, flagging potential keywords and negatives.
- **Schedule:** Weekly
- **Customization:** Impression/click thresholds, conversion requirements

### Landing Page Performance Report
Reports on landing page metrics with conversion rate benchmarks.
- **Schedule:** Monthly
- **Customization:** Minimum click threshold

## Cleanup & Maintenance

### Negative Keyword Conflict Checker
Identifies negative keywords that block positive keywords.
- **Source:** Brainlabs-Digital/Google-Ads-Scripts
- **Schedule:** Monthly
- **Customization:** Campaign/ad group scope

### Duplicate Keyword Finder
Finds duplicate keywords across ad groups and campaigns.
- **Schedule:** Monthly
- **Customization:** Match type handling, output sheet

### Low Quality Score Keyword Pauser
Pauses keywords with Quality Score below threshold after minimum impressions.
- **Schedule:** Weekly
- **Customization:** QS threshold (default: 3), min impressions (default: 100)

### Zero Impression Keyword Cleaner
Identifies enabled keywords with zero impressions over 30+ days.
- **Schedule:** Monthly
- **Customization:** Lookback period, action (pause vs report only)

## PMax Specific

### PMax Search Terms Extractor
Extracts PMax search term categories to Google Sheets for analysis.
- **Source:** agencysavvy/pmax
- **Schedule:** Weekly
- **Customization:** Campaign selection, sheet URL

### PMax Asset Performance Tracker
Tracks asset performance ratings over time.
- **Source:** agencysavvy/pmax
- **Schedule:** Weekly
- **Customization:** Asset group selection

### PMax Category Label Script
Auto-labels PMax campaigns based on search term categories.
- **Source:** agencysavvy/pmax
- **Schedule:** Daily

## Script Resources

- **Brainlabs-Digital/Google-Ads-Scripts:** github.com/Brainlabs-Digital/Google-Ads-Scripts (145 stars)
- **Czarto/Adwords-Scripts:** github.com/Czarto/Adwords-Scripts (50 stars)
- **agencysavvy/pmax:** github.com/agencysavvy/pmax (276 stars)
- **pamnard/Google-Ads-Scripts:** github.com/pamnard/Google-Ads-Scripts (23 stars)
