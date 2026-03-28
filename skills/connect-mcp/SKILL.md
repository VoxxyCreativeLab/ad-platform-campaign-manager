---
name: connect-mcp
description: "[Phase 2] Configure MCP connections to Google Ads API — OAuth setup, server selection, connection verification. Use when setting up live API access."
disable-model-invocation: true
allowed-tools: "Read, Edit, Bash"
---

# Connect Google Ads MCP Server

**Phase 2 Skill** — This skill guides you through connecting Claude Code to the Google Ads API via an MCP server.

## Prerequisites

Before starting, you need:
1. A Google Ads account (or MCC account)
2. A Google Cloud Platform project
3. Google Ads API developer token

If you don't have these, this skill will guide you through obtaining them.

## Reference Material

- **MCP server comparison:** [mcp-comparison.md](../../reference/mcp/mcp-comparison.md)
- **OAuth setup guide:** [oauth-setup-guide.md](../../reference/mcp/oauth-setup-guide.md)
- **Claude settings template:** [claude-settings-template.md](../../reference/mcp/claude-settings-template.md)

## Setup Steps

### Step 1: Choose MCP Server

Present the comparison from the reference and help the user choose:
- **Read-only analysis:** google-marketing-solutions/google_ads_mcp (official, safe)
- **Full management:** cohnen/mcp-google-ads (community, read+write)
- **Both:** Install both for maximum capability

### Step 2: Set Up OAuth Credentials

Walk through the OAuth setup guide:
1. Create GCP project (or use existing)
2. Enable Google Ads API
3. Create OAuth 2.0 credentials
4. Configure consent screen
5. Generate refresh token

### Step 3: Configure Claude Code

Help the user add the MCP server to their Claude Code settings using the templates from the reference.

### Step 4: Verify Connection

Test the connection:
1. Restart Claude Code
2. Try a simple query: "List my Google Ads campaigns"
3. Verify data matches the Google Ads interface
4. Troubleshoot common issues (auth errors, API access, uvx installation)

## Security Reminders

- Never commit credentials to git
- Use environment variables for tokens
- Review API access permissions regularly
- Use read-only MCP for day-to-day analysis, full-access only when making changes
