---
title: Primer - Session Handoff
date: 2026-04-18
tags:
  - mwp
---

# Primer — Session Handoff

> This file rewrites itself at the end of every session. Read it first.
> **To resume:** say "continue" — the system will read this file and PLAN.md and pick up from the first unchecked item in "What Still Needs to Happen."

---

## Active Project

**ad-platform-campaign-manager** — v1.25.0 on `main`. Backlog items #24 + #33 closed and released. Plugin reinstalled at v1.25.0.

---

## Last Completed

### Session 2026-04-18: v1.25.0 — cut-release

`/cut-release` executed on `ad-platform-campaign-manager`:

| Task | File | Status |
|------|------|--------|
| v1.25.0 entry added to CHANGELOG | `CHANGELOG.md` | ✅ |
| plugin.json version bump 1.24.0 → 1.25.0 | `.claude-plugin/plugin.json` | ✅ |
| README: account-scaling + ad-campaign-war-council added | `README.md` | ✅ |
| skills/CONTEXT.md: count 15 → 17, dependency map extended | `skills/CONTEXT.md` | ✅ |
| PRIMER.md rewritten for v1.25.0 | `PRIMER.md` | ✅ |

**Changes shipped in v1.25.0:**
- `post-launch-monitor`: Bid Strategy Readiness gate at Day 14 + Day 15–30 (GAQL query + threshold table + NOT YET callout + verdict-before-actions rule). Backlog #24.
- `ad-campaign-war-council`: Step 0e plan-mode hard stop + Step 3 must-dispatch rule for Full account brief / Forward planning + 6-helper worked example in CONTEXT.md. Backlog #33.

### Session 2026-04-18 (earlier): Plugin reinstall
- Uninstalled + reinstalled `ad-platform-campaign-manager` via `claude plugin` CLI. Version confirmed: 1.24.0 → 1.25.0 after this release.

### Prior sessions
- **2026-04-18 (earlier):** Backlog execution — #24 + #33 (commit `51307c9`)
- **2026-04-18:** v1.24.0 — ad-campaign-war-council skill + 7 helper agents — merged to `main` (commit `4d735a4`)
- **2026-04-17:** v1.23.0 — `/account-scaling` skill + projection guardrail

---

## Decisions Made

- **v1.25.0 cut immediately:** #24 + #33 were self-contained backlog items; no reason to batch with future items.
- **account-scaling in README Phase 2:** skill explicitly requires MCP for 8-gate evaluation; placed alongside live-report and connect-mcp.
- **ad-campaign-war-council in Strategic Layer:** orchestrator role, not a standard operational skill.

---

## Decisions Pending

- **Items #10–#13 Session 4 restart** — Unblocked but unscheduled. Needs: a dedicated session with PLAN.md Session 4 restart checklist (`docs/superpowers/plans/2026-04-16-session-4-paused.md`).

---

## Skills In Progress

- None.

---

## Active Plans & Specs

- [[docs/superpowers/plans/2026-04-16-session-4-paused]] — v1.21.0 Session 4 restart checklist (n8n track) — **live, use to restart**
- [[docs/superpowers/plans/2026-04-17-account-scaling]] — v1.23.0 account-scaling design — historical reference

---

## What Still Needs to Happen

1. **Invoke `/ad-campaign-war-council`** on Vaxter project for Day 14 gate (2026-04-21) — "Can we lift the May 7 budget freeze early? Per-campaign options?"
2. **BACKLOG #32** — Write `reference/platforms/google-ads/strategy/lift-budget-freeze.md` — early-lift criteria, step-sizing, official Google guidance
3. **BACKLOG #26** — Add `all_conversions_value` + attribution health check to `live-report` skill templates
4. **BACKLOG #29** — MCP docs fix: move `user_list` from "Not Available" to Section 2 + add GAQL template
5. **v1.21.0 Session 4 restart** — restart using `2026-04-16-session-4-paused.md` checklist (iClosed, Meta BQ, n8n automation layer, cross-platform data model)

---

## Open Blockers

| Blocker | Notes | Unblocks when |
|---|---|---|
| **OAuth client secret rotation** | Exposed in session screenshot 2026-04-01 | Jerry rotates in GCP Console before production use |
| **MCP server update in progress** | Jerry adding read capabilities + bug fixes | After update: run BACKLOG #30 validation |
| **n8n track (#10–#13)** | Unblocked in principle (n8n-plugin v0.2.0 operational) | Jerry schedules Session 4 restart |
| **Watermelon plan path** | Jerry to confirm which PDF is the "plan" for #18 extraction | Jerry provides path |
| **GTM scripts inventory** | Jerry to provide scripts for #17 cookie cHTML review | Jerry confirms which scripts to review |
| **ClickFunnels 2.0 (#21)** | CF2.0 event names unverifiable; deferred | Re-scope when CF2.0 is live client |

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

The `n8n-workflow-builder-plugin` is fully built and operational (v0.2.0). Cross-plugin routing from ad-platform → n8n-plugin is wired in 5 skill files (commit `46e22ee`). Sessions 4 and 5 of v1.21.0 remain paused pending scheduling. Blocked items now unblocked in principle: #10 iClosed tracking, #11 Meta BQ pipeline, #12 n8n automation layer, #13 cross-platform data model, #14 n8n reverse path.
