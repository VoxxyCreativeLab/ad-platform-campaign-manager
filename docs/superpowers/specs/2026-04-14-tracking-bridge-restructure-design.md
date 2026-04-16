---
title: "Tracking Bridge Restructure — Design Spec"
date: 2026-04-14
tags:
  - design
  - tracking-bridge
  - iclosed
  - n8n
  - meta
---

# Tracking Bridge Restructure — Design Spec

## Context

Two reference files added in Session 3 (`iclosed-attribution.md` and `n8n-pipeline-patterns.md`) contain content that conflicts with the plugin's tracking philosophy:

1. `iclosed-attribution.md` recommends iClosed's native Meta CAPI integration and a dedicated GTM container (Scenario B) — both of which reduce tracking specialist control over consent, event selection, and deduplication. These should be reframed as warnings.
2. `n8n-pipeline-patterns.md` is over-scoped to iClosed + Airtable + Meta — it documents iClosed-specific pipeline flows that belong in the iClosed reference doc, not in a generic n8n reference.

Additionally, the "Google Ads only" rule in `CLAUDE.md` is too restrictive — the plugin's tracking-bridge naturally spans multiple platforms (Meta CAPI is required for high-ticket attribution), and `platforms/meta-ads/` already exists as a placeholder.

## Decisions Agreed

| Topic | Decision |
|-------|----------|
| iClosed flows in n8n doc | Move WF1-WF4 to `iclosed-attribution.md` |
| Non-recommended content | Keep as warnings (reframe, don't delete) |
| n8n pricing section | Remove entirely — changes too often, not our knowledge |
| Meta CAPI generic knowledge | Move to `platforms/meta-ads/capi-server-events.md` |
| "Google Ads only" rule in CLAUDE.md | Remove entirely — plugin scope is multi-platform |

## Core Principle

> All pixel and CAPI tracking — for every platform including Meta — routes through GTM. No exceptions. This ensures the tracking specialist controls consent gating, event selection, data normalization, and deduplication. Platform-native integrations (iClosed native CAPI, native pixels) are documented as **things to disable**, not things to use.

---

## Files to Change

### 1. `reference/tracking-bridge/iclosed-attribution.md` — Rewrite

**New structure:**

```
# iClosed — Tracking & Attribution Pipeline

## Overview
  What iClosed is, iframe embedding, why custom tracking is required.

## GTM Integration
  ### URL Parameter Injection
    widget.js loading, postMessage bridge (Scenario A only — this is the way).
    GTM Custom HTML tag for parent page dataLayer bridge.
  ### GA4 Cookie Configuration
    SameSite=None;Secure (needed for cross-origin iframe cookies).

## GTM DataLayer Events
  5 confirmed events table.
  Guidance: iclosed_call_scheduled is the primary conversion event.
  Warning: iclosed_potential fires twice — never use for conversions.

## Webhook Events
  12 webhook trigger types table.
  Focus note: Call Booked, Call Outcome, Contact by Status for attribution.

## fbclid Passthrough
  tracking object, utmKey_N/utmValue_N pattern (marked unverified).
  Fallback: store in CRM at booking time via WF1.

## n8n Pipeline Flows for iClosed
  ### WF1: Booking → CRM (Airtable)
    Trigger, nodes, key fields to store (fbclid + fbclidCaptureTime).
  ### WF2: Outcome → CRM (Airtable)
    Trigger, contactId correlation, what the payload may lack.
  ### WF3: CRM → Meta CAPI
    Internal trigger (from WF2), cross-ref to platforms/meta-ads/capi-server-events.md.
    contactId → SHA256(contactId), fbc construction, event_id = callPreviewId.
  ### WF4: Events → BigQuery
    Raw event log, BQ schema for iclosed_events_raw, partitioning.

## Attribution Gap: callOutcome
  Why tracking data is missing from outcome payload.
  contactId correlation workaround diagram.

## Consent Gating
  Trigger config (Custom Event + Marketing consent condition).
  Consent Mode v2 defaults.
  Iframe consideration: parent consent does not propagate into iframe.

## Platform Defaults to Override
  > [!warning] These are defaults iClosed enables. Disable them.

  ### Native Meta CAPI Integration
    What it sends (auto-captured fbc/fbp, hashed em/ph, event_id).
    Which events it fires (page view, potential, qualified, call booked).
    WHY TO DISABLE: iClosed controls consent, event selection, hashing method,
    and deduplication. You lose visibility. It cannot send outcome events anyway.
    When to use INSTEAD: n8n WF3 (full control, outcome events, custom event_id).

  ### Dedicated GTM Container (Scenario B)
    What iClosed recommends and why (easier for them to manage tag firing).
    WHY WE DON'T USE IT: you lose control of tag firing, consent gating, and
    integration with existing measurement strategy. The only valid edge case is
    an extremely fragile legacy container — even then, we own the container.

## Cross-References
```

---

### 2. `reference/tracking-bridge/n8n-pipeline-patterns.md` — Rewrite

**New structure (generic, tool-agnostic):**

```
# n8n — Tracking Pipeline Patterns

## Overview
  What n8n is, why it's used as the bridge layer.
  Core pattern: webhook in → Code node transform → route to N destinations.
  What this doc covers (webhook security, BQ streaming, node reference).
  What this doc does NOT cover: tool-specific pipeline flows.
  → See iclosed-attribution.md for iClosed-specific WF1-WF4.

## Webhook Security
  Context: most scheduling tools (including iClosed) do not support HMAC.
  Practical mitigations table (Header Auth, URL token, IP whitelist, payload validation).
  Recommended config: X-Webhook-Secret header, validation Code node first step.

## BigQuery Streaming via n8n
  Generic pattern: webhook → Code (normalize) → BigQuery Insert.
  Schema conventions: event_id, event_type, ingested_at (TIMESTAMP), raw_payload (JSON).
  Partition by DATE(ingested_at).

## n8n Node Reference
  Node table: Webhook, HTTP Request, Code, Google BigQuery, Airtable.
  Columns: n8n node ID, purpose in tracking pipelines, key config.

## Client Account Pattern
  Each client owns their n8n account (not housed in agency account).
  Advantages, setup steps, credential storage in client vault.

## Cross-References
  → iclosed-attribution.md (iClosed WF1-WF4)
  → platforms/meta-ads/capi-server-events.md (CAPI payload construction, fbc)
```

**Removed:** WF1-WF4 (→ iClosed doc), Meta CAPI payload structure (→ meta-ads doc), fbc construction (→ meta-ads doc), pricing section (dropped).

---

### 3. `reference/platforms/meta-ads/capi-server-events.md` — New File

**Structure:**

```
# Meta CAPI — Server-Side Events

## Overview
  What Meta CAPI is and when server-side events are needed.
  Key rule: route through GTM/sGTM where possible. Use n8n for offline conversions
  (no browser session at conversion time).

## Required Event Fields
  JSON payload structure.
  event_name, event_time (Unix), action_source, event_id, user_data, custom_data.

## action_source Values
  system_generated: automated/offline conversions — no user browser session.
  website: browser-present events sent server-side.

## fbc Construction
  Formula: fb.1.{subdomainIndex}.{creationTime_ms}.{fbclid}
  version = 1 always.
  subdomainIndex: 1 for root domain, 2 for www subdomain.
  creationTime_ms = landing page hit timestamp (NOT booking time).
  fbclid = raw URL parameter value.
  Do NOT hash fbc — send as plain string.

## User Data Hashing
  SHA256 for external_id, em, ph.
  Normalize before hashing: lowercase, trim whitespace.
  external_id = SHA256(contactId or internal user identifier).

## Event Deduplication
  Key: event_name + event_id (case-sensitive, 48-hour window).
  event_id should be a stable unique identifier for the event instance.
  If native platform CAPI is also active: match event_id or disable native.

## Cross-References
  → tracking-bridge/iclosed-attribution.md (iClosed-specific CAPI pipeline)
  → tracking-bridge/n8n-pipeline-patterns.md (HTTP Request node config)
```

---

### 4. `reference/tracking-bridge/CONTEXT.md` — Update

Update the file index and reading order:
- Update `iclosed-attribution.md` description (now includes n8n pipeline flows)
- Update `n8n-pipeline-patterns.md` description (now generic)
- Update reading order: "iClosed scheduling attribution" now reads `iclosed-attribution.md` → `platforms/meta-ads/capi-server-events.md`
- Add note about `platforms/meta-ads/capi-server-events.md` as a companion resource

---

### 5. `CLAUDE.md` — Remove "Google Ads only" rule

Remove: `**Google Ads only.** Architecture supports multi-platform (Meta, LinkedIn, TikTok) via \`reference/platforms/\` but only \`google-ads/\` is populated. Do not reference other platforms as if they are available.`

Replace with: `**Multi-platform tracking.** Campaign management advice is Google Ads only until other platform skills are built. The tracking-bridge and \`reference/platforms/\` may reference any platform where it appears in the conversion attribution pipeline (Meta CAPI, cross-platform BQ schemas, etc.).`

---

### 6. `reference/CONTEXT.md` (root file index) — Update

Add the 2 tracking-bridge files and the new meta-ads file to the file index under their respective sections.

---

## Verification

After implementation:
- [ ] `iclosed-attribution.md`: no mention of Scenario B as recommended, no mention of native CAPI as recommended — both appear only in the "Platform Defaults to Override" section
- [ ] `iclosed-attribution.md`: WF1-WF4 are present and complete, including BQ schema
- [ ] `n8n-pipeline-patterns.md`: no iClosed-specific content, no pricing section, cross-refs meta-ads doc
- [ ] `platforms/meta-ads/capi-server-events.md`: exists, contains fbc formula, hashing, deduplication
- [ ] `CLAUDE.md`: "Google Ads only" rule removed
- [ ] All internal `[[wikilinks]]` are valid paths
- [ ] `tracking-bridge/CONTEXT.md` reflects the new scopes of both files
