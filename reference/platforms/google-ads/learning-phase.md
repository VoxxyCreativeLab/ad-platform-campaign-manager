---
title: Learning Phase — Smart Bidding
date: 2026-04-08
tags:
  - google-ads
  - bidding
  - smart-bidding
  - reference
---

# Learning Phase — Smart Bidding

The single authoritative reference for what triggers the learning period, how long it lasts, and which changes are safe vs. disruptive.

> [!warning] Contradiction resolved
> Previous plugin docs were inconsistent about what's safe during learning. This file is the source of truth. All other references link here rather than defining their own rules.

---

## What Triggers a Learning Period

A new learning period begins when:

- A new campaign is created and enabled
- The bid strategy is switched (e.g., Manual CPC → Target CPA, Target CPA → Target ROAS)
- The target value changes significantly (tCPA, tROAS)
- The daily budget changes by more than 20%
- A conversion action is added, removed, or changed as the primary optimization goal
- The campaign is paused and re-enabled after a long dormancy
- Major restructuring: ad groups added/removed, targeting overhaul

---

## Safe vs. Disruptive Changes

### Safe Changes (do not reset learning)

These can be made at any time during the learning period without restarting it:

| Change | Notes |
|--------|-------|
| Add negative keywords | Including shared negative keyword lists |
| Update ad copy / RSA assets | Pinning, swapping headlines, descriptions |
| Adjust assets / extensions | Sitelinks, callouts, structured snippets, images |
| Add observation audiences | Observation-only targeting; bidding adjustments safe after learning |
| Ad schedule tweaks | Adjusting day/time preferences |
| Pause underperforming ads or keywords | Within an ad group, not removing ad groups entirely |
| Add brand exclusions (PMax) | These are filters, not structural changes |
| Update final URLs | If the landing page is essentially the same |

> [!tip] Rule of thumb
> If the change affects how Google allocates budget or sets bids, it is likely disruptive. If it only affects what Google shows or who sees it, it is likely safe.

### Disruptive Changes (reset learning)

Avoid these during the learning period:

| Change | Why It Resets Learning |
|--------|----------------------|
| Switch bid strategy | Completely new optimization model |
| Change target CPA / target ROAS | Redefines the optimization goal |
| Change daily budget by >20% | Disrupts the spend pacing model |
| Change primary conversion action | Changes what Google is optimizing for |
| Major campaign restructuring | Alter the data Google has been training on |
| Add or remove ad groups | Changes the campaign's structural data |
| Change campaign type | Triggers a full re-initialization |

---

## Learning Duration by Campaign Type

Learning duration depends on conversion volume. Low-volume accounts take longer.

| Campaign Type | Typical Duration | Notes |
|---------------|-----------------|-------|
| Search | 7–14 days | Shorter with high conversion volume |
| Shopping (Standard) | 7–14 days | Depends on product feed health |
| Display | 7–14 days | Smart Display may take up to 14–21d |
| Video / YouTube | 7–14 days | |
| Demand Gen | 14–21 days | Multi-surface learning takes longer |
| Performance Max | 14–28 days | Longest due to cross-channel optimization |

> [!note] Volume threshold
> Google generally needs 50+ conversions in the prior 30 days for Smart Bidding to perform reliably. Below this, learning periods may extend or Smart Bidding may underperform. See [[bidding-strategies]] for the tROAS/tCPA readiness gates.

---

## What "Resets Learning" Means Technically

When learning resets, Google re-enters an exploration phase:

1. The historical bid calibration model is discarded
2. Google increases bid variance to re-explore the optimal range
3. Performance fluctuates — CPAs and ROAS can spike or drop
4. The campaign status shows "Learning" in the Bid strategy column
5. This typically lasts the full duration for that campaign type (see table above)

Repeated resets create a compounding problem: the campaign never accumulates enough stable data to converge, causing permanently volatile performance.

---

## How to Check Learning Status

In the Google Ads UI:

1. Go to **Campaigns** view
2. Add the **Bid strategy type** column (Columns → Customize)
3. The status shows in that column:
   - **Learning** — exploration phase active
   - **Learning (limited)** — learning is constrained (usually budget or conversion volume)
   - **Eligible** — learning complete, Smart Bidding is fully active
   - **Eligible (limited)** — active but with constraints (budget cap, low search volume)

Common "Learning (limited)" reasons:
- Budget too low relative to the target CPA
- Conversion volume below threshold
- Target too aggressive for available traffic

---

## Post-Learning Checklist

Once the campaign reaches **Eligible** status:

- [ ] Pull a clean performance report (exclude the learning period from date ranges)
- [ ] Compare impressions, CTR, CPA/ROAS against pre-learning baseline
- [ ] Check conversion volume — has it hit the 50/month threshold?
- [ ] Evaluate tROAS/tCPA targets: is actual performance within 20% of target?
- [ ] If underperforming: diagnose before changing targets (see [[common-mistakes]] #20)
- [ ] If on track: schedule first optimization review at Day 30

---

## Related Files

- [[bidding-strategies]] — bid strategy selection, tROAS/tCPA targets, transition timing
- [[common-mistakes]] — Mistake #20: disrupting the learning period
- [[feed-only-pmax]] — PMax-specific post-launch safe steps (negatives, brand exclusions)
- [[account-maturity-roadmap]] — Week-by-week optimization cadence after learning
