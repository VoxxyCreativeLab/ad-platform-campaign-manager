# GAQL — Google Ads Query Language Reference

## Syntax

```sql
SELECT field1, field2, metrics.metric1
FROM resource_name
WHERE condition1 AND condition2
ORDER BY field ASC|DESC
LIMIT n
PARAMETERS include_drafts=true
```

## Common Resources

| Resource | Description |
|----------|------------|
| `campaign` | Campaign-level data |
| `ad_group` | Ad group-level data |
| `ad_group_ad` | Ad-level data |
| `keyword_view` | Keyword performance |
| `search_term_view` | Actual search terms that triggered ads |
| `ad_group_criterion` | Targeting criteria (keywords, audiences) |
| `campaign_budget` | Budget information |
| `customer` | Account-level data |
| `change_status` | Recent changes to the account |
| `landing_page_view` | Landing page performance |
| `gender_view` | Performance by gender |
| `age_range_view` | Performance by age range |
| `geographic_view` | Performance by location |

## Common Fields & Metrics

### Campaign Fields
```sql
campaign.id
campaign.name
campaign.status                    -- ENABLED, PAUSED, REMOVED
campaign.advertising_channel_type  -- SEARCH, DISPLAY, VIDEO, SHOPPING, PERFORMANCE_MAX
campaign.bidding_strategy_type     -- TARGET_CPA, TARGET_ROAS, MAXIMIZE_CONVERSIONS, etc.
campaign_budget.amount_micros      -- Budget in micros (divide by 1,000,000)
```

### Ad Group Fields
```sql
ad_group.id
ad_group.name
ad_group.status
ad_group.type
```

### Core Metrics
```sql
metrics.impressions
metrics.clicks
metrics.cost_micros               -- Divide by 1,000,000 for actual cost
metrics.ctr                       -- Click-through rate (decimal)
metrics.average_cpc               -- Average CPC in micros
metrics.conversions
metrics.conversions_value
metrics.cost_per_conversion
metrics.conversions_from_interactions_rate  -- Conversion rate
metrics.all_conversions
metrics.view_through_conversions
```

### Quality Score
```sql
ad_group_criterion.quality_info.quality_score
ad_group_criterion.quality_info.creative_quality_score    -- ABOVE_AVERAGE, AVERAGE, BELOW_AVERAGE
ad_group_criterion.quality_info.post_click_quality_score
ad_group_criterion.quality_info.search_predicted_ctr
```

### Date Segments
```sql
segments.date
segments.week
segments.month
segments.quarter
segments.year
segments.day_of_week
segments.hour
```

### Device Segments
```sql
segments.device  -- MOBILE, DESKTOP, TABLET, CONNECTED_TV, OTHER
```

## Example Queries

### Campaign Performance Summary
```sql
SELECT
  campaign.name,
  campaign.status,
  metrics.impressions,
  metrics.clicks,
  metrics.ctr,
  metrics.cost_micros,
  metrics.conversions,
  metrics.cost_per_conversion
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```

### Keyword Performance
```sql
SELECT
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.keyword.match_type,
  ad_group_criterion.quality_info.quality_score,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions,
  metrics.cost_micros
FROM keyword_view
WHERE campaign.status = 'ENABLED'
  AND ad_group.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
LIMIT 50
```

### Search Terms Report
```sql
SELECT
  search_term_view.search_term,
  campaign.name,
  ad_group.name,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions,
  metrics.cost_micros
FROM search_term_view
WHERE segments.date DURING LAST_7_DAYS
  AND metrics.impressions > 10
ORDER BY metrics.impressions DESC
LIMIT 100
```

### Ad Performance
```sql
SELECT
  campaign.name,
  ad_group.name,
  ad_group_ad.ad.responsive_search_ad.headlines,
  ad_group_ad.ad.responsive_search_ad.descriptions,
  metrics.impressions,
  metrics.clicks,
  metrics.ctr,
  metrics.conversions
FROM ad_group_ad
WHERE campaign.status = 'ENABLED'
  AND ad_group_ad.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
```

### Geographic Performance
```sql
SELECT
  geographic_view.country_criterion_id,
  geographic_view.location_type,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions,
  metrics.cost_micros
FROM geographic_view
WHERE segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```

## Date Ranges

| Literal | Meaning |
|---------|---------|
| `TODAY` | Today |
| `YESTERDAY` | Yesterday |
| `LAST_7_DAYS` | Last 7 days |
| `LAST_14_DAYS` | Last 14 days |
| `LAST_30_DAYS` | Last 30 days |
| `LAST_BUSINESS_WEEK` | Mon-Fri of last week |
| `THIS_MONTH` | Current month |
| `LAST_MONTH` | Previous month |
| `'YYYY-MM-DD' AND 'YYYY-MM-DD'` | Custom range |

## Notes

- `cost_micros` values need dividing by 1,000,000
- CTR and conversion rates are decimals (0.05 = 5%)
- Some segments can't be combined — check API docs
- `DURING` is used for date range literals; `BETWEEN` for custom dates
- GAQL is read-only — use mutations for changes
