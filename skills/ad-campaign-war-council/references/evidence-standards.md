---
title: Evidence Standards
date: 2026-04-18
tags:
  - ad-campaign-war-council
  - evidence
  - citations
---

# Evidence Standards — War-Council

Every external claim made by `/ad-campaign-war-council` or its helpers (research-analyst, evidence-arbiter, budget-advisor, growth-architect) must meet this standard. No recommendation without citations.

> [!warning] Applies to all web-enabled helpers
> research-analyst, evidence-arbiter, budget-advisor, and growth-architect are all bound by this standard. Pure local-data agents (account-archivist, trend-analyst, communications-analyst) cite by file path + line number instead — see [[#Scope]].

---

## Source Tiers

| Tier | Name | Examples | Status |
|---|---|---|---|
| Tier 1 | Vendor-official | Google Ads Help Center, Google Ads Liaison posts, Meta Business Help Center, Microsoft Advertising docs, Google Developers documentation, official platform product blogs with publish dates | **Required as at least one source** for any rule-override claim |
| Tier 2 | High-accountability secondary | Search Engine Land, Search Engine Journal, PPC Hero — named-author articles with publish date and editorial accountability | Supporting only |
| Tier 3 | Community-consensus | Google Ads Community (verified / Gold Product Expert answers), StackOverflow accepted answers with high score, r/ppc threads when cross-confirming Tier 1/2 | Supporting only — never sole source |
| Tier 4 | Open-source / code evidence | GitHub repos with active commit history, referenced by repo URL + commit SHA + file path. Particularly for Ads Scripts, GAQL patterns, BigQuery schemas | Supporting only for conceptual claims; primary for implementation claims |

---

## Minimum Requirements

- **Every external claim:** at least 2 independent sources
- **Rule-override verdict:** at least 1 Tier-1 source, plus at minimum 1 additional source from any tier
- **If the minimum cannot be met:** state "I don't have citeable evidence yet — dispatching research-analyst" and pause. Do not proceed with an uncited claim.

> [!danger] No unsupported recommendations
> A recommendation with no citations is not a recommendation — it is an opinion. The war-council does not present opinions as decisions. If evidence is not yet in hand, dispatch research-analyst before presenting options.

---

## Forbidden Sources

- Anonymous blog posts (no named author)
- Undated content (no publish date visible)
- AI-generated summaries (including LLM-written articles without original sourcing)
- Marketing agency lead-gen content (articles written to rank, not to inform)
- Screenshots without a source URL

---

## Staleness Rule

Any claim citing documentation older than **18 months** from the current date must be re-verified against a current vendor-official source before use. The research-analyst is responsible for flagging stale citations in its output.

> [!tip] Publication dates matter
> If a Google Ads Help Center article lacks a visible publish or update date, treat it as undated — note the retrieval date and flag for verification.

---

## Citation Format

Every citation must appear in the following format in session files and verdict documents:

```
[source name | Tier N | publish date | URL]
```

**Example:**

```
[Google Ads Help - Budget changes and the learning period | Tier 1 | 2024-03-15 | https://support.google.com/google-ads/answer/...]
```

Multiple citations on a claim are listed as separate lines:

```
**Evidence:**
- [Google Ads Help - Budget changes and the learning period | Tier 1 | 2024-03-15 | https://support.google.com/google-ads/answer/...]
- [Search Engine Journal - Smart Bidding Learning Phase | Tier 2 | 2023-11-08 | https://www.searchenginejournal.com/...]
```

When citing local project files, use file path + line number instead:

```
[PRIMER.md:56 — "Budget hold: €100/day through T5 (May 7)"]
```

---

## Scope

| Agent | Citation method |
|---|---|
| research-analyst | Full citation format per this doc |
| evidence-arbiter | Full citation format per this doc (inherits from research-analyst output) |
| budget-advisor | Full citation format for external claims; file path + line for local data |
| growth-architect | Full citation format for external claims; file path + line for local data |
| account-archivist | File path + line number only (local MCP data, no external claims) |
| trend-analyst | File path + line number only (local MCP data, no external claims) |
| communications-analyst | File path + line number only (local project files, no external claims) |

> [!info] Related
> See [[skills/ad-campaign-war-council/references/rule-override-protocol|rule-override-protocol.md]] for how citations feed into the override adjudication flow.
