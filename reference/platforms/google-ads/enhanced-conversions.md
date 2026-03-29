---
title: Enhanced Conversions
date: 2026-03-28
tags:
  - reference
  - google-ads
---

# Enhanced Conversions

## What Are Enhanced Conversions?

Enhanced conversions supplement your existing conversion tags by sending hashed first-party customer data (email, phone, name, address) alongside the conversion event. This improves attribution accuracy as third-party cookies decline.

## How It Works

1. User clicks ad → lands on your site
2. User converts (purchase, lead form)
3. Your conversion tag fires AND sends hashed PII (SHA-256)
4. Google matches the hashed data to the signed-in Google user
5. The conversion is attributed more accurately, even across devices

## Data Fields

| Field | Variable Name | Required? |
|-------|--------------|-----------|
| Email | `email` | Strongly recommended |
| Phone | `phone_number` | Recommended |
| First name | `first_name` | Optional (improves match) |
| Last name | `last_name` | Optional (improves match) |
| Street address | `street` | Optional |
| City | `city` | Optional |
| Region/State | `region` | Optional |
| Postal code | `postal_code` | Optional |
| Country | `country` | Optional |

**Minimum:** Email OR phone number. More fields = better match rate.

## Implementation Options

### Option 1: GTM (Web Container) — Recommended

1. **Enable enhanced conversions** in Google Ads:
   - Tools → Conversions → select conversion action → Enhanced conversions → Turn on
   - Choose "Google Tag Manager" as implementation method

2. **Configure in GTM:**
   - Edit your existing Google Ads Conversion Tracking tag
   - Check "Include user-provided data from your website"
   - Create a User-Provided Data variable:
     - Type: "User-Provided Data"
     - Map each field to a Data Layer variable, CSS selector, or JavaScript variable
   - Common approach: push user data to dataLayer on conversion:
     ```javascript
     dataLayer.push({
       'event': 'purchase',
       'enhanced_conversion_data': {
         'email': 'user@example.com',
         'phone_number': '+31612345678'
       }
     });
     ```

3. **GTM tag configuration:**
   - Tag type: Google Ads Conversion Tracking
   - User-Provided Data: select your User-Provided Data variable
   - Hashing: GTM hashes automatically (SHA-256). Send data unhashed.

### Option 2: sGTM (Server Container)

1. **Configure on the server side:**
   - The sGTM Google Ads Conversion Tracking tag supports enhanced conversions natively
   - User data arrives via the event data (from client-side GTM or direct API)
   - Map user data fields in the sGTM tag configuration
   - sGTM handles hashing automatically

2. **Benefits of sGTM for enhanced conversions:**
   - Data stays on your server (better privacy control)
   - Works with consent mode
   - Can enrich data from your backend before sending
   - More resilient to ad blockers

3. **Data flow:**
   ```
   Client GTM → sGTM endpoint → sGTM Google Ads tag (with user data) → Google Ads
   ```

### Option 3: Google Ads API (Offline)

For offline conversions enhanced with customer data:
1. Collect GCLID at conversion time
2. Match with CRM data (email, phone)
3. Upload via Google Ads API with hashed customer data
4. See [[../tracking-bridge/bq-to-gads|bq-to-gads.md]] for BigQuery pipeline

## Enhanced Conversions for Leads

A variant for lead generation where the actual conversion (sale) happens offline:

1. **Capture lead on website** — collect email/phone and store GCLID
2. **Lead qualifies/converts offline** — CRM marks as converted
3. **Upload to Google Ads** — match via hashed email and GCLID
4. Google attributes the offline conversion to the original click

**Setup:**
- Enable "Enhanced conversions for leads" in Google Ads settings
- Tag on the lead form page sends hashed email to Google Ads
- Later, import the offline conversion with the same hashed email
- Google connects the dots

## Consent & Privacy

- Enhanced conversions require user consent for data processing
- Integrate with Google Consent Mode
- Only send data when the user has consented to ad personalization
- GTM/sGTM consent mode handles this automatically when configured
- Hash ALL data before transmission (GTM does this automatically)
- Document your use of enhanced conversions in your privacy policy

## Verification

After setup, verify in Google Ads:
1. Tools → Conversions → select conversion action
2. Check "Enhanced conversions" status: "Recording" = working
3. Allow 48-72 hours for data to appear
4. Monitor the "Diagnostics" tab for warnings or errors
5. Use Google Tag Assistant to verify data is being sent correctly
