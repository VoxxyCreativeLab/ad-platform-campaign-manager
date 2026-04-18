---
title: "Stage 03 — Agents"
tags:
  - mwp
  - layer-2
  - stage
---

%% STAGE 03 — AGENTS (Autonomous Audit Tools) %%
%% Output from this stage lives in this folder's root. Agent .md files ARE the outputs. %%

# Agents — Context

3 autonomous agents that perform multi-step analysis. Defined as `.md` files with YAML frontmatter (`name`, `description`, `tools`, `model`). All use `model: sonnet` and have `Read, Grep, Glob, Bash` tools. Some agents are additionally granted `WebSearch, WebFetch` capabilities: research-analyst, evidence-arbiter, budget-advisor, and growth-architect.

- **campaign-reviewer** — triggers on "review", "audit", or "analyze" a campaign
- **tracking-auditor** — triggers on "audit tracking", "verify conversions", or "check conversion setup"
- **strategy-advisor** — triggers on "validate strategy", "check account against strategy", or "gap analysis". Requires account profile (from `/account-strategy`) for full scored gap analysis; runs structural health check without one.
- **account-archivist** — reads all client project artifacts and produces a comprehensive account-state brief (cold start, full orientation)
- **trend-analyst** — reads N days of reports, builds day-over-day delta tables, and flags anomalies by metric and campaign
- **communications-analyst** — reads all client communications, extracts approvals on file, agency commitments, active constraints, and open client questions
- **research-analyst** — searches official vendor docs, named-author publications, and GitHub for external evidence; returns citation-backed findings (WebSearch/WebFetch enabled)
- **evidence-arbiter** — adjudicates proposed rule overrides: issues Support / Oppose / Conditional verdict with local + external evidence (WebSearch/WebFetch enabled)
- **budget-advisor** — analyzes campaign budgets for marginal return and IS-headroom, proposes per-campaign budget deltas with learning-phase risk scores (WebSearch/WebFetch enabled)
- **growth-architect** — produces a forward account blueprint: expansion slate, asset/data gaps, 30/60/90-day trajectory for parabolic ROAS (internal-only; WebSearch/WebFetch enabled)

The `campaign-review` skill is the manual/guided version; the `campaign-reviewer` agent is the autonomous version. Same for `conversion-tracking` (skill) vs `tracking-auditor` (agent).

## Agent Reference Dependencies

```
campaign-reviewer ──→ audit/audit-checklist, audit/common-mistakes,
                      audit/negative-keyword-lists, quality-score,
                      bidding-strategies, account-structure
tracking-auditor ───→ tracking-bridge/*, conversion-actions,
                      enhanced-conversions
```

## Agent Outputs

Both agents produce structured markdown reports:
- **campaign-reviewer:** Scored checklist (X/Y passing), severity-tagged issues, prioritized action plan
- **tracking-auditor:** Layer-by-layer results (Ads → GTM → sGTM → BQ), data discrepancy table, architecture diagram
