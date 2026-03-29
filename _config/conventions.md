---
title: Conventions
tags:
  - layer-3
  - reference
---

# Conventions

%% LAYER 3 — STABLE REFERENCE %%
%% Naming, file organisation, and structural rules for this project. %%
%% These persist across every run. They are constraints the agent internalises. %%

## File Naming

%% HOW TO FILL THIS: Define what your output files will be called and how.
   For code: component names, extensions. For documents: slug patterns. For design: export formats. %%

- Documents: `[slug]-[status].md` (e.g. `api-auth-guide-draft.md`)
- Deliverables: `[slug]-v[n].[ext]` (e.g. `onboarding-deck-v2.pptx`)
- Dates in filenames: `YYYY-MM-DD` prefix (e.g. `2026-03-15-newsletter.md`)

**Statuses:** `draft` → `review` → `final`

## Folder Naming

%% HOW TO FILL THIS: These are the rules Claude follows when creating any folder in output/.
   Keep them simple and consistent with your existing project patterns. %%

- Lowercase, hyphen-separated: `my-folder-name`
- Numbered stages: `01-research`, `02-draft`, `03-production`
- No spaces, no underscores (unless MWP stage convention requires `_config/`)

## Output Conventions

%% HOW TO FILL THIS: Clarify exactly what Claude writes to output/ and how it's named.
   The more specific, the less Claude has to guess about output format. %%

- Every stage writes only to its own `output/` folder
- Filenames in `output/` follow: `[descriptor]-[stage-name].md`
- Never overwrite a previous run's output without renaming it first

## Version Control

%% HOW TO FILL THIS: How commits are structured for this project.
   Adapt the commit message format to match your team's existing conventions. %%

- Commit after each stage completes
- Commit message format: `[stage-name]: [brief description of output]`
- Tag final deliverables: `v[major].[minor]`

## Review & Handoff

%% HOW TO FILL THIS: Rules for what happens between stages.
   These are already set by MWP defaults above — add any project-specific exceptions here. %%

- Human reviews `output/` before next stage runs
- Edits to `output/` are valid — the next stage picks up whatever is there
- If a stage is re-run, clear `output/` first (or rename old files with `-archived`)

## Project-Specific Conventions

%% HOW TO FILL THIS: Any convention unique to this project that doesn't fit above.
   Examples: asset naming for a design project, tag naming for GTM, API naming for code. %%

- [Convention specific to this project]
- [Convention specific to this project]
