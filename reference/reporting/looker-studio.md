---
title: Looker Studio — Dashboard How-To & Conventions
date: 2026-04-16
tags:
  - reference
  - reporting
  - looker-studio
  - bigquery
---

# Looker Studio — Dashboard How-To & Conventions

Reference for building and maintaining Looker Studio dashboards connected to BigQuery. Covers tool selection, cost/performance rules, blending strategy, calculated-field formulas, and the Voxxy lead-gen dashboard pattern.

> [!note] Scope
> This file covers how to build LS dashboards correctly. For dashboard templates and structural examples (executive dashboard, campaign deep-dive, conversion tracking page, filter controls, color conventions), see [[looker-studio-templates]]. For the BigQuery upstream tables, see [[bigquery-native-connectors]].

---

## 1. When to Use Looker Studio (vs. Alternatives)

**Default choice:** Looker Studio for any single-client paid-media dashboard on a Google stack (GA4 + Google Ads + BigQuery already in place). Free, no infrastructure, native BQ connector.

| Alternative | When to choose it instead |
|-------------|--------------------------|
| **Looker (full / Looker Core)** | Only when you need LookML semantic layer governance, row-level security across a large org, or scheduled Looks for a non-Google-native team. Significant cost and setup. Overkill for single-client paid-media. |
| **Power BI** | Client is Microsoft-native (Azure, SQL Server, Microsoft Fabric) or needs DAX's advanced time-intelligence functions. Not a good fit if data lives in BQ and GA4. |
| **Metabase** | Self-serve SQL exploration by non-Google-stack teams. Weak for pre-built marketing connectors; better as an internal BI tool for engineering/product teams. |
| **Supermetrics / Windsor / Coupler** | Useful as a data-connector layer when clients have non-native sources and don't want a BQ ETL pipeline — but adds a paid middleware. Not needed once BQ is the source of truth. |

---

## 2. BigQuery ↔ Looker Studio — Cost & Performance

### The mantra: blend in BigQuery, visualize in Looker Studio

Do not use Looker Studio's native data blending for production dashboards. Instead:

1. Build a **BQ view** that pre-joins and pre-aggregates the data
2. Connect Looker Studio to that view (one source per report page)
3. Use LS only for visualization, date filtering, and scorecards

Why: LS native blends are opaque (hard to debug), cap at 5 sources, support equality-only joins, and cause performance issues at scale. Custom SQL in the BQ connector is already bypassing the blend — just move the logic to a BQ view where it is version-controlled and cacheable.

### BigQuery cost controls

| Technique | How |
|-----------|-----|
| **Partition pruning** | Always filter on `_PARTITIONTIME` or the partition column in BQ views. LS date pickers pass the selected range as a query param — only works if the view WHERE clause filters by partition. |
| **Materialized views** | For report pages queried repeatedly (daily views, weekly summaries), create a BQ materialized view. Cache hits are free; the view auto-refreshes on schedule. |
| **BI Engine reservation** | Enable for the BQ dataset powering active dashboards. **Free tier: 1 GB per Looker Studio user** with auto-acceleration — covers most single-client dashboards. Paid: $30.36/GB/month up to 250 GB. Enable via GCP Console → BigQuery → BI Engine. [Docs](https://docs.cloud.google.com/looker/docs/studio/accelerate-bigquery-data-with-bi-engine) |
| **Data freshness setting** | In LS data source settings, set "Data freshness" / cache duration. 12h is fine for daily-reporting dashboards; reduces re-queries on every page open. |
| **Custom quotas** | Set per-user BQ query quotas in the GCP Console to prevent runaway scans from misconfigured LS filters. |

> [!warning] Undefined join keys cause cross-joins
> When blending is unavoidable in LS, always define join keys explicitly (Date + Campaign name minimum). Undefined keys produce cross-joins with inflated metric totals that are hard to spot without a row-count check.

---

## 3. Native Blend Limits (for reference)

| Limit | Value |
|-------|-------|
| Max sources per blend | 5 |
| Join type | Equality only (no range, no LEFT OUTER on >2 sources reliably) |
| Debugging | No SQL inspection — black box |
| Performance | Degrades with 2+ sources; materialize in BQ instead |

Source: [Google Cloud — How blends work](https://docs.cloud.google.com/looker/docs/studio/how-blends-work-in-looker-studio); [Dataslayer — 7 Looker Studio blending limitations](https://www.dataslayer.ai/blog/limitations-of-data-blending-in-looker-studio)

---

## 4. Calculated-Field Formulas

These are the canonical formulas. Always use the `SUM(x)/SUM(y)` pattern — never `AVG(ratio)` — to avoid weighted-average errors when the data is aggregated across multiple campaigns or date ranges.

| Metric | Formula | Notes |
|--------|---------|-------|
| **ROAS** | `SUM(conversion_value) / SUM(cost)` | Multiply by 100 for percentage display |
| **CPA** | `SUM(cost) / SUM(conversions)` | — |
| **Conversion Rate (CR)** | `SUM(conversions) / SUM(clicks)` | — |
| **CPC** | `SUM(cost) / SUM(clicks)` | — |
| **CPM** | `SUM(cost) / SUM(impressions) * 1000` | — |
| **Blended ROAS** | `SUM(conversion_value) / SUM(cost)` | Across platforms — requires unified campaign performance table in BQ, not LS blending |
| **Blended CPA** | `SUM(cost) / SUM(conversions)` | Same — BQ view, not LS blend |
| **Week-over-Week %** | Use LS built-in comparison date range | `(current - previous) / previous` — available natively per metric |

> [!tip] SAFE_DIVIDE in BQ, SUM/SUM in LS
> In BQ views: use `SAFE_DIVIDE(SUM(cost), SUM(conversions))` to handle divide-by-zero. In LS calculated fields: the platform handles zero gracefully — just use `SUM(cost) / SUM(conversions)`.

---

## 5. Voxxy 4-Page Lead-Gen Dashboard Pattern

> [!note] Voxxy convention
> This 4-page structure is a Voxxy Creative Lab convention developed through client engagements — it is **not** an industry standard. Adapt as needed. It is optimized for high-ticket coaching funnels with multi-source data (Meta Ads + GA4 + CRM + BigQuery).

### Design principle

**Structure pages by data domain, not by current platform.** A "Campagnes" page covers paid media — not "Meta Ads page." When a second platform is added (Google Ads, LinkedIn), it slots in as a filter toggle, not a new page. This prevents dashboard restructuring every time a new platform is activated.

### Page 1 — Overzicht (Overview)

**Audience:** Client executive or weekly reporting glance

**Content:**
- 5 KPI scorecards: CPL, Leads/week, Call conversion rate, LTV, ROAS — all vs. previous period
- Funnel summary: LEAD → MQL → SQL count and conversion rate (static counts, not a funnel chart — easier to maintain)
- Single trend chart: leads per week (last 12 weeks)

**Data source:** `vw_overview_kpis` BQ view blending ad costs + CRM stage counts

**Grows to:** Add a second funnel column when a second product/offer is tracked.

### Page 2 — Funnel & Leads

**Audience:** Campaign manager, client sales team

**Content:**
- LEAD → MQL → SQL trend (weekly bars, stacked or grouped)
- Stage drop-off rates (% from each stage to next)
- Lead quality breakdown by source (paid / organic / referral)
- Lead source table (platform, leads, MQL rate, SQL rate)

**Data source:** `vw_lead_funnel_weekly` BQ view (CRM data joined to ad source)

**Grows to:** Second funnel column for upsell/second offer; lead scoring model output column.

### Page 3 — Campagnes (Paid Media)

**Audience:** Campaign manager, media buyer

**Content:**
- Platform filter toggle (Meta Ads / Google Ads / LinkedIn — inactive platforms hidden automatically by filter)
- Spend / CPL / CTR / ROAS per campaign and ad set
- Creative performance table (ad-level, with thumbnail if Supermetrics/Windsor feeds images)
- Budget pacing bar (spend-to-date vs. budget allocation)

**Data source:** `vw_campaign_performance_daily` BQ view (unified campaign performance, partitioned by date)

**Grows to:** New platforms are a filter toggle — no structural change.

### Page 4 — Omzet & Retentie (Revenue & Retention)

**Audience:** Client leadership, Pillar 2 growth tracking

**Content:**
- Deal value + pipeline (from CRM)
- LTV per cohort (monthly cohort bars)
- Revenue vs. ad spend (blended ROAS trend, 3-month)
- Retention: month 1 → month 2 → month 3 cohort survival

**Data source:** `vw_revenue_cohorts` BQ view (CRM deals joined to customer table)

**Grows to:** Upsell conversion tracking, subscription renewal rate, churn metrics.

---

## 6. External Template Resources

Link-list only — these are starting points, not canonical references.

| Resource | Cost | Notes |
|----------|------|-------|
| [Windsor.ai template gallery](https://windsor.ai/data-studio-template-gallery/) | Free | ~60 templates, marketer-focused, includes 4-page PPC and lead-gen layouts |
| [Porter Metrics templates](https://portermetrics.com/en/templates/) | Free (data connectors paid) | Clean funnel templates, active 2026 content |
| [Coupler.io dashboard examples](https://blog.coupler.io/looker-studio-dashboard-examples/) | Free | Reference layouts across verticals |
| [Funnel.io free templates](https://funnel.io/resources/google-data-studio-templates) | Free | 7 templates, reputable, no paywall |

> [!note] No canonical open-source template cloner
> A maintained `google/looker-studio-dashboard-cloner` repository does not exist as of 2026 (despite being referenced in various blog posts). The Looker Studio Linking API can programmatically clone dashboards — refer to official Google documentation if needed.

---

## 7. Cross-References

- [[bigquery-native-connectors]] — upstream tables this dashboard connects to; cost control notes for BQ side
- [[looker-studio-templates]] — dashboard structure templates, page layouts, color conventions, filter controls
- [[gaql-query-templates]] — GAQL queries for building the BQ views that power Google Ads pages
- [[cross-platform-data-model]] — unified schema for blending Google Ads + Meta Ads + GA4 in one BQ view

---

## Sources

- [Google Cloud — BI Engine + Looker Studio acceleration](https://docs.cloud.google.com/looker/docs/studio/accelerate-bigquery-data-with-bi-engine)
- [Google Cloud — How blends work in Looker Studio](https://docs.cloud.google.com/looker/docs/studio/how-blends-work-in-looker-studio)
- [Dataslayer — 7 Looker Studio blending limitations](https://www.dataslayer.ai/blog/limitations-of-data-blending-in-looker-studio)
- [Adswerve — Optimize LS connection with BigQuery](https://adswerve.com/technical-insights/how-to-optimize-your-looker-studio-connection-with-bigquery)
- [Gaille Reports — ROAS and CPC formulas in Looker Studio](https://gaillereports.com/how-to-calculate-roas-cpc-in-google-sheets-and-looker-studio/)
