---
title: Report Output Structure Design
date: 2026-04-04
tags: [design, spec, report-output, completeness-convention, master-plugin]
status: approved
version: 1.0.0
---

# Report Output Structure Design

## Problem Statement

Two problems drive this design:

1. **Output volume**: Skills produce 100+ pages of conversational output. This overwhelms context windows, makes manual review impractical, and wastes tokens when agents need the information later. All information is still needed, but it must be structured into files rather than dumped into conversation.

2. **Output truncation**: When producing long output, the AI shortcuts with "etc.", "...", or "similar to above". Campaign deliverables must be fully deterministic. If a skill says "8 asset groups with 5 attributes," all 40 attribute values must be written. No exceptions.

## Approach

**Coordinated update** across both plugins:

- **ad-platform-campaign-manager**: All 14 report-producing skills/agents write output to files inside MWP client projects. A completeness convention enforces deterministic output.
- **project-structure-and-scaffolding-plugin**: Small additive changes to recognize `reports/` as a valid output directory for domain plugins.

---

## Section 1: Report Directory Structure

When a skill runs inside an MWP client project, it writes output to:

```
{project-root}/
  reports/
    {YYYY-MM-DD}/
      CONTEXT.md              <- technical index (for the specialist)
      SUMMARY.md              <- client-facing summary (auto-built)
      01-audit/
        campaign-review.md
        campaign-cleanup.md
        live-report.md
        campaign-reviewer.md   (agent)
        tracking-auditor.md    (agent)
      02-plan/
        account-strategy.md
        keyword-strategy.md
        budget-optimizer.md
        strategy-advisor.md    (agent)
      03-build/
        campaign-setup.md
        pmax-guide.md
        ads-scripts.md
      04-launch/
        conversion-tracking.md
      05-optimize/
        reporting-pipeline.md
```

### Rules

- `reports/` is created by the master plugin's scaffold-project (for ad-platform domain) or by the first skill that runs.
- `{YYYY-MM-DD}/` folder is created on first skill invocation of the day. If it already exists (second skill same day), the skill adds its file to it.
- Stage sub-folders are created on-demand. If you only run audit skills today, only `01-audit/` exists.
- `CONTEXT.md` is created with the first file and updated by each subsequent skill.
- `SUMMARY.md` is created with the first file and updated by each subsequent skill.
- Each skill writes exactly one `.md` file per invocation.
- Agents follow the same pattern.
- 11 skills write to files. Only `connect-mcp` stays conversational-only (it is a setup wizard, not a report).
- 3 agents write to files.
- Interactive skills (pmax-guide, campaign-setup): Q&A happens in conversation, final deliverable goes to file.

---

## Section 2: CONTEXT.md Specification

CONTEXT.md is the technical index for the specialist. It is created with the first report file and updated by each subsequent skill.

### Template

```markdown
---
title: Campaign Report - {Client Name}
date: {YYYY-MM-DD}
account: {Client Name} ({Account ID})
tags: [report, google-ads]
---

## Report Overview

| File | Stage | Skill | Summary |
|------|-------|-------|---------|
| [[01-audit/campaign-review]] | 01-audit | campaign-review | {One-line summary of key findings} |
| [[02-plan/account-strategy]] | 02-plan | account-strategy | {One-line summary of strategy profile} |

## What Was Not Run

Skills not invoked this session: {comma-separated list of skills that were not run}

## Reading Order

Read files in stage order (01 -> 05) for the full picture.
Start with 01-audit if triaging. Start with 02-plan if building new.
```

### Rules

- Obsidian frontmatter with client, date, tags
- Wikilinks to each file
- One-line summary per file describes what the skill found, not just "ran campaign review"
- "What Was Not Run" section tracks completeness. Each skill removes itself from this list when it writes.
- Reading order guidance for how to consume the report

---

## Section 3: SUMMARY.md Specification

SUMMARY.md is the client-facing document. It auto-builds as skills run. Each skill appends a non-technical paragraph as part of its write step.

### Template

```markdown
---
title: Campaign Report - {Client Name}
date: {YYYY-MM-DD}
account: {Client Name} ({Account ID})
type: client-summary
tags: [report, client, google-ads]
---

## Account Health

{Appended by campaign-review / campaign-cleanup / live-report / campaign-reviewer agent}

## Strategy & Planning

{Appended by account-strategy / keyword-strategy / budget-optimizer / strategy-advisor agent}

## Campaign Build

{Appended by campaign-setup / pmax-guide / ads-scripts}

## Tracking & Launch

{Appended by conversion-tracking / tracking-auditor agent}

## Optimization & Reporting

{Appended by reporting-pipeline}
```

### Rules

- Sections map to stages: 01-audit = Account Health, 02-plan = Strategy & Planning, 03-build = Campaign Build, 04-launch = Tracking & Launch, 05-optimize = Optimization & Reporting.
- Exception: `tracking-auditor` agent lives in `01-audit/` physically but its SUMMARY.md paragraph goes to "Tracking & Launch" because clients care about tracking status.
- Each skill appends its paragraph to the appropriate section.
- If a section has no content (no skills ran for that stage), the section is omitted entirely.
- Language is non-technical: "We found 3 issues affecting your ad spend" not "QS = 4.2, CTR below 2% threshold."
- Numbers and quantities always included: "142 keywords", "8 asset groups", "2,500 EUR per month."
- No implementation detail: client knows WHAT and HOW MANY, not HOW.
- Typical length per skill: 3-5 lines. Additional lines permitted when strictly necessary for completeness. No arbitrary padding, no artificial truncation.
- No em-dashes in SUMMARY.md. Use hyphens or restructure the sentence.

---

## Section 4: Skill File-Writing Behavior

Every report-producing skill follows this 6-step sequence when writing output:

### Step 1: Detect MWP project

- Check if CWD has `stages/` directory or `reports/` directory.
- If yes: MWP project detected, proceed with file writing.
- If no: fall back to conversational output (legacy behavior, nothing breaks).

### Step 2: Ensure directory structure

- Create `reports/{YYYY-MM-DD}/` if it does not exist.
- Create `reports/{YYYY-MM-DD}/{stage}/` for this skill's stage.
- Use today's date from system.

### Step 3: Write the technical report

- Write full output to `reports/{YYYY-MM-DD}/{stage}/{skill-name}.md`.
- Full deterministic content following the Output Completeness Convention.
- Obsidian frontmatter template for each report file:

```markdown
---
title: {Skill Display Name} - {Client Name}
date: {YYYY-MM-DD}
skill: {skill-name}
stage: {stage}
account: {Client Name} ({Account ID})
tags: [report, google-ads, {stage}, {skill-name}]
---
```

### Step 4: Update CONTEXT.md

- If `CONTEXT.md` does not exist: create it with frontmatter, report overview table, and first entry.
- If it exists: append this skill's row to the overview table.
- Update "What Was Not Run" section (remove this skill from the list).

### Step 5: Update SUMMARY.md

- If `SUMMARY.md` does not exist: create it with frontmatter and section headers.
- Append this skill's client-facing paragraph to the appropriate stage section.

### Step 6: Conversation summary

- Show 5-10 line summary in conversation: key findings plus file path.
- Example: "Audit complete - 3 critical issues, 5 warnings. Full report: `reports/2026-04-04/01-audit/campaign-review.md`"

### Conversational-only exceptions

- `connect-mcp`: setup wizard, no report output.
- All interactive Q&A within any skill: questions happen in conversation, only the final deliverable goes to file.

---

## Section 5: Output Completeness Convention

A hard rule added to the ad-platform plugin's `_config/conventions.md`. This is the fix for Problem 2.

### The Rule

All skill output written to report files MUST be fully specified and deterministic.

### Prohibited Patterns

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

- If a single file would exceed approximately 500 lines, split into sub-files within the same stage folder.
- Example: `02-plan/keyword-strategy-brand.md`, `02-plan/keyword-strategy-competitor.md`.
- CONTEXT.md reflects all sub-files.

### Where This Rule Lives

- Primary definition: `_config/conventions.md` in the ad-platform plugin.
- Reinforcement: each skill's SKILL.md gets a one-line reference: "Follow the Output Completeness Convention. No truncation, no shortcuts."
- This is a hard rule, not a suggestion.

---

## Section 6: Master Plugin Changes

Three small, additive changes to `project-structure-and-scaffolding-plugin`:

### Change 1: domain-classification.md

Add an `Output Pattern` column to the classification table.

For ad-platform:

| Domain | Stages | Layer 3 Stubs | Output Pattern | Companion Plugin |
|--------|--------|---------------|----------------|------------------|
| Google Ads / PPC / campaign management | `01-audit`, `02-plan`, `03-build`, `04-launch`, `05-optimize` | `conventions`, `quality-criteria` | `reports/{date}/{stage}/` | `ad-platform-campaign-manager` |

Other domains retain `stages/{stage}/output/` as the default output pattern. They can adopt the `reports/` pattern later if their companion plugins produce dated reports.

### Change 2: scaffold-project skill

When scaffolding a project whose domain has `reports/{date}/{stage}/` as output pattern:

- Create `reports/.gitkeep` at project root.
- Add a note in the generated CLAUDE.md: "Reports are written to `reports/{YYYY-MM-DD}/` by companion plugin skills. See CONTEXT.md inside each date folder for the index."

### Change 3: structure-reviewer agent

Add `reports/` to the list of recognized directories so it does not flag it as unexpected structure. Accept `reports/{date}/{stage}/*.md` as valid.

### What Does NOT Change

- The 5 stages themselves stay the same.
- `stages/` directory and its `output/` dirs stay untouched.
- No other domain classifications change.
- Convention and quality-criteria stubs stay the same.

---

## Section 7: Complete Skill/Agent-to-File Mapping

| Skill/Agent | Stage | Output File | SUMMARY.md Section |
|---|---|---|---|
| `campaign-review` | `01-audit` | `campaign-review.md` | Account Health |
| `campaign-cleanup` | `01-audit` | `campaign-cleanup.md` | Account Health |
| `live-report` | `01-audit` | `live-report.md` | Account Health |
| `campaign-reviewer` (agent) | `01-audit` | `campaign-reviewer.md` | Account Health |
| `tracking-auditor` (agent) | `01-audit` | `tracking-auditor.md` | Tracking & Launch |
| `account-strategy` | `02-plan` | `account-strategy.md` | Strategy & Planning |
| `keyword-strategy` | `02-plan` | `keyword-strategy.md` | Strategy & Planning |
| `budget-optimizer` | `02-plan` | `budget-optimizer.md` | Strategy & Planning |
| `strategy-advisor` (agent) | `02-plan` | `strategy-advisor.md` | Strategy & Planning |
| `campaign-setup` | `03-build` | `campaign-setup.md` | Campaign Build |
| `pmax-guide` | `03-build` | `pmax-guide.md` | Campaign Build |
| `ads-scripts` | `03-build` | `ads-scripts.md` | Campaign Build |
| `conversion-tracking` | `04-launch` | `conversion-tracking.md` | Tracking & Launch |
| `reporting-pipeline` | `05-optimize` | `reporting-pipeline.md` | Optimization & Reporting |
| `connect-mcp` | - | - (conversational only) | - |

---

## Section 8: Future Enhancements (Backlog)

These are noted for future work, not part of this implementation:

| Enhancement | Description | When |
|---|---|---|
| Build agent | Autonomous agent that reads 02-plan output and generates campaign specs for 03-build | After validating the report structure with real clients |
| Launch validator agent | Validates tracking setup plus campaign config before go-live | After build agent |
| Optimization agent | Reads performance data over time, suggests bid/budget adjustments | After real optimization cycles |
| Finalize-report skill | Reads all files in a date folder, generates executive summary, validates completeness | If auto-build SUMMARY.md proves insufficient |
| Cross-date comparison | Diff two date folders to show week-over-week changes | After accumulating 3+ reports per client |
| Multi-platform support | Meta Ads, LinkedIn Ads, TikTok Ads skills writing to the same report structure | Phase 4 (already on roadmap) |
