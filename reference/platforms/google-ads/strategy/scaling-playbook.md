---
title: Google Ads Scaling Playbook
date: 2026-04-17
tags:
  - reference
  - strategy
  - scaling
  - google-ads
---

# Google Ads Scaling Playbook

This file is the knowledge base for the `/ad-platform-campaign-manager:account-scaling` skill. Read it when you need the rationale behind a gate, the mechanics of a trajectory, or the research behind a threshold. The skill is the operational tool; this file is the reference.

---

## 1. Purpose + Entry Criteria

This playbook applies to **Stage 3 and Stage 4 accounts only** — defined as 30+ conversions/month, stable CPA/ROAS, and a proven keyword portfolio. Stage 1 and Stage 2 accounts should not be scaled; they should be developed. See [[account-maturity-roadmap]] for stage definitions.

Entry question: "Is this account ready to grow?" That question has a yes/no answer at any given moment. The 8 gates below produce that answer. A partial pass (5 of 8 gates) is not a pass — it is a list of what must be fixed before scaling.

---

## 2. The 8 Gates

All gates must pass for a scaling trajectory to activate. Gate failures trigger T5 (Stabilization Required) before any budget step is considered.

| # | Gate | Rationale | Failure means |
|---|---|---|---|
| 1 | Maturity stage (Stage 3+) | Scaling an immature account accelerates waste, not growth | Clear Stage 1/2 work first |
| 2 | Monthly conversion volume (≥30/mo) | Smart Bidding needs data; scaling without volume locks the algorithm | Build volume before expanding budget |
| 3 | CPA/ROAS stability (CoV ≤20%) | A volatile account scaled up just scales up the volatility | Find the root cause (attribution, tracking, seasonality) before adding budget |
| 4 | Bid strategy fit (tCPA/tROAS active when eligible) | Max Conversions and Manual CPC leave conversion value on the table once volume allows Smart Bidding | Graduate bid strategy before expanding budget |
| 5 | IS headroom (budget-lost IS ≥15% on any campaign) | If rank is the limiter (not budget), adding budget does not improve results | Address quality signals (QS, ad relevance, LPE) before budget steps |
| 6 | Learning phase clear | Budget changes during learning restart the learning period, compounding the delay | Wait for learning to exit; only safe changes during learning (see [[learning-phase]]) |
| 7 | Negative keyword hygiene (≤10% irrelevant in top-50 terms) | Scaling a dirty account scales up wasted spend proportionally | Clean negatives before adding budget |
| 8 | Tracking infrastructure (EC active, DDA eligible) | Scaling without EC means Smart Bidding optimizes on incomplete data | Fix tracking before scaling; EC recovery is low-cost, scaling without it is high-cost |

**Delegation map** — the skill links to these existing sources for gate logic; it does not restate them:

| Gate | Delegates to |
|---|---|
| #4 (bid strategy fit) | [[../../skills/budget-optimizer/SKILL.md\|budget-optimizer]] L40-48 |
| #5 (IS headroom) | [[../../skills/budget-optimizer/SKILL.md\|budget-optimizer]] L69-87 |
| #2+#3 (volume + CoV thresholds) | [[account-maturity-roadmap]] L325-331, 465-471, 632-647 |
| #6 (learning phase) | [[../learning-phase\|learning-phase.md]], [[../../skills/post-launch-monitor/SKILL.md\|post-launch-monitor]] L170-191 |
| #7 (neg-kw hygiene) | [[../audit/audit-checklist\|audit-checklist.md]] Area 8 |

**The skill's unique contribution:** Gate #3 CoV computation from daily MCP data (no other skill computes CoV), single go/no-go verdict, trajectory routing.

---

## 3. Scaling Playbook by Channel

Channels are introduced sequentially. Do not expand to the next channel while the current one is unstable.

### Search (IS-led budget steps)

Trigger: Gate #5 passes (budget-lost IS ≥15%).

1. Identify campaigns where `search_budget_lost_impression_share ≥ 0.15`
2. Apply +20% budget step to those campaigns only
3. Wait minimum 14 days — no other changes during this period
4. Re-run `/account-scaling` after 14 days
5. Confirm CPA held within 15% of pre-step baseline before next +20% step

**Note:** The +20% rule is Search-specific (IS-led). It does not apply universally — see §4 below.

### Feed-Only PMax *(e-commerce only)*

Trigger: Stage 3 + Search stable for 8+ consecutive weeks + Merchant Center confirmed + no existing PMax campaign.

1. Route to `/ad-platform-campaign-manager:pmax-guide` for creation
2. Set PMax budget at 20-25% of current Search budget
3. Monitor Search impression share weekly — if Search IS drops >10 percentage points, reduce PMax budget before investigating (PMax/Search cannibalization signal)
4. Re-run `/account-scaling` after 4 weeks; T3 remains active until PMax is stable
5. **Oct 2024 note:** PMax competes with Shopping via Ad Rank — not automatic priority. Monitor Shopping IS alongside Search IS.

### Display Remarketing

Trigger: Stage 3+ + Search and Shopping hitting targets + remarketing list ≥1,000 users.

1. Start with retention audience only (past 90-day converters or high-value pages)
2. Budget cap: 5% of total account budget
3. Wait 4 weeks of stable performance before expanding
4. Do not mix retention and prospecting in the same campaign at this stage

### Demand Gen

Trigger: Display remarketing stable 4+ weeks + remarketing list ≥1,000 users.

1. Start with lookalike audience (similar to converters)
2. Budget cap: 10% of total account budget (test bucket)
3. **Geo-holdout required** before scaling Demand Gen past 15% of budget — Performance Planner does not model cross-campaign cannibalization; a geo-holdout experiment is the only way to confirm incrementality
4. Do not combine Demand Gen expansion with a Search budget step in the same 14-day window

### YouTube / Video *(Stage 4 only)*

Trigger: Stage 4 + Demand Gen stable + incrementality confirmed via geo-holdout.

Full incrementality measurement (Conversion Lift or geo-experiment) required before any significant budget allocation. See [[../video-campaigns|video-campaigns.md]] and `support.google.com/google-ads/answer/12003020`.

---

## 4. Budget Step Mechanics

The "+20% budget step" rule is commonly misattributed as universal. It is not.

| Channel | Step rule | Source |
|---|---|---|
| Search (IS-led) | +10-20% per step, wait 14 days | Dilate, KlientBoost, WordStream (consensus) |
| Display | +20% per step, wait for learning exit | Original Google guidance — Display-scoped |
| PMax | +15-20% every 3-7 days (higher-budget accounts) | Solutions 8, clicksinmind |
| Demand Gen | 10% test bucket max; hold until geo-holdout | — |

**Search scaling does not use the Display +20% rule.** Search scaling is governed by CoV stability (Gate #3) and IS headroom (Gate #5). Applying Display step mechanics to Search produces budget growth without performance validation.

**Minimum wait period:** 14 days after any budget step before the next step or bid strategy change. This ensures at least one full week of settled data on each side of the change. (WordStream, KlientBoost, clicksinmind — consistent across sources.)

---

## 5. The Six Scaling Trajectories (T1-T6)

Multiple trajectories can be active simultaneously. Priority execution order: **T5 → T2 → T1 → T3 / T4 / T6.**

When T5 is active, no other trajectory's budget or channel actions are taken until T5 gates clear.

| Trajectory | Trigger conditions | Action sequence | Delta cap / wait |
|---|---|---|---|
| **T1: Budget Scale-Up** | Gate #5 PASS (IS lost to budget ≥15%) + Gates #1-3 PASS | +20% budget on IS-limited Search campaigns → wait 14 days, no other changes → re-run skill → confirm CPA within 15% of baseline → next +20% or hold | +20% per step; 14-day minimum between steps |
| **T2: Bid Strategy Graduation** | Gates #2+#3 PASS (volume + stability at threshold) + Gate #4 FAIL (Max Conv or Manual CPC when tCPA/tROAS eligible) | Set tCPA at actual CPA × 1.15 → monitor 2-week learning → tighten 5-10% every 2 stable weeks → tROAS when 50+ conv/mo confirmed | tCPA at actual × 1.15 initial; tighten 5-10% per 2-week cycle |
| **T3: Channel Expansion — Feed-Only PMax** *(e-comm only)* | Stage 3 + Search stable 8+ weeks + Merchant Center confirmed + no existing PMax | Route to `pmax-guide` for creation → PMax at 20-25% of Search budget → monitor cannibalization (Search IS drop = warning) → re-run after 4 weeks | PMax: 20-25% of Search budget cap; 4-week review cycle |
| **T4: Channel Expansion — Display + Demand Gen** | Stage 3+, Search + Shopping hitting targets, remarketing list ≥1,000 | Display remarketing 5% budget (retention) → 4 weeks stable → Demand Gen test bucket 10% (lookalike) → geo-holdout before scaling Demand Gen >15% | Display: 5% cap; Demand Gen: 10% cap until geo-holdout confirms incrementality |
| **T5: Stabilization Required** | Any of Gate #3 (CPA volatile), #6 (in learning), or #7 (hygiene) FAIL | Gate-clearing per failing gate: learning → wait, no changes; CPA volatile → attribution/tracking investigation first; hygiene → negatives via UI before any budget step | No budget steps or channel expansions until all T5 gates clear |
| **T6: Portfolio Consolidation** *(Stage 4 only)* | 3+ campaigns, all tCPA/tROAS within targets 60+ days, target differences <15% across campaigns | Portfolio bid strategy setup → shared budget evaluation → IS review across portfolio → Vertex AI LTV consideration (B2B + e-commerce Stage 4) | — |

> [!warning] Dynamic scaling limitation
> The T1-T6 trajectories are a starting point, not a complete dynamic scaling system. True dynamic scaling — real-time multi-variable interaction, PMax/Shopping cannibalization in motion, predictive signal reading — is beyond current skill capability. The skill's value is: MCP-powered gate evaluation + conditional trajectory routing + evidence-gated recommendations + projection guardrail. It does not replace real-time algorithmic optimization.

**Conflict handling:** T1 + T2 simultaneously active requires sequencing. Bid strategy graduation (T2) resets the learning period — budget scale-up (T1) must wait until learning exits post-graduation. Do not run T1 and T2 actions in the same 14-day window.

---

## 6. What This Skill Adds vs. Existing Playbooks — Honest Gap Statement

A dense body of public scaling playbooks exists (see §8). The skill fills a **tooling gap**, not an information gap.

| Feature | Public playbooks | This skill |
|---|---|---|
| Coupled to live MCP data | No — all assume manual inspection | ✅ Yes — 7 GAQL queries, live field reads |
| Enforces a projection substantiation guardrail | No | ✅ Yes — prohibited patterns in report output |
| Emits a single go/no-go verdict | No — descriptive, not prescriptive | ✅ Yes — binary verdict + trajectory routing |
| CoV computation from daily data | No — stated as a rule without computation | ✅ Yes — computed from `segments.date` daily pull |
| Performance Planner cross-campaign cannibalization | ❌ Not modeled | ⚠️ Flagged as manual-only throughout |
| True dynamic scaling (multi-variable real-time) | Some agency frameworks describe it | ❌ Beyond current skill capability |

---

## 7. Major 2024-2026 Platform Changes

These changes affect skill branching logic. Each is reflected in the skill's gate and trajectory steps.

### PMax vs Shopping — Ad Rank decides (Oct 2024)

Before Oct 2024, Performance Max automatically received budget priority over Standard Shopping. Since Oct 2024, both campaign types compete via Ad Rank. PMax no longer dominates by default. Implication for T3: when recommending Feed-Only PMax addition, the skill must monitor both PMax and Shopping impression share. A PMax budget addition does not guarantee Shopping IS remains stable.

### Brand Exclusions — AI Max Migration (May 27, 2025)

Brand exclusion configuration is different when AI Max for Search is enabled. The skill branches: if a Search campaign uses AI Max, direct the user to the AI Max brand exclusion UI path (`support.google.com/google-ads/answer/14505308`) rather than the standard brand keyword negative list path.

### ECPC Removed (March 31, 2025)

Enhanced CPC was deprecated. Existing eCPC campaigns now run as Manual CPC. The skill flags any campaign with `bidding_strategy_type = ENHANCED_CPC` as deprecated under Gate #4 and recommends transitioning to Manual CPC → Max Conversions.

### Google Ads API v23 (Jan 2026)

Monthly release cadence from Jan 2026. The MCP server (`voxxy/google-ads-mcp-server`) must target v23+ for current field availability. If GAQL queries return unexpected field errors, check API version.

---

## 8. Curated External Playbooks

Research-verified 2026-04-16. The +20%/14-day consensus and PMax-specific thresholds below are corroborated across multiple independent sources.

| Source | Key finding |
|---|---|
| Google: `business.google.com/us/google-ads/campaign-budget/` | Official budget guidance |
| Solutions 8: "How to Scale a Performance Max Campaign" | +15-20% every 3-7 days (PMax, higher-budget accounts) |
| clicksinmind: "Scaling PMax the Right Way (5 Tips)" | +15-20% PMax, 14-day wait minimum |
| Accelerated Digital Media: "Performance Max: Tips for Bids and Budgets" | PMax 50+ conv/mo for reliable scaling |
| WordStream: "How to Scale Success in Google Ads (& When)" | ±10-20% per step, 14+ day wait |
| KlientBoost: "How to Scale Google Ads" | ±10-20% per step, 14+ day wait |
| Dilate: "The right way to scale Google Ads budgets" | ±10-20% consensus, budget-first before keywords |
| God Tier Ads: 400+ step optimization framework | Agency-grade scaling protocol |
| Search Engine Journal: "2026 Google Ads Playbook" | tROAS target 70-80% of actual ROAS |
| Store Growers: "Performance Max Campaigns: Ultimate Ecommerce Guide (2026)" | PMax 50+ conv/mo threshold corroborated |

**Key consensus numbers** (multi-source corroboration):
- Budget steps: ±10-20% per step
- Wait period: 14+ days after any step
- PMax reliable scaling: 50+ conv/mo
- tROAS target: set at 70-80% of actual ROAS (leave headroom before tightening)

---

## 9. Reference Repositories

Code repositories (not playbooks) for advanced implementation and incrementality measurement:

| Repo | Stars | Purpose |
|---|---|---|
| `googleads/google-ads-python` | 684 | Official Python client for Google Ads API |
| `Brainlabs-Digital/Google-Ads-Scripts` | 147 | Production Google Ads Scripts library |
| `facebookincubator/GeoLift` | 242 | Geo-lift / incrementality testing |
| `google/trimmed_match` | — | Geo-experiment methodology |
| `google/matched_markets` | — | Geo-experiment market selection |
| `googleads/google-ads-mcp` | — | Official Google Ads MCP server (Oct 2025) |
| `google/GeoexperimentsResearch` | 142 | Geo-experiment research (**archived 2022 — methodology only, not maintained**) |

---

## 10. Authoritative Google URLs

| Topic | URL |
|---|---|
| Learning period | `support.google.com/google-ads/answer/13020501` |
| tROAS / Portfolio bid strategies | `support.google.com/google-ads/answer/6268637` |
| Portfolio bid strategies (canonical) | `support.google.com/google-ads/answer/6263072` |
| Impression share metrics | `support.google.com/google-ads/answer/7103314` |
| Budget pacing insights | `support.google.com/google-ads/answer/13685469` |
| Smart Bidding Exploration | `support.google.com/google-ads/answer/16294223` |
| Brand exclusions (PMax) | `support.google.com/google-ads/answer/14505308` |
| Conversion Lift experiments | `support.google.com/google-ads/answer/12003020` |
| Experiments | `support.google.com/google-ads/answer/10682377` |
| Performance Planner | `support.google.com/google-ads/answer/9230124` |

---

## 11. Cross-References

This file is linked from:
- [[account-maturity-roadmap]] Stage 3 scaling section + Stage 4 scaling section + tROAS discrepancy footnote
- [[../bidding-strategies|bidding-strategies.md]] PMax/Shopping Ad Rank callout
- [[../../skills/post-launch-monitor/SKILL.md|post-launch-monitor]] bid strategy readiness section
- [[lift-budget-freeze]] — uses T1/T5 gate logic; this playbook is the source of truth for those gates
