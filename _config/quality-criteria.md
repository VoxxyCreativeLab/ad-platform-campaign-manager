---
title: Quality Criteria
tags:
  - layer-3
  - reference
---

# Quality Criteria

%% LAYER 3 — STABLE REFERENCE %%
%% Defines what "done" means for outputs in this project. %%
%% Claude uses this to self-evaluate before writing to output/. %%
%% Recommended for ALL project types — domain-agnostic by design. %%
%% Fill in all sections. The more specific, the better the output quality. %%

## Definition of Done

%% HOW TO FILL THIS: List the conditions every stage output must meet before it is considered complete.
   Think: completeness (all required sections filled), accuracy (factually correct), format (matches style-guide),
   and fitness (does it actually achieve the stage's goal). Use a checklist — Claude checks each item. %%

A stage output is "done" when:
- [ ] All required sections are populated with real content (no placeholder brackets remaining)
- [ ] Output matches the format defined in [[style-guide]] (if used in this project)
- [ ] No factual claims are made without a source or basis noted
- [ ] [Domain-specific condition — e.g. "All GTM tags call gtmOnSuccess/gtmOnFailure" / "All code passes linting" / "Word count is within target range"]
- [ ] [Add further conditions as needed]

## Quality Signals (What Good Looks Like)

%% HOW TO FILL THIS: Give 2-3 concrete examples of high-quality output for THIS project.
   This is the most powerful section — a real example calibrates Claude better than any rule.
   Example: "A good research summary for this project has a clear thesis, 3 supporting points with sources, and ends with a recommendation." %%

- [Quality signal 1 — describe what a strong output looks like for this project]
- [Quality signal 2]
- [Quality signal 3 — optional, add more if needed]

## Rejection Criteria (What Gets Sent Back)

%% HOW TO FILL THIS: Name the failure modes specific to your project.
   What would make you reject an output and ask for a redo? Be honest and direct.
   Example: "Output sent back if it reads like a template, uses passive voice throughout, or doesn't answer the brief." %%

Output is not acceptable and must be revised if:
- [ ] It contains unfilled placeholder text (`[brackets]` or generic filler)
- [ ] It does not address the input from the previous stage
- [ ] [Domain-specific rejection — e.g. "GTM tag does not fire in preview mode" / "Design uses colors outside the design tokens" / "Copy is over the word limit"]
- [ ] [Add further rejection criteria as needed]

## Stage-Specific Overrides

%% HOW TO FILL THIS: If a particular stage has stricter or different quality criteria than the defaults above,
   document them here. Leave the table empty if all stages share the same standards. %%

| Stage | Additional or overriding criteria |
|---|---|
| [stage-name] | [e.g. "Must include a summary table at the top"] |
| [stage-name] | [e.g. "Must be under 300 words — this is a brief, not a full document"] |
