---
title: Google Ads Campaign Audit Checklist
date: 2026-04-01
tags:
  - reference
  - google-ads
  - audit
---

# Google Ads Campaign Audit Checklist

## Account Level

### Conversion Tracking
- [ ] At least one primary conversion action is active and recording
- [ ] Conversion counting correct (One for leads, Every for sales)
- [ ] Attribution model set to data-driven
- [ ] Conversion windows match sales cycle
- [ ] Enhanced conversions enabled
- [ ] Conversion values set (dynamic preferred)
- [ ] No duplicate conversions (check for double-firing tags)
- [ ] Consent Mode v2 implemented (required in EEA; `ad_storage`, `ad_user_data`, `ad_personalization`, `analytics_storage` signals firing correctly)

### Account Settings
- [ ] Auto-tagging enabled
- [ ] IP exclusions configured (office IPs)
- [ ] Linked to GA4 property
- [ ] Linked to Google Merchant Center (if e-commerce)
- [ ] Linked to YouTube channel (if running video)

## Campaign Level

### Structure
- [ ] Campaigns named consistently (Type | Goal | Targeting | Region)
- [ ] Brand and non-brand campaigns separated
- [ ] Each campaign has a clear, distinct purpose
- [ ] No campaign overlap (competing for same traffic)
- [ ] Budget distributed proportionally to performance/priority

### Targeting
- [ ] Location targeting set to "Presence" (not "Presence or interest")
- [ ] Correct geographic targeting
- [ ] Language targeting matches audience
- [ ] Ad schedule set (if business hours apply)
- [ ] Device adjustments considered

### Bidding
- [ ] Bid strategy matches campaign goal
- [ ] Sufficient conversion data for smart bidding (15-30/month minimum)
- [ ] Target CPA/ROAS based on actual data, not aspirational goals
- [ ] No campaigns stuck in "Learning" for over 2 weeks

### Budget
- [ ] Daily budgets sufficient for the bid strategy to work
- [ ] No campaigns limited by budget on high-performing keywords
- [ ] Shared budgets used intentionally (not accidentally)
- [ ] Budget pacing checked (spend vs. budget)
- [ ] AI Max for Search: if enabled, review auto-generated assets and expanded matching; ensure brand controls are configured

## Ad Group Level

### Structure
- [ ] Max 7-10 ad groups per campaign (3-5 ideal)
- [ ] Each ad group has a single clear theme
- [ ] Ad group names are descriptive
- [ ] No ad groups with zero impressions (paused or fix)

### Keywords
- [ ] Max 15-20 keywords per ad group
- [ ] Keywords match the ad group theme
- [ ] Match types intentional (not all defaulting to broad)
- [ ] No conflicting keywords across ad groups
- [ ] Low Quality Score keywords identified and addressed
- [ ] Search terms reviewed (last 7/14/30 days)
- [ ] Irrelevant search terms added as negatives

### Negative Keywords
- [ ] Account-level negative keyword lists in place
- [ ] Campaign-level negatives for cross-campaign conflicts
- [ ] Common irrelevant terms excluded (jobs, free, how to, etc.)
- [ ] Negative keyword lists reviewed quarterly

## Ad Level

### RSA Quality
- [ ] Each ad group has at least 1 RSA (recommended 2-3)
- [ ] 15 unique headlines per RSA (or as many as possible)
- [ ] 4 descriptions per RSA
- [ ] Ad strength: "Good" or "Excellent" (not "Poor" or "Average")
- [ ] Headlines include keywords, value props, CTAs, brand
- [ ] No duplicate messaging across headlines
- [ ] Pinning used sparingly (only for legal/compliance)
- [ ] Display URL paths set with relevant keywords

### Landing Pages
- [ ] Landing pages match ad messaging
- [ ] Mobile-friendly design
- [ ] Fast load time (LCP < 2.5s)
- [ ] Clear CTA above the fold
- [ ] No broken landing page URLs (404s)
- [ ] HTTPS enabled

## Assets (formerly Extensions)
- [ ] Sitelinks: min 4 (linking to distinct pages)
- [ ] Callouts: min 4 (unique benefits/features)
- [ ] Structured snippets: at least 1 relevant header
- [ ] Call asset (if phone inquiries matter)
- [ ] Location asset (if physical stores)
- [ ] Image assets (if visual products)
- [ ] Assets reviewed for performance quarterly

## PMax Specific (if applicable)
- [ ] Each asset group has theme-appropriate audience signals
- [ ] Asset groups have diverse, high-quality images
- [ ] At least one custom video provided (not relying on auto-generated)
- [ ] "Low" performing assets identified and scheduled for replacement
- [ ] Brand exclusion list applied (to protect brand Search campaigns)
- [ ] Brand exclusion scope understood (applies to Search and Shopping channels only)
- [ ] Product feed optimized (titles, images, GTINs)
- [ ] Listing groups filtered appropriately per asset group
- [ ] Campaign-level negative keywords configured (up to 10,000 supported)
- [ ] Search terms report reviewed (full query visibility available since March 2025)
- [ ] Channel performance report reviewed (identify underperforming channels)
- [ ] Audience exclusions configured (exclude existing customers where appropriate)
- [ ] Demographic exclusions reviewed (age, gender, household income)
- [ ] Search themes per asset group reviewed (up to 50 per asset group)


## Shopping Specific (if Shopping campaigns present)

### Feed Health & Merchant Center
- [ ] Merchant Center linked and active (Tools > Linked accounts)
- [ ] Feed processing without critical errors (MC > Diagnostics)
- [ ] Disapproval rate below 2% of total products
- [ ] Price accuracy: feed prices match landing page prices (mismatches cause disapprovals)
- [ ] Required attributes populated: id, title, description, link, image_link, price, availability
- [ ] GTIN coverage above 90% for branded products

### Product Group Structure
- [ ] Product groups subdivided beyond default "All Products" (never bid on everything equally)
- [ ] Structure aligns with business logic (category, margin tier, brand, or custom label)
- [ ] "Everything else" catch-all group has the lowest bid or is excluded
- [ ] No empty product groups with zero impressions in last 30 days
- [ ] Ad group naming follows account convention (not platform-default or original language)

### Bidding
- [ ] Bid strategy matches conversion volume (Manual CPC < 50 conv/mo; tROAS > 50 conv/mo, sustained 4+ weeks)
- [ ] Product group bids differentiated by performance (winners higher, losers lower)
- [ ] Bids at or above benchmark CPC (check Benchmark max CPC column in product groups view)
- [ ] Default max CPC set intentionally (not leftover from initial campaign setup)
- [ ] Budget utilization > 80%/day (if spending well below daily budget, bids are likely too low)

### Competitive Metrics
- [ ] Click share reviewed (target > 50% on core product groups; 35% = losing 2/3 of eligible clicks)
- [ ] Search impression share reviewed (target 60-80% on top product groups)
- [ ] Search IS lost to budget vs lost to rank distinguished (budget = increase spend; rank = increase bids/feed quality)
- [ ] Auction Insights reviewed for top competitor overlap

### Negative Keywords
- [ ] Negative keyword lists applied to Shopping campaigns
- [ ] Search terms report reviewed (last 30 days minimum)
- [ ] Irrelevant queries excluded (DIY, care, free, jobs, how-to, informational)

### Product-Level Performance
- [ ] "Zombie" products identified: products with spend and zero conversions over 30+ days
- [ ] Products with zero impressions flagged (catalog coverage gap — may indicate feed or bid issue)
- [ ] Top 10 revenue products verified as active and not disapproved

### Shopping Tracking
- [ ] Dynamic remarketing tag fires on product pages with ecomm_prodid matching feed id
- [ ] Revenue reconciliation: Google Ads reported revenue vs backend (< 5% discrepancy acceptable)

## Audience Strategy

### Remarketing Lists
- [ ] Remarketing lists built and populated: all visitors, product viewers, cart abandoners, converters
- [ ] Audience membership durations match vertical sales cycle (e-commerce: 7/14/30/90 days typical)
- [ ] Audience sizes above minimum thresholds (1,000 for Display; 1,000 for Search/Shopping RLSA)
- [ ] Lists refreshing properly (not stale or empty — check Audience Manager)

### Exclusions
- [ ] Converter exclusion list applied to all prospecting campaigns
- [ ] Bounce suppression list active (exclude visits < 10 seconds — prevents wasted bids)
- [ ] Customer list exclusions applied where showing to existing customers is inappropriate

### RLSA & Audience Layering
- [ ] RLSA audiences layered on Search campaigns (at minimum observation mode)
- [ ] Bid adjustments set for high-value segments (cart abandoners, past purchasers)

### Customer Match
- [ ] Customer Match list uploaded and refreshed (quarterly minimum)
- [ ] Match rate above 30% (below 30% indicates Consent Mode or list quality issues)

## Display Campaign (if Display campaigns present)

### Campaign Settings
- [ ] Display campaigns separated from Search (never run Display+Search in a combined campaign)
- [ ] Campaign objective matches actual goal (awareness vs remarketing vs conversions)
- [ ] Frequency capping configured (3-5 impressions/week for awareness; 5-7/week for remarketing)
- [ ] Ad rotation set to Optimize (best-performing ads)
- [ ] Location targeting set to Presence (not Presence or interest)

### Targeting
- [ ] Targeting expansion / optimized targeting reviewed and intentionally enabled or disabled
- [ ] Audience segments appropriate for goal (affinity = awareness; in-market = conversions; remarketing lists = retargeting)
- [ ] Remarketing campaigns using product feed for dynamic display ads (if e-commerce)
- [ ] No overly broad targeting (all users with no audience signals — wastes budget)
- [ ] Audience exclusions configured (exclude converters from prospecting Display campaigns)

### Placement Controls
- [ ] Placement exclusion lists applied (poor-quality sites, apps, kids content)
- [ ] Automatic placements reviewed for quality (Where ads showed report, last 30 days)
- [ ] Mobile app placements excluded or reviewed (notorious for accidental clicks)
- [ ] Content exclusions configured (sensitive categories, parked domains, error pages)

### Responsive Display Ads
- [ ] All asset slots populated (landscape 1200×628, square 1200×1200, logo 1200×1200)
- [ ] Up to 5 short headlines, 1 long headline, 5 descriptions provided
- [ ] Ad strength: Good or Excellent (not Poor or Average)
- [ ] Custom uploaded images used (not relying solely on auto-generated)

### Performance
- [ ] CTR benchmarks checked (Display CTR typically 0.5-1.0%; below 0.3% = investigate targeting or creative)
- [ ] View-through conversions reviewed separately from click-through conversions
- [ ] VTC window set appropriately (consider 7 days, not default 30-day)

## Demand Gen (if Demand Gen campaigns present)

### Campaign Settings
- [ ] Campaign objective aligned with actual goal (mid-funnel engagement vs conversion)
- [ ] Channel controls configured at ad group level (YouTube, GDN, Discover, Gmail selected intentionally)
- [ ] Budget at minimum 10-15x target CPA daily (Google recommendation for optimization)
- [ ] Learning period respected (2-3 weeks before judging performance or making changes)

### Creative
- [ ] Lifestyle imagery used (no corporate stock photos, heavy text overlays, or staged scenes)
- [ ] All formats tested: image, video, carousel (video typically wins for engagement)
- [ ] Vertical video provided for Shorts placement (native vertical, not repurposed landscape)
- [ ] Creative refreshed within last 4-6 weeks (fatigue is the #1 Demand Gen risk for static creative)

### Audiences
- [ ] Lookalike / audience suggestion segments configured from best customers
- [ ] Customer list exclusions applied (existing customers excluded from prospecting)
- [ ] Optimized targeting reviewed after first 2 weeks (may expand too broadly)
- [ ] Prospecting and remarketing separated into distinct campaigns (not mixed)

### Measurement
- [ ] View-through conversion window reviewed (default 30 days — consider reducing to 7 for conservative reporting)
- [ ] VTC analyzed separately from click-through (Demand Gen VTC can significantly inflate reported conversions)

## Competitive Analysis (cross-campaign)

### Competitive Position
- [ ] Auction Insights reviewed for top campaigns (impression share, overlap rate, outranking share)
- [ ] Top 3-5 competitors identified from Auction Insights data
- [ ] Impression share lost to rank vs lost to budget distinguished (rank = quality/bid issue; budget = spend constraint)
- [ ] Absolute top impression share reviewed for brand campaigns (target > 80% on brand terms)
- [ ] Competitor bidding on brand terms detected (check if non-brand CPCs appear in brand campaign)
- [ ] Price Competitiveness report reviewed in Merchant Center (products priced 20%+ above market get fewer Shopping impressions — e-commerce only)

## Feed Health (if e-commerce with Merchant Center feed)

> [!info] This section expands on the basic feed checks in Shopping Specific > Feed Health & MC. Run both for e-commerce accounts — Shopping pre-flight (6 checks) + this deeper audit (10 checks).

### Feed Quality
- [ ] Feed update frequency: daily minimum; every 4-6 hours for dynamic pricing
- [ ] Disapproval rate below 2% of total products (MC > Diagnostics)
- [ ] Price accuracy: feed prices match landing page prices (mismatches cause disapprovals)
- [ ] GTIN coverage above 90% for branded products (missing GTINs = lost auctions)
- [ ] Image quality: minimum 800×800px, white background, no watermarks or text overlays
- [ ] All required attributes populated (id, title, description, link, image_link, price, availability)
- [ ] Supplemental feed in use for title overrides, custom labels, or promotions data
- [ ] Content API migration planned if applicable (Content API sunsets August 18, 2026)
- [ ] Feed rules configured for title/description optimization where needed
- [ ] MC Price Competitiveness report reviewed (products priced 20%+ above market flagged)

## Video / YouTube (if Video campaigns present)

### Creative Quality
- [ ] Hook delivers value proposition within first 5 seconds (before skip button appears)
- [ ] Brand name or logo visible within first 5 seconds
- [ ] Companion banner uploaded for in-stream ads (300×60px)
- [ ] All applicable formats tested: skippable in-stream, non-skippable, bumper, in-feed, Shorts

### Targeting & Controls
- [ ] Frequency capping configured (3-5 impressions/week for awareness; 5-7/week for remarketing)
- [ ] Placement exclusions active: kids content, competitor channels, low-quality sites
- [ ] YouTube channel linked to Google Ads account (required for audience list building)
- [ ] Prospecting and remarketing separated into distinct campaigns

### Measurement
- [ ] View-through conversion (VTC) window reviewed (default 30 days often inflates; consider 7 days)
- [ ] VTC analyzed separately from click-through conversions in reports
- [ ] Creative refreshed within last 4-6 weeks (video fatigue is faster than display)
- [ ] Brand Lift study eligibility assessed if spend > EUR 10,000 (requires Google rep)

## Cross-Campaign Cannibalization

### Campaign Overlap
- [ ] PMax brand search cannibalization assessed — brand exclusion list applied to PMax campaigns
- [ ] PMax vs Standard Shopping product overlap mapped — overlapping product sets cause internal auction conflict (PMax wins auction priority)
- [ ] Search vs DSA keyword overlap managed — cross-negatives in place where Search and DSA target same pages
- [ ] Brand campaign protected from non-brand spillover — campaign-level negatives prevent internal bidding on branded terms
- [ ] Cross-campaign negative keyword lists shared — no active campaigns competing for the same user intent

## Attribution Depth

### Attribution Configuration
- [ ] Attribution windows match vertical sales cycle (e-commerce impulse: 7-14 days; B2B: 60-90 days)
- [ ] View-through conversion window reviewed across all conversion actions (default 30-day may inflate results)
- [ ] Google Ads vs GA4 conversion discrepancy documented and within acceptable range (< 15% gap is normal; > 30% needs investigation)
- [ ] Assisted conversions reviewed before pausing any upper-funnel campaign (last-click-only view understates value)
- [ ] Value-based bidding eligibility assessed — requires reliable conversion values and sufficient volume (50+ conv/month)

## Account-Level Strengthening

### Account Hygiene
- [ ] Conversion Linker tag verified present on all site pages (not just landing pages)
- [ ] Account-level automated extensions reviewed — auto-generated sitelinks, callouts, and images may be off-brand or inaccurate
- [ ] Cross-campaign budget allocation reviewed — consider 70/20/10 split (proven campaigns / optimization / testing)
- [ ] Change history reviewed for too-frequent Smart Bidding changes (more than 2 significant changes/week resets learning period)
- [ ] Data exclusions configured for known measurement gaps (tracking outages, consent-blocked periods, site downtime)

## Scoring Guide

Count total checks and checked items:

| Score | Rating | Action |
|-------|--------|--------|
| 90-100% | Excellent | Minor optimizations only |
| 75-89% | Good | Address medium-priority items |
| 60-74% | Needs Work | Significant optimization needed |
| Below 60% | Critical | Major restructuring recommended |
