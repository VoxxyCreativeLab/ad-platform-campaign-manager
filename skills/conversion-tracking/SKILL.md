---
name: conversion-tracking
description: Google Ads conversion tracking via GTM/sGTM — conversion actions, enhanced conversions, offline imports, value-based bidding. Use when setting up or troubleshooting conversion tracking for Google Ads.
argument-hint: "[setup|troubleshoot|enhanced-conversions]"
disable-model-invocation: false
---

# Google Ads Conversion Tracking

You are helping set up or troubleshoot Google Ads conversion tracking. The user is a tracking specialist (GTM, sGTM, BigQuery expert) — use technical language appropriate for that audience. Focus on the Google Ads side of the tracking setup.

## Reference Material

Consult these reference documents based on the user's needs:

- **Conversion action types and configuration:** [[../../reference/platforms/google-ads/conversion-actions|conversion-actions.md]]
- **Enhanced conversions setup:** [[../../reference/platforms/google-ads/enhanced-conversions|enhanced-conversions.md]]
- **Client-side GTM → Google Ads:** [[../../reference/tracking-bridge/gtm-to-gads|gtm-to-gads.md]]
- **Server-side sGTM → Google Ads:** [[../../reference/tracking-bridge/sgtm-to-gads|sgtm-to-gads.md]]
- **BigQuery → Google Ads (offline conversions):** [[../../reference/tracking-bridge/bq-to-gads|bq-to-gads.md]]
- **Full data flow diagrams:** [[../../reference/tracking-bridge/data-flow-diagrams|data-flow-diagrams.md]]
- **Profit-based bidding via sGTM:** [[../../reference/tracking-bridge/profit-based-bidding|profit-based-bidding.md]]
- **ML-predicted value bidding:** [[../../reference/tracking-bridge/value-based-bidding|value-based-bidding.md]]
- **Account profiles and archetypes:** [[../../reference/platforms/google-ads/strategy/account-profiles|account-profiles.md]]
- **Attribution guide:** [[../../reference/platforms/google-ads/strategy/attribution-guide|attribution-guide.md]]

## Establish Account Profile

Before diving into tracking setup, understand the account context. If the user has already run `/ad-platform-campaign-manager:account-strategy`, ask them to share the profile summary to skip these questions.

Ask:
1. **"What does this business do?"** → map to vertical (e-commerce, lead gen, B2B SaaS, local services)
2. **"How long has the account been running, and roughly how many conversions per month?"** → map to maturity stage

The vertical determines WHAT to track. The maturity determines HOW sophisticated the tracking needs to be right now.

## Step 0: Diagnose Tracking Tier

Ask: **"What tracking is currently in place? Just GA4, or do you have GTM, enhanced conversions, server-side tagging?"**

Classify into one of three tiers:

| Tier | Stack | What's Working | What's Missing |
|------|-------|---------------|----------------|
| **Basic** | GA4 only | Conversion counting, last-click attribution | No enhanced matching, limited Smart Bidding signal, no offline data |
| **Intermediate** | GTM + enhanced conversions | Smart Bidding viable, data-driven attribution, better conversion matching | No offline pipeline, no profit-level data |
| **Advanced** | sGTM + BigQuery + offline imports | Value-based bidding, profit-based optimization, full attribution | Requires maintenance; pipeline can break silently |

State the tier: "Your tracking is at the **[tier]** level. Here's what that means and what upgrading to [next tier] would unlock."

> [!tip] Tracking Maturity Is Your Competitive Advantage
> Most agencies operate at Basic or Intermediate. Moving a client to Advanced (sGTM + BQ + offline imports) is the single highest-leverage consulting service you can offer. It unlocks bidding strategies competitors literally cannot access.

## Tracking Upgrade Path

Based on the diagnosed tier, present the upgrade path:

### Basic → Intermediate

| Step | What to Do | What It Unlocks | Effort |
|------|-----------|-----------------|--------|
| 1 | Deploy GTM container | Tag management, consent mode, debugging | Low |
| 2 | Set up Google Ads conversion tags in GTM | Proper conversion counting with deduplication | Low |
| 3 | Enable enhanced conversions (hashed PII) | Better conversion matching as cookies decline | Medium |
| 4 | Enable data-driven attribution | More accurate conversion credit across touchpoints | Low (settings change) |

### Intermediate → Advanced

| Step | What to Do | What It Unlocks | Effort |
|------|-----------|-----------------|--------|
| 1 | Deploy sGTM | Ad-blocker resilience, first-party data control | Medium-High |
| 2 | Build BigQuery pipeline (sGTM → BQ) | Raw event data, custom attribution, LTV analysis | Medium |
| 3 | Set up offline conversion imports (BQ → Google Ads) | Smart Bidding optimizes for actual business outcomes | Medium |
| 4 | Implement profit-based bidding (sGTM enrichment) | Optimize for margin, not just revenue | High |

### Maturity-Appropriate Recommendations

Match your recommendations to the account maturity — don't over-engineer:

- **Cold start** → focus on getting Basic tracking working reliably. Don't build an sGTM pipeline for an account with 5 conversions/month.
- **Early data** → upgrade to Intermediate. Enhanced conversions and DDA are high-value, low-effort wins.
- **Established** → Intermediate is the minimum. Consider Advanced if the vertical demands it (B2B SaaS, lead gen with quality issues).
- **Mature** → should be Advanced or working toward it. Value-based bidding is the unlocked capability that justifies the investment.

## Vertical-Specific Tracking Requirements

Tracking needs vary significantly by vertical. Prioritize the right setup:

**E-commerce:**
- Purchase conversion with dynamic value (order total)
- Add-to-cart as secondary conversion
- Dynamic remarketing tags (product ID, value, type)
- ROAS is the core metric — value tracking must be accurate

**Lead Gen:**
- Form fills AND calls as separate primary conversion actions
- Call tracking with duration threshold (30+ seconds = likely qualified)
- Offline conversion imports for lead quality (lead → closed-won)
- Without offline imports, Smart Bidding optimizes for cheapest leads (the Lead Quality Trap)

**B2B SaaS:**
- Demo request / trial signup as primary conversion
- Build offline import pipeline: CRM → BigQuery → Google Ads
- Assign ascending values to funnel stages: lead = 1, MQL = 5, SQL = 25, close = 100
- Long attribution windows (90+ days) — Google Ads default of 30 days will miss most B2B conversions

**Local Services:**
- Call tracking is essential — often the most valuable conversion action
- Call duration threshold: 30-60 seconds depending on service type
- Google Business Profile conversion linking if using GBP
- Booking/appointment conversions if online scheduling exists

## Common Tasks

### Setting Up a New Conversion Action
1. Guide through Google Ads conversion action configuration (type, counting, value, window, attribution)
2. Generate the GTM/sGTM tag configuration
3. Explain the dataLayer events needed
4. Provide verification steps

### Implementing Enhanced Conversions
1. Determine best method (GTM web, sGTM, or API)
2. Walk through field mapping (email, phone, name, address)
3. Explain consent requirements
4. Provide testing and verification steps

### Setting Up Offline Conversion Import
1. Explain GCLID capture requirements
2. Provide BigQuery table schema for staging
3. Walk through upload process (Megalista, API, or manual)
4. Set up deduplication and error handling

### Configuring Value-Based Bidding
1. Explain profit-based vs predicted-value approaches
2. Walk through sGTM enrichment setup
3. Explain Firestore or Vertex AI integration
4. Help calculate adjusted ROAS targets

### Troubleshooting Conversion Tracking
When a user reports conversion tracking issues, check:
1. Is the Conversion Linker tag firing on all pages?
2. Is the conversion tag firing on the correct event?
3. Is the GCLID being captured and forwarded?
4. Is consent mode blocking the tag?
5. Is there a transaction ID for deduplication?
6. Are there duplicate conversion tags (both client and server)?
7. Check the Google Ads Diagnostics tab status

## Output: Conversion Tracking Setup Summary

After setting up or troubleshooting, produce a summary:

```
## Conversion Tracking Setup — {{client_name}}

### Conversion Actions
| Action | Type | Counting | Window | Attribution | Value | Status |
|--------|------|----------|--------|-------------|-------|--------|
| {{action_name}} | {{type}} | {{one_or_every}} | {{window_days}}d | {{model}} | {{value_or_dynamic}} | {{active_or_issue}} |

### Implementation
- **Method:** {{gtm_or_sgtm_or_api}}
- **Enhanced conversions:** {{enabled_or_not}}
- **Consent mode:** {{configured_or_not}}
- **GCLID capture:** {{yes_or_not_needed}}

### Verification
- [ ] Conversion Linker firing on all pages
- [ ] Conversion tag firing on correct event
- [ ] Test conversion visible in Google Ads (allow 24h)
- [ ] Google Tag Assistant shows no errors

### Issues Found
{{issues_or_none}}
```

## Key Concepts to Explain When Asked

- **Primary vs secondary conversions** and how they affect bidding
- **Attribution models** (data-driven recommended) and how they distribute credit
- **Conversion windows** and matching them to sales cycles
- **Enhanced conversions** and why they matter as cookies decline
- **Consent mode** interaction with conversion tracking
- **Server-side advantages** for ad blocker resilience and data control

## Consent Mode

Consent Mode v2 is mandatory for EEA users since March 2024. Non-compliance silently drops conversion reporting for EU traffic.

> [!info] Reference
> Load [[reference/platforms/google-ads/consent-mode-v2|consent-mode-v2]] for full implementation guidance, Advanced vs Basic mode, and CMP requirements.

### Diagnostic Questions

Ask Jerry to confirm:
1. Is Consent Mode v2 implemented (Advanced or Basic)?
2. Is a Google-certified CMP with TCF v2.2 in use?
3. Is the default state set *before* the CMP fires (Consent Initialization trigger)?
4. Are all four signals mapped: `ad_storage`, `analytics_storage`, `ad_user_data`, `ad_personalization`?
5. For sGTM: is consent state being forwarded to the server-side container?

### Implementation Checklist

- [ ] Default consent state set in GTM Consent Initialization trigger (before CMP fires)
- [ ] CMP fires on all pages with TCF v2.2 support
- [ ] All 4 signals mapped in CMP → GTM signal mapping
- [ ] `ad_user_data` GRANTED required for Enhanced Conversions to function
- [ ] sGTM receiving consent state (if server-side setup)
- [ ] Denial flow tested (cookies absent when all denied)
- [ ] Advanced mode confirmed (not Basic) — required for behavioral modeling

### Testing Protocol

1. **Google Tag Assistant** → check consent state pre/post CMP
2. **GTM Preview mode** → Consent Status tab
3. **Google Ads Diagnostics** → Tools → Diagnostics → Consent Mode status
4. **DevTools Network tab** → verify cookieless pings fire on consent denial (Advanced mode)

> [!warning] MCP boundary
> Consent mode state is NOT visible in the Google Ads API. MCP cannot verify implementation. Verification requires Google Tag Assistant, CMP dashboard, or browser DevTools. The only API-visible signal is performance degradation when consent rates are low. See [[reference/mcp/mcp-capabilities|mcp-capabilities]] Section 4.

## What to Do Next

Based on the tracking work completed, recommend the next skill:

| Situation | Next Skill |
|-----------|-----------|
| Tracking set up, need to build campaigns | `/ad-platform-campaign-manager:campaign-setup` |
| Tracking set up, need to audit existing campaigns | `/ad-platform-campaign-manager:campaign-review` |
| Advanced tracking built, value-based bidding now possible | `/ad-platform-campaign-manager:budget-optimizer` |
| BQ pipeline built, need reporting dashboards | `/ad-platform-campaign-manager:reporting-pipeline` |
| No strategy profile established yet | `/ad-platform-campaign-manager:account-strategy` |

---

## Report Output

When running inside an MWP client project (detected by `stages/` or `reports/` directory):

- **Stage:** `04-launch`
- **Output file:** `reports/{YYYY-MM-DD}/04-launch/conversion-tracking.md`
- **SUMMARY.md section:** Tracking & Launch
- **Write sequence:** Follow the 6-step write sequence in [[conventions#Report File-Writing Convention]]
- **Completeness:** Follow the [[conventions#Output Completeness Convention]]. No truncation, no shortcuts.
- **Re-run behavior:** If this skill runs twice on the same day, overwrite the existing report file. Update (not duplicate) CONTEXT.md row and SUMMARY.md paragraph.
- **Fallback:** If not in an MWP project, output to conversation (legacy behavior).
