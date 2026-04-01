---
title: Google Ads API OAuth Setup Guide
date: 2026-03-28
tags:
  - reference
  - mcp
---

# Google Ads API OAuth Setup Guide

## Prerequisites

1. A Google Ads account (or MCC account)
2. A Google Cloud Platform (GCP) project
3. Google Ads API access (developer token)

## Step 1: Get a Developer Token

1. Log in to your Google Ads account (or MCC)
2. Go to Tools → API Center
3. If you don't have a developer token, apply for one

**Developer token levels:**

| Tier | Operations/Day | Application | Notes |
|------|---------------|-------------|-------|
| **Explorer Access** | 2,880 | **Automatic — no application** | New (Feb 2026). Try this first. |
| Test Account | Unlimited | No | Only works on test accounts, not real data |
| Basic Access | 15,000 | Yes — formal review | Can take days to weeks |
| Standard Access | 100,000 | Yes — formal review | Most common for production |

> [!tip] Start with Explorer Access
> Google introduced Explorer Access in February 2026. It provides 2,880 operations/day with **no formal application**. For interactive use with Claude (running queries, pulling reports, making occasional changes), this is plenty. You can always upgrade later.

> [!note] Cloud-Managed Access (Pilot)
> Google is piloting a **cloud-managed access** tier that eliminates developer tokens entirely if you have a Google Cloud organization. Check the Google Ads API documentation for current availability.

## Step 2: Create GCP Project & OAuth Credentials

1. Go to console.cloud.google.com
2. Create a new project (or use existing)
3. Enable the **Google Ads API**:
   - APIs & Services → Library → search "Google Ads API" → Enable
4. Create OAuth credentials:
   - APIs & Services → Credentials → Create Credentials → OAuth 2.0 Client ID
   - Application type: **Desktop app** (for MCP server)
   - Name: "Google Ads MCP"
   - Download the JSON file (client_secret.json)

## Step 3: Configure OAuth Consent Screen

1. APIs & Services → OAuth consent screen
2. User type: **External** (or Internal if using Google Workspace)
3. Fill in app information (name, email)
4. Scopes: Add `https://www.googleapis.com/auth/adwords`
5. Test users: Add your Google account email
6. Save

## Step 4: Get Refresh Token

Run the OAuth flow to get a refresh token:

```bash
# Using google-ads-python helper
pip install google-ads
python -c "
from google_auth_oauthlib.flow import InstalledAppFlow
flow = InstalledAppFlow.from_client_secrets_file(
    'client_secret.json',
    scopes=['https://www.googleapis.com/auth/adwords']
)
credentials = flow.run_local_server(port=8080)
print(f'Refresh token: {credentials.refresh_token}')
"
```

Save the refresh token securely.

## Step 5: Gather Required Values

You'll need these for MCP configuration:

| Value | Where to Find |
|-------|--------------|
| Developer token | Google Ads → Tools → API Center |
| Client ID | GCP → Credentials → OAuth 2.0 Client ID |
| Client secret | GCP → Credentials → OAuth 2.0 Client ID |
| Refresh token | From Step 4 |
| Customer ID | Google Ads → account number (XXX-XXX-XXXX, remove dashes) |
| Login customer ID | MCC account number (if using MCC) |

## Step 6: Configure MCP Server

See [[claude-settings-template]] for the Claude Code settings.json configuration.

## Security Notes

- Never commit credentials to git
- Store tokens in environment variables or a secure vault
- Refresh tokens don't expire but can be revoked
- Use a service account for production/automated access
- Limit API access to only the accounts you need
