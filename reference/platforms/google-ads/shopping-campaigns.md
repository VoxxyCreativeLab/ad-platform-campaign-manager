---
title: Shopping Campaigns
date: 2026-04-01
tags:
  - reference
  - google-ads
---

# Shopping Campaigns

Product-feed-driven campaigns that display product images, prices, and merchant information directly in Google Search results and the Shopping tab.

## When to Use

- E-commerce businesses selling physical products
- When you have a Google Merchant Center account with an active product feed
- When product images and prices in search results matter (visual buying intent)
- When you want product-level bidding and ROAS tracking
- **Not for:** services, lead generation, or businesses without a product catalog

### Shopping vs PMax: Choosing the Right Feed-Based Campaign

| Factor | Standard Shopping | Feed-Only PMax | Full PMax (with assets) |
|--------|-------------------|----------------|------------------------|
| Creative needed | None (feed only) | None (feed only) | Images + video + text |
| Control | High — manual bids, negatives, product groups | Low — Google AI manages everything | Low — Google AI manages everything |
| Reporting | Granular — product, query, device level | Full search terms, channel-level breakdowns | Full search terms, channel-level breakdowns |
| Reach | Shopping tab + Search only | All Google channels (Search, Display, YouTube, Gmail, Discover) | All Google channels (higher quality non-Shopping surfaces) |
| Negatives | Supported | Campaign-level (up to 10,000) + shared lists | Campaign-level (up to 10,000) + shared lists |
| Auction priority | Competes on Ad Rank (since late 2024) | Competes on Ad Rank (since late 2024) | Competes on Ad Rank (since late 2024) |
| Non-Shopping ad quality | N/A | Auto-generated (lower) | Custom creative (higher) |
| Best for | Experienced advertisers wanting granular control | E-commerce without creative team, wanting multi-channel reach | E-commerce with creative resources wanting maximum brand control |

> [!tip] Starting Point for Most E-Commerce Clients
> Feed-only PMax is the default starting point when a client has a healthy Merchant Center feed but no creative team. 90% of PMax spend goes to feed-based surfaces anyway — start feed-only, add creative assets incrementally as resources allow. See [[pmax/feed-only-pmax|feed-only-pmax]] for the full setup guide.

> [!info] Smart Shopping → PMax Migration
> Google migrated Smart Shopping to Performance Max in 2022. Standard Shopping campaigns still exist and remain a strong choice when you need granular control. See [[campaign-types]] for the full comparison.

## How It Works

### Campaign Structure

```
Shopping Campaign (priority: High / Medium / Low)
└── Product Groups (subdivisions)
    ├── Brand → Nike, Adidas, ...
    ├── Category → Shoes > Running, Shoes > Casual, ...
    ├── Item ID → SKU-12345, SKU-67890, ...
    ├── Custom Label → "margin-high", "seasonal", "clearance"
    └── Product Type → from feed attribute
```

### Product Group Subdivisions

| Subdivision | Use Case |
|-------------|----------|
| Brand | Different bids per brand (own brand vs competitors) |
| Category | Google product taxonomy — broad grouping |
| Item ID | Individual SKU-level bidding (high-value products) |
| Custom Label 0-4 | Your own labels: margin tier, seasonality, priority |
| Product Type | From your feed's `product_type` attribute |
| Channel | Online vs Local inventory |
| Condition | New, Refurbished, Used |

### Feed Requirements

| Attribute | Required | Notes |
|-----------|----------|-------|
| `id` | Yes | Unique product identifier (SKU) |
| `title` | Yes | Product name — most important for matching search queries |
| `description` | Yes | Product description |
| `link` | Yes | Landing page URL |
| `image_link` | Yes | Main product image (min 100x100, rec 800x800) |
| `price` | Yes | Current price with currency |
| `availability` | Yes | `in_stock`, `out_of_stock`, `preorder` |
| `brand` | Yes* | Required for all products with a known brand |
| `gtin` | Yes* | Required for all products with a manufacturer-assigned GTIN |
| `condition` | Yes | `new`, `refurbished`, `used` |
| `sale_price` | No | Shows strikethrough original price in ads |
| `custom_label_0-4` | No | Your own grouping labels for bidding/reporting |
| `product_type` | No | Your own category hierarchy |

### Bidding Strategies

| Strategy | When to Use |
|----------|-------------|
| Manual CPC | New campaigns, small catalogs, or when you want full control |
| Target ROAS | Mature campaigns with 15+ conversions/month and consistent ROAS |
| Maximize Conversion Value | When you want maximum revenue and trust Google's bidding |

### Priority Levels (Multi-Campaign Strategy)

Run multiple Shopping campaigns for the same products at different priority levels:

| Priority | Purpose | Bid | Negatives |
|----------|---------|-----|-----------|
| High | Catch generic queries ("running shoes") | Low bid | None |
| Medium | Catch mid-intent queries ("Nike running shoes") | Medium bid | Generic negatives |
| Low | Catch high-intent queries ("Nike Air Zoom Pegasus 40") | High bid | Generic + brand negatives |

This funnels queries through priority levels — high priority catches everything first with low bids, negatives push specific queries down to lower priority campaigns with higher bids.

## Best Practices

### Feed Quality

- **Title optimization:** `[Brand] + [Product Name] + [Key Attribute] + [Size/Color]` (e.g., "Nike Air Zoom Pegasus 40 Men's Running Shoes Black Size 10")
- **GTINs:** Always include when available — Google rewards accurate product identification
- **Product categories:** Use Google's taxonomy, be as specific as possible
- **Images:** High-quality, white background, product only (no watermarks, logos, or promotional text)
- **Supplemental feeds:** Use to override specific attributes without touching the primary feed

### Campaign Structure

- Segment by margin tier using Custom Labels (high-margin products get higher bids)
- Separate brand vs non-brand campaigns if bid strategy differs
- Exclude products that aren't profitable to advertise (low price, low margin)
- Review "Products" tab regularly — fix disapproved items promptly

### Audience Exclusions

Since August 2025, Shopping campaigns support **audience exclusions**. Upload Customer Match lists or remarketing segments and exclude them at campaign level. Use this to:

- Prevent ads showing to recent purchasers (avoid "buy again" waste)
- Separate prospecting vs remarketing Shopping campaigns
- Exclude low-value customer segments

### Negative Keywords

- Shopping campaigns support negative keywords
- Add brand negatives to force queries through the priority funnel
- Exclude irrelevant queries: "free", "cheap" (if premium brand), "DIY", "repair"
- Mine the search terms report weekly for new negatives
- See [[negative-keyword-lists]] for pre-built lists

### Common Mistakes

| Mistake | Fix |
|---------|-----|
| Poor feed titles | Rewrite with keyword-rich format: Brand + Product + Attributes |
| Missing GTINs | Add GTINs for all branded products — improves matching |
| Single campaign for all products | Split by margin/priority — different products need different bids |
| Ignoring disapprovals | Check Merchant Center diagnostics weekly — disapprovals = lost revenue |
| No negative keywords | Mine search terms report — Shopping queries can be very broad |

## Tracking Implications

### Revenue Tracking

- Shopping campaigns need **purchase/transaction conversion actions** with dynamic values
- `transaction_id` is required for deduplication — without it, refreshes and re-visits create duplicate conversions
- Configure the conversion tag to pass `value`, `currency`, and `transaction_id` from the checkout confirmation page

### Merchant Center ↔ Google Ads Linking

- Merchant Center must be linked to the Google Ads account
- Product feed data flows from Merchant Center to Google Ads for ad rendering
- Conversion data flows from Google Ads back to Merchant Center for product-level reporting
- **Verify linking:** Google Ads → Tools → Linked accounts → Google Merchant Center

### Product-Level ROAS

- Shopping allows product-level conversion tracking — match conversion value to specific SKUs
- Use `item_id` dimension in reports to identify top/bottom performing products
- Cross-reference with feed margin data (via Custom Labels) to calculate true profit ROAS

### Dynamic Remarketing

- Shopping campaigns generate dynamic remarketing lists automatically
- The remarketing tag must fire on product pages and pass `ecomm_prodid` matching feed `id`
- GTM setup: use the Google Ads Remarketing tag with dynamic parameters
- See [[gtm-to-gads]] for implementation details

### Value Reconciliation

- Feed `price` ≠ actual transaction value (discounts, bundles, shipping)
- Always track actual transaction value in the conversion tag, not feed price
- Regular reconciliation: compare Google Ads reported revenue vs backend revenue
- Acceptable discrepancy: < 5%. Above that, investigate tag implementation

## Free Listings

The same Merchant Center product feed powers **free/organic product listings** across multiple Google surfaces:

| Surface | Where |
|---------|-------|
| Shopping tab | Free product listings alongside paid Shopping ads |
| Google Search | Rich product results in organic search |
| Google Images | Product listings in image search |
| Google Discover | Product cards in the Discover feed |

### Why This Matters for Tracking

- Free listings generate clicks at **zero cost** — incremental traffic from your existing feed
- **Attribution distinction:** paid Shopping clicks vs free listing clicks must be separated in reporting
- In Google Ads: free listing performance is visible under "Listing groups" → filter by "Free" vs "Paid"
- In GA4: free listing clicks appear with different `utm_medium` values — ensure your attribution model distinguishes them
- Monitor both channels: a product performing well on free listings may not need the same paid bid

### Setup

No additional setup required — if your Merchant Center feed is active and products are approved, free listings are enabled by default. Opt in/out via Merchant Center → Growth → Manage programs.

## Merchant Center Transitions

> [!warning] API Migration Deadline
> Content API for Shopping sunsets **August 18, 2026** — replaced by the Merchant API. If your feed management relies on the Content API, plan your migration now.

### Key Changes

| Change | Date | Impact |
|--------|------|--------|
| Merchant Center Next is default | Now | New UI is the default interface; classic MC still accessible but being phased out |
| Content API sunset | August 18, 2026 | All integrations using Content API must migrate to Merchant API |
| Multi-channel product ID split | March 2026 | Products sold across multiple channels (online + local) require separate product IDs per channel |

### Tracking Implications

- **Merchant API:** if you have custom feed management scripts or sGTM integrations that call the Content API, migrate to the Merchant API before the deadline
- **Product ID split:** if you sell products both online and in local inventory, ensure your tracking matches the new per-channel product IDs — mismatched IDs break conversion attribution
- **Merchant Center Next:** the new interface reorganizes reporting; update any documentation or SOPs that reference classic MC navigation

## Related

- [[campaign-types]] — campaign type comparison and decision tree
- [[conversion-actions]] — conversion action setup
- [[gtm-to-gads]] — client-side tracking implementation
- [[bidding-strategies]] — bid strategy selection guide
- [[negative-keyword-lists]] — pre-built negative keyword lists
