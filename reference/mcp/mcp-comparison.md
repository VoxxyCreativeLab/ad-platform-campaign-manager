---
title: Google Ads MCP Server Comparison
date: 2026-03-28
tags:
  - reference
  - mcp
---

# Google Ads MCP Server Comparison

## Available MCP Servers

### cohnen/mcp-google-ads (Community)
- **Stars:** ~507
- **URL:** github.com/cohnen/mcp-google-ads
- **Language:** Python
- **Access:** Read + Write (full CRUD)
- **Features:**
  - Campaign information and metrics
  - Keyword management
  - Ad management
  - Budget management
  - Search terms report
  - Audience insights
  - Natural language queries to GAQL
- **Auth:** OAuth2 (service account or user credentials)
- **Best for:** Full campaign management from Claude

### google-marketing-solutions/google_ads_mcp (Official)
- **Stars:** ~141
- **URL:** github.com/google-marketing-solutions/google_ads_mcp
- **Language:** Python
- **Access:** Read-only
- **Features:**
  - Account diagnostics
  - Performance analytics
  - Campaign health checks
  - Anomaly detection
  - Natural language to GAQL
- **Auth:** OAuth2
- **Best for:** Safe read-only analysis and diagnostics

### amekala/ads-mcp (Multi-Platform)
- **Stars:** ~22
- **URL:** github.com/amekala/ads-mcp
- **Language:** Shell/Python
- **Access:** Read + Write
- **Features:**
  - Google Ads + Meta Ads + LinkedIn Ads + TikTok Ads
  - 100+ tools across platforms
  - Campaign management
  - Reporting
- **Auth:** Platform-specific OAuth
- **Best for:** Multi-platform management (when you expand beyond Google Ads)

## Comparison Matrix

| Feature | cohnen/mcp-google-ads | google_ads_mcp | ads-mcp |
|---------|----------------------|----------------|---------|
| Read campaigns | Yes | Yes | Yes |
| Modify campaigns | Yes | No | Yes |
| Keyword management | Yes | No | Yes |
| Ad management | Yes | No | Yes |
| Budget changes | Yes | No | Yes |
| Search terms | Yes | Yes | Yes |
| GAQL support | Yes | Yes | Partial |
| Multi-platform | No | No | Yes |
| Official Google | No | Yes | No |
| Active maintenance | Yes | Yes | Moderate |
| Safety (read-only) | No (write access) | Yes | No |

## Recommended Setup

### Phase 2A: Start Safe
1. Install `google_ads_mcp` (official, read-only)
2. Use for diagnostics, analysis, and reporting
3. No risk of accidental changes

### Phase 2B: Full Management
1. Add `cohnen/mcp-google-ads` for write operations
2. Use for campaign creation, keyword management, bid changes
3. Keep both installed — use official for analysis, community for actions

### Phase 3: Multi-Platform
1. Evaluate `ads-mcp` when adding Meta/LinkedIn/TikTok
2. Or install platform-specific MCPs as they become available
