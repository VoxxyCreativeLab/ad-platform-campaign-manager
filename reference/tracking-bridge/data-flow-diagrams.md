# Tracking Data Flow Diagrams

## Full-Stack Conversion Tracking Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           USER JOURNEY                                  │
│  Google Ad Click → Website Visit → Browse → Convert (purchase/lead)    │
└──────────┬──────────────────────────────────────────────────┬───────────┘
           │ GCLID in URL                                     │ Conversion Event
           ▼                                                  ▼
┌──────────────────────┐                          ┌──────────────────────┐
│   CLIENT-SIDE GTM    │                          │   CLIENT-SIDE GTM    │
│                      │                          │                      │
│ • Conversion Linker  │                          │ • GA4 Event Tag      │
│   (stores GCLID in   │                          │   (sends to sGTM)    │
│    _gcl_aw cookie)   │                          │ • DataLayer event    │
│                      │                          │   with user_data     │
│ • Consent Mode       │                          │   + ecommerce data   │
│   (CMP integration)  │                          │                      │
└──────────────────────┘                          └──────────┬───────────┘
                                                             │
                                                             │ GA4 Measurement
                                                             │ Protocol Request
                                                             ▼
                                                  ┌──────────────────────┐
                                                  │   SERVER-SIDE GTM    │
                                                  │   (sGTM Container)   │
                                                  │                      │
                                                  │ • GA4 Client         │
                                                  │   (receives event)   │
                                                  │                      │
                                                  │ • Google Ads Conv.   │
                                                  │   Tag (server-side)  │
                                                  │                      │
                                                  │ • GA4 Tag            │
                                                  │   (forwards to GA4)  │
                                                  │                      │
                                                  │ • Custom tags        │
                                                  │   (enrichment, BQ)   │
                                                  └──────┬───────┬───────┘
                                                         │       │
                                           ┌─────────────┘       └─────────────┐
                                           ▼                                   ▼
                                ┌──────────────────┐                ┌──────────────────┐
                                │   GOOGLE ADS     │                │   BIGQUERY        │
                                │                  │                │                   │
                                │ • Conversion     │                │ • Raw events      │
                                │   recorded       │                │ • GA4 export      │
                                │ • GCLID matched  │                │ • Custom tables   │
                                │ • Smart bidding   │                │                   │
                                │   optimizes      │                │ • Offline conv.   │
                                │                  │                │   staging table   │
                                └──────────────────┘                └────────┬──────────┘
                                         ▲                                   │
                                         │                                   │
                                         │  Offline Conversion Import        │
                                         │  (API upload, scheduled)          │
                                         └───────────────────────────────────┘
```

## Client-Side Only Flow (Simpler Setup)

```
User clicks ad (GCLID)
    │
    ▼
Client GTM: Conversion Linker (stores GCLID)
    │
    ▼
User converts on website
    │
    ▼
Client GTM: Google Ads Conversion tag fires
    │  (reads GCLID from cookie)
    │  (includes value, transaction ID)
    │  (includes hashed user data for enhanced conversions)
    │
    ▼
Google Ads: Conversion recorded
```

## Server-Side Flow with Enhanced Conversions

```
User clicks ad (GCLID) → Website
    │
    ▼
Client GTM: Conversion Linker + GA4 Config (transport to sGTM)
    │
    ▼
User converts → dataLayer.push({ event, value, user_data })
    │
    ▼
Client GTM: GA4 Event tag → sends to sGTM endpoint
    │ (event data + cookies including _gcl_aw)
    │
    ▼
sGTM: GA4 Client receives request
    │
    ├── sGTM: Google Ads Conversion tag
    │   (GCLID from cookie + hashed email/phone)
    │   → Google Ads API (server-to-server)
    │
    ├── sGTM: GA4 tag
    │   → Google Analytics (forwarded)
    │
    └── sGTM: BigQuery tag (optional)
        → BigQuery raw events table
```

## Offline Conversion Flow (CRM → Google Ads)

```
User clicks ad (GCLID) → Website → Submits lead form
    │                                      │
    │                                      ▼
    │                              CRM/Database
    │                              (stores GCLID + email + lead data)
    │                                      │
    │                                      │ Lead progresses
    │                                      │ (days/weeks)
    │                                      ▼
    │                              Lead converts offline
    │                              (sale, contract signed)
    │                                      │
    │                                      ▼
    │                              BigQuery
    │                              (CRM data synced)
    │                                      │
    │                                      ▼
    │                              Scheduled job
    │                              (Cloud Function / Megalista)
    │                                      │
    │                                      ▼
    └─────────────────────────────→ Google Ads API
                                   (offline conversion upload)
                                   (GCLID + value + timestamp)
```

## Value-Based Bidding Flow (Profit Data)

```
User converts → sGTM receives event
    │
    ▼
sGTM: Firestore Lookup (profit margins by product)
    │  (from gps_soteria pattern)
    │
    ▼
sGTM: Calculate profit-based value
    │  (revenue × margin = profit)
    │
    ▼
sGTM: Google Ads Conversion tag
    │  (sends profit as conversion value, not revenue)
    │
    ▼
Google Ads: Smart bidding optimizes for profit, not revenue
```
