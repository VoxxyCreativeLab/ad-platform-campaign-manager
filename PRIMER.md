---
title: Primer — Session Handoff
date: 2026-04-01
tags:
  - mwp
---

# Primer — Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.2.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists.

## Last Completed

### Session 2026-04-01 (Part 4): Feed-Only PMax Knowledge Gap Fixed

**Problem:** Plugin had zero coverage of feed-only PMax (PMax with Merchant Center feed, no creative assets). When asked to restructure a real e-commerce client's (Vaxteronline) messy Shopping+PMax campaigns, Claude failed — it didn't know feed-only PMax existed, couldn't explain listing groups, and the `campaign-setup` skill had a wrong blocker saying PMax "cannot launch" without creative.

**What was done:**

1. **Created `reference/platforms/google-ads/pmax/feed-only-pmax.md`** (~300 lines)
   - Feed-only PMax config, minimum viable setup, MC Next creation flow
   - Listing group configuration: 7 dimension types (verified against Google Ads API proto)
   - Listing group strategies (margin tier, category, brand, performance, hero products)
   - Account restructuring pattern (Shopping+PMax → clean feed-based PMax)
   - SMEC industry data: 90% of PMax spend is feed-based (4,000+ campaigns)
   - External sources section with Google official docs, API samples, SMEC research
   - Priority change note: PMax no longer auto-prioritized over Shopping (late 2024)

2. **Restructured `pmax-guide` skill** — Step 0 decision fork (feed-only / full / non-feed), listing group guidance as first-class step, restructuring section

3. **Fixed `campaign-setup` skill** — removed wrong blocker (line 101), added PMax decision fork, added missing Shopping campaigns block

4. **Updated 8 more files** — campaign-types decision tree, shopping-campaigns comparison table (3 columns), asset-requirements callout, CONTEXT routing, LESSONS (7 entries), open-source-repos (3 Google repos + 3 monitoring scripts), PLAN, CHANGELOG

**Sources verified:**
- Google Ads API: listing group dimensions, ShoppingSetting fields, retail PMax config
- SMEC (4,000+ campaigns): 90% feed-based, "little-to-no downside of feed-only"
- SMEC: PMax priority change late 2024, 70/30 split recommendation

### Prior sessions (same day)

- **Part 3:** MCP connection verified (25 tools, three-gate safety)
- **Part 2:** Custom MCP server built (96 tests, 25 tools)
- **Part 1:** Reference knowledge base overhaul (4 campaign type docs, fact-check sweep)

## Current State

### Plugin (ad-platform-campaign-manager)
- **22 reference files** under `platforms/google-ads/` (was 21 — added feed-only-pmax.md)
- **17 script docs** under `reference/scripts/`
- **6 tracking-bridge docs** (the differentiator)
- **5 reporting docs** + **3 MCP docs** + **1 repos catalog**
- **11 skills** (9 Phase 1 active + 2 Phase 2 ready to unhide)
- **2 agents** (campaign-reviewer, tracking-auditor)
- All reference docs fact-checked to 2025-2026 accuracy
- Feed-only PMax verified against Google API docs + SMEC industry data

### MCP Server (google-ads-mcp-server)
- **33 Python files**, **96 tests**, clean git
- **25 MCP tools** registered and verified via Claude Code
- Connected to MCC 7244069584 via Explorer Access
- Write passphrase: `voxxy-writes`
- Config: `claude mcp add google-ads -s user -- "C:\mcp\google-ads.cmd"`
- Credentials at `~/google-ads.yaml`
- Wrapper at `C:\mcp\google-ads.cmd`

### Credential Files (DO NOT COMMIT)
- `~/google-ads.yaml` — developer token, OAuth client ID/secret, refresh token, login_customer_id
- `C:\mcp\google-ads.cmd` — wrapper script (no secrets, just paths)
- `D:\Jerry\...\CLAUDE-files\GCS - Google Ads - Client Secret.json` — OAuth JSON backup

## Immediate Next Steps

1. **Rotate OAuth client secret** — exposed in previous session screenshot. GCP Console → Credentials → reset → update `~/google-ads.yaml`
2. **Unhide Phase 2 skills** — `connect-mcp` and `live-report` (set `disable-model-invocation: false`)
3. **Test feed-only PMax workflow** — use pmax-guide skill on Vaxteronline account via MCP tools
4. **Tackle Finding #3** — workflow dead-ends (post-launch monitoring, actionable insights)
5. **Tackle Finding #4** — Socratic skill redesign

## Remaining Audit Findings

| # | Finding | Status |
|---|---------|--------|
| 1 | No API access | ✅ Done — MCP server built, connected, verified |
| 2 | Missing campaign types | ✅ Done |
| 3 | Workflow dead-ends | ⬜ Not started |
| 4 | Skills tell rather than ask | ⬜ Not started |
| 5 | Feed-only PMax knowledge gap | ✅ Done |

## Open Blockers

- **Credential rotation:** OAuth client secret should be rotated (exposed in previous session screenshot)
- **Phase 4 (Multi-platform):** not started — Meta/LinkedIn/TikTok placeholders only

## Session Notes

- Feed-only PMax is the default starting point for e-commerce clients without creative teams — 90% of PMax spend goes to feed-based surfaces anyway
- Listing groups are the #1 most important and most overlooked setup step for feed-based PMax
- Since late 2024, PMax no longer auto-prioritized over Shopping — both compete on Ad Rank
- The pmax-guide skill now has a Step 0 decision fork — always determine PMax type before giving guidance
- **Critical workflow:** after every `git push`, Claude must execute marketplace clone sync (git pull → uninstall → install)
