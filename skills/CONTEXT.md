---
title: "Stage 02 — Skills"
tags:
  - mwp
  - layer-2
  - stage
---

%% STAGE 02 — SKILLS (Interactive Guidance Tools) %%
%% Output from this stage lives in this folder's subdirectories. Each skill is a self-contained SKILL.md. %%

# Skills — Context

10 invocable skills, each in its own folder with a `SKILL.md` file. Phase 1 (8 skills) requires no API. Phase 2 (2 skills) requires MCP connection.

## Conventions

- `SKILL.md` has YAML frontmatter: `name`, `description`, `disable-model-invocation`, optional `argument-hint`
- Wizard skills (`disable-model-invocation: true`) walk the user through steps interactively
- Reference skills (`disable-model-invocation: false`) respond to questions using loaded reference material
- Skills load from `../reference/` on demand — they do NOT contain duplicate domain knowledge

## Skill Dependencies on Reference Files

Each skill loads specific reference files. This map prevents loading unnecessary material:

```
campaign-setup ──────→ campaign-types, account-structure, match-types,
                       bidding-strategies, ad-extensions, pmax/* (if PMax)
keyword-strategy ────→ match-types, negative-keyword-lists
conversion-tracking ─→ conversion-actions, enhanced-conversions, tracking-bridge/*
reporting-pipeline ──→ reporting/*, gaql-reference
campaign-review ─────→ audit/*, quality-score, bidding-strategies
pmax-guide ──────────→ pmax/*, bidding-strategies
budget-optimizer ────→ bidding-strategies, campaign-types
ads-scripts ─────────→ scripts/catalog, ads-scripts-api
connect-mcp ─────────→ mcp/*
live-report ─────────→ reporting/gaql-query-templates, gaql-reference
```

## Inter-Skill References

Skills may recommend other skills to the user:

- `campaign-setup` → recommends `conversion-tracking` for tracking setup
- `campaign-review` → recommends `conversion-tracking` if tracking is missing
- `pmax-guide` → recommends `conversion-tracking` for PMax conversion requirements
- `live-report` → requires `connect-mcp` for MCP setup
- `reporting-pipeline` → complements `live-report` (design vs live data)
