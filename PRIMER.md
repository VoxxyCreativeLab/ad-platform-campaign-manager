---
title: Primer — Session Handoff
date: 2026-04-03
tags:
  - mwp
---

# Primer — Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.5.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists. Includes a strategic layer with account profile framework — skills are now profile-aware.

## Last Completed

### Session 2026-04-03: Strategic Upgrade v2.0 — Phase 1 Complete (1a + 1b + 1c)

**Objective:** Add strategic guidance layer to the plugin. Skills were context-blind — gave the same advice regardless of account type. Now they ask about vertical, maturity, and budget before recommending.

**Phase 1a (v1.3.0) — Systemic Skill Fixes:**
- Full skill review audit: scored all 11 skills (avg 82/100), identified 6 systemic issues
- Fixed all 6: argument-hints, placeholder syntax, inter-skill refs, dependency maps, $ARGUMENTS handling
- Redesigned live-report (62/100 → 85+): GAQL mapping, MCP tool mapping, error handling, companion reference file

**Phase 1b (v1.4.0) — Strategic Reference Docs:**
- 8 new docs in `reference/platforms/google-ads/strategy/`: account-profiles (15 archetypes), account-maturity-roadmap (4 stages), 4 vertical playbooks (ecommerce, lead-gen, b2b-saas, local-services), targeting-framework, attribution-guide
- 3 existing docs enhanced with profile-aware sections (bidding-strategies, account-structure, campaign-types)

**Phase 1c (v1.5.0) — Skill Strategy Hooks:**
- 4 skills now profile-aware: campaign-setup, keyword-strategy, budget-optimizer, campaign-cleanup
- campaign-setup: Step 1b (account profile questions), Socratic Step 2, maturity-aware Step 5, "What to Do Next" routing
- keyword-strategy: maturity/competition questions, Socratic keyword seeding, maturity-aware match types
- budget-optimizer: maturity/vertical profiling, Socratic bid strategy, vertical CPA/ROAS benchmarks
- campaign-cleanup: Triage Assessment with vertical-specific priorities
- Findings #3 (dead-ends) and #4 (Socratic) fully resolved

### Prior sessions
- **2026-04-02:** MCP reconnection after machine migration
- **2026-04-01:** Feed-only PMax knowledge gap fix, MCP server built + verified, fact-check sweep

## Current State

### Plugin (ad-platform-campaign-manager)
- **30 reference files** under `platforms/google-ads/` (22 core + 8 strategy)
- **17 script docs** under `reference/scripts/`
- **6 tracking-bridge docs** (the differentiator)
- **5 reporting docs** + **3 MCP docs** + **1 repos catalog**
- **11 skills** — all with argument-hints, inter-skill refs, {{placeholder}} syntax; 4 are profile-aware
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

### Phase 2 — Account Strategy Skill (next up)

New `account-strategy` skill that walks through the full 10-dimension profile and generates a tailored strategy document. Plus enhance 5 remaining skills for strategy-awareness:
- campaign-review, conversion-tracking, pmax-guide, reporting-pipeline, ads-scripts

### Phase 3 — Strategy Agent + Remaining Gaps

New `strategy-advisor` MCP agent that reads live account data and generates strategy. Plus 5 remaining reference docs:
- seasonal-planning, remarketing-strategies, ad-testing-framework, bid-adjustment-framework, shopping-feed-strategy

## Design Documents

- **Design spec:** `docs/superpowers/specs/2026-04-03-strategic-upgrade-design.md`
- **Skill review audit:** `docs/superpowers/specs/2026-04-03-skill-review-audit.md`
- **Phase 1a plan:** `docs/superpowers/plans/2026-04-03-phase-1a-systemic-skill-fixes.md`

## Open Blockers

- **Credential rotation:** OAuth client secret should be rotated (exposed in previous session screenshot)
- **Phase 4 (Multi-platform):** not started — Meta/LinkedIn/TikTok placeholders only
