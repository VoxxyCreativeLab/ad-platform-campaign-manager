---
title: Shopping Feed Strategy
date: 2026-04-03
tags:
  - reference
  - google-ads
---

# Shopping Feed Strategy

Strategic feed management for Shopping and PMax campaigns — feed architecture decisions, multi-market feeds, automation, diagnostics, and quality scoring. For attribute-level optimization and title formulas, see [[pmax/feed-optimization]].

%%fact-check: All feed specifications verified against Google Merchant Center Help and Merchant API documentation — 2026-04-03%%

## Decision Tree

```
What feed challenge are you solving?
├── Starting from scratch
│   ├── Single market → Standard primary feed (manual upload or scheduled fetch)
│   └── Multiple markets → One primary feed per country-language pair
├── Feed exists but performance is poor
│   ├── Disapprovals > 5% → Fix diagnostics first (see Feed Health Scoring)
│   ├── Low impression share → Title and attribute optimization (see [[pmax/feed-optimization]])
│   └── Wrong products showing → Custom labels + product exclusions
├── Need to add data without touching primary feed
│   └── Supplemental feed (custom labels, title overrides, promotions)
├── Need real-time updates
│   └── Merchant API push or Content API (sunsets Aug 2026)
└── Multi-channel (online + local)
    └── Separate product IDs per channel (required since March 2026)
```

## Feed Architecture

### Feed Types

| Feed Type | Purpose | Update Method | When to Use |
|---|---|---|---|
| **Primary feed** | Core product data — all required attributes | Scheduled fetch (URL), upload (SFTP/GCS), or API | Every account — the foundation |
| **Supplemental feed** | Override or add attributes to primary feed products | Same as primary, matched by `id` | Add custom labels, override titles, add sale prices without touching primary |
| **Feed rules** | Transform attributes in Merchant Center (regex, concatenation, mapping) | Configured in MC UI | Fix formatting issues, standardize values, combine attributes |
| **Promotions feed** | Structured promotion data (% off, BOGO, free shipping) | Scheduled fetch or upload | When running merchant promotions — displays promotion badge in Shopping ads |
| **Local inventory feed** | In-store availability and pricing | API push or scheduled fetch | Brick-and-mortar retailers with local inventory ads |

> [!tip] When to Use Supplemental vs Feed Rules
> **Supplemental feeds** add or replace entire attribute values. **Feed rules** transform existing values (e.g., prepend brand to title, map categories). Use supplemental feeds when you have external data to inject (margin tiers, seasonal labels). Use feed rules when the data exists in the primary feed but needs reformatting.

### Multi-Market Feed Architecture

For advertisers selling across multiple countries or languages:

| Scenario | Architecture | Notes |
|---|---|---|
| Same products, same language, multiple countries | One feed, multiple country targets in MC | E.g., US + CA + UK (English) |
| Same products, different languages | One feed per language with translated titles/descriptions | E.g., NL + DE + FR require separate feeds |
| Different product availability per country | Separate feeds per country | Different `availability`, `price`, `shipping` per market |
| Multi-currency | Automatic currency conversion OR separate feeds | MC supports auto-conversion but manual is more accurate |

%%fact-check: Merchant Center automatic currency conversion — available for Shopping ads; converts to local currency using Google Finance rates — verified 2026-04-03%%

> [!warning] Product ID Split — March 2026
> Products sold across multiple channels (online + local) now require separate product IDs per channel. If you sell the same SKU online and in-store with different prices or availability, use `online:en:NL:SKU-123` and `local:en:NL:SKU-123` format. Mismatched IDs break conversion attribution. See [[shopping-campaigns#Merchant Center Transitions]].

## Feed Automation

### Update Frequency

| Business Type | Recommended Frequency | Method |
|---|---|---|
| Small catalog (<500 SKUs), stable prices | Daily scheduled fetch | URL fetch from e-commerce platform |
| Medium catalog, regular price changes | Every 6 hours | Scheduled fetch or SFTP |
| Large catalog (10K+ SKUs), dynamic pricing | Every 1-4 hours | API push (Merchant API) |
| Flash sales, time-sensitive inventory | Real-time | Merchant API push on inventory change |

> [!info] Content API Sunset
> Content API for Shopping sunsets **August 18, 2026**. Migrate to Merchant API v1. If your feed pipeline uses Content API endpoints, plan migration now — see [[shopping-campaigns#Merchant Center Transitions]].

### Automation Pipeline

```
E-commerce platform (WooCommerce / Shopify / Magento / custom)
    │
    ├── Option A: Scheduled fetch (URL)
    │   └── MC fetches from a public URL on your schedule
    │
    ├── Option B: SFTP / GCS upload
    │   └── Server-side script generates feed → uploads to SFTP/GCS
    │
    ├── Option C: Merchant API push
    │   └── Server-side script pushes product updates via API
    │
    └── Option D: sGTM-enriched pipeline
        └── sGTM captures product data → writes to BigQuery → BigQuery export to MC
            (see [[../../tracking-bridge/sgtm-to-bq]] for implementation)
```

> [!tip] Tracking Specialist Advantage
> Option D (sGTM pipeline) lets you enrich product data with behavioural signals before it reaches Merchant Center. For example, you can add conversion rate tiers as custom labels — products with >5% CVR get `custom_label_2 = bestseller`. This enables bid differentiation at the product level based on actual performance data, not just margin or category.

## Feed Health Scoring

Rate feed quality on these dimensions. A score below 70% on any dimension needs immediate attention.

| Dimension | Weight | How to Measure | Target |
|---|---|---|---|
| **Disapproval rate** | 25% | Disapproved items / total items | < 2% |
| **Attribute completeness** | 20% | Required + recommended attributes populated | > 95% required, > 80% recommended |
| **Title quality** | 20% | Follows Brand + Product + Feature + Variant formula | 100% of top-50 revenue products |
| **Image quality** | 15% | Min 800x800, white background, no watermarks | > 95% compliant |
| **Price accuracy** | 10% | Feed price matches landing page price | 100% — mismatches cause disapproval |
| **GTIN coverage** | 10% | Products with valid GTIN / total branded products | > 90% for branded products |

### Merchant Center Diagnostics

Check these MC tabs weekly:

| Tab | What to Look For |
|---|---|
| **Diagnostics** | Item-level issues: disapprovals, warnings, demotions |
| **Price competitiveness** | Your prices vs market — products priced 20%+ above market get fewer impressions |
| **Best sellers** | Top products in your category — identify gaps in your catalog |
| **Shipping settings** | Delivery speed and cost vs competitors — affects ad rank |

## Product Exclusions

Not every product should be advertised. Exclude products that waste budget:

| Exclude When | Method |
|---|---|
| Out of stock | Set `availability = out_of_stock` (MC auto-excludes) |
| Negative margin after ad cost | Add `custom_label = exclude` → exclude in campaign product groups |
| Low price (< EUR 10) | Custom label filter — CPC often exceeds margin |
| Seasonal products out of season | Custom label `seasonal = off-season` → pause in campaigns |
| Products with policy violations | Fix the violation or exclude to protect account health |

> [!warning] Account Health
> Persistent disapprovals (>10% of catalog) can trigger account-level penalties: reduced impression share, manual review, or suspension. Fix disapprovals before scaling spend.

## Common Mistakes

| Mistake | Impact | Fix |
|---|---|---|
| Feed updates only weekly | Stale prices/availability → disapprovals, wasted clicks | Increase to daily minimum; 4-6 hours for dynamic pricing |
| No supplemental feed | Can't add custom labels or override titles without platform changes | Create a supplemental feed in Google Sheets or CSV for quick overrides |
| Ignoring feed diagnostics | Disapprovals accumulate silently → lost revenue | Weekly MC diagnostics review; alert on disapproval rate > 2% |
| Same feed for all markets | Wrong currency, language, or availability per country | Separate feeds per country-language pair |
| Missing GTINs for branded products | Lower ad rank, fewer auction wins vs competitors with GTINs | Source GTINs from manufacturers; use GS1 database |
| Title stuffing with keywords | Unreadable titles, potential MC policy violation | Follow Brand + Product + Feature + Variant formula; no promotional text |
| No product exclusions | Budget spent on unprofitable products | Tag low-margin, low-price products with custom labels; exclude from campaigns |

## Vertical Considerations

| Vertical | Feed Priority | Key Attributes | Special Considerations |
|---|---|---|---|
| **E-commerce (general)** | Title optimization, GTIN coverage, custom labels for margin tiers | `custom_label_0` (margin), `sale_price`, `additional_image_link` | Supplement with competitor pricing data for bid optimization |
| **Fashion** | Color/size variants, high-quality lifestyle images | `color`, `size`, `size_type`, `size_system`, `age_group`, `gender` | Each variant needs its own product ID; use `item_group_id` to group |
| **Electronics** | Spec-rich titles, model numbers, GTIN mandatory | `gtin`, `mpn`, `brand`, technical specs in title | Google matches by GTIN — missing GTINs = lost auctions to competitors |
| **Food & beverage** | Freshness, expiration, local availability | `expiration_date`, `availability`, local inventory feed | Short shelf life requires high update frequency |
| **Home & furniture** | Dimensions, material, room context | `product_detail` (custom attributes), lifestyle images | Large items need shipping weight/dimensions for accurate shipping calculations |

## Related

- [[pmax/feed-optimization]] — attribute-level optimization, title formulas, custom label strategies
- [[pmax/feed-only-pmax]] — launching PMax with feed only, no creative assets
- [[shopping-campaigns]] — Shopping campaign structure, bidding, priority levels
- [[campaign-types]] — campaign type comparison and decision tree
