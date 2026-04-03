---
title: "Live Report Templates"
date: 2026-04-03
tags:
  - reference
  - reporting
---

# Live Report Templates

%% Companion file for the live-report skill. Contains GAQL queries, MCP tool mappings, and output templates for each report type. %%

## Campaign Performance Summary

### MCP Tools
1. `get_campaign_metrics` — pull campaign-level metrics for a date range
2. `list_campaigns` — get campaign names, types, and statuses

### GAQL Query (if using run_gaql)

```sql
SELECT
  campaign.name,
  campaign.status,
  metrics.cost_micros,
  metrics.impressions,
  metrics.clicks,
  metrics.ctr,
  metrics.conversions,
  metrics.cost_per_conversion,
  metrics.conversions_value,
  metrics.all_conversions
FROM campaign
WHERE campaign.status != 'REMOVED'
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```

### Output Template

```
## Campaign Performance Summary — {{date_range}}

| Campaign | Status | Spend | Impr. | Clicks | CTR | Conv. | CPA | ROAS |
|----------|--------|-------|-------|--------|-----|-------|-----|------|
| {{campaign_name}} | {{status}} | €{{cost}} | {{impressions}} | {{clicks}} | {{ctr}}% | {{conversions}} | €{{cpa}} | {{roas}} |

**Total:** €{{total_spend}} | {{total_conversions}} conversions | €{{avg_cpa}} avg CPA

### Anomalies (>20% change vs previous period)
| Campaign | Metric | Previous | Current | Change |
|----------|--------|----------|---------|--------|
| {{campaign_name}} | {{metric}} | {{previous}} | {{current}} | {{change_pct}}% |
```

---

## Keyword Performance

### MCP Tools
1. `list_keywords` — pull keyword-level data (requires ad_group_id)
2. `list_ad_groups` — enumerate ad groups first
3. `run_gaql` — for custom keyword queries with Quality Score

### GAQL Query

```sql
SELECT
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.keyword.match_type,
  metrics.cost_micros,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions,
  metrics.cost_per_conversion,
  ad_group_criterion.quality_info.quality_score
FROM keyword_view
WHERE segments.date DURING LAST_30_DAYS
  AND ad_group_criterion.status != 'REMOVED'
ORDER BY metrics.cost_micros DESC
LIMIT 50
```

### Output Template

```
## Keyword Performance — {{date_range}}

### Top Keywords by Cost
| Keyword | Match | Ad Group | Spend | Conv. | CPA | QS |
|---------|-------|----------|-------|-------|-----|----|
| {{keyword}} | {{match_type}} | {{ad_group}} | €{{cost}} | {{conv}} | €{{cpa}} | {{qs}}/10 |

### Wasted Spend (cost > €0, conversions = 0)
| Keyword | Match | Spend | Clicks | Action |
|---------|-------|-------|--------|--------|
| {{keyword}} | {{match_type}} | €{{cost}} | {{clicks}} | Pause / add negative / adjust match |

### High Performers (low CPA, room to grow)
| Keyword | CPA | Conv. | Impr. Share | Action |
|---------|-----|-------|-------------|--------|
| {{keyword}} | €{{cpa}} | {{conv}} | {{impr_share}}% | Increase bid / broaden match |
```

---

## Search Terms Analysis

### MCP Tools
1. `run_gaql` — search_term_view requires GAQL

### GAQL Query

```sql
SELECT
  search_term_view.search_term,
  campaign.name,
  metrics.cost_micros,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions
FROM search_term_view
WHERE segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
LIMIT 100
```

### Output Template

```
## Search Terms Analysis — {{date_range}}

### Converting Search Terms (potential keywords to add)
| Search Term | Campaign | Spend | Conv. | CPA |
|-------------|----------|-------|-------|-----|
| {{term}} | {{campaign}} | €{{cost}} | {{conv}} | €{{cpa}} |

### Irrelevant Search Terms (add as negatives)
| Search Term | Campaign | Spend | Clicks | Why Irrelevant |
|-------------|----------|-------|--------|----------------|
| {{term}} | {{campaign}} | €{{cost}} | {{clicks}} | {{reason}} |
```

---

## Budget Pacing

### MCP Tools
1. `get_campaign_metrics` — current spend for the period
2. `list_campaigns` — daily budget per campaign

### Output Template

```
## Budget Pacing Report — {{date}}

| Campaign | Daily Budget | Today's Spend | MTD Spend | Projected Monthly | Budget Utilization |
|----------|-------------|---------------|-----------|-------------------|-------------------|
| {{campaign}} | €{{daily_budget}} | €{{today_spend}} | €{{mtd_spend}} | €{{projected}} | {{utilization}}% |

### Campaigns Limited by Budget
| Campaign | Lost Impr. Share (Budget) | Recommended Budget |
|----------|--------------------------|-------------------|
| {{campaign}} | {{lost_share}}% | €{{recommended}} |
```

---

## Ad Copy Performance

### MCP Tools
1. `list_ads` — pull ad-level data with RSA asset performance
2. `list_ad_groups` — enumerate ad groups

### Output Template

```
## Ad Copy Performance — {{date_range}}

### Per Ad Group
#### {{ad_group_name}}
| Ad | Impr. | Clicks | CTR | Conv. | Conv. Rate |
|----|-------|--------|-----|-------|------------|
| {{ad_label}} | {{impr}} | {{clicks}} | {{ctr}}% | {{conv}} | {{conv_rate}}% |
```

---

## Device & Geographic Breakdown

### MCP Tools
1. `run_gaql` — requires segments.device and geographic_view

### Output Template

```
## Device & Location Breakdown — {{date_range}}

### By Device
| Device | Spend | Conv. | CPA | Conv. Rate | Action |
|--------|-------|-------|-----|------------|--------|
| {{device}} | €{{cost}} | {{conv}} | €{{cpa}} | {{rate}}% | {{recommendation}} |

### By Location (Top 10)
| Location | Spend | Conv. | CPA | Action |
|----------|-------|-------|-----|--------|
| {{location}} | €{{cost}} | {{conv}} | €{{cpa}} | {{recommendation}} |
```
