---
title: Rule Override Protocol
date: 2026-04-18
tags:
  - ad-campaign-war-council
  - rule-override
  - evidence-arbiter
---

# Rule Override Protocol

This protocol activates whenever `/ad-campaign-war-council` detects that a recommended action contradicts a rule in PRIMER.md, PLAN.md, DESIGN.md, a spec doc, or any documented strategy decision.

> [!warning] Non-negotiable sequence
> Do not present override options to Jerry before the evidence-arbiter verdict is in hand. The verdict is not advisory — it determines which options are presented and in what order.

---

## Detection Triggers

The following keywords or phrasings in Jerry's input indicate a potential rule conflict and activate this protocol:

- "before May 7" (or any date that precedes a documented gate)
- "lift the freeze early"
- "increase budget before"
- "override"
- "ignore the rule"
- "different from what we agreed"
- "change the plan"
- "can we skip"
- "what if we just"
- "earlier than planned"
- "ahead of schedule"
- "bump the budget"
- Any question asking to take a campaign action that a PRIMER.md, PLAN.md, or spec doc explicitly defers or prohibits

> [!tip] When in doubt, activate
> If the request might contradict a documented decision, activate the protocol. A false positive costs one round of research. A missed override that damages a campaign's learning period costs weeks.

---

## Protocol Steps

1. **Identify the specific rule.** Quote the exact text of the rule and state its source file + line number. Example: `PRIMER.md:56 — "Budget hold: €100/day through T5 (May 7)"`

2. **Identify the proposed action.** State clearly what Jerry is asking to do and what the justification might be. Example: "Jerry is asking whether Shopping budget can be increased on Day 14 (2026-04-21) — 16 days before the T5 freeze lifts."

3. **Dispatch `evidence-arbiter`** with both the rule text and the proposed action. Do NOT present Jerry with options until evidence-arbiter returns. The evidence-arbiter will dispatch research-analyst if external citations are needed.

4. **Print the evidence-arbiter verdict block verbatim** in the response. Do not paraphrase. Format:

   ```
   **Evidence-Arbiter Verdict**
   Verdict: [Support / Oppose / Conditional]
   Confidence: [High / Medium / Low]
   Condition (if Conditional): [exact condition that must be true for the override to be defensible]
   Citations:
   - [citation 1 per evidence-standards.md format]
   - [citation 2]
   ```

5. **If verdict is "Oppose" or confidence is Low:** present the hold-the-rule option as the default (Option A). Present the override as Option C with full risk disclosure including learning period reset, client communication implications, and reversibility.

6. **If verdict is "Support" or "Conditional":** present the compliant action as Option A, the override as Option B (or Option A if the override IS the most evidenced path), and include the condition explicitly if verdict was Conditional.

7. **Require explicit override confirmation from Jerry** before any override action is taken or communicated to the client. "I think B is right" is not confirmation. "Do B" or "go with Option B" is confirmation.

8. **If override confirmed:** log the decision to `LESSONS.md` in the client project. Entry must include:
   - Date of decision
   - The rule that was overridden (quoted text + source)
   - The action taken
   - The evidence-arbiter verdict (Support / Conditional)
   - All citations from the verdict as supporting evidence

---

## What NOT to Do

- Do not skip evidence-arbiter — not even for "obvious" cases
- Do not present override options before the verdict is returned
- Do not implement an override before Jerry explicitly confirms
- Do not communicate override reasoning to the client without Jerry's sign-off
- Do not treat a previous override of a similar rule as precedent without re-running the protocol

> [!danger] Client communication boundary
> If an override is agreed, Jerry decides what (if anything) to communicate to the client. The war-council does not draft client-facing rationale for an override until Jerry explicitly requests it and the override has been confirmed.

---

## Example Trigger

> [!example] Vaxter budget freeze — Day 14
> Rule in PRIMER.md: `"Budget hold: €100/day through T5 (May 7)"` (PRIMER.md:56)
>
> Trigger: Jerry asks "Can we increase budgets on Day 14?"
>
> What happens:
> 1. War-council quotes the rule and its source
> 2. States proposed action: increase Shopping budget beyond pre-authorized Day-14 shifts (i.e., beyond what PRIMER.md:75-81 already allows)
> 3. Dispatches evidence-arbiter (which dispatches research-analyst for learning-phase documentation)
> 4. Prints verdict verbatim
> 5. Frames options per [[skills/ad-campaign-war-council/references/option-framing|option-framing.md]] — Option A hold, Option B pre-authorized shifts, Option C override
> 6. Waits for Jerry's confirmation before acting

---

## Related Files

| File | Role |
|---|---|
| [[skills/ad-campaign-war-council/references/evidence-standards|evidence-standards.md]] | Citation tiers and format for verdict citations |
| [[skills/ad-campaign-war-council/references/option-framing|option-framing.md]] | How to frame options after the verdict is in |
| [[skills/ad-campaign-war-council/CONTEXT|CONTEXT.md]] | Dispatch pattern — where evidence-arbiter fits in the subagent sequence |
