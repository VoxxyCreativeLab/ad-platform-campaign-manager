# Profit-Based Bidding via sGTM

Based on the Google gps_soteria pattern (github.com/google-marketing-solutions/gps_soteria).

## Concept

Instead of sending revenue as the conversion value to Google Ads, send **profit**. This way, smart bidding (Target ROAS) optimizes for profitability, not just top-line revenue.

```
Traditional:  Google Ads optimizes for revenue (€100 sale with €10 margin = same as €100 sale with €90 margin)
Profit-based: Google Ads optimizes for profit (€10 vs €90 — very different value)
```

## Architecture

```
Purchase event → sGTM
    │
    ▼
sGTM: Look up product margins (Firestore / API)
    │  Products in cart → margin per product
    │
    ▼
sGTM: Calculate profit value
    │  Sum(quantity × price × margin_rate) per product
    │
    ▼
sGTM: Google Ads Conversion tag
    │  conversion_value = calculated profit (not revenue)
    │
    ▼
Google Ads: Target ROAS optimizes for profit
```

## Implementation Steps

### 1. Build Margin Data Source

Store product margins in Firestore (or another data source accessible from sGTM):

**Firestore structure:**
```
Collection: products
Document: {product_id}
Fields:
  - margin_rate: 0.35  (35% margin)
  - category: "electronics"
  - cost: 65.00
```

**Alternative: BigQuery → Firestore sync**
If margins live in BigQuery, set up a scheduled sync:
```
BigQuery (product catalog with costs)
→ Cloud Function (scheduled daily)
→ Firestore (product margins)
→ sGTM reads at conversion time
```

### 2. sGTM Variable: Firestore Lookup

Create an sGTM variable that reads margins from Firestore:
- Variable type: Firestore Lookup
- Project ID: your GCP project
- Collection: products
- Document path: constructed from event data product ID
- Return field: margin_rate

### 3. sGTM Variable: Calculate Profit

Create a custom variable that computes profit:

```javascript
// Pseudo-code for sGTM custom variable
const items = eventData.items || [];
let totalProfit = 0;

for (const item of items) {
  const marginRate = firestoreLookup(item.item_id);  // e.g., 0.35
  const itemProfit = item.price * item.quantity * marginRate;
  totalProfit += itemProfit;
}

return totalProfit;
```

### 4. Configure Google Ads Tag

In the sGTM Google Ads Conversion Tracking tag:
- **Conversion Value:** Set to your calculated profit variable (not `value` from event data)
- **Currency:** Same as original

### 5. Adjust Target ROAS

Since you're now sending profit (not revenue), your ROAS targets change:

| Before (revenue) | After (profit) | Explanation |
|-------------------|-----------------|-------------|
| Target ROAS: 400% | Target ROAS: 140% | €4 revenue per €1 spent → ~€1.40 profit per €1 spent (35% margin) |

**Formula:** New Target ROAS = Old Target ROAS × Average Margin Rate

## Privacy Considerations

- Margin data stays on your server (sGTM) — never sent to the client
- Google only sees the final profit value, not your margins
- No PII involved in margin calculations
- This is purely a value transformation, fully compliant

## Monitoring

- Compare Google Ads reported conversion value (profit) against actual profit in your database
- Track margin accuracy over time (margins change)
- Set up alerts if margin data source becomes stale
- Keep Firestore margin data updated (at least daily for dynamic pricing)
