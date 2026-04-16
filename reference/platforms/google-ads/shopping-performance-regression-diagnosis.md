---
title: Shopping Performance Regression Diagnosis
date: 2026-04-16
tags:
  - reference
  - google-ads
  - shopping
  - troubleshooting
---

# Shopping Performance Regression Diagnosis

Use this file when a Shopping campaign that was previously performing well has a sudden ROAS drop, conversion collapse, or dramatic underperformance vs. historical averages.

> [!warning] Before diagnosing: check the date window
> If the campaign was recently restructured (bids, budget, product groups), the LAST_30_DAYS window will show pre-restructure performance mixed with post-restructure. A "7.49 ROAS last 30 days → 0.41 ROAS last 7 days" pattern may be a window contamination artifact, not a performance collapse. Always anchor your diagnosis on the post-restructure 7-day window.

---

## 1. Symptoms Taxonomy

Match the observable pattern to the most likely hypothesis category:

| Observable Pattern | Most Likely Hypothesis |
|---|---|
| ROAS drop + high spend + low primary conversions, but account ROAS is stable | Attribution shift (H1) — Shopping is last-click losing to PMax/remarketing |
| ROAS drop + IS Lost to Rank increased significantly | Bid structure disruption (H2) — new bids too low or product group structure reset |
| ROAS drop + specific product types disappeared from search terms | Product disapprovals (H3) — MC feed items going offline |
| ROAS drop + budget increase >20% happened recently | Budget change side effect (H4) — learning phase disruption for smart bidding |
| ROAS drop + outdoor/seasonal product mix in search terms | Seasonal demand shift (H5) — customers shifting to local stores for seasonal products |
| ROAS drop + other campaigns also showing fewer conversions | Conversion tracking gap (H6) — S2S/sGTM tag stopped firing |
| ROAS drop + individual converting products have 0 impressions | Feed issues (H7) — price/availability changes, product disapprovals |

---

## 2. Hypothesis Checklist (Investigation Order)

Work through these in order. Once a hypothesis is confirmed, document it and continue to check for secondary causes.

### H1 — Attribution Shift (Last-Click)

**When to suspect:** Account ROAS is stable while Shopping ROAS collapses. PMax or remarketing campaigns are running alongside Shopping.

**What happens:** Customers click a Shopping ad (top-of-funnel), then convert via PMax or a remarketing ad (last touchpoint). Last-click attribution gives Shopping 0 credit. Shopping's primary ROAS falls; PMax/remarketing ROAS rises.

**GAQL query:**
```gaql
SELECT segments.product_item_id, segments.product_title,
  metrics.conversions, metrics.all_conversions,
  metrics.conversions_value, metrics.all_conversions_value,
  metrics.cost_micros
FROM shopping_performance_view
WHERE segments.date DURING LAST_7_DAYS
ORDER BY metrics.all_conversions_value DESC LIMIT 30
```

**What to look for:**
- Products with `all_conversions` >> `conversions` (e.g., 26 all_conv, 0 primary conv)
- High `all_conversions_value` with 0 `conversions_value` = attribution star
- Multiple products showing this pattern = attribution shift confirmed

**Verdict logic:**
- Top products show `all_conversions` > `conversions` consistently → H1 CONFIRMED
- `all_conversions` ≈ `conversions` across products → H1 RULED OUT

**Action when confirmed:**
- Do NOT pause or reduce Shopping — it is driving the discovery that other campaigns convert
- Evaluate Shopping on `all_conversions_value / cost` as directional (double-counting caveat below)
- Report account-level ROAS (blended) as the primary health metric, not Shopping-specific ROAS
- Consider: does this account have enough data for data-driven attribution (50+ conversions/month)? If yes, enable DDA to get fairer Shopping credit
- Reframe client narrative: Shopping drives upper-funnel, PMax/remarketing close the sale. This is healthy.

> [!warning] Double-counting caveat for all_conversions_value
> `all_conversions_value` in shopping_performance_view includes the order value for EVERY product that was clicked in the customer's journey, not just the converting product. If a customer browsed 5 products before buying 1, all 5 products get the order value. Do not sum `all_conversions_value` across products and call it "Shopping's true revenue" — it will be massively inflated. Use it as a directional signal only, or for product-level attribution comparisons.

---

### H2 — Bid Structure Disruption / Rank-Based Impression Loss

**When to suspect:** ROAS drop coincides with a change to product group structure (subdivision, bid changes, or complete rebuild).

**GAQL query:**
```gaql
SELECT campaign.name,
  metrics.search_impression_share,
  metrics.search_budget_lost_impression_share,
  metrics.search_rank_lost_impression_share,
  metrics.search_click_share
FROM campaign
WHERE campaign.id = {campaign_id}
AND segments.date DURING LAST_7_DAYS
```

**What to look for:**
- IS Lost to Rank > 20% → bids are too low, campaign losing auctions to competitors
- IS Lost to Rank increased significantly vs. pre-restructure → bid change disrupted auction competitiveness
- IS Lost to Budget is the dominant metric (>60%) → budget constraint, not bid constraint
- Click share below 30% → significant competitive displacement

**Verdict logic:**
- IS Lost to Rank > 20% AND increased vs. pre-restructure baseline → H2 CONFIRMED
- IS Lost to Rank < 10% → H2 RULED OUT

**Action when confirmed:**
- If product group subdivision caused the disruption: Google Shopping's click distribution model re-learns with the new structure. Allow 2–3 weeks for stabilization before changing bids.
- If individual bids are too low: cross-reference avg CPC vs benchmark CPC per product group. Raise underperforming product group bids incrementally (10–20% at a time).
- If budget is the constraint (high IS Lost to Budget): the bids are fine — budget increase will improve reach. Calculate the revenue opportunity: IS Lost to Budget × click volume × avg CVR × avg order value.

---

### H3 — Product Disapprovals (Merchant Center)

**When to suspect:** Specific products that used to convert are now showing 0 impressions and 0 clicks despite being in active product groups.

**No direct GAQL for MC disapprovals.** Use Google Ads product performance as proxy:
```gaql
SELECT segments.product_item_id, segments.product_title,
  metrics.impressions, metrics.clicks, metrics.cost_micros
FROM shopping_performance_view
WHERE segments.date DURING LAST_7_DAYS
ORDER BY metrics.impressions DESC LIMIT 50
```

**What to look for:**
- Previously converting products showing 0 impressions in the 7-day window
- Zero impressions + product group bid > €0 = likely disapproved or out-of-stock in MC

**Verification:** Manual check in Merchant Center → Diagnostics → Products. Look for items with "Disapproved" status and the rejection reason.

**Common disapproval causes:**
- Broken URL (landing page 404 or redirect)
- Price mismatch between feed and landing page
- Missing required GTIN
- Mismatched availability (`in_stock` in feed, out-of-stock on landing page)
- Policy violation (prohibited products, deceptive claims)

**Action when confirmed:** Fix the specific feed attribute causing the disapproval. Resubmit via Merchant Center. Approval typically takes 24–72 hours.

---

### H4 — Budget Change Side Effects

**When to suspect:** ROAS drop closely follows a budget increase > 20%.

**Important note for Manual CPC:** A budget change does NOT reset the smart bidding learning phase on Manual CPC campaigns. This hypothesis is primarily relevant for tROAS or Maximize Conversion Value Shopping campaigns. For Manual CPC, large budget increases change the click distribution (more impressions across more products) but do not trigger a formal learning reset.

**GAQL to verify the budget change happened:**
```gaql
SELECT change_event.change_date_time, change_event.change_resource_type,
  change_event.old_resource, change_event.new_resource
FROM change_event
WHERE change_event.change_date_time >= '{restructure_date} 00:00:00'
  AND change_event.change_date_time <= '{today} 23:59:59'
ORDER BY change_event.change_date_time DESC LIMIT 50
```

**What to look for in change history:**
- Budget change magnitude (old_resource.amount_micros → new_resource.amount_micros)
- Whether the budget change precedes the ROAS drop in the timeline
- Any other concurrent changes (bid strategy changes are the real risk)

**Action when confirmed (smart bidding campaigns):**
- Allow 1–2 weeks for the algorithm to re-pace after a large budget change
- Do not make additional structural changes during this stabilization period
- For Manual CPC: budget change effects are non-structural — investigate H1/H2 before concluding H4

---

### H5 — Seasonal Demand Shift

**When to suspect:** ROAS drop aligns with a seasonal calendar shift. Outdoor/garden product mix in search terms. Spring or autumn for plant/garden retailers. Q4 for non-gift categories.

**Diagnostic approach:**
- Review search terms report for the past 7 days — what percentage are outdoor/seasonal terms?
- Compare product category mix (week 1 post-launch vs current) if data is available
- Check if the top outdoor-query products have near-0 `all_conversions` (not just primary) — if `all_conversions` is also 0, the demand is genuinely not converting, not just attributed elsewhere

**GAQL for category-level spend:**
```gaql
SELECT segments.product_item_id, segments.product_title,
  metrics.clicks, metrics.cost_micros, metrics.conversions, metrics.all_conversions
FROM shopping_performance_view
WHERE segments.date DURING LAST_7_DAYS
ORDER BY metrics.cost_micros DESC LIMIT 50
```

Group the results manually by indoor vs outdoor product type and compare ROAS per category.

**Action when confirmed:**
- Add product exclusions or bid reductions for seasonal outdoor products that have 0 `all_conversions` (not just 0 primary conversions — if they have all_conv, they're contributing to the journey)
- Set client expectations: seasonal demand shifts are external and temporary. Performance should recover when the season matches the product range.
- Document the seasonal pattern for Year 2 planning.

---

### H6 — Conversion Tracking Gap

**When to suspect:** ALL campaigns showing fewer conversions simultaneously (not just Shopping). Recent S2S/sGTM tag changes or Merchant Center changes.

**GAQL to check conversion action status:**
```gaql
SELECT conversion_action.name, conversion_action.status,
  conversion_action.category, conversion_action.counting_type,
  conversion_action.include_in_conversions_metric
FROM conversion_action
WHERE conversion_action.status = 'ENABLED'
```

**What to look for:**
- Primary purchase conversion action still ENABLED and PRIMARY
- No accidental pausing of the S2S conversion action
- No new conversion actions accidentally set to PRIMARY

**Additional checks:**
- If remarketing conversion is still firing → sGTM is working → H6 unlikely for Shopping
- Check sGTM container → Tags → Purchase tag: verify recent deployment hasn't broken anything
- Cross-reference with backend order volume: if backend shows orders but Google Ads shows 0, tracking is broken

**Action when confirmed:** Invoke `/ad-platform-campaign-manager:conversion-tracking` for a full conversion tracking audit.

---

### H7 — Feed Issues (Price/Availability)

**When to suspect:** Converting products are showing impressions but very low CTR. Competitors appear to be outbidding on price. Product availability changed recently.

**Check product-level click and impression data:**
```gaql
SELECT segments.product_item_id, segments.product_title,
  metrics.impressions, metrics.clicks,
  metrics.ctr, metrics.average_cpc, metrics.cost_micros,
  metrics.conversions, metrics.all_conversions
FROM shopping_performance_view
WHERE segments.date DURING LAST_7_DAYS
ORDER BY metrics.impressions DESC LIMIT 30
```

**What to look for:**
- High impressions + very low CTR (<0.3%) = price uncompetitive vs feed benchmark
- Previously converting products with impressions but 0 clicks = ad may not be rendering (disapproval)
- Very high avg CPC on certain products = anomalous — check feed price vs competitor pricing

**Action when confirmed:**
- Fix availability: mark out-of-stock products as `out_of_stock` in feed immediately (better than disapproval)
- Fix price accuracy: feed price must match landing page price exactly (including sale prices)
- For uncompetitive pricing: this is a business decision, not a Google Ads fix

---

## 3. Common Multi-Cause Scenarios

In practice, Shopping regressions often have multiple contributing factors. Common combinations:

**Attribution shift + Budget increase:**
Shopping budget was doubled (H4 contributing) AND PMax was launched at the same time (H1). PMax's presence shifts last-click attribution away from Shopping. Shopping's primary ROAS drops. Both causes are present but H1 is the dominant explanation.

**Bid structure disruption + Attribution shift:**
Product group subdivision (H2 — new structure needs re-learn period) coinciding with PMax running (H1). The timing of the subdivision is suspicious but the attribution data confirms H1. H2 adds click distribution instability on top.

**Seasonality + Attribution:**
Spring seasonality (H5) shifts product mix toward outdoor queries that don't convert online. At the same time, the indoor products that DO convert are being attributed to remarketing (H1). Both are real effects.

---

## 4. 30-Day Window Warning

> [!danger] Contaminated 30-day window after restructure
> If a Shopping campaign was restructured within the last 30 days (budget changed, product groups rebuilt, bids reset), the LAST_30_DAYS window will show pre-restructure performance mixed with post-restructure. A pre-restructure ROAS of 7.49 averaged with a post-restructure ROAS of 0.41 produces a misleading 30-day aggregate. ALWAYS state the restructure date and use LAST_7_DAYS as the operational window for post-restructure diagnosis.

**How to calculate true post-restructure window:**
- Identify the exact restructure timestamp from change_event history
- Use daily segmented data (segments.date) to isolate pre- vs. post-restructure performance
- Only the post-restructure days are relevant for performance assessment

---

## 5. Attribution Model Considerations

Shopping campaigns default to **last-click attribution**. Under last-click:
- The final ad click before a purchase gets 100% of the conversion credit
- Shopping frequently loses to PMax/remarketing on the last click
- Shopping's true contribution is invisible in the primary ROAS metric

**When to use `all_conversions` as a directional signal:**
- When Shopping shows 0 or near-0 primary conversions despite good click volume
- When comparing Shopping's assisted impact to PMax/remarketing last-click credit
- Note: `all_conversions` in shopping_performance_view is a cross-device, cross-session view that includes ALL conversion touchpoints where the product was in the journey

**When data-driven attribution (DDA) becomes available:**
- Requires 50+ conversions per month per account
- DDA distributes conversion credit across all touchpoints in the path
- Shopping ROAS under DDA is typically higher than last-click ROAS
- To enable: Google Ads → Tools → Attribution → Attribution model → Data-driven

---

## 6. tROAS Transition Gate — Shopping

Standard Shopping campaigns running on Manual CPC should transition to tROAS only when:

1. **Conversion volume:** >= 50 primary conversions per month on Shopping specifically (not account-total)
2. **Consistency:** ROAS is stable over 4+ consecutive weeks (no major swings)
3. **Attribution stability:** The account's attribution model is stable (no concurrent PMax competing for last click on the same products)
4. **Budget adequacy:** Daily budget >= 5× target CPA (for tROAS: budget >= 5 × (avg order value / target ROAS))

> [!warning] Attribution shift blocks tROAS transition
> If Shopping is experiencing attribution shift (H1), it will not accumulate the 50 primary conversions needed for tROAS. Transitioning to tROAS on a Shopping campaign with 2 primary conversions/week will produce erratic bidding. Keep Manual CPC until either: (a) attribution shift resolves, or (b) data-driven attribution is enabled and Shopping gets fair credit.

---

## Related

- [[shopping-campaigns]] — Shopping campaign setup and best practices (see Troubleshooting section)
- [[gaql-reference]] — Full GAQL field reference
- [[bidding-strategies]] — Bid strategy selection guide
- [[learning-phase]] — Learning phase reset triggers and recovery
- `/ad-platform-campaign-manager:post-launch-monitor` — Phase-aware post-launch monitoring (routes here when Shopping ROAS drops >30% vs baseline)
- `/ad-platform-campaign-manager:conversion-tracking` — Conversion tracking audit (invoke when H6 suspected)
