---
title: Primer — Session Handoff
date: 2026-03-31
tags:
  - mwp
---

# Primer — Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.0.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists.

## Last Completed

- **Phase 2: Content Completion & MCP Prep** — all 10 steps implemented:
  - Updated 3 MCP reference files with new official repo (`googleads/google-ads-mcp`), Explorer Access tier (2,880 ops/day, no application), `.mcp.json` project-level config
  - Created 17 Google Ads Script documentation files across 5 subdirectories (`bidding/` 3, `monitoring/` 4, `reporting/` 3, `cleanup/` 4, `pmax/` 3) — all with full working code, config tables, setup instructions
  - Created `reference/repos/open-source-repos.md` — curated catalog of 9 repos (scripts, MCP servers, tracking infrastructure, CLIs)
  - Updated `_config/ecosystem.md` with Google Ads MCP servers, CLIs (`adsctl`, `gaql-cli`), external tools
  - Updated `skills/connect-mcp/SKILL.md` with Explorer Access as Step 0, new official repo, project-level config
  - Created new `campaign-cleanup` skill for messy account triage (9 routing locations updated)
  - Seeded `LESSONS.md` with 5 plugin development lessons from master plugin
  - Updated `PLAN.md` to 4-phase structure

## Current State

- **84 markdown files** total (was 67)
- **57 reference files** (was 39 — added 17 scripts + 1 repos catalog)
- **11 skills** (was 10 — added `campaign-cleanup`)
- **2 agents** (unchanged)
- **0 stale placeholder directories** in scripts/ (all populated with real content)

## Next Steps

1. **Try Explorer Access** — go to Google Ads → Tools → API Center, check for automatic 2,880 ops/day tier to unblock Phase 3
2. **Install read-only MCP** — `googleads/google-ads-mcp` as first live API connection
3. **Test connect-mcp skill** — end-to-end with real credentials
4. **Test campaign-cleanup skill** — on a real messy client account
5. **Feed-only PMax via GMC** — document in `pmax-guide` (gap found in previous testing)
6. **Real client work** — skills are validated and ready for production use

## Open Blockers

- **Phase 3 (MCP integration):** needs Google Ads API credentials — try Explorer Access first (no application needed), fall back to Basic/Standard developer token if needed
- **Multi-platform (Phase 4):** not started — Meta/LinkedIn/TikTok reference folders are empty placeholders

## Session Notes

- MCP confirmed as right approach (no official Google Ads CLI exists)
- Official MCP server moved to `googleads/google-ads-mcp` (read-only, Google policy) — community `cohnen/mcp-google-ads` for write ops
- `tracking-bridge/` remains the plugin's unique differentiator
- Master plugin is `project-structure-and-scaffolding-plugin` — follow its LESSONS.md for save/commit/push patterns
- After push: must run marketplace clone sync (git pull → uninstall → install → reload VSCode)
