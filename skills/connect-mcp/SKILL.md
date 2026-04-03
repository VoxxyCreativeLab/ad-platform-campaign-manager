---
name: connect-mcp
description: "[Phase 2] Configure MCP connections to Google Ads API — OAuth setup, server selection, connection verification. Use when setting up live API access."
argument-hint: "[account-name or MCC-ID]"
disable-model-invocation: true
---

# Connect Google Ads MCP Server

**Phase 2 Skill** — This skill guides you through connecting Claude Code to the Google Ads API via an MCP server.

## Prerequisites

Before starting, you need:
1. A Google Ads account (or MCC account)
2. A Google Cloud Platform project
3. Google Ads API developer token (Explorer Access works — no application needed)

If you don't have these, this skill will guide you through obtaining them.

## Reference Material

- **MCP server comparison:** [[../../reference/mcp/mcp-comparison|mcp-comparison.md]]
- **OAuth setup guide:** [[../../reference/mcp/oauth-setup-guide|oauth-setup-guide.md]]
- **Claude settings template:** [[../../reference/mcp/claude-settings-template|claude-settings-template.md]]

## Setup Steps

### Step 0: Get API Access (Explorer Access — fastest path)

Before anything else, check your API access level:
1. Go to Google Ads → Tools → API Center
2. Look for **Explorer Access** (2,880 ops/day, automatic — no application required)
3. If Explorer Access is available, you can proceed immediately
4. If you need more capacity later, apply for Basic (15,000/day) or Standard (100,000/day)

> [!tip] Explorer Access is enough for interactive Claude usage — running queries, pulling reports, making occasional changes.

### Step 1: Choose MCP Server

Present the comparison from the reference and help the user choose:
- **Read-only analysis:** googleads/google-ads-mcp (official, safe)
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

Two configuration options:
- **Global** (settings.json) — applies to all projects
- **Project-level** (.mcp.json in project root) — per-client configuration, useful when managing multiple Google Ads accounts

### Step 4: Verify Connection

Test the connection:
1. Restart Claude Code
2. Try a simple query: "List my Google Ads campaigns"
3. Verify data matches the Google Ads interface

### Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| `UNAUTHENTICATED` or `invalid_grant` | Refresh token expired or revoked | Re-run the OAuth flow to generate a new refresh token; ensure the consent screen is set to "Internal" or the app is verified |
| `DEVELOPER_TOKEN_NOT_APPROVED` | Developer token is still in test mode | Apply for Basic or Standard access in the Google Ads API Center; test tokens only work on accounts listed in the API Center |
| `uvx: command not found` | uv/uvx not installed or not on PATH | Install via `curl -LsSf https://astral.sh/uv/install.sh \| sh` and restart the terminal |
| MCP server starts but returns no data | Customer ID is wrong or the account has no campaigns | Verify the `customer_id` in settings matches the account (no dashes); check the Google Ads interface for at least one campaign |
| `PERMISSION_DENIED` on MCC sub-account | OAuth was authorized for the MCC but the customer ID points to a sub-account | Add `login_customer_id` set to the MCC ID alongside the sub-account `customer_id` |
| OAuth consent screen rejected | User clicked "Deny" on the Google consent screen, or the app is not verified and user chose not to proceed | For internal use: set the consent screen to "Internal" (G Workspace only). For external: click through the "unverified app" warning or submit for verification. |
| OAuth redirect URI mismatch | The redirect URI in the `credentials.json` doesn't match the one registered in GCP Console | Go to GCP Console → APIs & Credentials → OAuth 2.0 Client IDs → Authorized redirect URIs — ensure it matches exactly (including trailing slash) |
| `invalid_client` during token exchange | Client ID or secret is incorrect, or the OAuth client was deleted/recreated | Verify `client_id` and `client_secret` in `~/google-ads.yaml` match the GCP Console values; regenerate the client secret if needed |

## Security Reminders

- Never commit credentials to git — verify `.gitignore` includes `google-ads.yaml`, `credentials.json`, and any `*.secret` files
- Use environment variables for tokens when possible
- Review API access permissions regularly
- Use read-only MCP for day-to-day analysis, full-access only when making changes
- **Rotate credentials** if they were ever exposed in logs, screenshots, or conversation history
