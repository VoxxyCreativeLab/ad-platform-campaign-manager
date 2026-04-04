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
- **2026-04-01** — Plugin installation can silently half-complete. The marketplace clone (`known_marketplaces.json`), the cache (`plugins/cache/`), and the `additionalDirectories` entry can all exist while `installed_plugins.json` and `enabledPlugins` in `settings.json` are missing. This means the plugin LOOKS installed but skills never load. Root cause: the `claude plugin install` step either failed silently, was interrupted, or was skipped during a batch install. Always verify all 5 registration points after installing: (1) `known_marketplaces.json`, (2) `plugins/cache/{name}/`, (3) `additionalDirectories` in `settings.json`, (4) `installed_plugins.json`, (5) `enabledPlugins` in `settings.json`. If skills don't appear, check `enabledPlugins` first — that's the gate.

## Third-Party Plugins

- **2026-04-04 — Superpowers plugin (v5.0.6) deprecated old slash commands.** `/brainstorm`, `/write-plan`, `/execute-plan` now show deprecation notices. Use the skill-based equivalents: `/brainstorming`, `/writing-plans`, `/executing-plans`. The old commands will be removed in the next major superpowers release. This is a third-party plugin change — no action needed in our custom plugins.

## MCP Server Development

- **2026-04-02** — Machine migration gotcha: `google-ads.yaml` (home directory credential file) is NOT covered by OneDrive sync or git. It must be backed up separately during machine migrations. The wrapper script (`C:\mcp\google-ads.cmd`), `.venv`, `config.yaml`, and even tool permissions in `settings.json` all survived — but the credential file was the single point of failure. Add `~/google-ads.yaml` to the migration runbook checklist.
- **2026-04-02** — MCP server registration (`mcpServers` in `~/.claude.json`) does NOT survive machine migration. Must re-register with `claude mcp add google-ads -s user -- "C:\mcp\google-ads.cmd"` after migration. Note: this writes to `~/.claude.json`, not `~/.claude/settings.json` — they are different files with different purposes.
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

- **2026-04-01** — Feed-only PMax is a distinct configuration from full PMax. When a client has a Merchant Center feed but no creative assets, the answer is NOT "you can't launch PMax" — it's feed-only PMax with auto-generated creative from the feed. The campaign-setup skill previously blocked this path entirely with a factually wrong blocker.
- **2026-04-01** — Account restructuring (messy Shopping+PMax → clean feed-based PMax) must be stepwise: create new PMax paused → pause overlapping Shopping → enable new PMax → monitor 2-4 weeks. Never cold-turkey. Keep old campaigns paused (not deleted) for 30 days as rollback.
- **2026-04-01** — Since late 2024, PMax is no longer auto-prioritized over Standard Shopping in auctions. Both compete on Ad Rank. Running both (70/30 or 80/20 split favoring PMax) is a viable strategy — restructuring to PMax-only is a choice, not a necessity.

## Skill Quality & Architecture

- **2026-04-03** — Full skill audit revealed 6 systemic issues across all 11 skills: missing argument-hints (9/11), wrong placeholder syntax (11/11), missing inter-skill refs (6/11), dependency map drift (2/11), missing $ARGUMENTS handling (5/11), no companion files (11/11). The live-report skill was the weakest (62/100) — essentially a table of contents with no actionable content. pmax-guide (90/100) was the gold standard: Step 0 decision tree, task-specific paths, troubleshooting table, inter-skill refs. Use pmax-guide as the template when designing or improving skills.
- **2026-04-03** — Subagent-driven development works well for mechanical skill fixes (batch frontmatter changes, add sections). Use haiku for simple edits (CONTEXT.md routing fixes), sonnet for content additions (troubleshooting tables, output templates), opus for research-heavy work (strategy reference docs). The tiering saved significant time and cost.
- **2026-04-03** — Strategy docs should use `%%fact-check: [feature] — verified [date]%%` markers on any claims tied to specific Google Ads features. Google changes features frequently — these markers create an audit trail for future fact-check sweeps.

## Strategic Layer

- **2026-04-03** — Docs-first agent development is the right pattern for knowledge-heavy agents. Writing the 5 reference docs before the strategy-advisor agent meant: (1) existing skills benefited immediately, (2) the agent had a complete knowledge base on day one, (3) no rework cycle. This mirrors Phase 1b/1c where reference docs preceded skill hooks.
- **2026-04-03** — Two-mode agents (with/without profile) provide flexibility without compromising quality. The strategy-advisor produces a full gap analysis with a profile, or a quick structural health check without one. This matches the "profile skip shortcut" pattern already in 10 skills — consistency across the plugin.

## Keyword Management

_(No entries yet)_

## Bidding & Budget

_(No entries yet)_

## Performance Max

- **2026-04-01** — Listing groups are the PMax equivalent of Shopping product groups. They control which products from the feed appear in which asset group. Critical difference from Shopping: listing groups are for inclusion/exclusion ONLY — they do NOT set bids. Without proper listing group configuration, all products dump into a single bucket — defeating the purpose of asset group segmentation.
- **2026-04-01** — Seven listing group dimension types available: ProductBrandInfo, ProductCategoryInfo, ProductChannelInfo, ProductConditionInfo, ProductCustomAttributeInfo, ProductItemIdInfo, ProductTypeInfo. Custom attributes (custom_label_0-4) are the most flexible. Google's API docs say listing groups work "best when targeting groups of products" — use item ID sparingly.
- **2026-04-01** — When creating PMax from Merchant Center Next, use Performance tab → "Create campaign" — this pre-selects PMax with the feed and is the fastest path for e-commerce clients.
- **2026-04-01** — SMEC data (4,000+ campaigns): 90% of PMax spend goes to feed-based ads (74-97% range). "There is little-to-no downside of using a feed-only campaign and little-to-no upside of using a full-asset campaign." The choice is strategic, not performance-driven.

## Conversion Tracking

_(No entries yet)_

## Reporting & Analytics

_(No entries yet)_

## Client Management

_(No entries yet)_
