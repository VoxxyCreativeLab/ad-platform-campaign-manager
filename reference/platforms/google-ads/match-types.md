---
title: Google Ads Keyword Match Types
date: 2026-04-01
tags:
  - reference
  - google-ads
---

# Google Ads Keyword Match Types

## The Three Match Types

### Broad Match (default)
**Syntax:** `keyword` (no symbols)

Matches searches related to your keyword, including synonyms, related searches, and implied intent.

**Example:** `running shoes` matches "buy sneakers online", "best jogging footwear"

**When to use:** With smart bidding + solid conversion data. Maximum reach.

### Phrase Match
**Syntax:** `"keyword"`

Matches searches that include the meaning of your keyword in the specified order.

**Example:** `"running shoes"` matches "buy running shoes online", "running shoes sale"

**When to use:** More control than broad, more reach than exact. Good for testing.

### Exact Match
**Syntax:** `[keyword]`

Matches searches with the same meaning/intent. Allows close variants (plurals, misspellings).

**Example:** `[running shoes]` matches "running shoes", "shoes for running"

**When to use:** High-value terms, brand terms, top performers.

## AI Max for Search

> [!warning] AI Max Overrides Match Types
> AI Max for Search is a campaign-level toggle (globally available mid-2025) that, when enabled, **overrides your match type settings entirely**. Google expands targeting beyond your keyword lists using broad match + keywordless (DSA-like) targeting powered by Gemini.

### What AI Max Does

- Treats all keywords as broad match regardless of their configured match type
- Adds keywordless query matching (similar to DSA) using your landing page content
- Uses Gemini models to understand intent and expand beyond explicit keyword lists
- Applies at the campaign level — either on or off for the entire campaign

### When Match Type Strategy Still Matters

The match type strategy by maturity framework below is **still valid for non-AI-Max campaigns**. If you haven't enabled AI Max, your match type settings behave as documented. However, Google has been pushing **broad match + smart bidding** as the default recommended approach for all advertisers, and AI Max takes this philosophy further by removing keyword-level control entirely.

### Recommendation

- For new campaigns: start with the maturity framework below. Enable AI Max once you have sufficient conversion data and trust smart bidding.
- For mature campaigns already running broad match + smart bidding: AI Max is a natural next step. Monitor search terms closely during the transition.
- Always maintain strong negative keyword lists — AI Max makes them more important, not less.

## Strategy by Campaign Maturity

| Stage | Approach |
|-------|----------|
| New, limited data | Phrase + exact. Gather conversion data first. |
| 30+ conversions/month | Add broad match with smart bidding. |
| Mature, rich data | Primarily broad + smart bidding, exact for top terms. |

## Negative Keywords

Prevent ads from showing for irrelevant searches.

| Type | Syntax | Blocks |
|------|--------|--------|
| Negative broad | `keyword` | Queries containing ALL terms (any order) |
| Negative phrase | `"keyword"` | Queries containing exact phrase |
| Negative exact | `[keyword]` | Queries matching exactly |

**Important:** Negative keywords do NOT include close variants. Add singular + plural forms.

### PMax Negative Keywords

Performance Max campaigns now support negative keywords — a major change from PMax's original launch:

- **Campaign-level negatives (March 2025):** up to 10,000 negative keywords per PMax campaign, managed directly in the Google Ads UI
- **Shared negative keyword lists (August 2025):** PMax campaigns can use account-level shared negative keyword lists, just like Search and Shopping campaigns

This closes one of PMax's biggest control gaps. Apply your standard negative keyword lists to PMax campaigns to prevent wasted spend on irrelevant queries.

### Best Practices
1. Review search terms weekly
2. Build shared negative keyword lists at account level
3. Common negatives: "jobs", "careers", "free", "how to", "what is"
4. Use cross-campaign negatives to prevent ad group competition
5. Apply shared negative keyword lists to PMax campaigns — they support them now

## Brand Restrictions for Search

Brand Restrictions allow advertisers to limit which queries trigger their broad match or AI Max keywords, preventing brand terms from showing for competitor searches.

> [!info] Different from PMax brand exclusions
> Brand Restrictions (Search) and Brand Exclusions (PMax) are separate features. Brand Restrictions apply to Search campaigns with broad match or AI Max — they restrict match expansion. PMax Brand Exclusions prevent your PMax assets from appearing for your own brand terms. These are configured in different places.

### How Brand Restrictions Work

- Available for: Search campaigns using **broad match** or **AI Max for Search**
- Setup location: Google Ads Settings → Brand lists → Brand restrictions
- Effect: Prevents broad match keywords from matching queries containing the restricted brand terms
- Use case: Running broad match for non-brand keywords but want to prevent serving for competitor brand names

### Brand Lists

1. Go to Google Ads → Tools → Brand lists
2. Create a brand list (e.g., "Competitor brands" or "My own brand")
3. Apply the brand list to the campaign as a restriction
4. The restriction applies to ALL broad match keywords in the campaign — cannot be applied per keyword

### Interaction with AI Max

When AI Max is enabled, Brand Restrictions also prevent AI Max from serving for the restricted brand queries. This is important for advertisers who:
- Have a dedicated brand campaign (want brand traffic there, not in generic campaigns)
- Are running non-brand PPC and don't want to bid on competitor brand terms

### Common Mistake
Do not confuse with negative keywords. Brand Restrictions are softer — they restrict expansion, but negative keywords are required for exact/phrase match queries you want to block entirely.

> [!tip] Cross-reference
> See [[pmax-guide]] for PMax Brand Exclusions, which serve a different purpose.
