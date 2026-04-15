---
title: Primer - Session Handoff
date: 2026-04-14
tags:
  - mwp
---

# Primer - Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.19.1 — Claude Code plugin for Google Ads campaign management, built for tracking specialists.

---

## Last Completed

### Session 2026-04-14 (planning): Backlog Expansion Design + Session 1 Housekeeping

- **Design spec written:** `docs/superpowers/specs/2026-04-14-backlog-expansion-design.md` — covers all 5 open backlog items (#9, #10, #11, #12, #13) across 2 releases (v1.20.0, v1.21.0)
- **Implementation plan written:** `docs/superpowers/plans/2026-04-14-backlog-expansion.md` — 25 tasks, 5-session breakdown with research phases per subject
- **Stale backlog fixed:** Items #5 (shopping queries), #6 (post-launch playbook), #8 (automated post-launch checks) marked Done — all delivered in v1.15.0–v1.18.0 but never updated in status table
- **PLAN.md updated:** v1.20.0 and v1.21.0 sections added
- **Architectural decisions locked:**
  - iClosed + n8n → `reference/tracking-bridge/` (tracking-bridge scope expansion, not new platform dirs)
  - Meta BQ pipeline → `reference/reporting/`
  - n8n stays as separate future plugin for full workflow automation; tracking pipeline patterns only here
  - CLAUDE.md "Google Ads only" rule relaxed for tracking-bridge in Session 5

---

### Session 2026-04-08 (v1.19.1): post-launch-monitor frontmatter fix

- **`skills/post-launch-monitor/SKILL.md`** — Fixed broken frontmatter: changed `skill:` to `name:` (correct registered field), removed invalid `version:` and `tags:` fields (silently ignored by Claude Code), added `argument-hint: "[campaign-name or phase]"`. Skill was not registering correctly in prior state.
- **`LESSONS.md`** — Added lesson: always copy frontmatter from an existing working skill; never generate from memory.

---

## Current State

### Plugin (ad-platform-campaign-manager) — v1.19.1

| Layer | Count | Notes |
|-------|-------|-------|
| Reference files | 46 | 20 core + 5 PMax + 4 audit + 12 strategy + 4 MCP + 1 repos catalog |
| Script docs | 17 | under `reference/scripts/` |
| Tracking-bridge docs | 6 | expanding to 8 in v1.21.0 (iClosed, n8n) |
| Reporting docs | 5 | expanding to 6 in v1.21.0 (Meta BQ pipeline) |
| Skills | 14 | expanding to 15 in v1.20.0 (product-performance) |
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

### Next session (Session 2): Research + Build #9 Product Performance Skill

1. **Online research:** `shopping_performance_view` fields, zombie product thresholds, feed optimization signals, product-level bidding in PMax vs Standard Shopping. Save findings to design spec Appendix (Session 2 section).
2. **Build:** `skills/product-performance/SKILL.md` — wraps 4 existing GAQL queries, interactive analysis flow, report output section
3. **Wire:** `CONTEXT.md` routing entry + `CLAUDE.md` Quick Navigation
4. **Release:** v1.20.0 — commit + CHANGELOG entry

### Session 3: Research iClosed (#10) + n8n (#12)
- Online research: iClosed developer docs (webhooks, API events, tracking object), n8n nodes (BQ/Airtable/webhook), Meta CAPI server event requirements, webhook security
- Write: `reference/tracking-bridge/iclosed-attribution.md`, `reference/tracking-bridge/n8n-pipeline-patterns.md`
- Save research findings to design spec Appendix (Session 3 section)

### Session 4: Research Meta BQ (#11) + Cross-Platform (#13)
- Online research: BQ Data Transfer Service for Meta, OWOX Data Marts, Meta Marketing API, join patterns
- Write: `reference/reporting/meta-ads-bigquery.md`, extend `reference/reporting/cross-platform-data-model.md`
- Save research findings to design spec Appendix (Session 4 section)

### Session 5: Integration + Release v1.21.0
- Wire: `CONTEXT.md` (3 new routing entries), `CLAUDE.md` (tracking-bridge rule), `ecosystem.md` (n8n note)
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
