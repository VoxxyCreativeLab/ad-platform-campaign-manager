---
title: Primer - Session Handoff
date: 2026-04-08
tags:
  - mwp
---

# Primer - Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.19.1 — Claude Code plugin for Google Ads campaign management, built for tracking specialists.

---

## Last Completed

### Session 2026-04-08 (v1.19.1): post-launch-monitor frontmatter fix

- **`skills/post-launch-monitor/SKILL.md`** — Fixed broken frontmatter: changed `skill:` to `name:` (correct registered field), removed invalid `version:` and `tags:` fields (silently ignored by Claude Code), added `argument-hint: "[campaign-name or phase]"`. Skill was not registering correctly in prior state.
- **`LESSONS.md`** — Added lesson: always copy frontmatter from an existing working skill; never generate from memory. Root cause: generating frontmatter from memory instead of a verified template.

---

### Session 2026-04-08: Backlog Gap Fill — All 7 Releases Complete (v1.13–v1.19)

The full backlog gap fill plan (v1.13.0–v1.19.0) is now complete on `main`. All work was executed directly on main after a feature branch was merged.

**v1.13.0 — Learning Phase Authority**
- Created `learning-phase.md` — safe/disruptive changes table, per-type durations (Search 7–14d, PMax 14–28d, etc.), UI status guide, post-learning checklist
- Fixed 3 active contradictions: `bidding-strategies.md`, `feed-only-pmax.md`, `common-mistakes.md`

**v1.14.0 — MCP Capability Map**
- Created `mcp-capabilities.md` — 25 tools, 21 GAQL resources, external boundary map, per-skill usage summary
- Fixed 4 wrong tool names in `claude-settings-template.md`
- Added MCP boundary awareness as Permanent Rule in `CLAUDE.md`

**v1.15.0 — Shopping Queries + Post-Launch Playbook**
- Created `post-launch-playbook.md` — Day 0 through Weeks 5-8 with Smart Bidding upgrade gates
- Added 4 Shopping GAQL queries (`shopping_performance_view`)
- Shopping Product Performance as 7th report type in live-report

**v1.16.0 — GAQL Expansion + Orphaned File Wiring**
- Added 8 new GAQL sections (PMax, Display, Demand Gen, Video, Auction Insights, Conversion Actions, Asset Performance) — 24 queries total
- Wired 3 orphaned strategy files: seasonal-planning → budget-optimizer, bid-adjustment-framework → budget-optimizer, remarketing-strategies → keyword-strategy
- Added campaign-review to campaign-cleanup routing

**v1.17.0 — Consent Mode v2**
- Created `consent-mode-v2.md` — 13 sections covering Advanced/Basic mode, behavioral modeling, CMP/TCF v2.2, EEA enforcement, Smart Bidding impact, sGTM forwarding, MCP boundary
- Added Consent Mode section to conversion-tracking skill (diagnostic questions, checklist, testing protocol)

**v1.18.0 — Post-Launch Monitor Skill**
- Created `skills/post-launch-monitor/SKILL.md` — 7-step phase-aware monitoring (Day 1-2 / First Week / Mid-Learning / Post-Learning / Month 2+). MCP tool sequences, learning phase safety gate, MCP-executable vs manual action split, routing table
- Expanded live-report to 10 report types: Audience Performance, PMax Asset Group Performance, Conversion Action Breakdown added
- Wired into campaign-setup routing + CLAUDE.md Quick Navigation

**v1.19.0 — Display, Brand Restrictions, NCA**
- Created `display-campaigns.md` — 12 sections (241 lines) backing all 20 Display audit checks in Area 14
- Added `## Brand Restrictions for Search` to match-types.md (separate from PMax Brand Exclusions)
- Added NCA goal to campaign-types.md for PMax (New Customer Value/Only modes) and Search (manual audience layering)

---

## Current State

### Plugin (ad-platform-campaign-manager) — v1.19.1

| Layer | Count | Notes |
|-------|-------|-------|
| Reference files | 46 | 20 core + 5 PMax + 4 audit + 12 strategy + 4 MCP + 1 repos catalog |
| Script docs | 17 | under `reference/scripts/` |
| Tracking-bridge docs | 6 | the differentiator |
| Reporting docs | 5 | + GAQL templates now 24 queries |
| Skills | 14 | post-launch-monitor added; live-report has 10 report types |
| Agents | 3 | campaign-reviewer, tracking-auditor, strategy-advisor |
| Audit areas | 21 | All Priority 1-3 complete |

### Branch
`main` — all 7 releases committed. Feature branch deleted.

### MCP Server (google-ads-mcp-server)

- 25 tools: 3 session + 9 read + 11 write + 2 confirm
- Connected to MCC 7244069584 via Explorer Access (2,880 ops/day)
- Write passphrase: `voxxy-writes`
- Credentials at `C:\Users\VCL1\google-ads.yaml`
- Wrapper at `C:\mcp\google-ads.cmd`

---

## What Still Needs to Happen

### Housekeeping
- **Rotate OAuth client secret** — exposed in session screenshot (2026-04-01). Do in GCP Console before any production use.

### Low-priority backlog
- **Priority 4 audit:** DSA-specific section (~4 checks), App Campaigns section (~4 checks) — niche, defer
- **Phase 4 Multi-platform:** meta-ads/, linkedin-ads/, tiktok-ads/ — no demand, defer
- **Real client work:** use the plugin skills on a live Google Ads account

### Future enhancements (v1.20+)
- Remarketing/audience strategy skill (reference wired in v1.16, full skill not yet needed)
- A/B testing / experimentation skill (`ad-testing-framework.md` exists as reference)
- MCP server tool expansion (create campaigns, add negatives — requires MCP server dev)

---

## Design Documents

- **Backlog gap fill plan:** `docs/superpowers/plans/2026-04-08-backlog-gap-fill.md`
- **Report output structure spec:** `docs/superpowers/specs/2026-04-04-report-output-structure-design.md`
- **Phase 3 design spec:** `docs/superpowers/specs/2026-04-03-phase-3-strategy-agent-design.md`

## Open Blockers

- **Credential rotation:** OAuth client secret exposed (2026-04-01) — rotate before production
