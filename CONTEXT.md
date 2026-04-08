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
| New campaign | `skills/campaign-setup/SKILL.md` | `reference/platforms/google-ads/campaign-types.md`, `account-structure.md`, `match-types.md`, `bidding-strategies.md`, `ad-extensions.md`, `ad-testing-framework.md`, `strategy/account-profiles.md`, `strategy/remarketing-strategies.md`, `shopping-feed-strategy.md` (if Shopping/PMax) | PMax refs (unless PMax), tracking-bridge, reporting |
| Keyword planning | `skills/keyword-strategy/SKILL.md` | `reference/platforms/google-ads/match-types.md`, `audit/negative-keyword-lists.md`, `account-structure.md`, `strategy/account-profiles.md`, `strategy/remarketing-strategies.md` | PMax, tracking-bridge, reporting, mcp |
| Conversion tracking | `skills/conversion-tracking/SKILL.md` | `reference/tracking-bridge/*`, `reference/platforms/google-ads/conversion-actions.md`, `enhanced-conversions.md`, `consent-mode-v2.md`, `strategy/account-profiles.md`, `strategy/attribution-guide.md`, `reference/mcp/mcp-capabilities.md` | Reporting, scripts |
| Reporting pipeline | `skills/reporting-pipeline/SKILL.md` | `reference/reporting/*`, `reference/platforms/google-ads/gaql-reference.md`, `strategy/account-profiles.md` | Tracking-bridge, scripts, audit |
| Campaign audit | `skills/campaign-review/SKILL.md` | `reference/platforms/google-ads/audit/*`, `quality-score.md`, `bidding-strategies.md`, `learning-phase.md`, `ad-testing-framework.md`, `strategy/account-profiles.md`, `strategy/remarketing-strategies.md`, `strategy/bid-adjustment-framework.md`, `reference/mcp/mcp-capabilities.md` | Tracking-bridge, reporting, scripts |
| PMax work | `skills/pmax-guide/SKILL.md` | `reference/platforms/google-ads/pmax/*`, `bidding-strategies.md`, `learning-phase.md`, `shopping-feed-strategy.md`, `strategy/account-profiles.md`, `reference/mcp/mcp-capabilities.md` | Tracking-bridge (unless conversion setup), scripts |
| Feed-only PMax / Shopping restructure | `skills/pmax-guide/SKILL.md` | `reference/platforms/google-ads/pmax/feed-only-pmax.md`, `pmax/feed-optimization.md`, `pmax/audience-signals.md`, `shopping-campaigns.md`, `learning-phase.md` | asset-requirements (unless adding creative), tracking-bridge, scripts |
| Budget / bids | `skills/budget-optimizer/SKILL.md` | `reference/platforms/google-ads/bidding-strategies.md`, `learning-phase.md`, `campaign-types.md`, `account-structure.md`, `audit/common-mistakes.md`, `strategy/account-profiles.md`, `strategy/account-maturity-roadmap.md`, `strategy/bid-adjustment-framework.md`, `strategy/seasonal-planning.md`, `reference/mcp/mcp-capabilities.md` | Tracking-bridge, reporting, pmax, scripts |
| Ads Scripts | `skills/ads-scripts/SKILL.md` | `reference/scripts/catalog.md`, `reference/platforms/google-ads/ads-scripts-api.md`, `strategy/account-profiles.md` | Everything else except strategy |
| Account cleanup | `skills/campaign-cleanup/SKILL.md` | `reference/platforms/google-ads/audit/*`, `common-mistakes.md`, `negative-keyword-lists.md`, `account-structure.md`, `strategy/account-profiles.md` | Tracking-bridge, reporting, scripts, mcp |
| Post-launch monitoring | `skills/post-launch-monitor/SKILL.md` | `reference/platforms/google-ads/strategy/post-launch-playbook.md`, `learning-phase.md`, `bidding-strategies.md`, `reference/mcp/mcp-capabilities.md` | Tracking-bridge, scripts |
| Live reports | `skills/live-report/SKILL.md` | `reference/reporting/gaql-query-templates.md`, `gaql-reference.md`, `reference/mcp/mcp-capabilities.md` | Everything except reporting |
| MCP setup | `skills/connect-mcp/SKILL.md` | `reference/mcp/*` | Everything else |
| Ad copy generation | `skills/ad-copy/SKILL.md` | `reference/platforms/google-ads/ad-copy-framework.md`, `ad-testing-framework.md`, `ad-extensions.md`, `pmax/asset-requirements.md`, `shopping-feed-strategy.md`, `strategy/account-profiles.md` | Tracking-bridge, reporting, scripts, mcp |
| Account strategy | `skills/account-strategy/SKILL.md` | `reference/platforms/google-ads/strategy/*`, `campaign-types.md`, `bidding-strategies.md` | Scripts, mcp, reporting |
| Full campaign audit (agent) | `agents/campaign-reviewer.md` | `reference/platforms/google-ads/audit/*`, `common-mistakes.md`, `learning-phase.md`, `ad-testing-framework.md`, `strategy/remarketing-strategies.md`, `strategy/bid-adjustment-framework.md` | Tracking-bridge, reporting, mcp |
| Strategy validation (agent) | `agents/strategy-advisor.md` | `reference/platforms/google-ads/strategy/*`, `campaign-types.md`, `bidding-strategies.md`, `shopping-feed-strategy.md`, `ad-testing-framework.md` | Scripts, mcp config, tracking-bridge |
| Tracking audit (agent) | `agents/tracking-auditor.md` | `reference/tracking-bridge/*`, `reference/platforms/google-ads/conversion-actions.md`, `enhanced-conversions.md` | Reporting, scripts, mcp |
| Report output conventions | `_config/conventions.md` | Sections: Output Completeness Convention, Report File-Writing Convention | — |
| File a plugin issue / check backlog | `BACKLOG.md` | `/project-structure-and-scaffolding-plugin:plugin-backlog` | — |

## Shared Resources

These files are stable reference material — never overwrite during normal use:
- `reference/platforms/google-ads/` — Google Ads domain knowledge (includes `strategy/` subdirectory with account profiles, vertical playbooks, targeting, attribution, bid adjustments, remarketing, seasonal planning; plus core docs for feed strategy and ad testing)
- `reference/tracking-bridge/` — GTM/sGTM/BQ ↔ Google Ads pipeline docs
- `reference/reporting/` — GAQL, BigQuery, dbt, Looker Studio patterns
- `reference/mcp/` — MCP server setup and comparison

> [!info] Report Output
> All report-producing skills and agents follow the 6-step write sequence defined in [[_config/conventions#Report File-Writing Convention]] when running inside an MWP client project. Each skill's `## Report Output` section specifies its stage and SUMMARY.md mapping.

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
| skills/ | `reference/` (via relative paths in SKILL.md) | `reports/{YYYY-MM-DD}/{stage}/` in MWP projects, conversation fallback otherwise |
| agents/ | `reference/` (via agent definitions) | `reports/{YYYY-MM-DD}/{stage}/` in MWP projects, conversation fallback otherwise |

---

## Phase Map

```
Phase 1 (done): Knowledge & guidance skills — no API required
    ↓
Phase 2 (done): Content completion & MCP prep — scripts, repos, fact-check sweep
    ↓
Phase 3 (done): MCP API integration — 25 tools via custom google-ads-mcp-server
    ↓ (reconnected after machine migration 2026-04-02)
Strategic Upgrade v2.0 (done): Account profiles, strategy docs, skill hooks, strategy-advisor agent
    ↓
Phase 4: Multi-platform — populate meta-ads/, linkedin-ads/, tiktok-ads/
```
