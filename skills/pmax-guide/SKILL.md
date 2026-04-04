---
name: pmax-guide
description: Performance Max guidance — feed-only PMax, full PMax, asset groups, audience signals, feed optimization, listing groups, PMax metrics interpretation. Use when working with PMax campaigns.
argument-hint: "[feed-only|full|optimize|report]"
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
- **Account profiles and archetypes:** [[../../reference/platforms/google-ads/strategy/account-profiles|account-profiles.md]]

## Step 0: Determine PMax Type

### Maturity and Budget Gate

Before determining PMax type, verify this account can run PMax effectively. Ask:
- **"How many conversions per month does this account generate?"**
- **"What's the monthly Google Ads budget?"**

| Situation | Verdict | Action |
|-----------|---------|--------|
| < 30 conversions/month | **Not ready for PMax** | "PMax needs 30+ conversions/month to optimize. Build conversion history with Search first." → `/ad-platform-campaign-manager:campaign-setup` |
| Micro budget (< EUR 1K/mo) | **PMax not viable** | "PMax needs ~EUR 50/day minimum to learn. At this budget, Search campaigns will be more effective." → `/ad-platform-campaign-manager:campaign-setup` |
| Small budget (EUR 1-5K/mo) | **Marginal** | "PMax can work at this budget if it's the only campaign, but leaves no room for Search. Proceed with awareness of the tradeoff." |
| Medium+ budget (EUR 5K+) + 30+ conv | **PMax viable** | Continue to PMax type selection below. |

If the user has run `/ad-platform-campaign-manager:account-strategy`, ask for their archetype number. State: "Based on your **Archetype #[X]** profile, here's how PMax fits your account."

Consult [[../../reference/platforms/google-ads/strategy/account-profiles|account-profiles.md]] for archetype-specific PMax recommendations.

### PMax Type Selection

Now determine which PMax configuration to use. Ask:

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
   - Subdivide by custom label, category, or brand (7 dimension types available)
   - Ensure NO product overlap between asset groups
   - Listing groups are for inclusion/exclusion only — NOT for bidding
5. Configure audience signals per asset group (match audience to product segment)
6. Add optional text assets (headlines, descriptions) and logo — low effort, meaningful impact
7. Configure brand exclusions (prevent cannibalizing brand Search)
8. Add negative keywords (up to 10,000 per campaign + shared lists)
9. Verify conversion tracking is configured

### Setting Up Full PMax (With Creative Assets)
1. Define campaign goal and bid strategy
2. Design asset group structure (by product category or audience)
3. Configure audience signals per asset group
4. List required creative assets with specifications (consult [[../../reference/platforms/google-ads/pmax/asset-requirements|asset-requirements.md]])
5. Set up listing groups (if Merchant Center feed is linked — see [[../../reference/platforms/google-ads/pmax/feed-only-pmax|feed-only-pmax.md]] for listing group details)
6. Configure brand exclusions
7. Discuss conversion tracking requirements

### Restructuring: Shopping+PMax → Clean Feed-Based PMax

When a client has messy overlapping Shopping and PMax campaigns, walk through the restructuring pattern:

1. **Ask:** What campaigns exist? (types, product scope, daily budgets)
2. **Ask:** Which products appear in multiple campaigns?
3. **Ask:** What's the 90-day ROAS per campaign and product segment?
4. **Note:** Since late 2024, PMax is no longer auto-prioritized over Shopping — they compete on Ad Rank. Running both is viable (70/30 or 80/20 split).
5. **Design:** Propose a clean PMax structure (by margin tier or category) with non-overlapping listing groups
6. **Migrate:** Stepwise — create new PMax paused → configure listing groups → pause old Shopping for overlapping products → enable new PMax → monitor 2-4 weeks
7. **Rollback:** Keep old campaigns paused (not deleted) for 30 days

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
- Channel distribution (Shopping vs Search vs Display vs YouTube vs Gmail vs Discover)
- Listing group performance (which product segments convert)

### Feed Optimization (Shopping/E-commerce)
Walk through product feed improvements:
- Title optimization formula and examples
- Required vs recommended attributes
- Custom labels for campaign segmentation (the power tool for listing groups)
- Supplemental feed strategy

### Vertical-Specific PMax Guidance

Adapt PMax advice based on the account's vertical:

**E-commerce:**
- Feed-only PMax is the default starting point (90% of spend goes to feed-based surfaces)
- Segment asset groups by margin tier using custom labels (high margin → higher ROAS target)
- Seasonal product rotation: pause off-season asset groups, adjust targets for peak periods
- Only add creative assets (images, video) when you specifically need YouTube or Display reach

**Lead Gen / B2B SaaS:**
- Non-feed PMax only — no Merchant Center product feed
- Audience signals are the primary lever: in-market segments, custom intent keywords, customer lists
- Fewer creative assets needed than e-commerce — focus on headline/description quality
- Critical: conversion tracking must be solid before PMax (it amplifies bad tracking)
- B2B SaaS: consider only at Established+ maturity with 50+ conversions/month

**Local Services:**
- Store goals PMax for multi-location businesses
- Location-specific asset groups (one per service area or store)
- Combine with local Search campaigns — PMax handles Display/YouTube/Discovery surfaces
- Budget carefully: local audiences are smaller, PMax may overspend on irrelevant geo

## Key Points to Emphasize

- PMax needs 30+ conversions/month for effective optimization (60+ ideal)
- Audience signals are **hints**, not hard targeting
- **Feed-only PMax:** Auto-generated YouTube ads are the weakest surface — acceptable for launch, add custom video as resources allow. 90% of spend goes to feed-based surfaces anyway.
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
| PMax and Shopping competing for same products | Both campaign types targeting the same catalog | Restructure: migrate to clean PMax with proper listing groups; pause overlapping Shopping. Or run both with 70/30 split. |

## What to Do Next

Based on the PMax work completed, recommend the next skill:

| Situation | Next Skill |
|-----------|-----------|
| PMax launched, need to monitor performance | `/ad-platform-campaign-manager:live-report` |
| Conversion tracking issues found during setup | `/ad-platform-campaign-manager:conversion-tracking` |
| Budget needs reallocation across campaigns | `/ad-platform-campaign-manager:budget-optimizer` |
| Account has structural issues beyond PMax | `/ad-platform-campaign-manager:campaign-cleanup` |
| No strategy profile established yet | `/ad-platform-campaign-manager:account-strategy` |
