---
title: Klaviyo Fundamentals — Tracking Specialist Reference
date: 2026-04-16
tags:
  - reference
  - platforms
  - klaviyo
  - email-marketing
  - tracking
---

# Klaviyo Fundamentals

Reference for a **tracking specialist** advising on a Klaviyo-integrated account. Covers GTM installation, sGTM integration, attribution-relevant events, Meta sync, BigQuery pipelines, and PII/consent rules. Not a Klaviyo marketing guide.

> [!info] Stack context
> Klaviyo most commonly appears alongside Shopify (e-commerce), Meta Ads, and a sGTM pipeline. This page assumes that stack. For lead-gen stacks, most of the event and PII guidance still applies; the Meta audience sync section is less relevant.

---

## 1. What Klaviyo Is — Stack Position

Klaviyo is an email + SMS marketing platform that owns **first-party profile data** for the accounts it serves. In an e-commerce tracking stack it sits between the website (data source) and the marketing channels (Meta Ads, Google Ads) as a profile store and audience builder.

```
Website (Shopify / CF2.0 / WooCommerce)
  │
  ├── GTM / sGTM ──→ GA4, Google Ads, Meta CAPI
  │
  └── Klaviyo JS ──→ Klaviyo profile store
                          │
                          ├──→ Email/SMS sequences
                          │
                          └──→ Meta Custom Audiences (sync)
                          │
                          └──→ BigQuery (via third-party connector)
```

**When it surfaces in tracking work:**

- Client asks why Meta audience is smaller than their Klaviyo list
- Attribution window mismatch: Klaviyo claims revenue that Meta also claims
- Email events (Placed Order, Started Checkout) should feed into CAPI or server-side BQ pipelines
- Klaviyo list data should land in BigQuery for unified reporting

---

## 2. GTM Client-Side Installation

### Method

Klaviyo's onsite JS runs as a **Custom HTML tag** in GTM (or directly via Shopify theme). It is NOT a built-in GTM tag type — must be manually added.

### Install pattern

```html
<script type="text/javascript">
  !function(){if(!window.klaviyo){window._klOnsite=window._klOnsite||[];
  try{window.klaviyo=new Proxy({},{get:function(n,i){return"push"===i?function(){var n;(n=window._klOnsite).push.apply(n,arguments)}:function(){for(var n=[i],o=arguments,r=0;r<o.length;r++)n.push(o[r]);var t;(t=window._klOnsite).push.apply(t,n)}}})}catch(n){window.klaviyo={push:function(){var n;(n=window._klOnsite).push.apply(n,arguments)}}}}}();
</script>
<script type="text/javascript" async src="https://static.klaviyo.com/onsite/js/klaviyo.js?company_id=YOUR_SITE_ID"></script>
```

Replace `YOUR_SITE_ID` with the 6-character public site ID from Klaviyo → Settings → API Keys.

Official install guide: [Klaviyo — GTM onsite install](https://help.klaviyo.com/hc/en-us/articles/360015392131)

### Consent gate (required)

Gate the Klaviyo tag on **Consent Mode v2** marketing consent before firing:

1. In GTM tag settings → **Additional consent checks** → require `ad_user_data` + `analytics_storage`
2. Add a trigger that fires only when consent is granted (CMP `consent_update` dataLayer event or equivalent)
3. Do NOT fire the Klaviyo JS on page load by default in EEA/UK traffic — Consent Mode v2 enforcement began July 2025

### Debug

```javascript
// Paste in browser console to verify Klaviyo is identified
window.klaviyo.isIdentified() // returns true/false
```

---

## 3. Server-Side via sGTM

### When to use

Route Klaviyo events through sGTM when:
- The client uses sGTM for Meta CAPI and GA4 already (most setups this is the right call)
- You need ad-blocker-resilient event tracking for Klaviyo
- You want to fan out `Placed Order` / `Started Checkout` to both Klaviyo and Meta CAPI from a single sGTM trigger

### Recommended tag

**`stape-io/klaviyo-tag`** (Apache-2.0, 11★) — [GitHub](https://github.com/stape-io/klaviyo-tag)

Official Stape sGTM tag for Klaviyo. Capabilities:

| Operation | What it does |
|-----------|-------------|
| Add contact | Creates / updates a Klaviyo profile from event data |
| Update contact | Updates properties on an existing profile |
| Track onsite activity | Fires a Klaviyo onsite event (e.g., `Viewed Product`) |
| Send event | Fires a Klaviyo server-side event via the Events API |

**Install pattern in sGTM:**

1. In your sGTM container → Templates → Search Gallery → "Klaviyo"
2. Use a Data Tag + Data Client to **persist user email** across sGTM requests (email does not arrive on every hit — must be stored from the first identify event)
3. Wire triggers to the same GA4 event names that fire your Google Ads Conversion tag (see [[sgtm-to-gads]])

**Klaviyo Private API Key** (required for sGTM tag): Klaviyo → Settings → API Keys → Create Private API Key. Use a scoped key (Events: Write, Profiles: Write). Store in sGTM server-side environment variable or Secret Manager — never in client-side JS.

---

## 4. Attribution-Relevant Events

These four events drive Klaviyo flows and feed into server-side pipelines:

| Event | When it fires | Relevance to tracking stack |
|-------|--------------|----------------------------|
| `Placed Order` | Order confirmation | Primary revenue event — should also flow to Meta CAPI + Google Ads Offline Conversions |
| `Started Checkout` | Checkout page load | Abandoned-cart trigger; maps to Meta `InitiateCheckout` |
| `Viewed Product` | Product page view | PDP view — maps to Meta `ViewContent` |
| `Active on Site` | Recurring session activity | Engagement signal — low relevance to paid attribution |

All four can be sent server-side via the **Klaviyo Events API** from sGTM:
- Endpoint: `POST https://a.klaviyo.com/api/events/`
- Auth: Private API key in `Authorization: Klaviyo-API-Key <key>` header
- Official docs: [Klaviyo Events API](https://developers.klaviyo.com/en/reference/events_api_overview)

> [!tip] Fan-out from sGTM
> If sGTM already receives `Placed Order` for Meta CAPI, add a second tag on the same trigger to send the event to Klaviyo via the Events API. One incoming event → Google Ads + Meta CAPI + Klaviyo. No client-side duplication.

---

## 5. Klaviyo ↔ Meta Custom Audience Sync

### How it works

Klaviyo syncs list/segment members to Meta as a Custom Audience using Meta's Marketing API. The sync uses **hashed email** (SHA-256) — no raw PII leaves Klaviyo.

| Detail | Value |
|--------|-------|
| Sync frequency (Klaviyo-side) | Hourly export |
| Meta processing time | 24–48 hours after Klaviyo exports |
| Minimum audience size (Meta) | 100 matched profiles |
| Typical match rate | 40–70% of list size (only emails with Meta accounts match) |

Official guide: [Klaviyo — Meta audience sync strategy](https://help.klaviyo.com/hc/en-us/articles/360040954011)

### Sync vs. CAPI — not the same thing

| Tool | Purpose | What it affects |
|------|---------|----------------|
| Klaviyo audience sync | **Targeting** — who sees ads | Audience reach |
| Meta CAPI | **Attribution + optimization** — which conversions happened | ROAS measurement, bid optimization |

**Do both.** Sync builds retargeting audiences. CAPI feeds the attribution model. They don't overlap.

### Attribution window conflict

Klaviyo defaults to a **5-day attribution window** (click or open). Meta defaults to **7-day click, 1-day view**. Both will claim revenue from the same transaction — this is expected and not a bug. Document it for the client:

> "Klaviyo-attributed revenue and Meta-attributed revenue are measured using different windows and different logic. Summing them double-counts. Use blended ROAS (total ad spend / total platform revenue) as the control metric."

---

## 6. Klaviyo → BigQuery — No Native Connector

> [!important] No native BQ connector
> Klaviyo is **not** available as a native Google Cloud BigQuery Data Transfer Service source (as of 2026). There is no one-click connector in the GCP console.

### Canonical paths

| Option | Cost | Sync cadence | Setup complexity |
|--------|------|-------------|-----------------|
| **Fivetran** (Klaviyo connector) | Paid — monthly MAR-based | ~15 min | Low — managed, no infra |
| **Airbyte** (Klaviyo source) | Free (self-hosted) / Airbyte Cloud (paid) | Configurable (15 min–24h) | Medium — run your own connector |
| **CSV export + manual BQ load** | Free | Manual | High — not sustainable |

- Fivetran docs: [fivetran.com/docs/connectors/applications/klaviyo](https://fivetran.com/docs/connectors/applications/klaviyo)
- Airbyte docs: [docs.airbyte.com/integrations/sources/klaviyo](https://docs.airbyte.com/integrations/sources/klaviyo)

### Key tables to land in BQ

| Klaviyo entity | BQ table suggestion | Useful for |
|----------------|-------------------|-----------|
| Events | `klaviyo_events` | `Placed Order`, `Started Checkout` time series |
| Profiles | `klaviyo_profiles` | Email list size, consent status, LTV |
| Campaigns | `klaviyo_campaigns` | Email revenue attribution vs. paid media |
| Flows | `klaviyo_flows` | Automated sequence performance |

> [!tip] Email as join key
> Klaviyo's `$email` profile property is the natural join key to CRM data. In BQ, SHA-256 hash it before joining to any Meta CAPI table (where `em` field is also hashed). Never store plain emails in the reporting layer.

Cross-reference: [[bigquery-native-connectors]] — decision matrix for where Klaviyo fits vs. native platform connectors

---

## 7. PII & Consent Rules

### What Klaviyo stores

Klaviyo profiles contain first-party PII: email, phone number, first name, last name. This is legitimate — it's Klaviyo's core product. The tracking rules apply to **what you send to other systems**.

### PII handling rules

| Rule | Detail |
|------|--------|
| **Never send raw email to client-side tags** | Klaviyo's `_kx` URL token is a server-resolved identifier — do not append raw email to query strings or push it to a dataLayer for any client-side tag to read |
| **Hash before CAPI** | When sending Klaviyo profile data to Meta CAPI, apply SHA-256 + normalize first: lowercase email, E.164 phone, lowercase names |
| **`$consent` property** | Klaviyo's consent system uses the `$consent` profile property. Granular opt-ins (email, SMS) are tracked per profile. Map this to your consent audit if running a GDPR compliance review |
| **Meta upload consent (Jan 2025)** | Meta requires explicit consent before uploading contact info for Custom Audience building. Ensure the Klaviyo ↔ Meta sync configuration has the consent legal basis documented |

Official consent reference: [Klaviyo — GDPR consent](https://help.klaviyo.com/hc/en-us/articles/360003536031)

---

## 8. Open-Source Repos

| Repo | Stars | License | What it's for |
|------|-------|---------|--------------|
| [`stape-io/klaviyo-tag`](https://github.com/stape-io/klaviyo-tag) | 11 | Apache-2.0 | sGTM tag for Klaviyo — add/update contacts, track events, send server-side events. The production reference for sGTM integration. |
| [`klaviyo/klaviyo-hotels-tags`](https://github.com/klaviyo/klaviyo-hotels-tags) | 1 | Apache-2.0 | Official Klaviyo-authored GTM patterns — **scope is hotel PMS only** (Mews, Cloudbeds, Guesty). Not a generic reference. |

> [!note] No generic Klaviyo GTM Template Gallery entry
> Klaviyo does not publish a first-party template in the Google GTM Template Gallery (as of 2026). The `stape-io/klaviyo-tag` is the only maintained sGTM tag; client-side Klaviyo always uses a Custom HTML tag.

---

## 9. Cross-References

- [[sgtm-to-gads]] — sGTM container setup; same infrastructure hosts the Klaviyo sGTM tag
- [[bigquery-native-connectors]] — platform-level decision matrix for which connectors are native vs. third-party
- [[cross-platform-data-model]] — how Klaviyo profile data joins to ad-platform data in BQ (email as join key)
- [[capi-server-events]] (`reference/platforms/meta-ads/`) — Meta CAPI payload structure; Klaviyo events fan out to CAPI from sGTM

---

## Sources

- [Klaviyo — GTM onsite install](https://help.klaviyo.com/hc/en-us/articles/360015392131)
- [Klaviyo — JavaScript API](https://developers.klaviyo.com/en/docs/javascript_api)
- [Klaviyo — Events API](https://developers.klaviyo.com/en/reference/events_api_overview)
- [Klaviyo — Meta Custom Audience sync strategy](https://help.klaviyo.com/hc/en-us/articles/360040954011)
- [Klaviyo — GDPR consent](https://help.klaviyo.com/hc/en-us/articles/360003536031)
- [Stape — Klaviyo sGTM setup guide](https://stape.io/blog/set-up-klaviyo-website-event-tracking-using-server-google-tag-manager)
- [stape-io/klaviyo-tag on GitHub](https://github.com/stape-io/klaviyo-tag)
- [Fivetran Klaviyo connector](https://fivetran.com/docs/connectors/applications/klaviyo)
- [Airbyte Klaviyo source](https://docs.airbyte.com/integrations/sources/klaviyo)
