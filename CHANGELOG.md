---
title: Changelog
date: 2026-03-28
tags:
  - mwp
---

# Changelog

## [1.1.0] — 2026-04-01

### Added
- **Custom Google Ads MCP server** (`../google-ads-mcp-server/`) — 25 tools, 96 tests, three-gate safety architecture
  - 9 read tools: list_accounts, list_campaigns, get_campaign, list_ad_groups, get_campaign_metrics, get_account_metrics, list_keywords, list_ads, run_gaql
  - 11 write tools: pause/enable campaign/ad_group/keyword/ad, update_campaign_budget, update_ad_group_bid, update_keyword_bid
  - 2 confirmation tools: confirm_change, list_pending_plans
  - 3 session tools: unlock_writes, lock_writes, write_status
  - Safety: session passphrase lock, draft-then-confirm ChangePlans, validate_only dry-run, budget ±50% / bid +30% caps, stale-state detection, REMOVE blocked, JSON audit log
- **4 campaign type reference docs:** shopping-campaigns.md, video-campaigns.md, dsa.md, demand-gen.md
- **campaign-cleanup skill** for messy account triage
- **Implementation plan:** `docs/superpowers/plans/2026-04-01-google-ads-mcp-server.md`

### Changed
- **Full fact-check sweep** — all 17 reference docs updated to 2025-2026 accuracy
- **MCP comparison updated** — custom server added as recommended option
- **PLAN.md** — Phase 3 now in progress
- **LESSONS.md** — 8 MCP development lessons added

### Fixed
- Removed deprecated Enhanced CPC from all strategy/bidding tables
- Removed Video Action Campaigns (migrated to Demand Gen)
- Fixed PMax metrics (full search term visibility since March 2025)
- Updated "extensions" → "assets" terminology throughout

### Fixed (MCP connection)
- **`app.py` module split** — moved shared `mcp` FastMCP instance to `google_ads_mcp/app.py` to fix `python -m` dual-instance bug (tools registered on wrong instance, `tools/list` returned empty)
- **MCP config method** — `claude mcp add` CLI instead of manual `~/.claude/.mcp.json` (wrong file) or `~/.claude.json` (overwritten on startup)
- **Windows wrapper** — `C:\mcp\google-ads.cmd` avoids spaces-in-path spawning issues

### Connected
- **MCC:** Voxxy Creative Lab (724-406-9584) via Explorer Access (2,880 ops/day)
- **Credentials:** `~/google-ads.yaml`, `C:\mcp\google-ads.cmd`
- **Verified:** 25 MCP tools confirmed live in Claude Code (2026-04-01)
- **Pending:** OAuth client secret rotation

---

## [1.0.0] — 2026-03-28

### Added
- **Plugin metadata:** plugin.json, marketplace.json, README.md, .gitignore
- **10 skills:** campaign-setup, keyword-strategy, conversion-tracking, reporting-pipeline, campaign-review, pmax-guide, budget-optimizer, ads-scripts, connect-mcp (Phase 2), live-report (Phase 2)
- **2 agents:** campaign-reviewer, tracking-auditor
- **Reference knowledge base (37 files):**
  - Google Ads fundamentals: campaign types, account structure, match types, quality score, ad extensions, bidding strategies, conversion actions, enhanced conversions, GAQL reference, Ads Scripts API
  - PMax: asset requirements, audience signals, feed optimization, metrics
  - Audit: checklist (60+ items), negative keyword lists, common mistakes
  - Tracking bridge: GTM→Ads, sGTM→Ads, BQ→Ads, data flow diagrams, profit-based bidding, value-based bidding
  - Reporting: GAQL templates, BigQuery schemas, dbt models, Looker Studio templates, cross-platform data model
  - Scripts: catalog
  - MCP: server comparison, OAuth guide, settings template
- **CONTEXT.md files** at root + 9 directory junctions
- **Root docs:** CLAUDE.md, PRIMER.md, MEMORY.sh, LESSONS.md, DESIGN.md, CHANGELOG.md
- **Platform placeholders:** meta-ads, linkedin-ads, tiktok-ads (.gitkeep)
