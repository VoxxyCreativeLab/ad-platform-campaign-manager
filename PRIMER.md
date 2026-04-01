---
title: Primer — Session Handoff
date: 2026-04-01
tags:
  - mwp
---

# Primer — Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.0.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists.

## Last Completed

### Session 2026-04-01: Reference Knowledge Base Overhaul

Two major deliverables:

**1. New campaign type docs (Finding #2 from plugin audit)**
- Created 4 standalone reference files: `shopping-campaigns.md`, `video-campaigns.md`, `dsa.md`, `demand-gen.md`
- Updated `campaign-types.md` with cross-references, decision tree, and comparison table
- Updated CONTEXT.md routing tables

**2. Full fact-check sweep of all 17 reference docs**
- Tier 1 (factual errors): eCPC deprecated, PMax full search terms, Video Action removed, AWQL→GAQL
- Tier 2 (significant omissions): AI Max added, audience exclusions, GDN expansion, free listings, DSA deprecation warning
- Tier 3 (minor updates): "assets" terminology, QS weighting, account-level EC, Data Manager API, GAQL updates
- Tier 4 (PMax & audit): asset specs fixed, MC Next, 7 new PMax audit checks, 7 new PMax common mistakes
- All recurring themes resolved: PMax 2025, AI Max, "assets" rebrand, eCPC, VAC→Demand Gen

Design spec: `docs/superpowers/specs/2026-03-31-missing-campaign-types-design.md`

### Session 2026-03-31: Phase 2 Completion

- 17 Google Ads Script docs across 5 subdirectories
- 3 MCP reference files updated (new official repo `googleads/google-ads-mcp`, Explorer Access tier)
- `reference/repos/open-source-repos.md` — 9 curated repos
- New `campaign-cleanup` skill — account triage for messy/neglected accounts
- `LESSONS.md` seeded with 6 plugin development lessons

## Current State

- **21 reference files** under `platforms/google-ads/` (8 core + 4 campaign types + 4 PMax + 3 audit + GAQL + Scripts API)
- **17 script docs** under `reference/scripts/`
- **6 tracking-bridge docs** (the differentiator)
- **5 reporting docs** + **3 MCP docs** + **1 repos catalog**
- **11 skills** (9 Phase 1 active + 2 Phase 2 hidden)
- **2 agents** (campaign-reviewer, tracking-auditor)
- All reference docs fact-checked to 2025-2026 accuracy

## Remaining Audit Findings

3 of 4 audit findings from 2026-03-31 remain (saved in PLAN.md):

| # | Finding | Status |
|---|---------|--------|
| 1 | No API access — guidance-only, Phase 2 skills hidden | ⬜ Not started |
| 2 | Missing campaign types | ✅ Done |
| 3 | Workflow dead-ends — no post-launch monitoring, no actionable insights, no brainstorming scaffold | ⬜ Not started |
| 4 | Skills tell rather than ask — instructional instead of Socratic | ⬜ Not started |

## Next Steps

1. **Tackle Finding #3 or #4** — workflow dead-ends or Socratic skill redesign
2. **Try Explorer Access** — Google Ads → Tools → API Center, check for 2,880 ops/day automatic tier
3. **Install read-only MCP** — `googleads/google-ads-mcp` as first live connection
4. **Test skills with real accounts** — all Phase 1 + 2 skills ready for production
5. **Feed-only PMax via GMC** — document in `pmax-guide` (known gap)

## Open Blockers

- **Phase 3 (MCP integration):** needs Google Ads API credentials — try Explorer Access first
- **Phase 4 (Multi-platform):** not started — Meta/LinkedIn/TikTok placeholders only

## Session Notes

- MCP confirmed as right approach (no official Google Ads CLI exists)
- Official MCP repo: `googleads/google-ads-mcp` (read-only) — community `cohnen/mcp-google-ads` for write ops
- `tracking-bridge/` remains the unique differentiator
- Master plugin: `project-structure-and-scaffolding-plugin`
- **Critical workflow:** after every `git push`, Claude must execute: `git pull` marketplace clone → `claude plugin uninstall` → `claude plugin install`. Never just remind — always execute.
