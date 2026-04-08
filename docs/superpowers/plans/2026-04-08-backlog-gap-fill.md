---
title: "Plan — Backlog Fix + Gap Analysis (v1.13–v1.19)"
date: 2026-04-08
tags:
  - plan
  - ad-platform-campaign-manager
---

# Plan — Backlog Fix + Comprehensive Gap Fill

## Context

During real-world usage on the Vaxteronline (vaxteronline.se) campaign, the plugin gave contradictory guidance about what changes are safe during a Smart Bidding learning phase. This surfaced 9 backlog items (3 contradictions, 4 gaps, 2 future capabilities). A full gap analysis revealed 15+ additional issues: no MCP capability map, orphaned reference files, missing GAQL queries, an absent Consent Mode v2 reference, missing Display campaigns doc, and the biggest workflow gap — no post-launch monitoring skill.

Additionally, the MCP server research revealed a documentation discrepancy (`claude-settings-template.md` lists wrong tool names) and confirmed that skills reference data outside the MCP boundary without telling the user.

This plan groups everything into 7 shippable releases (v1.13.0–v1.19.0), prioritizing correctness fixes first, then the MCP capability foundation, then high-value gaps, then enhancements.

---

## Release Overview

| Release | Name | Size | New Files | Edits | Key Deliverable |
|---------|------|------|-----------|-------|-----------------|
| v1.13.0 | Learning Phase Authority | M | 1 | 5 | `learning-phase.md` + 3 contradiction fixes |
| v1.14.0 | MCP Capability Map | M | 1 | 4 | `mcp-capabilities.md` + settings template fix + skill MCP boundary notes |
| v1.15.0 | Shopping Queries + Post-Launch Playbook | L | 1 | 5 | `post-launch-playbook.md` + Shopping GAQL |
| v1.16.0 | GAQL Expansion + Orphaned File Wiring | M | 0 | 6 | 8 new GAQL sections + 3 orphaned files wired |
| v1.17.0 | Consent Mode v2 | M | 1 | 3 | `consent-mode-v2.md` + conversion-tracking enhancement |
| v1.18.0 | Post-Launch Monitor Skill | L | 1 | 5 | New `post-launch-monitor` skill + live-report expansion |
| v1.19.0 | Display, Brand Restrictions, NCA | M | 1 | 3 | `display-campaigns.md` + Search brand restrictions + NCA goal |

**Totals:** 6 new files, ~31 file edits across 7 releases.

## Dependency Graph

```
v1.13.0 (Learning Phase) ─── must be first (correctness fix)
    │
    ▼
v1.14.0 (MCP Capability Map) ─── foundational for all MCP-using releases
    │
    ▼
v1.15.0 (Shopping + Playbook) ─── references learning-phase.md, uses MCP boundary awareness
    │
    ├──▶ v1.16.0 (GAQL + Wiring) ─── independent, logically after
    │
    └──▶ v1.18.0 (Monitor Skill) ─── references learning-phase.md + playbook + capability map
         │
         ▼
         v1.19.0 (Display, Brand, NCA) ─── lowest priority, last

v1.17.0 (Consent Mode) ─── independent, references capability map for "not in API" boundary
```

---

## v1.13.0 — Learning Phase Authority

**Why first:** Users are actively hitting contradictions in live client work. This is a correctness fix.

**Backlog items addressed:** #1, #2, #3, #4, #7

### New file

- **`reference/platforms/google-ads/learning-phase.md`** — Single source of truth:
  - Safe changes table: adding negatives, updating ad copy, adjusting extensions/assets, adding observation audiences, ad schedule tweaks, pausing underperformers
  - Disruptive changes table: bid strategy switch, target CPA/ROAS change, budget change >20%, conversion action change, campaign restructuring, adding/removing ad groups
  - Per-type learning durations: Search 7–14 days, PMax 14–28 days, Demand Gen 14–21 days, Display 7–14 days, Video 7–14 days, Shopping 7–14 days
  - What "resets learning" means technically
  - How to check learning status in Google Ads UI
  - Post-learning checklist

### Files to modify

1. **`reference/platforms/google-ads/bidding-strategies.md`** (line 151) — Replace "No other changes — don't adjust keywords, ads, or targeting during learning" with precise guidance + `[[learning-phase]]` wikilink. Also add wikilink at lines 120–125.
2. **`reference/platforms/google-ads/pmax/feed-only-pmax.md`** (lines 89–94) — Restructure steps 12–14: move brand exclusions + negatives to a "Pre-Learning Setup" sub-heading before step 14. Add note: "Negatives and brand exclusions are safe during learning — see [[learning-phase]]."
3. **`reference/platforms/google-ads/audit/common-mistakes.md`** (lines 96–98) — Expand mistake #20 with specific disruptive changes list + `[[learning-phase]]` wikilink.
4. **`reference/platforms/google-ads/CONTEXT.md`** — Add `learning-phase.md` to file list and Used By table.
5. **Root `CONTEXT.md`** — Add `learning-phase.md` to Load column for: campaign audit, budget/bids, PMax work rows.

### Verification

- Read all 5 modified files + new file, confirm no remaining contradictions about learning
- Search for "learning" across all reference files — every mention should either be consistent or link to `[[learning-phase]]`

---

## v1.14.0 — MCP Capability Map

**Why second:** Every MCP-using skill and agent needs to know what data it can pull vs what lives outside the API boundary. This is foundational — all subsequent releases that touch MCP workflows reference this doc. Also fixes a live documentation discrepancy.

**Primary audience:** Claude (loaded during skill execution to set correct expectations). Secondary: Jerry and Git users (public documentation of what the server can do).

### New file

- **`reference/mcp/mcp-capabilities.md`** — Authoritative capability matrix:

  **Section 1: Tool Inventory (25 tools)**
  Matrix with columns: Tool Name | Category | Type (Read/Write/Session/Confirm) | Parameters | Safety Caps
  - 3 session tools: `unlock_writes`, `lock_writes`, `write_status`
  - 9 read tools: `list_accounts`, `list_campaigns`, `get_campaign`, `list_ad_groups`, `get_campaign_metrics`, `get_account_metrics`, `list_keywords`, `list_ads`, `run_gaql`
  - 11 write tools: `pause_campaign`, `enable_campaign`, `update_campaign_budget` (+/-50%), `pause_ad_group`, `enable_ad_group`, `update_ad_group_bid` (+30%/-50%), `pause_keyword`, `enable_keyword`, `update_keyword_bid` (+30%/-50%), `pause_ad`, `enable_ad`
  - 2 confirm tools: `confirm_change`, `list_pending_plans`

  **Section 2: GAQL Queryable Resources**
  Matrix with columns: Resource | What It Returns | Example Use Case | Confirmed Working
  - `campaign` — campaign-level metrics, settings, status
  - `ad_group` — ad group metrics, bids
  - `ad_group_ad` — ad performance, RSA asset ratings, ad strength
  - `keyword_view` — keyword performance, quality score components
  - `search_term_view` — actual search queries that triggered ads
  - `shopping_performance_view` — product-level Shopping/PMax performance
  - `landing_page_view` — landing page metrics
  - `geographic_view` — performance by location
  - `gender_view`, `age_range_view` — demographic performance
  - `change_status` / `change_event` — account change history
  - `performance_max_placement_view` — PMax channel breakdown (API v23+)
  - `conversion_action` — conversion action settings, attribution model
  - `ad_group_criterion` — targeting criteria
  - `campaign_budget` — budget settings
  - `ad_group_ad_asset_view` — asset-level performance
  - `group_placement_view` — Display/Video placement performance
  - `customer` — account-level data

  **Section 3: What MCP Cannot Do (no tool exists)**
  Matrix with columns: Operation | Why Not Available | Where to Do It Instead
  - Create campaigns, ad groups, keywords, ads — use Google Ads UI or Editor
  - Add/remove negative keywords — use Google Ads UI or Editor
  - Manage extensions/assets (sitelinks, callouts) — use Google Ads UI
  - Upload offline conversions — use Google Ads API directly or scheduled script
  - Manage audience lists / Customer Match — use Google Ads UI
  - Edit ad copy (RSA headlines/descriptions) — use Google Ads UI or Editor
  - Create/manage experiments — use Google Ads UI

  **Section 4: Data Outside the Google Ads API Boundary**
  Matrix with columns: Data | Source System | How to Access | Relevant Plugin Skills
  - Merchant Center feed data (product disapprovals, feed health, GTIN coverage) — Google Merchant Center — MC UI, Content API / Merchant API — pmax-guide, campaign-review (Area 17)
  - GA4 analytics data (sessions, bounce rate, user behavior) — Google Analytics 4 — GA4 UI, GA4 API, BigQuery export — reporting-pipeline
  - GTM/sGTM configuration (tag setup, consent mode config, triggers) — Google Tag Manager — GTM UI, GTM API — conversion-tracking
  - Consent mode state (which consent signals are set, Advanced vs Basic) — Google Tag / CMP — Google Tag Assistant, CMP dashboard, browser DevTools — conversion-tracking
  - BigQuery data (raw events, GA4 export, offline staging tables) — BigQuery — BQ Console, bq CLI, client libraries — reporting-pipeline
  - Search Console data (organic queries, crawl stats) — Google Search Console — GSC UI, GSC API — (not covered by plugin)
  - CRM / offline lead data — Client CRM — CRM export, API integration — conversion-tracking (offline imports)
  - Firestore enrichment data (profit margins for value-based bidding) — Google Firestore — Firestore Console, client libraries — tracking-bridge (value-based bidding)
  - Google Ads Recommendations — Google Ads API (Recommendations service) — Google Ads UI, API — (not covered by MCP)

  **Section 5: Data Flow Map**
  Visual showing which Google products feed data into Google Ads and where the MCP boundary sits:
  ```
  [Client GTM] ──tag fires──▶ [sGTM] ──server-to-server──▶ [Google Ads] ◀── MCP reads here
       │                          │                               │
       ▼                          ▼                               ▼
    [GA4] ◀─── export ───▶ [BigQuery] ◀── staging ──▶ [Offline Upload → Google Ads]
                                                              (no MCP tool)
  [Merchant Center] ──feed──▶ [Google Ads Shopping/PMax]
       (no MCP access)              (MCP reads performance)

  [CRM] ──▶ [BigQuery] ──▶ [Offline Conversion Upload] ──▶ [Google Ads]
                                  (no MCP tool)
  ```

  **Section 6: Per-Skill MCP Usage Summary**
  Table with columns: Skill | MCP Tools Used | Data Requiring Manual Verification
  - `live-report` — `run_gaql`, `get_campaign_metrics`, `get_account_metrics`, `list_campaigns` — none (fully MCP-powered)
  - `campaign-review` — `run_gaql` (all 21 areas) — MC feed data (Area 17), GTM consent config
  - `campaign-cleanup` — `run_gaql`, `list_campaigns`, `list_ad_groups` — audience list health
  - `post-launch-monitor` (v1.18) — `run_gaql`, `get_campaign_metrics` — tracking verification (GTM), consent mode state
  - `budget-optimizer` — `get_campaign_metrics`, `run_gaql` (impression share) — none
  - `account-strategy` — `get_account_metrics`, `list_campaigns`, `run_gaql` — business context (manual input)
  - `keyword-strategy` — `run_gaql` (search terms, keywords) — competitor research (manual)
  - `pmax-guide` — `run_gaql` (PMax metrics, channel breakdown) — MC feed health, asset quality (UI)
  - `ad-copy` — none (generation skill, no live data) — n/a
  - `ads-scripts` — none (generation skill) — n/a
  - `campaign-setup` — none (planning skill) — n/a
  - `conversion-tracking` — `run_gaql` (conversion actions) — GTM config, consent mode, tag firing verification
  - `reporting-pipeline` — none (design skill) — n/a
  - `connect-mcp` — session tools (verification) — n/a

### Files to modify

1. **`reference/mcp/claude-settings-template.md`** — Fix tool name discrepancies:
   - `get_account_summary` → `get_account_metrics`
   - `list_budgets` → remove (doesn't exist)
   - `run_gaql_query` → `run_gaql`
   - Add missing tools: `get_campaign`
   - Update read tools count from 9 to 9 (correct count, wrong names)

2. **`reference/mcp/CONTEXT.md`** — Add `mcp-capabilities.md` to file list with description.

3. **Root `CONTEXT.md`** — Add `mcp-capabilities.md` to Load column for: live reports, campaign audit, PMax work, conversion tracking, budget/bids. Add a new row: "MCP boundaries" → `reference/mcp/mcp-capabilities.md`.

4. **`CLAUDE.md`** — Add to Permanent Rules: "Before using MCP tools in any skill, load `[[mcp-capabilities]]` to confirm what data is available via API vs what requires manual verification in external systems."

### Verification

- Cross-check all 25 tool names against actual MCP server source at `../google-ads-mcp-server/`
- Confirm every skill's MCP usage in Section 6 matches its actual SKILL.md content
- Verify `claude-settings-template.md` tool names now match the real server

---

## v1.15.0 — Shopping Queries + Post-Launch Playbook

**Why third:** Shopping queries unblock e-commerce audit completeness. Post-launch playbook fills the biggest knowledge gap (guidance scattered across 6+ files).

**Backlog items addressed:** #5, #6, #9 (partial — Shopping queries in live-report)

### New file

- **`reference/platforms/google-ads/strategy/post-launch-playbook.md`** — Unified day-by-day guide:
  - Day 0: Verify campaigns enabled, tracking firing, take baseline screenshots
  - Day 1: First data pull, add obvious negatives, check budget pacing
  - Day 2 (48h): Remarketing/Display serving check, consent mode verification
  - Day 7: First clean-week report, search term mining, learning status check
  - Day 14: PMax learning exit assessment, second search term pass
  - Day 21: tROAS gate check (conversion volume threshold)
  - Day 30: Full month review, bid strategy upgrade decision
  - Weeks 5–8: Optimization cadence, creative refresh, expansion planning
  - Per-campaign-type adjustments (PMax vs Search vs Shopping vs Demand Gen)
  - Per-check MCP boundary notes: what can be pulled via `run_gaql` vs what requires manual verification (reference `[[mcp-capabilities]]`)
  - Cross-references: `[[learning-phase]]`, `[[bidding-strategies]]`, `[[account-maturity-roadmap]]`, `[[mcp-capabilities]]`

### Files to modify

1. **`reference/reporting/gaql-query-templates.md`** — Add "## Shopping / Product Performance" section with 4 queries:
   - Top products by revenue (`shopping_performance_view`, ORDER BY `conversions_value DESC`)
   - Zombie products (spend > 0, conversions = 0)
   - Product category performance
   - High-impression low-CTR products (feed optimization candidates)
2. **`skills/live-report/references/report-templates.md`** — Add "Shopping Product Performance" report template with GAQL, MCP tool sequence (`run_gaql`), output format. Include MCP boundary note: "Product-level data from `shopping_performance_view`. Feed health data (disapprovals, GTIN coverage) not available via MCP — check Merchant Center directly."
3. **`skills/live-report/SKILL.md`** — Add "Shopping Product Performance" to Available Reports table.
4. **`reference/platforms/google-ads/CONTEXT.md`** — Add `post-launch-playbook.md`.
5. **Root `CONTEXT.md`** — Add routing row for "Post-launch monitoring" + add playbook to relevant Load columns.

### Verification

- Run `shopping_performance_view` GAQL query via MCP on a live e-commerce account (if available)
- Confirm post-launch-playbook.md covers every post-launch action currently scattered across bidding-strategies.md, account-maturity-roadmap.md, feed-only-pmax.md, demand-gen.md, campaign-cleanup SKILL.md, and budget-optimizer SKILL.md

---

## v1.16.0 — GAQL Expansion + Orphaned File Wiring

**Why fourth:** High value-to-effort ratio. Expands reporting foundation from 12 → 24 queries and connects 3 existing reference files that were written but never wired into skills.

**Items addressed:** GAQL gaps (I), orphaned files (F, G, H), budget-optimizer refs (M), keyword-strategy search terms (N), campaign-cleanup routing (K)

### Files to modify

1. **`reference/reporting/gaql-query-templates.md`** — Add 8 new query sections:
   - PMax Campaign Performance (channel breakdown)
   - PMax Asset Group Performance (`asset_group_asset`, `asset_group_listing_group_filter`)
   - Display Placement Report (`group_placement_view`)
   - Demand Gen Performance (filter by `DEMAND_GEN` channel)
   - Video Campaign Performance (video metrics)
   - Auction Insights (note: limited GAQL support, partial UI-only — document boundary per `[[mcp-capabilities]]`)
   - Conversion Action Breakdown (`conversion_action` resource)
   - Asset Performance (`ad_group_ad_asset_view`)

2. **`skills/budget-optimizer/SKILL.md`** — Add references to:
   - `[[seasonal-planning]]` — add "Seasonality Considerations" callout in Budget Forecasting section
   - `[[bid-adjustment-framework]]` — add "Bid Adjustments" section for device/geo/schedule levers

3. **`skills/keyword-strategy/SKILL.md`** — Add:
   - `[[remarketing-strategies]]` reference (for RLSA keyword strategy)
   - New "### Existing Account: Search Term Analysis Workflow" section — for accounts with data, mine search terms first via `run_gaql` before brainstorming from scratch

4. **`skills/campaign-cleanup/SKILL.md`** — Add `campaign-review` to "Recommend next skills" routing (close the cleanup → review loop)

5. **`skills/CONTEXT.md`** — Update dependency maps for budget-optimizer, keyword-strategy, campaign-cleanup

6. **`reference/platforms/google-ads/CONTEXT.md`** — Update Used By table for seasonal-planning, bid-adjustment-framework, remarketing-strategies

### Verification

- Confirm all 3 formerly orphaned files now appear in at least one skill's Reference Material section
- Confirm GAQL query count in gaql-query-templates.md is now ~24
- Verify every new GAQL query uses a resource listed in `mcp-capabilities.md` Section 2

---

## v1.17.0 — Consent Mode v2

**Why:** Critical for EU clients (Jerry's market includes NL/SE). Currently 16 files mention consent mode as one-liners with no authoritative reference. Fully independent — can ship in any order after v1.14.0.

**Items addressed:** Consent Mode v2 reference (A), conversion-tracking consent section (L)

### New file

- **`reference/platforms/google-ads/consent-mode-v2.md`** — Comprehensive reference:
  - v1 vs v2 comparison
  - Four consent signals: `ad_storage`, `ad_user_data`, `ad_personalization`, `analytics_storage`
  - Advanced vs Basic mode (Advanced = cookieless pings for modeling; Basic = no pings when denied)
  - Behavioral modeling: how Google fills gaps with modeled conversions
  - CMP requirements (Consent Management Platform, TCF v2.2)
  - EEA enforcement timeline (March 2024 mandatory for measurement)
  - Impact on Smart Bidding (fewer observed conversions = noisier signal; modeled conversions compensate partially)
  - Implementation via GTM / sGTM / direct API
  - Verification: Google Tag Assistant, Diagnostics tab, consent mode status
  - Common mistakes: not implementing Advanced mode, not testing denial flow, forgetting `ad_user_data`
  - **MCP boundary note:** Consent mode state is NOT visible in the Google Ads API. Verification requires Google Tag Assistant, CMP dashboard, or browser DevTools. The only API-visible signal is the proportion of modeled vs observed conversions in conversion reporting. Reference `[[mcp-capabilities]]` Section 4.

### Files to modify

1. **`skills/conversion-tracking/SKILL.md`** — Add "## Consent Mode" section with diagnostic questions, implementation guidance referencing `[[consent-mode-v2]]`, testing checklist, and explicit MCP boundary note: "Consent mode configuration lives in GTM/sGTM, not Google Ads. See [[mcp-capabilities]] for what data is available via API."
2. **`reference/platforms/google-ads/CONTEXT.md`** — Add `consent-mode-v2.md`.
3. **Root `CONTEXT.md`** — Add `consent-mode-v2.md` to Load column for conversion tracking row.

### Verification

- Confirm every existing consent mode mention in the plugin (16+ files) is consistent with the new reference
- Confirm conversion-tracking skill now has a clear consent mode workflow with MCP boundary awareness

---

## v1.18.0 — Post-Launch Monitor Skill + Live Report Expansion

**Why:** Addresses the single biggest workflow gap. The plugin covers strategy → plan → build → launch but drops off after launch. The `account-maturity-roadmap.md` defines weekly/monthly actions but no skill operationalizes them.

**Items addressed:** Backlog #8 (automated post-launch checks), live-report gaps (J), post-launch workflow gap (O)

### New skill

- **`skills/post-launch-monitor/SKILL.md`** — Post-launch campaign monitoring:
  - Step 1: Establish context — campaign name, launch date, campaign type, bid strategy
  - Step 2: Calculate days since launch → determine check phase (Day 1 / Day 7 / Day 14 / Day 30 / Ongoing)
  - Step 3: Phase-appropriate MCP checks with boundary awareness:
    - Day 1: budget pacing (`get_campaign_metrics`), tracking verification (ask user — not in API), obvious negatives (`run_gaql` search terms)
    - Day 7: search term mining (`run_gaql`), learning status (`get_campaign` — check `serving_status`), spend distribution
    - Day 14: learning exit assessment, performance vs baseline (`get_campaign_metrics`)
    - Day 30: full month review, optimization decisions
  - Step 4: Compare against baseline (from campaign-setup output if available)
  - Step 5: Recommend ONLY safe actions during learning (reference `[[learning-phase]]`)
  - Step 6: For actions MCP can execute (pause, enable, adjust bids/budgets) — propose via write tools. For actions MCP cannot execute (add negatives, edit ads) — output actionable list for manual implementation.
  - Step 7: Route to next skill based on findings
  - MCP boundary section: explicit list of what each check phase can pull via MCP vs what requires manual verification. Reference `[[mcp-capabilities]]`.
  - References: `[[learning-phase]]`, `[[post-launch-playbook]]`, `[[bidding-strategies]]`, `[[account-maturity-roadmap]]`, `[[mcp-capabilities]]`
  - Report Output: stage `05-optimize`

### Files to modify

1. **`skills/live-report/SKILL.md`** — Add 3 new report types to Available Reports:
   - Audience Performance (`run_gaql` with `ad_group_audience_view`)
   - PMax Asset Group Performance (`run_gaql` with campaign filter)
   - Conversion Action Breakdown (`run_gaql` with `conversion_action`)
2. **`skills/live-report/references/report-templates.md`** — Add GAQL queries + output templates for the 3 new report types.
3. **`skills/campaign-setup/SKILL.md`** — Add `post-launch-monitor` to "What to Do Next" routing table.
4. **`skills/CONTEXT.md`** — Add post-launch-monitor (skill count 13 → 14), dependency map, inter-skill references.
5. **Root `CONTEXT.md`** — Add routing row + update CLAUDE.md quick navigation table.

### Verification

- Walk through a mock Day 7 check: confirm each step maps to a real MCP tool or explicitly flags manual verification
- Confirm live-report now has 9 report types (up from 6)
- Confirm skill correctly distinguishes MCP-executable actions from manual-only actions

---

## v1.19.0 — Display, Brand Restrictions, NCA

**Why last:** MEDIUM priority content gaps. Display needs a full reference doc (20 audit checks exist with no backing reference). Brand restrictions and NCA are additions to existing files.

**Items addressed:** Display reference (B), Brand Restrictions for Search (C), New Customer Acquisition goal (D)

### New file

- **`reference/platforms/google-ads/display-campaigns.md`** — Full Display reference:
  - Campaign subtypes (Standard Display, Smart Display)
  - Responsive Display Ad specs and best practices
  - Targeting types: audiences, placements, topics, demographics
  - Exclusion management: placement exclusions (mobile apps, low-quality sites), content exclusions
  - Frequency capping
  - Performance benchmarks (CTR, VTC)
  - Display-specific bid strategies
  - Common mistakes (no placement exclusions, targeting too broad, VTC inflation)
  - Cross-references: the 20 audit checks in `audit-checklist.md`

### Files to modify

1. **`reference/platforms/google-ads/match-types.md`** — Add "## Brand Restrictions for Search" section: how they differ from PMax brand exclusions, setup via Google Ads Settings, interaction with broad match + AI Max.
2. **`reference/platforms/google-ads/campaign-types.md`** — Add NCA (New Customer Acquisition) goal to PMax and Search sections. Currently only documented for Demand Gen.
3. **`reference/platforms/google-ads/CONTEXT.md`** — Add `display-campaigns.md`.

### Verification

- Confirm the 20 Display audit checks in audit-checklist.md now have a backing reference doc
- Confirm NCA goal documented for all 3 campaign types that support it (PMax, Search, Demand Gen)

---

## Deferred Items

| Item | Recommendation | Reason |
|------|---------------|--------|
| AI Overviews impact on Search metrics | Defer to v1.20+ | Low-medium priority, still evolving, 5–10 line note would suffice |
| Privacy Sandbox / Topics API | Defer | Google handles this server-side for Google Ads; limited direct action for advertisers |
| Generative AI creative tools (Imagen 3) | Defer | Creative workflow, not campaign management. Brief mention in asset-requirements.md if needed |
| Automatically Created Assets (ACA) standalone doc | Defer | Partially covered in AI Max and feed-only PMax sections |
| Phase 4: Multi-platform | Skip for now | No user demand, empty placeholders |
| Product-level performance skill (Backlog #9) | Partially addressed | Shopping GAQL queries added in v1.15.0; standalone skill deferred until real usage shows what's needed |
| Backward feedback loops (P) | Addressed incrementally | v1.16 adds cleanup→review routing, v1.18 adds monitor→skill routing |
| Weak A/B testing / experimentation coverage | Defer to v1.20+ | `ad-testing-framework.md` exists; a skill could operationalize it later |
| Remarketing/audience strategy skill | Defer to v1.20+ | Reference exists, now wired (v1.16); full skill not yet needed |
| Google Ads API version matrix | Defer | Nice-to-have for MCP server maintenance, not urgent |
| MCP server tool expansion (create campaigns, add negatives, manage assets) | Defer | Requires MCP server development, not plugin changes. Document boundary now (v1.14), expand later. |

---

## Research Sources Used

- Plugin codebase: full file tree (80 reference files, 13 skills, 3 agents)
- MCP server source: `../google-ads-mcp-server/` (25 tools verified against implementation)
- BACKLOG.md: 9 items from Vaxteronline real-world usage
- Existing audit-gap-analysis.md: confirmed Priority 4 items (DSA, App)
- Web research: Google Ads 2025–2026 feature changes, Consent Mode v2 enforcement, API versions, Privacy Sandbox
- Cross-skill workflow analysis: entry/exit points, routing tables, orphaned references
- Tracking-bridge data flow diagrams: GTM → sGTM → GA4 / BigQuery / Google Ads pipeline
