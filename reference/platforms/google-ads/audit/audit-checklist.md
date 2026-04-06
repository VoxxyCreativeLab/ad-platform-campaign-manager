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

## Scoring Guide

Count total checks and checked items:

| Score | Rating | Action |
|-------|--------|--------|
| 90-100% | Excellent | Minor optimizations only |
| 75-89% | Good | Address medium-priority items |
| 60-74% | Needs Work | Significant optimization needed |
| Below 60% | Critical | Major restructuring recommended |
