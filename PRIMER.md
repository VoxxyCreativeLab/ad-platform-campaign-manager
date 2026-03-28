# Primer — Session Handoff

> This file rewrites itself at the end of every session. Read it first to pick up where things left off.

## Active Project

**ad-platform-campaign-manager** v1.0.0 — Claude Code plugin for Google Ads campaign management.

## Last Completed

- Full plugin build: 10 skills, 2 agents, 37 reference files
- CLAUDE.md (permanent rules), CONTEXT.md files at root + 10 directory junctions
- PRIMER.md, MEMORY.sh, LESSONS.md, DESIGN.md, CHANGELOG.md created
- Plugin metadata: plugin.json, marketplace.json, README.md, .gitignore

## Next Steps

1. **Git init** — initialize repository, create initial commit
2. **Test skills** — invoke each skill and verify it loads correctly with reference docs
3. **Real client work** — start using `campaign-setup` and `conversion-tracking` when client account is available
4. **Phase 2 prep** — obtain Google Ads API developer token and OAuth credentials when ready

## Open Blockers

- **Phase 2 (MCP integration):** blocked on Google Ads API credentials — need developer token, OAuth client ID/secret, refresh token
- **Multi-platform (Phase 3):** not started — Meta/LinkedIn/TikTok reference folders are empty placeholders

## Session Notes

- Plugin designed for a tracking specialist entering campaign management — all skills teach while they help
- `tracking-bridge/` is the unique differentiator (GTM → sGTM → BQ → Google Ads pipeline docs)
- Architecture is platform-agnostic from day one — adding a new platform = populating a new `reference/platforms/` subfolder
