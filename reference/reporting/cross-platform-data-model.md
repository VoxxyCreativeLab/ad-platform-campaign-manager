# Cross-Platform Ad Data Model

Unified schema for reporting across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads. Design the BigQuery/dbt layer with this model from day one so adding platforms later is seamless.

## Unified Campaign Performance Table

```sql
CREATE TABLE `project.dataset.unified_campaign_performance` (
  -- Dimensions
  report_date DATE NOT NULL,
  platform STRING NOT NULL,          -- 'google_ads', 'meta_ads', 'linkedin_ads', 'tiktok_ads'
  account_id STRING NOT NULL,
  account_name STRING,
  campaign_id STRING NOT NULL,
  campaign_name STRING,
  campaign_type STRING,              -- Normalized: 'search', 'display', 'video', 'shopping', 'performance_max', 'social_feed', 'stories', etc.
  campaign_status STRING,            -- Normalized: 'active', 'paused', 'removed'
  currency STRING DEFAULT 'EUR',

  -- Core metrics (every platform has these)
  impressions INT64,
  clicks INT64,
  cost FLOAT64,                      -- In account currency
  conversions FLOAT64,
  conversion_value FLOAT64,

  -- Calculated metrics
  ctr FLOAT64,                       -- clicks / impressions
  cpc FLOAT64,                       -- cost / clicks
  cpa FLOAT64,                       -- cost / conversions
  roas FLOAT64,                      -- conversion_value / cost
  conversion_rate FLOAT64,           -- conversions / clicks

  -- Platform-specific (NULL when not applicable)
  reach INT64,                       -- Meta, TikTok, LinkedIn
  frequency FLOAT64,                 -- Meta, TikTok
  video_views INT64,                 -- YouTube, Meta, TikTok
  engagements INT64,                 -- LinkedIn, Meta

  -- Metadata
  _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
  _source_table STRING               -- Original source table reference
)
PARTITION BY report_date
CLUSTER BY platform, campaign_id;
```

## Platform Mapping Guide

### Campaign Type Normalization

| Google Ads | Meta Ads | LinkedIn Ads | TikTok Ads | Unified |
|-----------|----------|-------------|------------|---------|
| SEARCH | — | — | — | search |
| DISPLAY | — | — | — | display |
| VIDEO | — | — | — | video |
| SHOPPING | — | — | — | shopping |
| PERFORMANCE_MAX | Advantage+ Shopping | — | — | performance_max |
| — | Awareness | Brand Awareness | Reach | awareness |
| — | Traffic | Website Visits | Traffic | traffic |
| — | Engagement | Engagement | Community Interaction | engagement |
| — | Leads | Lead Gen Forms | Lead Generation | lead_gen |
| — | Sales | Website Conversions | Conversions | conversions |

### Status Normalization

| Google Ads | Meta Ads | LinkedIn Ads | TikTok | Unified |
|-----------|----------|-------------|--------|---------|
| ENABLED | ACTIVE | ACTIVE | ENABLE | active |
| PAUSED | PAUSED | PAUSED | DISABLE | paused |
| REMOVED | DELETED | ARCHIVED | DELETE | removed |

## Unified Conversion Table

```sql
CREATE TABLE `project.dataset.unified_conversions` (
  report_date DATE NOT NULL,
  platform STRING NOT NULL,
  account_id STRING NOT NULL,
  campaign_id STRING NOT NULL,
  campaign_name STRING,
  conversion_action STRING,          -- Normalized action name
  conversion_category STRING,        -- purchase, lead, signup, page_view, etc.
  conversions FLOAT64,
  conversion_value FLOAT64,
  attribution_model STRING,          -- data_driven, last_click, 7d_click_1d_view, etc.
  _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY report_date
CLUSTER BY platform;
```

## Cross-Platform Reporting Queries

### Total Spend by Platform
```sql
SELECT
  platform,
  SUM(cost) AS total_cost,
  SUM(conversions) AS total_conversions,
  SAFE_DIVIDE(SUM(cost), SUM(conversions)) AS blended_cpa,
  SAFE_DIVIDE(SUM(conversion_value), SUM(cost)) AS blended_roas
FROM `project.dataset.unified_campaign_performance`
WHERE report_date BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY) AND CURRENT_DATE()
GROUP BY platform
ORDER BY total_cost DESC
```

### Cross-Platform Weekly Trend
```sql
SELECT
  DATE_TRUNC(report_date, WEEK(MONDAY)) AS week,
  platform,
  SUM(cost) AS cost,
  SUM(conversions) AS conversions,
  SAFE_DIVIDE(SUM(cost), SUM(conversions)) AS cpa
FROM `project.dataset.unified_campaign_performance`
WHERE report_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)
GROUP BY 1, 2
ORDER BY 1, 2
```

## Design Principles

1. **Normalize where possible** — campaign types, statuses, conversion categories
2. **Keep platform-specific fields as nullable columns** — don't force all platforms into one shape
3. **Use STRING for IDs** — different platforms use different ID formats
4. **Store cost in account currency** — handle currency conversion at the reporting layer
5. **Partition by date, cluster by platform** — optimizes most common queries
6. **Include _source_table** — traceability back to raw data
