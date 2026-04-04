---
title: Seasonal Planning
date: 2026-04-03
tags:
  - reference
  - google-ads
  - strategy
---

# Seasonal Planning

Strategic framework for seasonal bid, budget, and creative adjustments in Google Ads — annual planning calendars, ramp-up timelines, vertical-specific seasonality, and post-season analysis. For bid adjustment mechanics, see [[strategy/bid-adjustment-framework]]. For budget allocation strategy, see [[bidding-strategies]].

%%fact-check: Google Ads seasonality adjustments, Smart Bidding behavior during seasonal peaks — verified against Google Ads Help 2026-04-03%%

## Decision Tree

```
What seasonal planning task?
├── Annual planning (before the year starts)
│   └── Build full-year calendar with vertical-specific peaks → see Vertical Calendars
├── Preparing for a known peak
│   ├── 6-4 weeks out → Pre-season (infrastructure, budgets, creative)
│   ├── 2-1 weeks out → Ramp-up (bid increases, budget buffers, ad activation)
│   ├── Peak period → Full throttle (daily monitoring, reactive adjustments)
│   └── Post-peak → Wind-down (return to baseline, analyse, document)
├── Smart Bidding during seasonal peaks
│   └── Use Seasonality Adjustments (Google Ads tool) → see Smart Bidding section
└── Unexpected demand shift (unplanned)
    └── Reactive: increase budget, broaden keywords, monitor hourly
```

## Annual Planning Framework

### Universal Peak Periods (EU/NL Market Focus)

| Period | Dates | Impact Level | Affected Verticals |
|---|---|---|---|
| **New Year / January sales** | Jan 1-15 | Medium | E-commerce, fitness, SaaS (annual plans) |
| **Valentine's Day** | Feb 1-14 | Medium | E-commerce (gifts, flowers, jewelry) |
| **Easter** | Variable (March/April) | Medium | Travel, e-commerce, local services |
| **Koningsdag (NL)** | Apr 27 | Low-Medium | Local events, e-commerce (orange merchandise) |
| **Mother's Day** | 2nd Sunday in May | Medium | E-commerce (gifts), local services (restaurants) |
| **Father's Day** | 3rd Sunday in June | Low-Medium | E-commerce (gifts) |
| **Summer holidays** | Jul-Aug | Mixed | Travel (peak), B2B (dip), e-commerce (mixed) |
| **Back to school** | Aug 15-Sep 15 | Medium | E-commerce (supplies, electronics, furniture) |
| **Singles' Day (11.11)** | Nov 11 | Medium-High | E-commerce (growing in EU market) |
| **Black Friday** | Last Friday Nov | Very High | E-commerce (all categories) |
| **Cyber Monday** | Monday after BF | High | E-commerce (electronics, SaaS deals) |
| **Sinterklaas (NL/BE)** | Nov 15-Dec 5 | High | E-commerce (toys, gifts — NL/BE specific) |
| **Christmas** | Dec 1-24 | Very High | E-commerce, travel, local services |
| **End of year** | Dec 26-31 | Medium | SaaS (annual renewals), travel (NYE) |

> [!note] NL-Specific Calendar
> The Netherlands has unique peaks: Koningsdag, Sinterklaas, and a summer holiday period that differs from southern EU countries. Dutch e-commerce sees Sinterklaas (Nov 15-Dec 5) as a stronger gifting peak than Christmas. Plan gift-related campaigns accordingly.

### Vertical-Specific Calendars

#### E-Commerce

| Quarter | Peaks | Planning Notes |
|---|---|---|
| Q1 | January sales, Valentine's | Post-holiday clearance; Valentine's ramp starts Jan 20 |
| Q2 | Mother's Day, Father's Day, spring collection | Launch spring creative by March; gift campaigns 2 weeks before each holiday |
| Q3 | Summer sales, back to school | Summer dip Jul-Aug for non-travel; back-to-school ramp mid-Aug |
| Q4 | Singles' Day, Black Friday, Sinterklaas, Christmas | The big quarter — plan budgets in September; creative in October |

#### Lead Generation

| Quarter | Peaks | Planning Notes |
|---|---|---|
| Q1 | "New year, new start" demand | High search volume for courses, services, consultants |
| Q2 | Pre-summer push | Businesses finalize vendor decisions before summer holidays |
| Q3 | Summer dip → September surge | Reduce budgets Jul-Aug; ramp aggressively in September |
| Q4 | Year-end budget spending | B2B buyers spending remaining annual budget; strong for enterprise sales |

#### B2B SaaS

| Quarter | Peaks | Planning Notes |
|---|---|---|
| Q1 | Annual planning period | Companies evaluating new tools for the year; demo requests peak |
| Q2 | Mid-year evaluations | Stable demand; good for content/awareness campaigns |
| Q3 | Budget-setting season | Decision-makers planning next year's budget; pipeline building |
| Q4 | "Use it or lose it" budget | Strongest quarter for enterprise — closing before fiscal year-end |

#### Local Services

| Quarter | Peaks | Planning Notes |
|---|---|---|
| Q1 | Home improvement (post-holiday) | Plumbers, electricians, renovators see January demand |
| Q2 | Spring services | Garden, painting, outdoor work peak Mar-May |
| Q3 | Emergency + vacation services | Emergency repairs, pet sitting, house cleaning |
| Q4 | Heating, insulation, winterization | HVAC and energy services peak Oct-Dec |

## Ramp-Up Timeline

For any significant seasonal peak, follow this timeline:

### T-6 to T-4 Weeks: Pre-Season

| Action | Details |
|---|---|
| **Budget planning** | Calculate peak budget (typically 1.5-3x normal daily budget) |
| **Creative preparation** | Write seasonal ad copy; design Display/YouTube creative |
| **Landing page readiness** | Seasonal landing pages live and tested (load speed, mobile, tracking) |
| **Audience list building** | Ensure remarketing lists are populated (see [[strategy/remarketing-strategies]]) |
| **Feed preparation** | Update product feed with seasonal labels, sale prices (see [[shopping-feed-strategy]]) |
| **Tracking verification** | Verify all conversion tags fire correctly before the rush |

### T-2 to T-1 Weeks: Ramp-Up

| Action | Details |
|---|---|
| **Increase budgets** | Raise daily budgets by 50% to allow algorithm expansion |
| **Activate seasonal campaigns** | Enable paused seasonal campaigns / ad groups |
| **Adjust bid targets** | Loosen tCPA by 15-20% or tROAS by 15-20% to capture more volume |
| **Enable seasonal creative** | Swap in seasonal headlines, descriptions, extensions |
| **Broaden keywords** | Add broader match types or seasonal keywords |
| **Competitor monitoring** | Check auction insights for new competitors entering |

### T-0: Peak Period

| Action | Details |
|---|---|
| **Daily monitoring** | Check spend pacing, CPA, ROAS every morning |
| **Budget top-ups** | If campaigns hit daily cap before 18:00, increase budget 20% |
| **Reactive bidding** | If CPA spikes > 30% above target, check search terms for irrelevant queries |
| **Negative keyword mining** | Daily search term review — seasonal peaks attract irrelevant queries |
| **Creative performance** | Check which seasonal headlines are "Best" — pause "Low" performers |

### T+1 to T+2 Weeks: Wind-Down

| Action | Details |
|---|---|
| **Reduce budgets** | Return to pre-season levels gradually (don't cut 50% overnight) |
| **Pause seasonal campaigns** | Disable seasonal ad groups / campaigns |
| **Restore bid targets** | Return tCPA / tROAS to pre-season targets |
| **Remove seasonal creative** | Swap out dated messages ("Black Friday", "Christmas Special") |
| **Post-season analysis** | Document what worked — see Post-Season Analysis section |

## Smart Bidding and Seasonality

### Seasonality Adjustments (Google Ads Feature)

For Smart Bidding campaigns, use the built-in **Seasonality Adjustments** tool instead of manual bid changes.

| Setting | What It Does | When to Use |
|---|---|---|
| **Expected CVR change** | Tell Google you expect conversion rate to increase/decrease by X% | Short peaks (1-7 days) with predictable CVR shifts |
| **Scope** | Apply to specific campaigns or all campaigns | Apply only to campaigns affected by the seasonal event |
| **Duration** | Start and end dates | Must be short — Google recommends 1-14 days max |

%%fact-check: Seasonality Adjustments recommended duration 1-14 days, available under Tools → Bidding → Seasonality Adjustments — verified 2026-04-03%%

> [!warning] Don't Use for Long Periods
> Seasonality Adjustments are designed for **short, predictable peaks** (Black Friday weekend, flash sale). For gradual seasonal changes (summer dip, Q4 ramp), adjust budgets and bid targets directly. Using Seasonality Adjustments for 30+ day periods confuses the algorithm.

### Smart Bidding Behavior During Peaks

| Behavior | What to Expect |
|---|---|
| **Learning acceleration** | More data during peaks = faster learning → algorithm performs better |
| **Auto-adjustment** | Smart Bidding detects increased CVR and automatically bids more aggressively |
| **Post-peak overcorrection** | After the peak, the algorithm may continue bidding high for 3-7 days — monitor and reduce budgets if spend doesn't normalize |
| **Data skew** | Peak data inflates historical performance — Smart Bidding may set unrealistic expectations. If performance drops post-peak, loosen targets temporarily. |

> [!tip] Budget Over Bid Targets During Peaks
> During seasonal peaks, adjust **budgets** rather than **bid targets**. Smart Bidding already responds to higher CVR — what it needs is more budget to capture the additional volume. Lowering your tCPA during a peak (hoping for cheaper conversions) is counterproductive — Google already knows conversions are cheaper and is bidding accordingly.

## Post-Season Analysis

After every significant seasonal period, document:

| Question | Where to Find Data | Action |
|---|---|---|
| Which campaigns had the highest ROAS lift? | Campaign performance vs prior period | Allocate more budget next year |
| Which seasonal keywords converted? | Search terms report, filtered by date | Add to permanent keyword list or save for next year |
| Which creative messages won? | Asset performance labels during peak | Save winning headlines for next year's templates |
| Did we hit budget caps too early? | Hourly spend reports | Plan higher daily budgets next year |
| What was the true peak day/hour? | Hourly conversion data | Fine-tune next year's schedule adjustments |
| Were there unexpected negative keywords? | Search terms report | Pre-load negatives before next year's peak |

> [!tip] Tracking Specialist Advantage
> If you have sGTM → BigQuery, you can build a year-over-year seasonal comparison dashboard that overlays this year's daily conversion data on last year's. This gives you predictive power for planning next year's ramp-up timeline and budget allocation. See [[../../tracking-bridge/sgtm-to-bq]] for the data pipeline.

## Common Mistakes

| Mistake | Impact | Fix |
|---|---|---|
| No budget increase during peaks | Campaigns cap out by noon; missed conversions | Plan 1.5-3x daily budget during peaks |
| Starting ramp-up too late | Algorithm needs 1-2 weeks to adapt; missed early peak demand | Start 2 weeks before the peak |
| Forgetting to wind down | Post-peak spend at elevated levels with declining CVR | Schedule budget reduction 1-2 days after peak ends |
| Seasonal creative left running | "Black Friday" ads in December → bad brand impression | Remove seasonal copy the day after the event |
| Tightening bid targets during peaks | Counter-productive — algorithm already adjusting for higher CVR | Adjust budgets, not targets, during peaks |
| No post-season analysis | Same mistakes repeated next year | Document learnings within 1 week of peak ending |
| Using Seasonality Adjustments for long periods | Confuses Smart Bidding algorithm | Only use for short peaks (1-14 days) |

## Related

- [[strategy/bid-adjustment-framework]] — manual bid adjustment mechanics and stacking
- [[strategy/remarketing-strategies]] — audience list preparation for seasonal campaigns
- [[bidding-strategies]] — bid strategy selection and learning period management
- [[strategy/account-profiles]] — account archetype for budget tier planning
- [[strategy/account-maturity-roadmap]] — maturity progression affects seasonal readiness
