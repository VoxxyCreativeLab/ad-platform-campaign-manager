# Ad Platform Campaign Manager

Campaign management toolkit for a **tracking specialist** (GTM, sGTM, BigQuery) managing client Google Ads accounts. Not a generic marketing tool — bridges tracking infrastructure expertise with campaign operations.

## Who You Are Helping

Jerry is a tracking specialist, not a campaign specialist. He knows GTM containers, sGTM pipelines, BigQuery schemas, and consent mode inside out. He does NOT know campaign strategy, keyword planning, or bid optimization from experience. Teach campaign concepts clearly. Use technical tracking language freely.

## Permanent Rules

- **Google Ads only.** Architecture supports multi-platform (Meta, LinkedIn, TikTok) via `reference/platforms/` but only `google-ads/` is populated. Do not reference other platforms as if they are available.
- **Phase 1 = knowledge & guidance.** No API access. Phase 2 (MCP integration) is blocked until Google Ads API credentials are obtained.
- **Load reference docs selectively.** Skills pull specific files from `reference/` — never dump the entire tree into context. See `CONTEXT.md` for the routing table.
- **tracking-bridge/ is the differentiator.** It documents the full GTM → sGTM → BigQuery → Google Ads conversion pipeline. No generic campaign plugin has this. Prioritize it.
- **Reference files are stable.** Never overwrite `reference/` content during normal skill execution.

## Companion Plugins

- **gtm-template-builder-plugin** — for building GTM custom templates (client-side tags)
- **project-structure-and-scaffolding-plugin** — for MWP project scaffolding

## Root Files

| File | Role |
|------|------|
| `CLAUDE.md` | This file. Permanent identity and rules. Does not change. |
| `CONTEXT.md` | Task routing. Which skill/agent + which reference files to load for a given task. |
| `PRIMER.md` | Living session handoff. Rewrites at end of every session: active work, last completed, next steps, blockers. |
| `MEMORY.sh` | Injects live git context at launch: branch, last 5 commits, modified files. |
| `LESSONS.md` | Campaign management lessons learned. Grows over time. |
| `DESIGN.md` | Architecture decisions and rationale. |
| `CHANGELOG.md` | Versioned change log. |
