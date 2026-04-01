---
title: Shopping Campaigns
date: 2026-03-31
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

### Shopping vs PMax with Feed

| Factor | Standard Shopping | PMax with Feed |
|--------|-------------------|----------------|
| Control | High — manual bids, negatives, product groups | Low — Google AI manages everything |
| Reporting | Granular — product, query, device level | Limited — asset group level only |
| Reach | Shopping tab + Search only | All Google channels (Search, Display, YouTube, Gmail, Discover) |
| Negatives | Supported | Account-level only (no campaign negatives) |
| Best for | Experienced advertisers wanting control | Maximizing reach with minimal management |

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
| Enhanced CPC | Transitional — manual CPC with Google's auto-adjustment |
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

### Negative Keywords

- Shopping campaigns support negative keywords (unlike PMax)
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

## Related

- [[campaign-types]] — campaign type comparison and decision tree
- [[conversion-actions]] — conversion action setup
- [[gtm-to-gads]] — client-side tracking implementation
- [[bidding-strategies]] — bid strategy selection guide
- [[negative-keyword-lists]] — pre-built negative keyword lists
