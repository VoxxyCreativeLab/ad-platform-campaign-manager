---
title: Ad Platform Campaign Manager
date: 2026-03-28
tags:
  - mwp
  - readme
---

# Ad Platform Campaign Manager

Claude Code plugin for ad platform campaign management. Built for tracking specialists (GTM/sGTM/BigQuery) who manage client ad accounts.

## Phase 1 — Knowledge & Guidance (no API required)

| Skill | Command | Purpose |
|-------|---------|---------|
| Campaign Setup | `/ad-platform-campaign-manager:campaign-setup` | Guided campaign builder with best practices |
| Keyword Strategy | `/ad-platform-campaign-manager:keyword-strategy` | Keyword research, match types, negative keywords |
| Conversion Tracking | `/ad-platform-campaign-manager:conversion-tracking` | GTM/sGTM conversion setup for Google Ads |
| Reporting Pipeline | `/ad-platform-campaign-manager:reporting-pipeline` | Google Ads to BigQuery pipelines |
| Campaign Review | `/ad-platform-campaign-manager:campaign-review` | Best-practice audit checklist |
| PMax Guide | `/ad-platform-campaign-manager:pmax-guide` | Performance Max campaign guidance |
| Budget Optimizer | `/ad-platform-campaign-manager:budget-optimizer` | Budget allocation and bid strategy |
| Ads Scripts | `/ad-platform-campaign-manager:ads-scripts` | Google Ads Scripts library |

## Phase 2 — API Integration (requires Google Ads API credentials)

| Skill | Command | Purpose |
|-------|---------|---------|
| Connect MCP | `/ad-platform-campaign-manager:connect-mcp` | Set up MCP connection to Google Ads API |
| Live Report | `/ad-platform-campaign-manager:live-report` | Pull live data and generate reports |

## Agents

| Agent | Purpose |
|-------|---------|
| `campaign-reviewer` | Automated campaign audit with scored report |
| `tracking-auditor` | Conversion tracking pipeline audit (Ads ↔ GTM/sGTM ↔ BQ) |

## Platform Support

- **Current:** Google Ads
- **Planned:** Meta Ads, LinkedIn Ads, TikTok Ads

## Author

Voxxy Creative Lab — MIT License
