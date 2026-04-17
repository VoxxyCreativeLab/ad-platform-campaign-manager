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

**ad-platform-campaign-manager** v1.23.0 — Account Scaling Skill + Projection Guardrail (BACKLOG #23 + #28).

**Phase:** Implementation. Design complete. Plan written. Ready to execute via subagent-driven-development.

---

## Last Completed

### v1.23.0 Design + Planning Phase (2026-04-17)

All brainstorming sections approved and committed:

- **Section 1:** Architecture — skill positioning ladder, MCP + always-report + projection gate, Stage 3/4 entry criteria, strategy-advisor boundary ✅
- **Section 2:** Skill logic — 4 phases (MCP pull → 8 gates → T1-T6 trajectories → report write), CoV computation from daily data, gate delegation map ✅
- **Section 3:** Projection guardrail — 3-layer design (global + master plugin + ad-platform), full rule text, FTC + UK CAP §§3.1/3.7/3.34 + DMCC Act 2024, scope all 15 skills + 3 agents, ships in v1.23.0 ✅
- **Section 4:** `scaling-playbook.md` structure — 11 sections, honest gap statement, 10 curated external playbooks, 10 Google URLs, T1-T6 backbone ✅
- **CONTEXT.md routing row phrasing:** confirmed "Account scaling / ready to scale / grow this account / scale up budget" ✅
- **T1-T6 trajectories:** frozen ✅

Design artifacts:
- Spec: `docs/superpowers/specs/2026-04-17-account-scaling-design.md` (committed `0ac05d8`)
- Plan: `docs/superpowers/plans/2026-04-17-account-scaling.md` (written, not yet committed)

### Previous Milestones

- v1.22.0 — BigQuery native connectors, Klaviyo fundamentals, Looker Studio dashboard
- v1.21.1 — Feed-only PMax AD STRENGTH = POOR exception + Shopping regression routing
- v1.21.0 Session 4 — PAUSED (n8n-plugin must be built first)

---

## What Still Needs to Happen

### v1.23.0 Implementation

> [!warning] Pre-flight first — do not skip
> Before executing ANY task in the plan, resolve the uncommitted n8n routing changes (see "Pre-flight" below). Ask Jerry which option (a/b/c) before touching any skills/ files.

> [!info] Execution approach
> Use `superpowers:subagent-driven-development` to execute the plan task by task.

**Implementation plan:** `docs/superpowers/plans/2026-04-17-account-scaling.md`

#### Mandatory first step

- [ ] **Pre-flight:** Resolve uncommitted n8n routing changes (see Pre-flight section below). Ask Jerry: revert (a), separate commit (b), or bundle (c)?

#### Guardrail (3 layers)

- [ ] **Task 1:** Update `~/.claude/CLAUDE.md` — add one-line projection guardrail under new `## Client Communication` heading
- [ ] **Task 2:** Update `project-structure-and-scaffolding-plugin/_config/conventions.md` — add generic `## Client Communication Guardrails` section
- [ ] **Task 3:** Update `_config/conventions.md` — add domain-specific `## Client Communication Guardrails` section

#### Reference updates

- [ ] **Task 4:** Update `reference/platforms/google-ads/strategy/account-maturity-roadmap.md` — tROAS discrepancy footnote + scaling-playbook links at Stage 3/4
- [ ] **Task 5:** Update `reference/platforms/google-ads/bidding-strategies.md` — PMax/Shopping Ad Rank callout (Oct 2024)

#### New files

- [ ] **Task 6:** Create `reference/platforms/google-ads/strategy/scaling-playbook.md` (11 sections)
- [ ] **Task 7:** Create `skills/account-scaling/SKILL.md` (4-phase flow, 7 GAQL queries, 8 gates, T1-T6 routing, report template)

#### Wiring

- [ ] **Task 8:** Update `CONTEXT.md` (routing row) + `CLAUDE.md` (Quick Navigation)

#### Release

- [ ] **Task 9:** Update `BACKLOG.md` (#23+#28 done) + `CHANGELOG.md` (v1.23.0 entry) + commit + tag `v1.23.0` + plugin reinstall + rewrite this PRIMER.md

---

## Pre-flight: Uncommitted n8n Routing Changes

Git status shows 5 modified files with n8n routing entries that were added before v1.23.0 brainstorming:

| File | Change |
|---|---|
| `skills/CONTEXT.md` | Cross-plugin routing table pointing to `n8n-workflow-builder-plugin:*` |
| `skills/ads-scripts/SKILL.md` | +1 row: "Migrate scripts to n8n workflows" → `n8n-workflow-builder-plugin:workflow-architect` |
| `skills/conversion-tracking/SKILL.md` | +1 row: similar n8n routing |
| `skills/live-report/SKILL.md` | +1 row: similar n8n routing |
| `skills/reporting-pipeline/SKILL.md` | +1 row: similar n8n routing |

The `n8n-workflow-builder-plugin` does not exist yet — it is listed as a prerequisite for v1.21.0 Sessions 4-5 (currently blocked). Options:

- **(a) Revert** — the plugin doesn't exist; these rows are premature
  ```bash
  git checkout skills/CONTEXT.md skills/ads-scripts/SKILL.md skills/conversion-tracking/SKILL.md skills/live-report/SKILL.md skills/reporting-pipeline/SKILL.md
  ```
- **(b) Commit separately** before v1.23.0 work (e.g., `chore: add n8n routing stubs (pre-v1.23.0)`)
- **(c) Bundle** with v1.23.0 only if n8n plugin is imminent

**Do not decide unilaterally. Ask Jerry at the start of the next session.**

---

## Key Decisions Made (v1.23.0)

| Decision | Detail |
|---|---|
| Skill name | `account-scaling` |
| Entry criteria | Stage 3+ (30+ conv/mo); Stage 1/2 → exit message, no report |
| MCP mode | Read-only; `unlock_writes` never called |
| Always-report stage | `05-optimize/account-scaling.md` |
| Gate count | 8 gates; all must pass for scaling trajectory |
| Gate 3 (CoV) computation | Daily data from MCP; ±20% CoV = PASS; skill is the only place this is computed |
| tROAS threshold | Both 50 (roadmap) and 15 (Google portfolio docs) cited; neither hardcoded; user confirms |
| T1-T6 trajectories | 6 trajectories, priority T5→T2→T1→T3/T4/T6; multiple can be active simultaneously |
| T1+T2 conflict | Graduate bid strategy (T2) first; budget step (T1) waits until learning exits |
| +20% budget rule | Search-specific (IS-led); Display has separate rule; NOT universal |
| Projection guardrail scope | All 15 skills + 3 agents; all client-facing output surfaces |
| Guardrail layers | 3: global ~/.claude/CLAUDE.md + master plugin + ad-platform _config/conventions.md |
| Guardrail ships in | v1.23.0 (all 3 layers together) |
| CONTEXT.md routing trigger | "Account scaling / ready to scale / grow this account / scale up budget" |
| Dynamic scaling limitation | Reproduced verbatim in spec, SKILL.md, and scaling-playbook.md |

---

## Implementation Plan Quick Reference

Full plan at `docs/superpowers/plans/2026-04-17-account-scaling.md`.

**New files:**
1. `skills/account-scaling/SKILL.md` — skill
2. `reference/platforms/google-ads/strategy/scaling-playbook.md` — reference

**Modified files (ad-platform):**
- `_config/conventions.md` — Client Communication Guardrails (Layer 3)
- `CONTEXT.md` — routing row
- `CLAUDE.md` — Quick Navigation
- `reference/platforms/google-ads/strategy/account-maturity-roadmap.md` — tROAS footnote + links
- `reference/platforms/google-ads/bidding-strategies.md` — Ad Rank callout
- `BACKLOG.md` — #23 + #28 done
- `CHANGELOG.md` — v1.23.0 entry
- `PRIMER.md` — this file (rewrite at end)

**Modified files (other repos):**
- `project-structure-and-scaffolding-plugin/_config/conventions.md` — Layer 2 generic rule
- `~/.claude/CLAUDE.md` — Layer 1 one-liner

---

## Deferred Backlog Items (after v1.23.0)

| # | Item | Size |
|---|---|---|
| 24 | tROAS/tCPA transition gates in post-launch-monitor | S |
| 26 | `all_conversions` in live-report + attribution interpretation | S-M |
| 29 | MCP docs fix — user_list sizes are API-accessible | S |
| 30 | MCP server capability expansion validation (after MCP update ships) | After update |

---

## Open Blockers

| Blocker | Notes |
|---|---|
| **OAuth client secret rotation** | Exposed in session screenshot 2026-04-01. Rotate in GCP Console before production use |
| **MCP server update in progress** | Jerry adding read capabilities + bug fixes. After update: run BACKLOG #30 validation |
| **n8n-plugin build** | Prerequisite for v1.21.0 Sessions 4-5 |
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

## N8n Items — Still Blocked

Sessions 4 and 5 of v1.21.0 paused. The n8n-plugin must be built first.

**Blocked:** #10 iClosed tracking, #11 Meta BQ pipeline, #12 n8n automation layer, #13 cross-platform data model, and n8n reverse path of #14.

**Pause memo:** `docs/superpowers/plans/2026-04-16-session-4-paused.md`
