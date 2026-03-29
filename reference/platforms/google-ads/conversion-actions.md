---
title: Google Ads Conversion Actions
date: 2026-03-28
tags:
  - reference
  - google-ads
---

# Google Ads Conversion Actions

## What Is a Conversion Action?

A specific customer action you want to track (purchase, lead, sign-up). Google Ads uses conversion data to optimize bidding and report campaign performance.

## Conversion Action Types

### Website Conversions
Actions on your website tracked via a tag (GTM/sGTM) or Google tag.

- **Purchase/Sale:** Transaction with value
- **Lead/Form submission:** Contact form, quote request
- **Sign-up:** Account creation, newsletter subscription
- **Page view:** Key page visited (pricing, confirmation)
- **Click-to-call:** Phone number clicks on website

### Phone Call Conversions
- **Calls from ads:** Clicks on call extension or call-only ads
- **Calls to a number on your website:** Tracked via Google forwarding number
- **Imported calls:** Call data imported from a CRM

### App Conversions
- App installs and in-app actions tracked via Firebase or third-party

### Offline Conversions (Import)
Actions that happen offline, imported back to Google Ads.

- **Click-through conversions:** Match offline event to a click via GCLID
- **Call conversions:** Match to a call
- **Store visits:** Estimated from location data (Google-managed)

### Enhanced Conversions
First-party data (hashed email, phone, address) sent alongside the conversion to improve attribution accuracy in a cookieless world.

See [[enhanced-conversions]] for setup details.

## Configuration Settings

### Counting
- **One:** Count one conversion per click (use for leads — one form = one lead, regardless of resubmissions)
- **Every:** Count every conversion per click (use for purchases — multiple purchases from one click all count)

### Conversion Window
- **Click-through window:** 1-90 days (default 30). How long after a click a conversion is attributed.
- **View-through window:** 1-30 days (default 1). How long after an ad view (no click).
- **Engaged-view window:** 1-30 days (default 3). For video ads — 10+ seconds watched.

### Attribution Model
- **Data-driven (default, recommended):** Uses Google's AI to assign credit across touchpoints
- **Last click:** All credit to the last-clicked ad
- Data-driven is strongly recommended — it gives Google the fullest picture for smart bidding

### Value
- **Use the same value for each:** Fixed value per conversion (e.g., every lead = €50)
- **Use different values for each:** Dynamic value passed from the website (e.g., transaction revenue)
- **Don't use a value:** Not recommended — value data enables better optimization

### Category
Categorize conversions for reporting:
- Purchase/Sale
- Lead (sign-up, subscribe, contact)
- Page view
- Add to cart
- Begin checkout
- Other

## Primary vs Secondary Conversions

- **Primary:** Used for bidding optimization. Google optimizes campaigns toward these.
- **Secondary:** Tracked for observation/reporting only. Not used in bidding.

**Best practice:**
- Set your main business goal as **primary** (purchase, qualified lead)
- Set micro-conversions as **secondary** (add to cart, page view, newsletter sign-up)
- Having too many primary conversions confuses smart bidding

## Conversion Action Setup Flow

```
1. Define the conversion action in Google Ads
   └── Settings: name, category, value, counting, window, attribution
2. Get the conversion ID and label
3. Implement tracking tag
   ├── Option A: GTM (web container) — Google Ads Conversion Tracking tag
   ├── Option B: sGTM (server container) — Google Ads Conversion Tracking tag
   └── Option C: Google tag (gtag.js) — direct on-page snippet
4. Verify in Google Ads → Tools → Conversions → check status
5. Test with Google Tag Assistant
```

For implementation details, see `/ad-platform-campaign-manager:conversion-tracking`.

## Conversion Tracking Checklist

- [ ] At least one primary conversion action configured
- [ ] Counting method matches conversion type (One for leads, Every for purchases)
- [ ] Conversion values set (fixed or dynamic)
- [ ] Attribution model set to data-driven
- [ ] Click-through window appropriate for sales cycle
- [ ] Enhanced conversions enabled where possible
- [ ] Conversion actions assigned to correct campaigns
- [ ] Tag implemented and verified (status: "Recording conversions")
