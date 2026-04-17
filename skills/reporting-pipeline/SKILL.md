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
- **Account profiles and archetypes:** [[../../reference/platforms/google-ads/strategy/account-profiles|account-profiles.md]]

## Establish Reporting Context

Before designing a pipeline, understand the account's profile to recommend the right complexity level. If the user has already run `/ad-platform-campaign-manager:account-strategy`, ask them to share the profile summary to skip these questions.

Ask:
1. **"How long has this account been running, and roughly how many conversions per month?"** → map to maturity stage
2. **"Who manages the ads — in-house team, agency, or freelancer?"** → management model
3. **"What vertical is this?"** → determines which metrics matter

## Pipeline Complexity by Maturity

Match pipeline sophistication to the account's maturity. Don't over-engineer early-stage accounts.

| Maturity | Recommended Pipeline | Tools | Why |
|----------|---------------------|-------|-----|
| **Cold start** (0-3 mo) | Google Sheets | GAQL via MCP → copy/paste to Sheets | Not enough data for automated pipelines. Manual review teaches you the account. |
| **Early data** (3-6 mo) | BigQuery views | Google Ads Data Transfer or gaarf → BQ views for metrics | Enough data for basic trends. Views are low-maintenance. |
| **Established** (6-18 mo) | dbt models | Data Transfer → BQ → dbt staging/intermediate/marts | Reliable data volume. dbt gives reproducible transformations and version control. |
| **Mature** (18+ mo) | Full sGTM + BQ + dbt + Looker Studio | sGTM → BQ (raw events) + Data Transfer (cost data) → dbt → Looker Studio | Rich data. Profit-based metrics, LTV, full attribution pipeline. |

> [!warning] Don't Build dbt for a 2-Month-Old Account
> A cold-start account generating 10 conversions/month doesn't need a dbt pipeline. Start with Sheets, graduate to BQ views when data is meaningful, then add dbt when the account is established. Complexity should grow with the account.

## Key Metrics by Vertical

Different verticals need different metrics in their reports:

| Vertical | Primary Metrics | Secondary Metrics | Advanced Metrics |
|----------|----------------|-------------------|-----------------|
| **E-commerce** | ROAS, Revenue, Purchases | AOV, Blended ROAS, MER | Profit margin, LTV by cohort, New vs returning customer ROAS |
| **Lead Gen** | CPA, CPL, Leads | Lead-to-close rate, Cost per closed deal | Offline conversion rate, Lead quality score, Revenue per lead |
| **B2B SaaS** | CPL, CPMQL, Demos | CPSQL, Pipeline value | CAC payback period, LTV:CAC ratio, Revenue by keyword theme |
| **Local Services** | CPA per call/booking, Calls | Call duration, Location performance | Revenue per service type, Seasonal trends, Geographic ROI |

## Reporting Cadence by Management Model

| Model | Cadence | Format | Content |
|-------|---------|--------|---------|
| **In-house** | Weekly summary + daily budget pacing | Dashboard (Looker Studio) + automated alerts | Focus on actionable metrics — what to change this week |
| **Agency** | Monthly deep-dive + bi-weekly email summary | PDF report + live dashboard access | QBR template with exec summary, trends, and next steps |
| **Freelancer** | Weekly report + ad-hoc deep-dives | Sheets or simple dashboard | Flexible — match the client's communication preference |

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

## What to Do Next

Based on the pipeline work completed, recommend the next skill:

| Situation | Next Skill |
|-----------|-----------|
| Pipeline designed, need automated monitoring scripts | `/ad-platform-campaign-manager:ads-scripts` |
| Need ad-hoc live data pulls (not scheduled reports) | `/ad-platform-campaign-manager:live-report` |
| Tracking gaps found during pipeline design | `/ad-platform-campaign-manager:conversion-tracking` |
| Budget allocation needs rethinking based on data | `/ad-platform-campaign-manager:budget-optimizer` |
| No strategy profile established yet | `/ad-platform-campaign-manager:account-strategy` |
| Need to deliver reports as automated scheduled workflows (Slack digest, email, Sheets push) | `/n8n-workflow-builder-plugin:workflow-architect` |

---

## Report Output

When running inside an MWP client project (detected by `stages/` or `reports/` directory):

- **Stage:** `05-optimize`
- **Output file:** `reports/{YYYY-MM-DD}/05-optimize/reporting-pipeline.md`
- **SUMMARY.md section:** Optimization & Reporting
- **Write sequence:** Follow the 6-step write sequence in [[conventions#Report File-Writing Convention]]
- **Completeness:** Follow the [[conventions#Output Completeness Convention]]. No truncation, no shortcuts.
- **Re-run behavior:** If this skill runs twice on the same day, overwrite the existing report file. Update (not duplicate) CONTEXT.md row and SUMMARY.md paragraph.
- **Fallback:** If not in an MWP project, output to conversation (legacy behavior).
