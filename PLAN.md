---
title: "Plan — Ad Platform Campaign Manager"
date: 2026-03-28
tags:
  - mwp
  - plan
---

# Plan — Ad Platform Campaign Manager

**Last updated:** 2026-04-02
**Current milestone:** Phase 3 — MCP API Integration ✅ Done (25 tools verified, reconnected after migration)

---

## Project Overview

Claude Code plugin providing campaign management guidance for Google Ads. Phase 1 delivered knowledge-based skills (no API). Phase 2 fills remaining content gaps and prepares MCP configuration. Phase 3 connects live API via MCP. Phase 4 expands to multi-platform.

---

## Phases & Status

| Phase | Name | Status | Notes |
|-------|------|--------|-------|
| 1 | Knowledge & Guidance | ✅ Done | 10 skills, 37 reference files, 2 agents, config complete |
| 2 | Content Completion & MCP Prep | ✅ Done | Script files, repos catalog, MCP refs, campaign-cleanup skill |
| 3 | MCP API Integration | ✅ Done | Custom `voxxy/google-ads-mcp-server` — 25 tools verified in Claude Code, three-gate safety |
| 4 | Multi-Platform | ⬜ Not started | Populate meta-ads/, linkedin-ads/, tiktok-ads/ |

## Stages & Status

| Stage | Name | Status | Notes |
|-------|------|--------|-------|
| 01 | Reference | 🔄 Expanding | 37 → 60+ files — added 17 script docs, repos catalog, 4 campaign type docs, feed-only-pmax.md |
| 02 | Skills | 🔄 Expanding | 10 → 11 skills — adding campaign-cleanup |
| 03 | Agents | ✅ Done | 2 agents (campaign-reviewer, tracking-auditor) |

**Status key:** ⬜ Not started · 🔄 In progress · ✅ Done · ⚠️ Blocked

---

## Current Focus

**Active phase:** Audit Findings #3/#4
**What's happening:**
- ✅ Phase 2 complete — scripts, repos, MCP refs, campaign-cleanup, fact-check sweep
- ✅ Phase 3 complete — MCP server built, connected, and verified (25 tools live in Claude Code)
- ✅ MCP reconnected after machine migration (2026-04-02) — credentials restored, server re-registered
- ✅ Finding #1 resolved — API access working via custom MCP server
- ✅ Finding #2 resolved — 4 campaign type docs added
- ✅ Finding #5 resolved — feed-only PMax reference doc, skill restructuring, blocker fix
- Next: Restart session → test MCP → Finding #3 (workflow dead-ends) or Finding #4 (Socratic skills)
**Blockers:** OAuth client secret should be rotated. Session restart needed for MCP tools to load.

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
- 2026-04-01 — Human currency input only (no raw micros) — prevents the #1 costly Google Ads API error
- 2026-04-01 — Session passphrase write lock (`voxxy-writes`) — additional gate beyond draft-then-confirm
- 2026-04-01 — MCP server lives as sibling under CLAUDE-plugins (own git repo, own version lifecycle)
- 2026-04-01 — Explorer Access (2,880 ops/day) obtained — sufficient for interactive Claude use
- 2026-04-01 — MCC 7244069584 as login_customer_id — gives access to all child client accounts
- 2026-04-01 — MCP config: use `claude mcp add` CLI, not manual JSON edits (`~/.claude/.mcp.json` is not read, `~/.claude.json` gets overwritten)
- 2026-04-01 — Python `-m` shared singleton must live in its own module (not in the `__main__` entrypoint) to avoid dual-instance bug
- 2026-04-01 — Windows MCP servers need wrapper scripts in clean paths (no spaces) — `C:\mcp\` directory

---

## Next Steps

1. **Restart Claude Code session** — MCP tools registered but won't load until restart
2. **Test MCP connection** — call `list_accounts()` to verify credentials work post-migration
3. **Rotate OAuth client secret** — exposed in previous session screenshot, update `~/google-ads.yaml`
4. **Unhide Phase 2 skills** — set `disable-model-invocation: false` in `connect-mcp` and `live-report`
5. **Tackle Finding #3** — workflow dead-ends (post-launch monitoring, actionable insights, brainstorming scaffolds)
6. **Tackle Finding #4** — Socratic skill redesign (guided discovery instead of info dumps)
7. **Real client work** — use skills on a live Google Ads account

---

## Audit Findings (2026-03-31)

Full plugin audit identified 4 weaknesses. Tackling one at a time — each gets its own brainstorm → spec → plan → implementation cycle.

| # | Weakness | Impact | Status |
|---|----------|--------|--------|
| 1 | **No API access** — guidance-only, Phase 2 skills hidden | Can teach but can't validate or automate | ✅ Done — MCP server built, connected, 25 tools verified in Claude Code |
| 2 | **Missing campaign types** — Shopping, Video/YouTube, DSA, Demand Gen undocumented | Plugin can't guide setup/review for these types | ✅ Done |
| 3 | **Workflow dead-ends** — campaign-setup has no post-launch monitoring, live-report has no actionable insights, keyword-strategy has no brainstorming scaffold | User gets a plan but no follow-through | ⬜ Not started |
| 4 | **Skills tell rather than ask** — instructional instead of Socratic, less interactive than agents | Tracking specialist needs guided discovery, not info dumps | ⬜ Not started |
| 5 | **Feed-only PMax knowledge gap** — zero coverage of feed-only PMax, listing groups, MC creation flow, restructuring patterns. campaign-setup had wrong blocker. | Claude failed real-world e-commerce campaign restructuring | ✅ Done |

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

### Finding 5: Feed-Only PMax Knowledge Gap

- Plugin had zero coverage of feed-only PMax, listing groups, Merchant Center campaign creation flow, and account restructuring patterns.
- `campaign-setup` skill had a factually wrong blocker saying PMax "cannot launch" without creative assets — false for feed-only PMax.
- **Impact:** Claude failed to guide real-world campaign restructuring for e-commerce client (Vaxteronline).
- **Fix:** Created `feed-only-pmax.md` reference doc (verified against Google API docs + SMEC 4,000+ campaign study), restructured `pmax-guide` skill with feed-only/full/non-feed decision fork, fixed `campaign-setup` blockers, updated decision tree, comparison tables, open-source-repos catalog.
- **Files changed:** 1 created (`pmax/feed-only-pmax.md`), 10 modified (asset-requirements, shopping-campaigns, campaign-types, pmax-guide SKILL, campaign-setup SKILL, CONTEXT, LESSONS, PLAN, open-source-repos).
- **Status:** ✅ Done

---

## Fact-Check Sweep (2026-04-01)

Full fact-check of all 17 `reference/platforms/google-ads/` files against 2025-2026 Google Ads changes. 16 of 17 files need updates. Plan: `docs/superpowers/plans/2026-04-01-fact-check-sweep.md` (in execution plan file).

### Tier 1: Factual Errors (must fix)

| File | Issue | Status |
|------|-------|--------|
| `bidding-strategies.md` | Enhanced CPC described as active — **deprecated March 2025** | ✅ Done |
| `pmax/pmax-metrics.md` | Says PMax shows "categories of search terms" — **has full visibility since March 2025** | ✅ Done |
| `campaign-types.md` | Video Action Campaigns still listed — **migrated to Demand Gen, no longer exist** | ✅ Done |
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

- Explorer Access obtained (2,880 ops/day) — sufficient for interactive use
- Phase 2 skills (`connect-mcp`, `live-report`) ready to unhide — MCP is now verified
- Platform placeholder directories (meta-ads/, linkedin-ads/, tiktok-ads/) remain .gitkeep only (Phase 4)
- `campaign-cleanup` skill addresses common pattern: messy accounts need triage before optimization
- Custom MCP server: `../google-ads-mcp-server/` — 96 tests, 25 tools, 16 commits, clean git
- **SECURITY:** OAuth client secret was exposed in a conversation screenshot (2026-04-01). Must rotate in GCP Console before production use.

## MCP Server Details (google-ads-mcp-server)

| Item | Value |
|------|-------|
| Location | `../google-ads-mcp-server/` (sibling to this plugin) |
| Tests | 96 passing |
| Tools | 25 (3 session + 9 read + 11 write + 2 confirm) |
| Safety | Three-gate: passphrase lock → ChangePlan draft → validate_only dry-run |
| Passphrase | `voxxy-writes` |
| API Tier | Explorer Access (2,880 ops/day) |
| MCC | 7244069584 (Voxxy Creative Lab) |
| Credentials | `~/google-ads.yaml` |
| MCP Config | `claude mcp add google-ads -s user` → `C:\mcp\google-ads.cmd` |
| Audit Log | `~/google-ads-mcp-audit.jsonl` |
| Implementation Plan | `docs/superpowers/plans/2026-04-01-google-ads-mcp-server.md` |
