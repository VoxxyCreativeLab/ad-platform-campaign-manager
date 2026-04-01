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
