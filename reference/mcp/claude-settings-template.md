---
title: Claude Code MCP Settings Templates
date: 2026-03-28
tags:
  - reference
  - mcp
---

# Claude Code MCP Settings Templates

## Configuration Location

Claude Code MCP servers are configured in your settings.json.

## voxxy/google-ads-mcp-server (Custom — Read + Write + Safety)

> [!tip] Recommended
> This is the preferred server for this plugin. Writes require a session passphrase, a validate_only dry-run, and an explicit confirmation. Budget ±50% and bid +30% caps are enforced. All operations are logged to a JSON audit file.

```json
{
  "mcpServers": {
    "google-ads-custom": {
      "command": "uv",
      "args": [
        "run",
        "--project",
        "../google-ads-mcp-server",
        "python",
        "-m",
        "google_ads_mcp.server"
      ],
      "env": {
        "GOOGLE_ADS_DEVELOPER_TOKEN": "YOUR_DEVELOPER_TOKEN",
        "GOOGLE_ADS_CLIENT_ID": "YOUR_CLIENT_ID",
        "GOOGLE_ADS_CLIENT_SECRET": "YOUR_CLIENT_SECRET",
        "GOOGLE_ADS_REFRESH_TOKEN": "YOUR_REFRESH_TOKEN",
        "GOOGLE_ADS_LOGIN_CUSTOMER_ID": "YOUR_MCC_ID",
        "GOOGLE_ADS_CUSTOMER_ID": "YOUR_CUSTOMER_ID"
      }
    }
  }
}
```

**Read tools (9):**
- `list_accounts` — all accessible accounts under MCC
- `list_campaigns` — campaigns with status and budget
- `list_ad_groups` — ad groups for a campaign
- `get_campaign_metrics` — performance data (impressions, clicks, cost, conversions)
- `list_keywords` — keywords with match type and metrics
- `list_ads` — ads with performance
- `run_gaql_query` — arbitrary GAQL query
- `get_account_summary` — account-level rollup
- `list_budgets` — all campaign budgets

**Write tools (11, all gated):**
- `unlock_write_session` — set session passphrase to enable writes
- `pause_campaign` / `enable_campaign` — change campaign status
- `pause_ad_group` / `enable_ad_group` — change ad group status
- `update_campaign_budget` — change daily budget (±50% cap per operation)
- `update_keyword_bid` — change keyword CPC bid (+30% cap per operation)
- `pause_keyword` / `enable_keyword` — change keyword status
- `pause_ad` / `enable_ad` — change ad status

---

## cohnen/mcp-google-ads (Community — Full Access)

```json
{
  "mcpServers": {
    "google-ads": {
      "command": "uvx",
      "args": ["mcp-google-ads"],
      "env": {
        "GOOGLE_ADS_DEVELOPER_TOKEN": "YOUR_DEVELOPER_TOKEN",
        "GOOGLE_ADS_CLIENT_ID": "YOUR_CLIENT_ID",
        "GOOGLE_ADS_CLIENT_SECRET": "YOUR_CLIENT_SECRET",
        "GOOGLE_ADS_REFRESH_TOKEN": "YOUR_REFRESH_TOKEN",
        "GOOGLE_ADS_LOGIN_CUSTOMER_ID": "YOUR_MCC_ID",
        "GOOGLE_ADS_CUSTOMER_ID": "YOUR_CUSTOMER_ID"
      }
    }
  }
}
```

**Available tools after connection:**
- `get_campaigns` — list all campaigns with performance data
- `get_ad_groups` — list ad groups for a campaign
- `get_keywords` — list keywords with metrics
- `get_ads` — list ads with performance
- `search_google_ads` — run GAQL queries
- `create_campaign` — create new campaign
- `update_campaign` — modify campaign settings
- `create_ad_group` — create new ad group
- `add_keywords` — add keywords to ad group
- `get_search_terms` — search terms report
- And more...

## googleads/google-ads-mcp (Official — Read Only)

> [!note] Repo Change
> The official server moved from `google-marketing-solutions/google_ads_mcp` to `googleads/google-ads-mcp`. The old repo still works but the new one is canonical.

```json
{
  "mcpServers": {
    "google-ads-official": {
      "command": "uvx",
      "args": ["google-ads-mcp-server"],
      "env": {
        "GOOGLE_ADS_DEVELOPER_TOKEN": "YOUR_DEVELOPER_TOKEN",
        "GOOGLE_ADS_CLIENT_ID": "YOUR_CLIENT_ID",
        "GOOGLE_ADS_CLIENT_SECRET": "YOUR_CLIENT_SECRET",
        "GOOGLE_ADS_REFRESH_TOKEN": "YOUR_REFRESH_TOKEN",
        "GOOGLE_ADS_CUSTOMER_ID": "YOUR_CUSTOMER_ID"
      }
    }
  }
}
```

**Available tools after connection:**
- Campaign diagnostics and health checks
- Performance analytics queries
- Anomaly detection
- Natural language to GAQL conversion

## Environment Variables (Recommended)

Instead of hardcoding credentials in settings.json, use environment variables:

### Windows (PowerShell)
```powershell
[System.Environment]::SetEnvironmentVariable("GOOGLE_ADS_DEVELOPER_TOKEN", "your_token", "User")
[System.Environment]::SetEnvironmentVariable("GOOGLE_ADS_CLIENT_ID", "your_client_id", "User")
[System.Environment]::SetEnvironmentVariable("GOOGLE_ADS_CLIENT_SECRET", "your_secret", "User")
[System.Environment]::SetEnvironmentVariable("GOOGLE_ADS_REFRESH_TOKEN", "your_refresh_token", "User")
[System.Environment]::SetEnvironmentVariable("GOOGLE_ADS_CUSTOMER_ID", "your_customer_id", "User")
```

Then reference in settings.json:
```json
{
  "mcpServers": {
    "google-ads": {
      "command": "uvx",
      "args": ["mcp-google-ads"],
      "env": {}
    }
  }
}
```
The MCP server will read from system environment variables automatically.

## Project-Level Configuration (.mcp.json)

Instead of configuring MCP servers globally in settings.json, you can create a `.mcp.json` file in your project root. This is useful when different projects use different Google Ads accounts.

```json
{
  "mcpServers": {
    "google-ads-custom": {
      "command": "uv",
      "args": [
        "run",
        "--project",
        "../google-ads-mcp-server",
        "python",
        "-m",
        "google_ads_mcp.server"
      ],
      "env": {
        "GOOGLE_ADS_DEVELOPER_TOKEN": "${GOOGLE_ADS_DEVELOPER_TOKEN}",
        "GOOGLE_ADS_CLIENT_ID": "${GOOGLE_ADS_CLIENT_ID}",
        "GOOGLE_ADS_CLIENT_SECRET": "${GOOGLE_ADS_CLIENT_SECRET}",
        "GOOGLE_ADS_REFRESH_TOKEN": "${GOOGLE_ADS_REFRESH_TOKEN}",
        "GOOGLE_ADS_LOGIN_CUSTOMER_ID": "${GOOGLE_ADS_LOGIN_CUSTOMER_ID}",
        "GOOGLE_ADS_CUSTOMER_ID": "1234567890"
      }
    },
    "google-ads-official": {
      "command": "uvx",
      "args": ["google-ads-mcp-server"],
      "env": {
        "GOOGLE_ADS_DEVELOPER_TOKEN": "${GOOGLE_ADS_DEVELOPER_TOKEN}",
        "GOOGLE_ADS_CLIENT_ID": "${GOOGLE_ADS_CLIENT_ID}",
        "GOOGLE_ADS_CLIENT_SECRET": "${GOOGLE_ADS_CLIENT_SECRET}",
        "GOOGLE_ADS_REFRESH_TOKEN": "${GOOGLE_ADS_REFRESH_TOKEN}",
        "GOOGLE_ADS_CUSTOMER_ID": "1234567890"
      }
    },
    "google-ads": {
      "command": "uvx",
      "args": ["mcp-google-ads"],
      "env": {
        "GOOGLE_ADS_DEVELOPER_TOKEN": "${GOOGLE_ADS_DEVELOPER_TOKEN}",
        "GOOGLE_ADS_CLIENT_ID": "${GOOGLE_ADS_CLIENT_ID}",
        "GOOGLE_ADS_CLIENT_SECRET": "${GOOGLE_ADS_CLIENT_SECRET}",
        "GOOGLE_ADS_REFRESH_TOKEN": "${GOOGLE_ADS_REFRESH_TOKEN}",
        "GOOGLE_ADS_LOGIN_CUSTOMER_ID": "${GOOGLE_ADS_LOGIN_CUSTOMER_ID}",
        "GOOGLE_ADS_CUSTOMER_ID": "1234567890"
      }
    }
  }
}
```

> [!tip] Per-Client Setup
> For each client project directory, create a `.mcp.json` with that client's `CUSTOMER_ID`. Keep sensitive credentials in environment variables — only the account-specific customer ID goes in the file.

## Verifying Connection

After configuring, test with:
1. Start a new Claude Code conversation
2. Ask: "List my Google Ads campaigns"
3. Claude should use the MCP tool to fetch campaign data
4. If it fails, check:
   - Is `uvx` installed? (`pip install uv` or `pipx install uv`)
   - Are credentials correct?
   - Is the Google Ads API enabled in your GCP project?
   - Does the developer token have the right access level?
