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
