---
title: MCP Capabilities — google-ads-mcp-server
date: 2026-04-08
tags:
  - mcp
  - reference
  - google-ads
---

# MCP Capabilities — google-ads-mcp-server

The single authoritative reference for what the `voxxy/google-ads-mcp-server` can and cannot do. Load this before any skill that uses MCP tools to know what data is available via API vs. what requires manual verification.

> [!info] Scope
> This document covers `voxxy/google-ads-mcp-server` only — the custom server with three-gate safety. Community servers (cohnen/mcp-google-ads) and the official server (googleads/google-ads-mcp) have different tool sets. See [[claude-settings-template]] for connection configs.

---

## Section 1: Tool Inventory (25 tools)

### Session Tools (3)

These control write access and must be used before any write operation.

| Tool | Purpose |
|------|---------|
| `unlock_writes` | Enable write mode by providing the session passphrase (`voxxy-writes`) |
| `lock_writes` | Disable write mode (re-lock after session) |
| `write_status` | Check current write lock state |

### Read Tools (9)

These are always available — no passphrase required.

| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `list_accounts` | All accessible accounts under MCC | — |
| `list_campaigns` | Campaigns with status, budget, bid strategy | `customer_id` |
| `get_campaign` | Single campaign details + current settings | `customer_id`, `campaign_id` |
| `list_ad_groups` | Ad groups for a campaign | `customer_id`, `campaign_id` |
| `get_campaign_metrics` | Performance data (impressions, clicks, cost, conversions) | `customer_id`, `campaign_id`, date range |
| `get_account_metrics` | Account-level rollup metrics | `customer_id`, date range |
| `list_keywords` | Keywords with match type and metrics | `customer_id`, `ad_group_id` |
| `list_ads` | Ads with performance | `customer_id`, `ad_group_id` |
| `run_gaql` | Arbitrary GAQL query against any accessible resource | `customer_id`, `query` |

### Write Tools (11, all gated)

These require `unlock_writes` first. Each write creates a ChangePlan that must be confirmed via `confirm_change`.

| Tool | Purpose | Safety Cap |
|------|---------|-----------|
| `pause_campaign` | Pause a campaign | — |
| `enable_campaign` | Enable a campaign | — |
| `update_campaign_budget` | Change daily budget | ±50% cap per operation |
| `pause_ad_group` | Pause an ad group | — |
| `enable_ad_group` | Enable an ad group | — |
| `update_ad_group_bid` | Change ad group CPC bid | +30% / −50% cap |
| `pause_keyword` | Pause a keyword | — |
| `enable_keyword` | Enable a keyword | — |
| `update_keyword_bid` | Change keyword CPC bid | +30% / −50% cap |
| `pause_ad` | Pause an ad | — |
| `enable_ad` | Enable an ad | — |

### Confirm Tools (2)

| Tool | Purpose |
|------|---------|
| `confirm_change` | Execute a pending ChangePlan after dry-run validation |
| `list_pending_plans` | View all unconfirmed ChangePlans in the current session |

---

## Section 2: GAQL Queryable Resources

These resources are accessible via `run_gaql`. Use standard GAQL syntax (`SELECT ... FROM resource WHERE ... DURING ...`).

| Resource | What It Contains |
|----------|-----------------|
| `campaign` | Campaign settings, status, bid strategy, budget |
| `ad_group` | Ad group settings, status, bids |
| `ad_group_ad` | Individual ads with status and approval state |
| `keyword_view` | Keyword performance (impressions, clicks, cost, QS) |
| `search_term_view` | Search terms that triggered your ads |
| `shopping_performance_view` | Product-level performance (by `item_id`, title, category) |
| `landing_page_view` | Performance by final URL |
| `geographic_view` | Performance by geography |
| `gender_view` | Performance by gender |
| `age_range_view` | Performance by age range |
| `change_status` / `change_event` | Account change history (last 30 days) |
| `performance_max_placement_view` | PMax placement-level data (API v23+, Aug 2025) |
| `conversion_action` | Conversion action configuration and counts |
| `ad_group_criterion` | Keyword-level details, bids, quality scores |
| `campaign_budget` | Budget amounts and utilization |
| `ad_group_ad_asset_view` | Asset-level performance within RSAs/PMax asset groups |
| `group_placement_view` | Placement performance for Display/Demand Gen |
| `customer` | Account-level settings, currency, timezone |
| `asset_group` | PMax asset group status and performance |
| `asset_group_asset` | Individual assets within a PMax asset group |
| `asset_group_listing_group_filter` | PMax listing group structure |

> [!tip] GAQL Reference
> For full query syntax, field names, and example queries see [[gaql-reference]]. For a library of ready-to-run queries see the reporting pipeline reference.

---

## Section 3: What MCP Cannot Do

The following operations are **not possible** via the current MCP server. They require the Google Ads UI or direct API access.

| Action | Why It's Blocked |
|--------|-----------------|
| Create campaigns, ad groups, keywords, or ads | Write tools only support status/bid/budget changes |
| Add or remove negative keywords | No negative keyword mutation tools exist |
| Manage ad extensions / assets | Asset creation not implemented |
| Upload offline conversions | No upload tool — requires Offline Conversion Import API |
| Manage audience lists or Customer Match | Audience management not implemented |
| Edit ad copy | Ad text mutation not implemented |
| Create or manage experiments (A/B tests) | Experiment API not implemented |
| Change bid strategy type | Structural campaign changes not implemented |
| Change campaign targeting (geo, language) | Targeting mutation not implemented |
| Access Merchant Center data | Different API entirely — not in scope |
| Read GA4 or GTM data | Different products, different APIs |

> [!warning] Scope reminder
> If a skill asks Claude to "check" something that isn't in the GAQL resources table above or the tool inventory, it requires **manual verification** — Claude cannot fetch it via MCP.

---

## Section 4: Data Outside the Google Ads API Boundary

Some data that skills reference is in other systems entirely. MCP cannot access these — manual verification is always required.

| Data | System | How to Access | Relevant Skills |
|------|--------|---------------|-----------------|
| MC product feed (disapprovals, GTIN coverage, feed errors) | Merchant Center | MC UI → Diagnostics / Products | pmax-guide, campaign-review Area 17 |
| GA4 analytics data (sessions, bounce rate, page views) | Google Analytics 4 | GA4 UI / GA4 API / BQ export | reporting-pipeline |
| GTM / sGTM container configuration | Google Tag Manager | GTM UI / GTM API | conversion-tracking |
| Consent mode signal state (ad_storage, ad_user_data) | Google Tag / CMP | Tag Assistant / CMP dashboard / DevTools | conversion-tracking |
| Tag firing confirmation | Google Tag Manager | Tag Assistant Live / Preview mode | conversion-tracking |
| BigQuery raw data | BigQuery | BQ Console / bq CLI / API | reporting-pipeline |
| Search Console impression/position data | Google Search Console | GSC UI / API | (not covered) |
| CRM / offline lead data | Client CRM | CRM export / API | conversion-tracking (offline) |
| Firestore profit margin data | Firestore | Console / client libraries | tracking-bridge |
| Google Ads Recommendations | Recommendations API | Google Ads UI → Recommendations | (not covered) |
| Auction Insights | Auction Insights API | Google Ads UI → Auction insights (also limited in GAQL) | campaign-review |
| Quality Score history | QS historical data API | Google Ads UI / limited GAQL | campaign-review |

> [!note] Modeled vs. observed conversions
> The only consent-mode-related signal visible via MCP is the **modeled vs. observed conversion ratio** (available in conversion_action GAQL queries). Consent state itself is invisible to the API. See [[consent-mode-v2]] for details.

---

## Section 5: Data Flow Map

```
[Client GTM] ──tags──▶ [sGTM] ──server-to-server──▶ [Google Ads] ◀── MCP reads here
      │                   │                                │
      ▼                   ▼                                ▼
   [GA4] ◀──────▶ [BigQuery] ◀── dbt staging ──▶ [Offline Upload → Google Ads]
                                                       (no MCP tool)
[Merchant Center] ──feed──▶ [Google Ads Shopping/PMax]
      (no MCP access)              (MCP reads campaign performance only)
[CRM] ──▶ [BigQuery] ──▶ [Offline Conversion Upload] ──▶ [Google Ads]
                                   (no MCP tool — UI or direct API only)
[Google Analytics 4] ──linked account──▶ [Google Ads audience import]
      (GA4 data NOT in Google Ads API)
```

**What MCP can read:** Campaign/ad group/keyword/ad performance, search terms, shopping product performance, change history, conversion action config.

**What MCP can write:** Pause/enable status for campaigns/ad groups/keywords/ads; budget and bid adjustments (within safety caps).

**Everything else** requires the relevant platform's own UI or API.

---

## Section 6: Per-Skill MCP Usage Summary

| Skill / Agent | MCP Tools Used | Manual Verification Required |
|---------------|---------------|------------------------------|
| `live-report` | `run_gaql`, `get_campaign_metrics`, `get_account_metrics`, `list_campaigns` | None (fully MCP-powered for in-API data) |
| `campaign-review` | `run_gaql` (all 21 areas) | MC feed data (Area 17), GTM consent config, Tag Assistant |
| `campaign-cleanup` | `run_gaql`, `list_campaigns`, `list_ad_groups` | Audience list health, consent state |
| `budget-optimizer` | `get_campaign_metrics`, `run_gaql` | Business context, seasonality |
| `account-strategy` | `get_account_metrics`, `list_campaigns`, `run_gaql` | Business goals (manual input) |
| `keyword-strategy` | `run_gaql` (search term mining) | Competitor research (manual) |
| `pmax-guide` | `run_gaql` | MC feed health, asset quality (UI), channel reporting |
| `conversion-tracking` | `run_gaql` (conversion actions) | GTM config, consent mode, tag firing, Tag Assistant |
| `reporting-pipeline` | None (design skill) | n/a — produces GAQL + BQ queries for Jerry to run |
| `campaign-setup` | None (planning skill) | n/a — produces a plan, no live data needed |
| `ad-copy` | None (generation skill) | n/a |
| `ads-scripts` | None (generation skill) | n/a |
| `connect-mcp` | `write_status`, `list_accounts` (verification) | n/a |
| `post-launch-monitor` (v1.18.0) | `get_campaign_metrics`, `run_gaql` | Tracking verification (Tag Assistant), consent state |
| `campaign-reviewer` (agent) | `run_gaql` (all audit areas) | MC data, GTM/consent config |
| `strategy-advisor` (agent) | `get_account_metrics`, `list_campaigns`, `run_gaql` | Business context (manual) |
| `tracking-auditor` (agent) | `run_gaql` (conversion actions) | GTM container, sGTM logs, consent mode |
