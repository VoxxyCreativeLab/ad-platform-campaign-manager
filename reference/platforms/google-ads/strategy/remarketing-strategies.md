---
title: Remarketing Strategies
date: 2026-04-03
tags:
  - reference
  - google-ads
  - strategy
---

# Remarketing Strategies

Strategic remarketing framework — audience list design, funnel-stage segmentation, membership durations, frequency management, RLSA, and cross-channel remarketing. For audience type definitions and targeting mechanics, see [[strategy/targeting-framework]].

%%fact-check: Remarketing list requirements, membership durations, RLSA mechanics — verified against Google Ads Help 2026-04-03%%

## Decision Tree

```
What remarketing approach do you need?
├── Search remarketing (RLSA)
│   ├── Bid-only (observation mode) → Layer audiences on existing campaigns for bid adjustment
│   └── Target-only → Separate campaigns targeting ONLY past visitors with broader keywords
├── Display remarketing
│   ├── Standard → Show ads to past visitors across GDN
│   └── Dynamic → Auto-generated product ads based on viewed products (requires feed)
├── Video remarketing
│   └── YouTube viewers, channel subscribers → retarget on YouTube + GDN
├── Customer Match
│   └── Upload hashed customer data → target across Search, Shopping, YouTube, Display
└── Cross-channel (PMax)
    └── Audience signals with remarketing lists → PMax expands beyond your lists automatically
```

## Audience List Design

### Core Lists (Build These First)

Every account should have these foundational remarketing lists before running any remarketing campaigns:

| List | Definition | Membership Duration | Min Size |
|---|---|---|---|
| **All visitors** | Anyone who visited the site | 30 days | 1,000 (Search) / 100 (Display) |
| **All visitors — extended** | Same as above, longer window | 90 days | 1,000 / 100 |
| **Product/service page viewers** | Viewed a product page or service detail | 14 days | 1,000 / 100 |
| **Cart/form initiators** | Started checkout or began filling a form | 7 days | 1,000 / 100 |
| **Converters** | Completed purchase or lead submission | 180 days | Used for exclusion |
| **High-value converters** | Top 20% by transaction value or LTV | 365 days | Customer Match seed |

> [!tip] Tracking Specialist Implementation
> Build these lists using Google Ads Remarketing tags in GTM, or export GA4 Audiences to Google Ads via account linking. For the most control, use the Google Ads Remarketing tag with custom parameters — this avoids GA4 audience processing delays (up to 48 hours). See [[../../tracking-bridge/gtm-to-gads]] for tag implementation.

### Advanced Lists (Build When Core Lists Are Populated)

| List | Definition | Use Case |
|---|---|---|
| **Engaged visitors** | 3+ pages or 2+ minutes on site | Filter out bounces from remarketing pools |
| **Category-specific viewers** | Viewed products in a specific category | Category-specific remarketing creative |
| **Repeat visitors (no conversion)** | 3+ sessions, no conversion | High intent but blocked — investigate UX/offer |
| **Lapsed customers** | Purchased 90-365 days ago, no repeat | Win-back campaigns with incentive |
| **Video viewers** | Watched 50%+ of a YouTube video | Mid-funnel awareness → remarketing bridge |
| **App users** | Specific in-app actions | Cross-platform remarketing |

## Membership Duration Strategy

How long a user stays in your remarketing list depends on your sales cycle and vertical.

%%fact-check: Max membership duration 540 days — verified 2026-04-03%%

| Vertical | Recommended Durations | Rationale |
|---|---|---|
| **E-commerce** | 7d (cart), 14d (product), 30d (browse), 90d (lapsed) | Short purchase cycles; intent decays fast |
| **Lead generation** | 14d (form start), 30d (page visit), 60d (general) | Medium sales cycle; follow-up period matters |
| **B2B SaaS** | 30d (demo page), 90d (content), 180d (general) | Long buying cycles; committee decisions take months |
| **Local services** | 7d (service page), 14d (general) | Immediate need; if they haven't booked in 14 days, they found someone else |
| **Travel** | 14d (search), 30d (destination page), 90d (general) | Research phase is long but booking window is short |

> [!note] Maximum Duration
> Google Ads allows membership durations up to **540 days**. However, audience relevance degrades sharply after 90 days for most verticals. Only use 180-540 day windows for Customer Match or lapsed-customer win-back campaigns.

### Recency Layering

Create overlapping lists with different durations to apply different bids by recency:

```
0-7 days   ────────  Highest intent → highest bid adjustment (+40-60%)
0-14 days  ─────────────  High intent → moderate adjustment (+20-40%)
0-30 days  ──────────────────  Medium intent → light adjustment (+10-20%)
0-90 days  ────────────────────────────  Lower intent → no adjustment or slight
```

> [!warning] List Overlap
> A user in the 0-7 day list is also in the 0-14 and 0-30 day lists. Google uses the most specific list with the highest bid adjustment. Structure your campaign/ad group targeting to avoid conflicts — either use exclusions to create non-overlapping windows (7d, 8-14d, 15-30d) or rely on Google's "best match" behavior.

## RLSA (Remarketing Lists for Search Ads)

RLSA layers remarketing audiences onto Search campaigns. Two modes:

### Observation Mode (Bid-Only)

Add remarketing lists to existing Search campaigns without restricting targeting. Adjust bids for past visitors while still showing ads to everyone.

| Scenario | Adjustment | Example |
|---|---|---|
| Past visitors searching your brand | +30-50% | Ensure top position for returning visitors |
| Cart abandoners searching product terms | +50-70% | Aggressive bid for high-intent returners |
| Past purchasers searching related terms | +20-30% | Cross-sell opportunity |
| All visitors on competitor brand terms | +20-40% | Conquest with familiarity advantage |

### Targeting Mode (Target-Only)

Create separate campaigns or ad groups that ONLY show to past visitors. This unlocks:

- **Broader keywords** — terms that would be too expensive or irrelevant for cold traffic become profitable for past visitors
- **Custom ad copy** — reference their previous visit ("Welcome back", "Still looking for...?")
- **Different landing pages** — send returners to a streamlined page, not the full funnel

| Strategy | Keywords | Ad Copy | Landing Page |
|---|---|---|---|
| Generic keywords for returners | Broad match generics in your category | "Welcome back — [offer]" | Category page with returning visitor incentive |
| Competitor keywords for returners | Competitor brand terms | "Compare us vs [competitor]" | Comparison page |
| Upsell for past purchasers | Related product category terms | "Customers also bought..." | Cross-sell collection page |

> [!tip] RLSA Budget Allocation
> RLSA campaigns typically convert at 2-3x the rate of standard Search campaigns with 30-50% lower CPA. Allocate 10-20% of Search budget to RLSA-specific campaigns — it's often the highest-ROI allocation in the account.

## Dynamic Remarketing

For e-commerce accounts with a Merchant Center feed, dynamic remarketing auto-generates ads featuring the specific products a user viewed.

### Requirements

| Requirement | Details |
|---|---|
| **Merchant Center feed** | Active, approved product feed linked to Google Ads |
| **Remarketing tag with product parameters** | Must pass `ecomm_prodid` (matching feed `id`), `ecomm_pagetype`, `ecomm_totalvalue` |
| **Responsive display ads** | Google auto-generates layouts from your feed data + brand assets |
| **Min audience size** | 100 matched users for Display |

### Implementation via GTM

1. Google Ads Remarketing tag → fire on all pages
2. Custom parameters data layer → push `ecomm_prodid`, `ecomm_pagetype`, `ecomm_totalvalue`
3. Map data layer variables to tag parameters
4. See [[../../tracking-bridge/gtm-to-gads]] for full implementation

> [!info] Feed Quality Impact
> Dynamic remarketing ad quality depends directly on your feed. Poor titles, low-quality images, or missing prices result in ugly ads that hurt CTR. See [[shopping-feed-strategy]] for feed optimization.

## Cross-Channel Remarketing

### Platform Coordination

| Channel | Remarketing Capability | Best For |
|---|---|---|
| **Search (RLSA)** | Bid adjustment or targeting on search queries | High-intent returners actively searching |
| **Display (GDN)** | Banner ads across 2M+ websites | Broad awareness re-engagement |
| **YouTube** | Video ads to site visitors or channel viewers | Mid-funnel storytelling, brand reinforcement |
| **Demand Gen** | Gmail, Discover, YouTube Shorts | Native-format re-engagement |
| **PMax** | Audience signals (hints, not constraints) | Automated cross-channel remarketing |
| **Shopping** | Audience exclusions (purchaser suppression) | Prevent wasted spend on recent buyers |

### Frequency Across Channels

When running remarketing on multiple channels, total impressions per user stack up:

- 5 Display impressions + 3 YouTube impressions + 2 Gmail = 10 total per day
- Set channel-level caps: Display 3-5/day, YouTube 3/week, Demand Gen 3/week
- Monitor cross-channel frequency in Google Ads reach reports
- See [[strategy/targeting-framework#6. Frequency Capping]] for detailed caps

## Common Mistakes

| Mistake | Impact | Fix |
|---|---|---|
| Remarketing "all visitors" without segmentation | Treats bounces the same as cart abandoners | Segment by behaviour depth and recency |
| No converter exclusion | Showing ads to people who already purchased | Exclude converters list from all remarketing campaigns |
| Membership durations too long | Stale audiences, wasted budget, ad fatigue | Match duration to vertical sales cycle |
| No frequency capping | Ad fatigue, brand damage, wasted spend | Set caps: Display 3-5/day, Video 3/week |
| RLSA in targeting mode with small lists | List under 1,000 → campaign can't serve | Use observation mode until list reaches 1,000+ |
| Same creative for all funnel stages | Low relevance, poor CTR | Tailor creative by segment: awareness → consideration → conversion |
| Ignoring cross-channel frequency | Users bombarded across Display + YouTube + Gmail | Monitor total reach frequency; coordinate channel caps |

## Related

- [[strategy/targeting-framework]] — audience types, layering, PMax signals, frequency capping
- [[strategy/account-profiles]] — account archetype framework
- [[campaign-types]] — campaign type comparison
- [[shopping-feed-strategy]] — feed quality for dynamic remarketing
- [[../../tracking-bridge/gtm-to-gads]] — remarketing tag implementation
- [[../../tracking-bridge/bq-to-gads]] — Customer Match automation from BigQuery
