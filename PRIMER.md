---
title: Primer — Session Handoff
date: 2026-04-03
tags:
  - mwp
---

# Primer — Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.4.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists. Now includes a strategic layer with account profile framework.

## Last Completed

### Session 2026-04-03: Strategic Upgrade v2.0 — Phase 1a + 1b

**Objective:** Add strategic guidance layer to the plugin. The plugin excelled at execution (tracking pipeline, campaign setup, feed optimization) but lacked account-specific strategy. Now it can differentiate "B2B SaaS with €3K/mo" from "e-commerce with €25K/mo."

**What was done (Phase 1a — v1.3.0):**
1. **Full skill review audit** — scored all 11 skills (avg 82/100), identified 6 systemic issues
2. **Fixed all 6 systemic issues:**
   - Added `argument-hint` frontmatter to 9 skills
   - Replaced `[bracket]` → `{{placeholder}}` syntax in all output templates
   - Added inter-skill cross-references to 6 skills (skill flow graph)
   - Fixed dependency maps in both CONTEXT.md files
   - Added `$ARGUMENTS` handling to budget-optimizer + campaign-cleanup
   - **Redesigned live-report** (62/100 → 85+): GAQL mapping, MCP tool mapping, error handling, companion reference file
3. **Fixed Findings #3 + #4** partially: added troubleshooting sections, inter-skill routing, data sufficiency handling

**What was done (Phase 1b — v1.4.0):**
4. **8 new strategic reference docs** in `reference/platforms/google-ads/strategy/`:
   - `account-profiles.md` — 10-dimension tiered framework, 15 strategy archetypes
   - `account-maturity-roadmap.md` — 4-stage progression with graduation criteria
   - `vertical-ecommerce.md` — feed-centric, ROAS-driven playbook
   - `vertical-lead-gen.md` — CPA-driven, call tracking playbook
   - `vertical-b2b-saas.md` — long-cycle, offline conversion playbook
   - `vertical-local-services.md` — location-bound, call-first playbook
   - `targeting-framework.md` — all audience types, remarketing matrix
   - `attribution-guide.md` — 6 models, CPA vs CAC, profit-based metrics
5. **Enhanced 3 existing reference docs** with account-profile-aware sections:
   - `bidding-strategies.md` — maturity/volume bid strategy table, learning period tactics
   - `account-structure.md` — maturity + budget tier structure tables
   - `campaign-types.md` — vertical + maturity campaign mix tables
6. **Updated routing tables and CHANGELOG**

**Key files created/modified:**
- 8 new files in `reference/platforms/google-ads/strategy/`
- 1 new file: `skills/live-report/references/report-templates.md`
- 15 modified SKILL.md files
- 3 spec/plan docs in `docs/superpowers/`
- Both CONTEXT.md files, CHANGELOG.md

### Prior sessions
- **2026-04-02:** MCP reconnection after machine migration
- **2026-04-01:** Feed-only PMax knowledge gap fix, MCP server built + verified, fact-check sweep

## Current State

### Plugin (ad-platform-campaign-manager)
- **30 reference files** under `platforms/google-ads/` (was 22; +8 strategy docs)
- **17 script docs** under `reference/scripts/`
- **6 tracking-bridge docs** (the differentiator)
- **5 reporting docs** + **3 MCP docs** + **1 repos catalog**
- **11 skills** — all with argument-hints, inter-skill refs, {{placeholder}} syntax
- **2 agents** (campaign-reviewer, tracking-auditor)
- All reference docs fact-checked to 2025-2026 accuracy
- **Skill quality:** avg 82/100 → improved (live-report redesigned, systemic fixes applied)

### MCP Server (google-ads-mcp-server)
- **33 Python files**, **96 tests**, clean git
- **25 MCP tools** (3 session + 9 read + 11 write + 2 confirm)
- Connected to MCC 7244069584 via Explorer Access (2,880 ops/day)
- Write passphrase: `voxxy-writes`
- Credentials at `C:\Users\VCL1\google-ads.yaml`
- Wrapper at `C:\mcp\google-ads.cmd`

### Credential Files (DO NOT COMMIT)
- `C:\Users\VCL1\google-ads.yaml` — developer token, OAuth client ID/secret, refresh token, login_customer_id
- `C:\mcp\google-ads.cmd` — wrapper script (no secrets, just paths)
- `C:\Users\VCL1\Voxxy Creative Lab Limited\08 - Projects\0007 - Claude Files\GCS - Google Ads - Client Secret.json` — OAuth JSON backup

## What Still Needs to Happen

### Phase 1c — Skill Strategy Hooks (next up)

Wire the new strategic reference docs into the 4 key skills. Fix remaining Findings #3/#4.

1. **campaign-setup** — Add account profile questions in Step 1, reference `account-profiles.md`, adapt type recommendations by vertical/maturity. Add "next step" routing. Convert lecture sections to Socratic questions.
2. **keyword-strategy** — Reference `account-profiles.md` for match type progression by maturity. Add competition-level and conversion-complexity questions.
3. **budget-optimizer** — Reference `account-profiles.md` for budget-tier targets. Add maturity-aware questioning with vertical-specific benchmarks.
4. **campaign-cleanup** — Reference `account-profiles.md` for triage priority by vertical/maturity. Add diagnostic questions before prescribing.
5. Update skills/CONTEXT.md dependency maps to include `strategy/*` for these 4 skills.
6. Update CHANGELOG with v1.5.0.

### Phase 2 — Account Strategy Skill (after 1c)

New `account-strategy` skill that asks Tier 1/2/3 questions and generates tailored strategy. Enhance 5 existing skills to pull from strategy context.

### Phase 3 — Strategy Agent (after Phase 2)

New `strategy-advisor` MCP agent + 5 remaining reference docs (seasonality, remarketing, ad testing, bid adjustments, shopping feed).

## Design Documents

- **Design spec:** `docs/superpowers/specs/2026-04-03-strategic-upgrade-design.md`
- **Skill review audit:** `docs/superpowers/specs/2026-04-03-skill-review-audit.md`
- **Phase 1a plan:** `docs/superpowers/plans/2026-04-03-phase-1a-systemic-skill-fixes.md`

## Open Blockers

- **Credential rotation:** OAuth client secret should be rotated (exposed in previous session screenshot)
- **Phase 4 (Multi-platform):** not started — Meta/LinkedIn/TikTok placeholders only
