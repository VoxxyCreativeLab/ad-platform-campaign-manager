# BigQuery Table Schemas for Google Ads Data

## Campaign Performance Table

```sql
CREATE TABLE `project.dataset.gads_campaign_performance` (
  date DATE NOT NULL,
  account_id INT64 NOT NULL,
  campaign_id INT64 NOT NULL,
  campaign_name STRING,
  campaign_status STRING,
  channel_type STRING,           -- SEARCH, DISPLAY, VIDEO, PERFORMANCE_MAX
  bidding_strategy STRING,
  budget_amount FLOAT64,         -- Daily budget in account currency
  impressions INT64,
  clicks INT64,
  cost FLOAT64,                  -- In account currency (not micros)
  conversions FLOAT64,
  conversion_value FLOAT64,
  ctr FLOAT64,
  avg_cpc FLOAT64,
  cpa FLOAT64,                   -- cost / conversions
  roas FLOAT64,                  -- conversion_value / cost
  _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY date
CLUSTER BY campaign_id;
```

## Keyword Performance Table

```sql
CREATE TABLE `project.dataset.gads_keyword_performance` (
  date DATE NOT NULL,
  account_id INT64 NOT NULL,
  campaign_id INT64 NOT NULL,
  campaign_name STRING,
  ad_group_id INT64 NOT NULL,
  ad_group_name STRING,
  keyword_text STRING,
  match_type STRING,             -- BROAD, PHRASE, EXACT
  quality_score INT64,
  impressions INT64,
  clicks INT64,
  cost FLOAT64,
  conversions FLOAT64,
  conversion_value FLOAT64,
  ctr FLOAT64,
  avg_cpc FLOAT64,
  _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY date
CLUSTER BY campaign_id, ad_group_id;
```

## Search Terms Table

```sql
CREATE TABLE `project.dataset.gads_search_terms` (
  date DATE NOT NULL,
  account_id INT64 NOT NULL,
  campaign_name STRING,
  ad_group_name STRING,
  search_term STRING,
  match_type STRING,
  impressions INT64,
  clicks INT64,
  cost FLOAT64,
  conversions FLOAT64,
  conversion_value FLOAT64,
  _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY date;
```

## Ad Performance Table

```sql
CREATE TABLE `project.dataset.gads_ad_performance` (
  date DATE NOT NULL,
  account_id INT64 NOT NULL,
  campaign_name STRING,
  ad_group_name STRING,
  ad_id INT64,
  ad_type STRING,
  headlines STRING,              -- JSON array of headlines
  descriptions STRING,           -- JSON array of descriptions
  final_url STRING,
  impressions INT64,
  clicks INT64,
  cost FLOAT64,
  conversions FLOAT64,
  conversion_value FLOAT64,
  ctr FLOAT64,
  _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY date;
```

## Conversion Actions Table

```sql
CREATE TABLE `project.dataset.gads_conversion_actions` (
  date DATE NOT NULL,
  account_id INT64 NOT NULL,
  campaign_name STRING,
  conversion_action_name STRING,
  conversion_action_category STRING,
  conversions FLOAT64,
  conversion_value FLOAT64,
  all_conversions FLOAT64,
  view_through_conversions FLOAT64,
  _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY date;
```

## Staging Tables for Reporting Views

### Weekly Summary View
```sql
CREATE VIEW `project.dataset.v_gads_weekly_summary` AS
SELECT
  DATE_TRUNC(date, WEEK(MONDAY)) AS week_start,
  campaign_name,
  channel_type,
  SUM(impressions) AS impressions,
  SUM(clicks) AS clicks,
  SUM(cost) AS cost,
  SUM(conversions) AS conversions,
  SUM(conversion_value) AS conversion_value,
  SAFE_DIVIDE(SUM(clicks), SUM(impressions)) AS ctr,
  SAFE_DIVIDE(SUM(cost), SUM(clicks)) AS avg_cpc,
  SAFE_DIVIDE(SUM(cost), SUM(conversions)) AS cpa,
  SAFE_DIVIDE(SUM(conversion_value), SUM(cost)) AS roas
FROM `project.dataset.gads_campaign_performance`
GROUP BY 1, 2, 3;
```

### Month-over-Month Comparison View
```sql
CREATE VIEW `project.dataset.v_gads_mom_comparison` AS
WITH current_month AS (
  SELECT campaign_name,
    SUM(cost) AS cost, SUM(conversions) AS conversions,
    SUM(conversion_value) AS value
  FROM `project.dataset.gads_campaign_performance`
  WHERE date >= DATE_TRUNC(CURRENT_DATE(), MONTH)
  GROUP BY 1
),
previous_month AS (
  SELECT campaign_name,
    SUM(cost) AS cost, SUM(conversions) AS conversions,
    SUM(conversion_value) AS value
  FROM `project.dataset.gads_campaign_performance`
  WHERE date >= DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 1 MONTH)
    AND date < DATE_TRUNC(CURRENT_DATE(), MONTH)
  GROUP BY 1
)
SELECT
  c.campaign_name,
  c.cost AS current_cost, p.cost AS previous_cost,
  c.conversions AS current_conv, p.conversions AS previous_conv,
  c.value AS current_value, p.value AS previous_value,
  SAFE_DIVIDE(c.cost - p.cost, p.cost) AS cost_change_pct,
  SAFE_DIVIDE(c.conversions - p.conversions, p.conversions) AS conv_change_pct
FROM current_month c
LEFT JOIN previous_month p USING (campaign_name);
```

## Notes

- All monetary values stored in account currency (not micros) for readability
- Tables partitioned by date for cost-efficient querying
- Use `_loaded_at` to track data freshness
- Cluster by campaign_id for common query patterns
- Use `SAFE_DIVIDE` to handle division by zero
