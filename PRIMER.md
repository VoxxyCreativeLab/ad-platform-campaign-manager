---
title: Primer — Session Handoff
date: 2026-04-02
tags:
  - mwp
---

# Primer — Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.2.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists.

## Last Completed

### Session 2026-04-02: MCP Reconnection After Machine Migration

**Problem:** Machine migration (2026-04-02) broke the MCP connection to the Google Ads API. The `google-ads.yaml` credential file was missing from the new machine, the MCP server was not registered in Claude Code settings, and the `start-mcp.cmd` inside the MCP server directory still had the old `D:\Jerry\...` path.

**What was done:**

1. **Diagnosed the break** — explored the MCP server directory, Claude settings, and migration backups to map what was in place vs missing
2. **Identified working components:**
   - `C:\mcp\google-ads.cmd` wrapper — already copied during migration with correct new path
   - `.venv` with all Python dependencies — intact
   - `config.yaml` with safety settings and write passphrase — intact
   - Client secret JSON — found at `0007 - Claude Files/GCS - Google Ads - Client Secret.json`
   - Tool permissions (`mcp__google-ads__list_accounts`, `mcp__google-ads__list_campaigns`) — already in `settings.json`
3. **Identified missing pieces:**
   - `~/google-ads.yaml` — credential file not backed up during migration
   - MCP server registration — `mcpServers` key absent from `~/.claude.json`
4. **Restored credentials** — Jerry provided the full `google-ads.yaml` contents (developer_token, client_id, client_secret, refresh_token, login_customer_id, use_proto_plus). Written to `C:\Users\VCL1\google-ads.yaml`
5. **Re-registered MCP server** — `claude mcp add google-ads -s user -- "C:\mcp\google-ads.cmd"` → wrote to `~/.claude.json`
6. **Pending:** Session restart required for MCP tools to become available

**Key files touched:**
- Created: `C:\Users\VCL1\google-ads.yaml` (credentials — DO NOT COMMIT)
- Modified: `C:\Users\VCL1\.claude.json` (MCP server registration)

### Prior sessions (2026-04-01)

- **Part 4:** Feed-only PMax knowledge gap fixed (reference doc, skill restructuring, blocker fix)
- **Part 3:** MCP connection verified (25 tools, three-gate safety)
- **Part 2:** Custom MCP server built (96 tests, 25 tools)
- **Part 1:** Reference knowledge base overhaul (4 campaign type docs, fact-check sweep)

## Current State

### Plugin (ad-platform-campaign-manager)
- **22 reference files** under `platforms/google-ads/`
- **17 script docs** under `reference/scripts/`
- **6 tracking-bridge docs** (the differentiator)
- **5 reporting docs** + **3 MCP docs** + **1 repos catalog**
- **11 skills** (9 Phase 1 active + 2 Phase 2 ready to unhide)
- **2 agents** (campaign-reviewer, tracking-auditor)
- All reference docs fact-checked to 2025-2026 accuracy

### MCP Server (google-ads-mcp-server)
- **33 Python files**, **96 tests**, clean git
- **25 MCP tools** (3 session + 9 read + 11 write + 2 confirm)
- Connected to MCC 7244069584 via Explorer Access (2,880 ops/day)
- Write passphrase: `voxxy-writes`
- Registration: `claude mcp add google-ads -s user -- "C:\mcp\google-ads.cmd"` → `~/.claude.json`
- Credentials at `C:\Users\VCL1\google-ads.yaml`
- Wrapper at `C:\mcp\google-ads.cmd`
- **Status after migration:** Credentials restored, server re-registered. Restart session to activate.

### Credential Files (DO NOT COMMIT)
- `C:\Users\VCL1\google-ads.yaml` — developer token, OAuth client ID/secret, refresh token, login_customer_id
- `C:\mcp\google-ads.cmd` — wrapper script (no secrets, just paths)
- `C:\Users\VCL1\Voxxy Creative Lab Limited\08 - Projects\0007 - Claude Files\GCS - Google Ads - Client Secret.json` — OAuth JSON backup

### Migration References (from `.migration/`)
- `.migration/mcp/google-ads.cmd` — wrapper script source (already copied to `C:\mcp\`)
- `.migration/claude-memories/0001-ad-platform-campaign-manager/project_mcp_connection.md` — original MCP setup documentation
- `start-mcp.cmd` inside MCP server directory — **still has old `D:\Jerry\...` path** (not used; `C:\mcp\google-ads.cmd` is the active wrapper)

## Immediate Next Steps

1. **Restart Claude Code session** — MCP tools won't load until session restart
2. **Test MCP connection** — call `list_accounts()` to verify credentials work
3. **Rotate OAuth client secret** — exposed in previous session screenshot. GCP Console → Credentials → reset → update `~/google-ads.yaml`
4. **Unhide Phase 2 skills** — `connect-mcp` and `live-report` (set `disable-model-invocation: false`)
5. **Tackle Finding #3** — workflow dead-ends (post-launch monitoring, actionable insights)
6. **Tackle Finding #4** — Socratic skill redesign
7. **Fix `start-mcp.cmd`** — update old `D:\Jerry\...` path to current location (low priority, wrapper at `C:\mcp\` is the one in use)

## Remaining Audit Findings

| # | Finding | Status |
|---|---------|--------|
| 1 | No API access | ✅ Done — MCP server built, connected, verified |
| 2 | Missing campaign types | ✅ Done |
| 3 | Workflow dead-ends | ⬜ Not started |
| 4 | Skills tell rather than ask | ⬜ Not started |
| 5 | Feed-only PMax knowledge gap | ✅ Done |

## Open Blockers

- **Credential rotation:** OAuth client secret should be rotated (exposed in previous session screenshot)
- **Session restart needed:** MCP server re-registered but tools won't load until Claude Code restarts
- **Phase 4 (Multi-platform):** not started — Meta/LinkedIn/TikTok placeholders only

## Session Notes

- `google-ads.yaml` was NOT included in the machine migration backup — must be backed up separately in future migrations (add to migration runbook)
- The `C:\mcp\google-ads.cmd` wrapper was correctly migrated and works on the new machine
- The `start-mcp.cmd` inside the MCP server directory still has the old D: path — doesn't matter because `C:\mcp\google-ads.cmd` is the active wrapper used by Claude Code
- Tool permissions in `settings.json` survived migration (already had `mcp__google-ads__*` entries)
- MCP registration goes into `~/.claude.json` (via `claude mcp add`), NOT `~/.claude/settings.json` — two different files
- Client secret JSON exists in two locations: `05 - Tracking/.../CLAUDE-files/` and `08 - Projects/0007 - Claude Files/`
- **Critical workflow:** after every `git push`, Claude must execute marketplace clone sync (git pull → uninstall → install)
