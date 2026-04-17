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
| PMax Guide | `/ad-platform-campaign-manager:pmax-guide` | Performance Max — feed-only PMax, full PMax, listing groups, restructuring |
| Budget Optimizer | `/ad-platform-campaign-manager:budget-optimizer` | Budget allocation and bid strategy |
| Ads Scripts | `/ad-platform-campaign-manager:ads-scripts` | Google Ads Scripts library |
| Ad Copy | `/ad-platform-campaign-manager:ad-copy` | Multilingual ad copy — RSA, extensions, PMax, Shopping titles |
| Campaign Cleanup | `/ad-platform-campaign-manager:campaign-cleanup` | Account triage for messy/neglected accounts |
| Post-Launch Monitor | `/ad-platform-campaign-manager:post-launch-monitor` | Phase-aware post-launch monitoring — learning, post-learning, Month 2+ |
| Product Performance | `/ad-platform-campaign-manager:product-performance` | Product-level Shopping and PMax analysis — zombie products, top converters, feed optimization candidates |

## Phase 2 — API Integration (MCP connected — skills hidden until unhidden)

| Skill | Command | Purpose |
|-------|---------|---------|
| Connect MCP | `/ad-platform-campaign-manager:connect-mcp` | Set up MCP connection to Google Ads API |
| Live Report | `/ad-platform-campaign-manager:live-report` | Pull live data and generate reports |

## Strategic Layer

| Skill / Agent | Command / Agent | Purpose |
|-------|---------|---------|
| Account Strategy | `/ad-platform-campaign-manager:account-strategy` | Interactive 10-dimension account profiling → strategy document |
| Strategy Advisor | `strategy-advisor` agent | Validates live account state against strategy profile — scored gap analysis |

## Agents

| Agent | Purpose |
|-------|---------|
| `campaign-reviewer` | Automated campaign audit with scored report |
| `tracking-auditor` | Conversion tracking pipeline audit (Ads ↔ GTM/sGTM ↔ BQ) |
| `strategy-advisor` | Live account data vs strategy profile — gap analysis with prioritized actions |

## Report Output

When skills and agents run inside an MWP client project, they write deliverables to `reports/{YYYY-MM-DD}/{stage}/` instead of dumping output into conversation. Each date folder gets:

- **CONTEXT.md** — technical index for the specialist
- **SUMMARY.md** — client-facing summary (auto-built as skills run)

An Output Completeness Convention ensures all output is fully deterministic — no truncation, no `etc.`, no back-references. See `_config/conventions.md` for the full specification.

## Platform Support

- **Current:** Google Ads
- **Planned:** Meta Ads, LinkedIn Ads, TikTok Ads

## Author

Voxxy Creative Lab — MIT License
