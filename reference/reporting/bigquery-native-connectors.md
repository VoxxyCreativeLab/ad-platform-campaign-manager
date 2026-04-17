---
title: BigQuery Native Connectors — GA4, Google Ads, Meta Ads
date: 2026-04-16
tags:
  - reference
  - reporting
  - bigquery
  - google-ads
  - meta-ads
  - ga4
---

# BigQuery Native Connectors

Zero-maintenance, Google-hosted pipelines that sync platform data into BigQuery on a recurring schedule. No infrastructure to manage, no code to deploy.

> [!note] Scope
> This file covers the **native path** only — connectors that run inside Google Cloud with no custom code. For sub-daily granularity, real-time events, or reverse BQ→CAPI flows, see the n8n pipeline documentation when available.

---

## Decision Matrix

| Connector | Data source | Refresh | Latency | Cost | Granularity | Best for |
|-----------|-------------|---------|---------|------|-------------|---------|
| GA4 BigQuery Export | GA4 native | Continuous streaming + daily | Streaming: minutes / Daily: ~24h | Free (standard BQ storage/query) | Event-level | Full funnel, user journeys, session analysis |
| Google Ads BQ Data Transfer Service | Google Ads API | Daily (configurable) | ~24h | Free | Campaign/ad group/keyword/day | ROAS, bid monitoring, keyword performance, cross-account |
| Meta Ads BQ Data Transfer Service | Meta Ads API | Daily | ~24h | Free (as of 2026 — billed by slot-hours at scale) | Campaign/ad set/ad/day | Meta spend, CPL, ROAS blended with GA4 and Google Ads |
| OWOX Data Marts | Meta Ads API (direct) | Sub-daily (configurable) | 1-3h | Self-hosted or OWOX managed | Session-level cost attribution | When 24h latency is insufficient; LinkedIn, TikTok, Reddit also supported |
| LinkedIn Ads, TikTok Ads, Reddit Ads | No native BQ DTS connector | Third-party required | Varies | Fivetran (managed) / OWOX Data Marts (OSS) / Airbyte (OSS) | Campaign/ad group/day | No native BQ Data Transfer Service support — OWOX Data Marts (MIT, OSS) is the recommended open-source path; Fivetran/Airbyte for managed |

**Rule of thumb:** Start with all three native connectors. Upgrade to OWOX only if you need sub-daily refresh or session-level cost attribution for Meta.

---

## 1. GA4 — Native BigQuery Export

### What it is

GA4's built-in export sends raw event data to BigQuery. Enabled per property. No API credentials required beyond GA4 admin access.

### Two export modes

| Mode | What you get | Latency |
|------|-------------|---------|
| **Streaming export** | Events as they happen (intraday tables: `events_intraday_YYYYMMDD`) | Minutes |
| **Daily export** | Complete day partition after GA4 processes all data (`events_YYYYMMDD`) | ~24h |

> [!tip] Use both modes
> Query `events_YYYYMMDD` for reporting (complete data). Query `events_intraday_*` for real-time dashboards. Never mix them in the same aggregation — intraday tables are overwritten when the daily table lands.

### Setup

1. GA4 Admin → Property → BigQuery Linking
2. Select GCP project and dataset region
3. Choose: **streaming** (recommended) + **daily export**
4. Link — export starts within ~24h

> [!warning] Free-tier export cap
> The GA4 BQ export caps at **~1M events per day** per property on the free tier. Exceeding the cap **pauses the export entirely** — no backfill occurs while paused. Resume by reducing event volume or upgrading to GA4 360 (removes the cap). Monitor daily event counts in GA4 Admin → BigQuery links. [Source](https://support.google.com/analytics/answer/9823238)

### Key tables

| Table | Contents |
|-------|---------|
| `events_YYYYMMDD` | All events for the day — one row per event per session |
| `events_intraday_YYYYMMDD` | Same structure, real-time, replaced at daily close |
| `pseudonymous_users_YYYYMMDD` | User-level behavioral data (requires consent signal) |

### Transformation layer (recommended)

Raw GA4 export is event-level — not yet sessionized or attributed. Use `google-marketing-solutions/ga4_dataform` (GitHub, 155 stars, active) to transform raw exports into:
- Sessions, users, transactions
- Last-click attribution model
- Standard marketing dimensions

Additional ready-to-use SQL: `aliasoblomov/Bigquery-GA4-Queries` (128 stars) — 65+ queries for funnel analysis, conversion paths, user journeys.

---

## 2. Google Ads — BigQuery Data Transfer Service

### What it is

Google's official connector in BigQuery Data Transfer Service. Syncs Google Ads campaign data — campaigns, ad groups, keywords, ads, and metrics — into partitioned BigQuery tables on a daily schedule.

### Setup

1. BigQuery Cloud Console → Data Transfer → + Create Transfer
2. Source: **Google Ads**
3. Authenticate with Google Ads account (MCC-level recommended for multi-account)
4. Select transfer cadence (daily, default 00:00 UTC)
5. Choose accounts to transfer
6. Set dataset destination

### Standard tables (v22, 2026)

| Table | Contents |
|-------|---------|
| `Campaign` | Campaign-level metrics by date |
| `AdGroup` | Ad group metrics by date |
| `Keyword` | Keyword performance by date |
| `Ad` | Ad creative performance by date |
| `GeoStats` | Geographic performance |
| `SearchQueryStats` | Search term report |
| `ProductPerformance` | Shopping product-level metrics (replaces `shopping_performance_view` queries for historical reporting) |
| `AgeRange`, `Gender` | Demographic breakdowns |

> [!tip] Partitioned by date
> All tables are date-partitioned (`_PARTITIONTIME`). Always filter on `_PARTITIONTIME` or `date` in queries to avoid full scans.

> [!note] API v22 — March 2, 2026
> Google Ads API v22 (released 2026-03-02) added newly populated columns across several standard DTS tables. Check the [BQ DTS change log](https://docs.cloud.google.com/bigquery/docs/transfer-changes) after major API version upgrades to catch new fields landing in existing tables.

### 2026 upgrade: custom GAQL reports in transfer config

Since early 2026, you can embed a **GAQL query** directly into the transfer configuration to ingest custom fields beyond the standard tables. This collapses the old "native vs. API pull" dichotomy for many use cases.

Example: pull campaign-level `value_per_conversion` (not in standard Campaign table) by adding it to a custom report transfer alongside your standard tables.

Official docs: [Google Ads custom reports in BQ DTS](https://docs.cloud.google.com/bigquery/docs/google-ads-transfer)

### Schema reference

Reference schemas and transformation models: `fivetran/dbt_facebook_ads` (49 stars) uses a staging→intermediate→mart pattern that is directly applicable to Google Ads BQ DTS data even without Fivetran. The schema design (not Fivetran-specific) provides a clean template for normalization.

---

## 3. Meta Ads (Facebook Ads) — BigQuery Data Transfer Service

### What it is

Meta Ads connector in BigQuery Data Transfer Service — **generally available as of 2026**. Official Google Cloud connector, no third-party tool required.

> [!important] Correcting prior documentation
> Previous notes in this project stated "BDTS for Meta doesn't exist." This is incorrect as of 2026. The Facebook Ads connector is fully GA and free (standard BQ storage and query costs apply; slot-hours billed at scale).

### Setup

1. BigQuery Cloud Console → Data Transfer → + Create Transfer
2. Source: **Facebook Ads**
3. Authenticate with Meta Ads account (requires Business Manager access)
4. Select ad accounts
5. Choose cadence (daily, default)
6. Set dataset destination

### What it syncs

| Entity | Metrics available |
|--------|-----------------|
| Campaign | Spend, impressions, clicks, reach, frequency, CPM, CPP, CPC |
| Ad set | Same + targeting breakdown |
| Ad | Creative-level performance |
| Demographic | Age/gender breakdown |

Official data model reference: [Meta Ads BQ data model](https://cloud.google.com/bigquery/docs/facebook-ads-transfer)

> [!warning] Latency and attribution window
> Meta Ads BQ DTS data reflects Meta's attribution model (default: 7-day click, 1-day view). ROAS figures from this connector may differ from GA4-attributed ROAS. Use a consistent attribution window when blending both sources.

### Schema inspiration

`fivetran/dbt_facebook_ads` (49 stars, active) — gold-standard Meta Ads schema design. Staging → intermediate → mart layers. Reuse schema patterns even without Fivetran:
- `stg_facebook_ads__ads` — normalized ad-level table
- `int_facebook_ads__ad_sets_budget` — budget and pacing normalized
- `fct_facebook_ads` — daily ad performance fact table

---

## 4. When to Upgrade Beyond Native Connectors

| Need | Solution |
|------|---------|
| Sub-daily Meta Ads refresh | `OWOX/owox-data-marts` (219 stars, MIT, open source) — supports Meta, LinkedIn, TikTok, Reddit. Session-level cost attribution SQL included. |
| Session-level cost attribution (Meta spend → GA4 session) | Same — OWOX includes the cost attribution SQL patterns |
| Real-time offline conversion events (BQ → Meta CAPI) | n8n reverse pipeline — documented separately when n8n-plugin is complete |
| Multi-attribution modeling (first-click, linear, time-decay) | `RuslanFatkhutdinov/sql-for-attribution-models` (41 stars) — SQL models for all major attribution types from GA4 BQ export |
| Email marketing data → BQ (Klaviyo, HubSpot, Mailchimp) | No native BQ DTS connector for any email platform — Fivetran (managed) or Airbyte (OSS) are canonical; see [[klaviyo-fundamentals]] for Klaviyo-specific pipeline guidance |

---

## 5. Looker Studio — Connecting to These Tables

Once native connectors are running, Looker Studio connects directly to BigQuery views built on top of these tables.

**Performance rules:**
- Pre-aggregate in BigQuery views before connecting to Looker Studio
- Define join keys explicitly when blending (Date + Campaign name minimum) — undefined keys cause cross joins with incorrect totals
- Blend at most 3 sources per chart
- Enable BI Engine on the BigQuery dataset for in-memory acceleration
- Use data extracts for dashboards queried repeatedly at fixed intervals

Cross-references: [[looker-studio]] (dashboard how-to, cost/performance, calculated-field formulas, 4-page lead-gen pattern) · [[looker-studio-templates]] (template catalog, dashboard structure, color conventions)

---

## 6. Reference Repos

| Repo | Stars | License | Use |
|------|-------|---------|-----|
| [`google-marketing-solutions/ga4_dataform`](https://github.com/google-marketing-solutions/ga4_dataform) | 155 | Apache 2.0 | Transform raw GA4 BQ export → sessions, users, transactions, last-click attribution |
| [`OWOX/owox-data-marts`](https://github.com/OWOX/owox-data-marts) | 219 | MIT | Meta Ads → BQ (sub-daily); LinkedIn, TikTok, Reddit also supported; session-level cost attribution SQL |
| [`fivetran/dbt_facebook_ads`](https://github.com/fivetran/dbt_facebook_ads) | 49 | BSD-3 | Meta Ads schema design (staging→intermediate→mart) — schema patterns reusable without Fivetran |
| [`aliasoblomov/Bigquery-GA4-Queries`](https://github.com/aliasoblomov/Bigquery-GA4-Queries) | 128 | MIT | 65+ ready SQL queries for GA4 BQ data: funnel, conversion paths, user journeys |
| [`RuslanFatkhutdinov/sql-for-attribution-models`](https://github.com/RuslanFatkhutdinov/sql-for-attribution-models) | 41 | — | SQL for first-click, last-click, linear, time-decay attribution from GA4 BQ export |
| [`GoogleCloudPlatform/bigquery-utils`](https://github.com/GoogleCloudPlatform/bigquery-utils) | 1,290 | Apache 2.0 | Official Google UDFs and utilities for BigQuery |

---

## 7. Cross-References

- [[cross-platform-data-model]] — join key strategy, schema normalization, lead lifecycle stages
- [[looker-studio-templates]] — visualization layer on top of these tables
- [[gaql-query-templates]] — GAQL queries for ad-hoc Google Ads pulls (separate from BQ DTS)
- `reference/platforms/meta-ads/capi-server-events.md` — Meta CAPI payload structure, fbc construction
- n8n pipeline patterns (when complete) — reverse BQ → Meta CAPI offline conversions
