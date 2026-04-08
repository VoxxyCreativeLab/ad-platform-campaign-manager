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

---

## Status

| # | Item | Category | Priority | Status |
|---|------|----------|----------|--------|
| 1 | bidding-strategies.md contradiction | Contradiction | High | ⬜ Open |
| 2 | feed-only-pmax.md steps 12-14 | Contradiction | High | ⬜ Open |
| 3 | common-mistakes.md #20 too vague | Contradiction | Medium | ⬜ Open |
| 4 | learning-phase.md reference | Gap | High | ⬜ Open |
| 5 | shopping_performance_view queries | Gap | High | ⬜ Open |
| 6 | Post-launch playbook | Gap | High | ⬜ Open |
| 7 | Learning duration table | Gap | Medium | ⬜ Open |
| 8 | Automated post-launch checks | New Capability | Medium | ⬜ Design needed |
| 9 | Product-level performance skill | New Capability | High | ⬜ Design needed |

---

%% New items are appended below this line by /plugin-backlog %%
