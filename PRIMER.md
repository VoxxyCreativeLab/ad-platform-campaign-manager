---
title: Primer — Session Handoff
date: 2026-04-01
tags:
  - mwp
---

# Primer — Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.1.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists.

## Last Completed

### Session 2026-04-01 (Part 3): MCP Connection Verified

**1. Fixed MCP server `tools/list` returning empty**
- Root cause: `python -m` dual-instance bug — `server.py` as `__main__` created one `mcp` instance, tool modules importing `from google_ads_mcp.server import mcp` created a second. Tools registered on the wrong instance.
- Fix: moved shared `mcp` object to `google_ads_mcp/app.py`, all modules import from there
- 96 tests still passing after fix

**2. Fixed MCP config registration**
- `~/.claude/.mcp.json` is NOT read by VS Code extension (wrong file)
- Manual edits to `~/.claude.json` get overwritten on startup
- Correct method: `claude mcp add google-ads -s user -- "C:\mcp\google-ads.cmd"`

**3. Windows path wrapper**
- Created `C:\mcp\google-ads.cmd` to avoid spaces-in-path issues
- Script `cd /d`s to server directory, runs `.venv\Scripts\python.exe -m google_ads_mcp.server`

**4. Updated LESSONS.md** with 3 new lessons (MCP config, Python `-m` bug, Windows paths)

### Session 2026-04-01 (Part 2): Custom MCP Server Built + Connected

- 32 Python files, 96 tests passing, 25 MCP tools (3 session + 9 read + 11 write + 2 confirmation)
- Three-gate safety: session passphrase lock → draft-then-confirm ChangePlans → validate_only dry-run
- Connected to MCC 7244069584 via Explorer Access (2,880 ops/day)
- Implementation plan: `docs/superpowers/plans/2026-04-01-google-ads-mcp-server.md`

### Session 2026-04-01 (Part 1): Reference Knowledge Base Overhaul

- 4 new campaign type docs (Shopping, Video, DSA, Demand Gen) — Finding #2
- Full fact-check sweep — all 17 reference docs updated to 2025-2026 accuracy

## Current State

### Plugin (ad-platform-campaign-manager)
- **21 reference files** under `platforms/google-ads/`
- **17 script docs** under `reference/scripts/`
- **6 tracking-bridge docs** (the differentiator)
- **5 reporting docs** + **3 MCP docs** + **1 repos catalog**
- **11 skills** (9 Phase 1 active + 2 Phase 2 ready to unhide)
- **2 agents** (campaign-reviewer, tracking-auditor)
- All reference docs fact-checked to 2025-2026 accuracy

### MCP Server (google-ads-mcp-server)
- **33 Python files**, **96 tests**, clean git
- **25 MCP tools** registered and verified via Claude Code
- Connected to MCC 7244069584 via Explorer Access
- Write passphrase: `voxxy-writes`
- Config: `claude mcp add google-ads -s user -- "C:\mcp\google-ads.cmd"`
- Credentials at `~/google-ads.yaml`
- Wrapper at `C:\mcp\google-ads.cmd`

### Credential Files (DO NOT COMMIT)
- `~/google-ads.yaml` — developer token, OAuth client ID/secret, refresh token, login_customer_id
- `C:\mcp\google-ads.cmd` — wrapper script (no secrets, just paths)
- `D:\Jerry\...\CLAUDE-files\GCS - Google Ads - Client Secret.json` — OAuth JSON backup

## Immediate Next Steps

1. **Rotate OAuth client secret** — exposed in previous session screenshot. GCP Console → Credentials → reset → update `~/google-ads.yaml`
2. **Unhide Phase 2 skills** — `connect-mcp` and `live-report` (set `disable-model-invocation: false`)
3. **Test live workflow** — use skills with real account data via MCP tools
4. **Tackle Finding #3** — workflow dead-ends (post-launch monitoring, actionable insights)
5. **Tackle Finding #4** — Socratic skill redesign

## Remaining Audit Findings

| # | Finding | Status |
|---|---------|--------|
| 1 | No API access | ✅ Done — MCP server built, connected, verified |
| 2 | Missing campaign types | ✅ Done |
| 3 | Workflow dead-ends | ⬜ Not started |
| 4 | Skills tell rather than ask | ⬜ Not started |

## Open Blockers

- **Credential rotation:** OAuth client secret should be rotated (exposed in previous session screenshot)
- **Phase 4 (Multi-platform):** not started — Meta/LinkedIn/TikTok placeholders only

## Session Notes

- The `__main__` vs module-name split is a classic Python gotcha — always put shared singletons in their own module
- `claude mcp add` is the only reliable way to register MCP servers (not manual JSON edits)
- Windows paths with spaces require wrapper scripts for MCP servers
- **Critical workflow:** after every `git push`, Claude must execute marketplace clone sync (git pull → uninstall → install)
