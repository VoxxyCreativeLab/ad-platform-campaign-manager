---
title: n8n — Tracking Pipeline Patterns
date: 2026-04-16
tags:
  - reference
  - tracking-bridge
---

# n8n — Tracking Pipeline Patterns

n8n is a workflow automation platform that acts as the **bridge layer** between third-party scheduling tools (iClosed, Calendly), CRM systems (Airtable, HubSpot), and data destinations (BigQuery, Meta CAPI).

> [!info] Scope
> This document covers tracking pipeline patterns: webhook ingestion security, BigQuery streaming, and the n8n node reference. Tool-specific pipeline flows (e.g., iClosed WF1–WF4) live in their respective tool reference docs. Full n8n workflow automation beyond tracking is deferred to the future `n8n-plugin`. See [[_config/ecosystem|ecosystem.md]].

---

## Overview

In high-ticket funnels, conversions happen offline — a call is booked, a session occurs, and a deal closes days later. No browser session is present at conversion time. n8n bridges this gap:

```
Third-party webhook (iClosed, Calendly, etc.)
  → n8n receives event
  → Code node: transform, normalize, hash
  → Routes to: CRM + BigQuery (raw log) + Meta CAPI (server event)
```

**Core pattern:** every tracking pipeline follows the same structure regardless of source tool:

1. `Webhook` node — receives the inbound event
2. `Code` node — validates, normalizes, and transforms the payload
3. One or more destination nodes — CRM write, BQ insert, CAPI POST, or internal workflow trigger

---

## Webhook Security

Most scheduling tools (including iClosed) do not support HMAC signature signing on outbound webhooks. You cannot cryptographically verify the sender — mitigate with layered controls instead.

| Method | n8n Support | Effectiveness |
|--------|------------|---------------|
| **Header Auth** (secret token in custom header) | Native | Medium |
| **URL token** (random secret embedded in webhook path) | Native | Medium — obscures endpoint |
| **IP whitelist** (restrict to sender's published IPs) | Native | Good — if sender publishes IPs |
| **Payload validation** (check required fields + types in Code node) | Manual (Code node) | Good — rejects malformed requests |
| **HMAC** (cryptographic signature verification) | Manual (requires sender support) | Best — rarely available |

**Recommended configuration:**

```
n8n Webhook node → Header Auth
Header Name:  X-Webhook-Secret
Header Value: [random 32-char secret stored in n8n credentials]
```

Configure the sending tool to include this header. Add a validation `Code` node as the **first step after the Webhook node** to reject requests where the header is missing or incorrect.

```javascript
// Validation Code node (first step)
const secret = $credentials.webhookSecret;
const incomingSecret = $input.first().headers['x-webhook-secret'];

if (incomingSecret !== secret) {
  throw new Error('Unauthorized: invalid webhook secret');
}

return $input.all();
```

---

## BigQuery Streaming via n8n

**Generic pattern for any tracking pipeline:**

```
Webhook → Code (normalize) → Google BigQuery (Insert rows)
```

### Schema Conventions

All tracking pipeline tables should follow this base schema:

```sql
CREATE TABLE tracking.{tool}_events_raw (
  event_id     STRING,      -- unique identifier for this event instance
  event_type   STRING,      -- human-readable event name (e.g., "Call Booked")
  ingested_at  TIMESTAMP,   -- when n8n received and processed the event
  raw_payload  JSON         -- full original webhook payload (for debugging)
  -- tool-specific columns added per table
)
PARTITION BY DATE(ingested_at);
```

**`event_id`:** Use a stable unique identifier from the source tool (e.g., `callPreviewId` from iClosed). If none exists, generate a UUID in the `Code` node.

**`ingested_at`:** Set in n8n's `Code` node via `new Date().toISOString()` — do not rely on the webhook delivery timestamp.

**`raw_payload`:** Store the full original payload as JSON. This enables recovery and reprocessing if downstream schema changes break parsing logic.

### Code Node Normalization

```javascript
// Normalize webhook payload before BQ insert
const payload = $input.first().json;

return [{
  json: {
    event_id:    payload.callPreviewId || generateUUID(),
    event_type:  payload.eventType || 'unknown',
    ingested_at: new Date().toISOString(),
    raw_payload: JSON.stringify(payload),
    // add tool-specific fields here
  }
}];
```

### BigQuery Node Configuration

- **Operation:** Insert rows
- **Table:** `{project}.{dataset}.{table_name}`
- **Insert Method:** Streaming insert (low latency) — use batch for high volume
- **Skip Invalid Rows:** Off (let failures surface, don't silently drop bad data)

---

## n8n Node Reference

| Node | n8n Node ID | Purpose in Tracking Pipelines | Key Config |
|------|-------------|-------------------------------|-----------|
| Webhook | `n8n-nodes-base.webhook` | Receive inbound events | Auth: Header Auth; Path: random UUID |
| HTTP Request | `n8n-nodes-base.httprequest` | POST to external APIs (Meta CAPI, etc.) | Method: POST; Auth: Bearer token |
| Code | `n8n-nodes-base.code` | Transform, normalize, validate, hash | JavaScript (Node.js environment) |
| Google BigQuery | `n8n-nodes-base.googlebigquery` | Insert rows to raw events tables | Auth: Google Service Account or OAuth2 |
| Airtable | `n8n-nodes-base.airtable` | Create/update/search CRM records | Auth: Airtable Personal Access Token |
| Airtable Trigger | `n8n-nodes-base.airtabletrigger` | Poll Airtable for record changes | Poll interval: configurable |
| Execute Workflow | `n8n-nodes-base.executeworkflow` | Trigger another n8n workflow (e.g., WF2 → WF3) | Workflow ID; wait for completion |

> [!note] Airtable Trigger polling
> The Airtable Trigger node uses polling, not webhooks. Each poll is one workflow execution. At 5-minute intervals: ~8,640 executions/month. At 15-minute intervals: ~2,880 executions/month. Use webhook-based triggers wherever possible to minimize execution count.

---

## Client Account Pattern

Each client should own their own n8n account — not housed in an agency account.

**Advantages:**
- Client data stays in client's account with no agency dependency on billing or access
- Client can audit, modify, or transfer workflows independently
- Isolates clients from each other (no shared credentials or accidental data access)

**Setup steps:**
1. Client creates n8n Cloud account (recommended: Cloud, not self-hosted — lower maintenance)
2. Client invites the agency team member as a collaborator
3. Credentials stored in client's n8n credentials vault — not exported to agency systems

**Credentials to configure:**
- Meta Conversions API access token (from Events Manager)
- Google BigQuery service account JSON (project-specific)
- Airtable Personal Access Token (base-specific)
- Webhook secrets (generated per workflow)

---

## Cross-References

- [[reference/tracking-bridge/iclosed-attribution|iClosed Attribution Pipeline]] — iClosed-specific WF1–WF4 pipeline flows (Booking→CRM, Outcome→CRM, CRM→CAPI, Events→BigQuery)
- [[reference/platforms/meta-ads/capi-server-events|Meta CAPI — Server-Side Events]] — CAPI payload structure, `action_source` values, `fbc` construction, hashing, deduplication
- [[reference/reporting/cross-platform-data-model|Cross-Platform Data Model]] — join keys, lifecycle stages, multi-source BQ architecture
