# Feed-Only PMax & Merchant Center Knowledge Gap — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close the critical knowledge gap that caused Claude to fail campaign restructuring for a real e-commerce client (Vaxteronline) — the plugin has zero coverage of feed-only PMax, listing groups, and Merchant Center campaign creation.

**Architecture:** One new reference doc (`feed-only-pmax.md`) covers the core knowledge gap. Surgical edits to 2 skills and 3 reference docs fix wrong information and add decision forks. Routing/metadata updated last.

**Tech Stack:** Obsidian-flavored Markdown, YAML frontmatter, `[[wikilinks]]` for internal refs

**Key Sources:** Google official docs, API reference, SMEC 4000+ campaign study, Google open-source repos

---

## Research Sources

Sources to verify facts and enrich content during implementation. Fetch each URL with `WebFetch` before writing the section that depends on it.

### Official Google Documentation (verify UI flows and listing group dimensions)

| Source | URL | Use In |
|--------|-----|--------|
| Create PMax in Merchant Center | `https://support.google.com/merchants/answer/12453202` | Task 1: MC Next creation flow |
| Listing Groups for Retail (API) | `https://developers.google.com/google-ads/api/performance-max/listing-groups` | Task 1: Listing group dimensions, tree rules, depth limits |
| PMax for Retail (API) | `https://developers.google.com/google-ads/api/performance-max/retail` | Task 1: ShoppingSetting fields, feed_label, campaign config |
| Manage PMax listing groups (UI) | `https://support.google.com/google-ads/answer/11596074` | Task 1: UI-level listing group management |
| PMax negative keywords | `https://support.google.com/google-ads/answer/15726455` | Task 1: Negative keyword limits for PMax |
| Retail Campaign Reporting (API) | `https://developers.google.com/google-ads/api/performance-max/retail-reporting` | Task 1: Reporting queries for feed-based PMax |
| PMax brand suitability | `https://support.google.com/google-ads/answer/13607727` | Task 1: Brand exclusions |
| PMax optimization with MC feed | `https://support.google.com/google-ads/answer/13776350` | Task 1: Google's own optimization tips for feed-based PMax |

### Data-Backed Community Research (validate claims and add benchmarks)

| Source | URL | Key Finding | Use In |
|--------|-----|-------------|--------|
| SMEC: State of PMax 2025 | `https://smarter-ecommerce.com/blog/en/google-ads/state-of-performance-max-campaigns-2025/` | **90% of PMax spend is feed-based** (74-97% range), 30+ conversions/month minimum | Task 1: "When to Use" section + Key Points |
| SMEC: PMax FAQ | `https://smarter-ecommerce.com/blog/en/google-ads/pmax-2025-faq-campaign-setup-brand-strategies-performance/` | "little-to-no downside of feed-only, little-to-no upside of full-asset" | Task 1: Rule of Thumb callout |
| SMEC: Shopping alongside PMax 2026 | `https://smarter-ecommerce.com/blog/en/google-ads/how-to-run-google-shopping-alongside-performance-max-in-2026/` | PMax no longer auto-prioritized over Shopping (Oct 2024) | Task 1: Restructuring section, Task 3: comparison table |
| SavvyRevenue: Feed-Only vs Full | `https://savvyrevenue.com/blog/shopping-ads-performance-max/` | Strategic decision framework | Task 1: decision matrix validation |
| DataFeedWatch: Feed-only vs All Assets | `https://www.datafeedwatch.com/blog/pmax-feed-only-vs-all-assets` | Since Aug 2023 Google auto-generates video from feed; min 30 EUR/day, 15+ products | Task 1: prerequisites and auto-generation details |

### GitHub Repos (add to open-source-repos.md)

| Repo | URL | What It Adds |
|------|-----|-------------|
| google/pmax_best_practices_dashboard | `https://github.com/google/pmax_best_practices_dashboard` | Looker Studio + BQ dashboard for PMax retail, has `non_retail_to_retail_upgrade.sh` |
| google-marketing-solutions/feedgen | `https://github.com/google-marketing-solutions/feedgen` | AI-powered feed title/description optimization via Vertex AI |
| googleads/google-ads-python (retail example) | `https://github.com/googleads/google-ads-python/blob/main/examples/shopping_ads/add_performance_max_retail_campaign.py` | Canonical code for creating feed-based PMax via API |

### PMax Scripts (add monitoring scripts to catalog)

| Script | Author | URL | What It Adds |
|--------|--------|-----|-------------|
| PMax Shopping Spend Drop Alert | Nils Rooijmans | `https://nilsrooijmans.com/google-ads-script-review-pmax-shopping-spend-drop-alert/` | Alert if feed-only PMax stops serving on Shopping |
| PMax Non-Converting Search Term Alerts | Nils Rooijmans | `https://nilsrooijmans.com/google-ads-script-pmax-non-converting-search-term-alerts/` | Catch wasted spend from irrelevant queries |

---

## File Structure

All paths relative to `ad-platform-campaign-manager/`.

```
reference/platforms/google-ads/pmax/
├── feed-only-pmax.md          ← CREATE — core knowledge gap fix
├── asset-requirements.md      ← MODIFY — add feed-only callout after line 9
├── feed-optimization.md       ← (no change — already covers feed mechanics)
├── audience-signals.md        ← (no change)
├── pmax-metrics.md            ← (no change)

reference/platforms/google-ads/
├── campaign-types.md          ← MODIFY — update decision tree lines 13-24, PMax section lines 50-71
├── shopping-campaigns.md      ← MODIFY — enhance comparison table lines 21-29

skills/
├── pmax-guide/SKILL.md        ← MODIFY — restructure with feed-only path, add restructuring section
├── campaign-setup/SKILL.md    ← MODIFY — fix wrong blocker line 101, add PMax fork, add Shopping block

reference/repos/
├── open-source-repos.md       ← MODIFY — add Google PMax retail repos + Nils Rooijmans scripts

Root files:
├── CONTEXT.md                 ← MODIFY — add routing row
├── LESSONS.md                 ← MODIFY — add Campaign Strategy + Performance Max entries
├── PLAN.md                    ← MODIFY — record the work
```

---

## Task 1: Create `feed-only-pmax.md` Reference Doc

**Files:**
- Create: `reference/platforms/google-ads/pmax/feed-only-pmax.md`

This is the core fix — everything else depends on this file existing.

- [x] **Step 0: Fetch source material**

Before writing, fetch these URLs to verify facts and extract current data:

```
WebFetch: https://support.google.com/merchants/answer/12453202  (MC Next → PMax creation flow)
WebFetch: https://developers.google.com/google-ads/api/performance-max/listing-groups  (listing group dimensions + tree rules)
WebFetch: https://developers.google.com/google-ads/api/performance-max/retail  (ShoppingSetting fields)
WebFetch: https://smarter-ecommerce.com/blog/en/google-ads/state-of-performance-max-campaigns-2025/  (90% feed stat)
WebFetch: https://smarter-ecommerce.com/blog/en/google-ads/pmax-2025-faq-campaign-setup-brand-strategies-performance/  (feed-only verdict)
WebFetch: https://smarter-ecommerce.com/blog/en/google-ads/how-to-run-google-shopping-alongside-performance-max-in-2026/  (priority change Oct 2024)
```

Use the fetched data to:
- Verify listing group dimension names against the API proto (not guessing)
- Confirm the MC Next creation flow matches Google's current documentation
- Add the SMEC stat ("90% of PMax spend is feed-based") to the "When to Use" section
- Add the priority change (PMax no longer auto-prioritized over Shopping since Oct 2024) to the restructuring section
- Verify minimum product count and budget recommendations

- [x] **Step 1: Create the reference doc (enriched with source data)**

```markdown
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

## When to Use Feed-Only PMax

| Scenario | Recommendation |
|----------|---------------|
| E-commerce, no creative team, want multi-channel reach | **Feed-only PMax** |
| E-commerce, have video/image assets, want brand control | Full PMax (with creative assets) |
| E-commerce, want product-level bidding control | Standard Shopping |
| E-commerce, limited budget, testing phase | Standard Shopping |
| E-commerce, small catalog (<50 products) | Feed-only PMax or Standard Shopping |
| Services / lead gen, no product catalog | Full PMax (creative required) or Search |

> [!tip] Rule of Thumb
> If the client has a healthy Merchant Center feed and no creative team, feed-only PMax is the default starting point. Add creative assets incrementally as budget and resources allow.

> [!abstract] Industry Data (SMEC, 4,000+ PMax campaigns, 2025)
> **90% of PMax spend goes to feed-based ads** (range: 74-97%). Feed quality is the single biggest lever for PMax retail performance. Campaigns need 30+ conversions/month minimum, 60+ ideal. There is "little-to-no downside of using a feed-only campaign and little-to-no upside of using a full-asset campaign" for e-commerce advertisers. Source: Smarter Ecommerce.

## What Google Auto-Generates From Your Feed

| Ad Surface | What Gets Generated | Source Data |
|-----------|--------------------|-----------  |
| Shopping (Search + Shopping tab) | Product listing ads with image, title, price | `title`, `image_link`, `price`, `availability` |
| Search (text ads) | Responsive text ads from product info | `title`, `description`, `price`, `brand` |
| Display Network | Product cards assembled from feed images | `image_link`, `title`, `price` |
| YouTube | Auto-generated slideshow from product images | `image_link`, `title` (quality varies — lowest quality surface) |
| Gmail | Product promotion cards | `image_link`, `title`, `price`, `sale_price` |
| Discover | Visual product cards | `image_link`, `title`, `price` |

> [!warning] YouTube Auto-Generated Quality
> Auto-generated YouTube ads from product images are often poor. For Shopping and Search surfaces, auto-generation works well. For YouTube, consider adding at least one custom video as your catalog grows. This is an incremental improvement, not a launch blocker.

## Minimum Viable Setup

### Prerequisites
1. Google Merchant Center account with active product feed (no disapprovals blocking >10% of products)
2. Merchant Center linked to Google Ads account (see Account Linking below)
3. Primary conversion action configured in Google Ads
4. At least 15 active products in the feed (fewer products = fewer signals for Google's AI)

### Step-by-Step: Create Feed-Only PMax Campaign

**From Google Ads UI:**

1. **Campaigns → + New campaign**
2. **Objective:** Sales (or Leads if applicable)
3. **Campaign type:** Performance Max
4. **Select Merchant Center account** — this prompt appears automatically if an MC account is linked. Select it.
5. **Feed label / country of sale** — select the feed and target country
6. **Campaign name:** Follow naming convention: `PMax | Feed-Only | [Category/Brand] | [Region]`
7. **Budget:** Set daily budget (recommendation: at least €20/day for meaningful learning)
8. **Bid strategy:** Maximize Conversion Value (if ROAS data exists) or Maximize Conversions (if starting fresh)

### Asset Group Configuration (Feed-Only)

9. **Asset group name:** Name by product segment (e.g., "Running Shoes" or "High-Margin Products")
10. **Listing group:** Configure product filter (see Listing Groups section below) — this controls WHICH products from your feed appear in this asset group
11. **Creative assets:** Skip images and video. Optionally add:
    - Text assets: 3+ headlines (30 chars), 1+ long headline (90 chars), 2+ descriptions (90 chars) — recommended for better Search text ads
    - Logo: 1 square logo — recommended for brand consistency on Display/YouTube
    - Business name: required (25 chars)
12. **Audience signals:** Configure per asset group (see [[audience-signals]])
13. **Final URL expansion:** Enable (lets Google find relevant landing pages from your site)

### Post-Launch

14. **Brand exclusions:** Add brand terms to prevent cannibalizing brand Search campaigns
15. **Monitoring:** Allow 2-4 weeks learning period before making changes
16. **Iteration:** Add creative assets incrementally — text first, then images, then video

**From Merchant Center Next UI:**

1. **MC Next dashboard → Performance tab** (or "Boost performance" banner if shown)
2. **"Create campaign"** — this links directly to Google Ads campaign creation with your MC feed pre-selected
3. Continue from step 5 above (campaign name, budget, bid strategy)

> [!info] MC Next Shortcut
> Creating from Merchant Center Next auto-selects PMax with your feed. It's the fastest path if you're starting from scratch.

## Listing Groups — The Missing Piece

### What Are Listing Groups?

Listing groups are the **PMax equivalent of Shopping campaign product groups**. They control which products from your Merchant Center feed appear in which asset group. Without proper listing group configuration, ALL products dump into a single bucket — defeating the purpose of asset group segmentation.

### Listing Group Structure

```
Asset Group: "Running Shoes"
└── Listing Group (filter)
    └── All Products
        └── Subdivide by: google_product_category
            ├── Include: "Apparel > Shoes > Athletic Shoes > Running Shoes"
            └── Exclude: Everything else
```

### How to Configure Listing Groups

1. **In asset group editor → Listing groups section**
2. **Default:** "All products" (entire feed) — this is what you get if you don't touch it
3. **Subdivide:** Click the pencil/edit icon → choose subdivision attribute:
   - `brand` — split by brand
   - `google_product_category` — split by Google's category taxonomy
   - `product_type` — split by your custom product type hierarchy
   - `custom_label_0` through `custom_label_4` — split by custom labels you define in the feed
   - `item_id` — target individual products (hero products)
   - `condition` — split by new/used/refurbished
   - `channel` — split by online/local
4. **Include/Exclude:** After subdividing, toggle which values to include in this asset group
5. **Multiple asset groups:** Each asset group gets its OWN listing group filter. Products should NOT overlap between asset groups (causes internal competition).

### Listing Group Strategies

| Strategy | Subdivision Attribute | When to Use | Example |
|----------|----------------------|-------------|---------|
| By margin tier | `custom_label_0` | Different ROAS targets per margin | High-margin → aggressive ROAS, low-margin → conservative |
| By product category | `google_product_category` | Category-specific audience signals | "Running Shoes" asset group with in-market for running audience |
| By brand | `brand` | Separate own brand vs third-party | Own brand with higher ROAS target, third-party with lower |
| By performance | `custom_label_2` | Isolate bestsellers from long tail | Bestsellers get own budget, long tail grouped |
| Hero products | `item_id` | Spotlight top sellers individually | Top 10 SKUs each in own asset group |

> [!tip] Custom Labels Are Your Power Tool
> Custom labels (`custom_label_0-4`) in the Merchant Center feed are the most flexible segmentation tool. Use them to encode business logic (margin tier, seasonality, performance tier, price range, priority) that Google's default attributes don't capture. See [[feed-optimization]] for custom label setup.

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

**Key takeaway:** Shopping surface (the primary revenue driver for e-commerce) is identical. The difference is in non-Shopping surfaces where auto-generated creative has lower quality.

## Account Restructuring: Shopping+PMax → Clean Feed-Based PMax

### When to Restructure

- Multiple Shopping and PMax campaigns competing for the same products
- Product groups overlap between Shopping and PMax (cannibalizing each other)
- No clear structure — campaigns were added incrementally without strategy
- Performance is flat or declining despite healthy feed and budget

> [!info] Priority Change (October 2024)
> Since October 2024, PMax is **no longer automatically prioritized over Standard Shopping** in ad auctions. Both campaign types now compete on equal footing. This means running Shopping alongside PMax is a viable strategy — restructuring to PMax-only is a choice, not a necessity. Source: Google Ads, confirmed by SMEC.

### Assessment Phase (Before Changing Anything)

1. **Inventory all campaigns:** List every Shopping and PMax campaign with status, daily budget, and product scope
2. **Map product overlap:** Identify which products appear in multiple campaigns (use product group reports)
3. **Pull 90-day performance:** By campaign and by product segment — ROAS, conversions, spend, impression share
4. **Identify the winner:** Which campaign type drives better ROAS per product segment?
5. **Check feed health:** Run MC diagnostics — disapprovals, warnings, feed freshness

### Design Phase

1. **Define new PMax campaign structure** — typically 1-3 campaigns:
   - By margin tier: High-margin products, standard-margin, clearance
   - By category: If product categories have very different audiences
   - Single campaign: If catalog is small (<200 products) or performance is uniform
2. **Map listing groups to asset groups** — each asset group gets a non-overlapping product filter
3. **Set audience signals per asset group** — match audience to product segment
4. **Decide asset level:** Feed-only to start, or add text/images if available
5. **Plan negative keyword carry-over** — export negatives from old Shopping campaigns, apply at account or campaign level

### Migration Phase (Stepwise — Never Cold Turkey)

1. **Create new feed-only PMax campaigns (PAUSED)**
2. **Configure listing groups** matching your design
3. **Add audience signals** and optional text assets
4. **Pause old Shopping campaigns** for the product segments that overlap with new PMax
5. **Enable new PMax campaigns**
6. **Monitor 2-4 weeks** — this is the learning period. Do NOT make changes.
7. **After stabilization:** Pause remaining old campaigns. Adjust ROAS/CPA targets based on 4-week data.

### Rollback Plan

- **Keep old campaigns PAUSED, not deleted**, for 30 days minimum
- If new PMax underperforms after 4 full weeks, re-enable old campaigns
- Compare **total account ROAS** before/after — not just campaign-level (PMax may shift conversions between surfaces)

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

## Cross-References

- [[feed-optimization]] — feed attribute optimization, custom labels, supplemental feeds
- [[asset-requirements]] — full PMax creative asset specs (when adding assets to a feed-only campaign)
- [[audience-signals]] — audience signal configuration per asset group
- [[../../shopping-campaigns]] — standard Shopping campaign reference
- [[../../campaign-types]] — campaign type decision tree
- [[../../bidding-strategies]] — bid strategy selection
```

- [x] **Step 2: Verify the file was created and renders correctly**

Run: `cat reference/platforms/google-ads/pmax/feed-only-pmax.md | head -5`
Expected: YAML frontmatter with title "Feed-Only PMax"

- [x] **Step 3: Commit**

```bash
git add reference/platforms/google-ads/pmax/feed-only-pmax.md
git commit -m "docs: add feed-only PMax reference — listing groups, MC creation flow, restructuring pattern"
```

---

## Task 2: Add Feed-Only Callout to `asset-requirements.md`

**Files:**
- Modify: `reference/platforms/google-ads/pmax/asset-requirements.md:9-10`

The current file starts listing asset minimums at line 12 with no mention that feed-only PMax exists. Users read this and conclude creative is mandatory for ALL PMax.

- [x] **Step 1: Add the callout after line 9 (after `# PMax Asset Requirements`)**

Insert between line 10 (`# PMax Asset Requirements`) and line 12 (`## Text Assets`):

```markdown
> [!info] Feed-Only PMax
> If your PMax campaign uses a Merchant Center product feed and you don't have creative assets, you can run PMax with feed only — Google auto-generates ads from your product data. The asset minimums below apply to **full PMax campaigns with custom creative**. See [[feed-only-pmax]] for the feed-only configuration and what to add incrementally.
```

- [x] **Step 2: Verify the callout is in place**

Run: `head -16 reference/platforms/google-ads/pmax/asset-requirements.md`
Expected: Callout block between the title and the Text Assets table

- [x] **Step 3: Commit**

```bash
git add reference/platforms/google-ads/pmax/asset-requirements.md
git commit -m "docs: add feed-only PMax callout to asset-requirements — prevents misread that creative is mandatory"
```

---

## Task 3: Enhance Shopping vs PMax Comparison Table in `shopping-campaigns.md`

**Files:**
- Modify: `reference/platforms/google-ads/shopping-campaigns.md:21-29`

The existing table compares Standard Shopping vs "PMax with Feed" but doesn't distinguish feed-only from full PMax. The distinction matters for campaign restructuring decisions.

- [x] **Step 1: Replace the comparison table (lines 21-29)**

Replace the current `### Shopping vs PMax with Feed` section:

```markdown
### Shopping vs PMax: Choosing the Right Feed-Based Campaign

| Factor | Standard Shopping | Feed-Only PMax | Full PMax (with assets) |
|--------|-------------------|----------------|------------------------|
| Creative needed | None (feed only) | None (feed only) | Images + video + text |
| Control | High — manual bids, negatives, product groups | Low — Google AI manages everything | Low — Google AI manages everything |
| Reporting | Granular — product, query, device level | Full search terms, channel-level breakdowns | Full search terms, channel-level breakdowns |
| Reach | Shopping tab + Search only | All Google channels (Search, Display, YouTube, Gmail, Discover) | All Google channels (higher quality non-Shopping surfaces) |
| Negatives | Supported | Campaign-level (up to 10,000) + shared lists | Campaign-level (up to 10,000) + shared lists |
| Non-Shopping ad quality | N/A | Auto-generated (lower) | Custom creative (higher) |
| Best for | Experienced advertisers wanting granular control | E-commerce without creative team, wanting multi-channel reach | E-commerce with creative resources wanting maximum brand control |

> [!tip] Starting Point for Most E-Commerce Clients
> Feed-only PMax is the default starting point when a client has a healthy Merchant Center feed but no creative team. Start feed-only, add creative assets incrementally as resources allow. See [[pmax/feed-only-pmax|feed-only-pmax]] for the full setup guide.
```

- [x] **Step 2: Verify the table renders with 3 columns**

Run: `sed -n '21,36p' reference/platforms/google-ads/shopping-campaigns.md`
Expected: Three-column comparison with "Feed-Only PMax" as middle column

- [x] **Step 3: Commit**

```bash
git add reference/platforms/google-ads/shopping-campaigns.md
git commit -m "docs: add feed-only PMax column to Shopping comparison table"
```

---

## Task 4: Update Decision Tree in `campaign-types.md`

**Files:**
- Modify: `reference/platforms/google-ads/campaign-types.md:13-24` (decision tree)
- Modify: `reference/platforms/google-ads/campaign-types.md:50-71` (PMax section)

The decision tree routes "sell physical products" exclusively to SHOPPING. Feed-only PMax should be a visible option. The PMax section says creative assets are needed to "perform well" without mentioning feed-only.

- [x] **Step 1: Replace the decision tree (lines 13-24)**

```markdown
```
What is your primary goal?
├── Drive sales/leads from search intent → SEARCH
├── Sell physical products (want granular control) → SHOPPING (needs Merchant Center)
├── Sell physical products (want multi-channel reach) → FEED-ONLY PMAX (needs Merchant Center)
├── Capture long-tail queries from website content → DSA
├── Maximize conversions across all channels (with creative) → PERFORMANCE MAX
├── Build brand awareness with visual ads → DISPLAY
├── Drive action through visual storytelling / video → DEMAND GEN
├── Video views / brand awareness on YouTube → VIDEO
├── App installs / in-app actions → APP
└── Local store visits / calls → PERFORMANCE MAX (with store goals)
```
```

- [x] **Step 2: Add feed-only distinction to PMax section (after line 69)**

Insert after `- Needs quality creative assets (images, videos, text) to perform well` (line 69):

```markdown
- **Feed-only PMax:** E-commerce businesses with a Merchant Center feed can run PMax WITHOUT custom creative — Google auto-generates ads from the feed. See [[pmax/feed-only-pmax|feed-only-pmax]] for setup and listing group configuration.
```

- [x] **Step 3: Verify the decision tree shows both Shopping and Feed-Only PMax**

Run: `sed -n '13,25p' reference/platforms/google-ads/campaign-types.md`
Expected: Both "SHOPPING (needs Merchant Center)" and "FEED-ONLY PMAX (needs Merchant Center)" in the tree

- [x] **Step 4: Commit**

```bash
git add reference/platforms/google-ads/campaign-types.md
git commit -m "docs: add feed-only PMax to campaign type decision tree"
```

---

## Task 5: Restructure `pmax-guide` Skill With Feed-Only Path

**Files:**
- Modify: `skills/pmax-guide/SKILL.md` (full restructure)

The current skill assumes one PMax archetype requiring full creative assets. It needs a decision fork at the top routing to feed-only vs full PMax, with listing group guidance as a first-class step.

- [x] **Step 1: Rewrite the skill**

Replace the entire content of `skills/pmax-guide/SKILL.md` with:

```markdown
---
name: pmax-guide
description: Performance Max guidance — feed-only PMax, full PMax, asset groups, audience signals, feed optimization, listing groups, PMax metrics interpretation. Use when working with PMax campaigns.
disable-model-invocation: false
---

# Performance Max Guide

You are helping with Performance Max (PMax) campaign setup, optimization, or analysis. PMax campaigns come in distinct configurations — determine which one applies before giving guidance.

## Reference Material

- **Feed-only PMax setup:** [[../../reference/platforms/google-ads/pmax/feed-only-pmax|feed-only-pmax.md]]
- **Asset requirements (full PMax):** [[../../reference/platforms/google-ads/pmax/asset-requirements|asset-requirements.md]]
- **Audience signals:** [[../../reference/platforms/google-ads/pmax/audience-signals|audience-signals.md]]
- **Feed optimization:** [[../../reference/platforms/google-ads/pmax/feed-optimization|feed-optimization.md]]
- **PMax metrics & reporting:** [[../../reference/platforms/google-ads/pmax/pmax-metrics|pmax-metrics.md]]
- **Campaign types overview:** [[../../reference/platforms/google-ads/campaign-types|campaign-types.md]] (PMax section)
- **Bidding strategies:** [[../../reference/platforms/google-ads/bidding-strategies|bidding-strategies.md]]
- **Shopping campaigns:** [[../../reference/platforms/google-ads/shopping-campaigns|shopping-campaigns.md]]

## Step 0: Determine PMax Type

Before anything else, ask:

1. **Does the client sell physical products with a Merchant Center product feed?**
   - Yes → feed-based PMax (continue to question 2)
   - No → non-feed PMax (services, lead gen — skip to "Setting Up Full PMax" below)

2. **Does the client have creative assets (product images, video, custom headlines)?**
   - Yes → **Full PMax** — asset groups with creative + feed + audience signals
   - No → **Feed-only PMax** — Google auto-generates from feed data
   - Some (e.g., logo + text, no video) → **Feed-only PMax with optional text assets** — start feed-only, add assets incrementally

| Type | Feed | Creative | Guide |
|------|------|----------|-------|
| Feed-only PMax | Required | None or optional text/logo | Use "Setting Up Feed-Only PMax" below |
| Full PMax | Optional but recommended for e-commerce | Required (images + video + text) | Use "Setting Up Full PMax" below |
| Non-feed PMax | None | Required (images + video + text) | Use "Setting Up Full PMax" below |

## Common Tasks

### Setting Up Feed-Only PMax

Consult [[../../reference/platforms/google-ads/pmax/feed-only-pmax|feed-only-pmax.md]] for complete step-by-step.

Walk the user through:
1. Verify Merchant Center link and feed health (check disapprovals, feed freshness)
2. Define campaign goal and bid strategy (Maximize Conversion Value if ROAS data, Maximize Conversions if starting fresh)
3. Design asset group structure by product segment (margin tier, category, or brand)
4. **Configure listing groups per asset group** — this is the critical step most people skip:
   - Default is "All products" — almost always wrong for multi-product catalogs
   - Subdivide by custom label, category, or brand
   - Ensure NO product overlap between asset groups
5. Configure audience signals per asset group (match audience to product segment)
6. Add optional text assets (headlines, descriptions) and logo — low effort, meaningful impact
7. Configure brand exclusions (prevent cannibalizing brand Search)
8. Verify conversion tracking is configured

### Setting Up Full PMax (With Creative Assets)
1. Define campaign goal and bid strategy
2. Design asset group structure (by product category or audience)
3. Configure audience signals per asset group
4. List required creative assets with specifications (consult [[../../reference/platforms/google-ads/pmax/asset-requirements|asset-requirements.md]])
5. Set up listing groups (if Merchant Center feed is linked)
6. Configure brand exclusions
7. Discuss conversion tracking requirements

### Restructuring: Shopping+PMax → Clean Feed-Based PMax

When a client has messy overlapping Shopping and PMax campaigns, walk through the restructuring pattern:

1. **Ask:** What campaigns exist? (types, product scope, daily budgets)
2. **Ask:** Which products appear in multiple campaigns?
3. **Ask:** What's the 90-day ROAS per campaign and product segment?
4. **Design:** Propose a clean PMax structure (by margin tier or category) with non-overlapping listing groups
5. **Migrate:** Stepwise — create new PMax paused → configure listing groups → pause old Shopping for overlapping products → enable new PMax → monitor 2-4 weeks
6. **Rollback:** Keep old campaigns paused (not deleted) for 30 days

Full pattern in [[../../reference/platforms/google-ads/pmax/feed-only-pmax|feed-only-pmax.md]] under "Account Restructuring."

### Optimizing an Existing PMax Campaign
1. Review asset performance ratings (Best/Good/Low)
2. Identify and replace underperforming assets
3. Refine audience signals based on Insights tab data
4. Check search term categories for brand cannibalization
5. Evaluate channel distribution (Search vs Display vs YouTube)
6. Assess whether PMax is truly incremental vs cannibalizing Search
7. For feed-based PMax: check listing group segmentation and feed health

### Interpreting PMax Reports
Help the user understand PMax-specific metrics:
- Asset group performance and status
- Asset performance ratings and what they mean
- Search term insights (full visibility since March 2025)
- Audience insights
- Channel distribution
- Listing group performance (which product segments convert)

### Feed Optimization (Shopping/E-commerce)
Walk through product feed improvements:
- Title optimization formula and examples
- Required vs recommended attributes
- Custom labels for campaign segmentation
- Supplemental feed strategy

## Key Points to Emphasize

- PMax needs 30+ conversions/month for effective optimization
- Audience signals are **hints**, not hard targeting
- **Feed-only PMax:** Auto-generated YouTube ads are the weakest surface — acceptable for launch, add custom video as resources allow
- **Full PMax:** Always provide custom video (don't rely on auto-generated)
- Brand exclusion lists prevent cannibalizing brand Search campaigns
- Allow 2-4 weeks before making changes (learning period)
- **Listing groups are the most critical setup step for feed-based PMax** — wrong listing groups = wasted spend on irrelevant products
- PMax works best with good conversion tracking — check with `/ad-platform-campaign-manager:conversion-tracking`

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| PMax spending but few or no conversions | Insufficient conversion volume (needs 30+/month) or wrong primary conversion action | Verify primary conversion action; if volume too low, consider Search first to build history |
| Asset ratings all "Low" | Assets don't match audience or too few variations | Replace low-rated assets with new variations; 15+ headlines, 5+ descriptions; wait 2 weeks |
| PMax cannibalizing brand Search | PMax serves brand terms by default | Add brand exclusion lists; compare by pausing PMax for 2 weeks |
| Search term categories show irrelevant traffic | Audience signals too broad or feed titles vague | Narrow audience signals; improve feed titles; add account-level negatives |
| Campaign stuck in "Learning" for 3+ weeks | Too many changes or not enough conversion data | Stop edits for 2 weeks; increase budget or consolidate asset groups |
| Auto-generated video looks poor | No custom video provided | Upload at least one custom video (even a simple slideshow) |
| Feed-based PMax has no Shopping impressions | Listing group misconfigured or feed disapprovals | Check listing group filters — may be filtering out all products; check MC diagnostics |
| Products showing in wrong asset group | Listing groups overlap between asset groups | Audit listing groups — ensure no product appears in more than one asset group |
| PMax and Shopping competing for same products | Both campaign types targeting the same catalog | Restructure: migrate to clean PMax with proper listing groups; pause overlapping Shopping |
```

- [x] **Step 2: Verify skill loads correctly**

Run: `head -6 skills/pmax-guide/SKILL.md`
Expected: YAML frontmatter with updated description mentioning "feed-only PMax" and "listing groups"

- [x] **Step 3: Commit**

```bash
git add skills/pmax-guide/SKILL.md
git commit -m "docs: restructure pmax-guide skill — add feed-only path, listing groups, restructuring guidance"
```

---

## Task 6: Fix Wrong Blocker and Add Shopping Block in `campaign-setup` Skill

**Files:**
- Modify: `skills/campaign-setup/SKILL.md:42-46` (PMax block)
- Modify: `skills/campaign-setup/SKILL.md:99-105` (blockers table)

The blocker table on line 101 says PMax "Cannot launch" without creative assets — factually wrong for feed-only PMax. The PMax block on lines 42-46 doesn't distinguish feed-only from full PMax. There's no Shopping block at all.

- [x] **Step 1: Replace the "For PMax campaigns" block (lines 42-46)**

Replace:

```markdown
**For PMax campaigns:**
- Propose asset group structure
- Define audience signals per asset group (consult [[../../reference/platforms/google-ads/pmax/audience-signals|audience-signals.md]])
- List required creative assets (consult [[../../reference/platforms/google-ads/pmax/asset-requirements|asset-requirements.md]])
- If Shopping: discuss feed optimization (consult [[../../reference/platforms/google-ads/pmax/feed-optimization|feed-optimization.md]])
```

With:

```markdown
**For PMax campaigns:**
- Ask: Does the client have a Merchant Center product feed?
  - **If yes (e-commerce) + no creative assets → Feed-only PMax:**
    - Design asset groups by product segment (margin tier, category, or brand)
    - Configure listing groups per asset group — the critical step (consult [[../../reference/platforms/google-ads/pmax/feed-only-pmax|feed-only-pmax.md]])
    - Define audience signals per asset group (consult [[../../reference/platforms/google-ads/pmax/audience-signals|audience-signals.md]])
    - Discuss optional text assets and logo (low effort, recommended)
    - Discuss feed optimization (consult [[../../reference/platforms/google-ads/pmax/feed-optimization|feed-optimization.md]])
  - **If yes (e-commerce) + has creative assets → Full PMax:**
    - Propose asset group structure
    - Configure listing groups per asset group (consult [[../../reference/platforms/google-ads/pmax/feed-only-pmax|feed-only-pmax.md]] for listing group details)
    - Define audience signals per asset group (consult [[../../reference/platforms/google-ads/pmax/audience-signals|audience-signals.md]])
    - List required creative assets (consult [[../../reference/platforms/google-ads/pmax/asset-requirements|asset-requirements.md]])
    - Discuss feed optimization (consult [[../../reference/platforms/google-ads/pmax/feed-optimization|feed-optimization.md]])
  - **If no (services/lead gen) → Non-feed PMax:**
    - Propose asset group structure by audience
    - Define audience signals per asset group (consult [[../../reference/platforms/google-ads/pmax/audience-signals|audience-signals.md]])
    - List required creative assets — mandatory for non-feed PMax (consult [[../../reference/platforms/google-ads/pmax/asset-requirements|asset-requirements.md]])

**For Shopping campaigns:**
- Verify Merchant Center link and feed health
- Propose product group structure (by brand, category, margin tier, or custom label)
- Discuss priority campaign strategy (multi-campaign tiered priority) vs single campaign (simpler, good for starting out)
- Recommend bidding: Manual CPC for control or Target ROAS if conversion data exists
- Consult [[../../reference/platforms/google-ads/shopping-campaigns|shopping-campaigns.md]]
```

- [x] **Step 2: Replace the blockers table (lines 99-105)**

Replace the single PMax blocker row:

```markdown
| No creative assets for PMax/Display/Demand Gen | Cannot launch — these types require images and video | Recommend starting with Search (text-only) while assets are produced, or provide asset specs so the client can prepare them |
```

With three rows:

```markdown
| No creative assets for Display/Demand Gen | Cannot launch — these types require images and video | Recommend starting with Search while assets are produced, or provide asset specs |
| No creative assets for PMax (no feed) | Cannot launch — non-feed PMax requires images and video | Recommend starting with Search while assets are produced |
| No creative assets for PMax (has MC feed) | CAN launch — feed-only PMax auto-generates from product data | Proceed with feed-only PMax setup. See `/ad-platform-campaign-manager:pmax-guide` |
```

- [x] **Step 3: Verify the wrong blocker is gone**

Run: `grep -n "Cannot launch.*these types" skills/campaign-setup/SKILL.md`
Expected: No matches (the old combined row should not exist)

Run: `grep -n "CAN launch" skills/campaign-setup/SKILL.md`
Expected: One match — the new feed-only PMax row

- [x] **Step 4: Commit**

```bash
git add skills/campaign-setup/SKILL.md
git commit -m "fix: campaign-setup skill — fix wrong PMax blocker, add feed-only fork, add Shopping block"
```

---

## Task 7: Update Routing Table in `CONTEXT.md`

**Files:**
- Modify: `CONTEXT.md:12-26` (routing table)

- [x] **Step 1: Add routing row for feed-only PMax / Shopping restructuring**

Insert after the "PMax work" row (line 19) in the routing table:

```markdown
| Feed-only PMax / Shopping restructure | `skills/pmax-guide/SKILL.md` | `reference/platforms/google-ads/pmax/feed-only-pmax.md`, `pmax/feed-optimization.md`, `pmax/audience-signals.md`, `shopping-campaigns.md` | asset-requirements (unless adding creative), tracking-bridge, scripts |
```

- [x] **Step 2: Verify the row was added**

Run: `grep "feed-only" CONTEXT.md`
Expected: The new routing row

- [x] **Step 3: Commit**

```bash
git add CONTEXT.md
git commit -m "docs: add feed-only PMax routing to CONTEXT.md task router"
```

---

## Task 8: Add Lessons Learned to `LESSONS.md`

**Files:**
- Modify: `LESSONS.md:36-50` (empty Campaign Strategy and Performance Max sections)

- [x] **Step 1: Add Campaign Strategy entries (replace line 38 `_(No entries yet)_`)**

```markdown
- **2026-04-01** — Feed-only PMax is a distinct configuration from full PMax. When a client has a Merchant Center feed but no creative assets, the answer is NOT "you can't launch PMax" — it's feed-only PMax with auto-generated creative from the feed. The campaign-setup skill previously blocked this path entirely.
- **2026-04-01** — Account restructuring (messy Shopping+PMax → clean feed-based PMax) must be stepwise: create new PMax paused → pause overlapping Shopping → enable new PMax → monitor 2-4 weeks. Never cold-turkey. Keep old campaigns paused (not deleted) for 30 days as rollback.
```

- [x] **Step 2: Add Performance Max entries (replace line 50 `_(No entries yet)_`)**

```markdown
- **2026-04-01** — Listing groups are the PMax equivalent of Shopping product groups. They control which products from the feed appear in which asset group. Without proper listing group configuration, all products dump into a single bucket — defeating the purpose of asset group segmentation. Configure listing groups BEFORE audience signals.
- **2026-04-01** — When creating PMax from Merchant Center Next, use Performance tab → "Create campaign" — this pre-selects PMax with the feed and is the fastest path for e-commerce clients.
```

- [x] **Step 3: Commit**

```bash
git add LESSONS.md
git commit -m "docs: add feed-only PMax and listing group lessons learned"
```

---

## Task 9: Update `PLAN.md` With This Work

**Files:**
- Modify: `PLAN.md`

- [x] **Step 1: Add a new finding or update Finding #2 status**

Add under the audit findings section or update Next Steps to reflect this work:

```markdown
### Finding 5: Feed-Only PMax Knowledge Gap

- **What:** Plugin had zero coverage of feed-only PMax, listing groups, Merchant Center campaign creation flow, and account restructuring patterns. `campaign-setup` skill had a factually wrong blocker saying PMax "cannot launch" without creative assets.
- **Impact:** Claude failed to guide real-world campaign restructuring for e-commerce client.
- **Fix:** Created `feed-only-pmax.md` reference doc, restructured `pmax-guide` skill with feed-only path, fixed `campaign-setup` blockers, updated decision tree and comparison tables.
- **Status:** ✅ Done
```

- [x] **Step 2: Commit**

```bash
git add PLAN.md
git commit -m "docs: record feed-only PMax knowledge gap fix in PLAN.md"
```

---

## Task 10: Update `open-source-repos.md` With New Repos

**Files:**
- Modify: `reference/repos/open-source-repos.md`

Add the Google repos and PMax monitoring scripts discovered during research.

- [x] **Step 1: Add Google repos under a new "Feed & PMax Retail" section**

Insert after the "Tracking Infrastructure" section:

```markdown
## Feed & PMax Retail

| Repository | Maintainer | What it provides |
|-----------|-----------|-----------------|
| google/pmax_best_practices_dashboard | Google | Looker Studio + BigQuery dashboard for PMax retail — asset compliance, performance monitoring, non-retail-to-retail upgrade script |
| google-marketing-solutions/feedgen | Google | AI-powered (Vertex AI / Gemini) feed title and description optimization — outputs supplemental feeds for Merchant Center |
| googleads/google-ads-python (retail examples) | Google | Canonical API code samples for creating PMax retail campaigns with listing group filters |

> [!tip] Feed-Only PMax
> The repos above are directly relevant to feed-only PMax setup and optimization. See [[../platforms/google-ads/pmax/feed-only-pmax|feed-only-pmax.md]] for the complete feed-only PMax reference.
```

- [x] **Step 2: Add Nils Rooijmans scripts under a new "PMax Monitoring Scripts (Community)" section**

Insert after the "Feed & PMax Retail" section:

```markdown
## PMax Monitoring Scripts (Community)

| Script | Author | What it provides |
|--------|--------|-----------------|
| PMax Shopping Spend Drop Alert | Nils Rooijmans | Alerts when PMax campaigns stop serving on Shopping inventory — critical for feed-only campaigns |
| PMax Non-Converting Search Term Alerts | Nils Rooijmans | Flags wasted spend from non-converting search terms in PMax campaigns |
| PMax Placement Exclusion Suggestions | Nils Rooijmans | Suggests Display/YouTube placement exclusions for poor-quality placements |

> [!note] Source
> Scripts available at nilsrooijmans.com. These complement the existing agencysavvy/pmax scripts already cataloged above.
```

- [x] **Step 3: Commit**

```bash
git add reference/repos/open-source-repos.md
git commit -m "docs: add Google PMax retail repos and Nils Rooijmans monitoring scripts"
```

---

## Task 11: Add External Sources Section to `feed-only-pmax.md`

**Files:**
- Modify: `reference/platforms/google-ads/pmax/feed-only-pmax.md` (append at end)

After the Cross-References section, add an External Sources section so the document is self-contained and traceable.

- [x] **Step 1: Append the sources section**

```markdown
## External Sources

### Official Google Documentation
- [Create PMax in Merchant Center](https://support.google.com/merchants/answer/12453202) — MC Next campaign creation flow
- [Listing Groups for Retail](https://developers.google.com/google-ads/api/performance-max/listing-groups) — API reference for listing group dimensions and tree rules
- [PMax for Online Sales with Product Feed](https://developers.google.com/google-ads/api/performance-max/retail) — Retail campaign ShoppingSetting fields
- [Manage PMax Listing Groups](https://support.google.com/google-ads/answer/11596074) — UI-level listing group management
- [PMax Optimization with MC Feed](https://support.google.com/google-ads/answer/13776350) — Google's own feed-based PMax optimization tips
- [PMax Negative Keywords](https://support.google.com/google-ads/answer/15726455) — 10,000 per campaign + shared lists
- [Retail Campaign Reporting](https://developers.google.com/google-ads/api/performance-max/retail-reporting) — GAQL queries and cart data metrics

### Code Samples
- [add_performance_max_retail_campaign.py](https://github.com/googleads/google-ads-python/blob/main/examples/shopping_ads/add_performance_max_retail_campaign.py) — Google's canonical Python example for feed-based PMax
- [Add PMax Product Listing Group Tree](https://developers.google.com/google-ads/api/samples/add-performance-max-product-listing-group-tree) — Multi-language listing group filter examples

### Industry Research
- [SMEC: State of PMax 2025](https://smarter-ecommerce.com/blog/en/google-ads/state-of-performance-max-campaigns-2025/) — 4,000+ campaigns: 90% spend is feed-based, conversion thresholds, ROAS benchmarks
- [SMEC: PMax FAQ 2025](https://smarter-ecommerce.com/blog/en/google-ads/pmax-2025-faq-campaign-setup-brand-strategies-performance/) — Feed-only vs full-asset verdict
- [SMEC: Shopping Alongside PMax 2026](https://smarter-ecommerce.com/blog/en/google-ads/how-to-run-google-shopping-alongside-performance-max-in-2026/) — Priority change Oct 2024

### Tools
- [google/pmax_best_practices_dashboard](https://github.com/google/pmax_best_practices_dashboard) — Looker Studio + BQ dashboard with retail upgrade script
- [google-marketing-solutions/feedgen](https://github.com/google-marketing-solutions/feedgen) — AI feed optimization via Vertex AI
```

- [x] **Step 2: Commit**

```bash
git add reference/platforms/google-ads/pmax/feed-only-pmax.md
git commit -m "docs: add external sources section to feed-only-pmax.md"
```

---

## Verification

After all tasks are complete:

1. **Invoke `/ad-platform-campaign-manager:pmax-guide`** and say: "I have an e-commerce client with a Merchant Center feed and no creative assets, I want to set up PMax"
   - Expected: Claude asks about feed type, routes to feed-only path, explains listing groups step-by-step

2. **Invoke `/ad-platform-campaign-manager:campaign-setup`** and choose PMax for an e-commerce client with no creative
   - Expected: Claude does NOT say "Cannot launch" — routes to feed-only PMax setup

3. **Invoke `/ad-platform-campaign-manager:pmax-guide`** and say: "Client has messy Shopping + PMax campaigns competing for same products, need to restructure"
   - Expected: Claude walks through assessment → design → stepwise migration → rollback plan

4. **Read `reference/platforms/google-ads/pmax/feed-only-pmax.md`** and verify it covers:
   - [x] What feed-only PMax is
   - [x] When to use it (decision matrix)
   - [x] Minimum viable setup (step-by-step)
   - [x] Listing group configuration (what, how, strategies)
   - [x] Optional assets (what to add when)
   - [x] Merchant Center creation flow (both from MC and from Google Ads)
   - [x] Account restructuring pattern (assessment → design → migration → rollback)

5. **Check cross-references resolve:**
   - [x] `asset-requirements.md` callout links to `feed-only-pmax`
   - [x] `campaign-types.md` decision tree shows Feed-Only PMax
   - [x] `shopping-campaigns.md` comparison table has 3 columns
   - [x] `CONTEXT.md` has routing row for feed-only PMax
