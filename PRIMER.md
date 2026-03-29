---
title: Primer — Session Handoff
date: 2026-03-28
tags:
  - mwp
---

# Primer — Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.0.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists.

## Last Completed

- Full environment inventory: confirmed 4 plugins, 26 plugin skills, 5 agents, 8 system skills, Notion MCP
- Fixed `allowed-tools` frontmatter error in 5 SKILL.md files (ads-scripts, campaign-review, connect-mcp, conversion-tracking, live-report) — attribute is agent-only, not supported in skills
- Verified all 10 SKILL.md frontmatter blocks are clean: only `name`, `description`, `disable-model-invocation`, and `argument-hint` (where applicable)

## Next Steps

1. **Test skills** — invoke each `/ad-platform-campaign-manager:*` skill and verify it loads correctly with reference docs
2. **Real client work** — start using `campaign-setup` and `conversion-tracking` when client Google Ads account is available
3. **Phase 2 prep** — obtain Google Ads API developer token + OAuth credentials for MCP integration

## Open Blockers

- **Phase 2 (MCP integration):** blocked on Google Ads API credentials (developer token, OAuth client ID/secret, refresh token)
- **Multi-platform (Phase 3):** not started — Meta/LinkedIn/TikTok reference folders are empty placeholders

## Session Notes

- `allowed-tools` is valid only in agent `.md` files, not in SKILL.md frontmatter — skills inherit tool access from the harness
- Companion plugins confirmed loaded: gtm-template-builder, project-structure-and-scaffolding, wordpress-fse-builder
- The `tracking-bridge/` section remains the plugin's unique differentiator vs generic campaign tools
