---
title: "MCP — Context"
tags:
  - mwp
  - layer-2
  - context
---

# MCP — Context

4 files for connecting Claude Code to Google Ads via MCP servers. Phase 2 dependency — all Phase 1 skills work without any API connection.

Used by: `skills/connect-mcp/`, `skills/live-report/`, `skills/campaign-review/`, `skills/campaign-cleanup/`, `skills/budget-optimizer/`, `skills/pmax-guide/`, `skills/conversion-tracking/`

## Files

| File | Content |
|------|---------|
| `mcp-capabilities.md` | **Load first for any MCP-using skill.** Tool inventory (25), GAQL resources, what MCP cannot do, data outside API boundary, per-skill usage summary. |
| `mcp-comparison.md` | Feature matrix: cohnen/mcp-google-ads (full CRUD) vs google_ads_mcp (official, read-only) vs ads-mcp (multi-platform) |
| `oauth-setup-guide.md` | Step-by-step: GCP project, API enablement, OAuth credentials, refresh token |
| `claude-settings-template.md` | Copy-paste settings.json snippets for MCP server configuration |
