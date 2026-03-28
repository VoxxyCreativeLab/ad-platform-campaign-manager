# Primer — Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.0.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists.

## Last Completed

- Full plugin build: 10 skills, 2 agents, 37 reference files, 71 files total
- Documentation layer: CLAUDE.md (permanent rules), CONTEXT.md (root + 10 junctions), PRIMER.md, MEMORY.sh, LESSONS.md, DESIGN.md, CHANGELOG.md
- CLAUDE.md rewritten to permanent-rules-only format (no navigation — that's CONTEXT.md's job)
- Removed 9 non-root CLAUDE.md files, folded useful content into CONTEXT.md files
- Created `/project-structure-and-scaffolding-plugin:docs-layer` skill — reusable across all projects
- Git initialized, committed, pushed to **VoxxyCreativeLab/ad-platform-campaign-manager** (private)
- Added "rewrite PRIMER.md before session ends" rule to CLAUDE.md

## Next Steps

1. **Test skills** — invoke each `/ad-platform-campaign-manager:*` skill and verify it loads correctly with reference docs
2. **Real client work** — start using `campaign-setup` and `conversion-tracking` when client Google Ads account is available
3. **Phase 2 prep** — obtain Google Ads API developer token + OAuth credentials for MCP integration
4. **Commit the docs-layer skill** — the new skill in `project-structure-and-scaffolding-plugin` was created but not committed/pushed to that repo

## Open Blockers

- **Phase 2 (MCP integration):** blocked on Google Ads API credentials (developer token, OAuth client ID/secret, refresh token)
- **Multi-platform (Phase 3):** not started — Meta/LinkedIn/TikTok reference folders are empty placeholders
- **docs-layer skill uncommitted** — added to `project-structure-and-scaffolding-plugin/skills/docs-layer/SKILL.md` + registered in marketplace.json, needs commit+push

## Session Notes

- User wants one CLAUDE.md at root only (permanent rules), CONTEXT.md at every important junction
- File roles are strictly separated: CLAUDE.md = identity, CONTEXT.md = routing, PRIMER.md = session state
- MEMORY.sh tested and works — prints "Not a git repository" gracefully when no .git, now shows real git context
- The `tracking-bridge/` section is the plugin's unique differentiator vs generic campaign tools
