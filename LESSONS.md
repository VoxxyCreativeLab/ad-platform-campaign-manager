---
title: Lessons Learned
date: 2026-03-31
tags:
  - mwp
---

# Lessons Learned

Campaign management and plugin development lessons captured over time. Each entry includes the date, context, and takeaway.

## Plugin Development

- **2026-03-31** — Marketplace clone sync is the #1 recurring failure mode. After pushing new skills to GitHub, you must manually update the local marketplace clone: `cd ~/.claude/plugins/marketplaces/{plugin-name}/` → `git pull` → `claude plugin uninstall` → `claude plugin install` → VSCode `Ctrl+Shift+P` → Reload Window. Skipping any step means Claude won't see your changes.
- **2026-03-31** — `marketplace.json` must use the `plugins[]` array with `source` field. Custom `skills[]` arrays are silently ignored.
- **2026-03-31** — `disable-model-invocation: true` in skill frontmatter hides the skill from model discovery entirely. Use for Phase 2+ skills that aren't ready yet. Set to `false` to make them visible.
- **2026-03-31** — VSCode extension requires a full window reload (`Ctrl+Shift+P` → `Developer: Reload Window`) after plugin install. Opening new tabs or restarting terminals is not enough.
- **2026-03-31** — Skill names must be globally unique across ALL installed plugins. Prefix with plugin name to prevent collisions.
- **2026-03-31** — Claude (the AI) MUST run the marketplace clone sync as part of every commit+push workflow, NOT just remind the user to do it manually. The sync commands (`git pull` marketplace clone → `claude plugin uninstall` → `claude plugin install`) must be executed by Claude immediately after `git push`, in the same workflow. Telling the user "don't forget to sync" is not acceptable — the user asked Claude to handle the full process. If Claude cannot execute the sync commands (e.g. plan mode), it must flag this as a blocker before pushing.

## MCP Server Development

- **2026-04-01** — Google's own MCP server (`googleads/google-ads-mcp`) is deliberately read-only. ~70% of all Google Ads MCP repos are read-only. Write operations through LLM-controlled tools are high-risk. Always implement a multi-gate safety architecture for write operations.
- **2026-04-01** — The #1 costly error in Google Ads API work is micros confusion (1,000,000 micros = 1 EUR). Accept human currency only, convert internally, reject values > 10,000 as likely raw micros.
- **2026-04-01** — Draft-then-confirm with `ChangePlan` objects + `validate_only` dry-runs + stale-state re-reads before mutation is the gold-standard safety pattern. Learned from `kLOsk/adloop` and `TheMattBerman/google-ads-copilot`.
- **2026-04-01** — Session passphrase write lock is an effective additional gate. Even if Claude calls a write tool, it cannot execute without the user first unlocking writes for the session.
- **2026-04-01** — The `mcp` Python SDK requires `async def` for tool handlers, but synchronous Google Ads API calls work fine inside them. The `async` is cosmetic — no event loop complexity needed.
- **2026-04-01** — MCP server config: use `claude mcp add <name> -s user -- <command>` to register. This writes to `~/.claude.json` `mcpServers`. Do NOT manually edit `~/.claude/.mcp.json` (not read by VS Code extension) or `~/.claude.json` directly (gets overwritten on startup).
- **2026-04-01** — Python `-m` module bug: when `server.py` defines a shared object (like `mcp = FastMCP(...)`) and is also the `__main__` entrypoint, `from package.server import obj` creates a SECOND instance. Fix: move the shared object to its own module (e.g., `app.py`) so all imports resolve to the same object. Classic `__main__` vs module-name split.
- **2026-04-01** — On Windows, MCP server paths with spaces break shell spawning. Use a wrapper `.cmd` script in a clean path (e.g., `C:\mcp\google-ads.cmd`) that `cd /d` to the real directory and runs the command.
- **2026-04-01** — Explorer Access (2,880 ops/day) is auto-granted with no application. Sufficient for interactive Claude use. Try this before applying for Basic/Standard access.
- **2026-04-01** — Google Ads API version must match the `google-ads` Python client library. Library v30.0.0 ships v20-v23 only. Always check available versions with `pkgutil.iter_modules(google.ads.googleads.__path__)` before hardcoding.
- **2026-04-01** — Never share OAuth client secrets in screenshots or conversation. If exposed, rotate immediately in GCP Console → Credentials → Reset Secret.

## Campaign Strategy

_(No entries yet)_

## Keyword Management

_(No entries yet)_

## Bidding & Budget

_(No entries yet)_

## Performance Max

_(No entries yet)_

## Conversion Tracking

_(No entries yet)_

## Reporting & Analytics

_(No entries yet)_

## Client Management

_(No entries yet)_
