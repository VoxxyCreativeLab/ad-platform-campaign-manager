---
title: Feed-Only PMax (Merchant Center Product Feed, No Creative Assets)
date: 2026-04-01
tags:
  - reference
  - google-ads
  - pmax
---

# Feed-Only PMax

PMax campaign linked to a Merchant Center product feed with **no custom creative assets** in the asset groups. Google auto-generates all ad creatives from the product feed data (titles, images, prices, descriptions). Sometimes called "PMax for retail" or "PMax without assets." This is the spiritual successor to Smart Shopping campaigns.

> [!abstract] Industry Data (SMEC, 4,000+ campaigns, 500+ accounts, 2025)
> **90% of PMax spend goes to feed-based ads** (range: 74-97%). Feed quality is the single biggest lever for PMax retail performance. Campaigns need 30+ conversions/month minimum, 60+ ideal. ROAS targets: median rose from 4.7 to 6.0. Campaigns typically achieve 95-116% of stated targets.
>
> On feed-only vs full-asset: *"there is little-to-no downside of using a feed-only campaign and little-to-no upside of using a full-asset campaign"* — Mike Ryan, SMEC. The choice is strategic (account structure, asset availability, preventing self-competition), not performance-driven.

## When to Use Feed-Only PMax

| Scenario | Recommendation |
|----------|---------------|
| E-commerce, no creative team, want multi-channel reach | **Feed-only PMax** |
| E-commerce, have video/image assets, want brand control | Full PMax (with creative assets) |
| E-commerce, want product-level bidding control | Standard Shopping |
| E-commerce, limited budget (<€20/day) or testing phase | Standard Shopping |
| E-commerce, small catalog (<50 products) | Feed-only PMax or Standard Shopping |
| E-commerce, want to reduce PMax interference with Search | Feed-only PMax (fewer non-Shopping surfaces) |
| Services / lead gen, no product catalog | Full PMax (creative required) or Search |

> [!tip] Rule of Thumb
> If the client has a healthy Merchant Center feed and no creative team, feed-only PMax is the default starting point. Since 90% of PMax spend goes to feed-based surfaces anyway, adding creative assets has diminishing returns unless you specifically need better YouTube or Display presence.

## What Google Auto-Generates From Your Feed

| Ad Surface | What Gets Generated | Source Data |
|-----------|--------------------|-----------  |
| Shopping (Search + Shopping tab) | Product listing ads with image, title, price | `title`, `image_link`, `price`, `availability` |
| Search (text ads) | Responsive text ads from product info | `title`, `description`, `price`, `brand` |
| Display Network | Product cards assembled from feed images | `image_link`, `title`, `price` |
| YouTube | Auto-generated slideshow from product images | `image_link`, `title` (lowest quality surface) |
| Gmail | Product promotion cards | `image_link`, `title`, `price`, `sale_price` |
| Discover | Visual product cards | `image_link`, `title`, `price` |

> [!warning] YouTube Auto-Generated Quality
> Auto-generated YouTube ads from product images are often poor. For Shopping and Search surfaces (where 90% of spend goes), auto-generation works well. For YouTube, consider adding at least one custom video as your catalog grows. This is an incremental improvement, not a launch blocker.

## Minimum Viable Setup

### Prerequisites
1. Google Merchant Center account with active product feed (no disapprovals blocking >10% of products)
2. Merchant Center linked to Google Ads account (see Account Linking below)
3. Primary conversion action configured in Google Ads
4. At least 15 active products in the feed (fewer products = fewer signals for Google's AI)
5. Recommended minimum daily budget: €20/day (for meaningful learning signals)

### Step-by-Step: Create Feed-Only PMax Campaign

**From Google Ads UI:**

1. **Campaigns → + New campaign**
2. **Objective:** Sales (or Leads if applicable)
3. **Campaign type:** Performance Max
4. **Select Merchant Center account** — this prompt appears automatically if an MC account is linked. Select it.
5. **Feed label / country of sale** — select the feed and target country. The `feed_label` field in the API replaces the deprecated `sales_country` field.
6. **Campaign name:** Follow naming convention: `PMax | Feed-Only | [Category/Brand] | [Region]`
7. **Budget:** Set daily budget (minimum €20/day recommended)
8. **Bid strategy:** Maximize Conversion Value (recommended for e-commerce — drives higher revenue) or Maximize Conversions (if starting fresh with no ROAS data)

### Asset Group Configuration (Feed-Only)

9. **Asset group name:** Name by product segment (e.g., "Running Shoes" or "High-Margin Products")
10. **Listing group:** Configure product filter (see Listing Groups section below) — this controls WHICH products from your feed appear in this asset group
11. **Creative assets:** Skip images and video. Optionally add:
    - Text assets: 3+ headlines (30 chars), 1+ long headline (90 chars), 2+ descriptions (90 chars) — recommended for better Search text ads
    - Logo: 1 square logo — recommended for brand consistency on Display/YouTube
    - Business name: required (25 chars)
12. **Audience signals:** Configure per asset group (see [[audience-signals]])
13. **Final URL expansion:** Enable (lets Google find relevant landing pages from your site)

> [!info] Assets Are Optional for Retail PMax
> Google's API documentation confirms: assets are not mandatory for retail PMax campaigns. Automatic asset generation occurs when a Merchant Center feed is linked. However, "the more assets you provide, the more ad formats the system can create." Start without, add incrementally.

### Post-Launch

14. **Brand exclusions:** Add brand terms to prevent cannibalizing brand Search campaigns
15. **Negative keywords:** Up to 10,000 per campaign + shared lists. Apply to Search and Shopping inventory.
16. **Monitoring:** Allow 2-4 weeks learning period before making changes
17. **Iteration:** Add creative assets incrementally — text first, then images, then video

**From Merchant Center Next UI:**

1. **MC Next dashboard → Performance tab** (or "Boost performance" banner if shown)
2. **"Create campaign"** — this links to Google Ads campaign creation with your MC feed pre-selected
3. **PMax is auto-selected** as campaign type with your feed pre-configured
4. Continue from step 5 above (feed label, campaign name, budget, bid strategy)

> [!info] MC Next Shortcut
> Creating from Merchant Center Next auto-selects PMax with your feed. It's the fastest path if you're starting from scratch. The feed and Merchant Center account are pre-linked — no manual configuration needed.

## Listing Groups — The Missing Piece

### What Are Listing Groups?

Listing groups are the **PMax equivalent of Shopping campaign product groups**. They control which products from your Merchant Center feed appear in which asset group. Without proper listing group configuration, ALL products dump into a single bucket — defeating the purpose of asset group segmentation.

**Critical difference from Shopping:** PMax listing groups are for **inclusion/exclusion only** — they do NOT set bids (unlike Shopping product groups where you bid per group). PMax handles bidding automatically via its AI. Listing groups just filter which products go where.

### Listing Group Structure

```
Asset Group: "Running Shoes"
└── Listing Group Filter (AssetGroupListingGroupFilter)
    └── All Products (root SUBDIVISION node)
        ├── google_product_category = "Athletic Shoes > Running" (UNIT — included)
        └── Everything else (UNIT — excluded, "Other" node)
```

### Node Types

- **Subdivision nodes** — organizational layers that branch into children. Every subdivision MUST have a complete set of children including an "Other" node. Cannot be leaf nodes.
- **Unit nodes** — leaf nodes where inclusion/exclusion is applied. A product must fall into exactly one unit node across the tree.

### Available Dimension Types

Verified against Google Ads API `AssetGroupListingGroupFilter`:

| Dimension | API Type | What It Filters | Example |
|-----------|----------|----------------|---------|
| Brand | `ProductBrandInfo` | Product brand from feed | Nike, Adidas |
| Category | `ProductCategoryInfo` | Google product category taxonomy | "Apparel > Shoes > Athletic" |
| Channel | `ProductChannelInfo` | Distribution channel | Online, Local |
| Condition | `ProductConditionInfo` | Product condition | New, Used, Refurbished |
| Custom attribute | `ProductCustomAttributeInfo` | Custom labels 0-4 from feed | margin_high, seasonal, bestseller |
| Item ID | `ProductItemIdInfo` | Individual product SKU | SKU-12345 |
| Product type | `ProductTypeInfo` | Your custom product type hierarchy | "Shoes > Running > Trail" |

> [!tip] Groups Over Individuals
> Google's API docs state listing groups work "best when targeting groups of products" via dimensions like custom labels and brand, rather than individual item IDs. Use item ID targeting sparingly — for hero products only.

### How to Configure Listing Groups

1. **In asset group editor → Listing groups section**
2. **Default:** "All products" (entire feed) — this is what you get if you don't touch it
3. **Subdivide:** Click the pencil/edit icon → choose subdivision attribute from the 7 dimensions above
4. **Include/Exclude:** After subdividing, toggle which values to include in this asset group
5. **"Other" node:** Always created automatically — catches products not matching any explicit filter
6. **Multiple asset groups:** Each asset group gets its OWN listing group filter. Products should NOT overlap between asset groups (causes internal competition).

### Listing Group Strategies

| Strategy | Dimension | When to Use | Example |
|----------|-----------|-------------|---------|
| By margin tier | `ProductCustomAttributeInfo` (custom_label_0) | Different ROAS targets per margin | High-margin → aggressive ROAS, low-margin → conservative |
| By product category | `ProductCategoryInfo` | Category-specific audience signals | "Running Shoes" asset group with in-market for running audience |
| By brand | `ProductBrandInfo` | Separate own brand vs third-party | Own brand with higher ROAS target, third-party with lower |
| By performance | `ProductCustomAttributeInfo` (custom_label_2) | Isolate bestsellers from long tail | Bestsellers get own budget, long tail grouped |
| Hero products | `ProductItemIdInfo` | Spotlight top sellers individually | Top 10 SKUs each in own asset group |
| By condition | `ProductConditionInfo` | Separate new vs clearance | New products → full price, refurbished → clearance messaging |

> [!tip] Custom Labels Are Your Power Tool
> Custom labels (`custom_label_0-4`) in the Merchant Center feed are the most flexible segmentation tool. Use them to encode business logic (margin tier, seasonality, performance tier, price range, priority) that Google's default dimensions don't capture. See [[feed-optimization]] for custom label setup.

## Optional Assets — What to Add and When

| Asset Type | Effort | Impact | When to Add |
|-----------|--------|--------|-------------|
| Business name | 1 min | Required | Always (required field) |
| Logo (square) | 5 min | Medium — brand consistency | Always recommended |
| Text headlines/descriptions | 15 min | Medium — better Search text ads | First optimization pass |
| Images | 30+ min | High — better Display/Discovery | When creative resources available |
| Video | 1+ hour | High — much better YouTube | When any video asset exists |

**Priority order for incremental improvement:**
1. Logo + business name (launch)
2. Text assets — 5 headlines, 1 long headline, 2 descriptions (week 1)
3. Product lifestyle images (month 1)
4. Short video — even a 15s product slideshow (month 2)

## Feed-Only vs Full PMax Behavior

| Surface | Feed-Only PMax | Full PMax (with assets) |
|---------|---------------|------------------------|
| Shopping (Search + tab) | Identical — both use feed data | Identical |
| Search text ads | Auto-generated from feed titles/descriptions | Your custom headlines/descriptions |
| Display Network | Auto-assembled from product images | Your designed creative + feed |
| YouTube | Auto-generated slideshow (lowest quality) | Your custom video |
| Gmail | Auto-assembled product cards | Your creative + feed |
| Discover | Auto-assembled visual cards | Your creative + feed |

**Key takeaway:** Shopping surface (where 90% of spend goes for e-commerce) is identical. The difference is in non-Shopping surfaces where auto-generated creative has lower quality — but these represent only 3-26% of spend.

## Account Restructuring: Shopping+PMax → Clean Feed-Based PMax

### When to Restructure

- Multiple Shopping and PMax campaigns competing for the same products
- Product groups overlap between Shopping and PMax (cannibalizing each other)
- No clear structure — campaigns were added incrementally without strategy
- Performance is flat or declining despite healthy feed and budget

> [!info] Priority Change (Late 2024)
> Since late 2024, PMax is **no longer automatically prioritized over Standard Shopping** in ad auctions. Both campaign types now compete on equal footing based on Ad Rank (Bid × Quality Score). This means running Shopping alongside PMax is a viable strategy — restructuring to PMax-only is a choice, not a necessity.
>
> Recommended split if running both: **70/30 or 80/20 ratio** favoring PMax. Master PMax first before implementing hybrid approaches.

### Assessment Phase (Before Changing Anything)

1. **Inventory all campaigns:** List every Shopping and PMax campaign with status, daily budget, and product scope
2. **Map product overlap:** Identify which products appear in multiple campaigns (use product group reports)
3. **Pull 90-day performance:** By campaign and by product segment — ROAS, conversions, spend, impression share
4. **Identify the winner:** Which campaign type drives better ROAS per product segment?
5. **Check feed health:** Run MC diagnostics — disapprovals, warnings, feed freshness
6. **Check conversion volume:** Does the account have 30+ conversions/month? 60+ ideal for PMax.

### Design Phase

1. **Define new PMax campaign structure** — typically 1-3 campaigns:
   - By margin tier: High-margin products, standard-margin, clearance
   - By category: If product categories have very different audiences
   - Single campaign: If catalog is small (<200 products) or performance is uniform
2. **Map listing groups to asset groups** — each asset group gets a non-overlapping product filter using the 7 dimension types
3. **Set audience signals per asset group** — match audience to product segment
4. **Decide asset level:** Feed-only to start, or add text/images if available
5. **Plan negative keyword carry-over** — export negatives from old Shopping campaigns, apply at campaign level (up to 10,000) or via shared lists

### Migration Phase (Stepwise — Never Cold Turkey)

1. **Create new feed-only PMax campaigns (PAUSED)**
2. **Configure listing groups** matching your design — verify no product overlap between asset groups
3. **Add audience signals** and optional text assets
4. **Pause old Shopping campaigns** for the product segments that overlap with new PMax
5. **Enable new PMax campaigns**
6. **Monitor 2-4 weeks** — this is the learning period. Do NOT make changes.
7. **After stabilization:** Pause remaining old campaigns. Adjust ROAS/CPA targets based on 4-week data.

### Rollback Plan

- **Keep old campaigns PAUSED, not deleted**, for 30 days minimum
- If new PMax underperforms after 4 full weeks, re-enable old campaigns
- Compare **total account ROAS** before/after — not just campaign-level (PMax may shift conversions between surfaces)
- Products graduating from Shopping back to PMax should have statistically significant data (50+ clicks or recent conversions)

> [!warning] Do Not Delete Old Campaigns
> Paused campaigns retain their historical data and quality signals. Deleting them means starting from zero if you need to roll back.

## Account Linking: Merchant Center ↔ Google Ads

### From Merchant Center Next
1. **Settings → Linked accounts → Google Ads**
2. Enter the Google Ads customer ID (xxx-xxx-xxxx)
3. Send link request

### From Google Ads
1. **Tools & Settings → Setup → Linked accounts → Google Merchant Center**
2. Find the MC account → Accept link request (or send one)

### Verification
- Both sides must confirm the link
- One MC account can link to multiple Google Ads accounts
- One Google Ads account can link to multiple MC accounts
- After linking: campaigns can access the feed within ~24 hours
- API field: `ShoppingSetting.merchant_id` must match the linked MC account

## Cross-References

- [[feed-optimization]] — feed attribute optimization, custom labels, supplemental feeds
- [[asset-requirements]] — full PMax creative asset specs (when adding assets to a feed-only campaign)
- [[audience-signals]] — audience signal configuration per asset group
- [[../../shopping-campaigns]] — standard Shopping campaign reference
- [[../../campaign-types]] — campaign type decision tree
- [[../../bidding-strategies]] — bid strategy selection

## External Sources

### Official Google Documentation
- [Create PMax in Merchant Center](https://support.google.com/merchants/answer/12453202) — MC Next campaign creation flow
- [Listing Groups for Retail](https://developers.google.com/google-ads/api/performance-max/listing-groups) — API reference: 7 dimension types, tree rules, subdivision/unit nodes
- [PMax for Online Sales with Product Feed](https://developers.google.com/google-ads/api/performance-max/retail) — ShoppingSetting fields, retail campaign config
- [Manage PMax Listing Groups](https://support.google.com/google-ads/answer/11596074) — UI-level listing group management
- [PMax Optimization with MC Feed](https://support.google.com/google-ads/answer/13776350) — Google's own feed-based PMax optimization tips
- [PMax Negative Keywords](https://support.google.com/google-ads/answer/15726455) — 10,000 per campaign + shared lists
- [Retail Campaign Reporting](https://developers.google.com/google-ads/api/performance-max/retail-reporting) — GAQL queries, cart data metrics

### Code Samples
- [add_performance_max_retail_campaign.py](https://github.com/googleads/google-ads-python/blob/main/examples/shopping_ads/add_performance_max_retail_campaign.py) — Google's canonical Python example for feed-based PMax with listing groups
- [Add PMax Product Listing Group Tree](https://developers.google.com/google-ads/api/samples/add-performance-max-product-listing-group-tree) — Multi-language listing group filter examples

### Industry Research
- [SMEC: State of PMax 2025](https://smarter-ecommerce.com/blog/en/google-ads/state-of-performance-max-campaigns-2025/) — 4,000+ campaigns, 500+ accounts: 90% spend is feed-based, conversion thresholds, ROAS benchmarks
- [SMEC: PMax FAQ 2025](https://smarter-ecommerce.com/blog/en/google-ads/pmax-2025-faq-campaign-setup-brand-strategies-performance/) — Feed-only vs full-asset verdict (Mike Ryan)
- [SMEC: Shopping Alongside PMax 2026](https://smarter-ecommerce.com/blog/en/google-ads/how-to-run-google-shopping-alongside-performance-max-in-2026/) — Priority change late 2024, 70/30 split recommendation

### Tools
- [google/pmax_best_practices_dashboard](https://github.com/google/pmax_best_practices_dashboard) — Looker Studio + BQ dashboard with retail upgrade script
- [google-marketing-solutions/feedgen](https://github.com/google-marketing-solutions/feedgen) — AI feed optimization via Vertex AI
