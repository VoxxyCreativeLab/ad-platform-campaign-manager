---
title: Primer - Session Handoff
date: 2026-04-18
tags:
  - mwp
---

# Primer - Session Handoff

> This file rewrites itself at the end of every session. Read it first.
> **To resume:** say "continue" — the system will read this file and PLAN.md and pick up from the first unchecked item in "What Still Needs to Happen."

---

## Active Project

**ad-platform-campaign-manager** — v1.24.0 released and merged to `main` (2026-04-18). No active implementation plan. Next: plugin reinstall required to activate new skill + agents.

---

## Last Completed

### v1.24.0 — Ad Campaign War-Council (2026-04-18)

Full implementation merged to `main` in commit `4d735a4`.

| Deliverable | Type | Status |
|---|---|---|
| `skills/ad-campaign-war-council/SKILL.md` | Orchestrator skill | ✅ |
| `skills/ad-campaign-war-council/CONTEXT.md` | Skill routing index | ✅ |
| `skills/ad-campaign-war-council/references/evidence-standards.md` | Citation standard (4-tier) | ✅ |
| `skills/ad-campaign-war-council/references/rule-override-protocol.md` | Rule-override 8-step protocol | ✅ |
| `skills/ad-campaign-war-council/references/option-framing.md` | A/B/C template + Vaxter Day-14 example | ✅ |
| `agents/account-archivist.md` | Full-project brief | ✅ |
| `agents/trend-analyst.md` | Multi-day delta tables + anomaly flags | ✅ |
| `agents/communications-analyst.md` | Stakeholder intent + approval chain | ✅ |
| `agents/research-analyst.md` | External research (WebSearch/WebFetch) | ✅ |
| `agents/evidence-arbiter.md` | Rule-override adjudicator (WebSearch/WebFetch) | ✅ |
| `agents/budget-advisor.md` | Marginal return + IS-headroom reallocation (WebSearch/WebFetch) | ✅ |
| `agents/growth-architect.md` | Forward blueprint, parabolic-ROAS trajectory (WebSearch/WebFetch) | ✅ |
| `CLAUDE.md` (Quick Navigation) | `/ad-campaign-war-council` row added | ✅ |
| `CONTEXT.md` | 9 routing rows + Escalation Handshake section | ✅ |
| `agents/CONTEXT.md` | 7 new agent entries registered | ✅ |
| `BACKLOG.md` | Item #32: lift-budget-freeze-early.md reference doc | ✅ |
| `.claude-plugin/plugin.json` | Version bumped `1.23.0` → `1.24.0` | ✅ |
| `CHANGELOG.md` | v1.24.0 entry added | ✅ |

**Key design decisions:**
- Orchestrator is a **skill** (not a subagent) — must run in primary conversation for full tool access
- 4-tier tiered evidence standard; Tier-1 vendor-official required for any rule-override
- Dual entry path: direct `/ad-campaign-war-council` invocation + escalation from other skills
- `growth-architect` is internal-only; Client Communication Guardrail enforced at SKILL.md level
- `budget-advisor` is distinct from `/budget-optimizer` skill (autonomous reallocation analysis vs. interactive math workshop)
- 4 agents with WebSearch/WebFetch: research-analyst, evidence-arbiter, budget-advisor, growth-architect

### v1.23.0 — Account Scaling Skill + Projection Guardrail (2026-04-17)

All tasks completed and committed. See previous PRIMER for detail.

---

## What Still Needs to Happen

> [!warning] Plugin reinstall required — do this first
> v1.24.0 adds `/ad-campaign-war-council` (new skill) + 7 new agents. Run the plugin reinstall before using them:
> 1. Uninstall `ad-platform-campaign-manager` in VS Code (Claude Code extension → Plugins)
> 2. Reinstall via `/plugins install`
> 3. Reload VSCode window: `Ctrl+Shift+P` → "Developer: Reload Window"
> 4. Confirm `/ad-platform-campaign-manager:ad-campaign-war-council` appears in skill list

**Pending validation (after plugin reinstall):**

- [ ] Invoke `/ad-campaign-war-council` on the Vaxter project for Day 14 evaluation (2026-04-21) — "Can we lift the May 7 budget freeze early? Per-campaign options?"
- [ ] BACKLOG #32: Write `reference/platforms/google-ads/strategy/lift-budget-freeze.md` — reference doc for early-lift criteria, step-sizing, official Google guidance

---

## Deferred Backlog Items

| # | Item | Size | Notes |
|---|---|---|---|
| 24 | tROAS/tCPA transition gates in post-launch-monitor | S | Add "Bid Strategy Readiness" section at Day 14/21 checkpoints |
| 26 | `all_conversions` in live-report + attribution interpretation | S-M | Shopping + PMax multi-touch attribution; 58x delta confirmed in Vaxteronline |
| 29 | MCP docs fix — user_list sizes are API-accessible | S | Remove from "Not Available via MCP" section; add confirmed GAQL |
| 30 | MCP server capability expansion validation | After update | Wait for Jerry's MCP server update to ship before running |
| 32 | Reference doc: lift-budget-freeze-early.md | M | Covers early-lift criteria, step-sizing, official Google guidance; scattered content in scaling-playbook + post-launch-playbook + learning-phase |

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

## Active Skills

`/campaign-setup` · `/keyword-strategy` · `/conversion-tracking` · `/reporting-pipeline` · `/campaign-review` · `/pmax-guide` · `/post-launch-monitor` · `/product-performance` · `/budget-optimizer` · `/ads-scripts` · `/ad-copy` · `/campaign-cleanup` · `/account-scaling` · `/account-strategy` · `/live-report` · `/connect-mcp` · `/ad-campaign-war-council` (new v1.24.0)

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

The `n8n-workflow-builder-plugin` is fully built and operational (v0.1.0). Cross-plugin routing from ad-platform → n8n-plugin is wired in 5 skill files (commit `46e22ee`). Sessions 4 and 5 of v1.21.0 remain paused pending scheduling. Blocked items now unblocked in principle: #10 iClosed tracking, #11 Meta BQ pipeline, #12 n8n automation layer, #13 cross-platform data model, #14 n8n reverse path.
