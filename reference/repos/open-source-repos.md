---
title: Open-Source Google Ads Repositories
date: 2026-03-31
tags:
  - reference
  - repos
---

# Open-Source Google Ads Repositories

Curated list of open-source repositories relevant to Google Ads campaign management and tracking infrastructure.

## Google Ads Scripts

| Repository | Stars | Category | What it provides |
|-----------|-------|----------|-----------------|
| Brainlabs-Digital/Google-Ads-Scripts | ~145 | Monitoring, cleanup | Budget pacing, broken URLs, negative conflicts, QS tracking |
| Czarto/Adwords-Scripts | ~50 | Bidding | Day parting, bid adjustments, performance rules |
| agencysavvy/pmax | ~276 | Performance Max | Search term extraction, asset tracking, category labeling |
| pamnard/Google-Ads-Scripts | ~23 | Reporting | Weekly performance exports, formatted Google Sheets |

## MCP Servers

| Repository | Stars | Access | What it provides |
|-----------|-------|--------|-----------------|
| googleads/google-ads-mcp | Active | Read-only | Official Google server — diagnostics, analytics, GAQL, anomaly detection |
| cohnen/mcp-google-ads | ~507 | Read + Write | Community — full CRUD, keyword management, budget changes, GAQL |
| grantweston/google-ads-mcp-complete | Growing | Read + Write | Community — 29 tools, comprehensive management |
| amekala/ads-mcp | ~22 | Read + Write | Multi-platform — Google + Meta + LinkedIn + TikTok |

## Tracking Infrastructure

| Repository | Maintainer | What it provides |
|-----------|-----------|-----------------|
| google-marketing-solutions/megalista | Google | Offline conversion uploads from BigQuery to Google Ads, Meta, etc. |
| google-marketing-solutions/gps_soteria | Google | Profit-based bidding via sGTM + Firestore margin lookup |
| google-marketing-solutions/gps-phoebe | Google | Predicted LTV (pLTV) via Vertex AI for value-based bidding |

> [!tip] Tracking Bridge
> The three tracking infrastructure repos above are documented in detail in [[../tracking-bridge/profit-based-bidding|profit-based-bidding.md]], [[../tracking-bridge/value-based-bidding|value-based-bidding.md]], and [[../tracking-bridge/bq-to-gads|bq-to-gads.md]].

## CLI Tools

| Tool | Source | What it provides |
|------|--------|-----------------|
| adsctl | danielfrg/adsctl | kubectl-style CLI for Google Ads — GAQL REPL, campaign editing, multi-account, pandas output |
| gaql-cli | getyourguide/gaql-cli | GAQL-focused REPL with autocomplete, by GetYourGuide |

> [!note] No Official CLI
> Google does not provide an official CLI for Google Ads management. The tools above are community-maintained. For Claude Code integration, MCP servers are the recommended approach over CLIs.
