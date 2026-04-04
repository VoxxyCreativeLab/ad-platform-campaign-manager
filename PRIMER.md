---
title: Primer — Session Handoff
date: 2026-04-03
tags:
  - mwp
---

# Primer — Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.6.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists. Includes a full strategic layer with account profile framework — 10 of 12 skills are profile-aware.

## Last Completed

### Session 2026-04-03: Strategic Upgrade v2.0 — Phase 2 Complete (v1.6.0)

**Objective:** Complete the strategic layer. New account-strategy skill as the entry point, plus 5 remaining skills enhanced for strategy-awareness.

**Phase 2 (v1.6.0) — Account Strategy Skill + 5 Skill Enhancements:**
- New `account-strategy` skill: interactive 10-dimension profiler → archetype mapping → strategy document → routing
- campaign-review: profile intake, review area weighting by archetype, severity by maturity, vertical-specific audit items
- conversion-tracking: tracking tier diagnosis (Basic/Intermediate/Advanced), upgrade path, vertical-specific tracking requirements
- pmax-guide: maturity/budget gate (30+ conv/month, EUR 50/day minimum), vertical-specific PMax guidance
- reporting-pipeline: pipeline complexity by maturity (Sheets → BQ → dbt → full), metrics by vertical, cadence by management model
- ads-scripts: budget-tier gating, scripts by maturity stage, vertical-specific recommendations
- All 5 skills now have "What to Do Next" routing and "profile skip shortcut"
- 10 of 12 skills are now profile-aware (only connect-mcp and live-report excluded)

### Prior sessions
- **2026-04-03 (earlier):** Strategic Upgrade Phase 1 complete (1a/1b/1c, v1.3.0-v1.5.0)
- **2026-04-02:** MCP reconnection after machine migration
- **2026-04-01:** Feed-only PMax knowledge gap fix, MCP server built + verified, fact-check sweep


## Current State

### Plugin (ad-platform-campaign-manager)
- **30 reference files** under `platforms/google-ads/` (22 core + 8 strategy)
- **17 script docs** under `reference/scripts/`
- **6 tracking-bridge docs** (the differentiator)
- **5 reporting docs** + **3 MCP docs** + **1 repos catalog**
- **12 skills** — all with argument-hints, inter-skill refs, {{placeholder}} syntax; 10 are profile-aware
- **2 agents** (campaign-reviewer, tracking-auditor)
- All reference docs fact-checked to 2025-2026 accuracy
- All 5 audit findings resolved (Finding #1-#5)

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

## What Still Needs to Happen

### Phase 3 — Strategy Agent + Remaining Gaps (next up)

New `strategy-advisor` MCP agent that reads live account data and generates strategy. Plus 5 remaining reference docs:
- seasonal-planning, remarketing-strategies, ad-testing-framework, bid-adjustment-framework, shopping-feed-strategy

## Design Documents

- **Design spec:** `docs/superpowers/specs/2026-04-03-strategic-upgrade-design.md`
- **Skill review audit:** `docs/superpowers/specs/2026-04-03-skill-review-audit.md`
- **Phase 1a plan:** `docs/superpowers/plans/2026-04-03-phase-1a-systemic-skill-fixes.md`

## Open Blockers

- **Credential rotation:** OAuth client secret should be rotated (exposed in previous session screenshot)
- **Phase 4 (Multi-platform):** not started — Meta/LinkedIn/TikTok placeholders only
