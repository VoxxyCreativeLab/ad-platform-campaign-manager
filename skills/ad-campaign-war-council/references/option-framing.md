---
title: Option Framing Template
date: 2026-04-18
tags:
  - ad-campaign-war-council
  - options
  - decision-framing
---

# Option Framing — War-Council

Every recommendation from `/ad-campaign-war-council` must be presented as 2-4 named options. Never a single take-it-or-leave-it recommendation. The goal is to give Jerry the decision — not make it for him.

> [!info] Why options, not conclusions
> Jerry is a tracking specialist making campaign decisions, not a campaign specialist who has seen hundreds of these situations. The war-council's role is to surface the decision space clearly, not to narrow it to one answer. Options with named trade-offs let Jerry apply his knowledge of the client, the context, and the risk tolerance that the war-council does not have.

---

## Option Block Template

```markdown
### Option [A/B/C]: [short name]

**Action:** [what specifically to do — per-campaign if budget, concrete if structural]
**Expected effect:** [what we expect to happen, stated as a condition, not a promise — use "if X then Y" language, not "X will happen"]
**Evidence:**
- [local: file path:line — what the data shows]
- [external: source name | Tier N | date | URL]
**Risk:** [what could go wrong]
**Reversibility:** [High / Medium / Low — and why]
```

---

## Rule on Projections

> [!warning] No ROAS promises
> Never write "this will achieve X ROAS." Write "if Shopping ROAS holds ≥ 3.5 at Day 14 and IS lost to budget remains >20%, the next step is increasing budget by €5/day."

The expected-effect line must be a conditional, not a forecast. Conditions are verifiable at a known future point. Forecasts are not. The war-council only makes commitments that the data can confirm or refute.

---

## Worked Example — Vaxter Day-14 Budget Decision (2026-04-21)

**Context:** The Vaxter (VäxterOnline.se) account launched 2026-04-07. Budget is frozen at €100/day total through May 7 (T5) per PRIMER.md. Day 14 is 2026-04-21. The Day-14 pre-authorized actions (PRIMER.md:75-81) are: Brand €5→€2/day, Remarketing €8→€6/day, freed €5 → Shopping (€67→€72) conditional on ROAS ≥ 3.5.

**Question from Jerry:** "Can we lift budgets? By how much per campaign?"

---

### Option A: Hold the Line to May 7

**Action:** No budget changes. Execute only within-T5 actions (product bid adjustments, negative keyword additions). Total spend cap stays at €100/day across all campaigns.

**Expected effect:** If Shopping ROAS holds ≥ 3.5 through May 7, the evidence base for the T5 budget lift will be stronger than if we act at Day 14. Smart Bidding continues learning on a stable signal for an additional 16 days.

**Evidence:**
- [PRIMER.md:56 — "Budget hold: €100/day through T5 (May 7)"]
- [reference/platforms/google-ads/learning-phase.md — budget changes >20% restart the learning period]

**Risk:** If Shopping ROAS is declining, waiting until May 7 wastes the window. If IS lost to budget is already high, competitors capture impressions that cannot be recovered.

**Reversibility:** High — no change means no learning reset, no irreversible action.

---

### Option B: Execute Pre-Authorized Day-14 Shifts Only

**Action:** Brand €5→€2/day; Remarketing €8→€6/day; freed €5 → Shopping €67→€72. Conditional: execute Shopping reallocation only if Shopping ROAS ≥ 3.5 at time of execution. If ROAS is below 3.5, revert to Option A.

**Expected effect:** If Shopping ROAS is ≥ 3.5 at execution, the €5 reallocation directs budget toward the best-performing campaign without triggering a learning reset, as the shifts stay within the pre-authorized envelope.

**Evidence:**
- [PRIMER.md:75-81 — pre-authorized Day-14 shifts]
- [reference/platforms/google-ads/strategy/post-launch-playbook.md — Day-14 gate criteria]
- [reference/platforms/google-ads/learning-phase.md — reallocation within existing total does not restart learning]

**Risk:** If Shopping ROAS is below 3.5, the conditional fails and we revert to Option A — no harm done. If Brand or Remarketing performance deteriorates after budget reduction, we may need to reverse.

**Reversibility:** High — small moves, no strategy change, no increase in total spend.

---

### Option C: Override T5 — Lift Shopping Budget Beyond Day-14 Pre-Authorization

> [!warning] Rule-override required
> This option requires an evidence-arbiter Support or Conditional verdict AND explicit confirmation from Jerry before execution. Do not present this option if evidence-arbiter has not returned.

**Action:** Shopping €67→€80/day (net +€13 above T5 cap, >20% increase on Shopping campaign). Total daily spend rises from €100 to €113/day.

**Expected effect:** If Shopping ROAS holds ≥ 3.5 AND IS lost to budget is the primary constraint (not IS lost to rank), the additional spend captures incremental revenue. However, the >20% increase threshold applies and may trigger a learning period restart on the Shopping campaign.

**Evidence:**
- [evidence-arbiter-verdict.md — to be dispatched before this option is presented; see [[skills/ad-campaign-war-council/references/rule-override-protocol|rule-override-protocol.md]]]
- [PRIMER.md:56 — rule being overridden: "Budget hold: €100/day through T5 (May 7)"]

**Risk:** Learning period reset on the Shopping campaign (estimated 2-4 weeks for Smart Bidding to restabilize). If IS lost to rank (not budget) is the real constraint, the extra spend has no effect on revenue and wastes the budget headroom intended for T5.

**Reversibility:** Low — a learning period reset is not instantly reversible. Recovery requires stable spend for the full relearning window.

---

> [!info] How to decide
> Check Shopping ROAS over the last 7 days (from `trend-analyst-deltas.md`). Check impression share lost to budget vs. impression share lost to rank (from `budget-advisor-proposal.md`). If Shopping ROAS ≥ 3.5 and IS lost to budget is >15%, Option B is supported by the data. If both metrics strongly favor scaling and the evidence-arbiter returned a Conditional or Support verdict, Option C is on the table with Jerry's confirmation. If either metric is weak, Option A is the correct default.

---

## Related Files

| File | Role |
|---|---|
| [[skills/ad-campaign-war-council/references/rule-override-protocol|rule-override-protocol.md]] | When to activate rule-override before presenting Option C |
| [[skills/ad-campaign-war-council/references/evidence-standards|evidence-standards.md]] | How to format evidence lines in option blocks |
| [[skills/ad-campaign-war-council/CONTEXT|CONTEXT.md]] | Which subagents produce the data files referenced in evidence lines |
