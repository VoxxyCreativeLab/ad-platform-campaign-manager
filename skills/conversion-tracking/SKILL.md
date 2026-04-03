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

## Key Concepts to Explain When Asked

- **Primary vs secondary conversions** and how they affect bidding
- **Attribution models** (data-driven recommended) and how they distribute credit
- **Conversion windows** and matching them to sales cycles
- **Enhanced conversions** and why they matter as cookies decline
- **Consent mode** interaction with conversion tracking
- **Server-side advantages** for ad blocker resilience and data control
