---
title: "Ad Platform Campaign Manager — Task Router"
tags:
  - mwp
  - layer-1
---

# Context — Task Routing

## What to Load

| Task | Location | Load | Skip |
|------|----------|------|------|
| New campaign | `skills/campaign-setup/SKILL.md` | `reference/platforms/google-ads/campaign-types.md`, `account-structure.md`, `match-types.md`, `bidding-strategies.md`, `ad-extensions.md` | PMax refs (unless PMax), tracking-bridge, reporting |
| Keyword planning | `skills/keyword-strategy/SKILL.md` | `reference/platforms/google-ads/match-types.md`, `audit/negative-keyword-lists.md`, `account-structure.md` | PMax, tracking-bridge, reporting, mcp |
| Conversion tracking | `skills/conversion-tracking/SKILL.md` | `reference/tracking-bridge/*`, `reference/platforms/google-ads/conversion-actions.md`, `enhanced-conversions.md` | Reporting, scripts, mcp |
| Reporting pipeline | `skills/reporting-pipeline/SKILL.md` | `reference/reporting/*`, `reference/platforms/google-ads/gaql-reference.md` | Tracking-bridge, scripts, audit |
| Campaign audit | `skills/campaign-review/SKILL.md` | `reference/platforms/google-ads/audit/*`, `quality-score.md`, `bidding-strategies.md` | Tracking-bridge, reporting, scripts, mcp |
| PMax work | `skills/pmax-guide/SKILL.md` | `reference/platforms/google-ads/pmax/*`, `bidding-strategies.md` | Tracking-bridge (unless conversion setup), scripts |
| Feed-only PMax / Shopping restructure | `skills/pmax-guide/SKILL.md` | `reference/platforms/google-ads/pmax/feed-only-pmax.md`, `pmax/feed-optimization.md`, `pmax/audience-signals.md`, `shopping-campaigns.md` | asset-requirements (unless adding creative), tracking-bridge, scripts |
| Budget / bids | `skills/budget-optimizer/SKILL.md` | `reference/platforms/google-ads/bidding-strategies.md`, `campaign-types.md`, `account-structure.md`, `audit/common-mistakes.md` | Tracking-bridge, reporting, pmax, scripts |
| Ads Scripts | `skills/ads-scripts/SKILL.md` | `reference/scripts/catalog.md`, `reference/platforms/google-ads/ads-scripts-api.md` | Everything else |
| Account cleanup | `skills/campaign-cleanup/SKILL.md` | `reference/platforms/google-ads/audit/*`, `common-mistakes.md`, `negative-keyword-lists.md`, `account-structure.md` | Tracking-bridge, reporting, scripts, mcp |
| Live reports | `skills/live-report/SKILL.md` | `reference/reporting/gaql-query-templates.md`, `gaql-reference.md` | Everything except reporting |
| MCP setup | `skills/connect-mcp/SKILL.md` | `reference/mcp/*` | Everything else |
| Account strategy | `skills/account-strategy/SKILL.md` (Phase 2) | `reference/platforms/google-ads/strategy/*` | Scripts, mcp, reporting |
| Full campaign audit (agent) | `agents/campaign-reviewer.md` | `reference/platforms/google-ads/audit/*`, `common-mistakes.md` | Tracking-bridge, reporting, mcp |
| Tracking audit (agent) | `agents/tracking-auditor.md` | `reference/tracking-bridge/*`, `reference/platforms/google-ads/conversion-actions.md`, `enhanced-conversions.md` | Reporting, scripts, mcp |

## Shared Resources

These files are stable reference material — never overwrite during normal use:
- `reference/platforms/google-ads/` — Google Ads domain knowledge (includes `strategy/` subdirectory with account profiles, vertical playbooks, targeting, attribution)
- `reference/tracking-bridge/` — GTM/sGTM/BQ ↔ Google Ads pipeline docs
- `reference/reporting/` — GAQL, BigQuery, dbt, Looker Studio patterns
- `reference/mcp/` — MCP server setup and comparison

---

## Pipeline Map

```
reference/ ──────────────→ skills/    (skills load reference docs on demand)
     │
     └─────────────────→ agents/    (agents load reference docs on demand)
```

**Note:** This is a dependency graph, not a sequential pipeline. Skills and agents both consume reference content independently.

---

## Inter-Stage Dependencies

| Stage | Reads From | Writes To |
|---|---|---|
| reference/ | External sources (Google Ads docs, tracking architecture) | `reference/` subdirectories |
| skills/ | `reference/` (via relative paths in SKILL.md) | Guidance output (interactive, not file-based) |
| agents/ | `reference/` (via agent definitions) | Scored audit reports (runtime output) |

---

## Phase Map

```
Phase 1 (done): Knowledge & guidance skills — no API required
    ↓
Phase 2 (done): Content completion & MCP prep — scripts, repos, fact-check sweep
    ↓
Phase 3 (done): MCP API integration — 25 tools via custom google-ads-mcp-server
    ↓ (reconnected after machine migration 2026-04-02)
Phase 4: Multi-platform — populate meta-ads/, linkedin-ads/, tiktok-ads/
```
