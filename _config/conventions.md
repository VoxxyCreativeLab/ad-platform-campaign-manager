---
title: Conventions
tags:
  - layer-3
  - reference
---

# Conventions

%% LAYER 3 — STABLE REFERENCE %%
%% Naming, file organisation, and structural rules for this plugin. %%
%% Split into plugin development conventions and campaign output conventions. %%

---

## Plugin Development Conventions

### SKILL.md Frontmatter

Every skill file must include YAML frontmatter with these fields:

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Lowercase, hyphen-separated. Must match the parent folder name. |
| `description` | Yes | One sentence. Used in skill discovery and help output. |
| `disable-model-invocation` | Yes | `true` for wizard skills (step-by-step), `false` for reference skills (question-driven). |
| `argument-hint` | No | Placeholder hint shown to the user (e.g., `"[campaign-type]"`). |

### Reference File Naming

- **Format:** `kebab-case.md` (e.g., `bidding-strategies.md`, `gtm-to-gads.md`)
- **Grouping:** files live in topic subdirectories under `reference/` (e.g., `platforms/google-ads/`, `tracking-bridge/`, `reporting/`)
- **Sub-topics:** use nested directories (e.g., `platforms/google-ads/pmax/`, `platforms/google-ads/audit/`)

### Reference File Structure

1. YAML frontmatter: `title`, `date`, `tags`
2. H1 title matching the `title` frontmatter property
3. Sections with H2/H3 headings
4. Tables for structured data, fenced code blocks for examples
5. Wikilinks for cross-references to other reference files: `[[filename]]` or `[[path/filename|display text]]`

### Agent File Naming

- **Format:** `kebab-case.md` in `agents/` directory
- **Frontmatter:** `name`, `description`, `tools` (array), `model` (e.g., `sonnet`)

### Skill Directory Naming

- Lowercase, hyphen-separated: `campaign-setup/`, `keyword-strategy/`
- Must match the `name` field in the SKILL.md frontmatter
- Each directory contains exactly one `SKILL.md` file

### Internal Cross-References

- Within reference files: `[[filename]]` or `[[filename|display text]]`
- From SKILL.md to reference: `[[../../reference/path/filename|filename.md]]`
- External URLs: standard markdown `[text](https://url)`

### Version Control

- Commit message format: `type: description` where type is one of `feat`, `fix`, `chore`, `refactor`, `docs`
- Tag releases: `v[major].[minor]`
- Commit after each logical change (not batched at end of session)

---

## Campaign Output Conventions

### Campaign Plan Format

Campaign plans produced by the `campaign-setup` skill follow this structure:

1. **Campaign overview** — name, type, goal, budget, bid strategy, targeting
2. **Ad groups / asset groups** — names, themes, keywords or audience signals
3. **Ad copy** — all headlines, descriptions, and assets
4. **Extensions** — sitelinks, callouts, structured snippets with copy
5. **Negative keywords** — initial negative keyword list
6. **Conversion tracking status** — what's set up, what's needed
7. **Next steps** — checklist for implementing in Google Ads

### Ad Copy Format

| Asset type | Character limit | Notes |
|-----------|----------------|-------|
| RSA headline | 30 characters | 15 per ad group, varied themes |
| RSA description | 90 characters | 4 per ad group |
| PMax headline | 30 characters | 5 per asset group |
| PMax long headline | 90 characters | 5 per asset group |
| PMax description | 90 characters | 5 per asset group |

Rules:
- Sentence case (not Title Case or ALL CAPS)
- No repetition across headlines
- Include: keywords, value propositions, CTAs, brand name, differentiators
- Pin only when necessary (prefer unpinned for RSA optimization)

### Keyword List Format

| Column | Description |
|--------|-------------|
| Keyword | The keyword phrase |
| Match type | Broad, Phrase, or Exact |
| Ad group | Which ad group this keyword belongs to |
| Rationale | Why this match type was chosen |

Group keywords by ad group. Include negative keywords as a separate section.

### Audit Report Format

Campaign audits (from `campaign-review` skill or `campaign-reviewer` agent):

1. **Scorecard** — X/Y checks passing, overall score
2. **Findings** — each issue tagged with severity: `Critical`, `Warning`, `Info`
3. **Action plan** — prioritized list, critical items first
4. **Quick wins** — changes that take <5 minutes with high impact

### Tracking Audit Format

Tracking audits (from `conversion-tracking` skill or `tracking-auditor` agent):

1. **Layer-by-layer results** — Google Ads → GTM → sGTM → BigQuery
2. **Data discrepancy table** — expected vs actual conversion counts per layer
3. **Architecture diagram** — text-based data flow
4. **Recommendations** — fixes per layer, ordered by data loss impact

---

## Folder Naming

- Lowercase, hyphen-separated: `my-folder-name`
- No spaces, no underscores (exception: `_config/` per MWP convention)
- Plugin root directories are convention-locked: `skills/`, `agents/`, `reference/`, `_config/`, `.claude-plugin/`

---

## Output Completeness Convention

All skill and agent output written to report files MUST be fully specified and deterministic. This is a hard rule, not a suggestion.

### Prohibited Patterns

These patterns are banned from all report file output:

- `etc.` / `...` / `and so on` / `similar to above`
- `repeat for remaining X`
- Truncating lists, tables, or repetitive sections
- Shortening later items because earlier items established a pattern
- `[same as group 1]` or any back-reference that avoids writing content

### Required Behavior

- If a skill recommends 8 asset groups with 5 attributes each, all 40 attribute values are written.
- If a keyword strategy has 142 keywords, all 142 are listed with match type and intent.
- If an audit checks 11 sections, all 11 sections appear with their findings, even if 7 passed cleanly.
- Every table row is complete. Every list item is complete. No implicit repetition.

### When Output is Genuinely Massive

If a single report file would exceed approximately 500 lines, split into sub-files within the same stage folder. Example: `02-plan/keyword-strategy-brand.md`, `02-plan/keyword-strategy-competitor.md`. CONTEXT.md reflects all sub-files.

---

## Report File-Writing Convention

When a report-producing skill or agent runs inside an MWP client project (detected by `stages/` or `reports/` directory at CWD), it follows this 6-step write sequence.

### Step 1: Detect MWP Project

Check if CWD has a `stages/` directory or `reports/` directory. If yes: MWP project detected, proceed with file writing. If no: fall back to conversational output (legacy behavior, nothing breaks).

### Step 2: Ensure Directory Structure

- Create `reports/{YYYY-MM-DD}/` if it does not exist (use today's date).
- Create `reports/{YYYY-MM-DD}/{stage}/` for this skill's assigned stage.

### Step 3: Write the Technical Report

Write full output to `reports/{YYYY-MM-DD}/{stage}/{skill-name}.md`.

If the same skill runs twice on the same day, overwrite the existing file (the latest run is authoritative).

Frontmatter template for report files:

````yaml
---
title: {Skill Display Name} - {Client Name}
date: {YYYY-MM-DD}
skill: {skill-name}
stage: {stage}
account: {Client Name} ({Account ID})
tags: [report, google-ads, {stage}, {skill-name}]
---
````

### Step 4: Update CONTEXT.md

CONTEXT.md is the technical index for the specialist, located at `reports/{YYYY-MM-DD}/CONTEXT.md`.

- If CONTEXT.md does not exist: create it from the template below with the first entry.
- If it exists: update the row for this skill (replace if re-running same day, append if new).
- Update "What Was Not Run" section (remove this skill from the list).

CONTEXT.md template:

````yaml
---
title: Campaign Report - {Client Name}
date: {YYYY-MM-DD}
account: {Client Name} ({Account ID})
tags: [report, google-ads]
---
````

````markdown
## Report Overview

| File | Stage | Skill | Summary |
|------|-------|-------|---------|
| [[{stage}/{skill-name}]] | {stage} | {skill-name} | {One-line summary of key findings} |

## What Was Not Run

Skills not invoked this session: {comma-separated list of remaining skills}

## Reading Order

Read files in stage order (01 -> 05) for the full picture.
Start with 01-audit if triaging. Start with 02-plan if building new.
````

### Step 5: Update SUMMARY.md

SUMMARY.md is the client-facing summary, located at `reports/{YYYY-MM-DD}/SUMMARY.md`.

- If SUMMARY.md does not exist: create it from the template below.
- Append (or replace if re-running same day) this skill's client-facing paragraph to the appropriate section.
- If a section has no content (no skills ran for that stage), omit the section entirely.

Rules for SUMMARY.md content:
- Language is non-technical: "We found 3 issues affecting your ad spend" not "QS = 4.2, CTR below 2% threshold"
- Numbers and quantities always included: "142 keywords", "8 asset groups", "2,500 EUR per month"
- No implementation detail: client knows WHAT and HOW MANY, not HOW
- Typical length per skill: 3-5 lines. Additional lines permitted when strictly necessary.
- No em-dashes in SUMMARY.md. Use hyphens or restructure the sentence.

SUMMARY.md template:

````yaml
---
title: Campaign Report - {Client Name}
date: {YYYY-MM-DD}
account: {Client Name} ({Account ID})
type: client-summary
tags: [report, client, google-ads]
---
````

Sections (map to stages):

| Section | Stage | Skills |
|---------|-------|--------|
| Account Health | 01-audit | campaign-review, campaign-cleanup, live-report, campaign-reviewer (agent) |
| Strategy & Planning | 02-plan | account-strategy, keyword-strategy, budget-optimizer, strategy-advisor (agent) |
| Campaign Build | 03-build | campaign-setup, pmax-guide, ads-scripts |
| Tracking & Launch | 04-launch | conversion-tracking, tracking-auditor (agent, exception: lives in 01-audit physically) |
| Optimization & Reporting | 05-optimize | reporting-pipeline |

### Step 6: Conversation Summary

After writing files, show a 5-10 line summary in conversation with key findings plus file path. Example: "Audit complete - 3 critical issues, 5 warnings. Full report: `reports/2026-04-04/01-audit/campaign-review.md`"

---

## Client Communication Guardrails

> [!info] Cross-plugin rule
> This section extends the master plugin's generic Client Communication Guardrails rule (in `project-structure-and-scaffolding-plugin/_config/conventions.md`) with Google Ads-specific language and examples.

**Substantiation Before Projection.** Never state a future ROAS target, conversion volume projection, budget-return forecast, or timeline commitment in any client-facing output (report, SUMMARY.md, conversation text, message) that does not appear in a dated strategy document held on file — a spec, report, or plan approved by the client on a recorded date.

If no documented target exists, describe the **data gate** that determines the next decision rather than the expected outcome.

**Prohibited:** "Scaling to 2x budget should produce a 1.4x ROAS."
**Required:** "Budget-lost-IS is 22% on the top five campaigns. If tCPA holds within 15% of target for 30 days after a +20% budget step, the next +20% step is data-supported."

Additional prohibited forms:
- "This account should hit [X] conversions by [month]."
- "At this trajectory, ROAS will reach [X] in Q[Y]."
- "Expect CPA to drop to [X] once Smart Bidding matures."

### Regulatory Basis

- **FTC Advertising Substantiation doctrine** — reasonable basis required before dissemination. `ftc.gov/legal-library/browse/ftc-policy-statement-regarding-advertising-substantiation`
- **UK CAP Code §§ 3.1 / 3.7 / 3.34** — documentary evidence held BEFORE the claim is made. `asa.org.uk/advice-online/substantiation.html`
- **DMCC Act 2024** — backs CAP Code enforcement with material fines.

### Scope

This rule applies to all 15 skills and 3 agents in this plugin. It covers every client-facing output surface: reports, SUMMARY.md, ad copy recommendations, conversation text, and any message intended for or shared with a client.

### Root Cause (for context)

On 2026-04-16 an email was drafted for a client projecting "5x ROAS in June/July." That figure appeared in no strategy document, no spec, and no approved plan. This convention was introduced so no skill or agent can generate that output in the future.
