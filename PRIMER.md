---
title: Primer — Session Handoff
date: 2026-04-03
tags:
  - mwp
---

# Primer — Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.7.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists. Full strategic layer complete: 10 of 12 skills profile-aware, strategy-advisor agent validates live accounts against strategy profiles.

## Last Completed

### Session 2026-04-03: Strategic Upgrade v2.0 — Phase 3 Complete (v1.7.0)

**Objective:** Complete the strategic layer with a strategy-advisor agent and 5 remaining reference docs.

**Phase 3 (v1.7.0) — Strategy Agent + 5 Reference Docs:**
- New `strategy-advisor` agent: two-mode (with/without profile), 8 scoring categories, cross-references all strategy + reference docs, prioritized actions with skill routing
- New `shopping-feed-strategy.md`: feed architecture, multi-market feeds, automation pipelines, feed health scoring, product exclusions
- New `ad-testing-framework.md`: RSA testing methodology, headline/description strategy, pinning, Ad Strength, creative iteration, AI Max
- New `strategy/bid-adjustment-framework.md`: device/geo/schedule/audience adjustments by archetype, stacking math, vertical patterns
- New `strategy/remarketing-strategies.md`: audience list design, funnel segmentation, RLSA, dynamic remarketing, cross-channel, frequency
- New `strategy/seasonal-planning.md`: annual calendars (EU/NL), vertical seasonality, ramp-up timelines, Smart Bidding seasonality adjustments
- CONTEXT.md routing updated with 5 new doc entries + strategy-advisor agent entry
- campaign-reviewer agent updated with 3 new reference doc pointers
- All root docs updated (CLAUDE.md, PLAN.md, CHANGELOG.md, DESIGN.md, README.md, START-HERE.md, plugin.json)

### Prior sessions
- **2026-04-03 (earlier):** Strategic Upgrade Phases 1a-2 (v1.3.0-v1.6.0)
- **2026-04-02:** MCP reconnection after machine migration
- **2026-04-01:** Feed-only PMax fix, MCP server built + verified, fact-check sweep

## Current State

### Plugin (ad-platform-campaign-manager)
- **35 reference files** under `platforms/google-ads/` (24 core + 11 strategy)
- **17 script docs** under `reference/scripts/`
- **6 tracking-bridge docs** (the differentiator)
- **5 reporting docs** + **3 MCP docs** + **1 repos catalog**
- **12 skills** — all with argument-hints, inter-skill refs, {{placeholder}} syntax; 10 are profile-aware
- **3 agents** (campaign-reviewer, tracking-auditor, strategy-advisor)
- All reference docs fact-checked to 2025-2026 accuracy
- All 5 audit findings resolved (Finding #1-#5)
- Strategic Upgrade v2.0 complete (all 3 phases)

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

## What Still Needs to Happen

### Housekeeping
- **Rotate OAuth client secret** — exposed in previous session screenshot (2026-04-01)

### Phase 4 — Multi-Platform (not started)
- Populate `meta-ads/`, `linkedin-ads/`, `tiktok-ads/` directories

### Real Client Work
- Use skills and agents on live Google Ads accounts

## Design Documents

- **Phase 3 design spec:** `docs/superpowers/specs/2026-04-03-phase-3-strategy-agent-design.md`
- **Phase 2 design spec:** `docs/superpowers/specs/2026-04-03-strategic-upgrade-design.md`
- **Skill review audit:** `docs/superpowers/specs/2026-04-03-skill-review-audit.md`

## Open Blockers

- **Credential rotation:** OAuth client secret should be rotated (exposed in previous session screenshot)
- **Phase 4 (Multi-platform):** not started — Meta/LinkedIn/TikTok placeholders only
