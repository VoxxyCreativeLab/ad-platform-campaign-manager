---
name: budget-optimizer
description: Budget allocation, bid strategy selection, spend forecasting, and target CPA/ROAS calculation. Use when planning or optimizing campaign budgets.
argument-hint: "[budget-amount or campaign-name]"
disable-model-invocation: false
---

# Budget Optimizer

You are helping with budget allocation, bid strategy selection, and spend optimization for Google Ads campaigns.

## Reference Material

- **Bidding strategies:** [[../../reference/platforms/google-ads/bidding-strategies|bidding-strategies.md]]
- **Campaign types:** [[../../reference/platforms/google-ads/campaign-types|campaign-types.md]]
- **Account structure:** [[../../reference/platforms/google-ads/account-structure|account-structure.md]]
- **Common mistakes:** [[../../reference/platforms/google-ads/audit/common-mistakes|common-mistakes.md]]

## Common Tasks

### Bid Strategy Selection
Help the user choose the right bid strategy based on:
1. Campaign goal (conversions, revenue, traffic, awareness)
2. Available conversion data (how many conversions/month?)
3. Campaign maturity (new vs established)
4. Risk tolerance (aggressive vs conservative)

Use the decision tree from the bidding strategies reference.

### Setting Target CPA/ROAS
1. **Never set aspirational targets** — start with actual performance data
2. Calculate current CPA: Total Cost / Total Conversions (last 30 days)
3. Set initial target at current CPA or slightly above
4. Gradually reduce target CPA by 10-15% every 2 weeks
5. Monitor for delivery issues (if spend drops, target is too aggressive)

**For ROAS:**
1. Calculate current ROAS: Total Conversion Value / Total Cost
2. Set initial target at current ROAS or slightly below
3. Gradually increase target ROAS by 10-15% every 2 weeks

### Budget Allocation Across Campaigns
Prioritize budget by:
1. **ROI/ROAS** — highest-performing campaigns get more budget
2. **Business priority** — strategic campaigns may justify higher CPA
3. **Headroom** — campaigns limited by budget with good performance → increase budget
4. **Diminishing returns** — campaigns spending freely with declining CPA → may be at optimal budget

**Framework:**
```
For each campaign, calculate:
- Marginal CPA = (Cost at current budget) / (Conversions at current budget)
- Is it budget-limited? (Impression share lost to budget > 10%)
- Performance trend (improving, stable, declining)

Then allocate:
1. Budget-limited campaigns with good CPA → increase first
2. Uncapped campaigns with declining CPA → may need more budget or optimization
3. Underperforming campaigns → reduce or pause
```

### Budget Forecasting
Help estimate required budget:
1. **Target conversions × Target CPA = Required budget**
2. Factor in: seasonality, competition, day-of-week patterns
3. Add 15-20% buffer for testing and learning periods
4. Account for ramp-up period (new campaigns need 2-4 weeks to optimize)

### Shared Budget Strategy
- **Use shared budgets** when campaigns have similar goals and performance
- **Don't use shared budgets** when one campaign is much higher priority (it may starve the others)
- **Never share budgets** between brand and non-brand campaigns

## Key Principles

1. **Spend follows performance** — allocate more to what works
2. **Don't starve smart bidding** — too-small budgets prevent optimization
3. **Budget and bid strategy are connected** — Maximize Conversions needs enough daily budget to find opportunities
4. **Allow learning time** — don't cut budget during the learning period
5. **Review weekly, adjust monthly** — daily changes create noise

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| No conversion data to set CPA/ROAS targets | New account or campaign with fewer than 15 conversions | Start with Maximize Clicks or Manual CPC; switch to Maximize Conversions after 15+ conversions, then add a target after 30+ |
| Spend drops sharply after setting a target | Target CPA too low or target ROAS too high | Raise CPA by 20% (or lower ROAS by 20%) and wait 2 weeks; never set aspirational targets |
| Campaign "Limited by budget" but CPA is bad | Budget is being spent on low-quality clicks | Don't increase budget — fix keywords, negatives, or ad relevance first, then reassess |
| Smart bidding won't exit learning period | Too few conversions per week (need 10+ per campaign) or frequent changes resetting learning | Consolidate campaigns to increase conversion volume; stop making changes for 2 weeks |
| Shared budget starving one campaign | Higher-priority campaign consumes the pool | Move the high-priority campaign to its own dedicated budget |
