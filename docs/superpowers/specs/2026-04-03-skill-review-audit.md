---
title: "Skill Review Audit — All 11 Skills"
date: 2026-04-03
tags:
  - mwp
  - audit
  - skills
---

# Skill Review Audit — All 11 Skills

**Date:** 2026-04-03
**Methodology:** Anthropic skill-building best practices + MWP quality criteria
**Average score:** 82/100

---

## Scorecard

| Rank | Skill | Score | Rating | Top Issue |
|------|-------|-------|--------|-----------|
| 1 | pmax-guide | 90/100 | ==Excellent== | Missing argument-hint |
| 2 | campaign-setup | 89/100 | **Good** | Wizard-mode flag question, minor structural |
| 3 | conversion-tracking | 87/100 | **Good** | Missing argument-hint, no output template |
| 4 | campaign-cleanup | 87/100 | **Good** | Missing argument-hint, no $ARGUMENTS handling |
| 5 | reporting-pipeline | 84/100 | **Good** | Missing inter-skill ref to live-report, no error handling for tooling gaps |
| 6 | ads-scripts | 83/100 | **Good** | Missing argument-hint |
| 7 | campaign-review | 82/100 | **Good** | No inter-skill ref to conversion-tracking, no error handling for insufficient data |
| 8 | keyword-strategy | 82/100 | **Good** | No error handling, no inter-skill refs, dependency map mismatch |
| 9 | connect-mcp | 82/100 | **Good** | No OAuth-flow error handling, `disable-model-invocation: true` justified |
| 10 | budget-optimizer | 76/100 | Fair | Missing argument-hint, no $ARGUMENTS, no output format, dependency map mismatch |
| 11 | live-report | 62/100 | Needs work | Zero error handling, no GAQL mapping, no examples, disable flag questionable |

---

## Systemic Issues (Affect All or Most Skills)

### 1. Missing `argument-hint` (9 of 11 skills)

Only `campaign-setup` and `keyword-strategy` have `argument-hint`. All other skills should add one.

| Skill | Recommended `argument-hint` |
|-------|-----------------------------|
| budget-optimizer | `"[budget-amount or campaign-name]"` |
| campaign-cleanup | `"[client-name]"` |
| campaign-review | `"[campaign-name-or-data]"` |
| conversion-tracking | `"[setup\|troubleshoot\|enhanced-conversions]"` |
| pmax-guide | `"[feed-only\|full\|optimize\|report]"` |
| reporting-pipeline | `"[gaql\|bigquery\|dbt\|looker-studio\|pipeline]"` |
| ads-scripts | `"describe the automation you need or browse the catalog"` |
| connect-mcp | `"optional: account name or MCC ID"` |
| live-report | `"report type and date range"` |

### 2. No `{{placeholder}}` Template Syntax (All 11 Skills)

All skills use `[square bracket]` placeholders in output templates instead of `{{curly-brace}}` syntax per MWP convention.

**Fix:** Replace all `[Client Name]`, `[Type]`, `[Goal]`, `[Region]`, `[X]`, `[Y]` etc. with `{{client_name}}`, `{{type}}`, `{{goal}}`, `{{region}}` throughout.

### 3. Missing Inter-Skill Cross-References (6 of 11 Skills)

Skills that should reference other skills but don't:

| Skill | Missing Reference | Context |
|-------|-------------------|---------|
| keyword-strategy | → campaign-setup, budget-optimizer | After keyword list is built |
| budget-optimizer | → campaign-cleanup, conversion-tracking | When structure or tracking issues found |
| campaign-review | → conversion-tracking | When tracking is missing/misconfigured |
| reporting-pipeline | → live-report | For ad-hoc data vs pipeline design |
| live-report | → connect-mcp | MCP prerequisite exists but thin |
| ads-scripts | (none missing) | Already self-contained |

### 4. Dependency Map Drift (2 Skills)

SKILL.md references files not listed in skills/CONTEXT.md or root CONTEXT.md:

| Skill | Referenced but Unlisted |
|-------|------------------------|
| keyword-strategy | `account-structure.md` |
| budget-optimizer | `account-structure.md`, `common-mistakes.md` |

### 5. No Companion Files (All 11 Skills)

All skills are single SKILL.md files with no `references/` or `templates/` subdirectories. Acceptable at current word counts (271-1,177 words) but should be monitored. `live-report` especially needs companion files for report templates.

### 6. Inconsistent $ARGUMENTS Handling (5 of 11 Skills)

Only `campaign-setup` and `keyword-strategy` document argument behavior. Others either ignore arguments entirely or handle them implicitly.

---

## Priority Fix Order

### Tier 1: Critical (Score < 70)

**live-report (62/100)** — Most urgent:
- Add troubleshooting table (zero error handling currently)
- Add concrete GAQL-to-report mapping for each of 6 report types
- Add at least one complete sample output table
- Reconsider `disable-model-invocation: true` — this is read-only, not a config wizard
- Add `references/report-templates.md` with actual templates
- Fix `looker-studio-templates.md` reference mismatch

### Tier 2: Significant (Score 70-84)

**budget-optimizer (76/100):**
- Add `argument-hint`
- Add `$ARGUMENTS` handling
- Add output format/template
- Add inter-skill references (→ campaign-cleanup, → conversion-tracking)
- Fix dependency map (add account-structure, common-mistakes to CONTEXT.md)

**keyword-strategy (82/100):**
- Add troubleshooting section for failure scenarios
- Add inter-skill references (→ campaign-setup, → budget-optimizer)
- Fix dependency map (add account-structure to CONTEXT.md)

**campaign-review (82/100):**
- Add inter-skill ref to conversion-tracking
- Add error handling for insufficient data
- Add `argument-hint`

**connect-mcp (82/100):**
- Add OAuth-flow error handling (consent rejection, redirect URI mismatch)
- Strengthen security section (.gitignore verification)
- Add `argument-hint`

### Tier 3: Minor Polish (Score 85+)

**campaign-setup (89/100):** Document wizard-mode flag rationale
**campaign-cleanup (87/100):** Add argument-hint, $ARGUMENTS handling
**conversion-tracking (87/100):** Add argument-hint, output template
**reporting-pipeline (84/100):** Add inter-skill ref to live-report, tooling gap handling
**ads-scripts (83/100):** Add argument-hint
**pmax-guide (90/100):** Add argument-hint (only issue)

---

## What's Done Well (Strengths Across All Skills)

- All descriptions follow the WHAT + WHEN formula (148-202 chars, under 1024)
- Zero broken wikilinks across 70+ total references
- All use Obsidian wikilink syntax for internal references
- No XML angle brackets in any frontmatter
- No ambiguous language ("might", "could", "usually") in any skill
- All well under 5,000-word progressive disclosure limit (271-1,177 words)
- All properly listed in skills/CONTEXT.md, root CONTEXT.md, and README.md
- Reference material properly externalized — no knowledge duplication in skill bodies
- Each directory contains only SKILL.md (no orphan files)
- pmax-guide is the gold standard — best decision tree, most comprehensive troubleshooting, only skill with proper inter-skill cross-referencing

---

## Recommendations for Strategic Upgrade

These findings feed directly into the v2.0 strategic upgrade design (`2026-04-03-strategic-upgrade-design.md`):

1. **Fix systemic issues first** — argument-hint, placeholder syntax, inter-skill refs, and dependency maps should be fixed across all skills before adding strategy features. These are mechanical fixes.

2. **live-report needs redesign** — It's essentially a table of contents. The strategic upgrade should rebuild it with actual GAQL queries, MCP tool mappings, and output templates.

3. **budget-optimizer is the weakest core skill** — The strategic upgrade's account-profile framework will heavily affect budget guidance. This skill needs both structural fixes AND strategy-aware content.

4. **pmax-guide is the template** — Use its structure (Step 0 decision tree, task paths, troubleshooting table, inter-skill refs) as the model when enhancing other skills.

5. **Inter-skill wiring is the highest-impact improvement** — Currently each skill is an island. The strategic upgrade should create a clear skill flow graph (account-strategy → campaign-setup → keyword-strategy → budget-optimizer → conversion-tracking → campaign-review).
