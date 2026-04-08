---
title: Primer - Session Handoff
date: 2026-04-08
tags:
  - mwp
---

# Primer - Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.15.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists.

## Last Completed

### Session 2026-04-08: Backlog Gap Fill v1.13–v1.15

Three releases shipped on `feature/backlog-gap-fill`:

**v1.13.0 — Learning Phase Authority**
- Created `reference/platforms/google-ads/learning-phase.md` — authoritative safe/disruptive changes tables, per-type durations (Search 7–14d, PMax 14–28d, Demand Gen 14–21d), UI status guide, post-learning checklist
- Fixed 3 active contradictions: `bidding-strategies.md` (2 locations), `feed-only-pmax.md` (Post-Launch restructured with Pre-Learning/Learning Period sub-headings), `common-mistakes.md` #20 expanded
- Fixed 2 ambiguous mentions: `demand-gen.md`, `audit-checklist.md` Demand Gen check
- Wired into root CONTEXT.md (5 Load columns) + google-ads/CONTEXT.md

**v1.14.0 — MCP Capability Map**
- Created `reference/mcp/mcp-capabilities.md` — 6 sections: 25 tools by category (verified against MCP server source), 21 GAQL resources, 12 blocked operations, 10 external data systems, data flow map, per-skill usage summary (17 skills/agents)
- Fixed 4 wrong tool names in `claude-settings-template.md`: `run_gaql_query`→`run_gaql`, `get_account_summary`→`get_account_metrics`, `list_budgets` removed, `unlock_write_session`→`unlock_writes`, added missing `get_campaign`
- Added MCP boundary awareness as Permanent Rule in `CLAUDE.md`
- Wired into 5 Load columns in root CONTEXT.md

**v1.15.0 — Shopping Queries + Post-Launch Playbook**
- Created `reference/platforms/google-ads/strategy/post-launch-playbook.md` — Day 0 through Week 8: launch checklist, Smart Bidding upgrade gates (15/30/50 conv thresholds), per-type milestones, MCP boundary table
- Added 4 Shopping GAQL queries to `gaql-query-templates.md` (top products, zombies, category, low-CTR) using `shopping_performance_view`
- Added Shopping Product Performance as 7th report type in `live-report` (SKILL.md + report-templates.md)
- Wired into root CONTEXT.md + google-ads/CONTEXT.md (strategy files 11→12, total 38→39)

### Session 2026-04-06: Priority 3 Audit Expansion (v1.12.0)

Added 4 new review areas to the audit system, completing all Priority 3 and Account-Level gaps from audit-gap-analysis.md:

- **Video / YouTube (Area 18)** — 12 checks across 3 sub-areas: Creative Quality (hook, branding, companion banners, format testing), Targeting & Controls (frequency capping, placement exclusions, YouTube linking, campaign separation), Measurement (VTC window, VTC vs click analysis, creative refresh, Brand Lift eligibility). GAQL query added for VIDEO channel type with view rate and CPV thresholds.
- **Cross-Campaign Cannibalization (Area 19)** — 5 checks: PMax brand exclusions, PMax vs Shopping product overlap, Search vs DSA cross-negatives, brand campaign protection, cross-campaign negative lists. UI-only (Auction Insights not available via GAQL).
- **Attribution Depth (Area 20)** — 5 checks: attribution windows vs vertical sales cycle, VTC window across all conversion actions, GA4 discrepancy documentation (< 15% normal; > 30% investigate), assisted conversions before pausing upper-funnel, value-based bidding eligibility. GAQL query for conversion_action attribution settings added.
- **Account-Level Strengthening (Area 21)** — 5 checks: Conversion Linker on all pages, auto-generated extensions review, 70/20/10 budget allocation, change history for Smart Bidding stability (> 10 bid strategy changes in 14 days = Warning), data exclusions for measurement gaps. GAQL query for change_event history added.

**Files changed:** audit-checklist.md (+27 checks, 4 new H2 sections), campaign-review SKILL.md (Areas 18-21 + 3 GAQL sections, count 17→21, weighting table expanded), campaign-cleanup SKILL.md (Video/YouTube triage pre-Phase 1 block), campaign-reviewer agent (+4 sections), audit-gap-analysis.md (Priority 3 + Account-Level marked Done), CHANGELOG.md (v1.12.0), PLAN.md, plugin.json (1.11.0→1.12.0).

**Stale files fixed (same session):** PRIMER.md rewritten to v1.12.0; PLAN.md "After v1.9.0" label updated to "After v1.12.0"; agents/CONTEXT.md updated to reflect 3 agents (strategy-advisor was missing); reference/platforms/google-ads/CONTEXT.md updated from "22 files" to "37 files" with accurate breakdown and expanded "Which Skill Loads What" table.

### Session 2026-04-06: Priority 2 Audit Expansion (v1.11.0)

- Added Display (20), Demand Gen (14), Competitive Analysis (6), Feed Health (10) — Areas 14-17 in campaign-review with GAQL queries; Display/Demand Gen triage in campaign-cleanup; campaign-reviewer agent backfilled with 6 missing sections (Shopping, Audience, Display, Demand Gen, Competitive Analysis, Feed Health).
- Created audit-gap-analysis.md as permanent roadmap for future audit expansion.

### Session 2026-04-06: Shopping + Audience Audit Sections (v1.10.0)

- Added 28-item Shopping Specific section (Area 12) and 11-item Audience Strategy section (Area 13) to audit-checklist. Triggered by Vaxteronline Shopping campaign audit miss (EUR 0.10 product group bids, 35% click share undetected).

### Prior sessions (2026-04-04)
- **v1.9.1** — Feed-only PMax correction: MC-only creation path, post-creation lockdown steps, CTV warning
- **v1.9.0** — Ad Copy skill: multilingual RSA, extensions, PMax, Shopping; ad-copy-framework.md
- **v1.8.0** — Report Output Structure: file-based reports, Output Completeness Convention, 6-step write sequence, 19 files modified
- **v1.7.0** — Strategic Upgrade Phase 3: strategy-advisor agent + 5 reference docs
- **v1.3.0-v1.6.0** — Strategic Upgrade Phases 1a-2: skill fixes, 8 strategy docs, 4 skills profile-aware, account-strategy skill

---

## Current State

### Plugin (ad-platform-campaign-manager) — v1.15.0

| Layer | Count | Notes |
|-------|-------|-------|
| Reference files | 42 | 18 core + 5 PMax + 4 audit + 12 strategy + 3 MCP (now 4 with mcp-capabilities) |
| Script docs | 17 | under `reference/scripts/` |
| Tracking-bridge docs | 6 | the differentiator |
| Reporting docs | 5 | + 4 MCP docs + 1 repos catalog |
| Skills | 13 | all with Report Output sections; 11 profile-aware; live-report now has 7 report types |
| Agents | 3 | campaign-reviewer, tracking-auditor, strategy-advisor |
| Audit areas | 21 | All Priority 1-3 complete |

### New in this session
- `learning-phase.md` — safe/disruptive changes authority doc
- `mcp-capabilities.md` — API boundary map (25 tools, 21 GAQL resources, external systems)
- `post-launch-playbook.md` — Day 0–Week 8 monitoring guide
- Shopping `shopping_performance_view` GAQL queries (4 queries)
- MCP boundary awareness in CLAUDE.md Permanent Rules

### Branch
`feature/backlog-gap-fill` — 5 commits ahead of main

### MCP Server (google-ads-mcp-server)

- **33 Python files**, **96 tests**, clean git
- **25 MCP tools** (3 session + 9 read + 11 write + 2 confirm)
- Connected to MCC 7244069584 via Explorer Access (2,880 ops/day)
- Write passphrase: `voxxy-writes`
- Credentials at `C:\Users\VCL1\google-ads.yaml`
- Wrapper at `C:\mcp\google-ads.cmd`

### Credential Files (DO NOT COMMIT)

- `C:\Users\VCL1\google-ads.yaml` — developer token, OAuth client ID/secret, refresh token, login_customer_id
- `C:\mcp\google-ads.cmd` — wrapper script (no secrets, just paths)

---

## What Still Needs to Happen

> **On "continue":** Work is on `feature/backlog-gap-fill`. Check out worktree at `.worktrees/backlog-gap-fill`. Start with v1.16.0 Step 1 — add GAQL sections to `gaql-query-templates.md`.

### Backlog Gap Fill — Remaining (v1.16.0–v1.19.0)

Full plan: `docs/superpowers/plans/2026-04-08-backlog-gap-fill.md`

| Release | Name | Key Deliverable |
|---------|------|-----------------|
| v1.16.0 | GAQL Expansion + Orphaned File Wiring | 8 new GAQL sections + 3 orphaned files (seasonal-planning, bid-adjustment-framework, remarketing-strategies) wired into skills |
| v1.17.0 | Consent Mode v2 | `consent-mode-v2.md` + conversion-tracking Consent Mode section (independent — any order) |
| v1.18.0 | Post-Launch Monitor Skill | New `post-launch-monitor` skill + 3 more live-report types (9 total) |
| v1.19.0 | Display, Brand Restrictions, NCA | `display-campaigns.md` + brand restrictions + NCA goal for PMax/Search |

**v1.16.0 detail:**
1. `reference/reporting/gaql-query-templates.md` — add 8 sections: PMax Campaign Performance, PMax Asset Group Performance, Display Placement Report, Demand Gen Performance, Video Campaign Performance, Auction Insights (note UI-only boundary), Conversion Action Breakdown, Asset Performance
2. `skills/budget-optimizer/SKILL.md` — add `[[seasonal-planning]]` + `[[bid-adjustment-framework]]` references
3. `skills/keyword-strategy/SKILL.md` — add `[[remarketing-strategies]]` + "Existing Account: Search Term Analysis Workflow" section
4. `skills/campaign-cleanup/SKILL.md` — add `campaign-review` to next-skills routing
5. `skills/CONTEXT.md` — update dependency maps
6. `reference/platforms/google-ads/CONTEXT.md` — update Used By for the 3 orphaned files

### Housekeeping
- **Rotate OAuth client secret** — exposed in session screenshot (2026-04-01)
- Add `docs/superpowers/CONTEXT.md`, `docs/superpowers/plans/CONTEXT.md`, `docs/superpowers/specs/CONTEXT.md` — requested but deferred due to session end

### After all 7 releases
- Merge `feature/backlog-gap-fill` → main
- Phase 4: Multi-platform (deferred, no demand)
- Priority 4 audit: DSA (~4 checks), App campaigns (~4 checks) — low priority

---

## Design Documents

- **Backlog gap fill plan (v1.13–v1.19):** `docs/superpowers/plans/2026-04-08-backlog-gap-fill.md`
- **Report output structure spec:** `docs/superpowers/specs/2026-04-04-report-output-structure-design.md`
- **Phase 3 design spec:** `docs/superpowers/specs/2026-04-03-phase-3-strategy-agent-design.md`
- **Phase 2 design spec:** `docs/superpowers/specs/2026-04-03-strategic-upgrade-design.md`
- **Skill review audit:** `docs/superpowers/specs/2026-04-03-skill-review-audit.md`

## Open Blockers

- **Credential rotation:** OAuth client secret should be rotated (exposed 2026-04-01)
- **docs/ CONTEXT.md files:** `docs/superpowers/CONTEXT.md`, `plans/CONTEXT.md`, `specs/CONTEXT.md` not yet created — do at start of next session
