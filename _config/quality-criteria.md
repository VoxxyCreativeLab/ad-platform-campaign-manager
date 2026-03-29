---
title: Quality Criteria
tags:
  - layer-3
  - reference
---

# Quality Criteria

%% LAYER 3 — STABLE REFERENCE %%
%% Defines what "done" means for outputs in this project. %%
%% Stage-specific criteria: reference = accuracy, skills = actionability, agents = coverage. %%

---

## Definition of Done (General)

A stage output is "done" when:
- [ ] All required sections are populated with real content (no placeholder brackets remaining)
- [ ] Sources cited for factual claims (Google Ads documentation, tracking architecture docs)
- [ ] Obsidian-flavored markdown used (YAML frontmatter, wikilinks, callouts)
- [ ] Cross-references to related files are present where relevant
- [ ] Content has been reviewed for accuracy against current Google Ads behavior

---

## Stage-Specific Quality Criteria

### Stage 01 — Reference (Accuracy & Completeness)

A reference file meets quality when:
- [ ] Factually accurate against current Google Ads documentation
- [ ] Covers common scenarios, not just the happy path (includes edge cases, gotchas)
- [ ] Includes decision trees or comparison tables where multiple options exist
- [ ] Cross-references related reference files via `[[wikilinks]]`
- [ ] Structured for selective loading — a skill should be able to load this file without pulling in the entire topic

> [!tip] Quality signal
> A good reference file lets someone unfamiliar with the topic make the right choice by following its decision tree, without needing to read Google's own documentation.

### Stage 02 — Skills (Clarity & Actionability)

A skill's output meets quality when:
- [ ] Walks the user through steps in logical order (no jumping between topics)
- [ ] Teaches campaign concepts while building — the user is not a campaign expert
- [ ] Loads only the reference files needed for the specific task (selective, not exhaustive)
- [ ] Produces output the user can directly use in the Google Ads interface (copy-paste ready)
- [ ] Ad copy follows Google Ads specs: character limits respected, no repetition, sentence case
- [ ] Keyword recommendations include match type rationale, not just a list of keywords
- [ ] Recommendations are tailored to the user's specific campaign, client, and budget — not generic

> [!tip] Quality signal
> A good skill output can be taken directly into the Google Ads interface and implemented without modification. Campaign plans include exact ad copy, keyword lists with match types, and bid strategy recommendations with reasoning.

### Stage 03 — Agents (Coverage & Scoring)

An agent's output meets quality when:
- [ ] Covers all relevant checklist items from the reference audit docs
- [ ] Every finding has a severity tag: `Critical`, `Warning`, or `Info`
- [ ] Produces a clear score (X/Y passing) so progress is measurable
- [ ] Action plan is prioritized — critical items first, quick wins highlighted
- [ ] Clear pass/fail per check item (no ambiguous "partially met")
- [ ] Tracking auditor checks every layer (Google Ads → GTM → sGTM → BigQuery)

> [!tip] Quality signal
> A good audit report lets the user fix the most impactful issues first. It distinguishes "this is costing you money" (Critical) from "this could be better" (Info).

---

## Rejection Criteria (What Gets Sent Back)

Output is not acceptable and must be revised if:
- [ ] It reads like a generic template (not tailored to the user's specific campaign or client)
- [ ] Ad copy exceeds character limits or contains repetitive headlines
- [ ] Recommendations contradict best practices documented in `reference/`
- [ ] Audit report misses items from `reference/platforms/google-ads/audit/audit-checklist.md`
- [ ] Keyword lists lack match type rationale (just keywords without strategy)
- [ ] Tracking audit skips layers or does not quantify data discrepancies
- [ ] Output contains placeholder text or unfilled brackets

---

## Quality Signals (What Good Looks Like)

- Campaign plan is copy-paste ready for the Google Ads interface
- Keyword lists include match type rationale and negative keyword recommendations
- Audit reports distinguish "critical" (costing money) from "nice-to-have" (optimization opportunity)
- Tracking audits include a per-layer data discrepancy table with actual numbers
- Ad copy has variety: different angles, CTAs, value propositions across headlines
- Budget recommendations include specific numbers and formulas, not just "increase budget"
