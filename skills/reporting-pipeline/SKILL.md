---
name: reporting-pipeline
description: Google Ads to BigQuery reporting pipelines — GAQL queries, BQ schemas, dbt models, Looker Studio dashboards. Use when building or designing a reporting pipeline from Google Ads to BigQuery.
argument-hint: "[gaql|bigquery|dbt|looker-studio]"
disable-model-invocation: false
---

# Reporting Pipeline

You are helping design and build Google Ads reporting pipelines. The user is a BigQuery expert — leverage their existing infrastructure knowledge.

> [!info] Pipeline Design vs Live Data
> This skill helps **design** reporting pipelines (GAQL → BQ → dbt → dashboards). For pulling **live ad-hoc data** interactively, use `/ad-platform-campaign-manager:live-report` instead.

## Reference Material

- **GAQL query templates:** [[../../reference/reporting/gaql-query-templates|gaql-query-templates.md]]
- **BigQuery table schemas:** [[../../reference/reporting/bigquery-table-schemas|bigquery-table-schemas.md]]
- **dbt model patterns:** [[../../reference/reporting/dbt-model-patterns|dbt-model-patterns.md]]
- **Looker Studio templates:** [[../../reference/reporting/looker-studio-templates|looker-studio-templates.md]]
- **Cross-platform data model:** [[../../reference/reporting/cross-platform-data-model|cross-platform-data-model.md]]
- **GAQL language reference:** [[../../reference/platforms/google-ads/gaql-reference|gaql-reference.md]]

## Common Tasks

### Design a Reporting Pipeline
Walk through the full architecture:
1. **Data extraction:** How to pull data from Google Ads (API, gaarf, data transfer, MCP)
2. **Storage:** BigQuery table schemas (partitioned, clustered)
3. **Transformation:** dbt models or BigQuery views
4. **Visualization:** Looker Studio dashboards

### Write GAQL Queries
Use the GAQL reference and templates to write custom queries for specific reporting needs. Always explain:
- Which resource to query
- Available fields and metrics
- Date range options
- Important notes (micros conversion, CTR format)

### Design BigQuery Schemas
Provide table schemas optimized for:
- Cost-efficient querying (partitioning by date)
- Common access patterns (clustering by campaign_id)
- Cross-platform readiness (unified column names)

### Build dbt Models
Design staging → intermediate → mart model architecture:
- Staging: clean and rename raw source data
- Intermediate: joins, calculations, enrichment
- Marts: business-ready reporting tables

### Design Looker Studio Dashboards
Provide dashboard specifications:
- Page layouts with metric selections
- Calculated fields and formulas
- Filter controls
- Conditional formatting rules
- Data source connection guidance

### Plan Cross-Platform Architecture
When the user is planning for multi-platform reporting:
- Use the unified data model from the reference
- Explain normalization mappings (campaign types, statuses)
- Design the dbt model that unifies Google + future Meta/LinkedIn/TikTok

## Pipeline Tooling Options

| Tool | Best For | Complexity |
|------|----------|------------|
| Google Ads Data Transfer | Automated daily BQ export | Low |
| gaarf (ads-api-report-fetcher) | Custom GAQL → BQ | Medium |
| Google Ads API + Cloud Functions | Full control, scheduled | High |
| MCP (Phase 2) | Ad-hoc queries from Claude | Low |
| dbt | Data transformation layer | Medium |
| Looker Studio | Visualization | Low |

> [!note] Getting Started Without All Tools
> Not all tools need to be in place from day one. Start with what's available:
> - **No BigQuery yet?** Start with GAQL queries via MCP → export to Sheets
> - **No dbt yet?** Use BigQuery views for transformation — migrate to dbt later
> - **No Data Transfer?** Use gaarf or Cloud Functions for scheduled exports
> - **No Looker Studio?** BigQuery Console + Sheets dashboards work for early reporting

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| GAQL query returns `Unrecognized field` | Field name is wrong or not available on the queried resource | Check the GAQL reference — field names are resource-specific (e.g., `metrics.cost_micros` not `metrics.cost`); use `segments.*` carefully as some combinations are incompatible |
| BigQuery `Permission denied` on Data Transfer | Service account lacks `bigquery.admin` role or the Data Transfer Service API is not enabled | Grant `BigQuery Admin` role to the transfer service account; enable the BigQuery Data Transfer API in GCP Console |
| dbt model compilation fails | Ref to a missing model or schema mismatch between staging and source table | Run `dbt ls` to verify model graph; check that source table column names match the staging model's `SELECT` |
| Looker Studio shows "no data" | Data source connection expired or the BQ view/table has no rows for the selected date range | Reconnect the data source; verify the date partition filter matches available data; check BQ directly with a `SELECT COUNT(*)` |
| Cost values look 1,000,000× too high | Google Ads API returns cost in micros (1 unit = 1/1,000,000 currency unit) | Divide `cost_micros` by 1,000,000 in your dbt model or BQ view: `cost_micros / 1000000 AS cost` |
| Data is stale (yesterday's data missing) | Data Transfer runs on a schedule (typically overnight); gaarf needs to be triggered | Check transfer run status in BQ Console; for gaarf, verify the Cloud Scheduler or cron job is active |
