---
title: iClosed — Tracking & Attribution Pipeline
date: 2026-04-16
tags:
  - reference
  - tracking-bridge
---

# iClosed — Tracking & Attribution Pipeline

iClosed is an AI-powered sales scheduling platform used by high-ticket coaching and consulting teams. Because the scheduler is iframe-embedded on external websites, standard GTM event listeners and click triggers do not fire directly — custom tracking infrastructure is required.

---

## Overview

iClosed provides two tracking layers:

1. **Client-side (GTM):** iClosed fires 5 named dataLayer events via a postMessage bridge from the iframe to the parent page. Requires a Custom HTML tag in your existing GTM container.
2. **Server-side (Webhooks):** iClosed sends 12 webhook trigger types to external endpoints. Used for CRM sync, BigQuery logging, and server-side conversion events via n8n.

> [!info] Platform Defaults
> iClosed also offers a native Meta CAPI integration and recommends a dedicated GTM container. Both are documented in the **Platform Defaults to Override** section at the bottom of this document. These are things to **disable**, not use.

---

## GTM Integration

### URL Parameter Injection

iClosed's scheduler is embedded via an iframe or popup widget. The widget loads via:

```
https://app.iclosed.io/assets/widget.js
```

**The tracking approach:** iClosed's dataLayer events fire inside the iframe. To receive these events on the parent page's dataLayer (where your GTM container runs), implement a Custom HTML tag that listens for `postMessage` events from the iframe.

**GTM tag (parent page — Custom HTML):**

```javascript
<script>
(function() {
  var ICLOSED_EVENTS = {
    'iclosed_view': true,
    'iclosed_potential': true,
    'iclosed_qualified': true,
    'iclosed_disqualified': true,
    'iclosed_call_scheduled': true
  };

  if (window._iClosedListenerRegistered) return;
  window._iClosedListenerRegistered = true;

  window.addEventListener('message', function(event) {
    if (!event.data || typeof event.data !== 'object') return;
    var eventName = event.data.event || event.data.type;
    if (!eventName || !ICLOSED_EVENTS[eventName]) return;

    if (!window._iClosedFiredEvents) window._iClosedFiredEvents = {};
    var key = eventName + '_' + Date.now();
    if (window._iClosedFiredEvents[key]) return;
    window._iClosedFiredEvents[key] = true;

    window.dataLayer = window.dataLayer || [];
    window.dataLayer.push({
      event: eventName,
      iclosed_event: eventName
    });
  });
})();
</script>
```

> [!note]
> iClosed does not officially document a postMessage API. The above pattern is based on common iframe tracking architecture. Verify event payload structure by testing in a webhook debugger or browser console before deploying to production.

### GA4 Cookie Configuration

When GA4 is loaded in the same GTM container as iClosed's iframe parent page, you may need to configure cross-origin cookie behavior:

```
cookie_domain: auto
cookie_flags: SameSite=None;Secure
```

This ensures GA4 session cookies are readable across the subdomain boundary between the parent page and the iframe origin. Without `SameSite=None;Secure`, browsers may block cookie access and break session stitching.

---

## GTM DataLayer Events

These 5 events are **confirmed** in iClosed's official GTM documentation:

| Event | Trigger Condition | Recommended Conversion Use |
|-------|------------------|---------------------------|
| `iclosed_view` | Scheduler page loaded | No — informational only |
| `iclosed_potential` | Visitor enters email + phone | **No — fires twice (see warning)** |
| `iclosed_qualified` | Completes full form | Yes — for Meta top-of-funnel signals |
| `iclosed_disqualified` | Fails qualification | No — negative signal |
| `iclosed_call_scheduled` | Call booked | **Yes — primary conversion event** |

> [!warning] `iclosed_potential` fires twice
> This event fires once when the email field is completed and again when the phone field is completed. Never use it for Google Ads or Meta conversion events. Use `iclosed_call_scheduled` instead.

**Optimization guidance:**
- Google Ads: optimize for `iclosed_call_scheduled` — highest intent, single fire
- Meta: optimize for `iclosed_qualified` (more signals for learning phase) or `iclosed_call_scheduled` (higher intent)

---

## Webhook Events

iClosed fires webhook events to configured endpoints when scheduler actions occur. All are **instant triggers** (not polling).

| Event Name | Trigger Condition | Tracking Use Case |
|------------|------------------|------------------|
| Call Booked | New call scheduled in iClosed | **WF1: Booking → CRM; BQ logging** |
| Call Cancelled | Call cancelled by invitee or closer | CRM status update; BQ log |
| Call Rescheduled | Upcoming call moved to new date | CRM status update; BQ log |
| Call Outcome | Outcome added to a completed call | **WF2: Outcome → CRM; WF3: CRM → CAPI** |
| Contact by Status | Contact status changes on scheduler journey | Lead stage progression |
| Contact Updated | Contact record updated | CRM sync |
| Contact Custom Field Updated | Custom field value changed | CRM sync (custom data) |
| Appointment Setting Outcome | Appointment setting outcome added | SDR/setter workflow |
| Setter Owner Assigned | Setter owner assigned to contact | Team attribution |
| Note Added | Note added to contact | Low value for tracking |
| Data Intelligence | Email/phone validated or credit score calculated | Lead quality signal |
| Transaction Synced | Transaction synced with a Deal | Revenue attribution |

**For tracking attribution pipelines, focus on:** Call Booked, Call Outcome, Contact by Status.

---

## fbclid Passthrough

iClosed captures standard UTM parameters automatically when present in the landing page URL.

For `fbclid` passthrough to server-side events, iClosed uses a `tracking` object in webhook payloads that stores arbitrary key-value pairs via a `utmKey_N` / `utmValue_N` format.

> [!warning] Unverified Field Format
> The `utmKey_N`/`utmValue_N` field format is based on empirical observation from client work and has not been confirmed in iClosed's public documentation. Verify against actual webhook payloads using Webhook.cool or n8n's built-in webhook tester before building automations that depend on this structure.

**If `tracking` object confirmed:**

```javascript
// Reconstruct fbclid from tracking object
function extractFbclid(trackingArray) {
  for (var i = 0; i < trackingArray.length; i++) {
    if (trackingArray[i].utmKey === 'fbclid' ||
        trackingArray[i].utmKey_0 === 'fbclid') {
      return trackingArray[i].utmValue || trackingArray[i].utmValue_0;
    }
  }
  return null;
}
```

**Fallback approach:** Store `fbclid` in Airtable at booking time (captured via WF1 below). Retrieve it at outcome time by looking up the contact's record using `contactId`.

---

## n8n Pipeline Flows for iClosed

These 4 workflows implement the full attribution pipeline for iClosed-based funnels. n8n acts as the bridge between iClosed webhooks, the CRM (Airtable), Meta CAPI, and BigQuery.

```
WF1: Call Booked   → Airtable (create/update lead record with booking + tracking data)
WF2: Call Outcome  → Airtable (update lead record with outcome + deal value)
WF3: CRM → CAPI   → Meta CAPI (send Purchase/Lead event using stored fbclid)
WF4: Events → BQ  → BigQuery (log all events for reporting)
```

### WF1: Booking → CRM (Airtable)

**Trigger:** iClosed webhook — `Call Booked`

**Purpose:** Capture booking data and tracking parameters at the moment of booking, when `fbclid` is freshest.

**n8n nodes:**
1. `Webhook` (trigger) — receives `Call Booked` event from iClosed
2. `Code` node — extract and transform: `contactId`, `callPreviewId`, `bookingTime`, email, phone, UTMs, `fbclid` from tracking object
3. `Airtable` node (Create/Update) — upsert lead record

**Key fields to store:** `fbclid` + `fbclidCaptureTime` (Unix ms timestamp of landing page hit — NOT booking time). Required for `fbc` construction at outcome time.

**Parallel:** Also trigger WF4 (BQ raw log).

---

### WF2: Outcome → CRM (Airtable)

**Trigger:** iClosed webhook — `Call Outcome`

**Purpose:** Record the call result. The `callOutcome` payload may not contain tracking data — retrieve it from Airtable via `contactId` correlation.

**n8n nodes:**
1. `Webhook` (trigger) — receives `Call Outcome` event from iClosed
2. `Code` node — extract: `contactId`, `callPreviewId`, `outcomeType`, `dealValue`, `closerOwner`, `outcomeTime`
3. `Airtable` node (Search) — find record where `contactId` matches
4. `Airtable` node (Update) — write: `outcomeType`, `dealValue`, `outcomeTime`, `closerOwner`
5. `n8n` node (Execute Workflow) — trigger WF3 with combined data (booking tracking + outcome)

---

### WF3: CRM → Meta CAPI

**Trigger:** Called by WF2 (internal trigger — not a direct webhook)

**Purpose:** Send a server-side Purchase or Lead event to Meta CAPI using stored `fbclid` for attribution.

**n8n nodes:**
1. (Receives from WF2: `contactId`, `callPreviewId`, `fbclid`, `fbclidCaptureTime`, `dealValue`, email, phone)
2. `Code` node — construct CAPI payload:
   - `fbc` = `fb.1.{subdomainIndex}.{fbclidCaptureTime_ms}.{fbclid}` (see [[reference/platforms/meta-ads/capi-server-events|Meta CAPI — Server-Side Events]] for full formula)
   - `event_id` = `callPreviewId` (unique per call — deduplication key)
   - `external_id` = SHA256(`contactId`)
   - `em` = SHA256(email)
   - `ph` = SHA256(phone)
3. `HTTP Request` node — POST to Meta CAPI endpoint (`https://graph.facebook.com/v21.0/{pixel_id}/events`)

See [[reference/platforms/meta-ads/capi-server-events|Meta CAPI — Server-Side Events]] for payload structure, `action_source` values, hashing rules, and deduplication requirements.

---

### WF4: Events → BigQuery

**Trigger:** iClosed webhook — all event types (configure multiple webhook paths or a single router)

**Purpose:** Raw event log for reporting, debugging, and joining with Google Ads data in BigQuery.

**n8n nodes:**
1. `Webhook` (trigger) — receives any iClosed event
2. `Code` node — normalize: add `ingested_at` timestamp, standardize field names
3. `Google BigQuery` node (Insert rows) — stream into `iclosed_events_raw` table

**BigQuery schema:**

```sql
CREATE TABLE tracking.iclosed_events_raw (
  event_id        STRING,
  event_type      STRING,
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

## Attribution Gap: callOutcome

The `callOutcome` webhook event carries outcome data (deal value, outcome type, closer owner) but the `tracking` object — which contains `fbclid` and UTM data — may not be present in this payload.

**Why this matters:** Sending a server-side Purchase event to Meta CAPI after a closed deal requires `fbc` (constructed from `fbclid`) to attribute revenue to the right ad. Without `fbclid` in `callOutcome`, attribution breaks.

**Workaround — contactId correlation (WF2 → WF3):**

```
callOutcome webhook received
  → Extract: contactId, dealValue, outcomeType
  → Query Airtable: find record where contactId matches
  → Retrieve: stored fbclid + fbclidCaptureTime from booking-time WF1
  → Construct fbc: fb.1.{subdomainIndex}.{fbclidCaptureTime_ms}.{fbclid}
  → Send CAPI event with fbc, dealValue, event_id = callPreviewId
```

This is the WF2 → WF3 pattern documented in the sections above.

---

## Consent Gating

iClosed GTM tags should be gated behind consent to comply with Consent Mode v2.

**Trigger configuration (in GTM):**

```
Trigger type: Custom Event
Event name: iclosed_call_scheduled
Fire on: All custom events
Condition: Cookie Consent — Marketing = true
```

**Consent Mode v2 defaults (set BEFORE the GTM snippet on iClosed-integrated pages):**

```javascript
gtag('consent', 'default', {
  'ad_storage': 'denied',
  'ad_user_data': 'denied',
  'ad_personalization': 'denied',
  'analytics_storage': 'denied'
});
```

**Iframe-specific consideration:** iClosed's scheduler runs in an iframe. Consent signals from the parent page do **not** automatically propagate into the iframe. iClosed handles consent for events fired within its own GTM container. For events bridged to the parent page (the postMessage pattern above), apply consent gating on the **parent page trigger**.

---

## Platform Defaults to Override

> [!warning] These are defaults iClosed enables. Disable them.
> The options below give the appearance of easy setup but reduce tracking specialist control over consent, event selection, data normalization, and deduplication. Use the patterns documented in this file instead.

### Native Meta CAPI Integration

iClosed has a built-in server-side Meta CAPI integration that activates when a Meta Pixel ID is configured in iClosed Settings.

**What it sends automatically:**

| Field | Value |
|-------|-------|
| `external_id` | SHA256-hashed `contactId` |
| `em` | SHA256-hashed email |
| `ph` | SHA256-hashed phone |
| `client_user_agent` | Browser user agent |
| `client_ip_address` | Contact IP |
| `fbc` | Auto-captured from `_fbc` browser cookie |
| `fbp` | Auto-captured from `_fbp` browser cookie |
| `event_id` | Included (iClosed-generated, not your identifier) |

**Events sent:** Page view, Potential, Qualified, Disqualified, Call booked (`invitee_meeting_scheduled`)

**Why to disable:**

1. **No consent control.** iClosed fires CAPI events regardless of the user's consent choice on your GTM consent layer. You cannot gate these events behind `cookie_consent_marketing = true`.
2. **No outcome events.** The native integration cannot send Purchase or Lead events after a call outcome — it only sends events that fire during the scheduling session. WF3 (n8n) is required for closed-deal attribution.
3. **No custom `event_id`.** The native integration generates its own event IDs. Using `callPreviewId` as `event_id` (the WF3 pattern) gives you stable, auditable deduplication identifiers that you control.
4. **No BigQuery routing.** Native CAPI sends events to Meta and nowhere else.

**Use WF3 instead.** It sends outcome events, uses your own `event_id`, gives full consent control, and routes raw data to BigQuery.

---

### Dedicated GTM Container (Scenario B)

iClosed recommends creating a dedicated GTM container for iClosed (separate from your main website container). iClosed manages tag firing for its 5 events automatically within this container.

**Why we don't use this:**

1. **You lose tag firing control.** When iClosed manages the container, you cannot adjust what events fire, in what order, or under what conditions.
2. **No consent integration.** iClosed's managed container does not integrate with your existing consent management platform. Tags fire without consent signals from your CMP.
3. **No measurement strategy integration.** Your main container's dataLayer variables, event parameters, and custom dimensions are not available inside a separate iClosed container.

**The only valid edge case:** An extremely fragile legacy container where adding a new Custom HTML tag poses unacceptable risk. Even in that case, create and fully own the dedicated container — do not let iClosed manage it.

**Use Scenario A instead:** The postMessage Custom HTML tag pattern documented in the GTM Integration section above.

---

## Cross-References

- [[reference/platforms/meta-ads/capi-server-events|Meta CAPI — Server-Side Events]] — payload structure, `action_source` values, `fbc` formula, hashing, deduplication (used by WF3)
- [[reference/tracking-bridge/n8n-pipeline-patterns|n8n Pipeline Patterns]] — generic webhook security, BigQuery streaming pattern, node reference
- [[reference/reporting/cross-platform-data-model|Cross-Platform Data Model]] — `contactId` join key, lead lifecycle stages
- [[reference/platforms/google-ads/tracking-bridge/gtm-to-gads|GTM to Google Ads]] — Client-side conversion setup patterns
- [[reference/mcp/mcp-capabilities|MCP Capabilities]] — What can be verified via Google Ads API vs. manual
