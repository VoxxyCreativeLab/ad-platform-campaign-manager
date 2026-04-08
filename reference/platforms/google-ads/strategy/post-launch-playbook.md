---
title: Post-Launch Playbook
date: 2026-04-08
tags:
  - google-ads
  - strategy
  - post-launch
  - reference
---

# Post-Launch Playbook

A unified day-by-day and week-by-week guide for the period after campaign launch. Consolidates guidance previously scattered across `bidding-strategies.md`, `account-maturity-roadmap.md`, `feed-only-pmax.md`, `demand-gen.md`, `campaign-cleanup`, and `budget-optimizer`.

> [!warning] Learning period reminder
> Most of the early weeks are observation-only. Resist the urge to make structural changes. See [[learning-phase]] for the complete safe vs. disruptive list before touching anything.

---

## Day 0 — Launch Day

**Goal:** Confirm everything is live and measurement is working before any traffic arrives.

- [ ] Campaigns enabled (check status — not paused, not "Limited")
- [ ] Tracking firing: open Tag Assistant Live, trigger a test conversion, verify it registers in Google Ads → Tools → Conversions (allow 3h delay)
- [ ] Budget pacing: confirm daily budget is set correctly (not leftover from test)
- [ ] Baseline screenshot: take a screenshot of Campaigns view showing impressions = 0 (Day 0 baseline)
- [ ] Negative keywords applied: brand competitors, irrelevant queries (safe during learning — see [[learning-phase]])
- [ ] Brand exclusions applied for PMax (safe during learning)
- [ ] Audience signals attached (PMax, Demand Gen)
- [ ] Merchant Center linked (if Shopping/PMax) — verify feed status in MC

**MCP boundary:** No MCP needed on Day 0 — no data to pull yet. Tag Assistant and Google Ads UI are the only tools here.

---

## Day 1 — First Data

**Goal:** Confirm impressions, catch spend anomalies before they compound.

- [ ] Pull first data: `get_campaign_metrics` or Campaign Performance Summary (live-report)
- [ ] Check spend pacing — is budget being consumed? If €0 spent after 4h on a Search campaign, investigate (low bids? Over-restricted targeting? Limited approval status?)
- [ ] Add obvious negatives from first search terms report (`run_gaql` search_term_view, LAST_1_DAYS)
- [ ] Confirm no runaway spend — Maximize Conversions without a target can overspend on Day 1
- [ ] Flag any "Learning (limited)" constraints: budget? Conversion volume? Approval issues?

**Per-campaign-type Day 1 checks:**

| Type | What to Check |
|------|---------------|
| Search | Impression share > 0. At least some impressions on target queries. |
| Shopping | Impressions > 0 in Shopping tab. MC product status: Active. |
| PMax | Any impressions at all. Check channel breakdown if available. |
| Demand Gen | May take 24-48h to serve. Normal if impressions = 0 on Day 1. |
| Display | May take 24-48h. Confirm placements aren't brand-unsafe (check Placements tab). |

**MCP tools:** `get_campaign_metrics`, `run_gaql` (search_term_view)

---

## Day 2 (48 Hours) — Remarketing & Display Check

**Goal:** Confirm remarketing and display surfaces are serving correctly.

- [ ] Remarketing audiences: verify audiences are building (Google Ads → Audience Manager → check user count)
- [ ] Display/Demand Gen: confirm impressions > 0 after 48h; check placement report for inappropriate sites
- [ ] Consent mode: if EU traffic is in scope, verify consent signals are flowing — check Tag Assistant or CMP dashboard. Consent state is NOT visible in Google Ads API.
- [ ] PMax channel split: if API v23+ available, check that Shopping holds the majority of spend (benchmark: 60-80%)

**MCP boundary:** Audience list sizes and CMP/consent state are NOT in the API. These must be checked in Google Ads UI and CMP dashboard respectively.

---

## Day 7 — First Clean Week

**Goal:** First meaningful data. Search term mining. Learning status check.

- [ ] Pull 7-day Campaign Performance Summary
- [ ] Learning status: check "Bid strategy" column in Google Ads UI — should show "Learning" (not "Learning (limited)") for Smart Bidding campaigns
- [ ] Search term mining: run search_term_view for last 7 days. Add irrelevant terms as negatives. Add high-volume winners as keywords (safe during learning)
- [ ] Budget pacing: are any campaigns hitting daily caps before end of day? If yes, budget may be too low relative to competition
- [ ] Conversion count: how many conversions recorded? Is it tracking correctly? Cross-reference with GA4

**Decision gate — Day 7:**
- 0 conversions despite significant spend → investigate tracking before spending more (not a bidding problem yet)
- Conversion volume < 5 → normal for early days. Stay the course. Do not change bid strategy.
- Conversion volume > 15 → good signal. Continue observing through Day 14.

**MCP tools:** `run_gaql` (search_term_view), `get_campaign_metrics`, `list_campaigns`

---

## Day 14 — Learning Assessment

**Goal:** Evaluate learning progress. First bid strategy decision point.

- [ ] PMax learning exit assessment: PMax campaigns should be near or past learning (14-28 days). Check status.
- [ ] Second search term pass: mine another week of search terms, add more negatives
- [ ] Conversion quality check: are the conversions real? (Check GA4 goal completions vs Google Ads conversions)
- [ ] Performance vs Day 0 baseline: CPA trend up or down? ROAS stabilizing?
- [ ] Spending efficiency: is the algorithm finding the right auctions? Check auction insights if available (UI only)

**Decision gate — Day 14 (Smart Bidding upgrade):**

| Condition | Action |
|-----------|--------|
| 0 conversions | Don't touch bid strategy. Fix tracking first. |
| < 15 conversions | Stay on Maximize Conversions. Don't set a tCPA target yet. |
| 15-30 conversions | May set a conservative tCPA target (use 30-day actual CPA × 1.3 as starting point) |
| 30+ conversions | Safe to set tCPA target at actual 30-day CPA. Monitor for 2 weeks after. |

> [!note] tROAS gate
> tROAS requires 50+ conversions with values in the last 30 days. Don't switch to tROAS before this threshold. See [[bidding-strategies]] for the full readiness gates.

**MCP tools:** `get_campaign_metrics`, `run_gaql` (search_term_view, campaign)

---

## Day 21 — tROAS Gate Check

**Goal:** Evaluate conversion volume for value-based bidding upgrade.

- [ ] Conversion value total for last 21 days: calculate average daily value
- [ ] Conversion volume check: have you hit 50 conversions in 30 days? (tROAS threshold)
- [ ] Shopping performance: if Shopping campaign, pull `shopping_performance_view` — are zombie products consuming budget?
- [ ] Demand Gen learning exit: Demand Gen should have exited learning by Day 21 (14-21d typical). Assess performance.

**Per-type Day 21 decisions:**

| Type | If Learning Complete | If Still Learning |
|------|---------------------|-------------------|
| Search | Set tCPA if 30+ conv. Otherwise stay on Max Conv. | Do NOT change strategy. Investigate constraints. |
| Shopping | Review top/zombie products. Adjust bids if using manual. | Wait. Check MC for feed issues. |
| PMax | Review channel split, asset performance. | Check if "Learning (limited)" — diagnose constraint. |
| Demand Gen | Review audience performance, creative fatigue. | Normal if still learning at Day 21. |

**MCP tools:** `get_campaign_metrics`, `run_gaql` (shopping_performance_view, conversion_action)

---

## Day 30 — Full Month Review

**Goal:** First full-month performance review. Bid strategy upgrade decisions.

- [ ] Pull full 30-day Campaign Performance Summary (live-report)
- [ ] CPA/ROAS vs targets: how close are actual figures to the client's goal?
- [ ] Budget utilization: are budgets being fully consumed? Any campaigns consistently under-pacing?
- [ ] Search term mining: final pass for Month 1. Compile negative keyword list additions.
- [ ] Bid strategy upgrade decision (see Day 14 gate above, now with 30 days of data)
- [ ] Creative review: RSA asset performance ratings (Best/Good/Low/Learning). Refresh Low-rated assets.
- [ ] Audience performance: pull age/gender/geographic breakdown, identify under- and over-performing segments

**MCP tools:** `get_campaign_metrics`, `get_account_metrics`, `run_gaql` (all segmentation views)

---

## Weeks 5–8 — Optimization Cadence

After the first 30 days, move into a regular optimization cadence:

| Cadence | Task |
|---------|------|
| **Weekly** | Search term mining + negatives, budget pacing check, anomaly flag (>20% metric change) |
| **Bi-weekly** | Ad/asset performance review, keyword bid adjustments (if Manual CPC) |
| **Monthly** | CPA/ROAS target reassessment, audience strategy review, budget reallocation across campaigns, creative refresh planning |
| **Quarterly** | Full account strategy review, campaign structure reassessment, bid strategy upgrade evaluation |

See [[account-maturity-roadmap]] for the full optimization cadence by account age.

---

## MCP Boundary Notes

| Task | MCP Available | Manual Required |
|------|--------------|-----------------|
| Campaign performance data | `get_campaign_metrics`, `run_gaql` | — |
| Search term mining | `run_gaql` (search_term_view) | — |
| Adding negative keywords | NOT in MCP (write tool gap) | Google Ads UI → Negative keywords |
| Tracking verification (Day 0) | NOT in MCP | Tag Assistant, Google Ads → Conversions |
| Consent mode state | NOT in MCP | Tag Assistant, CMP dashboard, DevTools |
| Audience list sizes | NOT in MCP | Google Ads UI → Audience Manager |
| MC feed status | NOT in MCP | Merchant Center UI |
| Bid strategy change (upgrade) | NOT in MCP | Google Ads UI → Bid strategy settings |
| RSA asset ratings | `run_gaql` (ad_group_ad_asset_view) | — |
| Shopping product performance | `run_gaql` (shopping_performance_view) | — |

---

## Related Files

- [[learning-phase]] — safe vs. disruptive changes during the learning period (the most important constraint)
- [[bidding-strategies]] — bid strategy selection, tCPA/tROAS readiness gates
- [[account-maturity-roadmap]] — long-term optimization cadence, account maturity stages
- [[mcp-capabilities]] — full MCP boundary reference
- [[feed-only-pmax]] — PMax-specific post-launch steps
