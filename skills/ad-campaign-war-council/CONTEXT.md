---
title: "War-Council — Context"
date: 2026-04-18
tags:
  - mwp
  - layer-2
  - stage
  - ad-campaign-war-council
---

# War-Council — Context

> [!info] Load on demand
> Load reference docs for the specific question type only. Do not load the entire reference tree into context.

## Reference Routing

_File paths in the Reference docs and Skip columns are load-time references for Claude — backtick-formatted strings, not navigation links._

| Question type | Reference docs to load | Skip |
|---|---|---|
| Day X gate / budget freeze override decision | `reference/platforms/google-ads/strategy/post-launch-playbook.md`, `reference/platforms/google-ads/learning-phase.md`, `reference/platforms/google-ads/bidding-strategies.md`, `skills/ad-campaign-war-council/references/rule-override-protocol.md`, `skills/ad-campaign-war-council/references/evidence-standards.md`, `skills/ad-campaign-war-council/references/option-framing.md` | tracking-bridge, scripts, keyword refs |
| Forward account blueprint / what campaigns to build next | `reference/platforms/google-ads/strategy/account-maturity-roadmap.md`, `reference/platforms/google-ads/strategy/scaling-playbook.md`, `reference/platforms/google-ads/strategy/account-profiles.md`, `reference/platforms/google-ads/campaign-types.md`, `skills/ad-campaign-war-council/references/option-framing.md` | tracking-bridge, reporting, scripts |
| Budget reallocation across campaigns | `reference/platforms/google-ads/strategy/post-launch-playbook.md`, `reference/platforms/google-ads/bidding-strategies.md`, `reference/platforms/google-ads/learning-phase.md`, `reference/platforms/google-ads/strategy/bid-adjustment-framework.md`, `skills/ad-campaign-war-council/references/evidence-standards.md`, `skills/ad-campaign-war-council/references/option-framing.md` | tracking-bridge, scripts, keyword refs |
| Rule-override adjudication | `skills/ad-campaign-war-council/references/rule-override-protocol.md`, `skills/ad-campaign-war-council/references/evidence-standards.md`, `skills/ad-campaign-war-council/references/option-framing.md`, `reference/platforms/google-ads/learning-phase.md` | tracking-bridge, scripts |
| Online research for latest best practices | `skills/ad-campaign-war-council/references/evidence-standards.md` — research-analyst dispatched on-demand | everything else (load nothing local until results return) |
| Full account state brief (cold start / orientation) | `reference/platforms/google-ads/strategy/account-profiles.md`, `reference/platforms/google-ads/strategy/post-launch-playbook.md`, `reference/platforms/google-ads/strategy/account-maturity-roadmap.md`, `reference/mcp/mcp-capabilities.md`, `skills/ad-campaign-war-council/references/option-framing.md` | tracking-bridge, scripts |
| Multi-day trend comparison / anomaly detection | `reference/platforms/google-ads/strategy/post-launch-playbook.md`, `reference/platforms/google-ads/strategy/seasonal-planning.md`, `reference/mcp/mcp-capabilities.md` | tracking-bridge, scripts, keyword refs |
| Stakeholder communication review / what client approved | `reference/platforms/google-ads/strategy/account-profiles.md`, `_config/conventions.md` (§Client Communication Guardrails), `skills/ad-campaign-war-council/references/option-framing.md` | tracking-bridge, scripts, reporting |
| Existing campaign audit → escalate to campaign-reviewer agent | `agents/campaign-reviewer.md`, `reference/platforms/google-ads/audit/`, `reference/platforms/google-ads/learning-phase.md` | war-council option-framing (agent runs its own output format) |
| Existing strategy validation → escalate to strategy-advisor agent | `agents/strategy-advisor.md`, `reference/platforms/google-ads/strategy/`, `reference/platforms/google-ads/campaign-types.md`, `reference/platforms/google-ads/bidding-strategies.md` | war-council option-framing (agent runs its own output format) |
| Tracking audit → escalate to tracking-auditor agent | `agents/tracking-auditor.md`, `reference/tracking-bridge/`, `reference/platforms/google-ads/conversion-actions.md`, `reference/platforms/google-ads/enhanced-conversions.md` | war-council option-framing (agent runs its own output format) |

---

## Helper Subagents

| Helper subagent | Triggers | Produces |
|---|---|---|
| account-archivist | Cold-start orientation; full account state brief requested; session resumed after gap | `account-state-brief.md` — current campaign list, budgets, statuses, last 7-day KPIs, PRIMER.md snapshot |
| trend-analyst | Multi-day comparison; anomaly detected; "why did X change?"; Day X gate triggered | `trend-analyst-deltas.md` — day-by-day metric table, delta % vs prior period, anomaly flags |
| communications-analyst | Stakeholder communication review; "what did we tell the client?"; approval verification | `communications-summary.md` — timeline of client communications, what was approved, what was promised |
| research-analyst | Any claim lacking external citation; rule-override adjudication when Tier-1 source needed; "what does Google say about X?" | `research-findings.md` — structured citations per evidence-standards.md, Tier classification, publish dates |
| evidence-arbiter | Rule-override protocol activated (always after research-analyst returns, never before) | `evidence-arbiter-verdict.md` — Support / Oppose / Conditional verdict, confidence level, citations |
| budget-advisor | Budget reallocation decision; Day X gate with spend data needed; "how should we allocate?" | `budget-advisor-proposal.md` — per-campaign current vs proposed budget, IS lost to budget data, reallocation rationale |
| growth-architect | Forward blueprint requested; "what do we build next?"; account maturity assessment | `growth-architect-blueprint.md` — phased campaign build sequence, maturity gate criteria, rationale |

---

## Dispatch Pattern

Most helpers run **in parallel** via a single message with multiple Agent tool calls. Send account-archivist, trend-analyst, budget-advisor, and communications-analyst simultaneously when a full account brief is needed — do not wait for each to complete before starting the next.

**evidence-arbiter always runs serially, AFTER the parallel fan-in.** The evidence-arbiter needs research-analyst output (citations) before it can return a verdict. Never dispatch evidence-arbiter in the same parallel batch as research-analyst.

**research-analyst is triggered on-demand** when a claim lacks external evidence or when rule-override protocol requires a Tier-1 source. It is not dispatched on every question — only when the current context has no citeable source for a claim being made.

Typical dispatch sequence for a budget-override decision:

```
[Message 1 — parallel]
  → account-archivist  (account state)
  → trend-analyst      (spend + ROAS deltas)
  → budget-advisor     (reallocation proposal)

[Message 2 — parallel, after Message 1 returns]
  → research-analyst   (Tier-1 source for learning-phase reset rule)

[Message 3 — serial, after Message 2 returns]
  → evidence-arbiter   (verdict on the override)

[Message 4 — war-council output]
  → option-framing template applied, verdict block printed
```

> [!warning] Do not skip serial ordering for evidence-arbiter
> Dispatching evidence-arbiter before research-analyst has returned will produce an unverifiable verdict. The rule-override-protocol.md enforces this constraint — see [[skills/ad-campaign-war-council/references/rule-override-protocol|rule-override-protocol]].

---

## Related Files

| File | Role |
|---|---|
| [[skills/ad-campaign-war-council/references/evidence-standards|evidence-standards.md]] | Citation tiers, minimum requirements, forbidden sources, citation format |
| [[skills/ad-campaign-war-council/references/rule-override-protocol|rule-override-protocol.md]] | Step-by-step rule-override adjudication process |
| [[skills/ad-campaign-war-council/references/option-framing|option-framing.md]] | Canonical option block template + worked example |
| [[_config/conventions|_config/conventions.md]] | Output conventions, Client Communication Guardrails |
| [[reference/mcp/mcp-capabilities|mcp-capabilities.md]] | What data is available via MCP vs. manual verification |
