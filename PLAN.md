---
title: "Plan — Ad Platform Campaign Manager"
date: 2026-03-28
tags:
  - mwp
  - plan
---

# Plan — Ad Platform Campaign Manager

**Last updated:** 2026-03-29
**Current milestone:** Phase 1 — Knowledge & Guidance

---

## Project Overview

Claude Code plugin providing campaign management guidance for Google Ads. Phase 1 delivers knowledge-based skills (no API). Phase 2 adds live API integration via MCP. Phase 3 expands to multi-platform (Meta, LinkedIn, TikTok).

---

## Phases & Status

| Phase | Name | Status | Notes |
|-------|------|--------|-------|
| 1 | Knowledge & Guidance | ✅ Done | 8 skills, 37 reference files, 2 agents, config complete |
| 2 | MCP API Integration | ⬜ Not started | Blocked until Google Ads API credentials obtained |
| 3 | Multi-Platform | ⬜ Not started | Populate meta-ads/, linkedin-ads/, tiktok-ads/ |

## Stages & Status

| Stage | Name | Status | Notes |
|-------|------|--------|-------|
| 01 | Reference | ✅ Done | 37 files across 6 subdirectories |
| 02 | Skills | ✅ Done | 10 skills (8 Phase 1 + 2 Phase 2 defined) |
| 03 | Agents | ✅ Done | 2 agents (campaign-reviewer, tracking-auditor) |

**Status key:** ⬜ Not started · 🔄 In progress · ✅ Done · ⚠️ Blocked

---

## Current Focus

**Active phase:** Phase 1 complete — awaiting Phase 2 unblock
**What's done:** All 8 Phase 1 skills active. 37 reference files, 2 agents, config (conventions + quality criteria) complete. Phase 2 skills (`connect-mcp`, `live-report`) fully defined but not testable yet.
**Blockers:** Phase 2 blocked on Google Ads API credentials

---

## Decisions Made

- 2026-03-28 — Google Ads only for Phase 1; multi-platform deferred to Phase 3
- 2026-03-28 — tracking-bridge/ is the differentiator vs generic campaign tools
- 2026-03-28 — Skills load reference docs selectively (never dump full tree into context)
- 2026-03-28 — MWP overlay mode chosen (plugin directory structure is convention-locked)

---

## Next Steps

1. **Test skills** — invoke each `/ad-platform-campaign-manager:*` skill and verify it loads correctly with reference docs
2. **Real client work** — use `campaign-setup` and `conversion-tracking` on a live Google Ads account
3. **Obtain API credentials** — Google Ads developer token + OAuth client ID/secret + refresh token to unblock Phase 2
4. **Test Phase 2 skills** — once credentials are obtained, test `connect-mcp` and `live-report` with live data

---

## Notes / Open Questions

- Phase 2 skills (`connect-mcp`, `live-report`) are fully defined but not testable without API credentials
- Platform placeholder directories (meta-ads/, linkedin-ads/, tiktok-ads/) contain only .gitkeep
