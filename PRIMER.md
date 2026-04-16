---
title: Primer - Session Handoff
date: 2026-04-16
tags:
  - mwp
---

# Primer - Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.20.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists. v1.21.0 in progress (Session 4 next). v1.22.0 BigQuery Baseline planned.

---

## Last Completed

### Session 2026-04-16 (planning): Backlog Expansion + BigQuery Baseline Plan

- **`BACKLOG.md`** — Added items #14–#18:
  - #14: BigQuery pipeline expansion — GA4/GAds native connectors + n8n BQ→Meta CAPI reverse flow
  - #15: Klaviyo email marketing knowledge base (client: Vaxteronline)
  - #16: Looker Studio dashboards from BigQuery
  - #17: GTM scripts review — cookie collection cHTML (Watermelon plan)
  - #18: Watermelon plan knowledge extraction (100-page doc, strip client-specifics)
- **BigQuery baseline cluster (#14, #17, #18) planned:** design + skill sequencing locked:
  - Skip `/review-skill` (wrong tool). Use `/superpowers:brainstorming` → `/superpowers:writing-plans` → `/superpowers:executing-plans`
  - v1.21.0 finishes first (Sessions 4–5), then v1.22.0 starts
  - Design spec target: `docs/superpowers/specs/2026-04-16-bigquery-baseline-design.md`
  - Plan target: `docs/superpowers/plans/2026-04-16-bigquery-baseline.md`
  - Planning meta-plan saved at `C:\Users\VCL1\.claude\plans\wise-scribbling-cat.md`

### Session 2026-04-14 (Session 3): iClosed Attribution + n8n Pipeline Patterns

- `reference/tracking-bridge/iclosed-attribution.md` — 12 webhook events, GTM Scenario A/B, fbclid passthrough, callOutcome gap, native Meta CAPI context, consent gating.
- `reference/tracking-bridge/n8n-pipeline-patterns.md` — 4-workflow pattern (WF1–WF4), webhook security, Meta CAPI + fbc construction, n8n node reference, pricing (Pro €50/mo recommended).
- `reference/tracking-bridge/CONTEXT.md` — 6 → 8 files, updated routing scenarios.
- **Commit:** `5395be5` — `feat: iClosed attribution + n8n pipeline patterns`

---

## Current State

### Plugin (ad-platform-campaign-manager) — v1.20.0 (v1.21.0 in progress)

| Layer | Count | Notes |
|-------|-------|-------|
| Reference files | 48 | +2 from Session 3 (iclosed-attribution, n8n-pipeline-patterns) |
| Script docs | 17 | under `reference/scripts/` |
| Tracking-bridge docs | 8 | +2 new in Session 3 |
| Reporting docs | 5 | expanding to 6 in v1.21.0 Session 4 (Meta BQ) |
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

### IMMEDIATE: Session 4 — Research Meta BQ (#11) + Cross-Platform (#13)

Full task list in `docs/superpowers/plans/2026-04-14-backlog-expansion.md` (Tasks 17–20).

1. **Online research:** BigQuery Data Transfer Service for Meta (capabilities, field coverage, setup), OWOX Data Marts (`OWOX/owox-data-marts` GitHub), Meta Marketing API (fields, rate limits, pagination), comparison (cost/latency/maintenance). Save to design spec Appendix Session 4.
2. **Create** `reference/reporting/meta-ads-bigquery.md` — 3 pipeline approaches (BQ Data Transfer, OWOX, n8n HTTP), decision matrix, `meta_ads_performance` schema
3. **Extend** `reference/reporting/cross-platform-data-model.md` — 5-source architecture (GA4/Meta/iClosed/Airtable/sGTM), join keys (contactId, callPreviewId), lifecycle stages, fbc formula
4. **Commit** Session 4 + PRIMER.md rewrite

### Session 5: Integration + Release v1.21.0

Full task list in `docs/superpowers/plans/2026-04-14-backlog-expansion.md` (Tasks 21–25).

- **Wire** `CONTEXT.md` — 3 new routing entries (iClosed, n8n, Meta Ads BQ)
- **Update** `CLAUDE.md` — relax "Google Ads only" for tracking-bridge scope
- **Update** `_config/ecosystem.md` — add n8n-plugin note
- **Update** `BACKLOG.md` — mark #10–#13 Done (v1.21.0)
- **Release** v1.21.0 — CHANGELOG, commit, final PRIMER.md rewrite

### AFTER v1.21.0: v1.22.0 BigQuery Baseline (#14, #17, #18)

Session 1:
- Ask Jerry for Watermelon plan document path and GTM scripts inventory
- Invoke `/superpowers:brainstorming` → produces `docs/superpowers/specs/2026-04-16-bigquery-baseline-design.md`
- Invoke `/superpowers:writing-plans` → produces `docs/superpowers/plans/2026-04-16-bigquery-baseline.md`
- Update `PLAN.md` with v1.22.0 section

Sessions 2–5: Execute per plan (see spec + plan files once written).

> [!info] Overlap note
> #14 delta (after v1.21.0 ships): GA4→BQ native export, GAds→BQ via BDTS, **BQ→Meta CAPI reverse offline flow (n8n)**, unified decision matrix. Meta→BQ already covered by #11 (v1.21.0).

### Housekeeping

- **Rotate OAuth client secret** — exposed in session screenshot (2026-04-01). Do in GCP Console before production use.
- **Priority 4 audit:** DSA-specific, App Campaigns — niche, defer
- **Phase 4 Multi-platform:** meta-ads/, linkedin-ads/, tiktok-ads/ platform skills — no demand, defer

---

## Key Research Notes for Session 4

From Session 3 research — carry forward for cross-platform data model work:

- **fbc format:** `fb.1.{subdomainIndex}.{creationTime_ms}.{fbclid}` — NOT booking time, it is LANDING time in ms
- **contactId:** iClosed's internal contact identifier — primary join key across iClosed, Airtable, CAPI events
- **callPreviewId:** unique per call — use as `event_id` for CAPI deduplication
- **iClosed native CAPI events:** Page view, Potential, Qualified, Disqualified, Call booked (`invitee_meeting_scheduled`) — from native integration; custom purchase events need n8n
- **n8n Airtable trigger:** polling only — 5-min polling = ~8,640 executions/month, exceeds Starter (2,500). Use Pro (€50/mo) or poll at 15-min intervals.

---

## Design Documents

- **Backlog expansion design:** `docs/superpowers/specs/2026-04-14-backlog-expansion-design.md` (Session 3 research in Appendix; Session 4 to be added)
- **Backlog expansion plan (25 tasks):** `docs/superpowers/plans/2026-04-14-backlog-expansion.md`
- **BigQuery baseline meta-plan:** `C:\Users\VCL1\.claude\plans\wise-scribbling-cat.md` (outside codebase — decisions + skill sequencing)
- **Report output structure spec:** `docs/superpowers/specs/2026-04-04-report-output-structure-design.md`

## Open Blockers

- **Credential rotation:** OAuth client secret exposed (2026-04-01) — rotate before production
- **Watermelon plan path:** Jerry to provide when v1.22.0 Session 1 begins
- **GTM scripts inventory:** Jerry to provide when v1.22.0 Session 1 begins
