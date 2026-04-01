---
title: Demand Gen Campaigns
date: 2026-03-31
tags:
  - reference
  - google-ads
---

# Demand Gen Campaigns

Visual, social-media-style campaigns that run across YouTube (in-feed, Shorts), Google Discover, and Gmail. Designed for mid-funnel engagement — reaching users in a "discovery" mindset with rich creative.

> [!info] Formerly Discovery Campaigns
> Google rebranded Discovery campaigns to Demand Gen in 2023, adding new features: lookalike segments, video support, Shorts placements, and product feeds. If you see references to "Discovery campaigns" in older documentation, they are now Demand Gen.

## When to Use

- **Mid-funnel engagement:** between awareness (Display/Video) and conversion (Search)
- **Visual products/services:** lifestyle imagery, short video, carousel-style creative
- **Social-media-style advertising** on Google surfaces (not Meta/TikTok — those are separate platforms)
- **Reaching users in discovery mode:** browsing YouTube home, scrolling Discover, checking Gmail
- **Not for:** high-intent search capture (use Search), pure brand awareness at scale (use Video Reach), or granular keyword targeting

### Demand Gen vs Display vs Video

| Factor | Demand Gen | Display | Video |
|--------|------------|---------|-------|
| Placements | YouTube in-feed, Shorts, Discover, Gmail | Google Display Network (3M+ sites) | YouTube + Video Partners |
| Creative | Image, video, carousel | Responsive display ads | Video only |
| Intent level | Medium (discovery) | Low (passive browsing) | Low-Medium |
| Audience focus | Strong (lookalikes, customer lists) | Medium | Medium |
| Best for | Mid-funnel visual engagement | Remarketing, broad reach | Awareness, YouTube presence |

## How It Works

### Ad Formats

| Format | Assets Required | Where It Shows |
|--------|-----------------|----------------|
| Single image | 1-20 images + headlines + descriptions | Discover, YouTube in-feed, Gmail |
| Carousel | 2-10 image cards + headline per card | Discover, YouTube in-feed, Gmail |
| Video | 1+ videos (landscape + vertical rec.) | YouTube in-feed, Shorts |

### Asset Requirements

| Asset | Spec | Limit |
|-------|------|-------|
| Landscape image | 1200x628 (1.91:1) | Required, up to 20 |
| Square image | 1200x1200 (1:1) | Required, up to 20 |
| Portrait image | 960x1200 (4:5) | Optional, up to 20 |
| Logo | 1200x1200 (1:1) | Required |
| Headline | 40 characters | Up to 5 |
| Description | 90 characters | Up to 5 |
| Business name | 25 characters | Required |
| CTA | Auto or selected (Learn More, Sign Up, Shop Now, etc.) | 1 |
| Video (landscape) | 16:9, 10s-60s recommended | Optional, up to 5 |
| Video (vertical) | 9:16, for Shorts | Optional, up to 5 |
| Carousel card image | 1200x1200 (1:1) or 1200x628 (1.91:1) | 2-10 cards |

### Placements

| Placement | User Context | Creative Shown |
|-----------|-------------|----------------|
| YouTube Home feed | Browsing recommended videos | In-feed image/video ad |
| YouTube Shorts | Scrolling short-form videos | Vertical video or image |
| YouTube In-stream | Watching videos | Skippable video ad |
| Google Discover | Scrolling news/interest feed (mobile) | Image or carousel |
| Gmail Promotions | Checking email promotions tab | Collapsed ad → expanded landing |

### Audience Targeting

| Audience Type | Description |
|---------------|-------------|
| Google audiences | Affinity (interests), In-market (active shoppers), Life events |
| Lookalike segments | Similar audiences based on your seed list (customer list or converters) |
| Customer lists | Upload hashed email/phone lists for targeting or exclusion |
| Remarketing | Website visitors, YouTube viewers, app users |
| Optimized targeting | Google expands beyond your signals to find likely converters |

> [!tip] Lookalike Segments
> Lookalike segments are Demand Gen's equivalent of Meta's Lookalike Audiences. Upload a seed list (customer emails) and Google finds similar users. Available in Narrow (2.5%), Balanced (5%), and Broad (10%) expansion levels.

### Bidding Strategies

| Strategy | When to Use |
|----------|-------------|
| Maximize Conversions | Starting out — let Google learn |
| Target CPA | Once you have 15+ conversions/month |
| Maximize Conversion Value | E-commerce — optimize for revenue |
| Target ROAS | Mature campaigns with consistent ROAS data |

## Best Practices

### Creative

- **Lifestyle imagery** — avoid corporate stock photos, staged scenes, or heavy text overlays
- **Test formats:** image vs video vs carousel — video typically wins for engagement, carousel for product discovery
- **Creative diversity:** provide multiple images/videos per format — Google tests combinations
- **Refresh creative every 4-6 weeks** — Demand Gen audiences see ads repeatedly, fatigue is real
- **Vertical video for Shorts** — don't repurpose landscape video; create native vertical content

### Audience Strategy

- **Start with lookalike segments** based on your best customers (highest LTV or most purchases)
- **Layer interests on top** of lookalike for more refined targeting
- **Enable optimized targeting** initially — it expands reach but review performance after 2 weeks
- **Exclude converters** — upload customer lists as exclusions to avoid wasting budget on existing customers

### Budget and Bidding

- **Minimum daily budget:** 10-15x your target CPA (Google's recommendation)
- **Learning period:** allow 2-3 weeks before judging performance — Demand Gen needs time to optimize
- **Don't scale too fast** — increase budget by max 20% per week to maintain performance stability
- **Separate campaigns by audience type** (prospecting vs remarketing) for cleaner reporting

### Common Mistakes

| Mistake | Fix |
|---------|-----|
| Low-quality creative | Use lifestyle imagery, test video, refresh every 4-6 weeks |
| Too narrow audience | Start broader (lookalike + optimized targeting), narrow later |
| Judging too early | Allow 2-3 week learning period before making changes |
| Budget too low | Minimum 10-15x target CPA daily — below this, Google can't optimize |
| Mixing prospecting + remarketing | Separate into distinct campaigns for budget control |
| No customer list exclusions | Upload converters as exclusion list to avoid waste |

## Tracking Implications

### View-Through Attribution (Critical)

- Demand Gen default **view-through conversion window is 30 days**
- This means: user sees ad in Discover feed, doesn't click, converts 3 weeks later → Demand Gen gets credit
- This can **significantly inflate** reported conversions compared to click-only attribution
- **Recommendation:**
  - Review "View-through conversions" column separately from "Conversions"
  - Consider reducing VTC window to 7 days for more conservative reporting
  - Compare Demand Gen reported conversions vs GA4 assisted conversions for the same period

### Engagement Tracking in GA4

- Demand Gen clicks create standard `session_start` events in GA4 with `utm_source=google` / `utm_medium=cpc`
- Ad impressions (views without click) are NOT tracked in GA4 — only in Google Ads
- For click-based conversions, tracking is identical to Search campaigns
- For view-through conversions, rely on Google Ads reporting (GA4 can't see ad impressions)

### Consent Mode Implications

- **Customer list matching** depends on user consent signals
- If consent mode is active and a user has not consented to `ad_storage`, their email won't match against your customer list
- Lookalike segment seed lists are also affected — consent refusals reduce your match rate
- **Recommendation:** monitor customer list match rates in Google Ads Audience Manager. If below 30%, investigate consent mode configuration
- See [[enhanced-conversions]] for consent-aware user data handling

### Cross-Device Measurement

- Discovery journey is typically cross-device: see ad on mobile Discover → research on desktop → convert
- Google's cross-device reports help, but accuracy depends on signed-in Google users
- Enhanced conversions improve cross-device matching — strongly recommended for Demand Gen
- Monitor device segmentation: if mobile has high engagement but low conversions, check desktop conversion funnel

### Limited Search Term Visibility

- Unlike Search or DSA, Demand Gen does NOT have a search terms report
- You cannot see which queries triggered your ads — targeting is audience-based, not query-based
- This means you cannot mine Demand Gen for keyword insights (use Search and DSA for that)
- Focus optimization on audience signals and creative performance instead

## Related

- [[campaign-types]] — campaign type comparison and decision tree
- [[conversion-actions]] — conversion action setup and configuration
- [[enhanced-conversions]] — improved cross-device and consent-aware tracking
- [[data-flow-diagrams]] — full tracking architecture overview
