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

14 invocable skills, each in its own folder with a `SKILL.md` file. 11 are profile-aware (ask account profiling questions). Phase 1 (11 skills) requires no API. Phase 2 (3 skills) requires MCP connection.

## Conventions

- `SKILL.md` has YAML frontmatter: `name`, `description`, `disable-model-invocation`, optional `argument-hint`
- Wizard skills (`disable-model-invocation: true`) walk the user through steps interactively
- Reference skills (`disable-model-invocation: false`) respond to questions using loaded reference material
- Skills load from `../reference/` on demand — they do NOT contain duplicate domain knowledge

## Skill Dependencies on Reference Files

Each skill loads specific reference files. This map prevents loading unnecessary material:

```
account-strategy ────→ strategy/*, campaign-types, bidding-strategies
campaign-setup ──────→ campaign-types, account-structure, match-types,
                       bidding-strategies, ad-extensions, pmax/* (if PMax),
                       strategy/account-profiles
keyword-strategy ────→ match-types, negative-keyword-lists, account-structure,
                       strategy/account-profiles, strategy/remarketing-strategies
conversion-tracking ─→ conversion-actions, enhanced-conversions, tracking-bridge/*,
                       strategy/account-profiles, strategy/attribution-guide
reporting-pipeline ──→ reporting/*, gaql-reference, strategy/account-profiles
campaign-review ─────→ audit/*, quality-score, bidding-strategies,
                       strategy/account-profiles
pmax-guide ──────────→ pmax/*, bidding-strategies, shopping-campaigns,
                       strategy/account-profiles
budget-optimizer ────→ bidding-strategies, campaign-types, account-structure,
                       audit/common-mistakes, strategy/account-profiles,
                       strategy/account-maturity-roadmap, strategy/seasonal-planning,
                       strategy/bid-adjustment-framework
ads-scripts ─────────→ scripts/catalog, ads-scripts-api,
                       strategy/account-profiles
campaign-cleanup ────→ audit/*, common-mistakes, negative-keyword-lists,
                       account-structure, strategy/account-profiles
connect-mcp ─────────→ mcp/*
ad-copy ─────────────→ ad-copy-framework, ad-testing-framework, ad-extensions,
                       pmax/asset-requirements, shopping-feed-strategy,
                       strategy/account-profiles
live-report ─────────→ reporting/gaql-query-templates, gaql-reference
post-launch-monitor ─→ learning-phase, strategy/post-launch-playbook,
                       bidding-strategies, strategy/account-maturity-roadmap,
                       mcp/mcp-capabilities
```

## Inter-Skill References

Skills may recommend other skills to the user:

- `account-strategy` → routes to `campaign-setup`, `keyword-strategy`, `conversion-tracking`, `campaign-cleanup`, `budget-optimizer`, `pmax-guide`, `reporting-pipeline`, `campaign-review` based on profile gaps
- `campaign-setup` → recommends `keyword-strategy`, `conversion-tracking`, `budget-optimizer`, `campaign-cleanup`, `ad-copy`, `post-launch-monitor` (monitoring after launch)
- `campaign-review` → recommends `conversion-tracking`, `budget-optimizer`, `campaign-cleanup`, `pmax-guide`, `keyword-strategy`, `account-strategy`
- `campaign-cleanup` → recommends `conversion-tracking`, `campaign-setup`, `keyword-strategy`, `budget-optimizer`, `campaign-review`
- `conversion-tracking` → recommends `campaign-setup`, `campaign-review`, `budget-optimizer`, `reporting-pipeline`, `account-strategy`
- `pmax-guide` → recommends `conversion-tracking`, `live-report`, `budget-optimizer`, `campaign-cleanup`, `account-strategy`
- `reporting-pipeline` → recommends `ads-scripts`, `live-report`, `conversion-tracking`, `budget-optimizer`, `account-strategy`
- `ads-scripts` → recommends `reporting-pipeline`, `budget-optimizer`, `live-report`, `account-strategy`
- `keyword-strategy` → recommends `campaign-setup`, `budget-optimizer`, `campaign-review`
- `ad-copy` → recommends `campaign-setup`, `keyword-strategy`, `budget-optimizer`, `campaign-review`, `pmax-guide`, `live-report`
- `budget-optimizer` → recommends `campaign-review`, `campaign-cleanup`, `conversion-tracking`
- `live-report` → requires `connect-mcp` for MCP setup
- `reporting-pipeline` → complements `live-report` (design vs live data)
