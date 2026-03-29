---
title: Value-Based Bidding with ML Predictions
date: 2026-03-28
tags:
  - reference
  - tracking-bridge
---

# Value-Based Bidding with ML Predictions

Based on the Google gps-phoebe pattern (github.com/google-marketing-solutions/gps-phoebe).

## Concept

Use machine learning to predict the long-term value of a conversion (e.g., customer lifetime value, lead quality score) and send that predicted value to Google Ads. Smart bidding then optimizes for predicted value, not just the immediate conversion.

## Use Cases

- **E-commerce:** Predict customer lifetime value at first purchase → bid higher for likely repeat customers
- **Lead gen:** Predict lead-to-sale probability → bid higher for likely-to-close leads
- **SaaS:** Predict subscription retention → bid higher for likely-to-retain customers
- **Subscriptions:** Predict LTV based on plan selection and user profile

## Architecture

```
Conversion event → sGTM
    │
    ▼
sGTM: Call Vertex AI prediction endpoint
    │  Input: user features (device, location, product, channel)
    │  Output: predicted value (pLTV, lead score)
    │
    ▼
sGTM: Google Ads Conversion tag
    │  conversion_value = predicted value
    │
    ▼
Google Ads: Target ROAS optimizes for predicted lifetime value
```

## Implementation Steps

### 1. Build Training Data (BigQuery)

Collect historical conversion data with actual outcomes:

```sql
-- Training dataset: what features predict high-value customers?
SELECT
  -- Features available at conversion time
  device_category,
  geo_country,
  traffic_source,
  landing_page,
  first_purchase_value,
  product_category,
  day_of_week,
  hour_of_day,
  -- Target: actual lifetime value (calculated retrospectively)
  SUM(revenue) OVER (
    PARTITION BY customer_id
    ORDER BY transaction_date
    ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
  ) AS actual_ltv
FROM `project.dataset.transactions`
WHERE first_purchase_date BETWEEN '2024-01-01' AND '2024-12-31'
```

### 2. Train Model (Vertex AI)

Train a regression model to predict LTV from features available at conversion time:

- **Model type:** AutoML Tabular Regression or custom TensorFlow/XGBoost
- **Features:** Device, location, source, product category, first order value, time
- **Target:** Actual lifetime value (or lead close probability × deal value)
- **Evaluation:** MAE, RMSE on holdout set

### 3. Deploy Prediction Endpoint

Deploy the trained model as a Vertex AI endpoint:
- Online prediction (low-latency, for real-time sGTM calls)
- Set up authentication (service account)

### 4. sGTM: Call Prediction API

Create an sGTM variable or custom tag that calls the Vertex AI endpoint:

```javascript
// sGTM custom variable (pseudo-code)
const features = {
  device: eventData.device,
  country: eventData.geo.country,
  source: eventData.traffic_source,
  product_category: eventData.items[0].item_category,
  order_value: eventData.value
};

const prediction = callVertexAI(features);
return prediction.predicted_ltv;
```

### 5. Configure Google Ads Tag

- **Conversion Value:** Set to predicted LTV variable
- Google Ads sees the predicted lifetime value, not just the first purchase

### 6. Feedback Loop

Continuously improve predictions:
```
Google Ads conversion (with predicted value)
→ Actual customer behavior (tracked in BQ)
→ Compare predicted vs actual
→ Retrain model periodically
→ Deploy updated model
→ Better predictions → better bidding
```

## Simplified Alternative: Rule-Based Value Scoring

If ML is overkill, use rule-based value adjustments:

```
Base conversion value: €100 (purchase amount)

Multipliers (applied in sGTM):
  + Returning customer: × 1.5
  + High-value product category: × 1.3
  + Desktop purchase: × 1.1 (higher LTV historically)
  + Netherlands location: × 1.2 (better retention)

Adjusted value: €100 × 1.3 = €130 (new customer, high-value category)
```

This is simpler than ML but captures the main value signals.

## Considerations

- **Start simple:** Rule-based value adjustments first, ML when you have enough data (1000+ conversions)
- **Latency:** Vertex AI predictions add ~100-300ms to sGTM processing
- **Cost:** Vertex AI online prediction has per-prediction costs
- **Accuracy:** Predictions don't need to be perfect — directionally correct is enough for bidding
- **Privacy:** Feature data stays on your server; Google only sees the predicted value
