---
title: "Plan — Ad Platform Campaign Manager"
date: 2026-03-28
tags:
  - mwp
  - plan
---

# Plan — Ad Platform Campaign Manager

**Last updated:** 2026-03-28
**Current milestone:** Phase 1 — Knowledge & Guidance

---

## Project Overview

Claude Code plugin providing campaign management guidance for Google Ads. Phase 1 delivers knowledge-based skills (no API). Phase 2 adds live API integration via MCP. Phase 3 expands to multi-platform (Meta, LinkedIn, TikTok).

---

## Phases & Status

| Phase | Name | Status | Notes |
|-------|------|--------|-------|
| 1 | Knowledge & Guidance | 🔄 In progress | 8 skills active, 37 reference files, 2 agents |
| 2 | MCP API Integration | ⬜ Not started | Blocked until Google Ads API credentials obtained |
| 3 | Multi-Platform | ⬜ Not started | Populate meta-ads/, linkedin-ads/, tiktok-ads/ |

## Stages & Status

| Stage | Name | Status | Notes |
|-------|------|--------|-------|
| 01 | Reference | 🔄 In progress | 37 files across 6 subdirectories |
| 02 | Skills | 🔄 In progress | 10 skills (8 Phase 1 + 2 Phase 2) |
| 03 | Agents | 🔄 In progress | 2 agents (campaign-reviewer, tracking-auditor) |

**Status key:** ⬜ Not started · 🔄 In progress · ✅ Done · ⚠️ Blocked

---

## Current Focus

**Active phase:** Phase 1 — Knowledge & Guidance
**What's happening:** All 8 Phase 1 skills are defined. Reference docs populated for Google Ads fundamentals, tracking-bridge, reporting, PMax, audit, and Ads Scripts.
**Blockers:** Phase 2 blocked on Google Ads API credentials

---

## Decisions Made

- 2026-03-28 — Google Ads only for Phase 1; multi-platform deferred to Phase 3
- 2026-03-28 — tracking-bridge/ is the differentiator vs generic campaign tools
- 2026-03-28 — Skills load reference docs selectively (never dump full tree into context)
- 2026-03-28 — MWP overlay mode chosen (plugin directory structure is convention-locked)

---

## Next Steps

1. Fill `_config/conventions.md` and `_config/quality-criteria.md` with project-specific criteria
2. Review and refine stage CONTEXT.md Process sections
3. Obtain Google Ads API credentials to unblock Phase 2
4. Build `connect-mcp` and `live-report` skills for Phase 2

---

## Notes / Open Questions

- Phase 2 skills (`connect-mcp`, `live-report`) have SKILL.md stubs but are not functional yet
- Platform placeholder directories (meta-ads/, linkedin-ads/, tiktok-ads/) contain only .gitkeep
