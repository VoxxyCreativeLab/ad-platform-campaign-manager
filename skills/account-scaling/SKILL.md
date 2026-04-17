---
name: account-scaling
description: "Account scaling health check — 8-gate MCP evaluation of Stage 3/4 readiness to grow, conditional trajectory routing (T1-T6), and always-on diffable report. Trigger: 'account scaling / ready to scale / grow this account / scale up budget'."
disable-model-invocation: false
---

# Account Scaling Health Check

You are running a structured account scaling evaluation. This skill is for **Stage 3+ accounts only** (30+ conversions/month). It uses live MCP data to run 8 gates and routes to conditional scaling trajectories.

> [!warning] Projection Guardrail — Active
> This skill enforces the Substantiation Before Projection rule from [[../../_config/conventions|conventions.md]] §Client Communication Guardrails. Never state a future ROAS target, CPA projection, conversion volume forecast, or timeline commitment in any output unless it appears in a dated strategy document on file. Describe data gates — not expected outcomes.

## Reference Material

Load these on demand — not all at once:

- **MCP capabilities:** [[../../reference/mcp/mcp-capabilities|mcp-capabilities.md]] — load first, confirm GAQL field availability
- **Scaling playbook:** [[../../reference/platforms/google-ads/strategy/scaling-playbook|scaling-playbook.md]] — gate rationale, T1-T6 full detail, channel ladder, external playbooks, Google URLs
- **Account maturity roadmap:** [[../../reference/platforms/google-ads/strategy/account-maturity-roadmap|account-maturity-roadmap.md]] — Stage 3/4 criteria, CoV thresholds
- **Budget optimizer (Gates #4, #5):** [[../budget-optimizer/SKILL.md|budget-optimizer]] — maturity ladder L40-48, IS-headroom L69-87
- **Learning phase (Gate #6):** [[../../reference/platforms/google-ads/learning-phase|learning-phase.md]]
- **Campaign review (Gate #7):** [[../campaign-review/SKILL.md|campaign-review]] — Area 8 (neg-kw hygiene)
- **Conventions:** [[../../_config/conventions|conventions.md]] — 6-step report write sequence, projection guardrail

## Step 0: Entry Gate

Before running MCP queries, confirm Stage 3 or Stage 4 eligibility.

Say: "Let me pull 90 days of conversion data to confirm Stage 3/4 status before running the full evaluation."

Run:

```gaql
SELECT campaign.id, campaign.name, campaign.status,
  metrics.conversions, metrics.cost_micros, metrics.conversion_value
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND segments.date DURING LAST_90_DAYS
```

**Classify from results:**
- Total 90-day conversions ÷ 3 = monthly average
- If monthly average ≥ 30 → **Stage 3+ confirmed. Proceed to Step 1.**
- If below threshold → **Exit.** Say: "This account is not yet ready for scaling evaluation — it needs 30+ conversions/month (Stage 3). Current 90-day average: [X/month]. Load [[../../reference/platforms/google-ads/strategy/account-maturity-roadmap|account-maturity-roadmap.md]] for the Stage 2 → Stage 3 gate to work toward." **Do not write a report. Do not assign trajectories.**

## Step 1: Live MCP Data Pull

Load [[../../reference/mcp/mcp-capabilities|mcp-capabilities.md]] to confirm available fields. All reads are read-only — never call `unlock_writes` in this skill.

Run these 7 queries and collect all results before proceeding to gate evaluation.

**Query A — Campaign summary, 90 days:**
```gaql
SELECT campaign.id, campaign.name, campaign.status, campaign.serving_status,
  campaign.bidding_strategy_type,
  metrics.conversions, metrics.cost_micros, metrics.conversion_value,
  metrics.search_impression_share,
  metrics.search_budget_lost_impression_share,
  metrics.search_rank_lost_impression_share
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND segments.date DURING LAST_90_DAYS
```

**Query B — Daily campaign data, 30 days (CoV computation):**
```gaql
SELECT campaign.id, campaign.name,
  segments.date,
  metrics.conversions, metrics.cost_micros, metrics.conversion_value
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
ORDER BY campaign.id, segments.date
```

**Query C — Keyword quality scores:**
```gaql
SELECT ad_group_criterion.keyword.text,
  ad_group_criterion.quality_info.quality_score,
  metrics.impressions, metrics.clicks
FROM keyword_view
WHERE segments.date DURING LAST_30_DAYS
  AND ad_group_criterion.status = 'ENABLED'
ORDER BY metrics.impressions DESC
```

**Query D — Top-50 search terms by cost (hygiene check):**
```gaql
SELECT search_term_view.search_term, search_term_view.status,
  metrics.impressions, metrics.clicks, metrics.cost_micros, metrics.conversions
FROM search_term_view
WHERE segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
LIMIT 50
```

**Query E — PMax asset groups (run only if PMax campaigns detected in Query A):**
```gaql
SELECT asset_group.name, asset_group.ad_strength, campaign.name,
  campaign.shopping_setting.merchant_id
FROM asset_group
WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX'
  AND asset_group.status = 'ENABLED'
```

> [!info] Feed-only PMax AD_STRENGTH = POOR exception
> Feed-only PMax campaigns created via Merchant Center always show AD_STRENGTH = POOR. This is expected — not a defect. Confirm via `campaign.shopping_setting.merchant_id` presence before flagging. See v1.21.1 for the full exception rule.

**Query F — Negative keyword shared sets:**
```gaql
SELECT shared_set.name, shared_set.type, shared_set.member_count
FROM shared_set
WHERE shared_set.type = 'NEGATIVE_KEYWORDS'
  AND shared_set.status = 'ENABLED'
```

**Query G — Campaign budgets:**
```gaql
SELECT campaign_budget.amount_micros, campaign_budget.name,
  campaign_budget.has_recommended_budget,
  campaign_budget.recommended_budget_amount_micros
FROM campaign_budget
WHERE campaign_budget.status = 'ENABLED'
```

**Not GAQL-accessible:** Auction Insights — manual verification only if competitive context is needed.

## Step 2: Gate Evaluation

Evaluate all 8 gates using collected data. Each gate result = **PASS**, **FAIL**, or **WARNING**.

> [!warning] Write all 8 gate results to the report — passes and fails alike. The report is designed to be diffable across sessions.

### Gate 1 — Maturity Stage

Already confirmed in Step 0. Mark **PASS**.

Reference: [[../../reference/platforms/google-ads/strategy/account-maturity-roadmap|account-maturity-roadmap.md]] Stage 3/4 criteria.

### Gate 2 — Monthly Conversion Volume (target: ≥30/mo)

Using Query A (90-day) and Query B (30-day):
- 90-day total ÷ 3 = rolling monthly average
- Query B 30-day total = current month

**PASS** = both ≥30. **WARNING** = rolling average ≥30 but last 30 days < 30 (declining trend). **FAIL** = below threshold.

Reference: [[../../reference/platforms/google-ads/strategy/account-maturity-roadmap|account-maturity-roadmap.md]] L325-331, 465-471.

### Gate 3 — CPA/ROAS Stability (target: CoV ≤20%)

Using Query B daily data, compute the Coefficient of Variation (CoV) for daily CPA (or daily ROAS for e-commerce accounts):

- Daily CPA = daily `cost_micros` ÷ daily `conversions` (exclude days with 0 conversions)
- CoV = (standard deviation of daily CPA ÷ mean daily CPA) × 100

**PASS** = CoV ≤20%. **WARNING** = 20% < CoV ≤35%. **FAIL** = CoV > 35%.

> [!info] This is the only place in the plugin that computes CoV from live data. The roadmap defines the ±20% rule; this skill executes it.

Reference: [[../../reference/platforms/google-ads/strategy/account-maturity-roadmap|account-maturity-roadmap.md]] ±20% CoV rule.

### Gate 4 — Bid Strategy Fit

Using Query A `campaign.bidding_strategy_type`, apply the maturity ladder from [[../budget-optimizer/SKILL.md|budget-optimizer]] L40-48:

| Current strategy | Conversions/month | Gate result |
|---|---|---|
| `TARGET_CPA` or `TARGET_ROAS` | Any | **PASS** |
| `MAXIMIZE_CONVERSIONS` or `MAXIMIZE_CONVERSION_VALUE` | ≥30 (Gate 2 pass) + CoV ≤20% (Gate 3 pass) | **FAIL** → T2 |
| `MANUAL_CPC` | ≥30 | **FAIL** → T2 |
| `MAXIMIZE_CLICKS` | Any | **FAIL** → T2 |
| `ENHANCED_CPC` | Any | **FAIL** → T2 + flag as deprecated (removed March 2025) |

> [!warning] tROAS threshold discrepancy
> When advising on tROAS eligibility: account-maturity-roadmap.md states 50 conversions/month; Google's portfolio bid strategy docs (`support.google.com/google-ads/answer/6268637`) cite 15 conversions past 30 days for Search/Display. Do not hardcode either number. Cite the live URL and recommend the user confirm the current threshold in their account UI.

### Gate 5 — IS Headroom

Using Query A `metrics.search_budget_lost_impression_share`:

- Any campaign with `search_budget_lost_impression_share ≥ 0.15` = headroom exists
- **PASS** = headroom detected (budget is limiting, not rank) → T1 candidate
- **FAIL** = all campaigns < 0.15 (rank is the limiter — adding budget won't help)
- **WARNING** = mixed across campaigns

Reference: [[../budget-optimizer/SKILL.md|budget-optimizer]] IS-headroom L69-87, [[../../reference/platforms/google-ads/audit/audit-checklist|audit-checklist.md]] Area 16.

### Gate 6 — Learning Phase Clear

Using Query A `campaign.serving_status`:

- **PASS** = all enabled campaigns show `ELIGIBLE`
- **FAIL** = any campaign shows `LEARNING` → T5 (no scaling until learning exits; list affected campaigns by name)

Reference: [[../../reference/platforms/google-ads/learning-phase|learning-phase.md]], [[../post-launch-monitor/SKILL.md|post-launch-monitor]] L170-191.

### Gate 7 — Negative Keyword Hygiene

Using Query D (top-50 search terms by cost), manually review for: branded competitor names, spam/bot queries, clear intent mismatch (e.g., job seekers on a product campaign).

- **PASS** = ≤10% of top-50 terms are irrelevant
- **WARNING** = 10-25% irrelevant
- **FAIL** = >25% irrelevant → T5 (add negatives in Google Ads UI before any budget step)

Reference: [[../campaign-review/SKILL.md|campaign-review]] Area 8.

### Gate 8 — Tracking Infrastructure

Ask the user (MCP cannot verify this directly):
1. Is Enhanced Conversions active on the primary conversion action? (Y/N)
2. Is Data-Driven Attribution (DDA) shown in Google Ads → Goals → Conversions → Attribution? (Y/N)

- **PASS** = EC active + DDA active or eligible (≥300 conversions/30 days)
- **WARNING** = EC active, DDA not yet available (volume insufficient) — flag for future DDA switch, do not block scaling
- **FAIL** = EC not active → load [[../conversion-tracking/SKILL.md|conversion-tracking]] before continuing

Reference: [[../conversion-tracking/SKILL.md|conversion-tracking]], [[../../reference/platforms/google-ads/enhanced-conversions|enhanced-conversions.md]].

## Step 3: Trajectory Routing

Based on gate results, assign one or more active trajectories. Multiple can be active simultaneously. Present in priority order: **T5 → T2 → T1 → T3 / T4 / T6.**

Load [[../../reference/platforms/google-ads/strategy/scaling-playbook|scaling-playbook.md]] §5 for full decision tables, delta caps, and wait periods.

| Trajectory | Active when | First action |
|---|---|---|
| **T5: Stabilization Required** | Gate #3, #6, or #7 FAIL | Gate-clearing before any budget step — no exceptions |
| **T2: Bid Strategy Graduation** | Gates #2+#3 PASS + Gate #4 FAIL | Set tCPA at actual CPA × 1.15 |
| **T1: Budget Scale-Up** | Gate #5 PASS + Gates #1-3 PASS | +20% on IS-limited Search campaigns |
| **T3: Feed-Only PMax** *(e-comm only)* | Stage 3 + Search stable 8+ wks + MC confirmed + no existing PMax | Route to `/ad-platform-campaign-manager:pmax-guide` |
| **T4: Display + Demand Gen** | Stage 3+ + targets hit + remarketing list ≥1,000 | Display remarketing at 5% budget |
| **T6: Portfolio Consolidation** *(Stage 4 only)* | 3+ campaigns tCPA/tROAS within targets 60+ days, target difference <15% | Portfolio bid strategy setup |

> [!warning] Dynamic scaling limitation
> The T1-T6 trajectories are a starting point, not a complete dynamic scaling system. True dynamic scaling — real-time multi-variable interaction, PMax/Shopping cannibalization in motion, predictive signal reading — is beyond current skill capability. The skill's value is: MCP-powered gate evaluation + conditional trajectory routing + evidence-gated recommendations + projection guardrail. It does not replace real-time algorithmic optimization.

> [!warning] T1 + T2 conflict
> If both T1 and T2 are active: complete T2 (bid strategy graduation) first. The learning period triggered by the bid strategy switch means no budget steps should run during the 14-day learning window. Resume T1 evaluation after learning exits and Gate 3 (CoV) confirms stability post-graduation.

> [!info] PMax vs Shopping — Oct 2024
> Since October 2024, PMax and Shopping compete via Ad Rank. Do not assume PMax dominates Shopping budget when activating T3. Monitor both campaign types' impression share after PMax addition.

## Step 4: Report Write

Write a report every run, regardless of gate outcomes. A report with all FAILs is valuable — it documents the baseline before T5 gate-clearing begins.

**Report path:** `reports/{YYYY-MM-DD}/05-optimize/account-scaling.md`

Follow the 6-step write sequence in [[../../_config/conventions|conventions.md]] §Report File-Writing Convention:
1. Detect MWP project root (look for `_config/conventions.md`)
2. Ensure `reports/{YYYY-MM-DD}/05-optimize/` directory exists
3. Write full report (see template below)
4. Update `reports/{YYYY-MM-DD}/CONTEXT.md`
5. Update `reports/{YYYY-MM-DD}/SUMMARY.md` under "Optimization & Reporting"
6. Summarize in conversation: gate results, active trajectories, first action

**Report template:**

```markdown
---
title: Account Scaling Health Check — {Client Name}
date: {YYYY-MM-DD}
skill: account-scaling
stage: 05-optimize
account: {Client Name} ({Account ID})
tags: [report, google-ads, 05-optimize, account-scaling]
---

# Account Scaling Health Check — {Client Name}

## Gate Evaluation Results

| Gate | Result | Evidence |
|---|---|---|
| 1 — Maturity Stage | PASS/FAIL | {stage classification from live data} |
| 2 — Conversion Volume | PASS/FAIL/WARNING | {30-day: X, 90-day avg: Y/mo} |
| 3 — CPA/ROAS Stability | PASS/FAIL/WARNING | {CoV: X%} |
| 4 — Bid Strategy Fit | PASS/FAIL | {current strategy per campaign} |
| 5 — IS Headroom | PASS/FAIL/WARNING | {budget-lost IS: X% on [campaign name]} |
| 6 — Learning Phase | PASS/FAIL | {serving_status per campaign} |
| 7 — Neg-KW Hygiene | PASS/FAIL/WARNING | {X of top-50 terms flagged} |
| 8 — Tracking Infrastructure | PASS/FAIL/WARNING | {EC: active/inactive, DDA: active/eligible/unavailable} |

## Verdict

**[GO / NO-GO / CONDITIONAL-GO]**

{One sentence explaining the verdict — which gates drove it.}

## Active Trajectories (in priority order)

{Only list active trajectories. If none active, state: "All gates passed. No trajectory required at this time. Re-run in 30 days."}

### T[X]: [Trajectory Name]

**Triggered by:** Gate #[X] result — {evidence}
**First action:** {specific step from trajectory table}
**Wait period:** {X days before re-evaluation}
**Re-run trigger:** {condition that ends this trajectory}

## What This Report Does Not Cover

- Auction Insights (requires manual Google Ads UI check)
- DDA model confirmation (requires Goals → Conversions → Attribution in UI)
- Real-time multi-variable cannibalization (beyond current skill capability)
```

> [!warning] Projection guardrail — report content
> Do not state any numeric future target (ROAS, CPA, conversion volume, timeline) in this report unless it appears in a dated strategy document on file. Describe data gates. See [[../../_config/conventions|conventions.md]] §Client Communication Guardrails.

## What to Do Next

| Finding | Next Skill |
|---|---|
| T5 active — CPA volatile / attribution suspect | `/ad-platform-campaign-manager:conversion-tracking` |
| T5 active — search term hygiene failing | `/ad-platform-campaign-manager:campaign-cleanup` |
| T5 active — campaign still in learning | `/ad-platform-campaign-manager:post-launch-monitor` |
| T2 active — bid strategy graduation needed | `/ad-platform-campaign-manager:budget-optimizer` |
| T3 active — PMax channel expansion | `/ad-platform-campaign-manager:pmax-guide` |
| Full structural audit needed before scaling | `/ad-platform-campaign-manager:campaign-review` |
| Account strategy or stage classification | `/ad-platform-campaign-manager:account-strategy` |

---

## Report Output

When inside an MWP client project, write output to `reports/{YYYY-MM-DD}/05-optimize/account-scaling.md`.

Follow the 6-step write sequence and Output Completeness Convention in [[../../_config/conventions|conventions.md]]:
1. Detect MWP project root (look for `_config/conventions.md`)
2. Ensure `reports/{YYYY-MM-DD}/05-optimize/` directory exists
3. Write full report — all 8 gate results (all passes and fails), active trajectories, MCP data summary, first recommended action per trajectory
4. Update `reports/{YYYY-MM-DD}/CONTEXT.md` with new entry
5. Update `reports/{YYYY-MM-DD}/SUMMARY.md` under "Optimization & Reporting"
6. Summarize in conversation: verdict, active trajectories, next action

**Stage:** `05-optimize` | **Summary section:** Optimization & Reporting
