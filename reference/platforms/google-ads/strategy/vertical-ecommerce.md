---
title: "Vertical Playbook — E-commerce"
date: 2026-04-03
tags:
  - reference
  - strategy
  - vertical
---

# Vertical Playbook — E-commerce

%%
Audience: tracking specialists learning campaign strategy.
This document covers the Google Ads e-commerce vertical — feed-centric, ROAS-driven, Merchant Center required.
%%

> [!abstract] What This Covers
> Feed management, campaign mix for product-based businesses, ROAS optimisation, seasonal planning. Cross-references: [[vertical-lead-gen]], [[vertical-b2b-saas]], [[vertical-local-services]], [[account-profiles]].

---

## 1. Overview

E-commerce is the most data-rich Google Ads vertical. Every sale has a known value, which makes value-based bidding viable earlier than in any other vertical. The product feed is the single biggest lever — your title, image, price, and custom labels determine which queries your ads appear for in Shopping.

**What defines this vertical:**
- Revenue is the primary objective, not leads
- Attribution is relatively clean — purchase events carry known values
- The Merchant Center feed is the creative unit for Shopping and PMax
- Competition scales with margin: low-margin categories face brutal CPCs

**Key business metrics:**

| Metric | Definition | Why It Matters |
|--------|------------|----------------|
| **ROAS** | Revenue ÷ Ad Spend | Primary KPI — measures return on every euro spent |
| **Blended ROAS** | Total revenue ÷ total ad spend (all campaigns) | Prevents gaming one campaign at another's expense |
| **AOV** | Average Order Value | Determines minimum viable CPA before ROAS breaks |
| **MER** | Marketing Efficiency Ratio | Total revenue ÷ total marketing spend (not just Google) |
| **Cart abandonment rate** | % of add-to-carts that do not purchase | Signals remarketing opportunity |

**Typical conversion types:**

| Conversion | Tracking method | Attribution window |
|------------|----------------|-------------------|
| Purchase | GTM `purchase` event → sGTM → Google Ads | 30-day click, 1-day view |
| Add to cart | GTM event (micro-conversion, do not optimise bids on this) | — |
| Begin checkout | GTM event (micro-conversion) | — |
| Dynamic remarketing view | `view_item` / `view_item_list` events for audience building | — |

%%fact-check: 30-day click default attribution window for purchase conversions — verified 2026-04-03%%

---

## 2. Recommended Campaign Mix by Maturity

%%
The mix shifts heavily from Search-first to feed-first as data accumulates.
%%

| Maturity Stage | Primary Campaigns | Supporting Campaigns | Not Yet |
|---------------|------------------|---------------------|---------|
| **Cold start** (0-3 mo) | Brand Search (exact) | Non-brand Search (exact/phrase, top SKUs) | PMax, Shopping, Demand Gen |
| **Early data** (3-6 mo) | Standard Shopping (top products) | Brand + Non-brand Search | Feed-only PMax (test, 1 campaign) |
| **Established** (6-18 mo) | Feed-only PMax (primary) | Standard Shopping (catch-all) + Brand Search | Full-asset PMax, Display |
| **Mature** (18+ mo) | Feed-only PMax (segmented by margin) | Brand Search + Demand Gen remarketing | — |

> [!tip] Why Feed-Only PMax, Not Standard Shopping?
> Feed-only PMax runs on Shopping inventory only (no Display, no YouTube) but gets smarter bidding signals than Standard Shopping. Once you have 30+ conversions/month with value data, feed-only PMax consistently outperforms Standard Shopping on ROAS.
> Cross-ref: [[pmax/feed-only-pmax]]

> [!warning] PMax + Standard Shopping Conflict
> Running PMax and Standard Shopping with overlapping product sets creates internal auction conflict. PMax takes priority in most auctions, cannibalising Standard Shopping's data. Segment by product category or run a true Performance-Max-first strategy with Standard Shopping as a safety net for low-volume SKUs only.

---

## 3. Campaign Structure

**Naming convention:**

```
[Brand|NB|Shop|PMax] — [Category/Segment] — [Match Type if Search] — [Country]
```

Examples:
- `Brand — Exact — NL`
- `NB — Running Shoes — Phrase — NL`
- `PMax — Feed-Only — High Margin — NL`
- `Shop — All Products — NL`

**Ad group organisation (Search):**

Segment Search ad groups by intent, not product category:

| Ad Group Theme | Example keywords | Goal |
|---------------|-----------------|------|
| Brand | `[brand name]`, `[brand name] shop` | Protect brand, low CPC |
| Category (non-brand) | `buy running shoes`, `running shoes online` | Volume |
| Competitor | `[competitor] alternative` | Conquest (optional, tread carefully) |
| Long-tail product | `nike air max 90 size 42` | High intent, lower competition |

**Shopping / PMax segmentation logic:**

Segment products by one of these axes (not all at once):

1. **Margin tier** (via custom labels) — high/medium/low — allows different tROAS targets per group
2. **Category** — separate asset groups per product type (footwear, apparel, accessories)
3. **Bestseller vs long-tail** — protect top-10 SKUs from dilution by low-performers

%%fact-check: custom label support in feed-only PMax via Merchant Center supplemental feeds — verified 2026-04-03%%

---

## 4. Bidding Strategy

**Recommended path:**

```
Maximize Clicks (cold start, manual CPC floor)
  → Maximize Conversion Value (once 20+ purchases/month)
  → tROAS (once 50+ purchases/month, stable for 4+ weeks)
  → Portfolio tROAS (mature accounts, multiple campaigns)
```

**tROAS target-setting:**

Set initial tROAS at 10-20% below your current achieved ROAS. Aggressive targets starve campaigns of traffic. Example: if current ROAS is 5x, set tROAS at 400% initially.

**Typical benchmarks (NL/EU e-commerce, 2025):**

%%fact-check: EU e-commerce Google Ads benchmarks — sourced from Google Ads Benchmark Report 2024, Wordstream 2024 industry data — verified 2026-04-03%%

| Metric | Low | Typical | Strong |
|--------|-----|---------|--------|
| CTR (Shopping) | 0.5% | 1.5-3% | 4%+ |
| CTR (Search, non-brand) | 2% | 4-6% | 8%+ |
| CVR (all traffic) | 0.5% | 1-3% | 4%+ |
| ROAS | 2x | 3-6x | 8x+ |
| CPC (Shopping) | €0.15 | €0.30-€0.80 | — |
| CPC (Search, non-brand) | €0.40 | €0.60-€1.50 | — |

> [!info] Margin vs Revenue ROAS
> ROAS of 4x on a 25% margin product = 1x return on cost of goods. Always calculate **margin ROAS** (revenue × margin % ÷ spend) alongside gross ROAS. A 6x ROAS on a 15% margin product breaks even at the ad spend level.

---

## 5. Conversion Tracking

**What to track:**

| Event | Priority | Tracking Setup |
|-------|----------|---------------|
| `purchase` with `value` and `transaction_id` | Critical | GTM dataLayer → sGTM → Google Ads conversion |
| `add_to_cart` | Secondary (audience) | GTM event → GA4 only (do not import to Google Ads) |
| `view_item` | Audience signal only | GTM event → GA4 for remarketing audiences |
| `begin_checkout` | Secondary (audience) | GTM event → GA4 only |

> [!danger] Never Optimise on Micro-Conversions
> Setting `add_to_cart` as a Google Ads conversion action and bidding toward it trains Smart Bidding to maximise add-to-carts — often soft, window-shopping traffic that never purchases. Always bid on `purchase` only. Use micro-conversions in GA4 for funnel analysis.

**Deduplication:** Always pass `transaction_id` in the purchase event. Without it, page reloads and cross-device journeys cause duplicate conversions, inflating ROAS.

%%fact-check: transaction_id deduplication in Google Ads enhanced conversions — verified 2026-04-03%%

**Attribution model:**

- Use **data-driven attribution** (DDA) once you have 300+ conversions/month. DDA distributes credit based on Google's ML model of your actual conversion paths.
- Below 300 conversions/month, use **last click** — DDA becomes unreliable with thin data.
- For tracking specialists: the sGTM pipeline should pass `gclid` and session source data to BigQuery for independent attribution analysis alongside Google's model.

Cross-ref: [[conversion-actions]], [[enhanced-conversions]]

---

## 6. Audience Strategy

**Priority audiences:**

| Audience | Type | Use |
|----------|------|-----|
| Past purchasers (30d) | Customer Match / RLSA | Bid up, exclude from prospecting if margin is tight |
| Cart abandoners (7d) | RLSA / Demand Gen | Remarketing — high intent |
| Product viewers (14d) | GA4 remarketing | Mid-funnel retargeting |
| Customer list (all-time) | Customer Match | Exclusion from prospecting or lookalike seed |
| Similar audiences | Auto-generated | Prospecting expansion |

%%fact-check: Customer Match availability for all Google Ads advertisers (not just large spenders) — verified 2026-04-03%%

**Remarketing approach:**

Dynamic remarketing is the standard: show the exact products a visitor viewed. Requires:
1. `view_item` events pushing `item_id` to the dataLayer
2. Google Ads dynamic remarketing tag (or sGTM equivalent) capturing item IDs
3. Merchant Center feed with matching `id` values

For tracking specialists: sGTM is the correct place to fire the dynamic remarketing call — it keeps the Merchant Center item ID mapping server-side and avoids third-party cookie dependency.

---

## 7. Common Mistakes

> [!failure] Mistake 1 — Running PMax and Standard Shopping with overlapping products
> PMax takes auction priority over Standard Shopping. When both target the same products, Standard Shopping starves of impressions and looks like it is underperforming. Solution: segment products cleanly — either full PMax with Standard Shopping as exclusion-based catch-all, or Standard Shopping only.

> [!failure] Mistake 2 — Not using custom labels for margin segmentation
> Without custom labels, a tROAS campaign treats a 10% margin product identically to a 40% margin product. Set up a supplemental feed with `custom_label_0` = `high` / `medium` / `low` margin, then run separate PMax campaigns (or asset groups) with different tROAS targets per tier.

> [!failure] Mistake 3 — Ignoring feed quality
> Shopping and feed-only PMax get their keywords from your product titles. A title like "Blue T-shirt XL" will not match `mens blue cotton t-shirt size xl` — you lose impressions to competitors with better titles. Feed title formula: `[Brand] [Gender] [Product Type] [Key Attribute] [Size/Colour]`.

> [!failure] Mistake 4 — Setting aggressive tROAS too early
> Setting tROAS above achieved ROAS immediately after switching from Maximize Conversion Value throttles traffic and sends the campaign into a death spiral. The algorithm needs room to learn. Start 10-20% below actual ROAS.

> [!failure] Mistake 5 — Not tracking actual purchase value
> Many setups send a fixed conversion value (e.g., €1) instead of the actual order value. This makes value-based bidding meaningless — the algorithm cannot distinguish a €20 order from a €500 order. Always pass `value` dynamically from the dataLayer.

---

## 8. KPI Benchmarks

These are orientation ranges, not guarantees. Category, price point, and competition vary significantly.

%%fact-check: e-commerce Google Ads CTR, CVR, ROAS benchmarks — sourced from Wordstream 2024, Google Ads Transparency Center category data — verified 2026-04-03%%

| KPI | Weak | Average | Strong | Notes |
|-----|------|---------|--------|-------|
| Shopping CTR | < 0.5% | 1-3% | 4%+ | High CTR with low CVR = wrong query match |
| Search CVR | < 0.5% | 1-3% | 5%+ | Benchmark against category, not industry average |
| ROAS (blended) | < 2x | 3-6x | 8x+ | Always calculate on revenue ex-VAT |
| ROAS (Shopping only) | < 3x | 4-8x | 12x+ | Shopping should outperform non-brand Search |
| CPC (Shopping, NL) | — | €0.30-€0.80 | — | Fashion/luxury can reach €3+ |
| CPC (NB Search, NL) | — | €0.60-€1.50 | — | |
| Impression share (IS) | < 40% | 50-70% | 80%+ | Low IS + low budget = expand; low IS + enough budget = bid/quality issue |

---

## 9. Seasonal Patterns

E-commerce has the strongest seasonal swings of any Google Ads vertical. Plan budget and bids around these peaks.

| Period | Typical Impact | Action |
|--------|---------------|--------|
| **Q4 Oct–Dec** | +30-60% revenue for many stores | Increase budgets from mid-Oct; peak Black Friday week; taper post-Christmas |
| **Black Friday week** | Single highest revenue week of the year for most | Pre-load budget 7 days before; raise tROAS ceiling; pause low-margin campaigns |
| **Valentine's Day** (Feb) | +15-25% for gifts, jewellery, flowers | Start 2 weeks before |
| **Moederdag / Mother's Day** (May) | +10-20% for gifts, flowers, experiences | Start 2 weeks before |
| **Summer** (Jul–Aug) | -10-20% for apparel (except swimwear), -30% B2C electronics | Reduce bids; shift budget to evergreen |
| **Back to school** (Aug–Sep) | +15-25% for stationery, bags, tech | Start early Aug |
| **January sales** | +10-20% for clearance categories | Budget ready for Jan 2 |

> [!tip] Black Friday Budget Planning
> Do not simply add 50% to your daily budget on Black Friday. Google can overspend daily budgets by 2x. Instead: raise daily budgets on Oct 15 and let the algorithm accrue the learning period before the peak. Lower aggressive tROAS targets 5-7 days before Black Friday to allow the algorithm room to spend.

---

## 10. Cross-references

| Topic | Document |
|-------|----------|
| Feed-only PMax setup | [[pmax/feed-only-pmax]] |
| Feed optimisation | [[pmax/feed-optimization]] |
| PMax asset requirements | [[pmax/asset-requirements]] |
| Shopping campaign structure | [[shopping-campaigns]] |
| Account maturity model | [[account-profiles]] |
| Bidding strategy selection | [[bidding-strategies]] |
| Conversion action setup | [[conversion-actions]] |
| Enhanced conversions | [[enhanced-conversions]] |
| Audit checklist | [[audit/audit-checklist]] |
| Common mistakes (all verticals) | [[audit/common-mistakes]] |

---

## Further Reading

- [Google Merchant Center product data specification](https://support.google.com/merchants/answer/7052112) — official feed attribute reference
- [Google Ads Performance Max best practices guide](https://support.google.com/google-ads/answer/11396178) — Google's official PMax guidance
- [Wordstream Google Ads Industry Benchmarks 2024](https://www.wordstream.com/blog/ws/2016/02/29/google-adwords-industry-benchmarks) — CTR, CVR, CPA by industry
- [Think with Google — Retail Insights](https://www.thinkwithgoogle.com/intl/en-emea/consumer-insights/consumer-trends/retail/) — EU shopper behaviour data
- [Smarter Ecommerce (SMEC) PMax feed guide](https://www.smec.com/en/blog/performance-max-product-feed/) — feed optimisation deep-dive for PMax
