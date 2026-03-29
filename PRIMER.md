---
title: Primer — Session Handoff
date: 2026-03-29
tags:
  - mwp
---

# Primer — Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.0.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists.

## Last Completed

- **Full skill review (`/review-skill all`)** — all 10 skills audited against Anthropic best practices and MWP quality criteria
  - 9 of 10 scored 90+/100; `campaign-review` hit 100/100
  - `live-report` scored 87/100 (lowest) — fixed to 95+
- **4 auto-fixes applied:**
  - Added "Use when..." trigger patterns to `conversion-tracking`, `live-report`, `reporting-pipeline` descriptions
  - Added `live-report` routing row to root `CONTEXT.md` (was missing)
- **Troubleshooting sections added to 7 skills** — `ads-scripts`, `budget-optimizer`, `campaign-setup`, `connect-mcp`, `keyword-strategy`, `pmax-guide`, `reporting-pipeline` now all have error handling tables
- **Functional test-run** — ran `campaign-setup`, `pmax-guide`, and `budget-optimizer` end-to-end on a test scenario (plant ecom, Sweden, €80/day, 1000 SKUs, full sGTM)
- **Validation against manual audit** — compared skill output (from minimal input) against a thorough screenshot-based account audit of the same client:
  - Strategic alignment: ~85% (campaign type, bid strategy, audience signals, brand exclusions all correct)
  - Tactical alignment: ~60% (feed-only PMax via GMC, keep Shopping alive were missed)
  - Diagnostic alignment: ~30% (dirty conversion data, legacy tags, structural misconfiguration require live data)
  - Key insight: audience signals predicted by the skill (House Plants, Lawn Care, Landscape Design) matched Google's own discovered converting audiences

## Next Steps

1. **Phase 2 prep** — obtain Google Ads API developer token + OAuth credentials for MCP integration (closes the diagnostic gap found in testing)
2. **Feed-only PMax via GMC** — document the Merchant Center campaign creation method in `pmax-guide` (the skill currently doesn't cover this)
3. **Real client work** — skills are validated and ready for production use
4. **Consider adding a `/campaign-cleanup` skill** — the test revealed a common pattern (messy existing account → stop the bleeding → rebuild) that isn't covered by any current skill

## Open Blockers

- **Phase 2 (MCP integration):** blocked on Google Ads API credentials (developer token, OAuth client ID/secret, refresh token)
- **Multi-platform (Phase 3):** not started — Meta/LinkedIn/TikTok reference folders are empty placeholders

## Session Notes

- All 10 skills now have error handling/troubleshooting sections
- All 10 skills listed in all 3 routing locations (skills/CONTEXT.md, root CONTEXT.md, README.md)
- All 48 file references verified as existing — zero broken links
- The biggest quality gap is diagnostic: skills produce solid strategic plans from minimal input but can't detect conversion tracking pollution, structural misconfiguration, or inflated ROAS without live account data
- `tracking-bridge/` remains the plugin's unique differentiator vs generic campaign tools
