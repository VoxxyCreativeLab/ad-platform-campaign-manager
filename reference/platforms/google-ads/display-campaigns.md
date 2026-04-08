---
title: Display Campaigns
date: 2026-04-08
tags:
  - google-ads
  - display
  - reference
---

# Display Campaigns

The Google Display Network (GDN) reaches users across 35M+ websites, apps, and Google-owned properties (YouTube, Gmail, Google Maps). Display campaigns show image and video creative to users while they are browsing — passive exposure rather than active search intent.

**Primary use cases:** brand awareness, remarketing to previous visitors, upper-funnel reach, competitor conquesting at scale.

## 1. Overview

### GDN vs Search: Core Distinction

| Dimension | Search | Display |
|-----------|--------|---------|
| User intent | High (active query) | Low–Medium (passive browsing) |
| Creative format | Text only | Image, video, HTML5 |
| CTR | Higher (2–5% typical) | Lower (0.35% average) |
| Reach | Limited to searchers | 35M+ sites and apps |
| Targeting | Keywords (query-based) | Audiences, placements, context |
| Best for | Capture existing demand | Create demand, remarket |

Display should not be evaluated against Search CTR benchmarks — the two channels serve fundamentally different funnel positions.

### Google-Owned Properties on GDN

- **YouTube** — video and display ads within and around video content
- **Gmail** — ads in the Promotions and Social tabs
- **Google Maps** — display placements within the Maps app
- Third-party: news sites, blogs, apps, and any publisher in the Google AdSense network

> [!info] Display vs Demand Gen
> Demand Gen also uses GDN inventory (since April 2025) but is a distinct campaign type with social-style creative, lookalike segments, and mid-funnel positioning. Display campaigns offer more manual control: placement exclusions, manual bidding, granular targeting layering. See [[demand-gen]] for the side-by-side comparison.

## 2. Campaign Subtypes

| Subtype | Description | Best For | Bidding |
|---------|-------------|----------|---------|
| Standard Display | Full manual control over targeting, bids, and creative | Experienced advertisers, custom audiences, remarketing | tCPA, Maximize Conversions, Manual CPM, vCPM |
| Smart Display | Automated targeting + bidding + creative assembly | Quick setup, Google-managed optimization | tCPA only |

> [!tip] Standard vs Smart Display
> Smart Display is easier to launch but significantly less controllable. Use Standard Display when you need placement exclusions, specific audience lists, or manual bidding control. Smart Display cannot be layered with placement exclusions — if placement quality is a concern (and it usually is), use Standard.

## 3. Responsive Display Ad (RDA) Specs

Google assembles Responsive Display Ads automatically from the assets you provide. Providing the maximum number of assets improves Ad Strength and gives Google more combinations to test.

| Asset | Count Required | Size / Length |
|-------|---------------|---------------|
| Headlines | 5 (required) | max 30 chars each |
| Long headline | 1 (required) | max 90 chars |
| Descriptions | 5 (required) | max 90 chars each |
| Images — landscape | Up to 15 | 1.91:1 ratio; min 600×314px; recommended 1200×628px |
| Images — square | Up to 15 | 1:1 ratio; min 300×300px; recommended 1200×1200px |
| Logo — landscape | Up to 5 | 4:1 ratio; min 512×128px |
| Logo — square | Up to 5 | 1:1 ratio; min 128×128px; recommended 1200×1200px |
| Videos | Up to 5 | YouTube URL, any length |
| Business name | 1 (required) | max 25 chars |
| Final URL | 1 (required) | — |

**Ad Strength:** Aim for "Good" or "Excellent." Google mixes assets automatically — more unique headlines and descriptions = more combinations tested = better optimization signal. Avoid pinning assets unless legally required; pinning reduces the combinatorial space.

> [!warning] Image quality matters more than quantity
> Upload custom lifestyle or product images — do not rely solely on auto-generated images from your URL. Google can generate images automatically, but they are generic and often lower performing than intentional creative.

## 4. Targeting Types

### Audience Targeting

| Audience Type | Description | Use Case |
|---------------|-------------|----------|
| Custom segments (keyword intent) | Users who searched for specific terms on Google | High-intent prospecting |
| Custom segments (URL interest) | Users who browsed specific websites | Competitor and category targeting |
| In-market audiences | Active researchers/buyers in a category | Mid-funnel conversion push |
| Affinity audiences | Users with long-term interest patterns | Brand awareness, upper funnel |
| Remarketing lists | Previous website visitors, app users, YouTube viewers | Retargeting |
| Customer Match | Uploaded hashed email/phone lists | CRM-based targeting or exclusion |
| Similar segments | Users resembling your existing audience lists | Prospecting near look-alikes |

### Contextual Targeting

| Type | How It Works | Use Case |
|------|-------------|----------|
| Keywords (contextual) | Ads appear on pages whose content matches your keywords | Relevant page-level targeting |
| Topics | Ads appear on pages broadly matching a content category | Wider reach than keyword context |

**Note:** Contextual keywords in Display target the page content, not a user query. They are fundamentally different from Search keywords.

### Placement Targeting

Target specific websites, YouTube channels, or apps directly. Most precise targeting option but significantly limits reach. Use for high-value sites or competitor conquesting. Best combined with remarketing rather than cold prospecting.

### Demographic Targeting

Age, gender, household income, parental status. Layer on top of audience targeting to refine reach — do not use demographics alone without an audience signal.

> [!warning] Layering targeting types
> Stacking targeting types (e.g., audience AND placement AND demographic) restricts reach dramatically — you are requiring the user to match all conditions simultaneously. For awareness campaigns, use a single broad audience signal. For remarketing, use audience + frequency cap. Placement + audience layering is appropriate only when volume is not a constraint.

## 5. Exclusion Management

Exclusions are the single highest-leverage lever in Display campaigns. Poor placement quality is the default state — you must actively manage it.

### Placement Exclusions

- **`adsenseformobileapps.com`** — exclude by default. Mobile app traffic inflates impressions and clicks with near-zero purchase intent. This is the most commonly cited source of Display waste.
- Parked domains and error pages — Google excludes many automatically, but verify in campaign Content Exclusions settings.
- Review the **Group Placement Report** weekly via GAQL (`group_placement_view` — see [[reference/reporting/gaql-query-templates|gaql-query-templates]]).
- Add exclusions at both **campaign level** and **account level** via shared placement exclusion lists. Account-level lists apply across all campaigns automatically.

### Content Exclusions (Campaign Settings)

| Exclusion Type | When to Enable |
|----------------|---------------|
| Sensitive categories (gambling, alcohol, violence, tragedy) | Any brand-safety-conscious advertiser |
| Digital content label DL-MA (mature audiences) | B2B, children's brands, regulated industries |
| Digital content label DL-T (teen audiences) | Children's brands, strict brand safety |
| Parked domains | Always recommended |
| Live streaming video | If video context is not relevant to your brand |

### Topic and Keyword Exclusions

Negative keywords on Display campaigns block pages whose content matches those terms — they do not block search queries (that is a Search-only concept). Use negative keywords to prevent your ads from appearing on pages about competitors, DIY alternatives, or unrelated categories.

## 6. Frequency Capping

Uncapped Display campaigns cause ad fatigue and waste spend on users who have already ignored your ad multiple times.

| Audience Type | Recommended Cap | Notes |
|---------------|----------------|-------|
| Remarketing | 3–5 impressions/day | Higher frequency is acceptable for hot remarketing (cart abandoners) |
| Cold audiences (prospecting) | 1–2 impressions/day | Lower frequency = more unique users reached per budget |
| Default (Smart Bidding) | Google optimizes automatically | Smart Bidding adjusts frequency based on predicted conversion probability |

**Manual cap setting:** Available in campaign Settings > Frequency management. Set at impression level per day, week, or month per user.

**Cross-device note:** Frequency capping operates at the user level based on Google sign-in data, not at the device level. A user on multiple devices counts as one user if signed in to Google — reducing double-counting compared to cookie-based approaches.

## 7. Performance Benchmarks

Display CTR is inherently lower than Search. Evaluating Display on CTR alone is misleading — a 0.35% CTR on Display is normal and not a signal of poor performance.

| Metric | Average | Good | Excellent |
|--------|---------|------|-----------|
| CTR | 0.35% | 0.50–0.75% | >1% |
| CPC | $0.50–$3.00 (varies by industry) | — | — |
| View-through conversion rate | 0.5–2% | — | Varies by VTC window setting |

**Primary evaluation metrics:** Conversion cost (CPA), view-through conversion rate, and brand lift — not CTR. If CTR is below 0.3%, investigate targeting quality and creative relevance before assuming the channel is failing.

## 8. Display-Specific Bid Strategies

| Strategy | Use Case | Notes |
|----------|----------|-------|
| Target CPA | Lead gen with conversion history | Requires 30+ conversions in last 30 days to exit learning |
| Maximize Conversions | When volume > efficiency; new campaigns | Good starting strategy before switching to tCPA |
| Target CPM (Manual) | Brand awareness, fixed cost per thousand impressions | Pay per 1,000 impressions regardless of clicks |
| Viewable CPM (vCPM) | Viewability-focused awareness | Pay only when 50%+ of the ad is visible for 1+ second |
| Target ROAS | E-commerce with conversion value tracking | Requires reliable conversion value data and sufficient volume |

> [!warning] Enhanced CPC deprecated
> Enhanced CPC (eCPC) was deprecated in March 2025. Do not use it in new campaigns. Existing eCPC campaigns should migrate to Maximize Conversions or Target CPA.

## 9. Common Mistakes

| Mistake | Impact | Fix |
|---------|--------|-----|
| No placement exclusions | Mobile app spam and low-quality sites dominate spend | Exclude `adsenseformobileapps.com` immediately; review placement report weekly |
| No audience or placement targeting (fully open) | Budget wasted on irrelevant content with no signal | Layer audience targeting or start with remarketing lists |
| VTC window left at 30-day default | View-through conversions inflate reported performance | Reduce VTC window to 1 day (conservative) or 7 days (moderate) |
| Comparing Display CTR to Search CTR | Wrong expectation setting; good campaigns get paused | Display CTR 0.35% is normal; evaluate on CPA/ROAS |
| Smart Display for remarketing | Cannot add placement exclusions to Smart Display | Use Standard Display for all remarketing campaigns |
| No frequency cap | Ad fatigue, diminishing returns as campaign matures | Cap at 3–5/day for remarketing; 1–2/day for cold prospecting |
| No content exclusions | Brand appears on inappropriate or brand-unsafe content | Enable sensitive category exclusions in all Display campaigns |
| Layering too many targeting types | Reach collapses; campaign cannot spend budget | Use one primary targeting signal; add a second only if reach remains sufficient |

## 10. Audit Cross-Reference

The 20 Display audit checks are in [[audit-checklist]] Area 14 (lines 194–226). Key checks mapped to this document:

| Audit Check | Section in This Doc |
|-------------|-------------------|
| Display separated from Search (no combined campaigns) | Section 2 — Campaign Subtypes |
| Frequency capping configured | Section 6 — Frequency Capping |
| Targeting expansion / optimized targeting reviewed | Section 4 — Targeting Types |
| Audience segments match goal (affinity / in-market / remarketing) | Section 4 — Targeting Types |
| Placement exclusion lists applied | Section 5 — Exclusion Management |
| Mobile app placements excluded | Section 5 — Exclusion Management |
| Content exclusions configured | Section 5 — Exclusion Management |
| All RDA asset slots populated | Section 3 — RDA Specs |
| Ad strength Good or Excellent | Section 3 — RDA Specs |
| CTR benchmarks checked | Section 7 — Performance Benchmarks |
| VTC reviewed separately from click-through | Section 9 — Common Mistakes (VTC row) |
| VTC window set appropriately | Section 9 — Common Mistakes (VTC row) |

## 11. GAQL for Display

Reference [[reference/reporting/gaql-query-templates|gaql-query-templates]] — `## Display Performance` section. The key query uses `group_placement_view` to surface placement-level metrics (impressions, clicks, conversions, cost) so you can identify low-quality placements for exclusion.

Example GAQL pattern:

```sql
SELECT
  group_placement_view.display_name,
  group_placement_view.placement,
  group_placement_view.placement_type,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions,
  metrics.cost_micros
FROM group_placement_view
WHERE campaign.advertising_channel_type = 'DISPLAY'
  AND metrics.impressions > 100
ORDER BY metrics.cost_micros DESC
```

Run weekly to identify high-spend, low-conversion placements for exclusion.

## 12. MCP Boundary Note

> [!info] What MCP can and cannot do for Display
> **MCP can pull:** placement performance (`group_placement_view`), campaign-level metrics, audience performance (`ad_group_audience_view`), creative performance by asset combination.
>
> **MCP cannot:** add or remove placement exclusions, create or modify audience lists, adjust frequency caps, modify content exclusion settings.
>
> All write operations for Display campaign management require the Google Ads UI. Reference [[reference/mcp/mcp-capabilities|mcp-capabilities]] for the full read/write boundary map.

## Related

- [[campaign-types]] — campaign type comparison and decision tree
- [[demand-gen]] — Demand Gen vs Display comparison; GDN expansion details
- [[conversion-actions]] — conversion action setup including VTC window configuration
- [[reference/reporting/gaql-query-templates|gaql-query-templates]] — `group_placement_view` queries for placement auditing
- [[audit-checklist]] — Area 14 (Display), 20 checks
