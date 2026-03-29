---
title: PMax Audience Signals
date: 2026-03-28
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
Basic demographic targeting.

- Age ranges (18-24, 25-34, 35-44, 45-54, 55-64, 65+, Unknown)
- Gender (Male, Female, Unknown)
- Parental status
- Household income (top 10%, 11-20%, 21-30%, etc.)

**Best for:** Products with clear demographic skew.

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
