---
title: iClosed — Tracking & Attribution Pipeline
date: 2026-04-14
tags:
  - reference
  - tracking-bridge
---

# iClosed — Tracking & Attribution Pipeline

iClosed is an AI-powered sales scheduling platform used by high-ticket coaching and consulting teams. Because the scheduler is iframe-embedded on external websites, standard GTM event listeners and click triggers do not fire directly — custom tracking infrastructure is required.

## Overview

iClosed provides two tracking layers:

1. **Client-side (GTM):** iClosed fires 5 named dataLayer events through its own GTM container integration. Requires a dedicated GTM container ID configured in iClosed settings.
2. **Server-side (Webhooks):** iClosed sends 12 webhook trigger types to external tools. Used for CRM sync, BigQuery logging, and server-side conversion events.

A third layer exists as a **native Meta CAPI integration** built into iClosed — relevant context when deciding whether to build a custom n8n pipeline.

---

## GTM URL Parameter Injection

iClosed's scheduler is embedded via an iframe or popup widget. The widget loads via:

```
https://app.iclosed.io/assets/widget.js
```

### Scenario A — Single GTM Container

Use when the iClosed scheduler is embedded on a page already tracked by your main GTM container.

**Approach:** Add iClosed's GTM container ID to the iClosed platform settings. The iClosed dataLayer events fire into the iClosed container, which runs inside the iframe. To receive events on the parent page dataLayer, you must implement a Custom HTML tag that listens for postMessage events from the iframe (similar to the Calendly tracking pattern).

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
> iClosed does not officially document a postMessage API. The above pattern is based on common iframe tracking architecture. Verify event payload structure by testing in a webhook debugger or browser console.

### Scenario B — Dedicated iClosed GTM Container

iClosed recommends creating a dedicated GTM container for iClosed (separate from your main website container). This is the cleaner approach for clients with complex existing containers.

**Setup:**
1. Create a new GTM container named e.g., `iClosed - [Client Name]`
2. Enter the Container ID in iClosed Settings → Integrations → Google Tag Manager
3. Add your GA4 property ID, Google Ads Conversion ID, and Meta Pixel ID
4. iClosed manages tag firing for its 5 events automatically within this container

**GA4 configuration for iClosed container:**

```
cookie_domain: auto
cookie_flags: SameSite=None;Secure
```

---

## Webhook Events

iClosed fires webhook events to configured endpoints when scheduler actions occur. All are **instant triggers** (not polling).

Subscription limit: Startup plan = 1 GTM container. Business/Enterprise = up to 3 GTM container IDs.

| Event Name | Trigger Condition | Tracking Use Case |
|------------|------------------|------------------|
| Call Booked | New call scheduled in iClosed | WF1: Booking → CRM; BQ logging |
| Call Cancelled | Call cancelled by invitee or closer | CRM status update; BQ log |
| Call Rescheduled | Upcoming call moved to new date | CRM status update; BQ log |
| Call Outcome | Outcome added to a completed call | WF2: Outcome → CRM; WF3: CRM → CAPI |
| Contact by Status | Contact status changes on scheduler journey | Lead stage progression |
| Contact Updated | Contact record updated | CRM sync |
| Contact Custom Field Updated | Custom field value changed | CRM sync (custom data) |
| Appointment Setting Outcome | Appointment setting outcome added | SDR/setter workflow |
| Setter Owner Assigned | Setter owner assigned to contact | Team attribution |
| Note Added | Note added to contact | Low value for tracking |
| Data Intelligence | Email/phone validated or credit score calculated | Lead quality signal |
| Transaction Synced | Transaction synced with a Deal | Revenue attribution |

**For tracking attribution pipelines, focus on:** Call Booked, Call Cancelled, Call Rescheduled, Call Outcome, Contact by Status.

---

## fbclid Passthrough

iClosed captures standard UTM parameters (source, medium, campaign, term, content) automatically when present in the landing page URL.

For `fbclid` passthrough to server-side events, iClosed uses a `tracking` object in webhook payloads that stores arbitrary key-value pairs via a `utmKey_N` / `utmValue_N` format. This allows custom tracking parameters beyond the standard 5 UTMs to be stored and retrieved via webhooks.

> [!warning] Unverified Field Format
> The `utmKey_N`/`utmValue_N` field format is based on empirical observation from the WinstArchitect client project and has not been confirmed in iClosed's public documentation. Verify against actual webhook payloads using a tool like Webhook.cool or n8n's built-in webhook tester before building automations that depend on this structure.

**Recommended approach (if `tracking` object confirmed):**

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

**Fallback approach:** Store fbclid in Airtable at booking time (captured via iClosed webhook → n8n → Airtable). Retrieve it at outcome time by looking up the contact's Airtable record using `contactId`.

---

## Attribution Gap: callOutcome

The `callOutcome` webhook event carries outcome data (e.g., deal value, outcome type, closer owner) but the `tracking` object — which contains fbclid and UTM data — may not be present in this payload.

**Why this matters:** When sending a server-side purchase/lead event to Meta CAPI after a closed deal, you need `fbc` (constructed from fbclid) to attribute the revenue to the right ad. Without fbclid in the `callOutcome` payload, attribution breaks.

**Workaround — contactId correlation:**

```
callOutcome webhook received
  → Extract: contactId, dealValue, outcomeType
  → Query Airtable: find record where contactId matches
  → Retrieve: stored fbclid from booking-time data
  → Construct fbc: fb.1.1.{captureTime_ms}.{fbclid}
  → Send CAPI event with fbc, dealValue, event_id = callPreviewId
```

This is WF2 → WF3 in the n8n pipeline pattern. See [[reference/tracking-bridge/n8n-pipeline-patterns|n8n Pipeline Patterns]].

---

## Native Meta CAPI Integration

iClosed has a **built-in server-side Meta CAPI integration** that activates when Meta Pixel is configured in iClosed Settings.

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
| `event_id` | Included for deduplication |

**Events sent:** Page view, Potential, Qualified, Disqualified, Call booked (`invitee_meeting_scheduled`)

**When to use native CAPI vs. n8n:**

| Scenario | Use |
|----------|-----|
| Standard lead gen — just need call bookings tracked | Native iClosed CAPI — zero setup |
| Need Purchase event after closed deal with deal value | n8n WF3 — native doesn't send outcome events |
| Need BigQuery raw event log | n8n WF4 — native has no BQ routing |
| Need custom `event_id` (e.g., `callPreviewId`) | n8n WF3 — native generates its own IDs |
| Consent Mode v2 required | Both — see Consent Gating section below |

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

**Consent Mode v2 defaults (if using Consent Mode on iClosed pages):**

```javascript
// Set defaults BEFORE the GTM snippet
gtag('consent', 'default', {
  'ad_storage': 'denied',
  'ad_user_data': 'denied',
  'ad_personalization': 'denied',
  'analytics_storage': 'denied'
});
```

**Iframe-specific consideration:** iClosed's scheduler runs in an iframe. Consent signals from the parent page do not automatically propagate into the iframe. iClosed handles consent for events fired within its own GTM container. For events bridged to the parent page (Scenario A postMessage pattern), apply consent gating on the parent page trigger.

---

## GTM DataLayer Events

These 5 events are **confirmed** in iClosed's official GTM documentation:

| Event | Trigger Condition | Recommended Conversion Use |
|-------|------------------|---------------------------|
| `iclosed_view` | Scheduler page loaded | No — informational only |
| `iclosed_potential` | Visitor enters email + phone | No — fires twice, too broad |
| `iclosed_qualified` | Completes full form | Yes — for Meta top-of-funnel |
| `iclosed_disqualified` | Fails qualification | No — negative signal |
| `iclosed_call_scheduled` | Call booked | **Yes — primary conversion** |

**Important:** `iclosed_potential` fires **twice** when both email and phone fields are on the form (once per field completed). Do not use for Google Ads or Meta conversion events — use `iclosed_call_scheduled` instead.

For Meta Ads: optimize for `iclosed_qualified` (more signals) or `iclosed_call_scheduled` (higher intent). Never optimize for `iclosed_potential`.

---

## Cross-References

- [[reference/tracking-bridge/n8n-pipeline-patterns|n8n Pipeline Patterns]] — WF1 (Booking → CRM), WF2 (Outcome → CRM), WF3 (CRM → CAPI)
- [[reference/reporting/cross-platform-data-model|Cross-Platform Data Model]] — `contactId` join key, lead lifecycle stages
- [[reference/platforms/google-ads/tracking-bridge/gtm-to-gads|GTM to Google Ads]] — Client-side conversion setup patterns
- [[reference/mcp/mcp-capabilities|MCP Capabilities]] — What can be verified via Google Ads API vs. manual
