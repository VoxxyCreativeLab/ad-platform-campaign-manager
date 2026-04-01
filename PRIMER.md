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

- **Phase 2: Content Completion & MCP Prep** — all 10 steps implemented
- **LESSONS.md updated** in both this plugin and master (`project-structure-and-scaffolding-plugin`) — added critical lesson: Claude must execute marketplace clone sync itself after every push, not just remind the user
- **Marketplace clone sync** executed for both plugins after push

### Phase 2 Deliverables

- 17 Google Ads Script docs across 5 subdirectories (`bidding/` 3, `monitoring/` 4, `reporting/` 3, `cleanup/` 4, `pmax/` 3)
- 3 MCP reference files updated (new official repo `googleads/google-ads-mcp`, Explorer Access tier, `.mcp.json` config)
- `reference/repos/open-source-repos.md` — 9 curated repos
- `_config/ecosystem.md` — added MCP servers, CLIs, external tools
- `skills/connect-mcp/SKILL.md` — Explorer Access as Step 0
- New `campaign-cleanup` skill — account triage for messy/neglected accounts
- `LESSONS.md` seeded with 6 plugin development lessons
- `PLAN.md` updated to 4-phase structure

## Current State

- **84 markdown files** total
- **57 reference files** (17 scripts + 1 repos catalog added)
- **11 skills** (added `campaign-cleanup`)
- **2 agents** (unchanged)
- **0 stale placeholder directories** in scripts/

## Next Steps

1. **Try Explorer Access** — Google Ads → Tools → API Center, check for 2,880 ops/day automatic tier
2. **Install read-only MCP** — `googleads/google-ads-mcp` as first live connection
3. **Test connect-mcp and campaign-cleanup skills** with real accounts
4. **Feed-only PMax via GMC** — document in `pmax-guide` (known gap)
5. **Real client work** — all Phase 1 + 2 skills ready for production

## Open Blockers

- **Phase 3 (MCP integration):** needs Google Ads API credentials — try Explorer Access first
- **Phase 4 (Multi-platform):** not started — Meta/LinkedIn/TikTok placeholders only

## Session Notes

- MCP confirmed as right approach (no official Google Ads CLI exists)
- Official MCP repo: `googleads/google-ads-mcp` (read-only) — community `cohnen/mcp-google-ads` for write ops
- `tracking-bridge/` remains the unique differentiator
- Master plugin: `project-structure-and-scaffolding-plugin`
- **Critical workflow:** after every `git push`, Claude must execute: `git pull` marketplace clone → `claude plugin uninstall` → `claude plugin install`. Never just remind — always execute.
