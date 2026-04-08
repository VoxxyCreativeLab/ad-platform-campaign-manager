---
title: Changelog
date: 2026-03-28
tags:
  - mwp
---

# Changelog

## [1.13.0] — 2026-04-08

Resolves 3 active contradictions in Smart Bidding learning phase guidance discovered during real-world Vaxteronline client work. Creates single authoritative reference for safe vs. disruptive changes, per-type learning durations, and post-learning checklist. Wires into all relevant routing tables.

### Added
- **`reference/platforms/google-ads/learning-phase.md`** — new authoritative reference: safe vs. disruptive changes tables, per-type learning durations (Search 7–14d, PMax 14–28d, Demand Gen 14–21d, Display/Video/Shopping 7–14d), technical explanation of what "resets learning" means, how to check learning status in UI, post-learning checklist.

### Fixed
- **`bidding-strategies.md`** — Two contradictory "no changes" statements replaced with precise safe/disruptive distinction + `[[learning-phase]]` wikilinks (Learning Period section + Learning Period Tactics).
- **`pmax/feed-only-pmax.md`** — Post-Launch section restructured: brand exclusions + negative keywords moved under "Pre-Learning Setup" heading with explicit safety note; step 14 clarified to specify disruptive changes only. Migration step 6 updated similarly. Added `[[learning-phase]]` wikilinks.
- **`audit/common-mistakes.md`** — Mistake #20 expanded from vague "making changes resets it" to specific disruptive change list + safety note for negatives/ad copy + `[[learning-phase]]` wikilink.
- **`demand-gen.md`** — "Judging too early" common mistake updated with disruptive/safe distinction + `[[learning-phase]]` wikilink.
- **`audit/audit-checklist.md`** — Demand Gen learning period audit check updated with "disruptive changes" qualifier + `[[learning-phase]]` wikilink.

### Changed
- **`reference/platforms/google-ads/CONTEXT.md`** — Core file count 17 → 18, total 37 → 38. `learning-phase.md` added to "Which Skill Loads What" table.
- **Root `CONTEXT.md`** — `learning-phase.md` added to Load column for: Campaign audit, PMax work, Feed-only PMax / Shopping restructure, Budget / bids, Full campaign audit (agent).

---

## [1.12.0] — 2026-04-06

All Priority 3 audit gaps from audit-gap-analysis.md implemented: Video/YouTube, Cross-Campaign Cannibalization, Attribution Depth, and Account-Level Strengthening. Adds 27 new checklist items, 4 new campaign-review areas (18-21), 3 new GAQL verification sections (Video, Attribution, Change History), a Video/YouTube triage block in campaign-cleanup, and 4 inline sections in the campaign-reviewer agent.

### Added
- **Video / YouTube section in audit-checklist.md** — 12 checks across 3 sub-areas: Creative Quality (hook in 5s, brand early, companion banners, format testing), Targeting & Controls (frequency capping, placement exclusions, YouTube linking, campaign separation), Measurement (VTC window, VTC vs click analysis, creative refresh, Brand Lift eligibility).
- **Cross-Campaign Cannibalization section in audit-checklist.md** — 5 checks: PMax brand exclusions, PMax vs Shopping product overlap, Search vs DSA cross-negatives, brand campaign protection from non-brand spillover, cross-campaign negative keyword lists.
- **Attribution Depth section in audit-checklist.md** — 5 checks: attribution windows vs vertical sales cycle, VTC window across all conversion actions, GA4 vs Google Ads discrepancy documentation, assisted conversions reviewed before pausing upper-funnel, value-based bidding eligibility.
- **Account-Level Strengthening section in audit-checklist.md** — 5 checks: Conversion Linker on all pages, auto-generated extensions review, 70/20/10 budget allocation, change history for Smart Bidding stability, data exclusions for measurement gaps.
- **Areas 18-21 in campaign-review SKILL.md** — Video/YouTube, Cross-Campaign Cannibalization, Attribution Depth, Account-Level Strengthening added to review list. Area count updated 17 → 21. Weighting table expanded for all 7 profiles.
- **MCP Verification: Video / YouTube** — GAQL query for VIDEO channel type; thresholds: view rate < 15% Warning, < 10% Critical, CPV > 2× average Warning.
- **MCP Verification: Attribution Settings** — GAQL query for conversion_action attribution model, click-through and view-through windows; flags for non-DDA model, excessive windows.
- **MCP Verification: Account Change History** — GAQL query for change_event resource (last 14 days); flags for > 10 bid strategy changes in 14 days resetting Smart Bidding learning.
- **Video / YouTube Triage in campaign-cleanup SKILL.md** — Pre-Phase 1 section with GAQL query, thresholds (view rate < 10% Critical, CPV > 2× Warning, VTC > 70% Warning), and manual checks (placement report, frequency, creative age).
- **Sections 17-20 in campaign-reviewer agent** — Video/YouTube (4 checks), Cross-Campaign Cannibalization (4 checks), Attribution Depth (3 checks), Account-Level Strengthening (3 checks) added as inline audit sections.

### Changed
- **audit-gap-analysis.md** — Coverage matrix updated: Video/YouTube, Cross-Campaign Cannibalization, Attribution Depth marked ✅ Done (v1.12.0). Account-Level Strengthening heading updated. Priority 3 section marked Done.
- **plugin.json** — version bumped to 1.12.0.

---

## [1.11.0] — 2026-04-06

All Priority 2 audit gaps from audit-gap-analysis.md implemented: Display, Demand Gen, Competitive Analysis, Feed Health. Adds 50 new checklist items, 4 new campaign-review areas (14-17), 3 new GAQL verification sections, and a Display/Demand Gen triage block in campaign-cleanup. The campaign-reviewer agent was also backfilled with 6 inline sections missing since v1.10.0 (Shopping, Audience, Display, Demand Gen, Competitive Analysis, Feed Health).

### Added
- **Display Campaign section in audit-checklist.md** — 20 checks across 5 sub-areas: Campaign Settings, Targeting, Placement Controls, Responsive Display Ads, Performance. Key thresholds: CTR 0.5-1.0% (< 0.3% = investigate); frequency 3-5/week awareness; VTC window 7 days not 30.
- **Demand Gen section in audit-checklist.md** — 14 checks across 4 sub-areas: Campaign Settings, Creative, Audiences, Measurement. Key thresholds: budget 10-15x target CPA; learning period 2-3 weeks; creative refresh 4-6 weeks.
- **Competitive Analysis section in audit-checklist.md** — 6 cross-campaign checks: Auction Insights, IS lost to rank vs budget, absolute top IS > 80% on brand, competitor brand detection, MC Price Competitiveness.
- **Feed Health section in audit-checklist.md** — 10 checks with callout explaining the overlap with Shopping > Feed Health & MC (Shopping = quick 6-item pre-flight; Feed Health = deeper 10-item standalone audit).
- **Areas 14-17 in campaign-review SKILL.md** — Display, Demand Gen, Competitive Analysis, Feed Health review areas.
- **MCP Verification: Display Campaigns** — GAQL query + 4 flag thresholds (CTR, VTC inflation, IS lost to rank/budget).
- **MCP Verification: Demand Gen Campaigns** — GAQL query + 3 flag thresholds (VTC inflation, cost/conv, learning period).
- **MCP Verification: Competitive Analysis** — GAQL query for IS metrics + 3 flag thresholds + callout explaining Auction Insights UI requirement.
- **Display / Demand Gen Triage in campaign-cleanup SKILL.md** — GAQL query, 4 flag thresholds, 3 manual checks for placement waste, broad targeting, and creative fatigue.
- **6 inline checklist sections in campaign-reviewer agent** — Shopping Specific, Audience Strategy, Display Campaign, Demand Gen, Competitive Analysis, Feed Health (backfill from v1.10.0 and this release).

### Changed
- **campaign-review SKILL.md** — 13 → 17 review areas; stale "11 review areas" text fixed to "17"; profile weighting table updated for all 6 profiles; e-commerce vertical-specific items reference Areas 14-17.
- **audit-gap-analysis.md** — All Priority 2 sections marked ✅ Done (v1.11.0) in coverage matrix and section headings.
- **audit-checklist.md** — total checklist grows from ~121 to ~171 items.
- **plugin.json** — version bumped to 1.11.0.

---

## [1.10.0] — 2026-04-06

Shopping-specific and Audience Strategy audit sections added to the audit checklist and campaign-review skill. Complete gap analysis document saved for future expansion. Discovered via Vaxteronline client project where the Shopping campaign (biggest spender) passed a full audit with critical issues undetected.

### Added
- **audit-gap-analysis.md** — complete gap analysis of all audit checklist gaps by campaign type (Display, Demand Gen, Video, DSA, App, cross-cutting), with priority rankings, actionable checklist items, and source URLs. Serves as the implementation roadmap for future audit checklist expansion.
- **Shopping Specific section in audit-checklist.md** — 28 checks across 7 sub-areas: Feed Health & MC, Product Group Structure, Bidding, Competitive Metrics (click share, impression share, IS lost breakdown), Negative Keywords, Product-Level Performance, Tracking. Mirrors the existing PMax Specific section.
- **Audience Strategy section in audit-checklist.md** — 11 checks across 4 sub-areas: Remarketing Lists, Exclusions, RLSA & Layering, Customer Match.
- **Area 12 (Shopping Specific) in campaign-review SKILL.md** — with MCP GAQL queries for product group performance, click share, impression share, and IS lost breakdown. Includes flag thresholds (click share < 40% = Critical; IS < 50% = Warning; budget util < 70% = Warning).
- **Area 13 (Audience Strategy) in campaign-review SKILL.md** — audience strategy review area.
- **Shopping Triage in campaign-cleanup SKILL.md** — concrete Shopping checks (GAQL query + flag thresholds) to run before Phase 1, replacing vague "prioritize feed health, product groups" guidance.

### Changed
- **campaign-review SKILL.md** — 11 → 13 review areas; e-commerce priority table updated; e-commerce vertical checks updated to reference new Shopping section and Area 12/13; MCP section added with Shopping GAQL queries
- **campaign-cleanup SKILL.md** — e-commerce triage priority updated with Shopping triage checklist and flag thresholds
- **audit-checklist.md** — total checklist grows from ~82 to ~121 items
- **plugin.json** — version bumped to 1.10.0

---

## [1.9.1] — 2026-04-04

Feed-only PMax reference correction. Google Ads now requires 3+ headlines to save an asset group — the only true feed-only path is via Merchant Center. Reference doc corrected, new lessons added, sources expanded.

### Changed
- **feed-only-pmax.md** — MC path promoted to primary creation method, Google Ads path reframed as "feed-first" (not feed-only), added post-creation lockdown steps (disable auto-generated assets, Final URL expansion), CTV auto-generation warning (since Q2 2025), channel-level reporting benchmarks (60-80% Shopping), single-asset-group limitation, 9 new external sources
- **LESSONS.md** — 5 new Performance Max entries: MC-only creation path, post-creation lockdown, single-asset-group limitation, CTV auto-generation, 90% claim nuance
- **PRIMER.md** — session entry documenting the finding and impact on Vaxteronline project
- **plugin.json** — version bumped to 1.9.1

---

## [1.9.0] — 2026-04-04

New `/ad-copy` skill for multilingual ad copy generation. Character-counted, language-aware, research-backed. Ships with Swedish, Dutch, German, and English CTA libraries. Companion reference doc `ad-copy-framework.md` provides the reusable knowledge base.

### Added
- **New skill: ad-copy** — interactive multilingual ad copy generator for RSA headlines/descriptions, extensions (sitelinks, callouts, structured snippets), PMax text assets, and Shopping feed titles. Every text element includes `(XX/YY chars)` character counts. Supports Swedish (sv-SE), Dutch (nl-NL), German (de-DE), English (en-GB/US) with native CTA libraries and compound-word handling.
- **New reference doc: `ad-copy-framework.md`** — character limits quick reference (RSA, extensions, PMax, Shopping), headline generation framework (8 categories with distribution), language-specific rules (compound words, CTA libraries, trust signals, address forms), Shopping feed title formulas by market, extension copy framework (sitelink topics, callout themes, structured snippet headers)

### Changed
- **CONTEXT.md** — ad copy generation routing entry added
- **skills/CONTEXT.md** — skill count 12→13, dependency map entry added, inter-skill references updated (campaign-setup → ad-copy, ad-copy → 6 downstream skills)
- **CLAUDE.md** — quick navigation entry added, file counts updated (43 reference files, 13 skills)
- **campaign-setup skill** — Step 4 callout added recommending `/ad-copy` for multilingual or character-counted copy; `/ad-copy` added to "What to Do Next" routing
- **plugin.json** — version bumped to 1.9.0

---

## [1.8.0] — 2026-04-04

Report output structure. Skills and agents now write deliverables to files inside MWP client projects instead of dumping 100+ pages into conversation. Adds an output completeness convention that bans truncation patterns (`etc.`, `...`, back-references).

### Added
- **Output Completeness Convention** (`_config/conventions.md`) — hard rule: all report output fully specified, no truncation, no shortcuts. Prohibited patterns defined. 500-line split rule for massive output.
- **Report File-Writing Convention** (`_config/conventions.md`) — 6-step write sequence: detect MWP project, ensure dirs, write report, update CONTEXT.md index, update SUMMARY.md client summary, show conversation summary. Templates for CONTEXT.md and SUMMARY.md included.
- **Report Output section** added to 11 skills: campaign-review, campaign-cleanup, live-report, account-strategy, keyword-strategy, budget-optimizer, campaign-setup, pmax-guide, ads-scripts, conversion-tracking, reporting-pipeline
- **Report Output section** added to 3 agents: campaign-reviewer, strategy-advisor, tracking-auditor
- **Re-run behavior** defined: same skill same day overwrites report file, updates (not duplicates) CONTEXT.md row and SUMMARY.md paragraph

### Changed
- **CLAUDE.md** — new permanent rule for report output in MWP projects
- **CONTEXT.md** — report output routing entry added, inter-stage dependencies updated (skills/agents now write to `reports/` in MWP projects), report output callout added
- **Master plugin: `domain-classification.md`** — Output Pattern column added (ad-platform gets `reports/{date}/{stage}/`, all others get `stages/{stage}/output/`)
- **Master plugin: `scaffold-project` skill** — reports-pattern project handling (creates `reports/.gitkeep`, adds CLAUDE.md note, handoff message)
- **Master plugin: `structure-reviewer` agent** — `reports/` whitelisted as valid output directory

### Not Changed
- `connect-mcp` skill — stays conversational-only (setup wizard, not a report)
- Report directory structure, stage names, and reference files unchanged

---

## [1.7.0] — 2026-04-03

Phase 3 of the Strategic Upgrade v2.0. Completes the strategic layer with a new strategy-advisor agent (live account validation against strategy profiles) and 5 new reference docs filling remaining knowledge gaps.

### Added
- **New agent: strategy-advisor** — reads live account data via MCP, cross-references against strategy profile (from `/account-strategy`), produces scored gap analysis (8 categories, X/10 each, overall X/100) with prioritized recommendations. Two modes: full gap analysis (with profile) or structural health check (without profile).
- **New reference doc: `shopping-feed-strategy.md`** — feed architecture, multi-market feeds, automation pipelines, feed health scoring, product exclusions, vertical feed considerations
- **New reference doc: `ad-testing-framework.md`** — RSA testing methodology, headline/description strategy, pinning decisions, Ad Strength, performance evaluation, creative iteration process, AI Max for Search
- **New reference doc: `strategy/bid-adjustment-framework.md`** — device/geo/schedule/audience bid adjustments by archetype and maturity, stacking math, vertical patterns, review cadence
- **New reference doc: `strategy/remarketing-strategies.md`** — audience list design, funnel segmentation, membership durations, RLSA, dynamic remarketing, cross-channel remarketing, frequency management
- **New reference doc: `strategy/seasonal-planning.md`** — annual planning calendars (EU/NL focus), vertical-specific seasonality, ramp-up timelines, Smart Bidding seasonality adjustments, post-season analysis

### Changed
- **CONTEXT.md** — 5 new reference doc routing entries added to existing skill routes; strategy-advisor agent routing entry added; file counts updated; phase map updated
- **campaign-reviewer agent** — now references `ad-testing-framework.md`, `strategy/remarketing-strategies.md`, `strategy/bid-adjustment-framework.md` in Step 3
- **CLAUDE.md** — file counts updated (42 reference files, 3 agents), strategy-advisor added to quick navigation
- **README.md** — strategic layer section added, agent count updated
- **plugin.json** — version bumped to 1.7.0, description updated
- Agent count: 2 → 3; reference file count: 30 → 35 google-ads files (22 core + 2 new core + 8 strategy + 3 new strategy)

---

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
