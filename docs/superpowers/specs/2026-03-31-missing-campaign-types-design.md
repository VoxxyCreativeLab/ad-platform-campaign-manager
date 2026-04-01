---
title: "Design: Missing Campaign Types"
date: 2026-03-31
tags:
  - design
  - audit-finding-2
---

# Design: Missing Campaign Types

## Problem

The plugin's reference knowledge base covers Search, PMax, and Display campaigns in detail but lacks standalone documentation for 4 campaign types: Shopping, Video/YouTube, Dynamic Search Ads (DSA), and Demand Gen. This means the plugin cannot guide setup, review, or tracking for these types.

Identified in the plugin audit of 2026-03-31 (Finding #2 in [[PLAN]]).

## Approach

**Approach A: Four flat reference files** — create 4 standalone `.md` files in `reference/platforms/google-ads/`, following the same structure as existing reference docs. Update `campaign-types.md` with cross-references and update CONTEXT.md routing.

Chosen over subdirectories (premature — no active clients need deep coverage yet) and expanding `campaign-types.md` (violates selective-loading design principle).

## Deliverables

### New Files

| File | Path | Topic |
|------|------|-------|
| `shopping-campaigns.md` | `reference/platforms/google-ads/` | Google Shopping / Merchant Center |
| `video-campaigns.md` | `reference/platforms/google-ads/` | YouTube Video campaigns (all subtypes) |
| `dsa.md` | `reference/platforms/google-ads/` | Dynamic Search Ads |
| `demand-gen.md` | `reference/platforms/google-ads/` | Demand Gen campaigns |

### Updated Files

| File | Change |
|------|--------|
| `reference/platforms/google-ads/campaign-types.md` | Keep existing brief sections, add "See [[filename]] for full details" wikilink at end of each |
| `reference/platforms/google-ads/CONTEXT.md` | Add 4 new files to routing table |
| `reference/CONTEXT.md` | Update file count |
| `PLAN.md` | Mark Finding #2 status as complete when done |

## File Structure (Each New File)

Every file follows the reference file convention from `_config/conventions.md`:

1. **YAML frontmatter** — `title`, `date: 2026-03-31`, `tags: [reference, google-ads]`
2. **H1 title** — matching the `title` property
3. **When to Use** — decision criteria, ideal scenarios, comparison vs alternatives
4. **How It Works** — campaign structure, targeting, ad formats, specs tables
5. **Best Practices** — setup tips, optimization, common mistakes to avoid
6. **Tracking Implications** — what a tracking specialist needs to know (GTM setup, conversion considerations, measurement gaps, sGTM relevance)
7. **Cross-references** — wikilinks to related files (`[[campaign-types]]`, `[[bidding-strategies]]`, etc.)

The **Tracking Implications** section is unique to this plugin. It bridges campaign type knowledge with the user's tracking expertise.

## Content Outline Per File

### shopping-campaigns.md

**When to Use:**
- E-commerce product sales, product-feed-driven campaigns
- Google Merchant Center integration required
- When you want product images/prices in search results

**How It Works:**
- Standard Shopping campaign structure (campaign → product groups)
- Product group subdivisions (brand, category, item ID, custom labels)
- Feed structure requirements (title, description, GTIN, price, availability)
- Bidding: manual CPC, Target ROAS, Maximize Conversion Value
- Priority levels for multi-campaign Shopping strategies (high/medium/low)
- Standard Shopping vs PMax with feed (comparison — PMax has replaced Smart Shopping)

**Best Practices:**
- Feed quality is everything: title optimization formula, GTINs, product categories
- Negative keywords still work in Shopping (unlike PMax)
- Campaign structure by product margin or category
- Subdivision strategies for different business types
- Supplemental feeds for overriding attributes

**Tracking Implications:**
- Revenue tracking via purchase events (transaction_id required for dedup)
- Merchant Center ↔ Google Ads account linking
- Product-level ROAS measurement
- Dynamic remarketing tags for Shopping audiences
- Feed-based conversion value vs actual transaction value reconciliation
- Cross-references: `[[conversion-actions]]`, `[[gtm-to-gads]]`

### video-campaigns.md

**When to Use:**
- Brand awareness on YouTube
- Consideration / mid-funnel engagement
- Direct action (conversions from video ads)
- YouTube Shorts advertising

**How It Works:**
- Campaign subtypes: Video Reach, Video Views, Video Action, Demand Gen (video), Shorts
- Ad formats table: skippable in-stream, non-skippable in-stream (15s), bumper (6s), in-feed, Shorts
- Specs per format: length limits, companion banner sizes, CTA overlay requirements
- Targeting: demographics, affinity audiences, custom intent, topic targeting, placement targeting
- Bidding: CPV (cost-per-view), CPM, Target CPA (Video Action only)

**Best Practices:**
- Hook in first 5 seconds (skippable ads)
- CTAs and companion banners always on
- Frequency capping to avoid fatigue
- Audience sequencing (show different ads based on prior engagement)
- Creative variants for different placements (landscape vs vertical for Shorts)

**Tracking Implications:**
- View-through conversions (VTC) vs click-through — VTC inflates attribution
- YouTube engagement events in GA4 (video_start, video_progress, video_complete)
- Cross-device attribution challenges (users watch on phone, convert on desktop)
- sGTM considerations: video view events don't pass through standard tag firing
- Brand Lift studies (requires Google rep) for awareness measurement
- Cross-references: `[[conversion-actions]]`, `[[enhanced-conversions]]`

### dsa.md

**When to Use:**
- Supplement keyword-based Search campaigns
- Capture long-tail queries you haven't thought of
- Large product catalogs or content sites
- Fill gaps in keyword coverage

**How It Works:**
- Auto-generated headlines from page content (Google crawls landing pages)
- Targeting methods: all web pages, specific page categories, page feed (URLs + custom labels)
- Description lines are manual (2 descriptions, 90 chars each)
- Landing page selection: Google matches query to most relevant page
- Ad group structure: one DSA ad group per page category/feed label

**Best Practices:**
- Always use page feeds for control (don't let Google target everything)
- Exclude pages that shouldn't trigger ads: careers, privacy policy, blog, support, 404
- Negative keywords: cross-reference with existing Search campaigns to avoid overlap
- Structure by page category (products → one ad group, services → another)
- Mine DSA search terms report for new keyword ideas → add to Search campaigns
- Bidding: start with Maximize Conversions, move to Target CPA once data accumulates

**Tracking Implications:**
- Same conversion tracking as Search (click-based, standard tag firing)
- Critical: auto-targeting may send traffic to pages WITHOUT conversion tracking
- Must verify every page in the page feed has proper GTM tags deployed
- Landing page coverage audit: check that all targeted URLs fire the conversion tag
- Cross-references: `[[conversion-actions]]`, `[[gtm-to-gads]]`, `[[audit-checklist]]`

### demand-gen.md

**When to Use:**
- Mid-funnel visual engagement (not pure awareness, not pure conversion)
- Social-media-style creative on Google surfaces
- Reaching users in "discovery" mindset (YouTube in-feed, Discover, Gmail)
- When you have strong visual assets (lifestyle imagery, short video)

**How It Works:**
- Ad formats: single image, carousel (2-10 cards), video (landscape + vertical)
- Placements: YouTube in-feed, YouTube Shorts, Discover feed, Gmail promotions tab
- Audience targeting: Google audiences (affinity, in-market), lookalike/similar segments, customer lists, optimized targeting
- Asset requirements table per format (image dimensions, video specs, headline/description limits)
- Bidding: Maximize Conversions, Target CPA, Maximize Conversion Value

**Best Practices:**
- High-quality lifestyle creative — avoid stocky/corporate imagery
- Test image vs video vs carousel formats (video typically wins for engagement)
- Audience signals matter more than keywords (no keyword targeting in Demand Gen)
- Budget: Google recommends 10-15x target CPA as daily budget minimum
- Optimized targeting: start enabled, narrow later based on performance
- Frequency: monitor ad fatigue — rotate creative every 4-6 weeks

**Tracking Implications:**
- View-through attribution default is 30-day window — may inflate reported conversions
- Engagement tracking in GA4 (ad_click, ad_impression, ad_view)
- Consent mode implications: audience list matching depends on consent signals
- Limited search term visibility (unlike Search/DSA)
- Cross-device measurement more critical here (discovery → research → convert)
- Cross-references: `[[conversion-actions]]`, `[[enhanced-conversions]]`, `[[data-flow-diagrams]]`

## What This Does NOT Include

- **Skill changes:** Existing skills (campaign-setup, campaign-review, etc.) are not updated to reference these new docs. That's a separate improvement (Finding #3: Workflow dead-ends or separate scope).
- **Subdirectories:** No `shopping/` or `video/` folders. If depth is needed later, files can be promoted to directories.
- **Non-Google platforms:** Meta, LinkedIn, TikTok remain .gitkeep placeholders (Phase 4).

## Verification

After implementation:
1. All 4 new files exist and follow conventions (frontmatter, H1, sections, wikilinks)
2. `campaign-types.md` cross-references all 4 new files
3. `reference/platforms/google-ads/CONTEXT.md` lists all 4 new files
4. Wikilinks resolve correctly (test by reading cross-referenced files)
5. No broken references or orphaned links
