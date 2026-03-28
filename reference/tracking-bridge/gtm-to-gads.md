# GTM to Google Ads — Client-Side Conversion Tracking

## Architecture

```
User clicks ad → lands on site (GCLID in URL)
→ Conversion Linker tag fires (stores GCLID in cookie)
→ User converts (purchase, form submit)
→ Conversion event pushed to dataLayer
→ GTM Google Ads Conversion Tracking tag fires
→ Conversion sent to Google Ads with GCLID + value + transaction ID
```

## Required GTM Tags

### 1. Conversion Linker Tag
**Must be on every page.** Captures GCLID and auto-tagging parameters from the URL and stores them in first-party cookies.

- **Tag type:** Conversion Linker
- **Trigger:** All Pages (Page View)
- **Settings:** Enable linking on all page URLs
- **Consent:** Requires `ad_storage` consent

Without the Conversion Linker, conversions cannot be attributed to clicks.

### 2. Google Ads Conversion Tracking Tag
Fires on the conversion event.

- **Tag type:** Google Ads Conversion Tracking
- **Trigger:** Custom Event matching your conversion event
- **Configuration:**
  - **Conversion ID:** From Google Ads (AW-XXXXXXXXX)
  - **Conversion Label:** From Google Ads (specific to the conversion action)
  - **Conversion Value:** Data Layer variable (e.g., `{{DLV - transaction_total}}`)
  - **Currency Code:** e.g., `EUR`, `USD`
  - **Transaction ID:** Data Layer variable (for deduplication)
  - **User-Provided Data:** For enhanced conversions (email, phone)

### 3. Google Ads Remarketing Tag (Optional)
For building remarketing audiences.

- **Tag type:** Google Ads Remarketing
- **Trigger:** All Pages or specific page types
- **Configuration:**
  - Conversion ID (same as above)
  - Custom parameters for dynamic remarketing (product IDs, category, value)

## DataLayer Events

### Purchase Event
```javascript
dataLayer.push({
  'event': 'purchase',
  'ecommerce': {
    'transaction_id': 'T12345',
    'value': 149.99,
    'currency': 'EUR',
    'items': [...]
  },
  // For enhanced conversions
  'user_data': {
    'email': 'customer@example.com',
    'phone_number': '+31612345678'
  }
});
```

### Lead Form Event
```javascript
dataLayer.push({
  'event': 'generate_lead',
  'value': 50,  // estimated lead value
  'currency': 'EUR',
  'user_data': {
    'email': 'lead@example.com',
    'phone_number': '+31612345678'
  }
});
```

## Consent Mode Integration

Google Ads tags respect Consent Mode. Configure:

```javascript
// Default state (before user consent)
gtag('consent', 'default', {
  'ad_storage': 'denied',
  'ad_user_data': 'denied',
  'ad_personalization': 'denied',
  'analytics_storage': 'denied'
});

// After user grants consent
gtag('consent', 'update', {
  'ad_storage': 'granted',
  'ad_user_data': 'granted',
  'ad_personalization': 'granted',
  'analytics_storage': 'granted'
});
```

With Consent Mode, Google models conversions even when consent is denied (using aggregated data).

## Verification

1. **Google Tag Assistant:** Preview mode in GTM → trigger a test conversion → verify tag fires
2. **Google Ads:** Tools → Conversions → check status = "Recording conversions"
3. **Real-time:** Make a test conversion → check Google Ads within 24h
4. **Cross-reference:** GA4 conversions should approximately match Google Ads conversions

## Common Issues

- **Conversion Linker missing:** GCLID not captured → conversions not attributed
- **Tag fires on page load instead of event:** Overcounting conversions
- **No transaction ID:** Duplicate conversions counted
- **Consent not configured:** Tags blocked by CMP → underreporting
- **Cross-domain tracking:** GCLID lost when navigating between domains
