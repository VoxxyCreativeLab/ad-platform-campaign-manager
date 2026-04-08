---
title: Primer - Session Handoff
date: 2026-04-08
tags:
  - mwp
---

# Primer - Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.12.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists.

---

## Last Completed

### Session 2026-04-08: Backlog Analysis + Comprehensive Gap Fill Plan

This session produced no code changes. It produced a fully researched, approved implementation plan spanning 7 releases (v1.13.0–v1.19.0).

**What triggered this session:**
- BACKLOG.md was added from the Vaxteronline client project (real-world usage discovering contradictions in learning phase guidance)
- Request: "research what else is missing, come up with a plan"
- Full gap analysis was run: codebase exploration (3 parallel agents), web research (2025–2026 Google Ads features), skill workflow analysis

**What was found:**
- 3 active contradictions in reference docs (learning phase safety)
- 4 documentation gaps (learning-phase.md missing, shopping_performance_view queries absent, no post-launch playbook, learning durations inconsistent)
- 2 future capabilities needed (post-launch monitor skill, product-level performance)
- 3 orphaned strategy reference files never wired into skills (seasonal-planning, bid-adjustment-framework, remarketing-strategies)
- 12 GAQL queries exist but all Search-only; zero for Shopping/PMax/Display/Demand Gen/Video
- No Consent Mode v2 reference doc (16 files mention it as one-liners only)
- No Display campaigns reference doc (20 audit checks exist but no backing doc)
- MCP capability boundary never documented (skills reference data outside the API without telling user)
- Documentation discrepancy in claude-settings-template.md (wrong tool names: `get_account_summary`, `list_budgets`, `run_gaql_query` — none of these exist)

**Plan file:** `C:\Users\VCL1\.claude\plans\staged-tumbling-pie.md` — approved by Jerry, full detail preserved there

### Prior sessions (2026-04-06): v1.10.0 → v1.12.0 audit expansion

- v1.12.0: Priority 3 audit expansion — Video/YouTube (12), Cross-Campaign Cannibalization (5), Attribution Depth (5), Account-Level Strengthening (5). Areas 18-21 added.
- v1.11.0: Priority 2 — Display (20), Demand Gen (14), Competitive Analysis (6), Feed Health (10). Areas 14-17.
- v1.10.0: Shopping (28) + Audience (11). Areas 12-13.

---

## Current State

### Plugin (ad-platform-campaign-manager) — v1.12.0

| Layer | Count | Notes |
|-------|-------|-------|
| Reference files | 37 | 17 core + 5 PMax + 4 audit + 11 strategy |
| Script docs | 17 | under `reference/scripts/` |
| Tracking-bridge docs | 6 | the differentiator |
| Reporting docs | 5 | + 3 MCP docs + 1 repos catalog |
| Skills | 13 | all with Report Output sections; 11 profile-aware |
| Agents | 3 | campaign-reviewer, tracking-auditor, strategy-advisor |
| Audit areas | 21 | Areas 1-21, all Priority 1-3 complete |

### MCP Server (google-ads-mcp-server)

- 25 tools: 3 session + 9 read + 11 write + 2 confirm
- Connected to MCC 7244069584 via Explorer Access (2,880 ops/day)
- Write passphrase: `voxxy-writes`
- Credentials at `C:\Users\VCL1\google-ads.yaml`
- Wrapper at `C:\mcp\google-ads.cmd`

---

## What Still Needs to Happen — v1.13.0–v1.19.0

> **On "continue":** Set up a git worktree first (no worktree was created this session — Jerry asked for advice). Use `.worktrees/` project-local. No tests to run (pure markdown). Then execute releases in order starting with v1.13.0 Step 1.

### Worktree Setup (do this first)

```bash
cd "c:\Users\VCL1\Voxxy Creative Lab Limited\08 - Projects\0001 - Claude Plugins\ad-platform-campaign-manager"
# Check if .worktrees is gitignored
git check-ignore -q .worktrees || echo "add to .gitignore"
# Then:
git worktree add .worktrees/backlog-gap-fill -b feature/backlog-gap-fill
```

---

### v1.13.0 — Learning Phase Authority (START HERE)

**Why:** 3 active contradictions in live docs. Correctness fix, no API dependency.

**New file to create:**
- `reference/platforms/google-ads/learning-phase.md`
  - Safe changes table: adding negatives ✓, updating ad copy ✓, adjusting extensions/assets ✓, adding observation audiences ✓, ad schedule tweaks ✓, pausing underperformers ✓
  - Disruptive changes table: bid strategy switch ✗, target CPA/ROAS change ✗, budget change >20% ✗, conversion action change ✗, campaign restructuring ✗, adding/removing ad groups ✗
  - Per-type learning durations: Search 7–14d, PMax 14–28d, Demand Gen 14–21d, Display 7–14d, Video 7–14d, Shopping 7–14d
  - What "resets learning" means technically
  - How to check learning status in Google Ads UI
  - Post-learning checklist

**Files to fix:**
1. `reference/platforms/google-ads/bidding-strategies.md` line 151 — change "No other changes — don't adjust keywords, ads, or targeting during learning" → precise list of safe vs disruptive + `[[learning-phase]]` wikilink
2. `reference/platforms/google-ads/pmax/feed-only-pmax.md` lines 89–94 — move brand exclusions + negatives (steps 12-13) to "Pre-Learning Setup" sub-heading before step 14. Add note: "These are safe during learning. See [[learning-phase]]."
3. `reference/platforms/google-ads/audit/common-mistakes.md` lines 96–98 — expand mistake #20 with specific list + `[[learning-phase]]` wikilink
4. `reference/platforms/google-ads/CONTEXT.md` — add learning-phase.md
5. Root `CONTEXT.md` — add learning-phase.md to Load column for campaign audit, budget/bids, PMax work

**Verification:** search "learning" across all reference files — every mention must be consistent or wikilink to `[[learning-phase]]`

---

### v1.14.0 — MCP Capability Map

**Why:** Every MCP-using skill needs to know what's in the API vs outside it. Foundational for all subsequent MCP-touching releases. Also fixes the claude-settings-template.md discrepancy.

**Primary audience: Claude** (loaded during skill execution). Secondary: Jerry + Git users.

**New file to create:**
- `reference/mcp/mcp-capabilities.md` with 6 sections:

  **Section 1: Tool Inventory (25 tools)**
  - Session (3): `unlock_writes`, `lock_writes`, `write_status`
  - Read (9): `list_accounts`, `list_campaigns`, `get_campaign`, `list_ad_groups`, `get_campaign_metrics`, `get_account_metrics`, `list_keywords`, `list_ads`, `run_gaql`
  - Write (11): `pause_campaign`, `enable_campaign`, `update_campaign_budget` (+/-50% cap), `pause_ad_group`, `enable_ad_group`, `update_ad_group_bid` (+30%/-50% cap), `pause_keyword`, `enable_keyword`, `update_keyword_bid` (+30%/-50% cap), `pause_ad`, `enable_ad`
  - Confirm (2): `confirm_change`, `list_pending_plans`

  **Section 2: GAQL Queryable Resources**
  campaign, ad_group, ad_group_ad, keyword_view, search_term_view, shopping_performance_view, landing_page_view, geographic_view, gender_view, age_range_view, change_status/change_event, performance_max_placement_view (API v23+), conversion_action, ad_group_criterion, campaign_budget, ad_group_ad_asset_view, group_placement_view, customer

  **Section 3: What MCP Cannot Do**
  Create campaigns/ad groups/keywords/ads, add/remove negative keywords, manage extensions/assets, upload offline conversions, manage audience lists/Customer Match, edit ad copy, create/manage experiments — all require Google Ads UI or direct API

  **Section 4: Data Outside the Google Ads API Boundary**
  | Data | System | How to Access | Relevant Skills |
  |------|--------|---------------|-----------------|
  | MC feed data (disapprovals, GTIN coverage) | Merchant Center | MC UI / Merchant API | pmax-guide, campaign-review Area 17 |
  | GA4 analytics data | Google Analytics 4 | GA4 UI / GA4 API / BQ export | reporting-pipeline |
  | GTM/sGTM configuration | Google Tag Manager | GTM UI / GTM API | conversion-tracking |
  | Consent mode state | Google Tag / CMP | Tag Assistant / CMP dashboard / DevTools | conversion-tracking |
  | BigQuery data | BigQuery | BQ Console / bq CLI | reporting-pipeline |
  | Search Console data | GSC | GSC UI / API | (not covered) |
  | CRM / offline lead data | Client CRM | CRM export / API | conversion-tracking (offline) |
  | Firestore profit margins | Firestore | Console / client libs | tracking-bridge |
  | Google Ads Recommendations | Recommendations API | Google Ads UI | (not covered) |

  **Section 5: Data Flow Map**
  ```
  [Client GTM] ──▶ [sGTM] ──server-to-server──▶ [Google Ads] ◀── MCP reads here
       │               │                               │
       ▼               ▼                               ▼
    [GA4] ◀──▶ [BigQuery] ◀── staging ──▶ [Offline Upload → Google Ads]
                                                   (no MCP tool)
  [Merchant Center] ──feed──▶ [Google Ads Shopping/PMax]
       (no MCP access)              (MCP reads performance only)
  [CRM] ──▶ [BigQuery] ──▶ [Offline Conversion Upload] ──▶ [Google Ads]
                                   (no MCP tool)
  ```

  **Section 6: Per-Skill MCP Usage Summary**
  | Skill | MCP Tools Used | Manual Verification Required |
  |-------|---------------|------------------------------|
  | live-report | `run_gaql`, `get_campaign_metrics`, `get_account_metrics`, `list_campaigns` | None (fully MCP-powered) |
  | campaign-review | `run_gaql` (all 21 areas) | MC feed data (Area 17), GTM consent config |
  | campaign-cleanup | `run_gaql`, `list_campaigns`, `list_ad_groups` | Audience list health |
  | post-launch-monitor | `run_gaql`, `get_campaign_metrics` | Tracking verification (GTM), consent state |
  | budget-optimizer | `get_campaign_metrics`, `run_gaql` | None |
  | account-strategy | `get_account_metrics`, `list_campaigns`, `run_gaql` | Business context (manual input) |
  | keyword-strategy | `run_gaql` | Competitor research (manual) |
  | pmax-guide | `run_gaql` | MC feed health, asset quality (UI) |
  | ad-copy | None (generation skill) | n/a |
  | ads-scripts | None (generation skill) | n/a |
  | campaign-setup | None (planning skill) | n/a |
  | conversion-tracking | `run_gaql` (conversion actions) | GTM config, consent mode, tag firing |
  | reporting-pipeline | None (design skill) | n/a |
  | connect-mcp | Session tools (verification) | n/a |

**Files to modify:**
1. `reference/mcp/claude-settings-template.md` — fix discrepancies: `get_account_summary` → `get_account_metrics`, remove `list_budgets` (doesn't exist), `run_gaql_query` → `run_gaql`, add missing `get_campaign`
2. `reference/mcp/CONTEXT.md` — add mcp-capabilities.md
3. Root `CONTEXT.md` — add mcp-capabilities.md to Load for: live reports, campaign audit, PMax work, conversion tracking, budget/bids
4. `CLAUDE.md` — add to Permanent Rules: "Before using MCP tools in any skill, load [[mcp-capabilities]] to confirm what data is available via API vs what requires manual verification."

**Verification:** cross-check all 25 tool names against MCP server source at `../google-ads-mcp-server/`

---

### v1.15.0 — Shopping Queries + Post-Launch Playbook

**Backlog items:** #5 (shopping_performance_view queries), #6 (post-launch playbook), #9 (partial)

**New file to create:**
- `reference/platforms/google-ads/strategy/post-launch-playbook.md`
  - Day 0: Verify campaigns enabled, tracking firing, baseline screenshots
  - Day 1: First data pull, add obvious negatives (competitors), check budget pacing
  - Day 2 (48h): Remarketing/Display serving check, consent mode verification
  - Day 7: First clean-week report, search term mining, learning status check
  - Day 14: PMax learning exit assessment, second search term pass
  - Day 21: tROAS gate check (conversion volume threshold)
  - Day 30: Full month review, bid strategy upgrade decision
  - Weeks 5–8: Optimization cadence, creative refresh
  - Per-campaign-type adjustments (PMax vs Search vs Shopping vs Demand Gen)
  - Per-check MCP boundary notes (what `run_gaql` can pull vs manual)
  - Cross-references: `[[learning-phase]]`, `[[bidding-strategies]]`, `[[account-maturity-roadmap]]`, `[[mcp-capabilities]]`

**Files to modify:**
1. `reference/reporting/gaql-query-templates.md` — add "## Shopping / Product Performance" with 4 queries using `shopping_performance_view`: top products by revenue, zombie products (spend > 0 / conversions = 0), product category performance, high-impression low-CTR products
2. `skills/live-report/references/report-templates.md` — add Shopping Product Performance template with GAQL + MCP tool sequence + MCP boundary note ("feed health data not in API — check MC directly")
3. `skills/live-report/SKILL.md` — add "Shopping Product Performance" to Available Reports
4. `reference/platforms/google-ads/CONTEXT.md` — add post-launch-playbook.md
5. Root `CONTEXT.md` — add routing row for "Post-launch monitoring"

---

### v1.16.0 — GAQL Expansion + Orphaned File Wiring

**Items:** GAQL gaps, 3 orphaned files wired in, skill routing fixes

**Files to modify:**
1. `reference/reporting/gaql-query-templates.md` — add 8 sections: PMax Campaign Performance, PMax Asset Group Performance (`asset_group_asset`, `asset_group_listing_group_filter`), Display Placement Report (`group_placement_view`), Demand Gen Performance (`DEMAND_GEN` channel filter), Video Performance, Auction Insights (note UI-only limitation), Conversion Action Breakdown (`conversion_action`), Asset Performance (`ad_group_ad_asset_view`)
2. `skills/budget-optimizer/SKILL.md` — add `[[seasonal-planning]]` + `[[bid-adjustment-framework]]` references + callouts for each
3. `skills/keyword-strategy/SKILL.md` — add `[[remarketing-strategies]]` reference + "### Existing Account: Search Term Analysis Workflow" section
4. `skills/campaign-cleanup/SKILL.md` — add `campaign-review` to "Recommend next skills" routing
5. `skills/CONTEXT.md` — update dependency maps for budget-optimizer, keyword-strategy, campaign-cleanup
6. `reference/platforms/google-ads/CONTEXT.md` — update Used By table for seasonal-planning, bid-adjustment-framework, remarketing-strategies

**Verification:** all 3 orphaned files now appear in at least one skill's Reference Material. GAQL count ~24.

---

### v1.17.0 — Consent Mode v2

**Why:** Critical for EU clients (NL/SE). 16 files mention consent mode as one-liners, no authority doc. MCP boundary is key — consent state NOT visible in Google Ads API.

**New file to create:**
- `reference/platforms/google-ads/consent-mode-v2.md`
  - v1 vs v2 comparison
  - Four signals: `ad_storage`, `ad_user_data`, `ad_personalization`, `analytics_storage`
  - Advanced vs Basic mode (Advanced = cookieless pings for behavioral modeling; Basic = no pings)
  - Behavioral modeling (how Google fills gaps, typically 5–30% modeled conversions)
  - CMP requirements (TCF v2.2)
  - EEA enforcement timeline (March 2024 mandatory for measurement)
  - Impact on Smart Bidding (fewer observed conversions = noisier signal)
  - Implementation via GTM / sGTM / direct API
  - Verification via Google Tag Assistant, Diagnostics tab
  - Common mistakes: not using Advanced mode, not testing denial flow, missing `ad_user_data`
  - **MCP boundary note:** Consent state NOT visible in Google Ads API. Verification requires Tag Assistant / CMP dashboard / DevTools. Only API-visible signal: modeled vs observed conversion ratio. Reference `[[mcp-capabilities]]` Section 4.

**Files to modify:**
1. `skills/conversion-tracking/SKILL.md` — add "## Consent Mode" section with diagnostic questions, `[[consent-mode-v2]]` reference, testing checklist, MCP boundary note
2. `reference/platforms/google-ads/CONTEXT.md` — add consent-mode-v2.md
3. Root `CONTEXT.md` — add to Load column for conversion tracking row

---

### v1.18.0 — Post-Launch Monitor Skill + Live Report Expansion

**Why:** Biggest workflow gap. Plugin covers strategy→plan→build→launch but drops off at launch. `account-maturity-roadmap.md` defines weekly/monthly actions but no skill operationalizes them.

**New skill to create:**
- `skills/post-launch-monitor/SKILL.md`
  - Step 1: Establish context — campaign name, launch date, campaign type, bid strategy
  - Step 2: Calculate days since launch → determine phase (Day 1 / Day 7 / Day 14 / Day 30 / Ongoing)
  - Step 3: Phase-appropriate MCP checks with boundary awareness:
    - Day 1: budget pacing (`get_campaign_metrics`), tracking (ask user — not in API), negatives (`run_gaql` search terms)
    - Day 7: search term mining (`run_gaql`), learning status (`get_campaign` → `serving_status`), spend distribution
    - Day 14: learning exit assessment, performance vs baseline (`get_campaign_metrics`)
    - Day 30: full month review, optimization decisions
  - Step 4: Compare against baseline (from campaign-setup output if available)
  - Step 5: Only safe actions during learning (reference `[[learning-phase]]`)
  - Step 6: MCP-executable actions → propose via write tools. Manual-only actions → output actionable list for UI
  - Step 7: Route to next skill
  - MCP boundary section: explicit per-phase what MCP can pull vs manual
  - References: `[[learning-phase]]`, `[[post-launch-playbook]]`, `[[bidding-strategies]]`, `[[account-maturity-roadmap]]`, `[[mcp-capabilities]]`
  - Report Output: stage `05-optimize`

**Files to modify:**
1. `skills/live-report/SKILL.md` — add 3 new report types: Audience Performance (`ad_group_audience_view`), PMax Asset Group Performance, Conversion Action Breakdown (`conversion_action`)
2. `skills/live-report/references/report-templates.md` — add GAQL queries + templates for 3 new types
3. `skills/campaign-setup/SKILL.md` — add `post-launch-monitor` to "What to Do Next"
4. `skills/CONTEXT.md` — add post-launch-monitor (skill count 13 → 14)
5. Root `CONTEXT.md` + `CLAUDE.md` — add routing row + quick navigation entry

---

### v1.19.0 — Display, Brand Restrictions, NCA

**New file to create:**
- `reference/platforms/google-ads/display-campaigns.md`
  - Subtypes (Standard Display, Smart Display)
  - Responsive Display Ad specs
  - Targeting types: audiences, placements, topics, demographics
  - Exclusion management: placement exclusions, content exclusions
  - Frequency capping, performance benchmarks, Display-specific bid strategies
  - Common mistakes
  - Cross-references to the 20 audit checks in audit-checklist.md

**Files to modify:**
1. `reference/platforms/google-ads/match-types.md` — add "## Brand Restrictions for Search" (distinct from PMax brand exclusions — different feature, setup in Google Ads Settings, interaction with broad match + AI Max)
2. `reference/platforms/google-ads/campaign-types.md` — add NCA (New Customer Acquisition) goal to PMax and Search sections (currently only documented for Demand Gen)
3. `reference/platforms/google-ads/CONTEXT.md` — add display-campaigns.md

---

## Deferred / Out of Scope

| Item | Status |
|------|--------|
| OAuth client secret rotation | Still needed — GCP Console, before production |
| Phase 4 Multi-platform | Deferred — no user demand |
| DSA / App Campaign audit (Priority 4) | Low priority, niche |
| Privacy Sandbox / Topics API | Google handles server-side; limited direct action |
| Generative AI creative tools (Imagen 3) | Out of scope (creative, not campaign management) |
| ACA standalone doc | Partially covered in AI Max + feed-only PMax sections |
| Remarketing/audience strategy skill | Deferred — reference wired in v1.16, full skill later |
| A/B testing / experimentation skill | Deferred — `ad-testing-framework.md` exists as reference |
| MCP server tool expansion (create/add negatives) | Requires MCP server dev, not plugin changes |

---

## Design Documents

- **Full plan file:** `C:\Users\VCL1\.claude\plans\staged-tumbling-pie.md`
- **Report output structure spec:** `docs/superpowers/specs/2026-04-04-report-output-structure-design.md`
- **Phase 3 design spec:** `docs/superpowers/specs/2026-04-03-phase-3-strategy-agent-design.md`

## Open Blockers

- **Credential rotation:** OAuth client secret should be rotated (exposed 2026-04-01)
- **Worktree:** Not created yet. Set up `.worktrees/backlog-gap-fill` before starting v1.13.0
