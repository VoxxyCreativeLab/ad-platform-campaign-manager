# Looker Studio Dashboard Templates

## Dashboard Structure

### Executive Dashboard (1 page)
High-level KPIs for stakeholders.

**Sections:**
1. **Scorecard row:** Total Spend | Conversions | CPA | ROAS | CTR (with comparison to previous period)
2. **Trend chart:** Daily spend + conversions over last 30 days (combo chart)
3. **Campaign table:** Campaign | Spend | Conversions | CPA | ROAS (sortable)
4. **Channel pie chart:** Spend distribution by campaign type (Search, PMax, Display)

**Data source:** `rpt_ad_performance_daily` or `gads_campaign_performance`

### Campaign Deep-Dive (1 page per campaign type)
Detailed performance for campaign managers.

**Search Campaign Page:**
1. Keyword performance table (keyword, QS, impressions, clicks, conversions, CPA)
2. Search terms table (search term, impressions, clicks, conversions)
3. Ad performance table (headline combinations, CTR, conversions)
4. Device breakdown (donut chart)
5. Day-of-week heatmap
6. Hour-of-day heatmap

**PMax Campaign Page:**
1. Asset group performance table
2. Channel distribution (network breakdown)
3. Audience insights (top converting segments)
4. Asset ratings summary

### Conversion Tracking Dashboard (1 page)
For tracking specialists (Jerry's priority).

1. Conversion actions table (action, type, count, value, status)
2. Conversion by source (online vs offline)
3. Enhanced conversion match rate
4. Conversion lag analysis (days between click and conversion)
5. Attribution comparison (data-driven vs last-click)

## Calculated Fields

### CPA (Cost Per Acquisition)
```
Cost / Conversions
```
**Looker Studio:** Create calculated field, type: Number, formula: `cost / conversions`

### ROAS (Return on Ad Spend)
```
Conversion Value / Cost
```
**Looker Studio:** `conversion_value / cost` — format as percentage (×100 for %)

### Conversion Rate
```
Conversions / Clicks
```

### Cost Per Click (CPC)
```
Cost / Clicks
```

### Impression Share Estimate
```
Impressions / (Impressions + Lost Impressions)
```

### Week-over-Week Change
```
(This Week Metric - Last Week Metric) / Last Week Metric
```
Use Looker Studio's built-in comparison date range feature.

## Filter Controls

Every dashboard should include:
- **Date range picker** (with comparison period)
- **Campaign filter** (dropdown)
- **Campaign type filter** (Search, PMax, Display, etc.)
- **Device filter** (Desktop, Mobile, Tablet)

## Looker Studio + BigQuery Connection

1. Create data source: BigQuery → select project → select table/view
2. Use views (`v_gads_weekly_summary`) rather than raw tables for performance
3. Set default date range to "Last 28 days"
4. Enable "Data freshness" to show last update time
5. Use calculated fields in Looker Studio for formatting (currency, percentages)

## Color Coding Conventions

| Metric | Good | Warning | Bad |
|--------|------|---------|-----|
| CPA | Below target | 0-20% above target | 20%+ above target |
| ROAS | Above target | 0-20% below target | 20%+ below target |
| CTR | > 5% (Search) | 2-5% | < 2% |
| Quality Score | 7-10 | 5-6 | 1-4 |
| Conv. Rate | > 5% | 2-5% | < 2% |

Use conditional formatting in Looker Studio tables to apply these colors.
