---
title: "Plan — Ad Platform Campaign Manager"
date: 2026-03-28
tags:
  - mwp
  - plan
---

# Plan — Ad Platform Campaign Manager

**Last updated:** 2026-04-01
**Current milestone:** Phase 2 — Content Completion & MCP Prep

---

## Project Overview

Claude Code plugin providing campaign management guidance for Google Ads. Phase 1 delivered knowledge-based skills (no API). Phase 2 fills remaining content gaps and prepares MCP configuration. Phase 3 connects live API via MCP. Phase 4 expands to multi-platform.

---

## Phases & Status

| Phase | Name | Status | Notes |
|-------|------|--------|-------|
| 1 | Knowledge & Guidance | ✅ Done | 10 skills, 37 reference files, 2 agents, config complete |
| 2 | Content Completion & MCP Prep | 🔄 In progress | Fill script files, repos catalog, update MCP refs, add campaign-cleanup skill |
| 3 | MCP API Integration | 🔄 In progress | Custom `voxxy/google-ads-mcp-server` built — 9 read + 11 write tools, three-gate safety architecture |
| 4 | Multi-Platform | ⬜ Not started | Populate meta-ads/, linkedin-ads/, tiktok-ads/ |

## Stages & Status

| Stage | Name | Status | Notes |
|-------|------|--------|-------|
| 01 | Reference | 🔄 Expanding | 37 → 59+ files — added 17 script docs, repos catalog, 4 campaign type docs |
| 02 | Skills | 🔄 Expanding | 10 → 11 skills — adding campaign-cleanup |
| 03 | Agents | ✅ Done | 2 agents (campaign-reviewer, tracking-auditor) |

**Status key:** ⬜ Not started · 🔄 In progress · ✅ Done · ⚠️ Blocked

---

## Current Focus

**Active phase:** Phase 2 — Content Completion & MCP Prep
**What's happening:**
- ✅ Populated `reference/scripts/` with 17 script docs
- ✅ Created `reference/repos/open-source-repos.md` — curated repo catalog
- ✅ Updated MCP references — official repo moved to `googleads/google-ads-mcp`, added Explorer Access tier
- ✅ Added `campaign-cleanup` skill for messy account triage
- ✅ Seeded `LESSONS.md` with master plugin development lessons
- ✅ Added 4 campaign type docs (Shopping, Video, DSA, Demand Gen) — Finding #2
- ✅ **Fact-check sweep** — all 17 reference docs updated to 2025-2026 accuracy
- 🔄 **Phase 3 started** — custom `voxxy/google-ads-mcp-server` built with three-gate safety architecture (session passphrase + validate_only dry-run + confirm); MCP reference docs updated
**Blockers:** None for Phase 2. Phase 3 needs Google Ads API credentials configured (try Explorer Access first).

---

## Decisions Made

- 2026-03-28 — Google Ads only for Phase 1; multi-platform deferred to Phase 4
- 2026-03-28 — tracking-bridge/ is the differentiator vs generic campaign tools
- 2026-03-28 — Skills load reference docs selectively (never dump full tree into context)
- 2026-03-28 — MWP overlay mode chosen (plugin directory structure is convention-locked)
- 2026-03-31 — MCP confirmed as right approach (no official Google Ads CLI exists)
- 2026-03-31 — Official MCP repo moved to `googleads/google-ads-mcp` (read-only, Google policy)
- 2026-03-31 — Explorer Access (Feb 2026) may bypass developer token approval backlog
- 2026-03-31 — PMax scripts get their own `scripts/pmax/` subdirectory
- 2026-03-31 — Master plugin is always `project-structure-and-scaffolding-plugin`
- 2026-04-01 — Custom `voxxy/google-ads-mcp-server` built locally — preferred over community alternatives due to three-gate safety architecture and audit logging

---

## Next Steps

1. **Complete Phase 2** — finish all 10 content completion steps
2. **Test skills** — invoke each `/ad-platform-campaign-manager:*` skill and verify it loads correctly
3. **Try Explorer Access** — go to Google Ads → Tools → API Center, check for automatic 2,880 ops/day tier
4. **Install read-only MCP** — `googleads/google-ads-mcp` as first live API connection
5. **Test connect-mcp and live-report** — once API access is confirmed
6. **Real client work** — use skills on a live Google Ads account

---

## Audit Findings (2026-03-31)

Full plugin audit identified 4 weaknesses. Tackling one at a time — each gets its own brainstorm → spec → plan → implementation cycle.

| # | Weakness | Impact | Status |
|---|----------|--------|--------|
| 1 | **No API access** — guidance-only, Phase 2 skills hidden | Can teach but can't validate or automate | ⬜ Not started |
| 2 | **Missing campaign types** — Shopping, Video/YouTube, DSA, Demand Gen undocumented | Plugin can't guide setup/review for these types | ✅ Done |
| 3 | **Workflow dead-ends** — campaign-setup has no post-launch monitoring, live-report has no actionable insights, keyword-strategy has no brainstorming scaffold | User gets a plan but no follow-through | ⬜ Not started |
| 4 | **Skills tell rather than ask** — instructional instead of Socratic, less interactive than agents | Tracking specialist needs guided discovery, not info dumps | ⬜ Not started |

### Finding 1: No API Access

- Everything is knowledge + guidance. Cannot pull live data, make changes, or verify.
- `connect-mcp` and `live-report` skills are hidden (`disable-model-invocation: true`).
- **Blocker:** Google Ads API credentials not yet obtained.
- **Possible mitigation:** CSV upload workflows, manual data entry patterns, workaround designs.

### Finding 2: Missing Campaign Types

- **Shopping campaigns:** No standalone reference. Critical for e-commerce clients.
- **Video/YouTube:** Mentioned in `campaign-types.md` but no dedicated doc.
- **Dynamic Search Ads (DSA):** Not documented.
- **Demand Gen:** Google's newest format (2024), only briefly mentioned.
- **Fix:** Create 4 new reference files under `reference/platforms/google-ads/`.

### Finding 3: Workflow Dead-Ends

- `campaign-setup` ends at "here's your plan" — no Day 1 / Week 1 / Month 1 monitoring.
- `live-report` lists 6 report types but no guidance on what to DO with results.
- `keyword-strategy` says "brainstorm keywords" but doesn't scaffold the brainstorming process.
- **Fix:** Add post-launch monitoring skill or section; add actionable insight guidance to existing skills.

### Finding 4: Instructional vs Socratic Skills

- Many skills tell (instructional) rather than ask (Socratic/guided discovery).
- `campaign-review` skill is less interactive than the `campaign-reviewer` agent.
- `campaign-setup` asks questions in Step 1 but then jumps to templates.
- **Fix:** Redesign skill interaction patterns — add decision-tree questions throughout, not just at the start.

---

## Fact-Check Sweep (2026-04-01)

Full fact-check of all 17 `reference/platforms/google-ads/` files against 2025-2026 Google Ads changes. 16 of 17 files need updates. Plan: `docs/superpowers/plans/2026-04-01-fact-check-sweep.md` (in execution plan file).

### Tier 1: Factual Errors (must fix)

| File | Issue | Status |
|------|-------|--------|
| `bidding-strategies.md` | Enhanced CPC described as active — **deprecated March 2025** | ⬜ Not started |
| `pmax/pmax-metrics.md` | Says PMax shows "categories of search terms" — **has full visibility since March 2025** | ⬜ Not started |
| `campaign-types.md` | Video Action Campaigns still listed — **migrated to Demand Gen, no longer exist** | ⬜ Not started |
| `ads-scripts-api.md` | AWQL reporting example deprecated; UrlFetchApp limit wrong (50 vs 20,000/day); missing `AdsApp.search()` | ✅ Done |

### Tier 2: Significant Omissions (should fix)

| File | Issue | Status |
|------|-------|--------|
| `match-types.md` | AI Max for Search not mentioned — fundamentally changes match type behavior | ✅ Done |
| `pmax/audience-signals.md` | Missing audience exclusions, demographic exclusions, search themes (50/group) | ✅ Done |
| `shopping-campaigns.md` | PMax comparison table wrong (negatives + reporting), free listings missing, MC transitions | ✅ Done |
| `video-campaigns.md` | Video Action subtype removed, Video Reach sub-options incomplete, Shorts behavior | ✅ Done |
| `demand-gen.md` | GDN expansion missing, VAC absorption, channel controls, ~10 new features | ✅ Done |
| `dsa.md` | AI Max for Search not mentioned, no deprecation warning | ✅ Done |

### Tier 3: Minor Updates

| File | Issue | Status |
|------|-------|--------|
| `account-structure.md` | PMax negatives missing, "extensions" terminology | ✅ Done |
| `quality-score.md` | "Extensions" → "assets", component weighting, Ad Rank formula | ✅ Done |
| `ad-extensions.md` | Header terminology, call-only deprecation, Brand Guidelines | ✅ Done |
| `conversion-actions.md` | Incomplete categories, External Attribution, Data Manager API | ✅ Done |
| `enhanced-conversions.md` | Account-level EC (2025 change), automatic detection, Data Manager | ✅ Done |
| `gaql-reference.md` | DEMAND_GEN channel type, PMax channel reporting, PARAMETERS | ✅ Done |

### Tier 4: PMax & Audit Remaining

| File | Issue | Status |
|------|-------|--------|
| `pmax/asset-requirements.md` | Description spec wrong, search themes, brand guidelines, video count | ✅ Done |
| `pmax/feed-optimization.md` | MC Next, Content API sunset, product ID split, feed frequency | ✅ Done |
| `audit/audit-checklist.md` | PMax section too thin, Consent Mode v2, "assets" terminology | ✅ Done |
| `audit/common-mistakes.md` | Missing PMax-specific mistakes section | ✅ Done |

### Clean

| File | Status |
|------|--------|
| `audit/negative-keyword-lists.md` | ✅ Updated (added PMax shared lists note) |

### Recurring themes — all resolved

- ~~PMax evolved massively in 2025~~ → all PMax docs updated
- ~~AI Max for Search absent everywhere~~ → added to match-types, campaign-types, dsa, account-structure, audit-checklist
- ~~"Extensions" → "assets" rebrand~~ → replaced throughout all files
- ~~Enhanced CPC deprecated March 2025~~ → removed from all strategy/bidding tables, replaced with deprecation warnings
- ~~Video Action Campaigns gone~~ → removed from video-campaigns, campaign-types; redirected to demand-gen
- ~~Demand Gen expanded~~ → GDN, VAC absorption, channel controls, new features all documented

---

## Notes / Open Questions

- Explorer Access (Feb 2026) provides 2,880 ops/day with no formal application — try this before standard developer token process
- Phase 2 skills (`connect-mcp`, `live-report`) are fully defined, updated with Explorer Access path
- Platform placeholder directories (meta-ads/, linkedin-ads/, tiktok-ads/) remain .gitkeep only (Phase 4)
- `campaign-cleanup` skill addresses common pattern: messy accounts need triage before optimization
