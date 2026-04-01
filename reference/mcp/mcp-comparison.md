---
title: Google Ads MCP Server Comparison
date: 2026-03-28
tags:
  - reference
  - mcp
---

# Google Ads MCP Server Comparison

## Available MCP Servers

### voxxy/google-ads-mcp-server (Custom — Read + Write + Safety)
- **Location:** Local — `../google-ads-mcp-server/`
- **Language:** Python
- **Access:** Read + Write with three-gate safety architecture
- **Features:**
  - 9 read tools (accounts, campaigns, ad groups, metrics, keywords, ads, GAQL)
  - 11 write tools with draft-then-confirm (pause/enable, budgets, bids)
  - Session passphrase lock — writes locked by default
  - validate_only dry-run before every mutation
  - Budget ±50% / bid +30% caps, stale-state detection, REMOVE blocked
  - JSON audit log of all operations
- **Auth:** OAuth2 via google-ads.yaml or environment variables
- **Best for:** Safe campaign management from Claude Code with full audit trail

### googleads/google-ads-mcp (Official — Canonical)
- **Stars:** Active
- **URL:** github.com/googleads/google-ads-mcp
- **Language:** Python
- **Access:** Read-only (Google policy — prevents AI from accidentally modifying campaigns)
- **Features:**
  - Account diagnostics
  - Performance analytics
  - Campaign health checks
  - Anomaly detection
  - Natural language to GAQL
- **Auth:** OAuth2
- **Best for:** Safe read-only analysis and diagnostics
- **Note:** This is the new canonical location. The older `google-marketing-solutions/google_ads_mcp` repo still exists but is legacy.

### cohnen/mcp-google-ads (Community — Read + Write)
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

### grantweston/google-ads-mcp-complete (Community — Full Suite)
- **Stars:** Growing
- **URL:** github.com/grantweston/google-ads-mcp-complete
- **Language:** Python
- **Access:** Read + Write (29 tools)
- **Features:**
  - All campaign CRUD operations
  - Ad group and keyword management
  - Performance reporting
  - Budget and bid management
  - Audience and extension management
- **Auth:** OAuth2
- **Best for:** Comprehensive management when you need every operation available

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
- **Best for:** Multi-platform management (Phase 3 — when expanding beyond Google Ads)

## API Access Tiers

Before using any MCP server, you need a Google Ads API developer token. Available tiers:

| Tier | Operations/Day | Application Required | Notes |
|------|---------------|---------------------|-------|
| **Explorer Access** | 2,880 | No — automatic | New (Feb 2026). Try this first. |
| Test Account | Unlimited | No | Only works on test accounts, not real data |
| Basic Access | 15,000 | Yes | Formal review, can take weeks |
| Standard Access | 100,000 | Yes | Most common for production use |

> [!tip] Explorer Access
> Google introduced Explorer Access in February 2026. It provides 2,880 operations/day with **no formal application**. This is enough for interactive campaign management with Claude and may be all you need to get started.

## Comparison Matrix

| Feature | voxxy/google-ads-mcp-server | googleads/google-ads-mcp | cohnen/mcp-google-ads | grantweston/complete | ads-mcp |
|---------|-----------------------------|--------------------------|-----------------------|---------------------|---------|
| Read campaigns | Yes | Yes | Yes | Yes | Yes |
| Modify campaigns | Yes (gated) | No | Yes | Yes | Yes |
| Keyword management | Yes (gated) | No | Yes | Yes | Yes |
| Ad management | Yes (gated) | No | Yes | Yes | Yes |
| Budget changes | Yes (gated) | No | Yes | Yes | Yes |
| Search terms | Yes | Yes | Yes | Yes | Yes |
| GAQL support | Yes | Yes | Yes | Yes | Partial |
| Multi-platform | No | No | No | No | Yes |
| Official Google | No | Yes | No | No | No |
| Active maintenance | Yes | Yes | Yes | Active | Moderate |
| Safety architecture | Three-gate | Read-only | None | None | None |
| Audit log | Yes | No | No | No | No |
| Tool count | 20 (9R+11W) | ~10 | ~15 | 29 | 100+ |

## Recommended Setup

### Step 0: Get API Access
1. Try **Explorer Access** first — go to Google Ads → Tools → API Center
2. Explorer Access (2,880 ops/day) requires no application and works immediately
3. If you need more, apply for Basic (15,000/day) or Standard (100,000/day) access

### Phase 2A: Start Safe — Custom Server (Recommended)
1. Use `voxxy/google-ads-mcp-server` (local, read + write with safety gates)
2. Writes require session passphrase + validate_only dry-run + explicit confirm
3. Budget and bid caps prevent runaway mutations
4. Full JSON audit trail of every operation

### Phase 2B: Read-Only Fallback
1. If the custom server is unavailable, fall back to `googleads/google-ads-mcp` (official, read-only)
2. Use for diagnostics, analysis, and reporting only
3. No write access — safe but limited

### Phase 2C: Community Alternatives
1. `cohnen/mcp-google-ads` — full write access, no safety architecture
2. `grantweston/google-ads-mcp-complete` — 29 tools, no safety architecture
3. Use these only if the custom server cannot be set up — they carry higher mutation risk

### Phase 3: Multi-Platform
1. Evaluate `ads-mcp` when adding Meta/LinkedIn/TikTok
2. Or install platform-specific MCPs as they become available
