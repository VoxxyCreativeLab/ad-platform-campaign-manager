---
title: Backlog — ad-platform-campaign-manager
date: 2026-04-08
tags:
  - backlog
  - plugin
  - ad-platform-campaign-manager
---

# Backlog — ad-platform-campaign-manager

Improvement items discovered during real-world usage of this plugin. Each item includes the source (where/how it was found) and the proposed fix.

> [!info] Origin
> This backlog was created during the Vaxteronline (vaxteronline.se) campaign management project, Stage 05 optimization. Items surfaced when the plugin gave contradictory guidance about what changes are safe during a smart bidding learning phase.

---

## Contradictions to Fix

### 1. "Don't adjust keywords during learning" is too broad

- **File:** `reference/platforms/google-ads/bidding-strategies.md` (line 151)
- **Current text:** `"No other changes -- don't adjust keywords, ads, or targeting during learning"`
- **Problem:** This implies adding negative keywords resets learning. It does not. Google's documentation confirms that negative keyword additions are safe during learning.
- **Fix:** Replace with a precise list distinguishing safe changes from disruptive ones. Reference the new `learning-phase.md` file (see Gap #1 below).

### 2. feed-only-pmax.md steps 12-14 contradict each other

- **File:** `reference/platforms/google-ads/pmax/feed-only-pmax.md` (lines 89-94)
- **Current:** Steps 12-13 say "add brand exclusions and negative keywords." Step 14 says "allow 2-4 weeks learning period before making changes."
- **Problem:** Steps 12-13 are changes. Step 14 says no changes. The reader cannot tell if negatives should be added before or after launch.
- **Fix:** Either (a) move steps 12-13 to the pre-launch section with a note that they should be done before enabling, or (b) add an explicit note after step 14: "Negatives and brand exclusions are safe during learning — they do not reset the learning period."

### 3. common-mistakes.md #20 is too vague

- **File:** `reference/platforms/google-ads/audit/common-mistakes.md` (lines 96-98)
- **Current:** `"Making changes during learning resets it"`
- **Problem:** "changes" is undefined. Adds to the confusion about what's safe vs. disruptive.
- **Fix:** Replace with "Making significant structural changes (bid strategy switches, budget changes >20%, conversion action changes) during learning resets it. Adding negatives, updating ad copy, and adjusting extensions are safe."

---

## Gaps to Fill

### 4. Missing: learning-phase.md — safe vs. disruptive changes reference

- **Proposed location:** `reference/platforms/google-ads/learning-phase.md`
- **Content:** A single authoritative reference table distinguishing:
  - **Disruptive (resets learning):** Bid strategy changes, target changes (tCPA/tROAS), budget changes >20%, conversion action changes, major campaign restructuring
  - **Safe (does not reset):** Adding negative keywords, updating ad copy/RSA assets, adjusting extensions, adding observation audiences, ad schedule tweaks
  - **Per campaign type:** Learning duration expectations (Search: 1-2 weeks, PMax: 2-4 weeks, Demand Gen: 2-3 weeks, Display: 1-2 weeks)
- **Why:** This was the root cause of the contradiction — no single source of truth existed in the plugin. Every other file references "learning" but each says something slightly different.

### 5. Missing: shopping_performance_view GAQL queries

- **Affected files:** `skills/live-report/references/report-templates.md`, `reference/reporting/gaql-query-templates.md`, `reference/platforms/google-ads/audit/audit-checklist.md`
- **Problem:** The audit checklist calls for "zombie product identification" and "top 10 revenue products" (lines 165-167) but provides no GAQL query. The `shopping_performance_view` resource is never referenced anywhere.
- **Fix:** Add GAQL query templates for:
  ```sql
  -- Product-level performance (top products by revenue)
  SELECT segments.product_item_id, segments.product_title,
    metrics.impressions, metrics.clicks, metrics.cost_micros,
    metrics.conversions, metrics.conversions_value
  FROM shopping_performance_view
  WHERE segments.date DURING LAST_30_DAYS
  ORDER BY metrics.conversions_value DESC
  LIMIT 50

  -- Zombie products (spend with zero conversions)
  SELECT segments.product_item_id, segments.product_title,
    metrics.impressions, metrics.clicks, metrics.cost_micros
  FROM shopping_performance_view
  WHERE segments.date DURING LAST_30_DAYS
    AND metrics.cost_micros > 0
    AND metrics.conversions = 0
  ORDER BY metrics.cost_micros DESC
  LIMIT 50
  ```
- **Bonus:** Consider a dedicated `/shopping-performance` skill or add a "Product Performance" report type to `/live-report`.

### 6. Missing: post-launch playbook

- **Proposed location:** `reference/platforms/google-ads/strategy/post-launch-playbook.md`
- **Content:** A unified day-by-day and week-by-week guide consolidating guidance currently scattered across 6+ files:
  - Day 0: Verify campaigns enabled, tracking firing, screenshots
  - Day 1: Pull first data, add obvious negatives (competitors), check budget pacing
  - Day 2 (48h): Remarketing/Display serving check
  - Day 7: First clean-week report, search term mining, learning status check
  - Day 14: PMax learning exit assessment, second search term pass
  - Day 21: tROAS gate check (conversion volume threshold)
  - Day 30: Full month review, bid strategy upgrade decision
- **Why:** During the Vaxteronline launch, the guidance for post-launch behavior had to be assembled from `bidding-strategies.md`, `account-maturity-roadmap.md`, `feed-only-pmax.md`, `demand-gen.md`, `campaign-cleanup SKILL.md`, and `budget-optimizer SKILL.md`. A single playbook would prevent this.

### 7. Learning period duration table — unify across files

- **Affected files:** `bidding-strategies.md`, `pmax-guide SKILL.md`, `feed-only-pmax.md`, `demand-gen.md`, `audit-checklist.md`, `account-maturity-roadmap.md`
- **Problem:** Different files cite different durations (1-2 weeks, 2-3 weeks, 2-4 weeks, 7-14 days) without explaining why.
- **Fix:** Add a table to the new `learning-phase.md` explaining per-type/per-strategy durations. Then reference it from all other files instead of each stating its own number.

### 11. [AUTO] Meta Ads to BigQuery Pipeline

- **Source project:** 0014 - Client WinstArchitect - subclient Next Chapter
- **Date found:** 2026-04-13
- **Affected file:** `reference/reporting/` (BigQuery reporting referenced conceptually but no Meta Ads-specific pipeline guidance)
- **Category:** Gap
- **Description:** BigQuery Data Transfer Service for Meta Ads data: native Google connector, 24h refresh, zero maintenance, free. OWOX Data Marts (`OWOX/owox-data-marts`, MIT license, open source) as upgrade path for more granular/frequent data. n8n HTTP Request to Meta Marketing API as alternative for real-time data. Schema design for `meta_ads_performance` table. When to use each approach: start with Data Transfer Service, upgrade to OWOX if sub-daily granularity needed.
- **Proposed fix:** Add a `reference/reporting/meta-ads-bigquery.md` file covering all three pipeline approaches with decision guidance.
- **Status:** ✅ Done (v1.25.0 pending) — routing edge added; content lives in n8n-plugin `reference/patterns/meta-ads-cost-to-bq.md`

### 13. [AUTO] Cross-Platform Data Model for BigQuery

- **Source project:** 0014 - Client WinstArchitect - subclient Next Chapter
- **Date found:** 2026-04-13
- **Affected file:** `reference/reporting/` (BigQuery architecture referenced but no cross-platform normalization guidance)
- **Category:** Gap
- **Description:** Meta + GA4 + iClosed + Airtable normalization in BigQuery. 5-source architecture: GA4 (native BQ export, daily), Meta Ads (BigQuery Data Transfer Service, 24h), iClosed (n8n webhook -> BQ node, real-time), Airtable (n8n Airtable Trigger -> BQ node, polling 5-15min), sGTM (sGTM BQ tag, streaming). Key join fields: `contactId` as cross-system key linking iClosed records to Airtable to CAPI events. `callPreviewId` as CAPI `event_id` for deduplication. Lead lifecycle stages (Lead/MQL/Booked/SQL/Closed) mapped across tools and tables. `fbc` reconstruction from stored fbclid: `fb.1.{bookingTime_unix}.{fbclid}`.
- **Proposed fix:** Add a `reference/reporting/cross-platform-data-model.md` file covering join key strategy, table schemas, and lifecycle stage mapping for high-ticket funnel stacks.
- **Status:** ✅ Done (v1.25.0 pending) — routing edge added; cross-platform BQ model covered by n8n-plugin Airtable + BigQuery + 4-workflow recipes

### 14. BigQuery pipeline expansion — native connections + n8n BQ→Meta offline conversions

- **Date found:** 2026-04-16 (updated 2026-04-16 session 7 with reference repos)
- **Affected file:** `reference/reporting/` (sGTM → BQ documented, but native platform connections and reverse BQ → CAPI flow missing)
- **Category:** Gap
- **Description:** Two related needs: (1) Native BigQuery connector strategies for GA4 (BQ export), Google Ads (Data Transfer Service), and Meta Ads (Data Transfer Service) — these are the simplest "plug in and forget" pipelines. (2) n8n reverse pipeline: read offline conversion data from BigQuery, batch and send to Meta CAPI as offline events. Decision guidance for when to use native vs. n8n for each source.
- **Related to:** #11 (Meta Ads to BigQuery), #13 (Cross-platform data model)
- **Proposed fix:** Expand or add to `reference/reporting/bigquery-connections.md` covering native connectors per platform and the BQ → Meta CAPI n8n workflow pattern.
- **Reference repos (researched 2026-04-16):**
  - `OWOX/owox-data-marts` (219 stars, active, MIT) — open-source Meta Ads→BigQuery connector + session-level cost attribution SQL. Also supports LinkedIn, TikTok, Reddit. Preferred over BigQuery Data Transfer Service for sub-daily granularity.
  - `google-marketing-solutions/ga4_dataform` (155 stars, active) — official Google Dataform project: transforms raw GA4 BQ exports into sessions, users, transactions + last-click attribution. Foundation layer for GA4 data.
  - `fivetran/dbt_facebook_ads` (49 stars, active) — gold-standard Meta Ads schema design (staging→intermediate→mart). Schema patterns reusable even without Fivetran.
  - `aliasoblomov/Bigquery-GA4-Queries` (128 stars, active) — 65+ ready SQL queries for GA4 BQ data: funnel analysis, conversion paths, user journeys.
  - `RuslanFatkhutdinov/sql-for-attribution-models` (41 stars) — SQL for first-click, last-click, linear, time-decay attribution from GA4 BQ export.
  - `GoogleCloudPlatform/bigquery-utils` (1,290 stars, active) — official Google UDFs and utilities for BigQuery.
  - `kobzevvv/marketing-attribution-data-model` (23 stars) — multi-touch attribution schema patterns.
  - ga4bigquery.com — end-to-end BQ→Looker attribution tutorial with 5 attribution models side-by-side.
- **Status:** ✅ Done (v1.25.0 pending) — BQ→Meta CAPI reverse path lives in n8n-plugin `reference/patterns/bq-to-capi-offline.md`; routing edge added to reporting-pipeline skill

### 15. Email marketing knowledge — Klaviyo

- **Date found:** 2026-04-16
- **Affected file:** None (new platform domain — no email marketing coverage exists)
- **Category:** Gap
- **Description:** Email marketing fundamentals specific to Klaviyo: lists, segments, flows, campaigns. Klaviyo ↔ Meta integration (Custom Audiences sync, suppression lists). Klaviyo ↔ BigQuery export options. Klaviyo tracking: web pixel, event tracking, Identify API. E-commerce flows: abandoned cart, post-purchase, browse abandonment. Attribution: Klaviyo last-touch vs. Meta attribution window conflicts.
- **Client context:** Vaxteronline (vaxteronline.se) uses Klaviyo — this will surface in campaign management sessions.
- **Proposed fix:** Add `reference/platforms/klaviyo/klaviyo-fundamentals.md` as a new platform domain. Scope to what a tracking specialist needs to know when advising on a Klaviyo-integrated account.
- **Status:** Open

### 16. Looker Studio dashboards from BigQuery

- **Date found:** 2026-04-16 (updated 2026-04-16 session 7 with lead gen patterns + reference repos)
- **Affected file:** `reference/reporting/` (BigQuery pipelines documented but no visualization layer)
- **Category:** Gap
- **Description:** End-to-end guidance for building Looker Studio dashboards from BigQuery data: connector setup, standard report templates for ad performance (GAds + Meta + GA4 blended), performance optimization (query caching, aggregation tables), calculated fields for common ad metrics (ROAS, CPA, CR), cross-source blending strategies.
- **Lead gen dashboard pattern (Next Chapter session 7):** 4-page structure proven for high-ticket coaching funnels with multi-source data (Meta Ads + GA4 + CRM + BigQuery views):
  1. **Overzicht** — 5 KPIs (CPL, leads/week, belconversie/call conversion, LTV, ROAS) + funnel summary (LEAD→MQL→SQL counts). Executive health check.
  2. **Funnel & Leads** — LEAD→MQL→SQL trend, drop-off rates, lead quality, source breakdown. Grows to: second funnels, lead scoring.
  3. **Campagnes** — Paid media spend/CPL/CTR/ROAS per campaign/ad set. Designed as "Paid media" not "Meta Ads" so additional platforms (Google Ads, LinkedIn, TikTok) slot in as filter toggles.
  4. **Omzet & Retentie** — Deal value, LTV, revenue cohort, retention metrics (Pillar 2, month 2+). Grows to: upsell tracking, churn, subscription metrics.
- **Design principle:** Structure pages by data domain, not by current platform. Enables adding platforms/services without restructuring the dashboard.
- **Reference repos/resources (researched 2026-04-16):**
  - `google/looker-studio-dashboard-cloner` (38 stars, active) — clone dashboards via Linking API. Useful for deploying custom templates to clients.
  - Porter Metrics free templates — free Looker Studio templates including Meta Ads and multi-channel marketing. Structural reference.
  - Catchr funnel template guide — practical walkthrough of custom funnel pages in Looker Studio (better than native funnel chart).
- **Proposed fix:** Add `reference/reporting/looker-studio.md` covering setup, templates, blending patterns, performance best practices, and the 4-page lead gen structure.
- **Status:** Open

---

## Future Capabilities

### 8. Automated post-launch checks

- **Type:** New skill or enhancement to `/live-report`
- **Concept:** An automated post-launch monitoring skill that:
  - Knows the launch date and campaign structure
  - Runs day-appropriate checks (e.g., Day 2 = remarketing serving check)
  - Compares metrics against the baseline snapshot
  - Flags anomalies using the safe-vs-disruptive framework
  - Suggests only safe actions (negatives, not bid changes)
- **Priority:** Medium — design after the reference fixes are done

### 9. Product-level performance skill

- **Type:** New skill or report type
- **Concept:** Pull per-product (per `item_id`) performance from `shopping_performance_view`, identify zombie products, top converters, and products with high impressions but low CTR (feed optimization candidates)
- **Depends on:** Gap #5 (GAQL queries must exist first)
- **Priority:** High for e-commerce accounts

### 10. [AUTO] iClosed Tracking Patterns

- **Source project:** 0014 - Client WinstArchitect - subclient Next Chapter
- **Date found:** 2026-04-13
- **Affected file:** Unknown (new platform domain — no iClosed coverage exists)
- **Category:** New Capability
- **Description:** GTM URL param injection for iClosed 2-Step Scheduler: iClosed URL param injector GTM Custom HTML tag on Thank You page, Scenario A (single container, events on parent dataLayer) vs Scenario B (dedicated iClosed container). Webhook-to-n8n pipeline using real iClosed API event names: `newContactCreated`, `contactDetailChanged`, `contactByStatus`, `newCallScheduled`, `callCancelled`, `callRescheduled`, `callOutcome`. fbclid passthrough via webhook `tracking` object: `utmKey_N`/`utmValue_N` key-value pairs (confirmed in iClosed developer docs). callOutcome attribution gap: `callOutcome` webhook has no `tracking` data — fbclid must be retrieved from CRM via `contactId` correlation. Consent gating for iClosed GTM events: `cookie_consent_marketing` trigger, Consent Mode v2 defaults denied. GTM dataLayer events (`iclosed_view`, `iclosed_qualified`, etc.) are UNVERIFIED (not in developer docs).
- **Proposed fix:** TBD
- **Status:** ✅ Done (v1.25.0 pending) — routing edge added; iClosed knowledge lives in n8n-plugin `reference/nodes/recipes/iclosed.md`

### 12. [AUTO] n8n as Automation Layer in Tracking Stacks

- **Source project:** 0014 - Client WinstArchitect - subclient Next Chapter
- **Date found:** 2026-04-13
- **Affected file:** Unknown (new platform domain — no n8n coverage exists)
- **Category:** New Capability
- **Description:** n8n replaces Zapier/Make in tracking stacks. n8n Cloud Starter: EUR 24/mo, unlimited users, client-owned account. Webhook security: URL-based secret token only (no HMAC available from iClosed, on their roadmap). 4-workflow pattern for high-ticket coaching funnels: WF1 booking-to-CRM (`newCallScheduled` -> Airtable), WF2 outcome-to-CRM (`callOutcome` -> Airtable update), WF3 CRM-to-CAPI (Airtable fbclid -> Meta CAPI Purchase, `action_source: system_generated`), WF4 events-to-BigQuery (all webhooks -> BigQuery raw log). n8n nodes used: `n8n-nodes-base.webhook`, `n8n-nodes-base.airtable`, `n8n-nodes-base.httpRequest`, `n8n-nodes-base.googlebigquery`.
- **Proposed fix:** TBD
- **Status:** ✅ Done (v1.25.0 pending) — routing edge added; content lives in n8n-plugin `reference/patterns/4-workflow-tracking-stack.md`

### 17. GTM scripts review — cookie collection cHTML tag (Watermelon plan)

- **Date found:** 2026-04-16
- **Affected file:** Unknown (scripts not yet reviewed — assessment needed before target file is known)
- **Category:** New Capability
- **Description:** Jerry has several custom GTM scripts to review for plugin incorporation. Priority: a client-side Custom HTML tag that collects cookies — used in the Watermelon plan stack. Need to assess each script: what it does, whether it's generic enough to include as a plugin reference or template, and where it belongs (tracking-bridge, reference/platforms/google-ads/scripts, or a new scripts reference).
- **Proposed fix:** Review scripts, extract generic/reusable patterns, determine target files. Likely adds content to `tracking-bridge/` or a new `reference/scripts/` section.
- **Status:** Open

### 18. Watermelon plan knowledge extraction

- **Date found:** 2026-04-16
- **Affected file:** Multiple — target files TBD after extraction
- **Category:** New Capability
- **Description:** ~100-page strategic document containing tracking strategy, campaign patterns, and pipeline architecture. Must be read and mined for generic, reusable knowledge that is not client-specific. Extracted knowledge will populate multiple reference files. Process: (1) read document, (2) identify reusable patterns vs. client-specific content, (3) map each pattern to existing or new reference files, (4) write additions without client identifiers.
- **Proposed fix:** Structured extraction session — read doc, produce extraction map, then add content to relevant `reference/` files in targeted commits.
- **Status:** Open

### 21. [AUTO] ClickFunnels 2.0 tracking patterns

- **Source project:** 0014 - Client WinstArchitect - subclient Next Chapter
- **Date found:** 2026-04-16
- **Affected file:** Unknown (new platform domain — zero ClickFunnels coverage exists in the plugin)
- **Category:** Gap
- **Priority:** Medium
- **Description:** ClickFunnels 2.0 (CF2.0) is a funnel builder used by high-ticket coaching clients. Key tracking patterns needed: (1) GTM installation via CF2.0 head/footer code injection (Settings → Tracking Codes). (2) Native dataLayer events: `cfPageView` (page load) and `cfLead` (form submit) — CF2.0 pushes these automatically; field names: `contactFirstName`, `contactEmailAddress`, `contactPhoneNumber`, `contactId`. (3) Multi-page funnel tracking: each CF2.0 page is a separate URL, so GTM fires per page using page path triggers. (4) Thank You page pattern: a separate CF page (not a redirect) where post-conversion tags fire. (5) fbclid capture on landing: GTM Custom HTML tag reads `?fbclid=` from URL → sets first-party `_fbclid` cookie (7-day, SameSite=Lax, Secure). (6) PII rule: `contactEmailAddress`, `contactPhoneNumber` from `cfLead` must never flow into GA4 or any analytics tool — only into server-side CRM pipelines. (7) Consent Mode v2 integration: consent defaults fire on all CF2.0 pages via GTM. (8) CF2.0 has a second GTM container slot (for iClosed or other embeds) — distinct from the main container.
- **Proposed fix:** Add `reference/platforms/clickfunnels/clickfunnels-tracking.md` covering GTM installation, native dataLayer events, multi-page patterns, fbclid capture, PII rules, and consent integration.
- **Status:** Open

### 20. n8n-plugin prerequisite for v1.21.0

- **Source project:** ad-platform-campaign-manager Session 4 planning
- **Date found:** 2026-04-13 (approx)
- **Affected file:** `n8n-workflow-builder-plugin` (external — built in sibling plugin)
- **Category:** Prerequisite
- **Priority:** Critical
- **Description:** Tracked the external dependency on n8n-workflow-builder-plugin being built before items #10, #11, #12, #13, #14 could resume. Satisfied by n8n-workflow-builder-plugin v0.1.0 shipping (see #31).
- **Status:** ✅ Done (v1.23.0) — n8n-workflow-builder-plugin v0.1.0 shipped

### 19. Shopping performance regression diagnostic protocol

- **Source project:** 0013 - Client Plantentotaal (Vaxteronline)
- **Date found:** 2026-04-16 (Session 26)
- **Affected file:** `reference/platforms/google-ads/shopping-campaigns.md` (lacks troubleshooting section), `skills/post-launch-monitor/SKILL.md` (no root-cause routing for ROAS drops)
- **Category:** Gap
- **Priority:** HIGH
- **Description:** After the Day 7 restructure (product group subdivision, budget increase, individual bids), the Shopping campaign dropped from 7.49 ROAS (30-day pre-restructure) to 0.41 ROAS (last 7 days). There is no structured protocol in the plugin for diagnosing *why* a Shopping campaign that was performing well suddenly stopped converting. The `shopping-campaigns.md` reference covers setup and best practices but not regression investigation. The `post-launch-monitor` skill covers phase-based monitoring but not root-cause diagnosis of a ROAS collapse.
- **Proposed fix:** New file `reference/platforms/google-ads/shopping-performance-regression-diagnosis.md` with:
  1. **Symptoms taxonomy** — map observable patterns to hypothesis categories
  2. **Hypothesis checklist** (in investigation order): attribution shift, bid structure disruption, product disapprovals, budget change side effects, seasonal demand shift, conversion tracking gap, feed issues
  3. **GAQL queries for each hypothesis** — ready to copy-paste via MCP
  4. **Interpretation guides** — what to look for in each query result
  5. **Action routing** — based on confirmed hypothesis (e.g., H1 confirmed → attribution model shift, not structural fix)
  6. **30-day vs 7-day window warning** — contaminated windows after restructures
  
  Additional changes:
  - Add "Troubleshooting" section to `shopping-campaigns.md` linking to the new file
  - Update `post-launch-monitor` skill to route to this file when Shopping ROAS drops >30% vs baseline
- **Status:** Open

### 22. [AUTO] Feed-only PMax AD STRENGTH = POOR incorrectly flagged across 7 files

- **Source project:** campaign-vaxteronline-project-files
- **Date found:** 2026-04-16
- **Affected file:** Multiple — see description
- **Category:** Contradiction
- **Priority:** High
- **Description:** Feed-only PMax (created via Merchant Center) has AD STRENGTH = POOR by design — no text/image assets, serves Shopping surfaces only via the product feed. This is correct and intentional behavior. However, 7 files in the plugin treat AD STRENGTH = POOR as a problem to fix for ALL PMax campaigns without distinguishing feed-only from regular PMax. This caused an incorrect "add PMax assets" recommendation in a live client session (Vaxteronline), which would have broken the feed-only approach by turning it into a full PMax with additional ad surfaces. Affected files: (1) `skills/post-launch-monitor/SKILL.md` line 90 — flags POOR asset groups for all PMax; (2) `reference/platforms/google-ads/audit/audit-checklist.md` lines 112-119 — requires images + video for all PMax; (3) `agents/campaign-reviewer.md` lines 70, 74-78 — requires "Good+" ad strength; (4) `agents/strategy-advisor.md` lines 115-118, 173 — scores Poor strength as 1/10 dragging down account score; (5) `reference/platforms/google-ads/audit/audit-gap-analysis.md` line 84 — requires "Good or Excellent" for PMax; (6) `reference/platforms/google-ads/audit/common-mistakes.md` lines 124-126 — flags "no custom video" as a PMax mistake without feed-only context; (7) `skills/live-report/references/report-templates.md` lines 300-333 — reports ad_strength=POOR with no feed-only context note.
- **Proposed fix:** Add a "feed-only exception" clause to each of the 7 files: "Feed-only PMax campaigns (created via Merchant Center, no text/image assets) always show AD STRENGTH = POOR. This is expected behavior — do not flag as an issue or recommend adding assets." The `pmax-guide` SKILL.md and `feed-only-pmax.md` already correctly document this; the audit/review/monitoring tools must align.
- **Status:** Open

### 23. [AUTO] No structured growth/scaling management skill

- **Source project:** campaign-vaxteronline-project-files
- **Date found:** 2026-04-16
- **Affected file:** `reference/platforms/google-ads/strategy/account-maturity-roadmap.md` (describes stages but doesn't guide transitions)
- **Category:** Gap
- **Priority:** High
- **Description:** The plugin covers build → audit → optimize but has no skill for "what comes after optimization starts working." The maturity roadmap describes four stages but provides no interactive skill or workflow for managing the transition between them. Missing elements: (1) expansion trigger framework — when to add campaigns, increase budget, expand geo; (2) diminishing returns analysis — when a campaign is at optimal spend vs. has room to grow; (3) portfolio management for interdependent multi-campaign stacks with cannibalization risks; (4) structured bid strategy graduation workflow with live data gates (not just thresholds described in prose). This gap was the direct root cause of a fabricated 5x ROAS growth projection in a live client email (Vaxteronline, April 16 session) — there was no skill to reference for grounded growth projections, so claims were invented. Note: the maturity roadmap says tROAS requires 50+ conversions/month; the post-launch playbook says the same; but no skill actively surfaces this check at the right moment.
- **Proposed fix:** New skill `/ad-platform-campaign-manager:account-scaling` that: (1) reads current account metrics and maturity stage; (2) runs against documented transition criteria; (3) produces a phase-specific action list — what to do now, what gate must pass before the next action; (4) explicitly blocks forward-looking ROAS projections that aren't grounded in real data gates. Alternatively: add a "Scaling phase" section to `account-strategy` skill.
- **Status:** ✅ Done (v1.23.0) — `/account-scaling` skill ships with 8-gate MCP evaluation, T1-T6 trajectory routing, CoV computation, and always-report to `05-optimize/`. `scaling-playbook.md` reference added.

### 24. [AUTO] tROAS/tCPA transition gates not surfaced in post-launch-monitor skill

- **Source project:** campaign-vaxteronline-project-files
- **Date found:** 2026-04-16
- **Affected file:** `skills/post-launch-monitor/SKILL.md`
- **Category:** Gap
- **Priority:** High
- **Description:** The `post-launch-monitor` skill runs phase-appropriate checks and generates reports, but it does not explicitly evaluate whether a bid strategy transition is appropriate at the current phase. Google's documented tROAS minimum is 50 conversions/month; tCPA is 30/month. The skill should query the account's conversion volume at Day 14 and Day 21 checkpoints, compare to these thresholds, and explicitly state "tROAS not yet eligible — current rate: X/month, threshold: 50/month." Without this check, sessions default to narrative-based projections. The omission also means `post-launch-monitor` reports can be written that imply bid strategy changes are imminent without any data gate being evaluated.
- **Proposed fix:** Add a "Bid Strategy Readiness" section to the Day 14 and Day 21 outputs of `post-launch-monitor`. Pull `metrics.conversions` for LAST_30_DAYS, compare to 30 (tCPA) and 50 (tROAS) thresholds, and output one of: ELIGIBLE / APPROACHING (>70%) / NOT YET. Reference `bidding-strategies.md` for threshold values so the check stays in sync if thresholds are updated.
- **Status:** ✅ Done — v1.25.0 (pending release)

### 25. [AUTO] Negative keyword write tools missing from MCP server

- **Source project:** campaign-vaxteronline-project-files
- **Date found:** 2026-04-16
- **Affected file:** `reference/mcp/mcp-capabilities.md` (documented as a known gap; operational impact confirmed as High)
- **Category:** Gap
- **Priority:** High
- **Description:** Every search term review (keyword-strategy, campaign-review, post-launch-monitor, campaign-cleanup) results in "add these as negative keywords" recommendations, but the MCP server has no negative keyword write tools. This is the single most frequent optimization action in active campaign management, and it must be executed manually by the user in the Google Ads UI every time. The gap is documented but the operational burden is significant: in the Vaxteronline account, negative keyword additions are recommended at every monitoring session with no automation possible. The MCP server currently supports: pause/enable/update for campaigns, ad groups, keywords, and ads. Negative keyword management is absent.
- **Proposed fix:** Add MCP tools: `add_negative_keyword` (campaign-level and ad-group-level), `remove_negative_keyword`, `list_negative_keywords`. These map to `CampaignCriterion` and `AdGroupCriterion` with `negative: true` in the Google Ads API. Scope: text match types (exact, phrase, broad). Add the three-gate safety protocol (same as existing write tools). Document in `mcp-capabilities.md` Section 3 once shipped.
- **Status:** Open

### 26. [AUTO] Attribution-aware reporting missing from live-report skill

- **Source project:** campaign-vaxteronline-project-files
- **Date found:** 2026-04-16
- **Affected file:** `skills/live-report/SKILL.md`, `reference/reporting/gaql-query-templates.md`
- **Category:** Gap
- **Priority:** Medium
- **Description:** The `live-report` skill reports `metrics.conversions` (primary, last-click) only. When Shopping + PMax + Remarketing coexist, the `metrics.all_conversions` field is critical for understanding the true multi-touch contribution of each campaign. The attribution shift between Shopping (discovery) and PMax/remarketing (close) is invisible in primary conversion reporting alone. In the Vaxteronline account, Shopping showed 0.41x ROAS on primary conversions but 23.7x on all_conversions — a 58x difference. Without the all_conversions dimension, the report is misleading for any account running a multi-campaign funnel. Confirmed via live GAQL: `metrics.all_conversions` and `metrics.all_conversions_value` are accessible at campaign level AND at `shopping_performance_view` product level.
- **Proposed fix:** (1) Add `all_conversions` and `all_conversions_value` to the default campaign performance report template in `live-report`. (2) Add an "Attribution health check" section: when Shopping + PMax coexist, compare primary vs. all_conversions across campaigns and flag if Shopping's all_conversions/primary ratio exceeds 5:1 (strong attribution shift signal). (3) Add the attribution shift interpretation to `reference/platforms/google-ads/strategy/attribution-guide.md`. Update the relevant GAQL templates.
- **Status:** Open

### 27. [AUTO] Ad copy and asset mutation not possible via MCP

- **Source project:** campaign-vaxteronline-project-files
- **Date found:** 2026-04-16
- **Affected file:** `reference/mcp/mcp-capabilities.md` (Section 3 — write tool gaps)
- **Category:** Gap
- **Priority:** Medium
- **Description:** The `ad-copy` skill generates high-quality multilingual ad copy, but there is no mechanism to push it into Google Ads via MCP. Every copy output requires manual implementation by the user in the Google Ads UI. The same applies to ad extensions (sitelinks, callouts, structured snippets) and PMax asset groups. This gap means the full round-trip (generate → review → implement → verify) requires two distinct tools and a manual step in the middle. Not a blocker, but a persistent operational friction for every ad copy update cycle.
- **Proposed fix:** Add MCP tools for RSA headline/description mutation: `update_ad_headline`, `update_ad_description` targeting `AdGroupAd.ad.responsive_search_ad`. For extensions: `add_sitelink`, `add_callout`. These are lower-priority than negative keywords (item #25) but address the same "output only, no write path" limitation. Minimum viable: even a `create_rsa_ad` that takes headline/description arrays and creates a new RSA in a given ad group would close 80% of the friction.
- **Status:** Open

### 28. [AUTO] No guard rail against aspirational projections in client communication

- **Source project:** campaign-vaxteronline-project-files
- **Date found:** 2026-04-16
- **Affected file:** `skills/post-launch-monitor/SKILL.md`, `_config/conventions.md`
- **Category:** Gap
- **Priority:** Medium
- **Description:** The plugin has no mechanism to prevent forward-looking ROAS projections in client-facing communication that are not grounded in documented strategy gates. In the Vaxteronline April 16 session, an email was written with a "5x ROAS in June/July" projection that had no basis in any strategy document, optimization spec, or research source. The actual documented strategy specified tROAS at 3.0 after 30 conversions (April 8 spec); the April 16 regression report had already invalidated that gate entirely. The email invented numbers to reassure the client. No skill or convention file prevented this. Root issue: when writing client emails, the skill/session does not cross-reference documented strategy gates before asserting what performance will look like in the future.
- **Proposed fix:** (1) Add a "Client communication projection rule" to `_config/conventions.md`: "Never state a future ROAS target in client communication that does not appear in a dated strategy document (spec, report, or approved plan). If no documented target exists, describe the data gate that determines the next step — not the expected outcome." (2) Add a "Before sending" checklist to any email-drafting workflow: every performance projection must be traceable to a specific file and line. (3) Consider adding a communication review step to the `post-launch-monitor` skill output: "Draft email section: [generated]. Strategy reference check: [list of files cited]."
- **Status:** ✅ Done (v1.23.0) — 3-layer guardrail added: global `~/.claude/CLAUDE.md` one-liner + `project-structure-and-scaffolding-plugin/_config/conventions.md` generic rule + ad-platform `_config/conventions.md` domain-specific rule with ROAS/CPA examples. FTC + UK CAP + DMCC cited. Scope: all 15 skills + 3 agents.

### 29. [AUTO] MCP documentation error — user_list sizes are API-accessible

- **Source project:** campaign-vaxteronline-project-files
- **Date found:** 2026-04-16
- **Affected file:** `reference/mcp/mcp-capabilities.md` (Section 4 — "Not Available via MCP")
- **Category:** Contradiction
- **Priority:** Medium
- **Description:** `mcp-capabilities.md` Section 4 lists "Audience list definitions (membership rules, sources, composition)" as manual-only: "Cannot verify audience list health programmatically." However, live GAQL testing confirms that `user_list.name`, `user_list.size_for_display`, `user_list.size_for_search`, `user_list.membership_status`, and `user_list.type` ARE accessible via `run_gaql` against the `user_list` resource. Confirmed working query: `SELECT user_list.name, user_list.size_for_display, user_list.size_for_search, user_list.membership_status, user_list.type FROM user_list`. The Vaxteronline account returned 16 audience lists with sizes (e.g., All visitors: 1,600 display / 760 search; Cart abandoners: 16 display / 24 search). What IS manual-only: audience membership rules, CMP/consent state, and GA4-sourced audience definitions. The documentation overstates the limitation.
- **Proposed fix:** Update `mcp-capabilities.md` Section 4: move `user_list` from the "Not Available" list to Section 2 (GAQL-accessible). Add a query template to `gaql-query-templates.md`. Update audit checklist Area 10 (audience strategy) to include the user_list size check as an MCP-automated step. Keep the note that membership rules and consent state remain manual.
- **Status:** Open

### 30. [AUTO] MCP server read capability expansion — compatibility validation needed

- **Source project:** ad-platform-campaign-manager v1.23.0 design session
- **Date found:** 2026-04-16
- **Affected file:** `reference/mcp/mcp-capabilities.md`, any skill referencing specific GAQL resources or tool responses
- **Category:** Dependency / Validation
- **Priority:** Medium
- **Description:** The `google-ads-mcp-server` is being updated with additional read capabilities and bug fixes (work in progress 2026-04-16, during the v1.23.0 design session). When the update ships, the following validation is needed: (1) compare new tool set against `mcp-capabilities.md` Section 1-3 — update the capability matrix for any added or changed tools; (2) check `mcp-capabilities.md` Section 4 ("Not Available via MCP") — any manual-only items now covered by new read tools should be moved to Section 2; (3) validate that existing GAQL patterns in `post-launch-monitor`, `live-report`, `campaign-review`, and the new `/account-scaling` skill are still compatible with any changed tool signatures or response formats.
- **Proposed fix:** Validation session after MCP server update ships. Re-run the mcp-capabilities accuracy check, update all affected sections, and confirm no skill breakage from changed tool interfaces.
- **Status:** Open — pending MCP server update completion

### 31. [AUTO] Pending n8n cross-plugin routing edges — commit with next release

- **Source project:** n8n-workflow-builder-plugin v0.1.0 build (2026-04-17)
- **Date found:** 2026-04-17
- **Affected file:** `skills/CONTEXT.md`, `skills/ads-scripts/SKILL.md`, `skills/conversion-tracking/SKILL.md`, `skills/live-report/SKILL.md`, `skills/reporting-pipeline/SKILL.md`
- **Category:** Ecosystem / Cross-ref
- **Priority:** Low
- **Description:** During the n8n-workflow-builder-plugin v0.1.0 build, editorial cross-plugin routing edges were added to 5 ad-platform skill files so this plugin recommends n8n when a user's workflow shifts from Google Ads data work into delivery automation. These are additive rows in existing "What to Do Next" tables plus a new "Cross-Plugin Routing" section in `skills/CONTEXT.md`. They are currently uncommitted because the v1.23.0 design session is active in parallel. Zero file overlap with v1.23.0 work (BACKLOG / PLAN / PRIMER) — no merge conflicts. Commit alongside v1.23.0 or as a standalone follow-up.
- **Proposed fix:** On the next release commit (v1.23.0 or later), include the 5 cross-ref files in the staged set. Suggested commit message: `feat: add cross-plugin routing edges to n8n-workflow-builder-plugin`. Verify via `git log --follow skills/CONTEXT.md` that the "Cross-Plugin Routing → n8n-workflow-builder-plugin" section appears in history.
- **Status:** ✅ Done (v1.23.0) — committed as standalone pre-flight commit `46e22ee` before v1.23.0 work began.


%% New items are appended below this line by /plugin-backlog %%

### 32. Reference doc: how to lift a budget freeze before its date

- **Date found:** 2026-04-18
- **Affected file:** None (new reference doc needed)
- **Category:** Gap
- **Priority:** High
- **Description:** No single reference doc in the plugin covers the specific scenario of lifting a budget freeze (like a T5 freeze) before its scheduled end date. Relevant guidance is currently scattered across `scaling-playbook.md` (IS-headroom gates), `post-launch-playbook.md` (budget re-entry after learning), and `learning-phase.md` (what resets learning — >20% budget changes). The `evidence-arbiter` and `budget-advisor` agents would benefit from a dedicated doc that covers: (1) when lifting a freeze early is justified by data, (2) safe step sizing to avoid learning reset, (3) conditions that must be met (ROAS stability, IS-lost-budget threshold, conversion volume), (4) what official Google guidance says about budget freeze management.
- **Proposed fix:** New file `reference/platforms/google-ads/strategy/lift-budget-freeze.md` covering early-lift criteria, step-sizing rules, official Google guidance citations, and decision flowchart.
- **Status:** ✅ Done (v1.25.0 pending) — `lift-budget-freeze.md` created; cross-links added to scaling-playbook, post-launch-playbook, learning-phase

### 33. [AUTO] War-council: plan-mode guard + full-dispatch enforcement

- **Source project:** campaign-vaxteronline-project-files
- **Date found:** 2026-04-18
- **Affected file:** `skills/ad-campaign-war-council/SKILL.md` (primary — Step 3, line 121); `skills/ad-campaign-war-council/CONTEXT.md` (secondary — Dispatch Pattern section, lines 52–74)
- **Category:** Contradiction
- **Priority:** High
- **Description:** Two related issues discovered in a live war-council session (Vaxteronline, Day 12): (1) **Plan-mode conflict:** The war-council skill has no plan-mode detection mechanism. When invoked inside plan-mode, the system constrains all agent dispatch to "max 3 Explore subagents only," silently collapsing the war-council's 6-parallel-specialist + 1-serial-arbiter pattern into a 3-Explore-agent research sweep. The user receives a degraded output with no warning that the war-council ran at partial capacity. The affected session was missing: `growth-architect` (forward 30/60/90 blueprint), `research-analyst` (no Tier-1 external benchmarks), and `evidence-arbiter` (no rule-override verdict on T5 freeze) — exactly the three helpers most critical for the "scale spend" question asked. (2) **Under-dispatch on full-account questions:** `SKILL.md` Step 3 line 121 states "Only dispatch helpers that are actually needed — do not dispatch all seven for every question." For question types classified as "Full account brief" or "Forward planning," ALL 6 parallel helpers are required by definition. The current guidance leaves room for judgment that incorrectly reduces the helper set, and the worked example in `CONTEXT.md` shows only 3 helpers for a budget-override dispatch, which reinforces under-dispatch as the default.
- **Proposed fix:** (1) Add a `> [!warning] Plan-Mode Detected` callout to Step 0 of `SKILL.md`: if the session is running inside plan-mode, emit a hard stop instructing the user to exit plan-mode before the war-council can proceed — the specialist dispatch pattern requires the full Agent tool, which plan-mode restricts. Do not attempt a degraded run. (2) Update `SKILL.md` Step 3: add an explicit rule — "For question types 'Full account brief' and 'Forward planning,' dispatch ALL 6 parallel helpers. These are the only two question types where partial dispatch is never acceptable." (3) Update `CONTEXT.md` Dispatch Pattern section: add a "Full account check / Forward planning" worked dispatch example showing all 6 helpers (account-archivist, trend-analyst, communications-analyst, budget-advisor, research-analyst, growth-architect) in a single parallel message, followed by serial evidence-arbiter if a rule-override surfaces.
- **Status:** ✅ Done — v1.25.0 (pending release)

---

## Status

| # | Item | Type | Priority | Status |
|---|------|------|----------|--------|
| 1 | bidding-strategies.md contradiction | Fix | High | ✅ Done (v1.13.0) |
| 2 | feed-only-pmax.md steps 12-14 | Fix | High | ✅ Done (v1.13.0) |
| 3 | common-mistakes.md #20 too vague | Fix | Medium | ✅ Done (v1.13.0) |
| 4 | learning-phase.md reference | New file | High | ✅ Done (v1.13.0) |
| 5 | shopping_performance_view queries | Gap fill | High | ✅ Done (v1.15.0) |
| 6 | Post-launch playbook | New file | High | ✅ Done (v1.15.0) |
| 7 | Learning duration table | Clarity | Medium | ✅ Done (v1.13.0) |
| 8 | Automated post-launch checks | Future | Medium | ✅ Done (v1.18.0) |
| 9 | Product-level performance skill | Future | High | ✅ Done (v1.20.0) |
| 10 | iClosed tracking patterns | New Capability | Medium | ✅ Done (v1.25.0 pending) — routing edge added; content lives in n8n-plugin |
| 11 | Meta Ads to BigQuery pipeline | Gap | Medium | ✅ Done (v1.25.0 pending) — routing edge added; content lives in n8n-plugin |
| 12 | n8n as automation layer in tracking stacks | New Capability | Medium | ✅ Done (v1.25.0 pending) — routing edge added; content lives in n8n-plugin |
| 13 | Cross-platform data model for BigQuery | Gap | Low | ✅ Done (v1.25.0 pending) — routing edge added; content lives in n8n-plugin |
| 20 | n8n-plugin prerequisite for v1.21.0 | Prerequisite | Critical | ✅ Done (v1.23.0) — n8n-workflow-builder-plugin v0.1.0 shipped |
| 14 | BigQuery pipeline expansion — native connections + n8n reverse path | Gap | High | ✅ Done (v1.25.0 pending) — reverse path in n8n-plugin bq-to-capi-offline.md; routing edge added |
| 15 | Email marketing knowledge — Klaviyo | Gap | Medium | ✅ Done (v1.22.0) |
| 16 | Looker Studio dashboards from BigQuery | Gap | Medium | ✅ Done (v1.22.0) |
| 17 | GTM scripts review — cookie collection cHTML (Watermelon) | New Capability | Medium | ⬜ Open |
| 18 | Watermelon plan knowledge extraction | New Capability | High | ⬜ Open |
| 19 | Shopping performance regression diagnostic protocol | Gap | High | ✅ Done (v1.21.1) — doc shipped v1.21.0; post-launch-monitor routing wired v1.21.1 |
| 21 | ClickFunnels 2.0 tracking patterns | Gap | Medium | ⬜ Open — deferred: CF2.0 event names unverified |
| 16 | Looker Studio dashboards (updated: +lead gen pattern + repos) | Gap | Medium | ✅ Done (v1.22.0) |
| 22 | Feed-only PMax AD STRENGTH = POOR incorrectly flagged (7 files) | Contradiction | High | ✅ Done (v1.21.1) — exception clause added to 8 files |
| 23 | No structured growth/scaling management skill | Gap | High | ✅ Done (v1.23.0) |
| 24 | tROAS/tCPA transition gates not surfaced in post-launch-monitor | Gap | High | ✅ Done (v1.25.0 pending) |
| 25 | Negative keyword write tools missing from MCP server | Gap | High | ⬜ Open |
| 26 | Attribution-aware reporting missing from live-report (all_conversions) | Gap | Medium | ⬜ Open |
| 27 | Ad copy and asset mutation not possible via MCP | Gap | Medium | ⬜ Open |
| 28 | No guard rail against aspirational projections in client communication | Gap | Medium | ✅ Done (v1.23.0) |
| 29 | MCP docs error — user_list sizes are API-accessible, not manual-only | Contradiction | Medium | ⬜ Open |
| 30 | MCP server read capability expansion — compatibility validation needed | Dependency | Medium | ⬜ Open — pending MCP server update |
| 31 | Pending n8n cross-plugin routing edges — commit with next release | Ecosystem | Low | ✅ Done (v1.23.0) — `46e22ee` |
| 32 | Reference doc: lift-budget-freeze.md | New file | High | ✅ Done (v1.25.0 pending) — lift-budget-freeze.md created + 3 cross-links |
| 33 | War-council: plan-mode guard + full-dispatch enforcement | Contradiction | High | ✅ Done (v1.25.0 pending) |
