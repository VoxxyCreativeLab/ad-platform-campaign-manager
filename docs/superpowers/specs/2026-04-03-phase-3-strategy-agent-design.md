---
title: "Design Spec — Strategic Upgrade v2.0 Phase 3"
date: 2026-04-03
tags:
  - spec
  - design
  - strategy
---

# Strategic Upgrade v2.0 — Phase 3 Design Spec

**Status:** Approved
**Version target:** v1.7.0
**Approach:** Docs-first — write 5 reference docs, update routing, then build agent

---

## Context

Phase 2 (v1.6.0) delivered the `account-strategy` skill and made 10 of 12 skills profile-aware. The strategic layer can now profile accounts and tailor guidance — but it stops at strategy. There's no automated validation of whether an account's live state matches its strategy.

Phase 3 closes the loop: reference docs fill remaining knowledge gaps, and a new `strategy-advisor` agent cross-references live account data against the strategy to produce actionable gap analysis.

---

## Deliverables

### 1. Reference Docs (5 files)

#### Core reference (`reference/platforms/google-ads/`)

| File | Purpose | Depth |
|---|---|---|
| `shopping-feed-strategy.md` | Feed attributes, validation, optimization tactics, Merchant Center, feed rules, supplemental feeds | 150-200 lines |
| `ad-testing-framework.md` | RSA testing methodology, statistical significance, ad rotation, pinning strategy, creative iteration | 150-200 lines |

#### Strategy (`reference/platforms/google-ads/strategy/`)

| File | Purpose | Depth |
|---|---|---|
| `seasonal-planning.md` | Seasonal bid/budget adjustments, calendar planning, vertical-specific seasonality, ramp-up timelines | 150-200 lines |
| `remarketing-strategies.md` | Audience lists, membership durations, funnel stages, frequency capping, RLSA, vertical considerations | 150-200 lines |
| `bid-adjustment-framework.md` | Device, geo, schedule, audience bid adjustments by archetype and maturity | 150-200 lines |

#### Structure pattern (all 5 docs)

1. YAML frontmatter (`title`, `date`, `tags` with `reference`, `google-ads`, optionally `strategy`)
2. Decision tree or "When to use" section
3. H2 content sections with bold specs, comparison tables, `> [!type]` callout blocks
4. Common mistakes section
5. Vertical considerations (e-commerce, lead gen, B2B SaaS, local services)
6. Cross-references via `[[wikilinks]]` to related docs
7. `%%fact-check%%` annotations where claims need source verification

#### Delivery order

1. `shopping-feed-strategy.md` — standalone
2. `bid-adjustment-framework.md` — standalone
3. `remarketing-strategies.md` — standalone
4. `ad-testing-framework.md` — standalone
5. `seasonal-planning.md` — can reference bid-adjustment and remarketing concepts

---

### 2. Skill Routing Updates

#### CONTEXT.md — 5 new routing entries

| Reference Doc | Primary Skills | Agents |
|---|---|---|
| `shopping-feed-strategy.md` | `pmax-guide`, `campaign-setup` | `campaign-reviewer`, `strategy-advisor` |
| `ad-testing-framework.md` | `campaign-review`, `campaign-setup` | `campaign-reviewer`, `strategy-advisor` |
| `seasonal-planning.md` | `budget-optimizer`, `campaign-setup` | `strategy-advisor` |
| `remarketing-strategies.md` | `campaign-setup`, `keyword-strategy`, `campaign-review` | `campaign-reviewer`, `strategy-advisor` |
| `bid-adjustment-framework.md` | `budget-optimizer`, `campaign-review` | `campaign-reviewer`, `strategy-advisor` |

#### Existing agent updates

- `campaign-reviewer.md` — add 3 new reference doc pointers: `ad-testing-framework`, `remarketing-strategies`, `bid-adjustment-framework`
- `tracking-auditor.md` — no changes (none of the 5 docs are tracking-specific)

#### Existing skills

- No skill file changes needed — skills load reference docs dynamically via CONTEXT.md routing
- Profile-aware skills will naturally incorporate new content when routed

---

### 3. Strategy-Advisor Agent

#### File

`agents/strategy-advisor.md`

#### Frontmatter

```yaml
---
name: strategy-advisor
description: "Reads live account data via MCP, cross-references against strategy profile, and produces scored gap analysis with prioritized recommendations. Use when validating account state against strategy."
tools: "Read, Grep, Glob, Bash"
model: sonnet
---
```

#### Two modes

**Mode 1 — With profile (primary path):**

1. Accept account ID + existing strategy document (output from `/account-strategy`)
2. Pull live data via MCP tools:
   - Campaign structure (`list_campaigns`, `list_ad_groups`)
   - Spend and performance (`get_campaign_metrics`, `get_account_metrics`)
   - Conversion setup (`run_gaql` for conversion actions)
   - Bid strategies (from campaign data)
   - Keywords (`list_keywords`)
   - Ads (`list_ads`)
3. Cross-reference live data against:
   - Archetype recommendations (campaign mix, budget allocation)
   - Maturity roadmap (current stage vs recommended next stage)
   - Vertical playbook (vertical-specific must-haves)
   - `seasonal-planning.md` (current timing vs seasonal calendar)
   - `remarketing-strategies.md` (audience list coverage, funnel stages)
   - `ad-testing-framework.md` (ad variation count, testing discipline)
   - `bid-adjustment-framework.md` (adjustment coverage vs archetype recommendations)
   - `shopping-feed-strategy.md` (feed quality, if Shopping/PMax campaigns exist)
4. Output: scored gap analysis report

**Mode 2 — Without profile (cold run):**

1. Accept account ID only
2. Pull same live data via MCP
3. Output: structural health check — raw findings on campaign structure, spend distribution, conversion setup, obvious issues
4. End with strong recommendation to run `/account-strategy` first for full analysis

#### Output format

```markdown
# Strategy Advisor Report — [Account Name]

## Profile Summary
%%Table of 10 dimensions if profile exists, or "No profile — limited analysis" notice%%

## Overall Score: X/100

## Category Scores

### Campaign Mix Alignment — X/10
%%Archetype recommends X campaign types, account has Y. Gaps and surpluses.%%

### Budget Allocation — X/10
%%Recommended splits vs actual spend distribution.%%

### Bid Strategy Maturity — X/10
%%Current bid strategies vs maturity roadmap stage.%%

### Conversion Tracking Completeness — X/10
%%Conversion actions found vs tracking upgrade path recommendations.%%

### Remarketing Coverage — X/10
%%Audience lists, funnel stages, membership durations vs remarketing-strategies guidance.%%

### Ad Testing Discipline — X/10
%%Ad variations per ad group, testing cadence vs ad-testing-framework.%%

### Seasonal Readiness — X/10
%%Current timing vs seasonal-planning calendar for this vertical.%%

### Feed Quality — X/10 (if applicable)
%%Feed completeness, attribute coverage vs shopping-feed-strategy. Skip if no Shopping/PMax.%%

## Top 5 Priority Actions
%%Ranked by impact × effort. Each action links to the skill that can execute it.%%

## Detailed Findings
%%By category, severity-ranked (Critical / Warning / Opportunity). Each finding includes:%%
%%- What was found%%
%%- What was expected (with reference doc citation)%%
%%- Recommended action%%
%%- Relevant skill to invoke%%
```

#### Reference docs loaded

- All 8 existing strategy docs (`strategy/`)
- All 5 new reference docs (this phase)
- Core docs dynamically based on campaign types found in account (e.g., `shopping-campaigns.md` if Shopping campaigns exist)

---

### 4. Root Docs Update

All root markdown files updated to reflect v1.7.0 state:

| File | Changes |
|---|---|
| `CONTEXT.md` | 5 new routing entries, `strategy-advisor` agent entry, updated file counts |
| `CLAUDE.md` | Updated folder structure block (file counts), quick navigation (strategy-advisor entry) |
| `PRIMER.md` | Full rewrite — session handoff with Phase 3 complete state |
| `PLAN.md` | Phase 3 marked ✅ Done, Strategic Upgrade v2.0 Phase 3 marked ✅ Done, next steps updated |
| `CHANGELOG.md` | v1.7.0 entry with all deliverables listed |
| `DESIGN.md` | New decisions: docs-first approach, two-mode agent, doc placement rationale |
| `LESSONS.md` | Any lessons from this phase |
| `README.md` | Updated capability descriptions, reference file counts, agent count |
| `START-HERE.md` | Updated if it references available docs or agents |
| `.claude-plugin/plugin.json` | Version bump to 1.7.0 |

---

## Verification

After all deliverables are complete:

1. **File existence** — all 6 new files exist at correct paths
2. **Frontmatter** — all new files have valid YAML frontmatter
3. **Wikilinks** — all `[[wikilinks]]` in new docs resolve to existing files
4. **CONTEXT.md** — routing table has entries for all 5 new docs + strategy-advisor agent
5. **campaign-reviewer** — agent file references 3 new doc paths
6. **Root docs** — all 10 root files updated with correct counts and references
7. **Version consistency** — `plugin.json`, `CHANGELOG.md`, `PLAN.md` all say v1.7.0
8. **Git** — clean commit with all changes
