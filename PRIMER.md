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

**ad-platform-campaign-manager** — v1.25.0 on `main`. Backlog execution session: groups [1+3] shipped. 6 items closed (pending `/cut-release` for next version tag).

---

## Last Completed

### Session 2026-04-18: Backlog execution — groups [1+3] (#10–#14, #32)

| Task | Description | Status |
|------|-------------|--------|
| Blocker verification | Confirmed n8n-plugin v0.2.0 unblocks #10–#14; confirmed MCP server feature/expand-reads (9→32 tools, 181 tests) unblocks #30 | ✅ |
| Cross-plugin routing #10 | iClosed routing edge → `conversion-tracking/SKILL.md` + `skills/CONTEXT.md` | ✅ |
| Cross-plugin routing #11 | Meta Ads → BQ routing edge → `reporting-pipeline/SKILL.md` + `skills/CONTEXT.md` | ✅ |
| Cross-plugin routing #12 | 4-workflow stack routing edge → `live-report/SKILL.md` + `skills/CONTEXT.md` | ✅ |
| Cross-plugin routing #13 | Cross-platform BQ model routing edge → `skills/CONTEXT.md` | ✅ |
| #14 — BQ→CAPI reverse path | Closed as Done — delegated to n8n-plugin `reference/patterns/bq-to-capi-offline.md` | ✅ |
| #32 — lift-budget-freeze.md | New reference doc created: 5-gate early-lift criteria, decision flowchart, GAQL queries | ✅ |
| Cross-links #32 | Added cross-links to `scaling-playbook.md`, `post-launch-playbook.md`, `learning-phase.md` | ✅ |
| BACKLOG.md update | #10–#14, #32 → ✅ Done (v1.25.0 pending); duplicate #14 row removed | ✅ |

**Research performed for #32:** Google official docs (`answer/13020501`, `answer/10276704`) — budget changes not formally listed as learning triggers; 20% step rule is industry consensus (WordStream, KlientBoost), not a Google hard rule. Documented accurately in the new file.

**MCP server finding (blocker check):** `google-ads-mcp-server` `feature/expand-reads` branch expanded from 9 → 32 read tools. New tools include `list_audiences` (returns user_lists — directly closes #29), `get_search_terms`, `get_shopping_performance`, `list_conversion_actions`, `get_change_history`, `walk_mcc_hierarchy`, GAQL field validator (v23, 8,792 fields), `run_gaql` envelope format. Branch is stable (181 tests) but NOT yet merged to main. Live smoke tests needed before merge.

### Prior sessions

- **2026-04-18 (earlier):** `/cut-release` v1.25.0 — backlog #24 (tROAS gates in post-launch-monitor) + #33 (war-council plan-mode guard) shipped
- **2026-04-18 (earlier):** Backlog execution #24 + #33 — committed `51307c9`
- **2026-04-18:** v1.24.0 — ad-campaign-war-council skill + 7 helper agents — merged to `main` (`4d735a4`)
- **2026-04-17:** v1.23.0 — `/account-scaling` skill + projection guardrail
- **2026-04-16:** v1.22.0 — BigQuery pipeline expansion (native connectors), Klaviyo, Looker Studio
- **2026-04-14:** v1.21.x — Shopping performance regression diagnosis, Feed-only PMax AD STRENGTH fix

---

## Decisions Made

- **#10–#13 resolved via cross-plugin routing, not content duplication.** The n8n-plugin is the authoritative home for iClosed, Meta BQ, 4-workflow, and cross-platform BQ knowledge. Ad-platform adds routing edges only — no duplicated content. — Why: clean separation of concerns; n8n-plugin already has 14 new reference files covering exactly these domains.
- **#14 closed as Done via delegation.** BQ→Meta CAPI reverse path lives in `n8n-plugin/reference/patterns/bq-to-capi-offline.md`. Ad-platform routing edge wired. — Why: no need to maintain a parallel doc.
- **PLAN.md v1.21.0 Session 4 ref-file creation tasks are moot.** The tasks to create `meta-ads-bigquery.md` and `cross-platform-data-model.md` in ad-platform are superseded by the routing-only approach. The PLAN.md items remain unchecked but should be treated as resolved-differently rather than todo.
- **MCP capability doc rewrite (#30) deferred to Group [2]** — needs the MCP server feature/expand-reads branch to merge first. Do not run Group [2] until after the PR is merged and the server is restarted.
- **#25 and #27 (MCP write tools) reclassified as external server-side work.** Should be filed to `google-ads-mcp-server/BACKLOG.md` as Tracks F/G proposals, not kept as Open items on the ad-platform side.

---

## Decisions Pending

- **PLAN.md v1.21.0 Session 4 items** — mark unchecked tasks as resolved-differently (routing approach used instead of creating ref files), or leave as-is? Needs: Jerry's call on PLAN.md hygiene.
- **google-ads-mcp-server PR merge timing** — feature/expand-reads has 181 tests passing; live smoke tests (`get_change_history`, `get_search_terms`, `list_conversion_actions`, `run_gaql` truncation) must pass before merge. Needs: Jerry to run smoke tests against real Voxxy account.
- **File #25/#27 to MCP server backlog** — approved in plan but not yet executed. Needs: Jerry to confirm filing.

---

## Skills In Progress

- `/plugin-backlog-execute ad-platform-campaign-manager` — Group [1+3] complete. Groups [2] and [4] remain. — **Group [2]** (MCP capability doc rewrite) is blocked until MCP server PR is merged. **Group [4]** (attribution reporting) is unblocked; ~30 min.

---

## Active Plans & Specs

- [[docs/superpowers/plans/2026-04-16-session-4-paused]] — v1.21.0 Session 4 restart checklist (n8n track) — historical context; routing approach now used instead of creating ref files; check against Done items before resuming
- [[docs/superpowers/plans/2026-04-17-account-scaling]] — v1.23.0 account-scaling design — historical reference only
- [[docs/superpowers/plans/2026-04-14-backlog-expansion]] — v1.21.0 design — partially complete; Session 4 tasks superseded by routing approach
- [[docs/superpowers/plans/2026-04-01-google-ads-mcp-server]] — google-ads-mcp-server expansion — referenced in blocker check this session

---

## What Still Needs to Happen

1. **`/cut-release ad-platform-campaign-manager`** — version-bump from v1.25.0 to v1.26.0. 6 items to ship: #10, #11, #12, #13, #14 (routing edges) + #32 (lift-budget-freeze.md).
2. **Merge `google-ads-mcp-server` feature/expand-reads** — run live smoke tests, create PR, merge, restart MCP server.
3. **BACKLOG Group [2] — MCP capability doc rewrite** — after MCP server merge: rewrite `reference/mcp/mcp-capabilities.md` Sections 1–4 against the new 32-tool surface. Closes #29 + #30. (~50 min)
4. **BACKLOG Group [4] — Attribution-aware reporting** — add `all_conversions` + attribution health check to `live-report` skill. Closes #26. (~30 min)
5. **File #25 + #27 to `google-ads-mcp-server/BACKLOG.md`** — negative keyword write tools (Track F) + RSA mutation tools (Track G).
6. **Invoke `/ad-campaign-war-council`** on Vaxteronline project for Day 14 gate (target: 2026-04-21) — "Can we lift the May 7 budget freeze early? Per-campaign options?"

---

## Open Blockers

| Blocker | Notes | Unblocks when |
|---|---|---|
| **OAuth client secret rotation** | Exposed in session screenshot 2026-04-01 | Jerry rotates in GCP Console before production use |
| **MCP server PR not merged** | `feature/expand-reads`: 9→32 tools, 181 tests. Needs live smoke tests | Jerry runs smoke tests + merges PR; then restart MCP server |
| **Group [2] blocked on MCP merge** | mcp-capabilities.md rewrite must reflect actual deployed tools | After MCP server restart |
| **#25, #27 (MCP write tools)** | Negative keyword + RSA mutation tools not started server-side | File to MCP server backlog; track as server-side items |
| **#17 GTM scripts inventory** | Jerry to provide scripts for cookie cHTML review | Jerry confirms which scripts |
| **#18 Watermelon plan path** | Jerry to confirm PDF path for knowledge extraction | Jerry provides path |
| **#21 ClickFunnels 2.0** | CF2.0 event names unverifiable; deferred | Re-scope when CF2.0 is live client |

---

## MCP Server Reference

| Item | Value |
|---|---|
| Connected to | MCC 7244069584 (Voxxy Creative Lab) via Explorer Access (2,880 ops/day) |
| Write passphrase | `voxxy-writes` |
| Credentials | `C:\Users\VCL1\google-ads.yaml` |
| Wrapper | `C:\mcp\google-ads.cmd` |
| Status | `feature/expand-reads` stable (181 tests) — awaiting merge to main |
| New tools (pending merge) | 32 total: +23 read tools including `list_audiences`, `get_search_terms`, `get_shopping_performance`, `get_change_history`, `walk_mcc_hierarchy`, GAQL field validator |

---

## Session Notes

**Blocker verification approach:** This session caught that the BACKLOG.md status for #10–#14 said "Paused — n8n-plugin" but the n8n-plugin had already shipped v0.2.0 with all required recipes. The plan-mode triage step (checking if blockers were actually resolved before classifying items) was critical and saved time.

**20% budget rule clarification:** The `lift-budget-freeze.md` doc accurately reflects that Google's official docs do NOT list budget changes as a formal learning trigger. The 20% step rule is industry consensus, not a Google hard rule. This distinction matters when advising clients — the `learning-phase.md` file's wording should be reviewed for accuracy on this point in a future session.

**v1.21.0 plan is effectively superseded:** The Session 4 tasks in `2026-04-16-session-4-paused.md` and PLAN.md called for creating `meta-ads-bigquery.md` and `cross-platform-data-model.md` in the ad-platform. This session resolved those items via routing edges instead. The PLAN.md items remain unchecked but are resolved-differently. Consider a PLAN.md cleanup pass before the next major release.
