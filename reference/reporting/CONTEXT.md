# Reporting — Context

5 files for building Google Ads → BigQuery → dbt → Looker Studio pipelines. Designed to leverage the user's existing BigQuery expertise.

Used by: `skills/reporting-pipeline/` and `skills/live-report/` (Phase 2).

## Pipeline Architecture

```
Google Ads API (GAQL queries)
    → BigQuery (raw tables, partitioned by date)
        → dbt models (staging → intermediate → marts)
            → Looker Studio (dashboards)
```

## Reading Order

| Task | Load |
|------|------|
| Write GAQL queries | `gaql-query-templates.md` + `../platforms/google-ads/gaql-reference.md` |
| Design BQ tables | `bigquery-table-schemas.md` |
| Build dbt layer | `dbt-model-patterns.md` |
| Design dashboards | `looker-studio-templates.md` |
| Plan multi-platform | `cross-platform-data-model.md` + `dbt-model-patterns.md` |

## Open-Source References

- `google/ads-api-report-fetcher (gaarf)` — GAQL → CSV/BigQuery tool
- `fivetran/dbt_ad_reporting` — cross-platform dbt models (architecture inspiration)
- `google/pmax_best_practices_dashboard` — Looker Studio PMax dashboard patterns
