---
title: Meta CAPI — Server-Side Events
date: 2026-04-16
tags:
  - reference
  - meta-ads
  - tracking-bridge
---

# Meta CAPI — Server-Side Events

Meta Conversions API (CAPI) is a server-side event delivery mechanism for sending conversion signals to Meta without relying on a browser pixel. Used when no browser session is present at conversion time (offline conversions, CRM-triggered events) or when browser-side signals are unreliable.

> [!info] When to use CAPI vs pixel
> Route through GTM or sGTM (browser-side or server-side pixel) wherever possible — you retain full consent gating, session stitching, and measurement strategy integration. Use CAPI via n8n **only** for offline conversions where no browser session is present at conversion time (e.g., CRM deal closure, call outcome events).

---

## Required Event Fields

All CAPI events must include the following payload structure:

```json
{
  "data": [{
    "event_name": "Purchase",
    "event_time": 1712345678,
    "action_source": "system_generated",
    "event_id": "{your-unique-event-id}",
    "user_data": {
      "external_id": ["{SHA256_hashed_user_id}"],
      "em": ["{SHA256_hashed_email}"],
      "ph": ["{SHA256_hashed_phone}"],
      "fbc": "fb.1.1.{fbclidCaptureTime_ms}.{fbclid}"
    },
    "custom_data": {
      "currency": "EUR",
      "value": 1500.00
    }
  }],
  "access_token": "{META_ACCESS_TOKEN}"
}
```

**API endpoint:**

```
POST https://graph.facebook.com/v21.0/{pixel_id}/events
```

**Required fields by event type:**

| Event | Required | Recommended |
|-------|----------|-------------|
| `Lead` | `event_name`, `event_time`, `action_source`, `event_id` | `user_data.external_id`, `user_data.em` |
| `Purchase` | `event_name`, `event_time`, `action_source`, `event_id`, `custom_data.currency`, `custom_data.value` | `user_data.fbc`, `user_data.external_id` |
| `Schedule` | `event_name`, `event_time`, `action_source`, `event_id` | `user_data.em`, `user_data.fbc` |

---

## `action_source` Values

`action_source` tells Meta the context in which the conversion occurred.

| Value | Use When |
|-------|----------|
| `system_generated` | The event is triggered by an automated system (CRM, n8n workflow) with no user browser session present. Use for call outcomes, deal closures, any offline conversion. |
| `website` | A browser session is present and the event is being sent server-side (e.g., via sGTM). The event corresponds to a user action on a website. |
| `app` | Event originates from a mobile app. |
| `email` | Conversion occurred via email. |
| `chat` | Conversion occurred via chat. |
| `phone_call` | Conversion occurred via phone call (distinct from an automated system). |

**For n8n offline conversion pipelines (WF3):** always use `system_generated`.

---

## `fbc` Construction

`fbc` is the Meta click identifier cookie value. Reconstructing it server-side from a stored `fbclid` is required when the browser cookie is not available.

**Format:**

```
fbc = fb.{version}.{subdomainIndex}.{creationTime_ms}.{fbclid}
```

**Components:**

| Component | Value | Notes |
|-----------|-------|-------|
| `version` | `1` | Always `1` |
| `subdomainIndex` | `1` for `example.com` / `2` for `www.example.com` | 1 for root domain, 2 for www subdomain |
| `creationTime_ms` | Unix timestamp in **milliseconds** | Timestamp when `fbclid` was first captured (landing page hit) — **NOT** booking time or current time |
| `fbclid` | Raw URL parameter value | The full fbclid string from the landing URL — do not modify |

**Example:**

```
fb.1.1.1712000000000.AbCdEfGhIjKlMnOpQrStUvWxYz1234567890
```

> [!warning] Capture time matters
> `creationTime_ms` must be the timestamp when the user first arrived on the landing page from a Meta ad (when `fbclid` appeared in the URL). Using booking time or current time produces an incorrect `fbc` value that Meta cannot match to the original click.

**Do NOT hash `fbc`** — send as a plain string. Only `external_id`, `em`, `ph`, and `fn`/`ln` require hashing.

---

## User Data Hashing

Meta requires certain user data fields to be SHA256-hashed before transmission.

**Fields that must be hashed:**

| Field | Content | Normalization before hashing |
|-------|---------|------------------------------|
| `external_id` | Your internal user identifier (e.g., `contactId`) | No normalization required — hash as-is |
| `em` | Email address | Lowercase, trim whitespace |
| `ph` | Phone number | Digits only, include country code (e.g., `31612345678` for NL) |
| `fn` | First name | Lowercase, trim whitespace |
| `ln` | Last name | Lowercase, trim whitespace |

**Implementation (JavaScript / n8n Code node):**

```javascript
const crypto = require('crypto');

function hashSHA256(value) {
  return crypto.createHash('sha256').update(value.trim().toLowerCase()).digest('hex');
}

// Usage
const hashedEmail    = hashSHA256(email);
const hashedPhone    = hashSHA256(phone.replace(/\D/g, ''));  // digits only
const hashedExternal = crypto.createHash('sha256').update(contactId).digest('hex');
```

**Fields that must NOT be hashed:**
- `fbc` — send as plain string
- `fbp` — send as plain string
- `client_ip_address` — send as plain string
- `client_user_agent` — send as plain string

---

## Event Deduplication

If both a browser pixel (via GTM/sGTM) and server-side CAPI send the same event, Meta uses `event_id` to deduplicate.

**Rules:**

| Rule | Detail |
|------|--------|
| Deduplication key | `event_name` + `event_id` (both must match, case-sensitive) |
| Deduplication window | 48 hours |
| `event_id` uniqueness | Must be unique per event instance — not per user or session |
| Matching requirement | `event_id` sent by the pixel and by CAPI must be identical for deduplication to occur |

**Best practice for `event_id`:**
- Use a stable, unique identifier from your source system (e.g., `callPreviewId` from iClosed, order ID from an e-commerce platform)
- Do not use timestamps alone — they are not unique enough
- If no stable ID exists, generate a UUID at event creation time and store it for later use in the CAPI call

**When iClosed native CAPI is also active:**
Either ensure the `event_id` sent by the native integration matches the one you send via n8n WF3, or disable the native integration entirely. Mismatched `event_id` values result in duplicate event counting.

---

## Cross-References

- [[reference/tracking-bridge/iclosed-attribution|iClosed Attribution Pipeline]] — iClosed-specific CAPI pipeline (WF3: CRM → Meta CAPI)
- [[reference/tracking-bridge/n8n-pipeline-patterns|n8n Pipeline Patterns]] — HTTP Request node configuration, webhook security, BigQuery streaming
- [[reference/reporting/meta-ads-bigquery|Meta Ads to BigQuery]] — Getting Meta Ads data into BigQuery for cross-platform reporting
