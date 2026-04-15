---
title: Backlog Expansion Design — v1.20.0–v1.21.0
date: 2026-04-14
tags: [design, spec, backlog, cross-platform, tracking-bridge, product-performance]
status: draft
version: 1.0.0
---

# Backlog Expansion Design — v1.20.0–v1.21.0

## Context

Eight open backlog items remain after the v1.13–v1.19 gap fill. Three are stale (already delivered but not marked Done: #5, #6, #8). The remaining five require new content — one within existing Google Ads scope (#9), four expanding the tracking-bridge and reporting layers into cross-platform territory (#10, #11, #12, #13).

Items #10–#13 were auto-filed from the **WinstArchitect / Next Chapter** client project (2026-04-13), where iClosed scheduling, n8n automation, Meta CAPI, and BigQuery normalization were designed as a real tracking stack. The knowledge exists now and must be captured before it decays.

**Drivers:**
- #9 — Product-level performance skill was the highest-priority "Future Capability" from the original backlog
- #10 — iClosed attribution is needed for active client work (WinstArchitect)
- #12 — n8n is the bridge layer between 3rd-party tools and CRMs/BigQuery
- #11 — Meta Ads BigQuery pipeline completes the reporting layer for multi-platform clients
- #13 — Cross-platform data model needs iClosed/Airtable join keys and lifecycle stages

---

## Problem Statement

1. **Stale backlog**: Items #5, #6, #8 are marked Open but were delivered in v1.15.0–v1.18.0. Status table is misleading.
2. **No product-level skill**: Shopping GAQL queries exist (v1.15.0) but no interactive skill wraps them. E-commerce accounts can't get zombie product identification or feed optimization guidance.
3. **Tracking-bridge is Google Ads-only**: All 6 files terminate at Google Ads. No coverage of iClosed webhooks, n8n pipeline patterns, or Meta CAPI — despite these being core to modern tracking stacks.
4. **Reporting layer has no Meta pipeline**: `cross-platform-data-model.md` has Meta schema mappings but no guidance on how to get Meta data into BigQuery.
5. **Cross-platform data model is incomplete**: Missing iClosed join keys, lead lifecycle stages, `fbc` reconstruction, and the 5-source architecture pattern.

---

## Approach

**Two versioned releases** following the proven v1.13–v1.19 pattern:

| Release | Name | Scope |
|---------|------|-------|
| v1.20.0 | Housekeeping + Product Performance | Fix stale statuses, build #9 skill |
| v1.21.0 | Cross-Platform Tracking Expansion | #10 iClosed, #11 Meta BQ, #12 n8n, #13 data model |

**Multi-session execution** with dedicated online research per subject before writing any content.

---

## Section 1: Stale Backlog Cleanup

Three items need status updates in `BACKLOG.md`:

| # | Item | Delivered In | Evidence |
|---|------|-------------|----------|
| 5 | `shopping_performance_view` queries | v1.15.0 | 4 queries in `gaql-query-templates.md` |
| 6 | Post-launch playbook | v1.15.0 | `strategy/post-launch-playbook.md` exists |
| 8 | Automated post-launch checks | v1.18.0 | `skills/post-launch-monitor/SKILL.md` exists |

**Action:** Update status table entries to `✅ Done (v1.15.0)` / `✅ Done (v1.18.0)`.

---

## Section 2: #9 — Product-Level Performance Skill (v1.20.0)

### New file

`skills/product-performance/SKILL.md`

### Content scope

Interactive skill that wraps the 4 existing `shopping_performance_view` GAQL queries into guided product-level analysis:

1. **Context gathering**: Account type (Shopping, PMax feed-only, both), date range, revenue threshold
2. **Data pull via MCP**: Top products by revenue, zombie products (spend + zero conversions), brand vs. category breakdown, low-CTR feed candidates
3. **Analysis**: Identify zombie products costing money, top converters driving revenue, feed optimization candidates (high impressions, low CTR)
4. **Recommendations**: Exclude zombies (negative product targets or feed suppression), reallocate budget to top converters, feed attribute improvements for low-CTR products

### References loaded

- `reference/platforms/google-ads/shopping-campaigns.md`
- `reference/platforms/google-ads/pmax/feed-only-pmax.md`
- `reference/platforms/google-ads/pmax/feed-optimization.md`
- `reference/platforms/google-ads/shopping-feed-strategy.md`
- `reference/reporting/gaql-query-templates.md` (Shopping section)
- `reference/mcp/mcp-capabilities.md`

### Report output

- Stage: `05-optimize`
- SUMMARY.md section: Optimization & Reporting
- Follows 6-step write sequence per `_config/conventions.md`

### Research needed (Session 2)

- Google Ads `shopping_performance_view` resource documentation — confirm all available fields and segments
- Best practices for zombie product identification thresholds (impressions, clicks, cost)
- Feed optimization signals: which product attributes most impact CTR
- Product-level bidding strategies in PMax vs. Standard Shopping

---

## Section 3: #10 — iClosed Tracking Patterns (v1.21.0)

### New file

`reference/tracking-bridge/iclosed-attribution.md`

### Content scope

Reference document covering the full iClosed tracking and attribution pipeline:

1. **GTM URL param injection**: iClosed 2-Step Scheduler URL param injector Custom HTML tag on Thank You page. Scenario A (single container, events on parent dataLayer) vs Scenario B (dedicated iClosed container)
2. **Webhook event mapping**: 7 real iClosed API events — `newContactCreated`, `contactDetailChanged`, `contactByStatus`, `newCallScheduled`, `callCancelled`, `callRescheduled`, `callOutcome`. Each with payload structure and tracking use case
3. **fbclid passthrough**: Via webhook `tracking` object using `utmKey_N`/`utmValue_N` key-value pairs (confirmed in iClosed developer docs)
4. **callOutcome attribution gap**: `callOutcome` webhook has no `tracking` data — fbclid must be retrieved from CRM via `contactId` correlation. Documented as a known limitation with workaround
5. **Consent gating**: `cookie_consent_marketing` trigger, Consent Mode v2 defaults denied pattern
6. **GTM dataLayer events**: `iclosed_view`, `iclosed_qualified`, etc. — marked as **UNVERIFIED** (not in developer docs, observed empirically)

### Research needed (Session 3)

- iClosed developer documentation — full webhook payload schemas, API authentication
- iClosed 2-Step Scheduler embedding documentation — URL param injection methods
- Consent Mode v2 interaction with iframe-embedded scheduling tools
- Similar patterns from Calendly GTM tracking (project 0002) for comparison

---

## Section 4: #12 — n8n Pipeline Patterns (v1.21.0)

### New file

`reference/tracking-bridge/n8n-pipeline-patterns.md`

### Content scope

Reference document covering n8n as the automation bridge layer in tracking stacks. Scoped to tracking pipelines only — full n8n workflow automation deferred to future `n8n-plugin`.

1. **4-workflow pattern** for high-ticket coaching funnels:
   - WF1: Booking → CRM (`newCallScheduled` → Airtable)
   - WF2: Outcome → CRM (`callOutcome` → Airtable update)
   - WF3: CRM → CAPI (Airtable fbclid → Meta CAPI Purchase, `action_source: system_generated`)
   - WF4: Events → BigQuery (all webhooks → BigQuery raw log)
2. **Webhook security**: URL-based secret token only (no HMAC available from iClosed, on their roadmap). Security implications documented
3. **n8n node reference**: `n8n-nodes-base.webhook`, `n8n-nodes-base.airtable`, `n8n-nodes-base.httpRequest`, `n8n-nodes-base.googlebigquery`
4. **Meta CAPI via n8n**: `action_source: system_generated` requirement, `fbc` construction, event deduplication via `event_id` = `callPreviewId`
5. **Pricing and setup**: n8n Cloud Starter EUR 24/mo, unlimited users, client-owned account

### Boundary note

This file documents n8n patterns **as they relate to tracking attribution pipelines**. General n8n workflow automation, API integration patterns, and agent pipelines remain scoped to the future `n8n-plugin` (see `_config/ecosystem.md`).

### Research needed (Session 3)

- n8n node documentation for BigQuery, Airtable, webhook, HTTP Request nodes
- Meta Conversions API server event requirements (`action_source` values, required fields)
- n8n webhook security best practices — alternatives to URL token auth
- n8n Cloud pricing tiers and limitations (execution limits, retention)

---

## Section 5: #11 — Meta Ads to BigQuery Pipeline (v1.21.0)

### New file

`reference/reporting/meta-ads-bigquery.md`

### Content scope

Three pipeline approaches for getting Meta Ads data into BigQuery, with decision guidance:

1. **BigQuery Data Transfer Service** (recommended starting point): Native Google connector, 24h refresh cycle, zero maintenance, free. Schema for `meta_ads_performance` table. Limitations: daily granularity only, limited field set
2. **OWOX Data Marts**: `OWOX/owox-data-marts` (MIT license, open source). Upgrade path for sub-daily granularity. Self-hosted, requires setup
3. **n8n HTTP Request to Meta Marketing API**: Real-time data via scheduled n8n workflow. Most flexible but most maintenance. Cross-reference to `n8n-pipeline-patterns.md`

Decision matrix: start with Data Transfer Service → upgrade to OWOX if sub-daily granularity needed → use n8n only if real-time or custom field requirements

### Research needed (Session 4)

- BigQuery Data Transfer Service for Meta/Facebook — current connector capabilities, field coverage, setup steps
- OWOX Data Marts GitHub repo — architecture, supported metrics, setup complexity
- Meta Marketing API — available fields, rate limits, reporting endpoints
- Comparison of all three approaches: cost, latency, field coverage, maintenance burden

---

## Section 6: #13 — Cross-Platform Data Model Expansion (v1.21.0)

### Modified file

`reference/reporting/cross-platform-data-model.md` (extend, not replace)

### New content to add

1. **5-source architecture table**: GA4 (native BQ export, daily), Meta Ads (BigQuery Data Transfer Service, 24h), iClosed (n8n webhook → BQ node, real-time), Airtable (n8n Airtable Trigger → BQ node, polling 5–15min), sGTM (sGTM BQ tag, streaming)
2. **Join key strategy**: `contactId` as cross-system key (iClosed ↔ Airtable ↔ CAPI events), `callPreviewId` as CAPI `event_id` for deduplication
3. **Lead lifecycle stages**: Lead → MQL → Booked → SQL → Closed — mapped across iClosed, Airtable, and Meta CAPI event names
4. **`fbc` reconstruction**: Formula `fb.1.{bookingTime_unix}.{fbclid}` for constructing Meta click identifier from stored fbclid

### Research needed (Session 4)

- Meta CAPI `fbc` parameter specification — construction rules, validation
- BigQuery best practices for multi-source join tables with different refresh cadences
- Lead lifecycle stage naming conventions across CRM platforms

---

## Section 7: Root File Updates

### CLAUDE.md

Relax the "Google Ads only" permanent rule to acknowledge tracking-bridge scope expansion:

> **Google Ads campaign management only.** The tracking-bridge layer extends to cross-platform attribution pipelines (iClosed, n8n, Meta CAPI) because tracking infrastructure is platform-agnostic. Skills and agents remain Google Ads-focused. Architecture supports multi-platform reference docs via `reference/platforms/` but only `google-ads/` has operational skills.

### CONTEXT.md

Add routing entries:
- Product performance → `skills/product-performance/SKILL.md`
- iClosed tracking → `reference/tracking-bridge/iclosed-attribution.md`
- n8n pipelines → `reference/tracking-bridge/n8n-pipeline-patterns.md`
- Meta Ads reporting → `reference/reporting/meta-ads-bigquery.md`

### ecosystem.md

Update n8n-plugin status to note that tracking-bridge patterns are captured in this plugin.

### BACKLOG.md

Update all status entries. Items #5, #6, #8 marked Done retroactively. Items #9–#13 marked Done as releases ship.

### PLAN.md

Add v1.20.0 and v1.21.0 sections with checklist items.

### PRIMER.md

Rewrite at end of each session with current state and next steps.

### CHANGELOG.md

Add v1.20.0 and v1.21.0 entries as releases ship.

---

## Section 8: Multi-Session Plan

| Session | Focus | Research Topics | Deliverables |
|---------|-------|-----------------|--------------|
| 1 (this session) | Planning + housekeeping | None | This design doc, stale status fixes, PLAN.md/PRIMER.md updates |
| 2 | #9 Product Performance | `shopping_performance_view` fields, zombie thresholds, feed optimization signals | `skills/product-performance/SKILL.md`, CONTEXT.md routing, v1.20.0 release |
| 3 | #10 iClosed + #12 n8n | iClosed dev docs, n8n nodes, Meta CAPI requirements, webhook security | `iclosed-attribution.md`, `n8n-pipeline-patterns.md` |
| 4 | #11 Meta BQ + #13 Data Model | BQ Data Transfer Service, OWOX, Meta Marketing API, join patterns | `meta-ads-bigquery.md`, extend `cross-platform-data-model.md` |
| 5 | Integration + release | None (all research done) | CONTEXT.md, CLAUDE.md, ecosystem.md, v1.21.0 release |

### Per-session protocol

1. Read PRIMER.md for handoff context
2. Execute research (online) — save findings in research notes section of this spec
3. Write content based on research + backlog item description
4. Update PLAN.md (check off items), BACKLOG.md (status), PRIMER.md (rewrite)
5. Commit with version tag

---

## Section 9: Verification

### v1.20.0 verification
- [ ] BACKLOG.md status table: #5, #6, #8 show `✅ Done`
- [ ] `skills/product-performance/SKILL.md` exists with interactive flow, MCP queries, report output section
- [ ] CONTEXT.md routes "product performance" to the new skill
- [ ] Skill loads correct reference files (shopping, feed, GAQL)
- [ ] Dry-run: invoke skill in conversation, verify it asks about account type and produces analysis

### v1.21.0 verification
- [ ] `reference/tracking-bridge/iclosed-attribution.md` exists with all 7 webhook events, fbclid passthrough, consent gating
- [ ] `reference/tracking-bridge/n8n-pipeline-patterns.md` exists with 4-workflow pattern, scoped to tracking only
- [ ] `reference/reporting/meta-ads-bigquery.md` exists with 3 pipeline approaches and decision matrix
- [ ] `cross-platform-data-model.md` extended with 5-source architecture, join keys, lifecycle stages
- [ ] CONTEXT.md routes all 4 new topics correctly
- [ ] CLAUDE.md permanent rule updated to acknowledge tracking-bridge scope
- [ ] ecosystem.md updated with n8n-plugin note
- [ ] No skills or agents reference Meta/iClosed/n8n as if operational skills exist (they don't — reference only)

---

## Appendix: Research Findings

%%
This section grows across sessions. Each research session appends its findings here before writing content.
%%

### Session 2 Research: Product Performance

**Date:** 2026-04-14
**Sources:** Google Ads API v20 docs, industry PPC publications (JumpFly, BigFlare, PPC Panos, FeedOps)

#### shopping_performance_view — Additional Fields (beyond current GAQL templates)

Current templates already use: `product_item_id`, `product_title`, `product_brand`, `product_category_level1/2`, `impressions`, `clicks`, `cost_micros`, `conversions`, `conversions_value`, `ctr`.

**Additional segments not yet in templates (useful for advanced analysis):**
- `segments.product_custom_attribute0` through `segments.product_custom_attribute4` — Merchant Center custom labels (margin tier, season, promo status)
- `segments.product_type_level1` through `segments.product_type_level5` — seller-defined product type hierarchy (more granular than Google categories)
- `segments.product_condition` — new / used / refurbished

**Additional metrics not yet in templates:**
- `metrics.gross_profit_micros` — available for retailers with cart data / Merchant Center cart integration
- `metrics.units_sold` — units sold per product
- `metrics.average_cart_size` — average number of items per order
- `metrics.search_budget_lost_impression_share` / `metrics.search_rank_lost_impression_share` — competitive/budget health signals

**Critical restriction:** `segments.date` CANNOT appear in SELECT (causes `UNSUPPORTED_DATE_SEGMENTATION` error). Use only in WHERE clause (`WHERE segments.date DURING LAST_30_DAYS`). Current templates are correct.

**shopping_product vs shopping_performance_view distinction:** `shopping_product` shows current state of products (including disapprovals, issues, feed errors) and is recommended for diagnosing why a product isn't serving. `shopping_performance_view` shows historical performance data for products that have served ads. Both are complementary.

#### Zombie Product Thresholds

**Industry consensus (no official Google mandated threshold):**
- **30 days** — standard window for active accounts with consistent traffic
- **90 days** — for seasonal products or low-volume accounts (avoids false positives)
- **Zero conversions + non-zero spend** = conversion zombie (product gets traffic but doesn't convert)
- **Zero impressions + zero clicks** = invisible zombie (product not surfacing at all — feed issue more likely than bidding)

**Recommended thresholds for the skill:**
- Primary zombie filter: `cost_micros > 0 AND conversions = 0` over LAST_30_DAYS
- Severity tiering: `cost_micros > 10,000,000` (> ~$10 spend) = high-priority zombie; lower spend = monitor
- Before excluding: check if product is seasonal (extend window to 90 days) or new (within 14-day data lag)
- PMax context: zombies in PMax are expected — PMax allocates ~80% of budget to "hero" products; low-visibility products may simply not have received budget, not necessarily feed issues

#### Feed Optimization Signals (CTR Impact)

**Ranked by impact on CTR:**
1. **Product title** — highest impact. 20-40% CTR uplift from optimization. Rules:
   - Front-load most important term (first 70 chars shown in ad)
   - Structure: Brand + Product Type + Key Attributes (color, size, material)
   - Include primary search terms; avoid keyword stuffing
2. **GTINs** — 20% average click increase when correct GTINs provided. Unlocks price comparison eligibility and additional Shopping features
3. **Images** — white/light background, high resolution, product fills 75-90% of frame. No watermarks, text, or promotional overlays
4. **Pricing competitiveness** — affects both CTR and conversion rate; high impression/low CTR often signals pricing is uncompetitive vs. listed alternatives
5. **Product type specificity** — more specific product type → better query matching → higher relevance → higher CTR
6. **Custom labels** — enable smart bidding and analysis segmentation (e.g., label by margin tier to catch low-margin zombie spend)

#### PMax vs Standard Shopping — Product-Level Control

| Aspect | Standard Shopping | Performance Max |
|--------|------------------|-----------------|
| Bidding options | Manual CPC, Max Clicks, Target ROAS | Smart Bidding only (Max Conv / Max Conv Value + optional tCPA/tROAS) |
| Per-product bids | Yes — product groups with manual CPC targets | No — AI controls all bids; no per-product levers |
| Product group structure | Up to 20,000 ad groups, 5-level product group hierarchy | Asset group listing groups (same hierarchy concept, different UI) |
| Budget allocation by product | Indirect via campaign/ad group structure | No — Google AI decides allocation; hero products absorb most budget |
| Zombie exclusion method | Negative product target (direct exclusion) | Listing group exclusion or remove from feed entirely |
| Impression share visibility | Yes — full search IS data | Limited — no direct IS reporting per product |

**Key insight for skill:** The zombie exclusion recommendation must differ by campaign type. Standard Shopping: add as negative product target in the ad group. PMax: either exclude via listing group edit, or suppress in Merchant Center feed using `excluded_destination`. Feed suppression affects all campaigns — use listing group exclusion if PMax-only exclusion is intended.

### Session 3 Research: iClosed + n8n

**Date:** 2026-04-14
**Sources:** iClosed Help Center (docs.iclosed.io), Zapier iClosed integration page, Meta CAPI developer docs, n8n documentation (docs.n8n.io), n8n pricing page

---

#### iClosed Webhook Events

From Zapier integration page (these are all available iClosed trigger events — all are "Instant" triggers):

| Zapier Trigger Name | Description | Tracking Relevance |
|---------------------|-------------|-------------------|
| Call Booked | Triggers when a new call is scheduled | Primary — booking confirmation |
| Call Cancelled | Triggers when cancelled by invitee or closer | Attribution hygiene |
| Call Rescheduled | Triggers when upcoming call rescheduled | Attribution hygiene |
| Call Outcome | Triggers when outcome of a call is added | Offline conversion trigger |
| Contact by Status | Triggers when contact status changes on scheduler journey | Lead stage tracking |
| Contact Updated | Triggers when a contact is updated | CRM sync |
| Contact Custom Field Updated | Triggers when a contact custom field is updated | CRM sync |
| Appointment Setting Outcome | Triggers when appointment setting outcome is added | SDR workflow |
| Setter Owner Assigned | Triggers when setter owner assigned to contact | Team attribution |
| Note Added | Triggers when a note is added | Low value for tracking |
| Data Intelligence | Triggers when email/phone validated or credit score calculated | Lead quality signal |
| Transaction Synced | Triggers when a transaction is synced with a Deal | Revenue attribution |

**For tracking attribution pipelines, the key events are:** Call Booked, Call Cancelled, Call Rescheduled, Call Outcome, Contact by Status.

Note: The design spec mentioned 7 "API events" with names like `newContactCreated`. These appear to be the internal API event names. The Zapier trigger names above are the public-facing names — actual webhook payload field names require direct API testing or contact with iClosed.

---

#### iClosed GTM DataLayer Events

From iClosed's own GTM documentation (docs.iclosed.io/en/articles/10420617-google-tag-manager) — these are **confirmed**, not unverified:

| Event Name | Trigger Condition |
|------------|------------------|
| `iclosed_view` | Page view / scheduler loaded |
| `iclosed_potential` | Visitor enters email + phone on form |
| `iclosed_qualified` | Completes full form without booking |
| `iclosed_disqualified` | Does not meet qualification criteria |
| `iclosed_call_scheduled` | Call booked — primary conversion event |

**Important:** If both email and phone are included on the event form, `iclosed_potential` fires **twice** (once for email, once for phone). For Meta optimization, use `iclosed_qualified` or `iclosed_call_scheduled` — do not optimize for `iclosed_potential`.

---

#### iClosed Native Meta CAPI Integration

iClosed has a **built-in server-side Meta CAPI integration** (as of 2025). This is important context for the n8n approach:

- **Sends:** contactId (sha256-hashed as `external_id`), email (sha256), phone (sha256), `client_user_agent`, `client_ip_address`, `event_id`
- **Auto-captures:** `fbc` and `fbp` from browser cookies — no hidden fields needed
- **Events sent:** Page view, Potential, Qualified, Disqualified, Call booked (`invitee_meeting_scheduled`)
- **Deduplication:** Implemented per Meta best practices when both Pixel and CAPI are active

**Why use n8n instead of native CAPI:** The n8n approach gives control over custom events (e.g., Purchase after outcome), allows using `callPreviewId` as `event_id` for reliable deduplication, and enables routing data to BigQuery simultaneously.

---

#### iClosed Embedding

- Widget script: `https://app.iclosed.io/assets/widget.js`
- Embed types: inline (loads directly on page) or popup (dialog on element click)
- Popup data attributes: `data-iclosed-link="[SCHEDULER_URL]"`, `data-embed-type="popup"`
- **Official warning:** Do not modify embed code — may break scheduler
- UTM parameters: Standard UTMs (source, medium, campaign, term, content) auto-captured if present in URL
- `utmKey_N`/`utmValue_N` tracking object format: Not publicly documented — appears to be internal webhook payload structure for custom UTM pairs (observed empirically in WinstArchitect project, treat as potentially unstable)

---

#### n8n Webhook Node Security

Authentication methods available for n8n webhook endpoints:

| Method | How it works | n8n Support |
|--------|-------------|-------------|
| Basic Auth | Username + password via HTTP headers | Native (built-in) |
| Header Auth | Custom header name + secret value (e.g., `X-N8N-Auth: secret`) | Native (built-in) |
| JWT Auth | JSON Web Token verification | Native (built-in) |
| IP Whitelist | Restrict to specific sender IP addresses | Native (built-in) |
| HMAC signature | Cryptographic request signing | Manual (implement in workflow code) |

**iClosed webhook security limitation:** iClosed does not support HMAC signing as of 2025 (on their roadmap). URL-based secret tokens (via Header Auth) are the practical choice. Mitigation: use Header Auth + IP whitelist if iClosed publishes their outbound IPs.

---

#### n8n Airtable Node

- Node: `n8n-nodes-base.airtabletrigger`
- Type: **Polling** (not a native webhook from Airtable)
- Polling interval: Configurable — every minute, hour, day, week, month, or custom cron
- Detection: Uses created or last-modified field to determine what changed since last check
- **Important cost implication:** 5-minute polling = ~8,640 executions/month. This exceeds the Starter plan limit of 2,500/month. For high-frequency polling, Pro plan (€50/mo) is needed or use less frequent polling (15-min = ~2,880 executions/month — still over Starter).

---

#### n8n Google BigQuery Node

- Node: `n8n-nodes-base.googlebigquery`
- Operations: Insert rows, Run query
- Credentials: Google OAuth2 or Service Account
- Use case in WF4 (Events → BigQuery): Insert rows for each webhook event received

---

#### n8n Pricing (2026)

| Plan | Price (annual) | Executions/month | Concurrent | Notes |
|------|---------------|-----------------|------------|-------|
| Starter | €20/mo | 2,500 | 5 | Suitable only if workflows run infrequently |
| Pro | €50/mo | 25,000 saved | 20 | Sufficient for most tracking pipelines |
| Business | €667/mo | 40,000 | 30 | Includes self-hosted option |

**Recommendation for client accounts:** n8n Cloud Pro at €50/mo — client-owned account, unlimited users. Starter (€20/mo) insufficient if Airtable polling runs every 5-15 minutes.

---

#### Meta CAPI — `action_source` Values

| Value | Use Case |
|-------|----------|
| `website` | Conversion occurred on website (with browser context) |
| `system_generated` | Automatic conversion — no user present (subscription renewals, outcome-triggered events) |
| `email` | Conversion via email |
| `app` | Conversion in mobile app |
| `phone_call` | Conversion by phone |
| `chat` | Conversion via messaging |
| `physical_store` | In-person conversion |
| `business_messaging` | Click-to-Messenger/Instagram/WhatsApp ads |

**For n8n-triggered purchase events after call outcome:** Use `system_generated` — no user session present, event triggered by CRM data.

---

#### Meta CAPI — `fbc` Parameter Construction

Format: `fb.{version}.{subdomainIndex}.{creationTime_ms}.{fbclid}`

- `version` = always `1`
- `subdomainIndex` = 1 for `example.com`, 2 for `www.example.com`, 0 for `.com`
- `creationTime_ms` = Unix timestamp in **milliseconds** when fbclid was first captured (landing time, NOT booking time)
- `fbclid` = raw fbclid value from URL parameter

Example: `fb.1.1.1554763741205.AbCdEfGhIjKlMnOpQrStUvWxYz1234567890`

**Important:** Do NOT hash fbc — send as plain string. Store `creationTime_ms` at landing time alongside fbclid.

---

#### Meta CAPI — Event Deduplication

- Deduplication key: `event_name` + `event_id` (case-sensitive, whitespace-sensitive)
- Window: 48 hours
- Priority: Browser/Pixel events take priority if they arrive ~5 minutes before server events
- Best practice: Use `callPreviewId` as `event_id` for iClosed call booking events — unique per call

### Session 4 Research: Meta BQ + Cross-Platform
_To be completed in Session 4_
