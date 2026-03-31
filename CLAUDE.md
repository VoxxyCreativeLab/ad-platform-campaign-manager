---
title: "Ad Platform Campaign Manager"
tags:
  - mwp
  - layer-0
---

# Ad Platform Campaign Manager

Campaign management toolkit for a **tracking specialist** (GTM, sGTM, BigQuery) managing client Google Ads accounts. Not a generic marketing tool — bridges tracking infrastructure expertise with campaign operations.

## Who You Are Helping

Jerry is a tracking specialist, not a campaign specialist. He knows GTM containers, sGTM pipelines, BigQuery schemas, and consent mode inside out. He does NOT know campaign strategy, keyword planning, or bid optimization from experience. Teach campaign concepts clearly. Use technical tracking language freely.

## Permanent Rules

- **Google Ads only.** Architecture supports multi-platform (Meta, LinkedIn, TikTok) via `reference/platforms/` but only `google-ads/` is populated. Do not reference other platforms as if they are available.
- **Phase 1 = knowledge & guidance.** No API access. Phase 2 (MCP integration) is blocked until Google Ads API credentials are obtained.
- **Load reference docs selectively.** Skills pull specific files from `reference/` — never dump the entire tree into context. See `CONTEXT.md` for the routing table.
- **tracking-bridge/ is the differentiator.** It documents the full GTM → sGTM → BigQuery → Google Ads conversion pipeline. No generic campaign plugin has this. Prioritize it.
- **Reference files are stable.** Never overwrite `reference/` content during normal skill execution.
- **Rewrite PRIMER.md before session ends.** When the user says "wrap up", "session end", "that's it", or signals they're done — rewrite `PRIMER.md` with current state before they clear.

## Companion Plugins

- **gtm-template-builder-plugin** — for building GTM custom templates (client-side tags)
- **project-structure-and-scaffolding-plugin** — for MWP project scaffolding
- **superpowers** — cross-domain: agentic methodology (brainstorming, TDD, debugging, code review, parallel agents)
- **frontend-design** — cross-domain: production-grade frontend design quality (typography, color, animations, spatial composition)

> [!info] Ecosystem
> See [[_config/ecosystem|_config/ecosystem.md]] for the full list of available plugins, CLIs, and MCPs.

## Root Files

| File | Role |
|------|------|
| `CLAUDE.md` | This file. Permanent identity and rules. Does not change. |
| `CONTEXT.md` | Task routing. Which skill/agent + which reference files to load for a given task. |
| `PRIMER.md` | Living session handoff. Rewrites at end of every session: active work, last completed, next steps, blockers. |
| `MEMORY.sh` | Injects live git context at launch: branch, last 5 commits, modified files. |
| `LESSONS.md` | Campaign management lessons learned. Grows over time. |
| `DESIGN.md` | Architecture decisions and rationale. |
| `CHANGELOG.md` | Versioned change log. |

---

## Folder Structure

```
ad-platform-campaign-manager/
  CLAUDE.md            ← You are here. Global identity.
  CONTEXT.md           ← Task routing. Where to go for what.
  README.md            ← Human-facing project overview
  START-HERE.md        ← Human quick-start guide
  PLAN.md              ← Live project roadmap
  PRIMER.md            ← Session handoff (rewrites each session)
  DESIGN.md            ← Architecture decisions
  LESSONS.md           ← Lessons learned
  CHANGELOG.md         ← Version log
  MEMORY.sh            ← Git context injection
  _config/             ← Layer 3: Stable reference files
  reference/           ← Stage 01: Domain knowledge base (37 files)
  skills/              ← Stage 02: Interactive guidance tools (10 skills)
  agents/              ← Stage 03: Autonomous audit agents (2 agents)
  .claude-plugin/      ← Plugin metadata
```

---

## Quick Navigation

| I want to... | Go here |
|---|---|
| Set up a new campaign | `/ad-platform-campaign-manager:campaign-setup` |
| Plan keywords | `/ad-platform-campaign-manager:keyword-strategy` |
| Set up conversion tracking | `/ad-platform-campaign-manager:conversion-tracking` |
| Build a reporting pipeline | `/ad-platform-campaign-manager:reporting-pipeline` |
| Audit a campaign | `/ad-platform-campaign-manager:campaign-review` |
| Work with PMax | `/ad-platform-campaign-manager:pmax-guide` |
| Optimize budget/bids | `/ad-platform-campaign-manager:budget-optimizer` |
| Browse Ads Scripts | `/ad-platform-campaign-manager:ads-scripts` |
| Understand task routing | [[CONTEXT]] |
| Adjust conventions | [[_config/conventions|_config/conventions.md]] |
| See what's in progress | [[PLAN]] |
