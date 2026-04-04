---
title: Primer - Session Handoff
date: 2026-04-04
tags:
  - mwp
---

# Primer - Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.7.0 (v1.8.0 in progress) - Claude Code plugin for Google Ads campaign management, built for tracking specialists.

## Last Completed

### Session 2026-04-04: Report Output Structure Design (v1.8.0)

- Brainstormed and designed a report output structure for the plugin
- Design approved by Jerry across 7 sections
- Spec written and self-reviewed: `docs/superpowers/specs/2026-04-04-report-output-structure-design.md`
- Full implementation plan saved to PLAN.md with checkboxes for each step
- **No implementation done yet** - all implementation pending for next session(s)

**Key design decisions:**
1. Reports live inside MWP client projects at `reports/{YYYY-MM-DD}/{stage}/`
2. Each date folder has CONTEXT.md (technical index) + SUMMARY.md (client-facing, auto-built)
3. 11 skills + 3 agents write to files. Only connect-mcp stays conversational-only.
4. Output Completeness Convention: hard rule, no truncation, no "etc.", fully deterministic
5. Master plugin gets 3 small changes: output pattern column, scaffold awareness, structure-reviewer whitelist
6. SUMMARY.md: no em-dashes, 3-5 lines per skill (more when strictly necessary)
7. Conversation shows 5-10 line summary + file path after each skill writes

### Prior sessions
- **2026-04-04 (earlier):** Cross-Plugin Lessons + Hierarchy Memory
- **2026-04-03:** Strategic Upgrade v2.0 - Phase 3 Complete (v1.7.0)
- **2026-04-03 (earlier):** Strategic Upgrade Phases 1a-2 (v1.3.0-v1.6.0)
- **2026-04-02:** MCP reconnection after machine migration
- **2026-04-01:** Feed-only PMax fix, MCP server built + verified, fact-check sweep

## Current State

### Plugin (ad-platform-campaign-manager)
- **35 reference files** under `platforms/google-ads/` (24 core + 11 strategy)
- **17 script docs** under `reference/scripts/`
- **6 tracking-bridge docs** (the differentiator)
- **5 reporting docs** + **3 MCP docs** + **1 repos catalog**
- **12 skills** - all with argument-hints, inter-skill refs, {{placeholder}} syntax; 10 are profile-aware
- **3 agents** (campaign-reviewer, tracking-auditor, strategy-advisor)
- All reference docs fact-checked to 2025-2026 accuracy
- All 5 audit findings resolved

### MCP Server (google-ads-mcp-server)
- **33 Python files**, **96 tests**, clean git
- **25 MCP tools** (3 session + 9 read + 11 write + 2 confirm)
- Connected to MCC 7244069584 via Explorer Access (2,880 ops/day)
- Write passphrase: `voxxy-writes`
- Credentials at `C:\Users\VCL1\google-ads.yaml`
- Wrapper at `C:\mcp\google-ads.cmd`

### Credential Files (DO NOT COMMIT)
- `C:\Users\VCL1\google-ads.yaml` - developer token, OAuth client ID/secret, refresh token, login_customer_id
- `C:\mcp\google-ads.cmd` - wrapper script (no secrets, just paths)

## What Still Needs to Happen

### Report Output Structure v1.8.0 (IN PROGRESS)

Implementation not started. Full plan with checkboxes in PLAN.md. Design spec at `docs/superpowers/specs/2026-04-04-report-output-structure-design.md`.

**Execution order:**
1. Master plugin: domain-classification.md, scaffold-project, structure-reviewer (3 files)
2. Ad-platform conventions.md (1 file - Output Completeness Convention + Report File-Writing Convention)
3. 11 skill SKILL.md files (add Report Output section with stage, summary section, 6-step write sequence)
4. 3 agent files (same report output section)
5. Root files: CONTEXT.md, CLAUDE.md (add report output routing + permanent rule)
6. CHANGELOG.md (v1.8.0 entry)
7. Verification

**Skill-to-stage mapping:**

| Skill/Agent | Stage | SUMMARY.md Section |
|---|---|---|
| campaign-review | 01-audit | Account Health |
| campaign-cleanup | 01-audit | Account Health |
| live-report | 01-audit | Account Health |
| campaign-reviewer (agent) | 01-audit | Account Health |
| tracking-auditor (agent) | 01-audit | Tracking & Launch |
| account-strategy | 02-plan | Strategy & Planning |
| keyword-strategy | 02-plan | Strategy & Planning |
| budget-optimizer | 02-plan | Strategy & Planning |
| strategy-advisor (agent) | 02-plan | Strategy & Planning |
| campaign-setup | 03-build | Campaign Build |
| pmax-guide | 03-build | Campaign Build |
| ads-scripts | 03-build | Campaign Build |
| conversion-tracking | 04-launch | Tracking & Launch |
| reporting-pipeline | 05-optimize | Optimization & Reporting |
| connect-mcp | - | - (conversational only) |

### Housekeeping
- **Rotate OAuth client secret** - exposed in previous session screenshot (2026-04-01)

### Phase 4 - Multi-Platform (not started)
- Populate `meta-ads/`, `linkedin-ads/`, `tiktok-ads/` directories

### Real Client Work
- Use skills and agents on live Google Ads accounts

## Design Documents

- **Report output structure spec:** `docs/superpowers/specs/2026-04-04-report-output-structure-design.md`
- **Phase 3 design spec:** `docs/superpowers/specs/2026-04-03-phase-3-strategy-agent-design.md`
- **Phase 2 design spec:** `docs/superpowers/specs/2026-04-03-strategic-upgrade-design.md`
- **Skill review audit:** `docs/superpowers/specs/2026-04-03-skill-review-audit.md`

## Open Blockers

- **Credential rotation:** OAuth client secret should be rotated
- **Phase 4 (Multi-platform):** not started
