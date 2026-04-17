---
title: Account Scaling Skill + Projection Guardrail Design
date: 2026-04-17
tags: [design, spec, account-scaling, projection-guardrail, conventions, v1.23.0]
status: approved
version: 1.0.0
---

# Account Scaling Skill + Projection Guardrail Design

## Problem Statement

Two problems drive this design:

1. **Missing iterative scaling skill.** The plugin has an entry-point profiler (`/account-strategy`) and a one-off bid/budget optimizer (`/budget-optimizer`), but nothing that repeatedly answers "is this account ready to grow right now?" Stage 3+ accounts need a repeatable, MCP-powered gate check — not a general-purpose audit. BACKLOG #23.

2. **No projection guardrail.** On 2026-04-16 an email was drafted for Vaxteronline projecting "5x ROAS in June/July." That figure appeared in no strategy document, no spec, and no approved plan. No skill stopped it. Every client-facing output surface is unprotected. BACKLOG #28.

## Approach

Two coordinated deliverables:

- **`/account-scaling` skill** — MCP-powered, always-report, Stage 3/4 entry gate. Runs 8 data-driven gates, routes to one or more conditional trajectories T1-T6, writes a diffable report every run.
- **Projection guardrail** — "Substantiation Before Projection" rule applied at three layers: user-global, master plugin, and this plugin. All 15 skills + 3 agents are in scope.

---

## Section 1: Architecture

### Skill Positioning

```
/account-strategy    → one-time profiler (entry-point or strategic pivot)
                           ↓
/budget-optimizer    → tactical: one-off bid/budget decisions
                           ↓
/account-scaling     → iterative: "is this account ready to grow?" (Stage 3+, MCP-powered)
```

The three skills form a ladder. `/account-scaling` is the only one that is run repeatedly — it is designed to be diffed across sessions.

### Capability Matrix

| Skill | MCP? | Always-report? | Projection gate? |
|---|---|---|---|
| `/account-strategy` | No | Yes (02-plan) | No |
| `/budget-optimizer` | No | Yes (02-plan) | No |
| `/post-launch-monitor` | Yes | Yes (stage-specific) | No |
| `/account-scaling` | **Yes** | **Yes (always, `reports/YYYY-MM-DD/05-optimize/`)** | **Yes** |

### Entry Criteria

- **Stage 3** (30+ conversions/month, confirmed from live 90-day data) or **Stage 4**.
- Stage 1 or Stage 2 accounts receive a single message: "Account not ready — here is the gate to clear first." No report is written, no trajectory is assigned.

### strategy-advisor Boundary

`/strategy-advisor` = 8-category profile audit → 1-10 scores across all strategic dimensions.
`/account-scaling` = focused gate subset → binary go/no-go verdict + budget step + trajectory routing.

The skill does not reproduce the scorecard. It delegates to `strategy-advisor` categories when overlap is detected and cites the reference, not the logic.

---

## Section 2: Skill Logic

### Phase 1 — Live MCP Data Pull

Load `[[reference/mcp/mcp-capabilities|mcp-capabilities]]` at skill start to confirm available fields. All reads are read-only; `unlock_writes` is never called in this skill.

| Query target | Fields pulled |
|---|---|
| `campaign` — 90 days | `metrics.conversions`, `cost_micros`, `conversion_value`, `search_impression_share`, `search_budget_lost_impression_share`, `search_rank_lost_impression_share`, `bidding_strategy_type`, `serving_status` |
| `campaign` — by day, last 30 days | Daily conv + cost for CPA/ROAS CoV computation |
| `keyword_view` | QS distribution |
| `search_term_view` — last 30 days | Top-spending terms (hygiene check) |
| `asset_group` | PMax `ad_strength` (feed-only POOR exception — see v1.21.1) |
| `shared_set` / `shared_criterion` | Negative keyword list presence |
| `ad_schedule_view` + `geographic_view` | Budget-lost-IS by daypart + geo |
| `campaign_budget` | Budget cap check |

**Not GAQL-accessible:** Auction Insights (manual verification only).

### Phase 2 — Gate Evaluation

Eight gates. All must pass for a scaling trajectory to activate. Gate result = PASS / FAIL / WARNING. All results are written to the report regardless of outcome — the report must be diffable across sessions.

| # | Gate | Delegated to | Skill's specific contribution |
|---|---|---|---|
| 1 | Maturity stage | `[[account-maturity-roadmap]]` Stage 3/4 | Classifies from live 90-day data |
| 2 | Monthly conversion volume | `[[account-maturity-roadmap]]` L325-331, 465-471 | Computes 30-day + 90-day rolling counts |
| 3 | CPA/ROAS stability | `[[account-maturity-roadmap]]` ±20% CoV rule | **Computes CoV from daily data** — roadmap states the rule, nothing else computes it |
| 4 | Bid strategy fit | `[[budget-optimizer]]` maturity ladder L40-48 | Reads live `bidding_strategy_type`, applies ladder |
| 5 | IS headroom | `[[budget-optimizer]]` IS-headroom L69-87 + `[[campaign-review]]` Area 16 | Reads live `search_budget_lost_impression_share` |
| 6 | Learning phase clear | `[[learning-phase]]` + `[[post-launch-monitor]]` L170-191 | Reads `serving_status` |
| 7 | Negative keyword hygiene | `[[campaign-review]]` Area 8 | Scans top-50 search terms for irrelevance % |
| 8 | Tracking infrastructure | `[[conversion-tracking]]` + `[[enhanced-conversions]]` | Verifies EC active + DDA eligibility |

**tROAS threshold discrepancy.** `account-maturity-roadmap.md` states "50 conversions in last 30 days" for tROAS. Google Portfolio Bid Strategy documentation (`support.google.com/google-ads/answer/6268637`) cites 15 conversions past 30 days for Search/Display tROAS. Resolution may be portfolio-level vs campaign-level, or a stale figure. The skill cites the live URL and instructs "confirm current threshold" — neither number is hardcoded. `account-maturity-roadmap.md` receives a discrepancy footnote.

### Phase 3 — Conditional Scaling Trajectories

Phase 2 gate results classify the account into one or more trajectories. Multiple trajectories can be active simultaneously; the skill presents them in priority order and flags conflicts.

**Priority execution order: T5 → T2 → T1 → T3 / T4 / T6.**

| Trajectory | Trigger conditions | Action sequence |
|---|---|---|
| **T1: Budget Scale-Up** | Gate #5 passes (IS lost to budget ≥15%) + Gates #1, #2, #3 pass | +20% budget on eligible campaigns → wait 14 days, no other changes → re-run skill → confirm CPA held within 15% of baseline → next +20% or hold |
| **T2: Bid Strategy Graduation** | Gates #2 + #3 pass (stable volume at threshold) + Gate #4 fails (Max Conv or Manual CPC when tCPA/tROAS now eligible) | Set tCPA at actual×1.15 → monitor 2-week learning → tighten 5-10% every 2 stable weeks → tROAS when 50+ conv/mo confirmed |
| **T3: Channel Expansion — Feed-Only PMax** *(e-commerce only)* | Stage 3 + Search stable 8+ weeks + Merchant Center confirmed + no existing PMax | Route to `pmax-guide` for creation → set PMax at 20-25% of Search budget → monitor cannibalization (Search IS drop = warning) → re-run skill after 4 weeks |
| **T4: Channel Expansion — Display + Demand Gen** | Stage 3+, Search + Shopping/PMax hitting targets, remarketing list ≥1,000 users | Display remarketing first (5% budget, retention only) → 4 weeks stable → Demand Gen test bucket (10%, lookalike) → geo-holdout required before scaling Demand Gen >15% |
| **T5: Stabilization Required** | Any of gates #3 (CPA volatile), #6 (in learning), #7 (hygiene) failing | Gate-clearing actions per failing gate: learning → wait, no changes; CPA volatile → attribution/tracking investigation first; hygiene → negatives via UI before any budget step |
| **T6: Portfolio Consolidation** *(Stage 4 only)* | 3+ campaigns, all tCPA/tROAS within targets 60+ days, target differences <15% | Portfolio bid strategy setup → shared budget evaluation → IS review across portfolio → Vertex AI LTV consideration (B2B + e-commerce Stage 4) |

> [!warning] Dynamic scaling limitation
> The T1-T6 trajectories are a starting point, not a complete dynamic scaling system. True dynamic scaling — real-time multi-variable interaction, PMax/Shopping cannibalization in motion, predictive signal reading — is beyond current skill capability. The skill's value is: MCP-powered gate evaluation + conditional trajectory routing + evidence-gated recommendations + projection guardrail. It does not replace real-time algorithmic optimization.

### Phase 4 — Report Write (Always)

Report path: `reports/{YYYY-MM-DD}/05-optimize/account-scaling.md`
SUMMARY.md section: **Optimization & Reporting**
Follow the 6-step write sequence from `[[_config/conventions]]`.

All 8 gate results are written — passes and fails — so the report is diffable across sessions.

---

## Section 3: Projection Gate + Conventions Bundle

### Root Cause

On 2026-04-16 an email was written for Vaxteronline projecting "5x ROAS in June/July." That figure appeared in no strategy document. No skill prevented it. The guardrail is designed so no skill or agent can generate this output in the future.

### Three-Layer Design

The rule is enforced at three layers to cover all output surfaces, including ad-hoc Claude conversations outside any plugin context.

#### Layer 1 — User Global (`~/.claude/CLAUDE.md`)

One-line rule + pointer. Applies on Jerry's machine in every context — ad-hoc chats, one-off drafts, any directory.

> Never state a future ROAS/CPA/budget-return projection or timeline commitment in any client-facing output without a dated strategy document on file. See plugin conventions for full rule.

#### Layer 2 — Master Plugin (`project-structure-and-scaffolding-plugin` conventions)

Full rule, generically framed. Applies to every downstream user of any Voxxy plugin (GTM, WordPress FSE, ad-platform). No Google-Ads-specific jargon — the rule covers any projection claim across any domain.

New section: `## Client Communication Guardrails`

Full rule text (see below). Generic Prohibited/Required example (non-campaign).

#### Layer 3 — Ad-Platform Plugin (`_config/conventions.md`)

Domain-specific extension. ROAS/CPA/tCPA/budget-lost-IS language. Concrete campaign Prohibited/Required example. Cites the master rule as parent.

### Full Rule Text (master + ad-platform versions)

> **Substantiation Before Projection.** Never state a future ROAS target, conversion volume projection, budget-return forecast, or timeline commitment in any client-facing output (report, SUMMARY.md, conversation text, message) that does not appear in a dated strategy document held on file — a spec, report, or plan approved by the client on a recorded date.
>
> If no documented target exists, describe the **data gate** that determines the next decision rather than the expected outcome.
>
> **Prohibited:** "Scaling to 2x budget should produce a 1.4x ROAS."
> **Required:** "Budget-lost-IS is 22% on the top five campaigns. If tCPA holds within 15% of target for 30 days after a +20% budget step, the next +20% step is data-supported."
>
> Regulatory backing: FTC Advertising Substantiation doctrine (reasonable basis before dissemination); UK CAP Code §§ 3.1 / 3.7 / 3.34 (documentary evidence held before the claim); DMCC Act 2024 fines.

Reference URLs:
- `ftc.gov/legal-library/browse/ftc-policy-statement-regarding-advertising-substantiation`
- `asa.org.uk/advice-online/substantiation.html`

### Scope

All 15 skills + 3 agents. Narrowing to reporting-only would leave conversational output surfaces unprotected — which is exactly where the Vaxteronline incident occurred.

### Skill-Local Enforcement (inside `/account-scaling`)

When the skill generates its report, it is prohibited from stating any numeric future target unless that target already exists in a dated strategy document held on file. If no documented target exists, the skill writes a data gate description: the condition that will determine the next decision, not the expected outcome.

---

## Section 4: `scaling-playbook.md` Structure

Companion reference file at `reference/platforms/google-ads/strategy/scaling-playbook.md`.

The "no canonical docs" claim from an earlier session was wrong. Dense public playbooks exist (see §8 below). The skill fills a **tooling gap**, not an information gap — no existing playbook is coupled to live MCP data reads, enforces a substantiation guardrail, or emits a single go/no-go verdict with trajectory routing.

### File Structure

**1. Purpose + Entry Criteria**
Stage 3/4 accounts only. `/account-scaling` is the operational counterpart — this file is its knowledge base, not a standalone guide.

**2. The 8 Gates**
Full gate table with rationale per gate, failure interpretation, and delegation target for each.

**3. Scaling Playbook by Channel**
Sequential ladder with budget caps and wait conditions:
- Search: IS-led budget steps, CoV stability check
- Feed-only PMax *(e-commerce only)*: 20-25% of Search budget, cannibalization watch
- Display remarketing: 5-10% cap, retention audience first
- Demand Gen: 10% test bucket, lookalike, geo-holdout required before scaling past 15%
- YouTube/Video *(Stage 4 only)*: incrementality-gated

**4. Budget Step Mechanics**
The +20% budget step rule is **Display-scoped only** — not universal. Search scaling uses CoV stability + learning-phase checks. Sources: Dilate, KlientBoost, WordStream (consensus ±10-20%). Wait 14+ days minimum after each step (WordStream, KlientBoost, clicksinmind).

**5. The Six Scaling Trajectories (T1-T6)**
Full decision table from Section 2. Triggers, action sequences, delta caps. Dynamic scaling limitation reproduced verbatim.

**6. What the Skill Adds vs. Existing Playbooks — Honest Gap Statement**
- ✅ Coupled to live MCP data (no public playbook does this)
- ✅ Enforces a substantiation guardrail (no public playbook does this)
- ✅ Emits a single go/no-go verdict with trajectory routing
- ⚠️ Performance Planner does not model cross-campaign cannibalization — always warn
- ❌ True dynamic scaling (multi-variable real-time) is beyond current skill capability

**7. Major 2024-2026 Platform Changes (with skill-branching notes)**
- PMax vs Shopping — Ad Rank decides (Oct 2024): skill cannot assume PMax dominates Shopping budget
- Brand exclusions migrating into AI Max for Search (May 27 2025): skill branches on this
- ECPC removed (March 31 2025): skill flags as deprecated if detected; transition path = Manual CPC → Max Conversions
- Google Ads API v23 (Jan 2026): monthly cadence; MCP server must target v23+

**8. Curated External Playbooks** (research-verified 2026-04-16)
- Google: `business.google.com/us/google-ads/campaign-budget/`
- Solutions 8: "How to Scale a Performance Max Campaign" (+15-20% every 3-7 days)
- clicksinmind: "Scaling PMax the Right Way (5 Tips)"
- Accelerated Digital Media: "Performance Max: Tips for Bids and Budgets"
- WordStream: "How to Scale Success in Google Ads (& When)"
- KlientBoost: "How to Scale Google Ads"
- Dilate: "The right way to scale Google Ads budgets"
- God Tier Ads: 400+ step optimization framework
- Search Engine Journal: "2026 Google Ads Playbook" (70-80% ROAS target rule)
- Store Growers: "Performance Max Campaigns: Ultimate Ecommerce Guide (2026)"

**9. Reference Repositories** (code, not playbooks)
- `googleads/google-ads-python` (684⭐)
- `Brainlabs-Digital/Google-Ads-Scripts` (147⭐)
- `facebookincubator/GeoLift` (242⭐) — geo-lift / incrementality testing
- `google/trimmed_match` + `google/matched_markets` — geo-experiment methodology
- `googleads/google-ads-mcp` (official, Oct 2025)
- `google/GeoexperimentsResearch` (142⭐, **archived 2022** — methodology only, flagged)

**10. Authoritative Google URLs**

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

**11. Cross-References**
Inbound links from:
- `account-maturity-roadmap.md` (Stage 3/4 sections + tROAS discrepancy footnote)
- `bidding-strategies.md` (PMax/Shopping Ad Rank correction Oct 2024 + ECPC deprecated note)
- `post-launch-monitor` skill (bid strategy readiness section)

---

## Implementation Scope

### New files (2)

| File | Notes |
|---|---|
| `skills/account-scaling/SKILL.md` | New standalone skill |
| `reference/platforms/google-ads/strategy/scaling-playbook.md` | Companion reference |

### Modified files (8 in this plugin)

| File | Change |
|---|---|
| `_config/conventions.md` | Add `## Client Communication Guardrails` section (Layer 3) |
| `CONTEXT.md` | Add routing: "Account scaling / ready to scale / grow this account / scale up budget" → `skills/account-scaling/SKILL.md` |
| `CLAUDE.md` Quick Navigation | Add `/ad-platform-campaign-manager:account-scaling` |
| `reference/platforms/google-ads/strategy/account-maturity-roadmap.md` | tROAS threshold discrepancy footnote + link to `scaling-playbook.md` from Stage 3/4 sections |
| `reference/platforms/google-ads/bidding-strategies.md` | PMax/Shopping Ad Rank correction (Oct 2024) + ECPC deprecated check (March 2025) |
| `BACKLOG.md` | #23 → ✅ Done (v1.23.0), #28 → ✅ Done (v1.23.0) |
| `CHANGELOG.md` | v1.23.0 entry |
| `PRIMER.md` | Session handoff rewrite |

### Modified files (1 in master plugin)

| File | Change |
|---|---|
| `project-structure-and-scaffolding-plugin/_config/conventions.md` (or equivalent) | Add `## Client Communication Guardrails` section (Layer 2 — generic rule, no Google-Ads-specific language) |

### Modified files (1 global)

| File | Change |
|---|---|
| `~/.claude/CLAUDE.md` | One-line rule + pointer to plugin conventions (Layer 1) |

---

## Codebase Overlap Audit

Genuine no-overlap zones (nothing existing computes or enforces these):

| Feature | Status |
|---|---|
| Projection guardrail | No overlap — new |
| Daily CoV computation from MCP data | No overlap — new |
| Conditional trajectory routing (T1-T6) | No overlap — new |
| Single go/no-go verdict with budget-step | No overlap — new |
| By-channel scaling ladder | No overlap — new |

Overlap resolved by delegation (link, do not restate):

| Gate | Existing location |
|---|---|
| Gate #4 (bid strategy fit) | `skills/budget-optimizer/SKILL.md` L40-48 |
| Gate #5 (IS headroom ≥10%) | `skills/budget-optimizer/SKILL.md` L69-87 |
| Gates #2+#3 thresholds | `reference/platforms/google-ads/strategy/account-maturity-roadmap.md` L325-331, 465-471, 632-647 |
| Gate #6 (learning phase) | `skills/post-launch-monitor/SKILL.md` L170-191 |
| Gate #7 (neg-kw hygiene) | `skills/campaign-review/SKILL.md` Area 8 |

---

## Research Notes

### Threshold Corroboration (external playbooks, 2026-04-16)

| Rule | Source(s) |
|---|---|
| Budget ±10-20% per step | Dilate, KlientBoost, WordStream, Stackmatix |
| Wait 14+ days after step | WordStream, KlientBoost, clicksinmind |
| PMax 50+ conv/mo for reliable scaling | Store Growers, Solutions 8, Accelerated Digital Media |
| PMax +15-20% every 3-7 days | Solutions 8, clicksinmind (higher-budget accounts) |
| tROAS target at 70-80% of actual ROAS | Search Engine Journal 2026, BrainMine Tech |
| Budget-first, keywords second | Panel Marketing, LinkedIn article |
