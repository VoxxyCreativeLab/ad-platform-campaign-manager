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

> [!important] AD STRENGTH = POOR Is Expected and Correct
> Feed-only PMax campaigns always show **AD STRENGTH = POOR** in Google Ads. This is intentional — there are no creative assets for Google to evaluate. Do not flag this as a problem, do not recommend adding assets to fix it, and do not let audit tools penalize this score. Audits, reports, and agents should identify this as feed-only first (by checking the creation path — MC-created = feed-only) before interpreting ad strength values.

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

%%fact-check: feed-only creation paths — verified 2026-04-04 via ClicksInMind, Store Growers, Search Engine Journal, AdNabu%%

> [!danger] True Feed-Only = Merchant Center Only
> As of 2025, Google Ads **requires at least 3 headlines** to save an asset group. You can no longer create a zero-asset asset group through the Google Ads UI. The only true feed-only path is via Merchant Center.

**From Merchant Center (the ONLY true feed-only path):**

1. **MC Next dashboard → Marketing → Advertising campaigns** (or Performance tab → "Boost performance" banner)
2. **"Create campaign"** — this routes to Google Ads campaign creation with your MC feed pre-selected
3. **PMax is auto-selected** as campaign type with your feed pre-configured — no asset minimums enforced
4. **Accept "All available products"** or filter by feed label / country of sale
5. **Campaign name:** Follow naming convention: `PMax | Feed-Only | [Category/Brand] | [Region]`
6. **Budget:** Set daily budget (minimum €20/day recommended)
7. **Bid strategy:** Maximize Conversion Value (recommended for e-commerce — drives higher revenue) or Maximize Conversions (if starting fresh with no ROAS data)

> [!warning] Single-Asset-Group Limitation
> The MC creation path creates **one asset group only**. You cannot add additional asset groups through MC. If you later add asset groups in Google Ads, Google enforces minimums (3+ headlines), breaking the feed-only approach for those groups. Plan your listing group strategy around this single asset group.

### Post-Creation Lockdown (Critical)

Immediately after creating the campaign, go into Google Ads and disable:

8. **Text customization / Automatically created assets → OFF** — prevents Google from auto-generating text ads
9. **Final URL Expansion → OFF** — ensures only product feed URLs are used, not random pages from your site
10. **Remove Final URL** from the asset group — so only product URLs from the feed are served
11. **Optionally** disable enhanced YouTube video generation via API: `AssetAutomationSetting.GENERATE_ENHANCED_YOUTUBE_VIDEOS` → `OPTED_OUT`

> [!info] Why the Lockdown?
> Without these steps, Google auto-generates creative from your feed data and serves it across Display, YouTube, Gmail, Discover, and even Connected TV (CTV). Since Q2 2025, 80% of PMax advertisers generate CTV impressions from auto-generated product image slideshows — many unknowingly. The lockdown minimizes non-Shopping spend leakage.

### Post-Launch

#### Pre-Learning Setup (do immediately after enabling)

12. **Brand exclusions:** Add brand terms to prevent cannibalizing brand Search campaigns
13. **Negative keywords:** Up to 10,000 per campaign + shared lists. Apply to Search and Shopping inventory.

> [!tip] These are safe during learning — they do not reset the learning period. See [[learning-phase]].

#### Learning Period

14. **Monitoring:** Allow 2-4 weeks learning period before making disruptive changes (bid strategy switches, target changes, budget changes >20%). See [[learning-phase]] for the full safe vs. disruptive list.
15. **Channel reporting:** Use channel-level reporting (available since Aug 2025, API v23 Jan 2026) to verify Shopping holds **60-80% of spend** — this is the healthy benchmark
16. **Iteration:** Add creative assets incrementally — text first, then images, then video

**From Google Ads UI (feed-first, NOT true feed-only):**

> [!warning] Not True Feed-Only
> This path requires at least 3 headlines to save the asset group. The result is a "feed-first" PMax — the feed drives Shopping ads, but text assets enable Search text ads and provide seeds for auto-generated creative on other surfaces. Use this path when you need multiple asset groups or want more control, but understand it is NOT asset-free.

1. **Campaigns → + New campaign**
2. **Objective:** Sales (or Leads if applicable)
3. **Campaign type:** Performance Max
4. **Select Merchant Center account** — this prompt appears automatically if an MC account is linked. Select it.
5. **Feed label / country of sale** — select the feed and target country. The `feed_label` field in the API replaces the deprecated `sales_country` field.
6. **Campaign name:** Follow naming convention: `PMax | Feed-First | [Category/Brand] | [Region]`
7. **Budget & bid strategy** as above
8. **Asset group:** Must provide at minimum 3 headlines (30 chars each), 1 long headline (90 chars), 2 descriptions (90 chars), business name (25 chars). Skip images and video — Google will auto-generate from feed.
9. **Listing group + audience signals** as normal
10. Apply the same post-creation lockdown steps (disable auto-generated assets, Final URL expansion)

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

**Key takeaway:** Shopping surface (where the majority of spend goes for e-commerce) is identical. The difference is in non-Shopping surfaces where auto-generated creative has lower quality — but these represent only 3-26% of spend.

> [!warning] CTV Auto-Generation (since Q2 2025)
> Even feed-only PMax campaigns now auto-generate **Connected TV (CTV) ads** from product catalog photos. 80% of PMax advertisers generate CTV impressions, many unknowingly. In January 2026, Google added shoppable CTV ads with QR codes. In March 2026, AI voice-over was added (opt-out only). There is **no way to completely prevent** PMax from serving on non-Shopping surfaces — "feed-only" is a practitioner convention, not an official Google feature.

### Channel-Level Reporting (since August 2025)

%%fact-check: channel-level reporting — verified 2026-04-04%%

Use channel-level reporting to monitor where feed-only PMax actually spends. Available since August 2025, programmatic access via API v23 (January 2026).

| Channel | Healthy Benchmark | Action if Over |
|---------|------------------|----------------|
| Shopping | **60-80%** of spend | This is your target — if below 60%, feed quality needs work |
| Search | 10-20% | Acceptable — auto-generated text ads from feed |
| Display | 5-15% | If >15%, tighten lockdown settings |
| YouTube/CTV | 3-10% | If >10%, add one custom video to prevent low-quality auto-generated slideshows, or use Nils Rooijmans' script to auto-delete auto-generated videos |
| Gmail + Discover | 1-5% combined | Usually fine |

> [!tip] The "90% to Feed-Based" Claim
> The SMEC 90% figure includes feed-based ads on ALL surfaces (dynamic remarketing on Display, product cards on Gmail/Discover), not just Shopping. Channel reporting shows **60-80% to Shopping proper** as the more precise benchmark for actual Shopping surface spend.

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
6. **Monitor 2-4 weeks** — this is the learning period. Avoid disruptive changes (bid strategy switches, target changes, budget >20%). See [[learning-phase]] for what's safe.
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
- [About Final URL Expansion in PMax](https://support.google.com/google-ads/answer/14337539) — Why to disable for feed-only
- [Controlling Text Customization in PMax](https://support.google.com/google-ads/answer/14337369) — Auto-generated text asset controls
- [About Auto-Generated Video Ads](https://support.google.com/google-ads/answer/16430641) — YouTube/CTV auto-generation explanation
- [Create a Performance Max Campaign](https://support.google.com/google-ads/answer/10724896) — Standard PMax creation flow (requires assets)

### Code Samples
- [add_performance_max_retail_campaign.py](https://github.com/googleads/google-ads-python/blob/main/examples/shopping_ads/add_performance_max_retail_campaign.py) — Google's canonical Python example for feed-based PMax with listing groups
- [Add PMax Product Listing Group Tree](https://developers.google.com/google-ads/api/samples/add-performance-max-product-listing-group-tree) — Multi-language listing group filter examples

### Industry Research
- [SMEC: State of PMax 2025](https://smarter-ecommerce.com/blog/en/google-ads/state-of-performance-max-campaigns-2025/) — 4,000+ campaigns, 500+ accounts: 90% spend is feed-based, conversion thresholds, ROAS benchmarks
- [SMEC: PMax FAQ 2025](https://smarter-ecommerce.com/blog/en/google-ads/pmax-2025-faq-campaign-setup-brand-strategies-performance/) — Feed-only vs full-asset verdict (Mike Ryan)
- [SMEC: Shopping Alongside PMax 2026](https://smarter-ecommerce.com/blog/en/google-ads/how-to-run-google-shopping-alongside-performance-max-in-2026/) — Priority change late 2024, 70/30 split recommendation
- [ClicksInMind: Feed-Only PMax 2026](https://clicksinmind.com/en/feed-only-pmax-campaign/) — MC-only creation path, lockdown steps, single asset group limitation
- [Store Growers: PMax Ultimate Ecommerce Guide 2026](https://www.storegrowers.com/performance-max-campaigns/) — Feed-only first 2-4 weeks, then add assets
- [Search Engine Journal: How To Build Feed-Only PMax](https://www.searchenginejournal.com/how-to-build-a-feed-only-performance-max-campaign/568794/) — Step-by-step MC creation
- [ALM Corp: 80% of PMax Running CTV Ads](https://almcorp.com/blog/pmax-ctv-ads-performance-max-connected-tv/) — CTV auto-generation from product feeds
- [ALM Corp: PMax Channel Reporting Video Usage Segment](https://almcorp.com/blog/pmax-channel-reporting-video-usage-segment/) — Channel breakdown reporting
- [Nils Rooijmans: Script to Delete Auto-Created YouTube Videos](https://nilsrooijmans.com/daily/performance-max-script-to-delete-automatically-created-youtube-videos) — Automation to remove auto-generated video ads

### Tools
- [google/pmax_best_practices_dashboard](https://github.com/google/pmax_best_practices_dashboard) — Looker Studio + BQ dashboard with retail upgrade script
- [google-marketing-solutions/feedgen](https://github.com/google-marketing-solutions/feedgen) — AI feed optimization via Vertex AI
