---
title: BigQuery to Google Ads — Offline Conversions & Audience Pipelines
date: 2026-03-28
tags:
  - reference
  - tracking-bridge
---

# BigQuery to Google Ads — Offline Conversions & Audience Pipelines

## Use Cases

1. **Offline Conversion Import:** Upload CRM conversions (lead qualified, deal closed) matched to clicks
2. **Customer Match:** Upload customer lists for audience targeting
3. **Enhanced Conversions for Leads:** Match offline conversions to online leads via hashed email
4. **Store Sales:** Import in-store transaction data matched to ad interactions

## Offline Conversion Import via GCLID

### Architecture
```
1. User clicks ad → lands on site
2. GCLID captured and stored in CRM/database alongside lead
3. Lead progresses through pipeline (days/weeks)
4. Lead converts offline (sale, contract signed)
5. CRM data exported to BigQuery
6. BigQuery job matches conversions with GCLIDs
7. Upload to Google Ads via API (conversion import)
```

### BigQuery Table Schema

```sql
CREATE TABLE `project.dataset.offline_conversions` (
  gclid STRING NOT NULL,
  conversion_name STRING NOT NULL,       -- Matches Google Ads conversion action name
  conversion_time TIMESTAMP NOT NULL,     -- When the offline conversion happened
  conversion_value FLOAT64,              -- Revenue/value of the conversion
  conversion_currency STRING DEFAULT 'EUR',
  -- Enhanced conversion data (hashed)
  hashed_email STRING,                    -- SHA-256 hashed, lowercase, trimmed
  hashed_phone STRING,                    -- SHA-256 hashed, E.164 format
  order_id STRING,                        -- Transaction ID for deduplication
  uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
  upload_status STRING DEFAULT 'pending'  -- pending, uploaded, failed
);
```

### Upload Query (Extract for API)
```sql
SELECT
  gclid,
  conversion_name,
  FORMAT_TIMESTAMP('%Y-%m-%d %H:%M:%S%Ez', conversion_time) AS conversion_time,
  conversion_value,
  conversion_currency,
  order_id
FROM `project.dataset.offline_conversions`
WHERE upload_status = 'pending'
  AND conversion_time > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
ORDER BY conversion_time ASC
```

### Important Rules
- Upload within 90 days of the click (Google's attribution window)
- GCLID must be captured at click time and stored in your database
- Use a unique order_id to prevent duplicate uploads
- Conversion name must exactly match the Google Ads conversion action name
- Account for timezone: conversion_time should include timezone offset

## Enhanced Conversions for Leads (Without GCLID)

When you can't store GCLIDs (e.g., phone leads), use hashed email to match:

### Architecture
```
1. User clicks ad → submits lead form (email captured)
2. Website tag sends hashed email to Google Ads (Enhanced Conversions)
3. Lead converts offline (days/weeks later)
4. Upload offline conversion with same hashed email
5. Google matches the offline conversion to the original click
```

### BigQuery Hashing
```sql
-- Hash email for Google Ads matching
SELECT
  TO_HEX(SHA256(LOWER(TRIM(email)))) AS hashed_email,
  -- Hash phone (E.164 format)
  TO_HEX(SHA256(
    CONCAT('+', REGEXP_REPLACE(phone, r'[^0-9]', ''))
  )) AS hashed_phone,
  conversion_name,
  conversion_time,
  conversion_value
FROM `project.dataset.crm_conversions`
WHERE upload_status = 'pending'
```

## Customer Match (Audience Upload)

Upload customer lists from BigQuery for targeting in Google Ads:

### BigQuery Schema
```sql
CREATE TABLE `project.dataset.customer_list` (
  hashed_email STRING,
  hashed_phone STRING,
  hashed_first_name STRING,
  hashed_last_name STRING,
  country_code STRING,
  zip_code STRING,
  list_name STRING,       -- Which audience list this belongs to
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);
```

### Audience Segmentation Example
```sql
-- High-value customers for lookalike targeting
SELECT
  TO_HEX(SHA256(LOWER(TRIM(email)))) AS hashed_email,
  'High Value Customers' AS list_name
FROM `project.dataset.customers`
WHERE lifetime_value > 500
  AND last_purchase_date > DATE_SUB(CURRENT_DATE(), INTERVAL 180 DAY)
```

## Pipeline Tools

### Google Megalista
Open-source tool (github.com/google/megalista) for automated uploads:
- Reads from BigQuery / Google Sheets
- Uploads to Google Ads (conversions, customer match, store sales)
- Also supports GA4, CM360, DV360
- Runs on Google Cloud Dataflow (Apache Beam)
- Scheduled via Cloud Scheduler

### Google Ads API Direct
- Python client: `google-ads-python`
- Upload conversions via `ConversionUploadService`
- Upload customer lists via `OfflineUserDataJobService`
- Can be scheduled as a Cloud Function or Cloud Run job

### Scheduled BigQuery Export
```
BigQuery (source of truth)
→ Scheduled query (extract pending conversions)
→ Cloud Function (triggered by schedule)
→ Google Ads API (upload conversions)
→ BigQuery (mark as uploaded)
```

## Verification

- Google Ads → Tools → Conversions → select action → "Diagnostics" tab
- Check upload success rate and error logs
- Compare uploaded count vs BigQuery source count
- Allow 24-48h for imported conversions to appear in reports
- Monitor for "partial" uploads — some rows may fail while others succeed
