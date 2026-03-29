---
title: PMax Metrics & Reporting
date: 2026-03-28
tags:
  - reference
  - google-ads
  - pmax
---

# PMax Metrics & Reporting

## Understanding PMax Reporting Limitations

PMax has less granular reporting than Search campaigns. Key differences:
- No keyword-level performance data (limited search term reporting)
- No placement-level data for Display/YouTube
- Asset performance is rated (Best/Good/Low) rather than showing exact metrics
- Audience insights show segments, not individual targeting performance

## Key Metrics to Monitor

### Campaign Level
| Metric | What to Watch | Action |
|--------|--------------|--------|
| Conversions | Trend over 7/14/30 days | Is the campaign learning and improving? |
| Conv. value | Total revenue/value | Growing or declining? |
| Cost | Daily/weekly spend | Is it spending the full budget? |
| ROAS | Conv. value / Cost | Meeting target? |
| CPA | Cost / Conversions | Sustainable? |
| Conv. rate | Conversions / Clicks | Improving over time? |

### Asset Group Level
| Metric | What to Watch |
|--------|--------------|
| Asset group status | Eligible, Limited, Learning |
| Listing group performance | Which product groups convert |
| Asset performance rating | Best, Good, Low, Learning |

### Asset Performance Ratings

Google rates each individual asset:

| Rating | Meaning | Action |
|--------|---------|--------|
| **Best** | Top-performing asset | Keep. Use as inspiration for new assets. |
| **Good** | Performs well | Keep. |
| **Low** | Underperforming | Replace after 2-4 weeks. |
| **Learning** | Not enough data | Wait. Need ~2 weeks of data. |
| **Pending** | Not yet evaluated | Wait. |

### Search Term Insights
Available under Insights → Search terms:
- Shows **categories** of search terms, not individual terms
- Categories: branded, competitor, generic
- Shows impression share by category
- Use this to detect brand cannibalization

## Common PMax Reports to Build

### Weekly Performance Report
```
Campaign Name | Spend | Impressions | Clicks | CTR | Conversions | Conv Value | CPA | ROAS
```
Compare week-over-week to spot trends.

### Asset Performance Review (Monthly)
```
Asset Group | Asset Type | Asset Text/Image | Rating | Action Needed
```
Identify and replace "Low" rated assets.

### Search Category Report
```
Search Category | Impressions | Clicks | Conversions | % of Total
```
Check if PMax is spending on the right search categories.

### Channel Distribution
PMax distributes across channels. Check:
- What % goes to Search vs Display vs YouTube vs Shopping?
- Is one channel dominating? (Often Shopping for e-commerce)
- Are you getting YouTube/Display impressions? (Need video assets)

**Access:** Insights tab → Performance by time → filter by network

## PMax vs Search Campaign Comparison

If running PMax alongside Search, compare:
- Brand search impression share (PMax may cannibalize)
- Incremental conversions (are PMax conversions truly incremental or stolen from Search?)
- Overall account performance (total conversions up or just shifted?)

### Brand Exclusions
To prevent PMax from cannibalizing brand Search:
1. Create a brand exclusion list in Google Ads
2. Apply it to PMax campaigns
3. Run brand terms only in dedicated Search campaigns

## GAQL Queries for PMax

```sql
-- PMax campaign performance
SELECT
  campaign.name,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM campaign
WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX'
  AND segments.date DURING LAST_30_DAYS

-- Asset group performance
SELECT
  campaign.name,
  asset_group.name,
  asset_group.status,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions,
  metrics.conversions_value
FROM asset_group
WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX'
  AND segments.date DURING LAST_30_DAYS
```

## Optimization Cadence

| Timeframe | Action |
|-----------|--------|
| Daily | Check spend pacing, flag anomalies |
| Weekly | Review campaign performance trends, search categories |
| Bi-weekly | Check asset ratings, plan replacements |
| Monthly | Full asset performance review, audience signal refinement |
| Quarterly | Strategic review: is PMax the right approach? Compare with Search-only |
