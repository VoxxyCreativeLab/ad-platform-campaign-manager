---
title: Lifting a Budget Freeze — Early-Lift Criteria and Safe Step Sizing
date: 2026-04-18
tags:
  - google-ads
  - strategy
  - scaling
  - reference
---

# Lifting a Budget Freeze — Early-Lift Criteria and Safe Step Sizing

A budget freeze is any deliberate decision to hold a campaign's daily budget constant and make no upward changes. Common reasons:

- **T5 Stabilization Required** — the `/account-scaling` skill triggered T5 (learning in progress, CPA volatile, or keyword hygiene below threshold). T5 blocks all budget steps until its gates clear.
- **Voluntary freeze during learning** — a new campaign or bid strategy change put the account into a learning period and the manager opted to hold budget until learning exits.
- **Post-restructure caution** — a significant structural change (subdivision of product groups, campaign splits) left the account in a transient state and a freeze was imposed to observe performance before scaling.

> [!info] Primary reference
> This file documents the early-lift decision process only. For the T5 gate logic, see [[scaling-playbook]]. For what constitutes a learning-phase trigger, see [[../learning-phase|learning-phase.md]].

---

## When Can a Freeze Be Lifted Early?

"Early" means before the originally scheduled review date (e.g., lifting a T5 freeze before Day 14, or lifting a learning-phase hold before the full learning window has passed).

All of the following conditions must be TRUE before lifting early. A partial pass is not a pass.

| # | Condition | Gate | How to Check |
|---|-----------|------|--------------|
| 1 | **Learning status is Eligible** | T5 Gate #6 | Google Ads UI: Bid strategy column must show "Eligible" (not "Learning" or "Learning (limited)") |
| 2 | **CPA/ROAS stability: CoV ≤20%** | T5 Gate #3 | Run `/account-scaling` — it computes CoV from daily MCP data. Requires minimum 7 days of post-learning data. |
| 3 | **IS lost to budget ≥15%** | T1 Gate #5 | `run_gaql`: `SELECT campaign.name, metrics.search_budget_lost_impression_share FROM campaign WHERE segments.date DURING LAST_7_DAYS` — any campaign showing ≥0.15 means rank is not the limiter and a budget increase has headroom |
| 4 | **Negative keyword hygiene ≤10% irrelevant** | T5 Gate #7 | Search term review via `get_search_terms`. If hygiene triggered the freeze, this must clear first. |
| 5 | **Minimum 7 post-learning data days** | Evidence floor | Do not assess CPA stability on learning-phase data. The reporting window must exclude the learning period. |

> [!warning] IS gate matters
> Gate #3 (IS headroom) is NOT optional even for an early lift. If IS lost to budget is <15%, adding budget does not improve results — rank is the limiter, not spend capacity. Lifting the freeze does nothing useful and may waste budget.

---

## Conditions That Do NOT Justify Early Lifting

Do not lift a freeze based on:

- **Client pressure alone** — "We need to scale now" is not a data gate. If no gate has cleared, the freeze stays.
- **A good single day** — CPA/ROAS stability requires 7+ days of post-learning data, not one positive day.
- **Impression share looks OK but budget IS is <15%** — this means rank is limiting you, not budget. Adding budget amplifies waste.
- **The original schedule "feels too conservative"** — the schedule exists to prevent compounding learning resets. Only data clears gates, not judgment.

---

## Safe Step Sizing After Lift

Once all early-lift criteria are met, resume scaling with the standard T1 mechanics.

| Step | Rule | Rationale |
|------|------|-----------|
| Max single increase | **+20% of current daily budget** | Industry consensus (WordStream, KlientBoost, Dilate). Exceeding this increases the risk of pacing disruption even if it does not formally trigger a "Learning" status. |
| Minimum wait between steps | **14 days** | Ensures one full week of settled data on each side of the change. Source: scaling-playbook.md §4, consistent with industry consensus. |
| Maximum frequency | **One budget step per 14 days** | Never increase budget at the same time as a bid strategy change or target adjustment. |
| Step sequence | Apply to IS-limited campaigns first | Do not increase budget evenly across all campaigns. Direct it to campaigns where `search_budget_lost_impression_share ≥ 0.15`. |

> [!note] Does a budget increase reset learning?
> Official Google documentation (answer/13020501) lists learning triggers as: new bid strategy, bid strategy setting change, and composition changes (campaigns/ad groups added/removed). Budget changes are **not listed** as a formal learning trigger. However, increases larger than ~20% can cause the algorithm to re-adjust pacing behavior, which practitioners consistently observe as performance volatility for 3-7 days even without a formal "Learning" status appearing. The safe practice is to keep steps ≤20% regardless.

---

## Decision Flowchart

```
Is the campaign in Learning status?
  → YES: Do not lift. Wait for Eligible status. No exceptions.
  → NO: Continue below.

Is CPA/ROAS CoV ≤20% over the last 7 post-learning days?
  → NO: Do not lift. Root-cause the instability (attribution? tracking? feed issue?).
  → YES: Continue below.

Is IS lost to budget ≥15% on at least one campaign?
  → NO: Do not lift — rank is the limiter. Adding budget won't help.
       Address quality signals instead (QS, ad relevance, landing page experience).
  → YES: Continue below.

Is negative keyword hygiene ≤10% irrelevant in top-50 terms?
  → NO: Clean negatives first. Budget freeze stays until hygiene clears.
  → YES: All gates clear.

→ LIFT: Apply +20% budget step to IS-limited campaigns only.
         Set 14-day review date. No other changes during this window.
         Re-run /account-scaling after 14 days to confirm CPA held within 15% of baseline.
```

---

## GAQL Queries for Early-Lift Assessment

### Learning status check

```sql
SELECT
  campaign.name,
  campaign.status,
  bidding_strategy.status,
  campaign.bidding_strategy_type
FROM campaign
WHERE campaign.status = 'ENABLED'
```

Check the `bidding_strategy.status` column in results. "LEARNING" = freeze stays; "ELIGIBLE" = gate 1 clear.

### IS lost to budget (Gate #3)

```sql
SELECT
  campaign.name,
  metrics.search_budget_lost_impression_share,
  metrics.search_rank_lost_impression_share
FROM campaign
WHERE segments.date DURING LAST_7_DAYS
  AND campaign.status = 'ENABLED'
ORDER BY metrics.search_budget_lost_impression_share DESC
```

If `search_budget_lost_impression_share ≥ 0.15` → budget headroom exists.
If `search_rank_lost_impression_share` is the higher figure → rank is the problem, not budget.

### Post-learning CPA window (7 days after Eligible)

```sql
SELECT
  campaign.name,
  segments.date,
  metrics.conversions,
  metrics.cost_micros,
  metrics.cost_micros / NULLIF(metrics.conversions, 0) AS cpa_micros
FROM campaign
WHERE segments.date DURING LAST_14_DAYS
  AND campaign.status = 'ENABLED'
ORDER BY campaign.name, segments.date
```

Run the 7 most recent days (post-Eligible) through the CoV formula in `/account-scaling` before lifting.

---

## What to Document

When lifting a freeze early, record:

1. The date each gate cleared (with the data that confirmed it)
2. The campaign(s) receiving the budget increase and the new budget amount
3. The 14-day review date
4. The baseline CPA/ROAS at lift time (used to confirm "CPA held within 15%" at the review)

If inside an MWP project: append a brief note to the current `reports/{YYYY-MM-DD}/05-optimize/` report or create a new optimization note at that path.

---

## Related Files

- [[scaling-playbook]] — T1/T5 trajectory mechanics, 8 gates, all scaling rules
- [[../learning-phase|learning-phase.md]] — what triggers learning, safe vs. disruptive changes
- [[../strategy/post-launch-playbook|post-launch-playbook.md]] — observation cadence in the early weeks (Day 0 → Day 30)
- [[../bidding-strategies|bidding-strategies.md]] — tROAS/tCPA target graduation timing
