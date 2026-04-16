---
title: Primer - Session Handoff
date: 2026-04-16
tags:
  - mwp
---

# Primer - Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.20.0 (v1.21.0 **paused**). v1.21.0 Session 4/5 are blocked pending creation of the `n8n-plugin`. See pause memo: `docs/superpowers/plans/2026-04-16-session-4-paused.md`.

---

## Last Completed

### Session 2026-04-16 (this session): Tracking-Bridge Restructure (Phase 1)

Executed `docs/superpowers/specs/2026-04-14-tracking-bridge-restructure-design.md` before Session 4 to prevent double cross-reference work.

**Files changed:**

| File | Change |
|------|--------|
| `reference/tracking-bridge/iclosed-attribution.md` | Full rewrite: Scenario A only (postMessage bridge), WF1-WF4 pipeline flows moved here (incl. BQ schema), Scenario B + native CAPI moved to "Platform Defaults to Override" warnings |
| `reference/tracking-bridge/n8n-pipeline-patterns.md` | Full rewrite: generic patterns only — webhook security, BigQuery streaming conventions, n8n node reference, client account pattern. iClosed WF1-WF4 + Meta CAPI payload + pricing removed |
| `reference/platforms/meta-ads/capi-server-events.md` | **New file** — Meta CAPI payload structure, `action_source` values, `fbc` construction formula, user data hashing (SHA256), event deduplication |
| `reference/tracking-bridge/CONTEXT.md` | Updated: new file descriptions, updated reading order (iClosed → capi-server-events), companion resource note |
| `reference/CONTEXT.md` (root) | Added: tracking-bridge files + new Meta Ads section |
| `CLAUDE.md` | "Google Ads only" permanent rule replaced with "Multi-platform tracking" — campaign management stays Google Ads only; tracking-bridge + `reference/platforms/` may reference any attribution pipeline platform |
| `CONTEXT.md` (plugin root) | Added 3 routing entries: iClosed attribution, n8n pipeline setup, Meta CAPI server events |
| `PLAN.md` | Session 3 commit checked off; Phase 1 restructure section added; Session 4-5 tasks updated |
| `docs/superpowers/specs/2026-04-14-tracking-bridge-restructure-design.md` | Committed (was previously untracked) |

### Session 2026-04-16 (earlier): Backlog Expansion + BigQuery Baseline Plan

- **`BACKLOG.md`** — Added items #14-#18 (BigQuery pipeline expansion, Klaviyo, Looker Studio, GTM scripts review, Watermelon plan extraction)
- **BigQuery baseline cluster planned:** design + skill sequencing in `C:\Users\VCL1\.claude\plans\wise-scribbling-cat.md`

### Session 2026-04-14 (Session 3): iClosed Attribution + n8n Pipeline Patterns

- `reference/tracking-bridge/iclosed-attribution.md` — 12 webhook events, GTM Scenario A/B, fbclid passthrough, callOutcome gap, native Meta CAPI context (commits `5395be5`, `bfcf12f`)
- `reference/tracking-bridge/n8n-pipeline-patterns.md` — 4-workflow pattern (WF1-WF4), webhook security, Meta CAPI + fbc, n8n node reference, pricing
- Note: These were subsequently restructured in this session (2026-04-16 Phase 1)

---

## Current State

### Plugin (ad-platform-campaign-manager) — v1.20.0 (v1.21.0 in progress)

| Layer | Count | Notes |
|-------|-------|-------|
| Reference files | 49 | +1 new this session (capi-server-events.md) |
| Script docs | 17 | under `reference/scripts/` |
| Tracking-bridge docs | 8 | iclosed-attribution + n8n-pipeline-patterns (both rewritten this session) |
| Meta Ads docs | 1 | capi-server-events.md (new this session) |
| Reporting docs | 5 | expanding to 6 in v1.21.0 Session 4 (meta-ads-bigquery.md) |
| Skills | 15 | product-performance added in v1.20.0 |
| Agents | 3 | campaign-reviewer, tracking-auditor, strategy-advisor |
| Audit areas | 21 | All Priority 1-3 complete |

### Branch

`main` — all releases committed directly on main (plugin convention).

### MCP Server (google-ads-mcp-server)

- 25 tools: 3 session + 9 read + 11 write + 2 confirm
- Connected to MCC 7244069584 via Explorer Access (2,880 ops/day)
- Write passphrase: `voxxy-writes`
- Credentials at `C:\Users\VCL1\google-ads.yaml`
- Wrapper at `C:\mcp\google-ads.cmd`

---

## What Still Needs to Happen

### IMMEDIATE: Build n8n-plugin (prerequisite for v1.21.0)

v1.21.0 Sessions 4 and 5 are **paused**. The Meta → BQ pipeline and cross-platform data model both depend on n8n as the transport layer. The `n8n-plugin` must exist first.

**Full pause memo (read before resuming v1.21.0):** `docs/superpowers/plans/2026-04-16-session-4-paused.md`

**After n8n-plugin ships** — return here and resume: Session 4 — Research Meta BQ (#11) + Cross-Platform (#13)

Full task list: `docs/superpowers/plans/2026-04-14-backlog-expansion.md` (Tasks 17-20).

**Step 1 — Online research** (use WebSearch):

| Topic | Research | Save to |
|-------|----------|---------|
| BigQuery Data Transfer Service for Meta | Current status, supported reports, field coverage, 24h refresh, historical backfill, known limitations, cost (free) | Design spec Appendix `### Session 4 Research: Meta BQ + Cross-Platform` |
| OWOX Data Marts | `OWOX/owox-data-marts` GitHub — architecture, setup steps, Meta metric coverage vs BDTS, maintenance overhead | Same |
| Meta Marketing API Insights | Available fields + breakdowns, rate limits (per-account vs per-app), pagination pattern, n8n HTTP Request node auth config | Same |

**Step 2 — Create** `reference/reporting/meta-ads-bigquery.md`

New file, Obsidian frontmatter (`title`, `date: 2026-04-1X`, `tags: [reference, reporting]`). Sections:
1. Overview — why Meta data in BQ (cross-platform reporting, attribution, ROAS comparison across channels)
2. Approach 1: BigQuery Data Transfer Service — setup steps, field coverage, 24h latency, backfill, cost (free), when to use
3. Approach 2: OWOX Data Marts — architecture overview, setup, what it adds vs BDTS, maintenance, when to upgrade
4. Approach 3: n8n HTTP Request to Meta Marketing API — n8n workflow design, auth (long-lived token), pagination, rate limits, when to use (real-time needs, custom fields)
5. Decision Matrix — comparison table: cost / latency / field coverage / maintenance burden / complexity
6. Schema: `meta_ads_performance` — BigQuery table schema for normalized Meta Ads data
7. Cross-References: `[[capi-server-events]]`, `[[n8n-pipeline-patterns]]`, `[[cross-platform-data-model]]`

**Step 3 — Extend** `reference/reporting/cross-platform-data-model.md`

Read the full file first. Then add:

| Section | Content |
|---------|---------|
| `## Multi-Source Architecture` | 5-source table: GA4 (BQ native export, daily, ~24h), Meta Ads (BDTS, daily, ~24h), iClosed (n8n webhook, real-time), Airtable (n8n polling, 5-15 min), sGTM (BQ tag, streaming) — columns: source, connector, refresh, latency, key tables |
| `## Join Key Strategy` | `contactId` as cross-system key (iClosed records ↔ Airtable ↔ CAPI events); `callPreviewId` as CAPI `event_id` for dedup; `fbc` reconstruction formula cross-ref to `capi-server-events.md`; join diagram |
| `## Lead Lifecycle Stages` | Table: Lead / MQL / Booked / SQL / Closed mapped across iClosed events / Airtable status / Meta CAPI event / GA4 event |

**Step 4 — Commit + PRIMER.md rewrite**

```
feat: Meta Ads BQ pipeline + cross-platform data model expansion
```

Files: `reference/reporting/meta-ads-bigquery.md`, `reference/reporting/cross-platform-data-model.md`, `docs/superpowers/specs/2026-04-14-backlog-expansion-design.md`.

Then rewrite PRIMER.md and commit: `docs: PRIMER.md session 4 handoff`

---

### Session 5 — Integration + Release v1.21.0

Full task list: `docs/superpowers/plans/2026-04-14-backlog-expansion.md` (Tasks 21-25).

**Skills to invoke:** `superpowers:executing-plans` or `superpowers:subagent-driven-development`

| Step | File | Change |
|------|------|--------|
| 5.1 | `CONTEXT.md` (plugin root) | Add routing for Meta Ads BQ pipeline — `reference/reporting/meta-ads-bigquery.md` routing entry |
| 5.2 | `_config/ecosystem.md` | n8n-plugin entry: add note that iClosed-specific tracking patterns live in `tracking-bridge/n8n-pipeline-patterns.md` |
| 5.3 | `BACKLOG.md` | Mark #10-#13 Done (v1.21.0) |
| 5.4 | `CHANGELOG.md` | Add v1.21.0 entry (iClosed attribution, n8n pipeline patterns, Meta Ads BQ, cross-platform data model, CLAUDE.md rule, CONTEXT.md routing) |
| 5.5 | `PLAN.md` | v1.21.0 row: `⬜ Not started` → `✅ Done (2026-04-XX)` |
| 5.6 | `PRIMER.md` | Final rewrite — advance to v1.22.0 |
| 5.7 | Commit | `feat: cross-platform tracking expansion — iClosed, n8n, Meta BQ, data model (v1.21.0)` |

> [!note] CLAUDE.md already updated
> The "Google Ads only" → "Multi-platform tracking" rule change was done in Phase 1 restructure (2026-04-16). Session 5 Step 5.1 from the original plan (Task 22) is already complete.

---

### After v1.21.0: v1.22.0 BigQuery Baseline (#14, #17, #18)

**Skills to invoke (in this order):**

1. `/superpowers:brainstorming` → produces `docs/superpowers/specs/2026-04-16-bigquery-baseline-design.md`
2. `/superpowers:writing-plans` → produces `docs/superpowers/plans/2026-04-16-bigquery-baseline.md`
3. Update `PLAN.md` with v1.22.0 section pointing to spec + plan
4. Execute via `/superpowers:executing-plans` or `/superpowers:subagent-driven-development` across sessions

**Needs from Jerry before starting:**
- Path to Watermelon plan document (100-page strategic tracking doc)
- GTM scripts inventory (for #17 — GTM scripts review)

**Meta-plan:** `C:\Users\VCL1\.claude\plans\wise-scribbling-cat.md` (outside codebase — full skill-sequencing decisions)

**Scope delta (#14 after v1.21.0 ships):**
- Meta→BQ (BDTS, OWOX, n8n HTTP): already covered by #11 in v1.21.0 — cross-link only
- n8n→CAPI event-driven: already covered by #12 — cross-link only
- **New in #14:** GA4→BQ native export documentation, Google Ads→BQ via BDTS, BQ→Meta CAPI reverse offline conversion flow (n8n), unified decision matrix across all connector options

---

## Key Research Notes for Session 4

From Session 3 research — carry forward:

- **fbc format:** `fb.1.{subdomainIndex}.{creationTime_ms}.{fbclid}` — creationTime_ms is LANDING time in ms, NOT booking time. Do NOT hash fbc — send as plain string.
- **subdomainIndex:** 1 for root domain (`example.com`), 2 for www subdomain (`www.example.com`)
- **contactId:** iClosed's internal contact identifier — primary join key across iClosed records, Airtable, and CAPI events
- **callPreviewId:** unique per call — use as `event_id` for CAPI deduplication
- **iClosed native CAPI events:** Page view, Potential, Qualified, Disqualified, Call booked — from native integration. Must be disabled when using n8n WF3 (or ensure matching event_id)
- **n8n Airtable trigger:** polling only — 5-min polling = ~8,640 executions/month, exceeds Starter (2,500). Use webhook-based triggers wherever possible; poll at 15-min intervals if polling is required
- **action_source for offline conversions:** `system_generated` — automated system event with no browser session present

---

## Design Documents

| File | Purpose |
|------|---------|
| `docs/superpowers/specs/2026-04-14-backlog-expansion-design.md` | Backlog expansion design (Sessions 2-5) — Session 4 Appendix to be added |
| `docs/superpowers/plans/2026-04-14-backlog-expansion.md` | Implementation plan (Tasks 1-25) — Tasks 17-20 = Session 4, Tasks 21-25 = Session 5 |
| `docs/superpowers/specs/2026-04-14-tracking-bridge-restructure-design.md` | Restructure spec (Phase 1) — fully executed 2026-04-16 |
| `docs/superpowers/specs/2026-04-04-report-output-structure-design.md` | Report output structure spec (v1.8.0) |
| `C:\Users\VCL1\.claude\plans\wise-scribbling-cat.md` | v1.22.0 BigQuery Baseline meta-plan (outside codebase) |

---

## Housekeeping

- **Rotate OAuth client secret** — exposed in session screenshot (2026-04-01). Do in GCP Console before production use. Do NOT use live client account until rotated.
- **Priority 4 audit:** DSA-specific, App Campaigns — niche, low demand, defer indefinitely
- **Phase 4 Multi-platform:** `meta-ads/`, `linkedin-ads/`, `tiktok-ads/` platform skills — no demand, defer (linkedin-ads and tiktok-ads are placeholders only)

---

## Open Blockers

- **OAuth client secret rotation:** GCP Console — must do before production MCP write use
- **Watermelon plan path:** Jerry to provide at v1.22.0 Session 1 start
- **GTM scripts inventory:** Jerry to provide at v1.22.0 Session 1 start
