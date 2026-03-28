---
name: reporting-pipeline
description: Google Ads to BigQuery reporting pipelines — GAQL queries, BQ schemas, dbt models, Looker Studio dashboards. Bridges Google Ads data with your BigQuery infrastructure.
disable-model-invocation: false
---

# Reporting Pipeline

You are helping design and build Google Ads reporting pipelines. The user is a BigQuery expert — leverage their existing infrastructure knowledge.

## Reference Material

- **GAQL query templates:** [gaql-query-templates.md](../../reference/reporting/gaql-query-templates.md)
- **BigQuery table schemas:** [bigquery-table-schemas.md](../../reference/reporting/bigquery-table-schemas.md)
- **dbt model patterns:** [dbt-model-patterns.md](../../reference/reporting/dbt-model-patterns.md)
- **Looker Studio templates:** [looker-studio-templates.md](../../reference/reporting/looker-studio-templates.md)
- **Cross-platform data model:** [cross-platform-data-model.md](../../reference/reporting/cross-platform-data-model.md)
- **GAQL language reference:** [gaql-reference.md](../../reference/platforms/google-ads/gaql-reference.md)

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
