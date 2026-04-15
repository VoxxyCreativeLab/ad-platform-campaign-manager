# Backlog Expansion v1.20.0–v1.21.0 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deliver 5 backlog items across 2 releases — #9 product performance skill (v1.20.0), plus iClosed/n8n/Meta/cross-platform reference docs (v1.21.0).

**Architecture:** Reference-first knowledge plugin. New content follows existing patterns: skills use SKILL.md frontmatter (`name`, `description`, `argument-hint`), reference docs use Obsidian frontmatter (`title`, `date`, `tags`). All content is markdown — no executable code. Skills reference docs via `[[wikilink]]` syntax and load MCP queries from `gaql-query-templates.md`.

**Tech Stack:** Markdown (Obsidian-flavored), GAQL queries, MCP tool references, git.

**Design spec:** `docs/superpowers/specs/2026-04-14-backlog-expansion-design.md`

---

## File Map

### New files

| File | Responsibility | Session |
|------|---------------|---------|
| `skills/product-performance/SKILL.md` | Interactive skill wrapping shopping GAQL queries | 2 |
| `reference/tracking-bridge/iclosed-attribution.md` | iClosed webhook schemas, GTM injection, fbclid passthrough | 3 |
| `reference/tracking-bridge/n8n-pipeline-patterns.md` | n8n as tracking pipeline bridge (4-workflow pattern) | 3 |
| `reference/reporting/meta-ads-bigquery.md` | 3 approaches for Meta Ads → BigQuery | 4 |

### Modified files

| File | Change | Session |
|------|--------|---------|
| `BACKLOG.md` | Fix stale statuses #5, #6, #8 + update #9–#13 as completed | 1, 2, 5 |
| `PLAN.md` | Add v1.20.0 and v1.21.0 sections | 1, 5 |
| `PRIMER.md` | Rewrite at end of each session | 1–5 |
| `CONTEXT.md` | Add routing for product-performance, iClosed, n8n, Meta | 2, 5 |
| `CLAUDE.md` | Relax "Google Ads only" for tracking-bridge scope | 5 |
| `_config/ecosystem.md` | Add note to n8n-plugin that tracking patterns live here | 5 |
| `reference/reporting/cross-platform-data-model.md` | Add 5-source architecture, join keys, lifecycle stages | 4 |
| `CHANGELOG.md` | Add v1.20.0 and v1.21.0 entries | 2, 5 |

---

## Session 1: Planning + Housekeeping (this session)

### Task 1: Fix stale backlog statuses

**Files:**
- Modify: `BACKLOG.md` (status table, lines 167–181)

- [ ] **Step 1: Update #5 status**

In `BACKLOG.md`, find the status table row for item 5. Change:
```
| 5 | shopping_performance_view queries | Gap fill | High | ⬜ Open |
```
to:
```
| 5 | shopping_performance_view queries | Gap fill | High | ✅ Done (v1.15.0) |
```

- [ ] **Step 2: Update #6 status**

Change:
```
| 6 | Post-launch playbook | New file | High | ⬜ Open |
```
to:
```
| 6 | Post-launch playbook | New file | High | ✅ Done (v1.15.0) |
```

- [ ] **Step 3: Update #8 status**

Change:
```
| 8 | Automated post-launch checks | Future | Medium | ⬜ Design needed |
```
to:
```
| 8 | Automated post-launch checks | Future | Medium | ✅ Done (v1.18.0) |
```

- [ ] **Step 4: Verify status table**

Read `BACKLOG.md` status table. Confirm:
- Items 1–8 all show `✅ Done`
- Items 9–13 remain `⬜ Open`

### Task 2: Update PLAN.md with v1.20.0–v1.21.0 roadmap

**Files:**
- Modify: `PLAN.md` (add new section after "After v1.12.0" block, around line 190)

- [ ] **Step 1: Add release plan to PLAN.md**

Add the following section after the v1.13–v1.19 table in the "What still needs to happen" section:

```markdown
### After v1.19.1 — Backlog Expansion (v1.20.0–v1.21.0)

Planned 2026-04-14. Design spec at `docs/superpowers/specs/2026-04-14-backlog-expansion-design.md`. Implementation plan at `docs/superpowers/plans/2026-04-14-backlog-expansion.md`.

| Release | Name | Size | Status | Key Deliverable |
|---------|------|------|--------|-----------------|
| v1.20.0 | Housekeeping + Product Performance | M | ⬜ Not started | `product-performance` skill + stale status fixes |
| v1.21.0 | Cross-Platform Tracking Expansion | L | ⬜ Not started | iClosed, n8n, Meta BQ pipeline, data model expansion |
```

- [ ] **Step 2: Update "Current Focus" section**

Replace the `**Blockers:**` line in the Current Focus section with:

```markdown
**Current milestone:** Backlog Expansion v1.20.0–v1.21.0 — planning complete, Session 2 next
**Blockers:** OAuth client secret should be rotated.
```

- [ ] **Step 3: Verify PLAN.md**

Read PLAN.md. Confirm v1.20.0–v1.21.0 table is present and formatted correctly.

### Task 3: Rewrite PRIMER.md for session handoff

**Files:**
- Modify: `PRIMER.md` (full rewrite of session-specific sections)

- [ ] **Step 1: Update "Last Completed" section**

Replace the current "Last Completed" content with:

```markdown
## Last Completed

### Session 2026-04-14 (planning): Backlog Expansion Design

- **Design spec written:** `docs/superpowers/specs/2026-04-14-backlog-expansion-design.md` — covers all 5 open backlog items (#9, #10, #11, #12, #13) across 2 releases (v1.20.0, v1.21.0)
- **Implementation plan written:** `docs/superpowers/plans/2026-04-14-backlog-expansion.md` — 5-session breakdown with research phases
- **Stale backlog fixed:** Items #5, #6, #8 marked Done (were delivered in v1.15.0–v1.18.0 but never updated)
- **Architectural decision:** iClosed + n8n tracking patterns go in `reference/tracking-bridge/` (tracking-bridge scope expansion). Meta Ads goes in `reference/reporting/`. n8n stays as separate future plugin for full workflow automation.
```

- [ ] **Step 2: Update "Current State" section**

Update the Plugin table:

```markdown
### Plugin (ad-platform-campaign-manager) — v1.19.1

| Layer | Count | Notes |
|-------|-------|-------|
| Reference files | 46 | 20 core + 5 PMax + 4 audit + 12 strategy + 4 MCP + 1 repos catalog |
| Script docs | 17 | under `reference/scripts/` |
| Tracking-bridge docs | 6 | expanding to 8 in v1.21.0 (iClosed, n8n) |
| Reporting docs | 5 | expanding to 6 in v1.21.0 (Meta BQ pipeline) |
| Skills | 14 | expanding to 15 in v1.20.0 (product-performance) |
| Agents | 3 | campaign-reviewer, tracking-auditor, strategy-advisor |
| Audit areas | 21 | All Priority 1-3 complete |
```

- [ ] **Step 3: Update "What Still Needs to Happen" section**

Replace the current content with:

```markdown
## What Still Needs to Happen

### Next session (Session 2): Research + Build #9 Product Performance Skill
- **Online research:** `shopping_performance_view` fields, zombie product thresholds, feed optimization signals, product-level bidding in PMax vs Standard Shopping
- **Build:** `skills/product-performance/SKILL.md`
- **Wire:** CONTEXT.md routing entry
- **Release:** v1.20.0

### Session 3: Research iClosed (#10) + n8n (#12)
- **Online research:** iClosed developer docs (webhooks, API events), n8n nodes (BigQuery, Airtable, webhook), Meta CAPI requirements, webhook security
- **Write:** `reference/tracking-bridge/iclosed-attribution.md`, `reference/tracking-bridge/n8n-pipeline-patterns.md`

### Session 4: Research Meta BQ (#11) + Cross-Platform (#13)
- **Online research:** BigQuery Data Transfer Service for Meta, OWOX Data Marts, Meta Marketing API, join patterns
- **Write:** `reference/reporting/meta-ads-bigquery.md`, extend `reference/reporting/cross-platform-data-model.md`

### Session 5: Integration + Release
- Wire all new files into CONTEXT.md, CLAUDE.md, ecosystem.md
- v1.21.0 release

### Housekeeping (unchanged)
- **Rotate OAuth client secret** — exposed in session screenshot (2026-04-01)
- **Priority 4 audit:** DSA-specific, App Campaigns — niche, defer
- **Phase 4 Multi-platform:** meta-ads/, linkedin-ads/, tiktok-ads/ platform skills — no demand, defer
```

- [ ] **Step 4: Update "Design Documents" section**

Add the new design spec and plan:

```markdown
## Design Documents

- **Backlog expansion design:** `docs/superpowers/specs/2026-04-14-backlog-expansion-design.md`
- **Backlog expansion plan:** `docs/superpowers/plans/2026-04-14-backlog-expansion.md`
- **Backlog gap fill plan:** `docs/superpowers/plans/2026-04-08-backlog-gap-fill.md`
- **Report output structure spec:** `docs/superpowers/specs/2026-04-04-report-output-structure-design.md`
- **Phase 3 design spec:** `docs/superpowers/specs/2026-04-03-phase-3-strategy-agent-design.md`
```

- [ ] **Step 5: Verify PRIMER.md**

Read PRIMER.md. Confirm all sections updated, session handoff is clear for Session 2.

### Task 4: Commit Session 1

- [ ] **Step 1: Stage and commit**

```bash
git add BACKLOG.md PLAN.md PRIMER.md docs/superpowers/specs/2026-04-14-backlog-expansion-design.md docs/superpowers/plans/2026-04-14-backlog-expansion.md
git commit -m "plan: backlog expansion v1.20.0–v1.21.0 — design spec, implementation plan, stale status fixes"
```

---

## Session 2: Research + Build #9 Product Performance Skill

### Task 5: Online research — shopping_performance_view

- [ ] **Step 1: Research Google Ads shopping_performance_view**

Use WebSearch to research:
- Google Ads API `shopping_performance_view` resource — all available fields and segments
- Zombie product identification — industry thresholds for "wasted spend" (impressions without conversions)
- Feed optimization signals — which product attributes most impact Shopping CTR
- Product-level bidding in PMax vs Standard Shopping — differences in how each uses product data

- [ ] **Step 2: Save research findings**

Append findings to the design spec's Appendix under `### Session 2 Research: Product Performance`. Include:
- Confirmed `shopping_performance_view` fields (any beyond what GAQL templates already use)
- Zombie thresholds: recommended cost/impression/click cutoffs from industry sources
- Top feed attributes for CTR: title, image, price competitiveness, product type specificity
- PMax vs Standard Shopping product control differences

### Task 6: Build product-performance skill

**Files:**
- Create: `skills/product-performance/SKILL.md`

- [ ] **Step 1: Create skill directory**

```bash
mkdir -p skills/product-performance
```

- [ ] **Step 2: Write SKILL.md**

Create `skills/product-performance/SKILL.md` with this structure:

```markdown
---
name: product-performance
description: "Analyze product-level performance from Shopping and PMax campaigns — identify zombie products, top converters, and feed optimization candidates. Use for e-commerce accounts with Shopping or feed-only PMax campaigns."
argument-hint: "[account-name or analysis-type]"
disable-model-invocation: false
---

# Product Performance Analysis

Guided product-level analysis for Shopping and Performance Max campaigns. Wraps `shopping_performance_view` GAQL queries to identify revenue drivers, wasted spend, and feed optimization opportunities.

## Prerequisites

1. MCP connected — run `mcp__google-ads__write_status` to verify
2. Account has Shopping campaigns, PMax feed-only campaigns, or both
3. Account has at least 14 days of conversion data for meaningful analysis

## Reference Material

- [[reference/platforms/google-ads/shopping-campaigns|Shopping Campaigns]]
- [[reference/platforms/google-ads/pmax/feed-only-pmax|Feed-Only PMax]]
- [[reference/platforms/google-ads/pmax/feed-optimization|Feed Optimization]]
- [[reference/platforms/google-ads/shopping-feed-strategy|Shopping Feed Strategy]]
- [[reference/reporting/gaql-query-templates|GAQL Query Templates]] (Shopping section)
- [[reference/mcp/mcp-capabilities|MCP Capabilities]]

## Step 1: Establish Context

Ask the user:

1. **Which account?** → Use `mcp__google-ads__list_accounts` to list available accounts
2. **Campaign type?** → Shopping campaigns, PMax feed-only, or both?
3. **Date range?** → Default LAST_30_DAYS. For seasonal products, consider LAST_90_DAYS
4. **Revenue threshold?** → What's the minimum conversion value to consider a product "performing"? (helps calibrate zombie detection)

## Step 2: Pull Product Data via MCP

Run 4 GAQL queries using `mcp__google-ads__run_gaql`. Adjust `LIMIT` and date range per user context.

### 2a. Top Products by Revenue

```sql
SELECT
  segments.product_item_id,
  segments.product_title,
  segments.product_brand,
  segments.product_category_level1,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM shopping_performance_view
WHERE segments.date DURING LAST_30_DAYS
ORDER BY metrics.conversions_value DESC
LIMIT 50
```

### 2b. Zombie Products (Spend, Zero Conversions)

```sql
SELECT
  segments.product_item_id,
  segments.product_title,
  segments.product_brand,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions
FROM shopping_performance_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.cost_micros > 0
  AND metrics.conversions = 0
ORDER BY metrics.cost_micros DESC
LIMIT 50
```

### 2c. Category Performance

```sql
SELECT
  segments.product_category_level1,
  segments.product_category_level2,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM shopping_performance_view
WHERE segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```

### 2d. High-Impression Low-CTR Products (Feed Optimization Candidates)

```sql
SELECT
  segments.product_item_id,
  segments.product_title,
  metrics.impressions,
  metrics.clicks,
  metrics.ctr,
  metrics.cost_micros
FROM shopping_performance_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 100
  AND metrics.ctr < 0.01
```

## Step 3: Analyze Results

For each query result, present findings in a structured table and interpret:

### Top Converters
- Which products drive the most revenue?
- Is revenue concentrated (top 10 = 80% of revenue) or distributed?
- Are top converters from expected categories?

### Zombie Products
- Total wasted spend on zero-conversion products
- Are zombies from a specific brand, category, or price range?
- How many zombies have >100 clicks? (strong signal of product-market mismatch vs. low volume)

### Category Performance
- Which categories have best/worst ROAS?
- Any categories with high spend but low conversions? (structural issue vs. product issue)

### Feed Optimization Candidates
- Products with high impressions but <1% CTR
- Common patterns: poor titles, missing images, non-competitive pricing, vague product types

## Step 4: Recommend Actions

Based on analysis, recommend actions categorized by type:

### Immediate (safe during learning)
- Add zombie products as negative product targets (Shopping) or exclude from feed (PMax)
- Flag feed optimization candidates for title/image improvements in Merchant Center

### Requires Merchant Center (manual)
- Update product titles for low-CTR items (more specific, include brand + key attributes)
- Check image quality for underperformers
- Review pricing competitiveness for high-impression/low-conversion products

> [!warning] MCP Boundary
> Feed health data (disapprovals, GTIN coverage, image issues) lives in Merchant Center, not the Google Ads API. Product-level recommendations that require feed changes must be actioned manually in Merchant Center or via Content API.

### Strategic (after learning period)
- Reallocate budget toward top-performing categories
- Consider campaign restructuring if zombie concentration is high in specific campaigns

## Step 5: Route to Next Steps

Based on findings, suggest relevant skills:

| Finding | Route to |
|---------|----------|
| Feed needs optimization | [[skills/pmax-guide/SKILL.md\|PMax Guide]] (feed optimization section) |
| Budget reallocation needed | [[skills/budget-optimizer/SKILL.md\|Budget Optimizer]] |
| Campaign restructuring | [[skills/campaign-setup/SKILL.md\|Campaign Setup]] |
| Need full campaign audit | [[skills/campaign-review/SKILL.md\|Campaign Review]] |
| Shopping → PMax migration | [[skills/pmax-guide/SKILL.md\|PMax Guide]] (migration path) |

## Report Output

When running inside an MWP client project, write report to files:

- **Stage:** `05-optimize`
- **SUMMARY.md section:** Optimization & Reporting
- **Write sequence:** Follow 6-step protocol in [[_config/conventions#Report File-Writing Convention]]
- **Completeness:** Follow [[_config/conventions#Output Completeness Convention]] — every product row, every metric, no truncation
- **Fallback:** If not in an MWP project, present findings in conversation

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| No data returned | Account has no Shopping/PMax campaigns | Verify campaign types with `list_campaigns` |
| Zero conversions everywhere | Conversion tracking not set up | Route to `/ad-platform-campaign-manager:conversion-tracking` |
| Very few products | Feed has limited inventory | Normal for small catalogs — lower `LIMIT` values |
| `shopping_performance_view` errors | API access issue | Check MCP connection with `write_status` |
```

- [ ] **Step 3: Verify skill structure**

Read the created file. Confirm:
- Frontmatter has `name`, `description`, `argument-hint`, `disable-model-invocation`
- All 4 GAQL queries match `gaql-query-templates.md` Shopping section exactly
- `## Report Output` section present with correct stage (`05-optimize`)
- `[[wikilink]]` syntax used for all internal references
- MCP boundary warning present

### Task 7: Wire product-performance into CONTEXT.md

**Files:**
- Modify: `CONTEXT.md` (routing table, around line 11)

- [ ] **Step 1: Add routing entry**

Add a new row to the routing table in `CONTEXT.md` after the "Ad copy generation" row:

```markdown
| Product performance | `skills/product-performance/SKILL.md` | `reference/platforms/google-ads/shopping-campaigns.md`, `pmax/feed-only-pmax.md`, `pmax/feed-optimization.md`, `shopping-feed-strategy.md`, `reference/reporting/gaql-query-templates.md`, `reference/mcp/mcp-capabilities.md` | Tracking-bridge, scripts, audit |
```

- [ ] **Step 2: Verify routing**

Read `CONTEXT.md`. Confirm the new row is present and formatted correctly.

### Task 8: Register skill in CLAUDE.md Quick Navigation

**Files:**
- Modify: `CLAUDE.md` (Quick Navigation table)

- [ ] **Step 1: Add navigation entry**

Add a new row to the Quick Navigation table in `CLAUDE.md`:

```markdown
| Analyze product performance | `/ad-platform-campaign-manager:product-performance` |
```

Place it after the "Monitor a launched campaign" row.

- [ ] **Step 2: Verify navigation**

Read `CLAUDE.md`. Confirm the new row is present.

### Task 9: Update BACKLOG.md for #9

**Files:**
- Modify: `BACKLOG.md` (status table)

- [ ] **Step 1: Update #9 status**

Change:
```
| 9 | Product-level performance skill | Future | High | ⬜ Design needed |
```
to:
```
| 9 | Product-level performance skill | Future | High | ✅ Done (v1.20.0) |
```

### Task 10: Release v1.20.0

**Files:**
- Modify: `CHANGELOG.md`
- Modify: `PLAN.md`
- Modify: `PRIMER.md`

- [ ] **Step 1: Add CHANGELOG entry**

Add at the top of `CHANGELOG.md` (after frontmatter):

```markdown
## [1.20.0] — 2026-XX-XX

### Added
- **Product Performance skill (`/ad-platform-campaign-manager:product-performance`):** Interactive product-level analysis for Shopping and PMax campaigns — zombie product identification, top converter analysis, category performance breakdown, feed optimization candidates. Wraps 4 `shopping_performance_view` GAQL queries with guided interpretation and actionable recommendations.

### Fixed
- **Stale backlog statuses:** Items #5 (shopping queries), #6 (post-launch playbook), #8 (automated post-launch checks) updated from Open to Done — all were delivered in v1.15.0–v1.18.0

---
```

Replace `2026-XX-XX` with the actual date of the session.

- [ ] **Step 2: Update PLAN.md v1.20.0 status**

Change v1.20.0 row from `⬜ Not started` to `✅ Done (2026-XX-XX)`.

- [ ] **Step 3: Rewrite PRIMER.md**

Update Last Completed, Current State (Skills: 15), and What Still Needs to Happen (remove Session 2, advance to Session 3).

- [ ] **Step 4: Commit v1.20.0**

```bash
git add skills/product-performance/SKILL.md CONTEXT.md CLAUDE.md BACKLOG.md CHANGELOG.md PLAN.md PRIMER.md docs/superpowers/specs/2026-04-14-backlog-expansion-design.md
git commit -m "feat: product performance skill + stale backlog fixes (v1.20.0)"
```

---

## Session 3: Research iClosed (#10) + n8n (#12)

### Task 11: Online research — iClosed

- [ ] **Step 1: Research iClosed developer docs**

Use WebSearch to research:
- iClosed developer documentation / API docs — webhook payload schemas for all 7 events
- iClosed 2-Step Scheduler embedding — how URL parameters are passed to the iframe
- iClosed `tracking` object structure — `utmKey_N`/`utmValue_N` key-value pair format
- `callOutcome` webhook payload — confirm absence of `tracking` data (the attribution gap)

- [ ] **Step 2: Research Calendly comparison**

Read `c:\Users\VCL1\Voxxy Creative Lab Limited\08 - Projects\0002 - GTM Calendly Tracking` for comparison patterns. Note similarities and differences with iClosed GTM tracking approach.

- [ ] **Step 3: Save research findings**

Append to design spec Appendix under `### Session 3 Research: iClosed + n8n`.

### Task 12: Online research — n8n + Meta CAPI

- [ ] **Step 1: Research n8n nodes**

Use WebSearch to research:
- n8n `Webhook` node — configuration, security options (header auth, URL token)
- n8n `Google BigQuery` node — insert modes, schema handling, batch size
- n8n `Airtable` node — trigger types, polling frequency, field mapping
- n8n `HTTP Request` node — Meta Conversions API integration pattern

- [ ] **Step 2: Research Meta Conversions API server events**

Use WebSearch to research:
- Meta CAPI server event requirements — required fields per event type
- `action_source` values — when to use `system_generated` vs `website` vs `server`
- `fbc` parameter construction — official format specification
- Event deduplication via `event_id` — requirements and behavior

- [ ] **Step 3: Research n8n pricing**

Use WebSearch to confirm:
- n8n Cloud Starter plan — current price, execution limits, data retention
- n8n self-hosted option — requirements, maintenance considerations

- [ ] **Step 4: Save research findings**

Append to design spec Appendix under `### Session 3 Research: iClosed + n8n`.

### Task 13: Write iclosed-attribution.md

**Files:**
- Create: `reference/tracking-bridge/iclosed-attribution.md`

- [ ] **Step 1: Write the reference doc**

Create `reference/tracking-bridge/iclosed-attribution.md` with:

```yaml
---
title: iClosed — Tracking & Attribution Pipeline
date: 2026-XX-XX
tags:
  - reference
  - tracking-bridge
---
```

Content sections based on backlog item #10 + research findings:

1. `## Overview` — What iClosed is, why it needs custom tracking (iframe-based scheduler)
2. `## GTM URL Parameter Injection` — Custom HTML tag on Thank You page, Scenario A (single container) vs Scenario B (dedicated container). Include tag code
3. `## Webhook Events` — Table of all 7 events with: event name, trigger condition, key payload fields, tracking use case
4. `## fbclid Passthrough` — `tracking` object structure, `utmKey_N`/`utmValue_N` format, extraction logic
5. `## Attribution Gap: callOutcome` — The gap, the workaround (`contactId` correlation via CRM), diagram
6. `## Consent Gating` — `cookie_consent_marketing` trigger, Consent Mode v2 defaults denied, iframe consent considerations
7. `## GTM DataLayer Events` — Table of proposed events with **UNVERIFIED** label
8. `## Cross-References` — Links to n8n pipeline patterns (WF1/WF2), cross-platform data model (join keys)

- [ ] **Step 2: Verify document**

Read the created file. Confirm all 7 webhook events present, UNVERIFIED labels on dataLayer events, consent section references Consent Mode v2.

### Task 14: Write n8n-pipeline-patterns.md

**Files:**
- Create: `reference/tracking-bridge/n8n-pipeline-patterns.md`

- [ ] **Step 1: Write the reference doc**

Create `reference/tracking-bridge/n8n-pipeline-patterns.md` with:

```yaml
---
title: n8n — Tracking Pipeline Patterns
date: 2026-XX-XX
tags:
  - reference
  - tracking-bridge
---
```

Content sections based on backlog item #12 + research findings:

1. `## Overview` — n8n as the automation bridge between 3rd-party tools (iClosed, Calendly) and data destinations (CRM, BigQuery, Meta CAPI). Scoped to tracking pipelines only.
2. `## 4-Workflow Pattern` — WF1 through WF4 with: trigger, source, destination, key fields, n8n nodes used. Include flow diagram.
3. `## Webhook Security` — URL-based secret token (current), no HMAC from iClosed (on their roadmap), recommended mitigations
4. `## Meta CAPI via n8n` — `action_source: system_generated`, required fields, `fbc` construction formula, event deduplication via `event_id` = `callPreviewId`
5. `## n8n Node Reference` — Table of nodes used with: node name, purpose, key configuration, gotchas
6. `## Pricing & Setup` — n8n Cloud Starter (EUR 24/mo), execution limits, client-owned account pattern
7. `## Boundary Note` — Explicit scope boundary: this doc covers tracking pipelines only. Full n8n workflow automation deferred to future `n8n-plugin`.
8. `## Cross-References` — Links to iClosed attribution (webhook events), Meta BQ pipeline, cross-platform data model

- [ ] **Step 2: Verify document**

Read the created file. Confirm boundary note present, 4 workflows described, Meta CAPI section has `fbc` formula.

### Task 15: Update tracking-bridge CONTEXT.md

**Files:**
- Modify: `reference/tracking-bridge/CONTEXT.md`

- [ ] **Step 1: Add entries for new files**

Add entries for `iclosed-attribution.md` and `n8n-pipeline-patterns.md` to the tracking-bridge CONTEXT.md file, following the existing pattern for other files in that directory.

- [ ] **Step 2: Verify**

Read the file. Confirm both new entries present.

### Task 16: Commit Session 3

- [ ] **Step 1: Stage and commit**

```bash
git add reference/tracking-bridge/iclosed-attribution.md reference/tracking-bridge/n8n-pipeline-patterns.md reference/tracking-bridge/CONTEXT.md docs/superpowers/specs/2026-04-14-backlog-expansion-design.md
git commit -m "feat: iClosed attribution + n8n pipeline patterns — tracking-bridge expansion"
```

- [ ] **Step 2: Rewrite PRIMER.md**

Update Last Completed with Session 3 deliverables. Update What Still Needs to Happen (advance to Session 4).

- [ ] **Step 3: Commit PRIMER.md**

```bash
git add PRIMER.md
git commit -m "docs: PRIMER.md session 3 handoff"
```

---

## Session 4: Research Meta BQ (#11) + Cross-Platform (#13)

### Task 17: Online research — Meta Ads to BigQuery

- [ ] **Step 1: Research BigQuery Data Transfer Service**

Use WebSearch to research:
- BigQuery Data Transfer Service for Facebook/Meta — current status, supported reports, field coverage
- Setup steps and prerequisites (Meta Business Manager, BQ project)
- Refresh frequency (24h), data latency, historical backfill capabilities
- Known limitations and field gaps

- [ ] **Step 2: Research OWOX Data Marts**

Use WebSearch to research:
- `OWOX/owox-data-marts` GitHub repo — architecture, setup, supported Meta metrics
- Comparison with BigQuery Data Transfer Service — what it adds
- Maintenance requirements, update frequency

- [ ] **Step 3: Research Meta Marketing API for n8n**

Use WebSearch to research:
- Meta Marketing API Insights endpoint — available fields, breakdowns, rate limits
- n8n HTTP Request node configuration for Meta API — auth, pagination
- Cost vs BQ Data Transfer Service — when manual API calls are worth it

- [ ] **Step 4: Save research findings**

Append to design spec Appendix under `### Session 4 Research: Meta BQ + Cross-Platform`.

### Task 18: Write meta-ads-bigquery.md

**Files:**
- Create: `reference/reporting/meta-ads-bigquery.md`

- [ ] **Step 1: Write the reference doc**

Create `reference/reporting/meta-ads-bigquery.md` with:

```yaml
---
title: Meta Ads to BigQuery Pipeline
date: 2026-XX-XX
tags:
  - reference
  - reporting
---
```

Content sections based on backlog item #11 + research findings:

1. `## Overview` — Why you need Meta data in BigQuery (cross-platform reporting, attribution, ROAS comparison)
2. `## Approach 1: BigQuery Data Transfer Service` — Setup steps, field coverage, limitations, cost (free), when to use
3. `## Approach 2: OWOX Data Marts` — Architecture, setup, what it adds vs BDTS, maintenance, when to upgrade
4. `## Approach 3: n8n HTTP Request to Meta Marketing API` — n8n workflow design, Meta API auth, pagination, rate limits, when to use
5. `## Decision Matrix` — Table comparing all 3 on: cost, latency, field coverage, maintenance, complexity
6. `## Schema: meta_ads_performance` — BigQuery table schema for normalized Meta Ads data
7. `## Cross-References` — Links to n8n pipeline patterns, cross-platform data model

- [ ] **Step 2: Verify document**

Read the created file. Confirm 3 approaches documented, decision matrix present, schema defined.

### Task 19: Extend cross-platform-data-model.md

**Files:**
- Modify: `reference/reporting/cross-platform-data-model.md`

- [ ] **Step 1: Read current file**

Read `reference/reporting/cross-platform-data-model.md` in full to understand current structure and find insertion points.

- [ ] **Step 2: Add 5-source architecture section**

Add a new section `## Multi-Source Architecture` (or extend existing architecture section) with:

```markdown
### 5-Source Architecture Table

| Source | Connector | Refresh | Latency | Key Tables |
|--------|-----------|---------|---------|------------|
| GA4 | Native BQ Export | Daily | ~24h | `analytics_XXXXXX.events_*` |
| Meta Ads | BigQuery Data Transfer Service | Daily | ~24h | `meta_ads_performance` |
| iClosed | n8n Webhook → BQ node | Real-time | Seconds | `iclosed_events` |
| Airtable | n8n Airtable Trigger → BQ node | Polling | 5–15 min | `airtable_contacts` |
| sGTM | sGTM BigQuery tag | Streaming | Seconds | `sgtm_events` |
```

- [ ] **Step 3: Add join key strategy section**

Add `## Join Key Strategy` section:

- `contactId` as cross-system key linking iClosed records ↔ Airtable ↔ CAPI events
- `callPreviewId` as CAPI `event_id` for deduplication
- `fbc` reconstruction formula: `fb.1.{bookingTime_unix}.{fbclid}`
- Join diagram showing which keys connect which tables

- [ ] **Step 4: Add lead lifecycle stages section**

Add `## Lead Lifecycle Stages` section:

Table mapping stages across systems:

| Stage | iClosed Event | Airtable Status | Meta CAPI Event | GA4 Event |
|-------|--------------|-----------------|-----------------|-----------|
| Lead | `newContactCreated` | "New Lead" | `Lead` | `generate_lead` |
| MQL | `contactByStatus` | "Qualified" | — | `qualify_lead` |
| Booked | `newCallScheduled` | "Call Booked" | `Schedule` | `book_call` |
| SQL | `callOutcome` (positive) | "Sales Qualified" | — | — |
| Closed | `callOutcome` (won) | "Closed Won" | `Purchase` | `purchase` |

- [ ] **Step 5: Verify changes**

Read the modified file. Confirm 5-source table, join key strategy, lifecycle stages all present and consistent.

### Task 20: Commit Session 4

- [ ] **Step 1: Stage and commit**

```bash
git add reference/reporting/meta-ads-bigquery.md reference/reporting/cross-platform-data-model.md docs/superpowers/specs/2026-04-14-backlog-expansion-design.md
git commit -m "feat: Meta Ads BQ pipeline + cross-platform data model expansion"
```

- [ ] **Step 2: Rewrite PRIMER.md**

Update Last Completed with Session 4 deliverables. Update What Still Needs to Happen (advance to Session 5).

- [ ] **Step 3: Commit PRIMER.md**

```bash
git add PRIMER.md
git commit -m "docs: PRIMER.md session 4 handoff"
```

---

## Session 5: Integration + Release v1.21.0

### Task 21: Update CONTEXT.md routing

**Files:**
- Modify: `CONTEXT.md` (routing table)

- [ ] **Step 1: Add routing entries**

Add 3 new rows to the routing table:

```markdown
| iClosed tracking | `reference/tracking-bridge/iclosed-attribution.md` | `reference/tracking-bridge/n8n-pipeline-patterns.md`, `reference/reporting/cross-platform-data-model.md` | Scripts, audit, mcp |
| n8n tracking pipelines | `reference/tracking-bridge/n8n-pipeline-patterns.md` | `reference/tracking-bridge/iclosed-attribution.md`, `reference/reporting/meta-ads-bigquery.md` | Scripts, audit |
| Meta Ads reporting | `reference/reporting/meta-ads-bigquery.md` | `reference/reporting/cross-platform-data-model.md`, `reference/tracking-bridge/n8n-pipeline-patterns.md` | Scripts, audit, tracking-bridge (unless pipeline setup) |
```

- [ ] **Step 2: Verify routing**

Read `CONTEXT.md`. Confirm all 3 entries present, cross-references correct.

### Task 22: Update CLAUDE.md permanent rule

**Files:**
- Modify: `CLAUDE.md` (Permanent Rules section)

- [ ] **Step 1: Update "Google Ads only" rule**

Find the current rule:
```markdown
- **Google Ads only.** Architecture supports multi-platform (Meta, LinkedIn, TikTok) via `reference/platforms/` but only `google-ads/` is populated. Do not reference other platforms as if they are available.
```

Replace with:
```markdown
- **Google Ads campaign management only.** The tracking-bridge layer extends to cross-platform attribution pipelines (iClosed, n8n, Meta CAPI) because tracking infrastructure is platform-agnostic. Skills and agents remain Google Ads-focused. Architecture supports multi-platform reference docs via `reference/platforms/` but only `google-ads/` has operational skills.
```

- [ ] **Step 2: Verify rule**

Read `CLAUDE.md`. Confirm the updated rule preserves the Google Ads skill boundary while acknowledging tracking-bridge expansion.

### Task 23: Update ecosystem.md

**Files:**
- Modify: `_config/ecosystem.md`

- [ ] **Step 1: Update n8n-plugin entry**

Find the n8n-plugin section and add a note:

```markdown
#### n8n-plugin 🔲 Planned
- **Skills:** TBD (design, build, test, deploy)
- **Domains:** N8N workflow automation, API integrations, agent pipelines
- **When to use:** Designing or building N8N automation workflows
- **Status:** Not yet built — use `tech-standards.md` + `conventions.md` stubs manually
- **Note:** Tracking-specific n8n pipeline patterns (webhook → BQ, CRM → CAPI) are documented in `ad-platform-campaign-manager/reference/tracking-bridge/n8n-pipeline-patterns.md`. This plugin will cover general n8n workflow automation beyond tracking.
```

- [ ] **Step 2: Verify ecosystem**

Read `_config/ecosystem.md`. Confirm note present and accurate.

### Task 24: Update BACKLOG.md final statuses

**Files:**
- Modify: `BACKLOG.md` (status table)

- [ ] **Step 1: Update remaining statuses**

Update items #10–#13 in the status table:

```
| 10 | iClosed tracking patterns | New Capability | Medium | ✅ Done (v1.21.0) |
| 11 | Meta Ads to BigQuery pipeline | Gap | Medium | ✅ Done (v1.21.0) |
| 12 | n8n as automation layer in tracking stacks | New Capability | Medium | ✅ Done (v1.21.0) |
| 13 | Cross-platform data model for BigQuery | Gap | Low | ✅ Done (v1.21.0) |
```

### Task 25: Release v1.21.0

**Files:**
- Modify: `CHANGELOG.md`
- Modify: `PLAN.md`
- Modify: `PRIMER.md`

- [ ] **Step 1: Add CHANGELOG entry**

Add at the top of `CHANGELOG.md`:

```markdown
## [1.21.0] — 2026-XX-XX

### Added
- **iClosed attribution reference (`reference/tracking-bridge/iclosed-attribution.md`):** Full iClosed tracking pipeline — GTM URL param injection (Scenario A/B), 7 webhook events with payload schemas, fbclid passthrough via `tracking` object, callOutcome attribution gap workaround, consent gating, UNVERIFIED dataLayer events
- **n8n pipeline patterns reference (`reference/tracking-bridge/n8n-pipeline-patterns.md`):** 4-workflow pattern for high-ticket funnels (booking→CRM, outcome→CRM, CRM→CAPI, events→BigQuery), webhook security, n8n node reference, Meta CAPI integration, pricing. Scoped to tracking pipelines only — full n8n automation deferred to future n8n-plugin
- **Meta Ads to BigQuery pipeline (`reference/reporting/meta-ads-bigquery.md`):** 3 pipeline approaches (BigQuery Data Transfer Service, OWOX Data Marts, n8n HTTP Request) with decision matrix, `meta_ads_performance` schema

### Changed
- **Cross-platform data model expanded:** 5-source architecture table, iClosed/Airtable join key strategy (`contactId`, `callPreviewId`), lead lifecycle stage mapping (Lead→MQL→Booked→SQL→Closed), `fbc` reconstruction formula
- **CLAUDE.md permanent rule updated:** "Google Ads only" relaxed — tracking-bridge now covers cross-platform attribution pipelines (iClosed, n8n, Meta CAPI). Skills and agents remain Google Ads-focused
- **CONTEXT.md routing updated:** iClosed tracking, n8n pipelines, Meta Ads reporting added to routing table
- **ecosystem.md:** n8n-plugin entry updated with cross-reference to tracking-bridge patterns

---
```

Replace `2026-XX-XX` with actual date.

- [ ] **Step 2: Update PLAN.md v1.21.0 status**

Change v1.21.0 row from `⬜ Not started` to `✅ Done (2026-XX-XX)`.

- [ ] **Step 3: Rewrite PRIMER.md (final)**

Full rewrite reflecting:
- Last Completed: v1.21.0 cross-platform tracking expansion
- Current State: updated counts (tracking-bridge: 8, reporting: 6, skills: 15)
- What Still Needs to Happen: remove Sessions 3–5, keep OAuth rotation + Phase 4 skills + Priority 4 audit

- [ ] **Step 4: Commit v1.21.0**

```bash
git add CONTEXT.md CLAUDE.md _config/ecosystem.md BACKLOG.md CHANGELOG.md PLAN.md PRIMER.md reference/tracking-bridge/CONTEXT.md
git commit -m "feat: cross-platform tracking expansion — iClosed, n8n, Meta BQ, data model (v1.21.0)"
```

---

## Verification Checklist

### v1.20.0
- [ ] BACKLOG.md: #5, #6, #8 show `✅ Done`; #9 shows `✅ Done (v1.20.0)`
- [ ] `skills/product-performance/SKILL.md` exists with frontmatter, 4 GAQL queries, report output section
- [ ] CONTEXT.md routes "Product performance" to the skill
- [ ] CLAUDE.md Quick Navigation includes product-performance
- [ ] Dry-run: invoke `/ad-platform-campaign-manager:product-performance` — verify skill loads and asks context questions

### v1.21.0
- [ ] `reference/tracking-bridge/iclosed-attribution.md` — 7 webhook events, fbclid passthrough, UNVERIFIED labels
- [ ] `reference/tracking-bridge/n8n-pipeline-patterns.md` — 4 workflows, boundary note, Meta CAPI section
- [ ] `reference/reporting/meta-ads-bigquery.md` — 3 approaches, decision matrix, schema
- [ ] `cross-platform-data-model.md` — 5-source table, join keys, lifecycle stages, `fbc` formula
- [ ] CONTEXT.md — 3 new routing entries (iClosed, n8n, Meta)
- [ ] CLAUDE.md — permanent rule updated (tracking-bridge scope)
- [ ] ecosystem.md — n8n-plugin note added
- [ ] BACKLOG.md — #10–#13 all show `✅ Done (v1.21.0)`
- [ ] No skills or agents reference iClosed/n8n/Meta as operational capabilities
