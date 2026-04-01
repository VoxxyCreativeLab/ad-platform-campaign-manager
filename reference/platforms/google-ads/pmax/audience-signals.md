---
title: PMax Audience Signals
date: 2026-04-01
tags:
  - reference
  - google-ads
  - pmax
---

# PMax Audience Signals

## What Are Audience Signals?

Audience signals are **hints** to Google's AI about who your ideal customers are. They are NOT hard targeting — Google uses them as starting points and expands beyond them based on performance data.

## Signal Types

### Custom Segments
Define audiences by their search behavior or app usage.

- **People who searched for:** Enter keywords your ideal customers search for
  - Example: "buy running shoes", "best trail running shoes", "Nike running shoes"
- **People who browse websites similar to:** Enter competitor or related URLs
  - Example: competitor websites, review sites, industry blogs
- **People who use apps similar to:** Enter apps your customers use

**Best for:** Most businesses. Directly maps search intent to audience.

### Your Data (First-Party)
Audiences built from your own customer data.

- **Customer lists:** Upload email/phone lists (Customer Match)
- **Website visitors:** Remarketing audiences from GA4 or Google Ads tag
- **App users:** Users of your app
- **YouTube users:** People who watched your videos or subscribed

**Best for:** Remarketing, lookalike targeting, high-value customer expansion.

### Interests & Detailed Demographics
Google's pre-built audience categories.

- **In-market audiences:** People actively researching/planning to buy
  - Example: "In-market for Athletic Shoes"
- **Affinity audiences:** People with long-term interests
  - Example: "Running Enthusiasts", "Fitness Buffs"
- **Life events:** People going through life changes
  - Example: "Recently moved", "Getting married"
- **Detailed demographics:** Income, education, homeownership, parental status, etc.

**Best for:** Broad targeting when you don't have first-party data.

### Demographics
Basic demographic targeting — available as **soft signals** and **hard exclusions**.

**Demographic signals (soft):** hints to Google, not hard limits.

- Age ranges (18-24, 25-34, 35-44, 45-54, 55-64, 65+, Unknown)
- Gender (Male, Female, Unknown)
- Parental status
- Household income (top 10%, 11-20%, 21-30%, etc.)

**Demographic hard exclusions (since late 2025):** permanently block specific groups.

- Hard-exclude specific **age brackets** and **genders** at campaign level
- These are NOT signals — Google will NOT show ads to excluded demographics, period
- Use for products with legal age restrictions, strong demographic mismatches, or regulatory requirements

> [!warning] Signals vs Exclusions
> Demographic signals are hints — Google may still show ads outside your selected demographics if it predicts conversions. Demographic hard exclusions are absolute blocks. Know the difference.

**Best for:** Products with clear demographic skew. Use signals for optimization, exclusions for compliance.

### Search Themes

Search themes are keyword-like inputs per asset group that tell Google which search topics are relevant. Unlike audience signals (which describe people), search themes describe **what people search for**.

- Up to **50 search themes per asset group** (doubled from 25 in August 2025)
- Work alongside audience signals — themes guide Search and Shopping inventory, signals guide Display/YouTube/Discover
- Think of them as broad match keywords scoped to PMax: enter topics, not exact queries
- Especially useful for new campaigns or asset groups where Google has no conversion data yet

**Best for:** Directing PMax's Search and Shopping inventory. Essential complement to audience signals.

## Audience Exclusions

> [!info] Exclusions Are Not Signals
> Audience exclusions are **hard blocks** — Google will never show ads to excluded audiences. This is fundamentally different from audience signals, which are optimization hints Google can ignore.

### Customer Match Exclusions (2025)

Upload Customer Match lists and **exclude them at campaign level**:

- Upload hashed email/phone lists of existing customers, past purchasers, or low-value segments
- Excluded users will not see your PMax ads on any channel
- Enables **pure prospecting PMax campaigns** — spend 100% of budget on new customers

### Website Visitor Exclusions (2025)

Exclude Website Visitor remarketing segments:

- Exclude "All website visitors" to run purely prospecting campaigns
- Exclude "Past purchasers (30 days)" to avoid remarketing to recent buyers
- Combine with Customer Match exclusions for comprehensive existing-customer filtering

### Use Cases

| Exclusion | Purpose |
|-----------|---------|
| All past purchasers | Pure new customer acquisition |
| Recent converters (7-30 days) | Avoid remarketing immediately after purchase |
| Low-LTV customers | Focus budget on higher-value segments |
| Internal staff emails | Prevent employee ad exposure |

## Audience Signal Strategy

### For New Campaigns (Limited Data)
1. Start with **Custom Segments** based on high-intent search terms
2. Add **In-market audiences** that match your product category
3. Add a **Customer list** if you have one (even small lists help)
4. Keep demographics broad — let Google learn

### For Established Campaigns (Rich Data)
1. **Your Data** as primary signal (past purchasers, high-value customers)
2. **Custom Segments** for competitive conquesting
3. Review and refine based on audience insights reports
4. Create separate asset groups for different audience segments

### Per Asset Group
Each asset group should have its own audience signal that matches its theme:

```
Asset Group: Budget Running Shoes
  Audience Signal:
    - Custom Segment: "cheap running shoes", "affordable sneakers"
    - In-market: Athletic Shoes
    - Demographics: No income restriction

Asset Group: Premium Running Shoes
  Audience Signal:
    - Custom Segment: "best running shoes", "carbon plate shoes"
    - Your Data: Past purchasers of premium products
    - Demographics: Top 30% household income
```

## Common Mistakes

1. **Too narrow signals** — restricts Google's learning. Signals are hints, not limits.
2. **No first-party data** — even a small customer list dramatically helps optimization.
3. **Same signal for all asset groups** — defeats the purpose of separate asset groups.
4. **Ignoring the Insights tab** — Google shows which audiences are converting; use this data to refine.
5. **Not updating signals** — refresh customer lists regularly (quarterly minimum).
