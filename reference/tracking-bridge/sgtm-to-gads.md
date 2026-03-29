---
title: sGTM to Google Ads — Server-Side Conversion Tracking
date: 2026-03-28
tags:
  - reference
  - tracking-bridge
---

# sGTM to Google Ads — Server-Side Conversion Tracking

## Architecture

```
User clicks ad → GCLID in URL
→ Client GTM: GA4 tag sends event to sGTM endpoint
→ sGTM receives event data (including GCLID from cookie)
→ sGTM: Google Ads Conversion Tracking tag fires
→ Conversion sent server-to-server to Google Ads
```

## Why Server-Side?

| Benefit | Description |
|---------|-------------|
| Ad blocker resilience | Server-side requests aren't blocked by browser ad blockers |
| Data control | PII stays on your server, only hashed data sent to Google |
| Consent enforcement | Server-side consent checks before forwarding |
| Data enrichment | Enrich events with backend data before sending |
| Reduced page weight | Fewer client-side tags = faster page loads |
| First-party context | sGTM runs on your domain (subdomain) |

## sGTM Setup for Google Ads

### Prerequisites
- sGTM container deployed (Cloud Run, App Engine, or other hosting)
- Custom domain configured (e.g., `sgtm.yourdomain.com`)
- Client GTM sending events to sGTM endpoint

### Client-Side GTM Configuration

1. **GA4 Configuration tag** → set transport URL to your sGTM endpoint
   ```
   Transport URL: https://sgtm.yourdomain.com
   ```

2. **GA4 Event tags** → fire on conversion events (purchase, lead, etc.)
   - Event data flows to sGTM via the GA4 measurement protocol

3. **Conversion Linker** → still needed client-side to capture GCLID

### sGTM Container Configuration

1. **GA4 Client:** Receives incoming GA4 requests and creates event data
   - Automatically parses GA4 measurement protocol
   - Extracts event name, parameters, user properties

2. **Google Ads Conversion Tracking tag:**
   - **Conversion ID:** AW-XXXXXXXXX
   - **Conversion Label:** from Google Ads
   - **Trigger:** Custom event matching your conversion event name
   - **Conversion Value:** From event data (`x-ga-mp2-ev` or mapped parameter)
   - **Transaction ID:** From event data
   - **GCLID:** Automatically extracted from the `_gcl_aw` cookie (forwarded by GA4 client)

3. **User-Provided Data (Enhanced Conversions):**
   - Map user data from event data to the tag
   - sGTM handles SHA-256 hashing automatically
   - Fields: email, phone, first_name, last_name, address

## Data Flow Details

### GCLID Flow
```
1. User clicks ad → URL has ?gclid=XYZ
2. Client GTM Conversion Linker → stores in _gcl_aw cookie
3. GA4 tag reads _gcl_aw → sends to sGTM as cookie data
4. sGTM GA4 Client → parses cookie data
5. sGTM Google Ads tag → extracts GCLID → sends with conversion
```

### Enhanced Conversion Data Flow
```
1. Client-side: user submits form with email/phone
2. DataLayer push with user_data
3. GA4 Event tag → sends user_data parameters to sGTM
4. sGTM Google Ads tag → maps user_data fields
5. sGTM hashes data (SHA-256) → sends to Google Ads API
```

## sGTM Variables for Google Ads

Common sGTM variables to set up:

| Variable | Type | Purpose |
|----------|------|---------|
| Event Name | Event Data | `event_name` parameter |
| Transaction ID | Event Data | Deduplication |
| Value | Event Data | `value` parameter |
| Currency | Event Data | `currency` parameter |
| User Email | Event Data | Enhanced conversions |
| User Phone | Event Data | Enhanced conversions |
| GCLID | Cookie | `_gcl_aw` cookie value |

## Consent in sGTM

sGTM respects Consent Mode signals forwarded from the client:

- If `ad_storage` is denied, the Google Ads tag won't fire (or fires in consent-aware mode)
- Configure consent checks in sGTM tag settings
- Consider implementing a consent lookup table in sGTM for additional control

## Testing & Verification

1. **sGTM Preview Mode:** Debug incoming requests and outgoing tags
2. **Network tab:** Verify requests going to your sGTM endpoint (not directly to Google)
3. **sGTM Logs:** Check Cloud Logging for successful/failed tag firings
4. **Google Ads Diagnostics:** Verify conversions recording with correct attribution
5. **Compare client vs server:** Ensure sGTM conversion count matches expectations

## Common Issues

- **GCLID not forwarded:** GA4 client must be configured to read cookies
- **Cross-domain GCLID loss:** Ensure linker parameters pass between domains
- **Consent mode mismatch:** Client and server consent states must align
- **Clock skew:** sGTM server time must be accurate (affects conversion attribution)
- **Missing event parameters:** Verify all required data is sent from client-side GA4 tags
