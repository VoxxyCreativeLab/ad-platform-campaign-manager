# dbt Model Patterns for Ad Reporting

Based on patterns from fivetran/dbt_ad_reporting (cross-platform ad reporting models).

## Model Architecture

```
Sources (raw data)
└── Staging models (stg_)
    └── Intermediate models (int_)
        └── Mart models (dim_, fct_, rpt_)
```

## Staging Models

Staging models clean and rename raw source data. One per source table.

### stg_google_ads__campaign_performance
```sql
-- models/staging/google_ads/stg_google_ads__campaign_performance.sql
WITH source AS (
    SELECT * FROM {{ source('google_ads', 'campaign_performance') }}
),

renamed AS (
    SELECT
        date AS report_date,
        account_id,
        campaign_id,
        campaign_name,
        campaign_status,
        channel_type AS campaign_type,
        impressions,
        clicks,
        cost,
        conversions,
        conversion_value,
        _loaded_at
    FROM source
)

SELECT * FROM renamed
```

### stg_google_ads__keyword_performance
```sql
-- models/staging/google_ads/stg_google_ads__keyword_performance.sql
WITH source AS (
    SELECT * FROM {{ source('google_ads', 'keyword_performance') }}
),

renamed AS (
    SELECT
        date AS report_date,
        account_id,
        campaign_id,
        campaign_name,
        ad_group_id,
        ad_group_name,
        keyword_text AS keyword,
        match_type,
        quality_score,
        impressions,
        clicks,
        cost,
        conversions,
        conversion_value
    FROM source
)

SELECT * FROM renamed
```

## Intermediate Models

Combine and transform staging data.

### int_google_ads__campaign_daily
```sql
-- models/intermediate/int_google_ads__campaign_daily.sql
SELECT
    report_date,
    account_id,
    campaign_id,
    campaign_name,
    campaign_type,
    campaign_status,
    impressions,
    clicks,
    cost,
    conversions,
    conversion_value,
    -- Calculated metrics
    SAFE_DIVIDE(clicks, impressions) AS ctr,
    SAFE_DIVIDE(cost, clicks) AS cpc,
    SAFE_DIVIDE(cost, conversions) AS cpa,
    SAFE_DIVIDE(conversion_value, cost) AS roas
FROM {{ ref('stg_google_ads__campaign_performance') }}
```

## Mart Models

### Cross-Platform Ad Performance (Future-Ready)

When you add Meta/LinkedIn/TikTok, use a unified model:

```sql
-- models/marts/rpt_ad_performance_daily.sql
-- Unified cross-platform ad performance report

WITH google_ads AS (
    SELECT
        report_date,
        'google_ads' AS platform,
        account_id,
        campaign_id,
        campaign_name,
        campaign_type,
        impressions,
        clicks,
        cost,
        conversions,
        conversion_value
    FROM {{ ref('int_google_ads__campaign_daily') }}
),

-- Future: add Meta, LinkedIn, TikTok CTEs here
-- meta_ads AS (
--     SELECT ... FROM {{ ref('int_meta_ads__campaign_daily') }}
-- ),

unified AS (
    SELECT * FROM google_ads
    -- UNION ALL SELECT * FROM meta_ads
    -- UNION ALL SELECT * FROM linkedin_ads
)

SELECT
    report_date,
    platform,
    account_id,
    campaign_id,
    campaign_name,
    campaign_type,
    impressions,
    clicks,
    cost,
    conversions,
    conversion_value,
    SAFE_DIVIDE(clicks, impressions) AS ctr,
    SAFE_DIVIDE(cost, clicks) AS cpc,
    SAFE_DIVIDE(cost, conversions) AS cpa,
    SAFE_DIVIDE(conversion_value, cost) AS roas
FROM unified
```

### Weekly Summary Mart
```sql
-- models/marts/rpt_campaign_weekly.sql
SELECT
    DATE_TRUNC(report_date, WEEK(MONDAY)) AS week_start,
    platform,
    campaign_name,
    campaign_type,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(cost) AS cost,
    SUM(conversions) AS conversions,
    SUM(conversion_value) AS conversion_value,
    SAFE_DIVIDE(SUM(clicks), SUM(impressions)) AS ctr,
    SAFE_DIVIDE(SUM(cost), SUM(clicks)) AS cpc,
    SAFE_DIVIDE(SUM(cost), SUM(conversions)) AS cpa,
    SAFE_DIVIDE(SUM(conversion_value), SUM(cost)) AS roas
FROM {{ ref('rpt_ad_performance_daily') }}
GROUP BY 1, 2, 3, 4
```

## Source Configuration

```yaml
# models/staging/google_ads/src_google_ads.yml
version: 2

sources:
  - name: google_ads
    database: "{{ var('google_ads_database', target.database) }}"
    schema: "{{ var('google_ads_schema', 'google_ads') }}"
    tables:
      - name: campaign_performance
        description: Daily campaign performance metrics
        loaded_at_field: _loaded_at
        freshness:
          warn_after: {count: 24, period: hour}
          error_after: {count: 48, period: hour}
      - name: keyword_performance
        description: Daily keyword-level performance metrics
      - name: search_terms
        description: Search terms that triggered ads
```

## Directory Structure
```
models/
├── staging/
│   └── google_ads/
│       ├── src_google_ads.yml
│       ├── stg_google_ads__campaign_performance.sql
│       ├── stg_google_ads__keyword_performance.sql
│       └── stg_google_ads__search_terms.sql
├── intermediate/
│   └── int_google_ads__campaign_daily.sql
└── marts/
    ├── rpt_ad_performance_daily.sql
    ├── rpt_campaign_weekly.sql
    └── rpt_campaign_monthly.sql
```
