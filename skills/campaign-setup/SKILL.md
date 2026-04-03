---
name: campaign-setup
description: Guided campaign builder — walks through type selection, structure, ad groups, and keyword strategy with best practices. Use when starting a new Google Ads campaign.
argument-hint: "[campaign-type]"
disable-model-invocation: false
---

# Guided Campaign Setup

You are helping build a new Google Ads campaign. Walk the user through each step, explaining best practices along the way. The user is a tracking specialist, not a campaign expert — teach while you build.

If `$ARGUMENTS` specifies a campaign type (search, pmax, display, demand-gen, video), skip the type selection step.

## Step 1: Define the Business Goal

Ask the user:
1. What is the client's business? (product, service, industry)
2. What is the primary goal? (sales, leads, awareness, traffic)
3. What is the target geography? (country, region, city)
4. What is the monthly budget range?
5. Does the client have existing conversion tracking? (If yes, which conversions are set up?)

## Step 2: Select Campaign Type

Based on the goal, recommend a campaign type. Consult [[../../reference/platforms/google-ads/campaign-types|campaign-types.md]] for the decision tree.

Present the recommendation with reasoning:
- Why this type matches their goal
- What the alternatives are and why they're less suitable
- What prerequisites exist (conversion data for PMax, creative assets for Display/Demand Gen)

## Step 3: Design Campaign Structure

Based on the selected type, design the full campaign structure. Consult [[../../reference/platforms/google-ads/account-structure|account-structure.md]] for patterns.

**For Search campaigns:**
- Propose campaign name following the naming convention: `{{type}} | {{goal}} | {{targeting}} | {{region}}`
- Design ad groups (one theme per ad group)
- For each ad group: suggest 10-15 keywords with recommended match types
- Consult [[../../reference/platforms/google-ads/match-types|match-types.md]] for match type strategy

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

**For Display/Demand Gen/Video:**
- Propose targeting strategy (audiences, placements)
- List creative requirements
- Recommend bid strategy

## Step 4: Write Ad Copy

**For Search (RSAs):**
Generate 15 headlines and 4 descriptions per ad group:
- Headlines should include: keywords, value propositions, CTAs, brand name, differentiators
- Descriptions should expand on headlines with features, benefits, social proof
- Follow Google's RSA best practices (variety, no repetition, sentence case)

**For PMax/Display:**
Generate text assets:
- 5 headlines (30 chars), 5 long headlines (90 chars), 5 descriptions (90 chars)
- Business name, optional display URL paths

## Step 5: Recommend Bid Strategy

Based on campaign type and available data, recommend a bidding strategy. Consult [[../../reference/platforms/google-ads/bidding-strategies|bidding-strategies.md]].

- New account with no data → Manual CPC or Maximize Clicks
- Some conversion data → Maximize Conversions
- 30+ conversions/month → Target CPA or Target ROAS
- Explain the recommended strategy and why

## Step 6: Configure Extensions/Assets

Recommend and draft extensions. Consult [[../../reference/platforms/google-ads/ad-extensions|ad-extensions.md]].

Minimum set:
- 4 sitelinks (with headlines and descriptions)
- 4 callouts
- 1 structured snippet

Additional if relevant: call, location, image, promotion

## Step 7: Conversion Tracking Check

Verify conversion tracking is ready:
- Is a primary conversion action configured?
- Is enhanced conversions enabled?
- Is the tag implemented (GTM/sGTM)?

If not, recommend using `/ad-platform-campaign-manager:conversion-tracking` to set up.

## Common Blockers

Before proceeding to the campaign plan, check for these blockers:

| Blocker | Impact | Resolution |
|---------|--------|------------|
| No creative assets for Display/Demand Gen | Cannot launch — these types require images and video | Recommend starting with Search while assets are produced, or provide asset specs |
| No creative assets for PMax (no feed) | Cannot launch — non-feed PMax requires images and video | Recommend starting with Search while assets are produced |
| No creative assets for PMax (has MC feed) | CAN launch — feed-only PMax auto-generates from product data | Proceed with feed-only PMax setup. See `/ad-platform-campaign-manager:pmax-guide` |
| Monthly budget under €300 for Search | Too thin to gather meaningful data across multiple ad groups | Limit to 1-2 tightly themed ad groups with exact/phrase match only; avoid broad match |
| No conversion tracking in place | Smart bidding won't work; campaign will optimize for clicks only | Set up tracking first via `/ad-platform-campaign-manager:conversion-tracking` before launching |
| Client wants PMax but has fewer than 30 conversions/month | PMax needs conversion volume to optimize | Start with Search to build conversion history, then migrate to PMax after reaching 30+/month |

## Step 8: Output Campaign Plan

Output a structured campaign plan document that includes:
1. **Campaign overview:** name, type, goal, budget, bid strategy, targeting
2. **Ad groups/asset groups:** names, themes, keywords or audience signals
3. **Ad copy:** all headlines, descriptions, assets
4. **Extensions:** all recommended extensions with copy
5. **Negative keywords:** initial negative keyword list
6. **Conversion tracking status:** what's set up, what's needed
7. **Next steps:** checklist for implementing in Google Ads

Format as a clean, copyable document the user can reference while building in the Google Ads interface.
