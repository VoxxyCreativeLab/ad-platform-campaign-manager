---
title: n8n — Tracking Pipeline Patterns
date: 2026-04-14
tags:
  - reference
  - tracking-bridge
---

# n8n — Tracking Pipeline Patterns

n8n is a workflow automation platform that acts as the **bridge layer** between third-party scheduling tools (iClosed, Calendly), CRM systems (Airtable, HubSpot), and data destinations (BigQuery, Meta CAPI). This document covers n8n patterns **specifically as they relate to tracking attribution pipelines**.

> [!info] Scope Boundary
> This document is scoped to tracking pipelines only: webhook ingestion, CRM sync, server-side conversion events, and raw event logging. Full n8n workflow automation (AI agents, multi-step business processes, content pipelines) is deferred to the future `n8n-plugin`. See [[_config/ecosystem|ecosystem.md]].

---

## Overview

In high-ticket coaching/consulting funnels, conversions happen offline — a call is booked, a strategy session occurs, and a deal closes days later. No browser session is present at conversion time. n8n bridges this gap:

```
iClosed webhook
  → n8n receives event
  → n8n routes to: Airtable (CRM) + BigQuery (raw log) + Meta CAPI (server event)
```

The critical challenge is **fbclid passthrough**: the Meta click ID from the original ad click must survive through the booking, the call, and the deal closure — so that a Purchase event sent days later can be attributed to the right ad.

---

## 4-Workflow Pattern

This pattern is designed for high-ticket coaching funnels using iClosed as the scheduler and Airtable as the CRM.

```
WF1: Call Booked   → Airtable (create/update lead record with booking + tracking data)
WF2: Call Outcome  → Airtable (update lead record with outcome + deal value)
WF3: CRM → CAPI   → Meta CAPI (send Purchase/Lead event using stored fbclid)
WF4: Events → BQ  → BigQuery (log all events for reporting)
```

### WF1: Booking → CRM

**Trigger:** iClosed webhook — `Call Booked`

**Purpose:** Capture booking data and tracking parameters at the moment of booking, when fbclid is freshest.

**n8n nodes:**
1. `Webhook` (trigger) — receives `Call Booked` event from iClosed
2. `Code` node — extract and transform: contactId, callPreviewId, bookingTime, email, phone, UTMs, fbclid from tracking object
3. `Airtable` node (Create/Update) — upsert lead record in Airtable
   - Fields: contactId, callPreviewId, email, phone, bookingTime, utmSource, utmMedium, utmCampaign, fbclid, fbclidCaptureTime

**Key field to store:** `fbclid` + `fbclidCaptureTime` (Unix ms timestamp) — required for `fbc` construction at outcome time.

**BigQuery routing:** Also fire WF4 in parallel (Airtable node → BigQuery node, or use a separate webhook path).

---

### WF2: Outcome → CRM

**Trigger:** iClosed webhook — `Call Outcome`

**Purpose:** Record the call result in the CRM. The `callOutcome` payload may not contain tracking data — this workflow retrieves it from Airtable by `contactId` correlation.

**n8n nodes:**
1. `Webhook` (trigger) — receives `Call Outcome` event from iClosed
2. `Code` node — extract: contactId, callPreviewId, outcomeType, dealValue, closerOwner, outcomeTime
3. `Airtable` node (Search) — find Airtable record where `contactId` matches
4. `Airtable` node (Update) — write outcome fields: outcomeType, dealValue, outcomeTime, closerOwner
5. `n8n` node (Execute Workflow) — trigger WF3 with the combined data (booking tracking + outcome data)

---

### WF3: CRM → Meta CAPI

**Trigger:** Called by WF2 (not a direct webhook — internal trigger)

**Purpose:** Send a server-side Purchase or Lead event to Meta CAPI using stored fbclid for attribution.

**n8n nodes:**
1. (Receives data from WF2: contactId, callPreviewId, fbclid, fbclidCaptureTime, dealValue, email, phone)
2. `Code` node — construct CAPI payload:
   - `fbc` = `fb.1.1.{fbclidCaptureTime_ms}.{fbclid}`
   - `event_id` = `callPreviewId` (unique per call — deduplication key)
   - `external_id` = SHA256(contactId)
   - `em` = SHA256(email)
   - `ph` = SHA256(phone)
3. `HTTP Request` node — POST to Meta CAPI endpoint:
   - URL: `https://graph.facebook.com/v21.0/{pixel_id}/events`
   - Method: POST
   - Body: CAPI event payload (see CAPI section below)

---

### WF4: Events → BigQuery

**Trigger:** iClosed webhook — all event types (configure multiple webhook paths or use a single router)

**Purpose:** Raw event log for reporting, debugging, and joining with Google Ads data in BigQuery.

**n8n nodes:**
1. `Webhook` (trigger) — receives any iClosed event
2. `Code` node — normalize: add `ingested_at` timestamp, standardize field names
3. `Google BigQuery` node (Insert rows) — stream into `iclosed_events_raw` table

**BigQuery schema (suggested):**

```sql
CREATE TABLE tracking.iclosed_events_raw (
  event_id        STRING,
  event_type      STRING,   -- Call Booked, Call Outcome, etc.
  contact_id      STRING,
  call_preview_id STRING,
  email           STRING,
  phone           STRING,
  outcome_type    STRING,
  deal_value      FLOAT64,
  utm_source      STRING,
  utm_medium      STRING,
  utm_campaign    STRING,
  fbclid          STRING,
  ingested_at     TIMESTAMP,
  raw_payload     JSON
)
PARTITION BY DATE(ingested_at);
```

---

## Webhook Security

### iClosed Limitation

iClosed does not support HMAC signature signing on outbound webhooks (as of 2025 — on their product roadmap). This means you cannot cryptographically verify that an incoming webhook is genuinely from iClosed.

### Practical Mitigations

| Method | n8n Support | Effectiveness |
|--------|------------|---------------|
| **Header Auth** (secret token in custom header) | Native | Medium — URL token in header is better than nothing |
| **URL token** (secret in webhook URL path) | Native (use random path) | Medium — obscures endpoint, doesn't verify sender |
| **IP whitelist** | Native | Good — restrict to iClosed outbound IPs (if published) |
| **Payload validation** | Manual (Code node) | Good — check required fields present and valid types |
| **HMAC** | Manual (requires sender support) | Best — not available from iClosed currently |

**Recommended configuration:**

```
n8n Webhook node → Header Auth
Header Name: X-IClosedWebhook-Secret
Header Value: [random 32-char secret stored in n8n credentials]
```

Configure iClosed to send this header when setting up the webhook URL. Add a validation Code node as the first step to reject requests missing the header.

---

## Meta CAPI via n8n

When using n8n to send CAPI events (WF3), configure as follows:

### Required Event Fields

```json
{
  "data": [{
    "event_name": "Purchase",
    "event_time": 1712345678,
    "action_source": "system_generated",
    "event_id": "{callPreviewId}",
    "user_data": {
      "external_id": ["{SHA256(contactId)}"],
      "em": ["{SHA256(email)}"],
      "ph": ["{SHA256(phone)}"],
      "fbc": "fb.1.1.{fbclidCaptureTime_ms}.{fbclid}"
    },
    "custom_data": {
      "currency": "EUR",
      "value": "{dealValue}"
    }
  }],
  "access_token": "{META_ACCESS_TOKEN}"
}
```

### `action_source` for Outcome Events

Use `system_generated` — the conversion event is triggered by the CRM (no user browser session present at outcome time). This is Meta's intended value for automated/offline conversions.

### `fbc` Construction

```
fbc = fb.1.{subdomainIndex}.{creationTime_ms}.{fbclid}
```

- `version` = `1` (always)
- `subdomainIndex` = `1` for `example.com`, `2` for `www.example.com`
- `creationTime_ms` = Unix timestamp in **milliseconds** when fbclid was first captured (landing page hit, NOT booking time)
- `fbclid` = raw value from URL parameter

Example: `fb.1.1.1712000000000.AbCdEfGhIjKlMnOpQrStUvWxYz1234567890`

Do NOT hash `fbc` — send as a plain string.

### Event Deduplication

- Key: `event_name` + `event_id` (case-sensitive)
- Window: 48 hours
- `event_id` = `callPreviewId` (unique per call in iClosed)
- If iClosed native CAPI also active: ensure `event_id` matches between native and n8n events, or disable native CAPI for outcome events

---

## n8n Node Reference

| Node | n8n ID | Purpose in Pipeline | Key Config |
|------|--------|--------------------|----|
| Webhook | `n8n-nodes-base.webhook` | Receive iClosed events | Auth: Header Auth; Path: random UUID |
| Airtable (action) | `n8n-nodes-base.airtable` | Create/update/search CRM records | Auth: Airtable Personal Access Token |
| Airtable Trigger | `n8n-nodes-base.airtabletrigger` | Poll Airtable for changes | Poll interval: configurable (see pricing note) |
| HTTP Request | `n8n-nodes-base.httprequest` | POST to Meta CAPI | Method: POST; Auth: Header (Bearer token) |
| Google BigQuery | `n8n-nodes-base.googlebigquery` | Insert rows to raw events table | Auth: Google Service Account or OAuth2 |
| Code | `n8n-nodes-base.code` | Transform data, hash fields, construct fbc | JavaScript (Node.js environment) |

---

## Pricing & Setup

### n8n Cloud Plans (2026)

| Plan | Price (annual) | Executions/month | Best For |
|------|---------------|-----------------|---------|
| Starter | €20/mo | 2,500 | Very low volume only |
| Pro | €50/mo | 25,000 saved | Most tracking pipelines |
| Business | €667/mo | 40,000 | High volume or self-hosted |

**Execution count warning:** One execution = one complete workflow run. If you use `Airtable Trigger` polling every 5 minutes, that consumes ~8,640 executions/month from the polling alone — exceeding Starter (2,500). Polling every 15 minutes = ~2,880 executions/month (still tight on Starter).

**Recommendation:** Use n8n Cloud Pro (€50/mo) for tracking pipelines with polling. Use webhook-based triggers wherever possible to minimize polling executions.

### Client Account Pattern

- Each client should own their n8n account (not housed in agency account)
- Advantages: client data stays in client's account, no agency dependency for billing
- Setup: client creates account, invites agency team member as collaborator
- Credentials (Meta access token, BigQuery service account, Airtable token) stored in client's n8n credentials vault

---

## Cross-References

- [[reference/tracking-bridge/iclosed-attribution|iClosed Attribution Pipeline]] — Webhook events, GTM setup, fbclid passthrough, native CAPI
- [[reference/reporting/meta-ads-bigquery|Meta Ads to BigQuery]] — BigQuery pipeline approaches for Meta data
- [[reference/reporting/cross-platform-data-model|Cross-Platform Data Model]] — join keys, lifecycle stages, fbc formula
- [[reference/platforms/google-ads/tracking-bridge/bq-to-gads|BigQuery to Google Ads]] — Offline conversion import from BQ
