---
title: Session 4 Pause Memo — v1.21.0 blocked on n8n-plugin
date: 2026-04-16
tags: [handoff, paused, v1.21.0, session-4, n8n-plugin]
status: paused
---

# Session 4 Pause Memo — v1.21.0 blocked on n8n-plugin

## Why we stopped

Mid-planning for Session 4 (Meta Ads BQ + cross-platform data model expansion), we hit a prerequisite wall: the Meta → BQ pipeline, the cross-platform data model, and the iClosed CAPI workflows all assume n8n as the transport layer. Building those references inside `ad-platform-campaign-manager` before the `n8n-plugin` exists would either duplicate content that naturally belongs in that plugin or bake in design choices prematurely.

**Decision (2026-04-16):** Pause v1.21.0 Session 4/5. Build the `n8n-plugin` first. Resume ad-platform-campaign-manager v1.21.0 Session 4 afterwards — n8n patterns will cross-reference the new plugin instead of being inlined here.

## Invocation note

`/plugin-backlog` was invoked **from outside this codebase** (CWD was not `ad-platform-campaign-manager`). When we restart:

1. Re-enter this working directory
2. Re-read `PRIMER.md`, `PLAN.md`, and this file
3. Re-review the full plan below before doing anything — assumptions will have shifted by the time the `n8n-plugin` exists

---

## Errors in the original plan that must be corrected before Session 4 executes

| # | Original premise | Reality |
|---|------------------|---------|
| 1 | "BigQuery Data Transfer Service for Meta" is Approach 1 | **BDTS has no native Meta/Facebook connector.** BDTS only supports Google products and a few data warehouses. This approach does not exist. Approach 1 must be replaced. |
| 2 | `iclosed-attribution.md` WF4 (iClosed → BigQuery) is an active pattern | **"We do not send data from iClosed to BQ."** WF4 was committed as aspirational content without explicit authorization. |
| 3 | `iclosed-attribution.md` WF3 (CRM → Meta CAPI) is an active pattern | **Jerry did not make the decision to use WF3.** WF3 was committed as aspirational content without explicit authorization. |
| 4 | sGTM → BQ tag is a generic source in the 5-source table | The sGTM → BQ tag is a Voxxy custom; Jerry has JSONs. Scope out of Session 4 — add in a dedicated future session. |
| 5 | `fbc` formula uses `bookingTime_unix` | Correct formula: `fb.1.{subdomainIndex}.{creationTime_ms}.{fbclid}` — `creationTime_ms` is landing time, NOT booking time. Authoritative source: `[[reference/platforms/meta-ads/capi-server-events]]`. Never duplicate here — cross-reference only. |

---

## Open questions to answer before executing

### Q1 — Meta → BQ approach

Given BDTS has no Meta connector, which do we document?

- n8n HTTP Request → Meta Marketing API Insights (will cross-link to `n8n-plugin` once it exists)
- OWOX Data Marts (`OWOX/owox-data-marts`, MIT, self-hosted) as open-source alternative
- Commercial ETL survey (Fivetran / Supermetrics / Windsor.ai / Coupler.io / Funnel.io) — mention-only?
- Manual CSV export from Ads Manager — last-resort fallback?

### Q2 — WF3/WF4 cleanup in iclosed-attribution.md

Current file extensively documents WF3 (CRM → Meta CAPI) and WF4 (iClosed → BigQuery). Neither was explicitly authorized. Options:

- Remove WF3 + WF4 entirely (keep only WF1 + WF2)
- Mark both as "proposed, not in active Voxxy stack"
- Remove WF4 only (no iClosed → BQ); keep WF3 as reference pattern
- Defer to a separate cleanup session; leave as-is

### Q3 — Real source list for the cross-platform data model

If WF4 (iClosed → BQ) is not real and sGTM BQ tag is scoped out, which sources belong in the multi-source architecture table?

Known-real sources:
- GA4 native BigQuery export
- Google Ads BDTS (this IS a real connector)
- Meta Ads (via whatever Q1 answer)

Uncertain:
- sGTM → BQ (real but defer — Jerry has JSONs)
- iClosed → BQ (not used per Jerry)
- Airtable → BQ (is this in use, or is Airtable terminal in the real stack?)

---

## Session 4 plan (preserved — needs review and corrections before executing)

> [!warning] Do not execute as-is
> Steps below contain the errors from the table above. Fix errors first, answer Q1–Q3, then execute.

### Step 1 — Research (WebSearch → append to design spec Appendix)

**Target:** `docs/superpowers/specs/2026-04-14-backlog-expansion-design.md` — append under `### Session 4 Research: Meta BQ + Cross-Platform` (currently `_To be completed in Session 4_`).

**1a. Meta → BQ real options (NOT BDTS — it does not exist for Meta)**
- Commercial ETL connectors: Fivetran, Supermetrics, Windsor.ai, Coupler.io, Funnel.io — pricing, field coverage, maintenance
- OWOX Data Marts: GitHub `OWOX/owox-data-marts`, license, active maintenance, setup overhead, GCP requirements
- Meta Marketing API Insights: available fields, breakdowns, rate limits, pagination (`paging.next`)

**1b. n8n HTTP Request path (cross-references future n8n-plugin)**
- Long-lived system user token auth, pagination loop, retry-on-429
- When n8n beats commercial ETL

### Step 2 — Create `reference/reporting/meta-ads-bigquery.md`

Obsidian frontmatter (`title: Meta Ads to BigQuery Pipeline`, `date: 2026-04-1X`, `tags: [reference, reporting]`).

Sections:
1. **Overview** — why Meta data in BQ; link to `[[cross-platform-data-model]]`
2. **Approach 1: Commercial ETL** (recommended default — lowest maintenance): survey table with Fivetran/Supermetrics/Windsor/Coupler/Funnel price / coverage / maintenance rows
3. **Approach 2: OWOX Data Marts** (open-source alt): architecture, setup, when to upgrade
4. **Approach 3: n8n HTTP Request to Meta Marketing API** (real-time / custom breakdowns): cross-link to `n8n-plugin` for the workflow pattern; this file owns only the Meta-specific payload shape
5. **Decision Matrix** — 3 approaches × 6 criteria: cost / latency / field coverage / maintenance / complexity / when-to-use
6. **Schema: `meta_ads_performance`** — BQ DDL with matching dimension names to `unified_campaign_performance` for clean UNION: `report_date`, `account_id`, `campaign_id`, `adset_id`, `ad_id`, `impressions`, `reach`, `frequency`, `clicks`, `spend`, `actions`, `action_values`, `currency`, `_loaded_at`, `_source`. Partition by `report_date`, cluster by `account_id, campaign_id`.
7. **Cross-References** — `[[capi-server-events]]` (CAPI payload, `fbc` formula, hashing — do NOT duplicate), future `n8n-plugin` link, `[[cross-platform-data-model]]`

### Step 3 — Extend `reference/reporting/cross-platform-data-model.md`

Read full file first (139 lines). Add 3 sections after `## Design Principles`:

**3a. `## Multi-Source Architecture`** — source / connector / refresh / latency / key tables. **Revised list depends on Q3 answers.**

**3b. `## Join Key Strategy`**
- `contactId` — primary cross-system key (iClosed ↔ Airtable ↔ CAPI events)
- `callPreviewId` — `event_id` for CAPI deduplication (see `[[capi-server-events]]`)
- `fbclid → fbc` — **do NOT duplicate formula** — cross-reference `[[capi-server-events]]` only; store landing-time `creationTime_ms` alongside `fbclid` in Airtable at booking time
- `user_pseudo_id` — GA4 + sGTM session stitching
- Small ASCII/Mermaid join diagram

**3c. `## Lead Lifecycle Stages`**

| Stage | iClosed Event | Airtable Status | Meta CAPI Event | GA4 Event |
|-------|--------------|-----------------|-----------------|-----------|
| Lead | `iclosed_potential` | "New Lead" | `Lead` | `generate_lead` |
| MQL | `iclosed_qualified` | "Qualified" | `Lead` (value tier) | `qualify_lead` |
| Booked | Call Booked webhook | "Call Booked" | `Schedule` | `book_call` |
| SQL | `callOutcome` (positive) | "Sales Qualified" | — (not emitted) | — (not emitted) |
| Closed | `callOutcome` (won) | "Closed Won" | `Purchase` | `purchase` |

Remove any rows that depend on WF3 if WF3 is removed from iclosed-attribution.md (Q2 answer).

### Step 4 — Small routing touches

- `reference/CONTEXT.md` (root) — add `meta-ads-bigquery.md` row to Reporting section
- `reference/reporting/CONTEXT.md` — add file index row + reading-order row for "Meta Ads → BigQuery"

Out of scope for Session 4: plugin-root `CONTEXT.md`, `CLAUDE.md`, `_config/ecosystem.md`, `BACKLOG.md`, `CHANGELOG.md`, `PLAN.md`.

### Step 5 — Commit

```
feat: Meta Ads BQ pipeline + cross-platform data model expansion
```

Staged: `reference/reporting/meta-ads-bigquery.md`, `reference/reporting/cross-platform-data-model.md`, `reference/reporting/CONTEXT.md`, `reference/CONTEXT.md`, `docs/superpowers/specs/2026-04-14-backlog-expansion-design.md`.

### Step 6 — Rewrite PRIMER.md + commit

Advance reporting count 5 → 6. Promote Session 5 to IMMEDIATE.

```
docs: PRIMER.md session 4 handoff
```

---

## Verification (when executing after restart)

Before committing:

1. `fbc` formula is NOT written in `meta-ads-bigquery.md` or `cross-platform-data-model.md`. Grep for `fb.1.` — must be zero matches.
2. Decision matrix complete: 3 approaches × 6 criteria, no blanks.
3. `meta_ads_performance` schema columns can UNION with `unified_campaign_performance` (matching dimension names for overlapping fields).
4. Cross-platform data model 5-source (or revised source count) table complete.
5. Q2 answer reflected — WF3/WF4 rows removed or annotated accordingly.
6. Routing rows present in both CONTEXT.md files.

---

## Restart checklist

- [ ] Confirm `n8n-plugin` exists and has: webhook security, BigQuery insert pattern, Meta CAPI HTTP Request pattern, Airtable polling pattern, HTTP Request retry pattern, system user auth
- [ ] Re-read PRIMER.md (active state), PLAN.md (session 4 block), and this file
- [ ] Answer Q1 (Meta → BQ approach)
- [ ] Answer Q2 (WF3/WF4 cleanup in iclosed-attribution.md)
- [ ] Answer Q3 (real source list for the data model)
- [ ] Correct the 5 errors in the table above in the original plan
- [ ] Execute Steps 1–6
