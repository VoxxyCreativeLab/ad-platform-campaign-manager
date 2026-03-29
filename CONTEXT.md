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
| Keyword planning | `skills/keyword-strategy/SKILL.md` | `reference/platforms/google-ads/match-types.md`, `audit/negative-keyword-lists.md` | PMax, tracking-bridge, reporting, mcp |
| Conversion tracking | `skills/conversion-tracking/SKILL.md` | `reference/tracking-bridge/*`, `reference/platforms/google-ads/conversion-actions.md`, `enhanced-conversions.md` | Reporting, scripts, mcp |
| Reporting pipeline | `skills/reporting-pipeline/SKILL.md` | `reference/reporting/*`, `reference/platforms/google-ads/gaql-reference.md` | Tracking-bridge, scripts, audit |
| Campaign audit | `skills/campaign-review/SKILL.md` | `reference/platforms/google-ads/audit/*`, `quality-score.md`, `bidding-strategies.md` | Tracking-bridge, reporting, scripts, mcp |
| PMax work | `skills/pmax-guide/SKILL.md` | `reference/platforms/google-ads/pmax/*`, `bidding-strategies.md` | Tracking-bridge (unless conversion setup), scripts |
| Budget / bids | `skills/budget-optimizer/SKILL.md` | `reference/platforms/google-ads/bidding-strategies.md`, `campaign-types.md` | Tracking-bridge, reporting, pmax, scripts |
| Ads Scripts | `skills/ads-scripts/SKILL.md` | `reference/scripts/catalog.md`, `reference/platforms/google-ads/ads-scripts-api.md` | Everything else |
| MCP setup | `skills/connect-mcp/SKILL.md` | `reference/mcp/*` | Everything else |
| Full campaign audit (agent) | `agents/campaign-reviewer.md` | `reference/platforms/google-ads/audit/*`, `common-mistakes.md` | Tracking-bridge, reporting, mcp |
| Tracking audit (agent) | `agents/tracking-auditor.md` | `reference/tracking-bridge/*`, `reference/platforms/google-ads/conversion-actions.md`, `enhanced-conversions.md` | Reporting, scripts, mcp |

## Shared Resources

These files are stable reference material — never overwrite during normal use:
- `reference/platforms/google-ads/` — Google Ads domain knowledge
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
Phase 1 (current): Knowledge & guidance skills — no API required
    ↓ (when client Google Ads access is available)
Phase 2: MCP API integration — connect-mcp + live-report skills
    ↓ (when expanding to other platforms)
Phase 3: Multi-platform — populate meta-ads/, linkedin-ads/, tiktok-ads/
```
