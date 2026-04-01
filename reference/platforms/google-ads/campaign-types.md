---
title: Google Ads Campaign Types
date: 2026-03-28
tags:
  - reference
  - google-ads
---

# Google Ads Campaign Types

## Decision Tree: Which Campaign Type?

```
What is your primary goal?
├── Drive sales/leads from search intent → SEARCH
├── Sell physical products with images/prices → SHOPPING (needs Merchant Center)
├── Capture long-tail queries from website content → DSA
├── Maximize conversions across all Google channels → PERFORMANCE MAX
├── Build brand awareness with visual ads → DISPLAY
├── Drive action through visual storytelling → DEMAND GEN
├── Video views / brand awareness on YouTube → VIDEO
├── App installs / in-app actions → APP
└── Local store visits / calls → PERFORMANCE MAX (with store goals)
```

## Search Campaigns

**Best for:** Capturing existing demand from users actively searching for your product/service.

- **Ad format:** Text ads (Responsive Search Ads — RSAs)
- **Targeting:** Keywords (broad, phrase, exact match)
- **Where ads show:** Google Search, Search Partners
- **When to use:**
  - High-intent products/services (people search before buying)
  - Lead generation (forms, calls, sign-ups)
  - E-commerce with specific product searches
  - Brand protection (bidding on your own brand name)
- **Typical bid strategies:** Target CPA, Target ROAS, Maximize Conversions
- **Structure:** Campaign → Ad Groups (themed by keyword clusters) → Keywords + RSAs

### RSA Requirements
- **Headlines:** 3-15 (minimum 3, recommended 15 for max combinations)
- **Descriptions:** 2-4 (minimum 2, recommended 4)
- **Display URL paths:** 2 optional path fields (15 chars each)
- Google tests combinations automatically; pin headlines/descriptions only when legally required

## Performance Max (PMax)

**Best for:** Maximizing conversions across ALL Google channels with a single campaign.

- **Ad format:** Auto-generated from asset groups (text, images, video)
- **Targeting:** Audience signals + Google's AI
- **Where ads show:** Search, Display, YouTube, Gmail, Discover, Maps, Shopping
- **When to use:**
  - E-commerce / Shopping (feed-based)
  - Businesses wanting maximum reach with minimal management
  - When you have good conversion data (needs 30+ conversions/month)
  - Multi-channel presence without managing separate campaigns
- **Typical bid strategies:** Maximize Conversions, Maximize Conversion Value
- **Structure:** Campaign → Asset Groups (each with audience signals + creative assets)

### PMax Considerations
- Limited reporting transparency (improving but still less granular than Search)
- May cannibalize brand Search traffic
- Needs quality creative assets (images, videos, text) to perform well
- Works best with a Merchant Center product feed for Shopping
- See `/ad-platform-campaign-manager:pmax-guide` for detailed guidance

## Display Campaigns

**Best for:** Building awareness, remarketing to past visitors, reaching users while browsing.

- **Ad format:** Responsive display ads (images + text auto-combined)
- **Targeting:** Audiences (affinity, in-market, custom), placements, topics, demographics
- **Where ads show:** Google Display Network (3M+ websites/apps)
- **When to use:**
  - Brand awareness / top-of-funnel
  - Remarketing to website visitors
  - Prospecting with audience targeting
  - Visual products that benefit from imagery
- **Typical bid strategies:** Target CPA, Maximize Conversions, viewable CPM

### Display Image Specs
- Landscape: 1200x628 (required)
- Square: 1200x1200 (required)
- Logo: 1200x1200 (square), 1200x300 (landscape)

## Demand Gen Campaigns

**Best for:** Visual storytelling to drive action on YouTube, Discover, Gmail.

- **Ad format:** Image ads, video ads, carousel ads
- **Targeting:** Google audiences, lookalike segments, customer lists
- **Where ads show:** YouTube (in-feed, Shorts), Discover feed, Gmail
- **When to use:**
  - Mid-funnel engagement
  - Visually appealing products/services
  - Social-media-style ad creative
  - Reaching users in "discovery" mindset
- **Typical bid strategies:** Maximize Conversions, Target CPA

See [[demand-gen]] for full details including asset requirements, audience strategy, and tracking implications.

## Video Campaigns

**Best for:** YouTube advertising for awareness, consideration, or action.

- **Subtypes:**
  - **Video reach:** Maximize impressions (bumper, in-stream)
  - **Video views:** Maximize views (in-feed, in-stream skippable)
  - **Video action:** Drive conversions (in-stream with CTAs)
- **Where ads show:** YouTube, Google video partners

See [[video-campaigns]] for full details including format specs, targeting options, and tracking implications (VTC, cross-device, sGTM).

## Shopping Campaigns

**Best for:** E-commerce product ads with images, prices, and merchant info in search results.

- **Ad format:** Product listing ads (from Merchant Center feed)
- **Targeting:** Product groups (brand, category, item ID, custom labels)
- **Where ads show:** Google Search, Shopping tab
- **When to use:**
  - E-commerce with a product catalog
  - When product images/prices drive clicks
  - When you want product-level ROAS tracking
  - Google Merchant Center account required
- **Typical bid strategies:** Manual CPC, Target ROAS, Maximize Conversion Value

See [[shopping-campaigns]] for full details including feed requirements, priority strategies, and tracking implications.

## Dynamic Search Ads (DSA)

**Best for:** Supplementing keyword campaigns by auto-generating ads from your website content.

- **Ad format:** Text ads with auto-generated headlines from page content
- **Targeting:** Website pages (page feeds, URL rules, categories)
- **Where ads show:** Google Search
- **When to use:**
  - Large product catalogs or content sites
  - Capturing long-tail queries your keyword list misses
  - Keyword gap discovery (mine search terms for new keywords)
  - Quick campaign launches without extensive keyword research
- **Typical bid strategies:** Maximize Conversions, Target CPA

See [[dsa]] for full details including page feed setup, exclusion best practices, and tracking implications (landing page coverage audit).

## Campaign Type Comparison

| Feature | Search | PMax | Shopping | Display | Demand Gen | Video | DSA |
|---------|--------|------|----------|---------|------------|-------|----|
| Intent level | High | Mixed | High | Low-Med | Medium | Low-Med | High |
| Control | High | Low | High | Medium | Medium | Medium | Medium |
| Reporting depth | High | Limited | High | Medium | Medium | Medium | High |
| Creative needs | Text only | All formats | Product feed | Images+text | Images+video | Video | Auto+text |
| Min budget | Low | Medium | Low | Low | Medium | Medium | Low |
| Beginner-friendly | Yes | Yes* | Medium | Remarketing | No | No | Yes |
| Conv. data needed | Some | 30+/month | Some | Some | Some | Some | Some |

*\* PMax is easy to set up but hard to diagnose when underperforming — limited reporting transparency.*
