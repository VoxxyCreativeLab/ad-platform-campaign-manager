---
title: Primer - Session Handoff
date: 2026-04-17
tags:
  - mwp
---

# Primer - Session Handoff

> This file rewrites itself at the end of every session. Read it first.
> **To resume:** say "continue" — the system will read this file and PLAN.md and pick up from the first unchecked item in "What Still Needs to Happen."

---

## Active Project

**ad-platform-campaign-manager** — currently at v1.24.0 (in development, feature/ad-campaign-war-council branch). Active skill: `/ad-campaign-war-council` — Strategic orchestrator — evidence-based options, rule-override adjudication, growth blueprinting, forward planning.

---

## Last Completed

### v1.23.0 — Account Scaling Skill + Projection Guardrail (2026-04-17)

All tasks completed and committed:

| Task | Description | Commit |
|---|---|---|
| Pre-flight | n8n routing edges (5 files) as standalone prep commit | `46e22ee` |
| Layer 1 guardrail | One-liner in `~/.claude/CLAUDE.md` (no git — outside all repos) | — |
| Layer 2 guardrail | Generic rule in `project-structure-and-scaffolding-plugin/_config/conventions.md` | `856304d` (PSP repo) |
| Layer 3 guardrail | Domain-specific rule in `_config/conventions.md` (FTC + UK CAP + DMCC) | `9ce1c9f` |
| account-maturity-roadmap | tROAS discrepancy footnote + Stage 3/4 scaling-playbook links | `904f146` |
| bidding-strategies | PMax/Shopping Ad Rank callout (Oct 2024) | `21d67e2` |
| scaling-playbook.md | New reference file (11 sections, 245 lines) | `969aafa` |
| account-scaling SKILL.md | New skill (4-phase flow, 7 GAQL queries, 8 gates, T1-T6 routing, report template) | `dd3dddc` |
| CONTEXT.md + CLAUDE.md | Routing row + Quick Navigation wired | `4f1209d` |
| BACKLOG + CHANGELOG | #23 + #28 + #31 closed, v1.23.0 entry added | (release commit) |

**Deliverables:**
- `/ad-platform-campaign-manager:account-scaling` — live, installable after plugin reinstall
- `reference/platforms/google-ads/strategy/scaling-playbook.md` — live
- 3-layer projection guardrail active across all 15 skills + 3 agents

### Previous Milestones

- v1.22.0 — BigQuery native connectors, Klaviyo fundamentals, Looker Studio dashboard
- v1.21.1 — Feed-only PMax AD STRENGTH = POOR exception + Shopping regression routing
- v1.21.0 Session 4 — PAUSED (n8n-plugin must be built first)

---

## What Still Needs to Happen

> [!info] Plugin reinstall required
> v1.24.0 adds a new skill (`ad-campaign-war-council`) and 7 new agents. Run the plugin reinstall before using them:
> 1. `/plugins uninstall ad-platform-campaign-manager`
> 2. `/plugins install`
> 3. Reload VSCode window (Ctrl+Shift+P → "Developer: Reload Window")
> 4. Confirm `/ad-platform-campaign-manager:ad-campaign-war-council` appears in skill list

No active implementation plan. Deferred backlog items listed below — pick the next one to work on.

---

## Deferred Backlog Items

| # | Item | Size | Notes |
|---|---|---|---|
| 24 | tROAS/tCPA transition gates in post-launch-monitor | S | Add "Bid Strategy Readiness" section at Day 14/21 checkpoints |
| 26 | `all_conversions` in live-report + attribution interpretation | S-M | Shopping + PMax multi-touch attribution; 58x delta confirmed in Vaxteronline |
| 29 | MCP docs fix — user_list sizes are API-accessible | S | Remove from "Not Available via MCP" section; add confirmed GAQL |
| 30 | MCP server capability expansion validation | After update | Wait for Jerry's MCP server update to ship before running |

---

## Open Blockers

| Blocker | Notes |
|---|---|
| **OAuth client secret rotation** | Exposed in session screenshot 2026-04-01. Rotate in GCP Console before production use |
| **MCP server update in progress** | Jerry adding read capabilities + bug fixes. After update: run BACKLOG #30 validation |
| **n8n-plugin build** | Prerequisite for v1.21.0 Sessions 4-5 — now built (`n8n-workflow-builder-plugin` v0.1.0 operational) |
| **Watermelon plan path** | Jerry to provide (for #18 extraction) |
| **GTM scripts inventory** | Jerry to provide (for #17 cookie cHTML review) |
| **ClickFunnels 2.0 (#21)** | Deferred; CF2.0 event names unverifiable; re-scope when CF2.0 is live |

---

## MCP Server Reference

| Item | Value |
|---|---|
| Connected to | MCC 7244069584 (Voxxy Creative Lab) via Explorer Access (2,880 ops/day) |
| Write passphrase | `voxxy-writes` |
| Credentials | `C:\Users\VCL1\google-ads.yaml` |
| Wrapper | `C:\mcp\google-ads.cmd` |
| Status | Update in progress (Jerry adding read capabilities) |

---

## N8n Items — Now Unblocked

The `n8n-workflow-builder-plugin` is fully built and operational (v0.1.0). Cross-plugin routing from ad-platform → n8n-plugin is wired in 5 skill files (commit `46e22ee`).

Sessions 4 and 5 of v1.21.0 remain paused — they require the plugin to be operational for workflow-building work. Now that the prerequisite is met, these can be scheduled.

**Blocked items now unblocked in principle:** #10 iClosed tracking, #11 Meta BQ pipeline, #12 n8n automation layer, #13 cross-platform data model, and n8n reverse path of #14.

**Pause memo:** `docs/superpowers/plans/2026-04-16-session-4-paused.md`
