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
- **Status:** Open

### 13. [AUTO] Cross-Platform Data Model for BigQuery

- **Source project:** 0014 - Client WinstArchitect - subclient Next Chapter
- **Date found:** 2026-04-13
- **Affected file:** `reference/reporting/` (BigQuery architecture referenced but no cross-platform normalization guidance)
- **Category:** Gap
- **Description:** Meta + GA4 + iClosed + Airtable normalization in BigQuery. 5-source architecture: GA4 (native BQ export, daily), Meta Ads (BigQuery Data Transfer Service, 24h), iClosed (n8n webhook -> BQ node, real-time), Airtable (n8n Airtable Trigger -> BQ node, polling 5-15min), sGTM (sGTM BQ tag, streaming). Key join fields: `contactId` as cross-system key linking iClosed records to Airtable to CAPI events. `callPreviewId` as CAPI `event_id` for deduplication. Lead lifecycle stages (Lead/MQL/Booked/SQL/Closed) mapped across tools and tables. `fbc` reconstruction from stored fbclid: `fb.1.{bookingTime_unix}.{fbclid}`.
- **Proposed fix:** Add a `reference/reporting/cross-platform-data-model.md` file covering join key strategy, table schemas, and lifecycle stage mapping for high-ticket funnel stacks.
- **Status:** Open

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
- **Status:** Open

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
- **Status:** Open

### 12. [AUTO] n8n as Automation Layer in Tracking Stacks

- **Source project:** 0014 - Client WinstArchitect - subclient Next Chapter
- **Date found:** 2026-04-13
- **Affected file:** Unknown (new platform domain — no n8n coverage exists)
- **Category:** New Capability
- **Description:** n8n replaces Zapier/Make in tracking stacks. n8n Cloud Starter: EUR 24/mo, unlimited users, client-owned account. Webhook security: URL-based secret token only (no HMAC available from iClosed, on their roadmap). 4-workflow pattern for high-ticket coaching funnels: WF1 booking-to-CRM (`newCallScheduled` -> Airtable), WF2 outcome-to-CRM (`callOutcome` -> Airtable update), WF3 CRM-to-CAPI (Airtable fbclid -> Meta CAPI Purchase, `action_source: system_generated`), WF4 events-to-BigQuery (all webhooks -> BigQuery raw log). n8n nodes used: `n8n-nodes-base.webhook`, `n8n-nodes-base.airtable`, `n8n-nodes-base.httpRequest`, `n8n-nodes-base.googlebigquery`.
- **Proposed fix:** TBD
- **Status:** Open

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
| 10 | iClosed tracking patterns | New Capability | Medium | 🚧 Paused — v1.21.0 blocked on n8n-plugin |
| 11 | Meta Ads to BigQuery pipeline | Gap | Medium | 🚧 Paused — v1.21.0 blocked on n8n-plugin |
| 12 | n8n as automation layer in tracking stacks | New Capability | Medium | 🚧 Paused — n8n-plugin must be built first |
| 13 | Cross-platform data model for BigQuery | Gap | Low | 🚧 Paused — v1.21.0 blocked on n8n-plugin |
| 20 | n8n-plugin prerequisite for v1.21.0 | Prerequisite | Critical | 🚧 In progress — build n8n-plugin, then resume Session 4 |
| 14 | BigQuery pipeline expansion — native connections + BQ→Meta n8n | Gap | High | ⬜ Open |
| 15 | Email marketing knowledge — Klaviyo | Gap | Medium | ⬜ Open |
| 16 | Looker Studio dashboards from BigQuery | Gap | Medium | ⬜ Open |
| 17 | GTM scripts review — cookie collection cHTML (Watermelon) | New Capability | Medium | ⬜ Open |
| 18 | Watermelon plan knowledge extraction | New Capability | High | ⬜ Open |
| 19 | Shopping performance regression diagnostic protocol | Gap | High | ✅ Done (v1.21.1) — doc shipped v1.21.0; post-launch-monitor routing wired v1.21.1 |
| 21 | ClickFunnels 2.0 tracking patterns | Gap | Medium | ⬜ Open — deferred: CF2.0 event names unverified |
| 14 | BigQuery pipeline expansion (updated: +8 reference repos) | Gap | High | 🚧 In progress — native connectors doc drafted (v1.22.0 seed); n8n reverse path deferred |
| 16 | Looker Studio dashboards (updated: +lead gen pattern + repos) | Gap | Medium | ⬜ Open |
| 22 | Feed-only PMax AD STRENGTH = POOR incorrectly flagged (7 files) | Contradiction | High | ✅ Done (v1.21.1) — exception clause added to 8 files |
