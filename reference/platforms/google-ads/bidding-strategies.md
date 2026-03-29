---
title: Google Ads Bidding Strategies
date: 2026-03-28
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

- **Min data:** 15-30 conversions with values in last 30 days
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

- **Enhanced CPC (eCPC):** Optional overlay — Google adjusts your manual bid up/down based on conversion likelihood. A middle ground.
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
| New account, no data | Manual CPC or Maximize Clicks | Gather initial data |
| 15+ conversions/month | Maximize Conversions | Build conversion volume |
| 30+ conversions/month | Target CPA | Set tCPA at current average |
| E-commerce, 30+ conv | Target ROAS | Set tROAS at current average |
| Brand protection | Target Impression Share | 90%+ on brand terms |
| Remarketing | Target CPA | Good conversion rates expected |
| PMax | Max Conv Value + tROAS | PMax works best with value-based |

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
