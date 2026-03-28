# Agents — Context

2 autonomous audit agents that perform multi-step analysis. Defined as `.md` files with YAML frontmatter (`name`, `description`, `tools`, `model`). Both use `model: sonnet` and have `Read, Grep, Glob, Bash` tools.

- **campaign-reviewer** — triggers on "review", "audit", or "analyze" a campaign
- **tracking-auditor** — triggers on "audit tracking", "verify conversions", or "check conversion setup"

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
