---
title: Video Campaigns
date: 2026-03-31
tags:
  - reference
  - google-ads
---

# Video Campaigns

YouTube and Google Video Partner advertising for awareness, consideration, and direct action. Video campaigns run across YouTube (in-stream, in-feed, Shorts) and the Google Video Partner network.

## When to Use

- **Brand awareness:** reach large audiences on YouTube with sight/sound/motion
- **Consideration:** drive views and engagement for mid-funnel audiences
- **Direct action:** convert viewers into leads or customers (Video Action campaigns)
- **YouTube Shorts:** reach mobile-first audiences with vertical video
- **Not for:** bottom-funnel intent capture (use Search), product catalog ads (use Shopping)

## How It Works

### Campaign Subtypes

| Subtype | Goal | Bidding | Primary Format |
|---------|------|---------|----------------|
| Video Reach | Maximize impressions | CPM, Target CPM | Bumper (6s), non-skippable in-stream (15s) |
| Video Views | Maximize views | CPV (cost-per-view) | Skippable in-stream, in-feed |
| Video Action | Drive conversions | Target CPA, Maximize Conversions | Skippable in-stream with CTA |
| Demand Gen (video) | Mid-funnel engagement | Target CPA, Maximize Conversions | In-feed, Shorts, Discover |

### Ad Format Specs

| Format | Max Length | Skip Option | Where It Shows | Companion Banner |
|--------|-----------|-------------|----------------|-----------------|
| Skippable in-stream | No limit (rec 15s-3min) | Skip after 5s | Before/during/after videos | Yes (300x60) |
| Non-skippable in-stream | 15 seconds | No skip | Before/during/after videos | Yes (300x60) |
| Bumper | 6 seconds | No skip | Before/during/after videos | Yes (300x60) |
| In-feed | No limit | N/A — click to play | YouTube search, home, watch next | No |
| Shorts | 60 seconds max | Swipe to skip | YouTube Shorts feed | No |

### Targeting Options

| Targeting Type | Description |
|----------------|-------------|
| Demographics | Age, gender, parental status, household income |
| Affinity audiences | Broad interest categories (sports fans, tech enthusiasts) |
| In-market audiences | Actively researching or comparing products |
| Custom audiences | Your own keyword/URL/app-based audiences |
| Topic targeting | Content topics of videos/channels |
| Placement targeting | Specific YouTube channels, videos, or websites |
| Remarketing | Your website visitors, YouTube channel viewers, customer lists |

### Bidding by Goal

| Goal | Strategy | You Pay For |
|------|----------|-------------|
| Awareness (reach) | Target CPM | Per 1,000 impressions |
| Views | CPV | Per view (30s or full video, whichever is shorter) |
| Conversions | Target CPA / Maximize Conversions | Per click (auction-based) |
| Conversion value | Maximize Conversion Value / Target ROAS | Per click (auction-based) |

## Best Practices

### Creative

- **Hook in first 5 seconds** — state the value proposition immediately (skippable ads)
- **Show brand early** — within first 5 seconds, not just at the end
- **Clear CTA** — tell viewers exactly what to do ("Visit site", "Sign up", "Shop now")
- **Companion banners:** always upload custom companion banners (300x60) for in-stream ads
- **Shorts creative:** vertical (9:16), fast-paced, native-feeling (not repurposed landscape ads)

### Campaign Management

- **Frequency capping:** limit to 3-5 impressions per week per user to avoid fatigue
- **Audience sequencing:** show different ads based on prior engagement (awareness → consideration → action)
- **Separate campaigns by goal:** don't mix awareness and conversion objectives in one campaign
- **Exclude placements:** kids content, irrelevant channels, competitor channels (optional)
- **Schedule:** run Video Action campaigns during business hours if you need same-day follow-up

### Budget Guidelines

| Campaign Type | Recommended Daily Budget |
|---------------|-------------------------|
| Video Reach (CPM) | €20+ for meaningful reach |
| Video Views (CPV) | €10+ (typical CPV: €0.02-0.10) |
| Video Action (CPA) | 10-15x target CPA minimum |

## Tracking Implications

### View-Through Conversions (VTC)

- Video campaigns report both click-through and **view-through conversions**
- VTC = user saw the ad, didn't click, but converted within the attribution window
- Default VTC window: **30 days** — this can significantly inflate reported conversions
- **Recommendation:** review VTC separately from click-through; consider reducing the VTC window to 7 days for more conservative attribution
- VTC is reported in the "View-through conversions" column (not the main "Conversions" column by default)

### GA4 YouTube Engagement Events

- YouTube engagement events in GA4: `video_start`, `video_progress` (25%, 50%, 75%), `video_complete`
- These track organic YouTube views — not the same as ad engagement
- For ad engagement tracking: use the Google Ads conversion tag, not GA4 YouTube events
- Cross-reference GA4 assisted conversions to see video's role in the conversion path

### Cross-Device Attribution

- Common pattern: user watches YouTube ad on mobile → researches on desktop → converts
- Google's cross-device tracking helps but depends on signed-in users
- **Enhanced conversions** improve cross-device matching — see [[enhanced-conversions]]
- Monitor device reports: if mobile views are high but conversions are low, check desktop conversion rates

### sGTM Considerations

- Standard YouTube ad impressions/views do NOT pass through GTM/sGTM tag firing
- Video ad clicks DO trigger a landing page visit → standard tag firing applies
- For Video Action campaigns: tracking is the same as Search (click → land → convert)
- For awareness/views campaigns: attribution relies on Google's own measurement, not your GTM setup

### Brand Lift Studies

- Available for awareness campaigns with sufficient budget (typically €10k+ spend)
- Measures: ad recall, brand awareness, consideration, purchase intent
- Requires Google rep to set up — not self-service
- Consider for large brand campaigns where traditional conversion tracking doesn't capture value

## Related

- [[campaign-types]] — campaign type comparison and decision tree
- [[conversion-actions]] — conversion action types and setup
- [[enhanced-conversions]] — cross-device matching for video viewers
- [[bidding-strategies]] — bid strategy selection guide
