---
title: Changelog
date: 2026-03-28
tags:
  - mwp
---

# Changelog

## [1.6.0] — 2026-04-03

Phase 2 of the Strategic Upgrade v2.0. New account-strategy skill (the strategic entry point) plus 5 existing skills enhanced for full strategy-awareness. After this release, 10 of 12 skills are profile-aware.

### Added
- **New skill: account-strategy** — interactive 10-dimension account profiling, maps to 15 archetypes, generates tailored strategy document (campaign mix, bid roadmap, tracking upgrade path, budget allocation, vertical-specific notes, key risks)
- **Profile intake sections** in: campaign-review, conversion-tracking, pmax-guide, reporting-pipeline, ads-scripts — each asks account profiling questions and adapts recommendations by archetype
- **Tracking tier classification** in conversion-tracking — diagnoses Basic/Intermediate/Advanced with upgrade path tables and vertical-specific tracking requirements
- **Maturity/budget gating** in pmax-guide — gates PMax by conversion volume (30+/month) and budget (EUR 50/day minimum) before the feed/creative decision fork
- **Pipeline complexity ladder** in reporting-pipeline — Sheets → BQ views → dbt → full sGTM+BQ+dbt+Looker Studio, matched to account maturity
- **Budget-tier script gating** in ads-scripts — Micro=skip, Small=critical only, Medium=standard suite, Large=full automation
- **Review area weighting** in campaign-review — 11 audit areas weighted by archetype, severity thresholds adjusted by maturity
- **Vertical-specific audit items** in campaign-review — e-commerce feed health, lead gen call tracking, B2B SaaS offline pipeline, local services geo targeting
- **Key metrics by vertical** in reporting-pipeline — e-commerce ROAS/AOV, lead gen CPA/CPL, B2B SaaS CPL/CPMQL/CAC, local services CPA per call
- **Reporting cadence by management model** in reporting-pipeline — in-house/agency/freelancer cadence and format
- **Vertical-specific PMax guidance** in pmax-guide — e-commerce feed-only default, lead gen audience signals, local services store goals
- **Vertical-specific script recommendations** in ads-scripts — e-commerce PMax/feed scripts, lead gen conversion alerts, B2B SaaS QS monitor, local services budget pacing
- **"What to Do Next" routing** in all 5 enhanced skills — profile-aware routing to downstream skills
- **Profile skip shortcut** in all enhanced skills — "If you've already run `/account-strategy`, share the profile summary to skip"

### Changed
- campaign-review now weights 11 review areas by account archetype and adjusts severity thresholds by maturity stage
- conversion-tracking now classifies tracking tier (Basic/Intermediate/Advanced) with upgrade path and vertical-specific requirements
- pmax-guide Step 0 now gates by maturity and budget before the feed/creative decision fork, with vertical-specific asset guidance
- reporting-pipeline now recommends pipeline complexity based on maturity and metrics based on vertical
- ads-scripts now recommends scripts based on budget tier, maturity stage, and vertical
- Skill count: 11 → 12; profile-aware skills: 4 → 10

### Fixed
- Dependency maps in `skills/CONTEXT.md` — all 5 enhanced skills now list `strategy/account-profiles`; conversion-tracking also lists `strategy/attribution-guide`
- Routing table in root `CONTEXT.md` — strategy references added to Load column for 5 task rows; account-strategy row no longer marked as Phase 2
- Inter-skill reference map in `skills/CONTEXT.md` — added account-strategy routing entries and updated routing for all 5 enhanced skills
- `plugin.json` version bumped from 1.0.0 to 1.6.0

---

## [1.5.0] — 2026-04-03

Phase 1c of the Strategic Upgrade v2.0. Wires strategy docs into 4 skills — they now ask account profiling questions and adapt recommendations by vertical, maturity, and budget. Completes Findings #3 (dead-ends) and #4 (Socratic/interactive).

### Added
- **Step 1b (Establish Account Profile)** in campaign-setup — asks vertical, maturity, budget; maps to strategy archetype before recommending campaign type
- **Triage Assessment** in campaign-cleanup — 5 diagnostic questions with vertical-specific triage priorities before prescribing fixes
- **Vertical CPA/ROAS benchmarks** in budget-optimizer (e-commerce, lead gen, B2B SaaS, local services)
- **"What to Do Next" routing** in campaign-setup (→ keyword-strategy, conversion-tracking, budget-optimizer, campaign-cleanup)
- Account maturity roadmap reference in budget-optimizer (bidding progression by stage)
- Maturity and competition questions in keyword-strategy Step 1
- Strategy wikilinks in Reference Material of all 4 skills

### Changed
- **campaign-setup Step 2** — Socratic: recommends type based on profile, asks for confirmation instead of lecturing
- **campaign-setup Step 5** — bidding now references maturity stage with 4-stage progression ladder
- **keyword-strategy Step 2** — asks "what do your customers search for?" before suggesting patterns
- **keyword-strategy Step 4** — match type advice adjusted by maturity and competition level
- **budget-optimizer** — asks conversion volume and maturity before recommending; Socratic bid strategy selection
- **campaign-cleanup** — vertical-aware triage (e-commerce → feed health, B2B → tracking, local → geo targeting)

### Fixed
- Dependency maps in `skills/CONTEXT.md` — all 4 skills now list `strategy/account-profiles`; budget-optimizer also lists `strategy/account-maturity-roadmap`
- Routing table in root `CONTEXT.md` — strategy references added to Load column for 4 task rows
- Inter-skill reference map in `skills/CONTEXT.md` — added campaign-setup, keyword-strategy, budget-optimizer routing entries

---

## [1.4.0] — 2026-04-03

Phase 1b of the Strategic Upgrade v2.0. New strategic reference layer — 8 documents covering account profiles, maturity progression, 4 vertical playbooks, targeting framework, and attribution guide.

### Added
- **`strategy/account-profiles.md`** — 10-dimension tiered framework (3 core axes × 4 modifiers × 3 context), 15 strategy archetypes collapsing 64 combinations into actionable playbooks
- **`strategy/account-maturity-roadmap.md`** — 4-stage progression (cold start → early data → established → mature) with graduation criteria, learning period tactics, per-vertical maturity notes
- **`strategy/vertical-ecommerce.md`** — feed-centric playbook: Shopping/PMax mix, ROAS benchmarks (3-8x), margin-tier custom labels, Black Friday planning
- **`strategy/vertical-lead-gen.md`** — CPA-driven playbook: call tracking, offline conversion imports, sub-vertical CPL benchmarks (legal, home services, insurance)
- **`strategy/vertical-b2b-saas.md`** — long-cycle playbook: multi-step funnel (lead→MQL→SQL→close), offline import pipeline, low-volume Smart Bidding workarounds
- **`strategy/vertical-local-services.md`** — location-bound playbook: radius targeting, call-only campaigns, GBP integration, LSA as parallel channel
- **`strategy/targeting-framework.md`** — all 8 audience types, remarketing segmentation matrix (recency × behavior × value), PMax audience signals, layered targeting, frequency capping
- **`strategy/attribution-guide.md`** — 6 attribution models, CPA vs CAC analysis, ROAS vs profit-based metrics, GA4 multi-touch analysis, offline conversion attribution

### Changed
- **`bidding-strategies.md`** — added "Bidding Strategy by Account Profile" section with maturity/volume table, learning period tactics, scaling guidance
- **`account-structure.md`** — added "Structure by Account Profile" section with maturity and budget tier tables
- **`campaign-types.md`** — added "Campaign Type by Account Profile" section with vertical and maturity decision tables
- **`CONTEXT.md`** — added strategy routing row, updated shared resources note

---

## [1.3.0] — 2026-04-03

Phase 1a of the Strategic Upgrade v2.0. Fixes 6 systemic issues across all 11 skills identified in full skill review audit (avg 82/100 → 90+).

### Added
- `argument-hint` frontmatter to 9 skills (was missing from all except campaign-setup and keyword-strategy)
- Troubleshooting section to keyword-strategy (5 failure scenarios)
- Output format template to budget-optimizer and conversion-tracking
- Inter-skill cross-references: keyword-strategy → campaign-setup/budget-optimizer/campaign-review; budget-optimizer → campaign-review/campaign-cleanup/conversion-tracking; campaign-review → conversion-tracking; reporting-pipeline → live-report
- Data sufficiency error handling to campaign-review (minimum data threshold, fallback guidance)
- OAuth flow error handling to connect-mcp (3 new troubleshooting rows)
- `$ARGUMENTS` handling to budget-optimizer and campaign-cleanup
- Report templates companion file for live-report (`references/report-templates.md`)
- Tooling gap guidance callout in reporting-pipeline

### Changed
- **live-report: complete redesign** — was 271 words / 62 score, now ~600 words with GAQL mapping, MCP tool mapping per report type, error handling (7 scenarios), and companion reference file
- `disable-model-invocation` changed to `false` for live-report (was incorrectly `true` for a read-only reporting skill)
- `[bracket]` placeholder syntax replaced with `{{placeholder}}` in all skill output templates (campaign-setup, keyword-strategy, campaign-review, campaign-cleanup)
- Security reminders in connect-mcp strengthened (.gitignore verification, credential rotation)

### Fixed
- Dependency map in `skills/CONTEXT.md` — keyword-strategy and budget-optimizer now list all referenced files
- Dependency map in root `CONTEXT.md` — matching fixes for keyword planning and budget/bids routing rows

---

## [1.2.1] — 2026-04-02

### Fixed (MCP reconnection — post-migration)
- **Restored `~/google-ads.yaml`** — credential file was not backed up during machine migration. Jerry provided credentials, file recreated at `C:\Users\VCL1\google-ads.yaml`
- **Re-registered MCP server** — `claude mcp add google-ads -s user -- "C:\mcp\google-ads.cmd"` → `~/.claude.json`. Registration did not survive migration.
- **Verified working components:** wrapper script (`C:\mcp\google-ads.cmd`), venv, `config.yaml`, client secret JSON, tool permissions in `settings.json` — all intact
- **Identified stale path:** `start-mcp.cmd` in MCP server directory still references old `D:\Jerry\...` path (not actively used; `C:\mcp\google-ads.cmd` is the active wrapper)

### Added
- **LESSONS.md** — 2 migration lessons: credential file backup, MCP re-registration

---

## [1.2.0] — 2026-04-01

### Added
- **Feed-only PMax reference doc** (`pmax/feed-only-pmax.md`) — complete guide: listing group configuration (7 API-verified dimension types), Merchant Center campaign creation flow, minimum viable setup, account restructuring pattern (Shopping+PMax → clean feed-based PMax), external sources (Google API docs, SMEC 4,000+ campaign study)
- **3 Google repos** added to open-source-repos.md: pmax_best_practices_dashboard, feedgen, google-ads-python retail examples
- **3 PMax monitoring scripts** (Nils Rooijmans): Shopping spend drop alert, non-converting search term alerts, placement exclusion suggestions

### Changed
- **pmax-guide skill** restructured — Step 0 decision fork (feed-only / full / non-feed PMax), listing group guidance as first-class step, account restructuring section, updated troubleshooting
- **campaign-setup skill** — PMax block expanded with decision fork (MC feed? → feed-only / full / non-feed), new Shopping campaigns block added
- **campaign-types.md** — decision tree now shows Feed-Only PMax as visible option alongside Shopping
- **shopping-campaigns.md** — comparison table expanded from 2 to 3 columns (Shopping / Feed-Only PMax / Full PMax)
- **asset-requirements.md** — callout added: feed-only PMax doesn't require these assets
- **CONTEXT.md** — routing row added for feed-only PMax / Shopping restructuring
- **All CONTEXT.md files** updated with new file counts and dependency maps
- **START-HERE.md** — skill count corrected (11), campaign-cleanup added to nav table
- **LESSONS.md** — 7 entries added under Campaign Strategy + Performance Max
- **open-source-repos.md** — 2 new sections (Feed & PMax Retail, PMax Monitoring Scripts)

### Fixed
- **campaign-setup skill line 101** — removed factually wrong blocker ("Cannot launch PMax without creative") — feed-only PMax CAN launch with just a Merchant Center feed
- **PMax priority assumption** — added note that PMax is no longer auto-prioritized over Shopping (late 2024 change)

---

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
