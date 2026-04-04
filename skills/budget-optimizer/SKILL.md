---
name: budget-optimizer
description: Budget allocation, bid strategy selection, spend forecasting, and target CPA/ROAS calculation. Use when planning or optimizing campaign budgets.
argument-hint: "[budget-amount or campaign-name]"
disable-model-invocation: false
---

# Budget Optimizer

You are helping with budget allocation, bid strategy selection, and spend optimization for Google Ads campaigns.

If `$ARGUMENTS` provides a budget amount, campaign name, or context, use it to scope the guidance. Otherwise, ask the user what they need help with: allocation, forecasting, bid strategy, or CPA/ROAS targets.

Before recommending budget or bidding changes, establish the account's maturity stage and budget tier. Ask:
1. How many conversions per month is this account generating?
2. How long has the account been running?
3. What vertical? (e-commerce, lead gen, B2B SaaS, local services)

Consult the maturity stage table in account-profiles.md to determine viable strategies.

## Reference Material

- **Bidding strategies:** [[../../reference/platforms/google-ads/bidding-strategies|bidding-strategies.md]]
- **Campaign types:** [[../../reference/platforms/google-ads/campaign-types|campaign-types.md]]
- **Account structure:** [[../../reference/platforms/google-ads/account-structure|account-structure.md]]
- **Common mistakes:** [[../../reference/platforms/google-ads/audit/common-mistakes|common-mistakes.md]]
- **Account profiles (budget tier and maturity):** [[../../reference/platforms/google-ads/strategy/account-profiles|account-profiles.md]]
- **Maturity roadmap (bidding progression):** [[../../reference/platforms/google-ads/strategy/account-maturity-roadmap|account-maturity-roadmap.md]]

## Common Tasks

### Bid Strategy Selection
Help the user choose the right bid strategy based on:
1. Campaign goal (conversions, revenue, traffic, awareness)
2. Available conversion data (how many conversions/month?)
3. Campaign maturity (new vs established)
4. Risk tolerance (aggressive vs conservative)

Use the decision tree from the bidding strategies reference.

Ask before recommending: "How many conversions did this campaign generate last month?" Map to maturity-appropriate strategy:
- 0-15 conv/mo → Manual CPC or Maximize Clicks (do not recommend Smart Bidding)
- 15-30 → test Maximize Conversions on highest-volume campaign only
- 30-50+ → tCPA or tROAS viable
- 50+ stable → value-based bidding, portfolio strategies

### Setting Target CPA/ROAS
Ask first: "What is your current CPA? What conversion volume do you have?"

Vertical-specific benchmarks for reference:
- **E-commerce:** ROAS 3-8x depending on margins; CPA varies by AOV
- **Lead gen:** CPA €15-200 (legal €50-150, home services €15-50, insurance €30-100)
- **B2B SaaS:** CPA €50-300 for demo/trial; true CAC much higher
- **Local services:** CPA €10-60 per call/booking

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

## Output Format

Present budget recommendations as a structured plan:

```
## Budget & Bid Strategy Plan

### Current State
| Campaign | Monthly Spend | Conv. | CPA | ROAS | Budget Limited? |
|----------|--------------|-------|-----|------|-----------------|
| {{campaign_name}} | €{{spend}} | {{conversions}} | €{{cpa}} | {{roas}} | {{yes_no}} |

### Recommended Changes
| Campaign | Action | Current → Proposed | Expected Impact |
|----------|--------|-------------------|-----------------|
| {{campaign_name}} | {{action}} | {{current}} → {{proposed}} | {{impact}} |

### Bid Strategy Recommendation
- **Current:** {{current_strategy}}
- **Recommended:** {{recommended_strategy}}
- **Rationale:** {{rationale}}
- **Data requirement:** {{min_conversions}} conversions/month (currently at {{current_conversions}})

### Timeline
- Week 1-2: {{initial_changes}}
- Week 3-4: {{monitoring_actions}}
- Month 2+: {{optimization_actions}}
```

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| No conversion data to set CPA/ROAS targets | New account or campaign with fewer than 15 conversions | Start with Maximize Clicks or Manual CPC; switch to Maximize Conversions after 15+ conversions, then add a target after 30+ |
| Spend drops sharply after setting a target | Target CPA too low or target ROAS too high | Raise CPA by 20% (or lower ROAS by 20%) and wait 2 weeks; never set aspirational targets |
| Campaign "Limited by budget" but CPA is bad | Budget is being spent on low-quality clicks | Don't increase budget — fix keywords, negatives, or ad relevance first, then reassess |
| Smart bidding won't exit learning period | Too few conversions per week (need 10+ per campaign) or frequent changes resetting learning | Consolidate campaigns to increase conversion volume; stop making changes for 2 weeks |
| Shared budget starving one campaign | Higher-priority campaign consumes the pool | Move the high-priority campaign to its own dedicated budget |

## Next Steps

- Validate the optimized campaign → `/ad-platform-campaign-manager:campaign-review`
- Fix structural issues found during budget analysis → `/ad-platform-campaign-manager:campaign-cleanup`
- Set up or fix conversion tracking (required for smart bidding) → `/ad-platform-campaign-manager:conversion-tracking`

---

## Report Output

When running inside an MWP client project (detected by `stages/` or `reports/` directory):

- **Stage:** `02-plan`
- **Output file:** `reports/{YYYY-MM-DD}/02-plan/budget-optimizer.md`
- **SUMMARY.md section:** Strategy & Planning
- **Write sequence:** Follow the 6-step write sequence in [[conventions#Report File-Writing Convention]]
- **Completeness:** Follow the [[conventions#Output Completeness Convention]]. No truncation, no shortcuts.
- **Re-run behavior:** If this skill runs twice on the same day, overwrite the existing report file. Update (not duplicate) CONTEXT.md row and SUMMARY.md paragraph.
- **Fallback:** If not in an MWP project, output to conversation (legacy behavior).
