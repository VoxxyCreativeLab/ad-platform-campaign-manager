---
title: Primer - Session Handoff
date: 2026-04-14
tags:
  - mwp
---

# Primer - Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.20.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists.

---

## Last Completed

### Session 2026-04-14 (v1.20.0): Product Performance Skill

- **Research completed:** `shopping_performance_view` fields (additional: `product_custom_attribute0-4`, `product_type_level1-5`, `product_condition`, cart data metrics), zombie thresholds (30-day standard / 90-day seasonal), feed CTR signals (title > GTINs > images > pricing), PMax vs Standard Shopping bidding differences. Saved to design spec Appendix Session 2.
- **`skills/product-performance/SKILL.md`** — New interactive skill: 5-step flow (context → MCP data pull → analysis → recommendations → routing). Wraps 4 `shopping_performance_view` queries. Zombie triage by severity (>€10 spend = high priority). Campaign-type-aware exclusion (Standard Shopping: negative product target; PMax: listing group exclusion). Feed diagnosis table. Report output: stage `05-optimize`.
- **`CONTEXT.md`** — Added routing entry for product performance.
- **`CLAUDE.md`** — Added Quick Navigation: "Analyze product performance".
- **`BACKLOG.md`** — Item #9 marked Done (v1.20.0).

---

### Session 2026-04-14 (planning): Backlog Expansion Design + Session 1 Housekeeping

- **Design spec written:** `docs/superpowers/specs/2026-04-14-backlog-expansion-design.md`
- **Implementation plan written:** `docs/superpowers/plans/2026-04-14-backlog-expansion.md` — 25 tasks, 5-session breakdown
- **Stale backlog fixed:** Items #5, #6, #8 marked Done (delivered in v1.15.0–v1.18.0)

---

## Current State

### Plugin (ad-platform-campaign-manager) — v1.20.0

| Layer | Count | Notes |
|-------|-------|-------|
| Reference files | 46 | 20 core + 5 PMax + 4 audit + 12 strategy + 4 MCP + 1 repos catalog |
| Script docs | 17 | under `reference/scripts/` |
| Tracking-bridge docs | 6 | expanding to 8 in v1.21.0 (iClosed, n8n) |
| Reporting docs | 5 | expanding to 6 in v1.21.0 (Meta BQ pipeline) |
| Skills | 15 | 14 existing + product-performance (new in v1.20.0) |
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

### Next session (Session 3): Research iClosed (#10) + n8n (#12)

1. **Online research:** iClosed developer docs (webhook schemas, API events, `tracking` object with `utmKey_N`/`utmValue_N` fbclid passthrough), n8n nodes (BigQuery, Airtable, webhook, HTTP Request), Meta CAPI server event requirements (`action_source` values, `fbc` construction), webhook security. Save findings to design spec Appendix (Session 3 section).
2. **Write:** `reference/tracking-bridge/iclosed-attribution.md` — 7 webhook events, GTM injection (Scenario A/B), fbclid passthrough, callOutcome attribution gap, consent gating
3. **Write:** `reference/tracking-bridge/n8n-pipeline-patterns.md` — 4-workflow pattern (Booking→CRM, Outcome→CRM, CRM→CAPI, Events→BQ), webhook security, Meta CAPI via n8n, scoped to tracking only
4. **Update:** `reference/tracking-bridge/CONTEXT.md` with new file entries (if it exists)
5. **Commit** Session 3 + PRIMER.md rewrite

### Session 4: Research Meta BQ (#11) + Cross-Platform (#13)
- Online research: BQ Data Transfer Service for Meta, OWOX Data Marts, Meta Marketing API, join patterns. Save to Appendix (Session 4 section).
- Write: `reference/reporting/meta-ads-bigquery.md` — 3 pipeline approaches + decision matrix
- Extend: `reference/reporting/cross-platform-data-model.md` — 5-source architecture, join keys, lifecycle stages, `fbc` formula

### Session 5: Integration + Release v1.21.0
- Wire: `CONTEXT.md` (3 new routing entries), `CLAUDE.md` (relax "Google Ads only" for tracking-bridge), `_config/ecosystem.md` (n8n note)
- Update: `BACKLOG.md` (#10–#13 → Done)
- Release v1.21.0

### Housekeeping
- **Rotate OAuth client secret** — exposed in session screenshot (2026-04-01). Do in GCP Console before any production use.
- **Priority 4 audit:** DSA-specific section (~4 checks), App Campaigns section (~4 checks) — niche, defer
- **Phase 4 Multi-platform:** meta-ads/, linkedin-ads/, tiktok-ads/ platform skills — no demand, defer

---

## Design Documents

- **Backlog expansion design:** `docs/superpowers/specs/2026-04-14-backlog-expansion-design.md`
- **Backlog expansion plan (25 tasks):** `docs/superpowers/plans/2026-04-14-backlog-expansion.md`
- **Backlog gap fill plan:** `docs/superpowers/plans/2026-04-08-backlog-gap-fill.md`
- **Report output structure spec:** `docs/superpowers/specs/2026-04-04-report-output-structure-design.md`
- **Phase 3 design spec:** `docs/superpowers/specs/2026-04-03-phase-3-strategy-agent-design.md`

## Open Blockers

- **Credential rotation:** OAuth client secret exposed (2026-04-01) — rotate before production
