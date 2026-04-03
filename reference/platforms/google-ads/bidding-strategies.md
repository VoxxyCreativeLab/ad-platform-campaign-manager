---
title: Google Ads Bidding Strategies
date: 2026-04-01
tags:
  - reference
  - google-ads
---

# Google Ads Bidding Strategies

## Decision Tree

```
What is your primary goal?
├── Maximize conversions within a budget
│   ├── I have a target cost per conversion → TARGET CPA
│   └── I want as many conversions as possible → MAXIMIZE CONVERSIONS
├── Maximize revenue/value
│   ├── I have a target return on ad spend → TARGET ROAS
│   └── I want maximum conversion value → MAXIMIZE CONVERSION VALUE
├── Drive traffic (clicks)
│   ├── I want to set max bids myself → MANUAL CPC
│   └── I want Google to optimize clicks → MAXIMIZE CLICKS
├── Brand awareness (impressions)
│   └── I want maximum visibility → TARGET IMPRESSION SHARE
└── Video views
    └── → CPV (Cost Per View)
```

## Smart Bidding Strategies (Recommended)

These use Google's AI to optimize bids in real-time, using signals like device, location, time, audience, and more.

### Target CPA (tCPA)
Sets bids to get as many conversions as possible at or below your target cost per acquisition.

- **Min data:** 15-30 conversions in last 30 days (more = better)
- **Set target to:** Your actual CPA from the last 30 days, then gradually lower
- **Good for:** Lead generation, sign-ups, form submissions
- **Pitfall:** Setting target CPA too low → Google restricts spend and you lose volume

### Target ROAS (tROAS)
Sets bids to maximize conversion value at your target return on ad spend.

- **Min data:** 50+ conversions with values in last 30 days
- **ROAS calculation:** (Conversion Value / Ad Spend) × 100%
- **Example:** Target ROAS 400% = for every €1 spent, you expect €4 in return
- **Good for:** E-commerce, revenue-focused campaigns
- **Pitfall:** Setting target too high → Google restricts spend

### Maximize Conversions
Spends your entire budget to get the most conversions possible. No target — just maximum volume.

- **Min data:** At least some conversion history
- **Good for:** New campaigns gathering data, campaigns with a fixed budget
- **Warning:** Will spend your full daily budget. Set budget carefully.
- **Tip:** Start here, gather 30+ conversions, then switch to Target CPA

### Maximize Conversion Value
Spends your budget to maximize total conversion value. Like Maximize Conversions but optimizes for value, not count.

- **Good for:** E-commerce with different product values
- **Warning:** Will spend full budget. May favor a few high-value conversions over many smaller ones.

## Manual Bidding

### Manual CPC
You set bids at keyword or ad group level. Full control, but labor-intensive.

> [!warning] Enhanced CPC was deprecated March 2025. Existing eCPC campaigns now run as Manual CPC. Use Maximize Conversions or Target CPA instead.

- **Good for:** Very small budgets, new accounts with zero data, specific keyword experiments
- **Bad for:** Scale — you can't optimize bids across thousands of signals like Google's AI can

### Maximize Clicks
Automatically sets bids to get the most clicks within your budget.

- **Good for:** Traffic-focused campaigns, building audience lists
- **Not for:** Conversion-focused campaigns (optimizes for clicks, not conversions)
- **Set a max CPC cap** to prevent expensive clicks

## Awareness Strategies

### Target Impression Share
Bids to show your ad a certain percentage of the time.

- **Options:** Anywhere on results page, top of results page, absolute top
- **Good for:** Brand terms (aim for 90%+ impression share on your brand name)
- **Expensive** for competitive non-brand terms

## Strategy Recommendations by Scenario

| Scenario | Strategy | Notes |
|----------|----------|-------|
| New account, no data | Manual CPC → Maximize Conversions | Gather initial data, then switch when ready |
| 15+ conversions/month | Maximize Conversions | Build conversion volume |
| 30+ conversions/month | Target CPA | Set tCPA at current average |
| E-commerce, 30+ conv | Target ROAS | Set tROAS at current average |
| Brand protection | Target Impression Share | 90%+ on brand terms |
| Remarketing | Target CPA | Good conversion rates expected |
| PMax | Max Conv Value + tROAS | PMax works best with value-based |

## Additional Strategies

### Demand Gen Target CPC
Demand Gen campaigns support Target CPC bidding (new in 2025), allowing you to set a target cost per click alongside conversion-based strategies. Useful when optimizing for traffic quality on Demand Gen surfaces (YouTube, Discover, Gmail, Display).

### Portfolio Bid Strategies
Portfolio bid strategies let you group multiple campaigns under a single shared bidding strategy with a shared budget. Benefits:
- Manage bid targets across campaigns from one place
- Balance performance between campaigns (one campaign can compensate for another)
- Set minimum and maximum bid limits across the portfolio
- Available for Target CPA, Target ROAS, Maximize Conversions, Maximize Conversion Value, and Target Impression Share

> [!info] AI Max for Search
> AI Max for Search (2025) layers on top of Search campaigns and works with Smart Bidding strategies. It expands query matching beyond your keyword list using broad match + keywordless targeting. Your chosen bid strategy still governs optimization — AI Max changes *which* queries you enter auctions for, not *how* you bid.

## Learning Period

When you change a bid strategy, Google enters a "learning" period (typically 1-2 weeks):

- Performance may fluctuate — this is normal
- Don't make changes during learning (resets the clock)
- Wait for "Eligible" status before evaluating
- If learning period takes too long, your targets may be too aggressive

## Common Mistakes

1. **Switching strategies too often** — each switch resets learning
2. **Setting targets based on goals, not data** — start with your actual CPA/ROAS, then optimize
3. **Too little conversion data** — smart bidding needs data to work
4. **Not using conversion values** — if products have different values, pass them to Google
5. **Ignoring seasonality** — adjust targets for known seasonal peaks/dips

## Bidding Strategy by Account Profile

Which bid strategy to use depends on account maturity and conversion volume. See [[strategy/account-profiles]] for the full framework.

| Account Stage | Conversions/Month | Recommended Strategy | Why |
|---------------|-------------------|---------------------|-----|
| Cold start (0-3mo) | 0-15 | Manual CPC or Maximize Clicks | No conversion data to optimize; need baseline learning |
| Early data (3-6mo) | 15-30 | Maximize Conversions (no target) | Enough data to let the algorithm find conversions, but not enough for targets |
| Established (6-18mo) | 30-50 | Target CPA or Target ROAS | Reliable data; set targets from actual 30-day averages, NOT aspirational |
| Mature (18+mo) | 50+ | Value-based bidding (tROAS with profit-adjusted values) | Rich data enables profit optimization, not just conversion counting |

### Learning Period Tactics

When transitioning between bid strategies:
1. **Don't change during high-traffic periods** — avoid learning period during Black Friday, launches
2. **Budget buffer** — increase daily budget by 20% during the 2-week learning period
3. **No other changes** — don't adjust keywords, ads, or targeting during learning
4. **Watch for spend spikes** — Maximize Conversions without a target can overspend; set a max CPC bid limit as a safety net
5. **Failed learning?** — If learning fails after 2 weeks, check: enough conversions? Too-aggressive target? Budget too low?

### Scaling Smart Bidding

After Smart Bidding is stable (4+ weeks, no learning):
- **Increase budget gradually** — 15-20% max per change, then wait 1-2 weeks
- **Tighten targets gradually** — reduce CPA or increase ROAS by 10% max, wait 2 weeks
- **If spend drops** — target is too aggressive; loosen by 15-20% and wait
- **Portfolio bid strategies** — consider these when 3+ campaigns share the same goal
