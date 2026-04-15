---
name: product-performance
description: "Analyze product-level performance from Shopping and PMax campaigns — identify zombie products, top converters, and feed optimization candidates. Use for e-commerce accounts with Shopping or feed-only PMax campaigns."
argument-hint: "[account-name or analysis-type]"
disable-model-invocation: false
---

# Product Performance Analysis

Guided product-level analysis for Shopping and Performance Max campaigns. Wraps `shopping_performance_view` GAQL queries to identify revenue drivers, wasted spend, and feed optimization opportunities.

## Prerequisites

1. MCP connected — run `mcp__google-ads__write_status` to verify
2. Account has Shopping campaigns, PMax feed-only campaigns, or both
3. Account has at least 14 days of conversion data for meaningful analysis (30+ days preferred)

## Reference Material

- [[reference/platforms/google-ads/shopping-campaigns|Shopping Campaigns]]
- [[reference/platforms/google-ads/pmax/feed-only-pmax|Feed-Only PMax]]
- [[reference/platforms/google-ads/pmax/feed-optimization|Feed Optimization]]
- [[reference/platforms/google-ads/shopping-feed-strategy|Shopping Feed Strategy]]
- [[reference/reporting/gaql-query-templates|GAQL Query Templates]] (Shopping / Product Performance section)
- [[reference/mcp/mcp-capabilities|MCP Capabilities]]

---

## Step 1: Establish Context

Ask the user:

1. **Which account?** → Use `mcp__google-ads__list_accounts` to list available accounts, then select with `mcp__google-ads__get_account_metrics`
2. **Campaign type?** → Shopping campaigns, PMax feed-only, or both? *(Affects exclusion method in Step 4)*
3. **Date range?** → Default: LAST_30_DAYS. For seasonal products (outdoor, holiday, back-to-school), use LAST_90_DAYS to avoid false zombie identification
4. **Revenue threshold?** → What conversion value is considered "performing"? Helps calibrate zombie severity. Example: for a €50 avg order value account, even 1 conversion = €50 minimum bar

> [!tip] Account context
> If the user has run `/ad-platform-campaign-manager:account-strategy`, the account profile already has campaign type and performance context. Ask them to share it, or load it if inside an MWP project.

---

## Step 2: Pull Product Data via MCP

Run 4 GAQL queries using `mcp__google-ads__run_gaql`. Adjust date range and `LIMIT` per user context from Step 1.

> [!note] Date segmentation restriction
> `segments.date` cannot appear in the SELECT clause for `shopping_performance_view` — it causes an `UNSUPPORTED_DATE_SEGMENTATION` error. Use it only in WHERE clauses (as shown below). Current queries are correct as written.

### 2a. Top Products by Revenue

```sql
SELECT
  segments.product_item_id,
  segments.product_title,
  segments.product_brand,
  segments.product_category_level1,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM shopping_performance_view
WHERE segments.date DURING LAST_30_DAYS
ORDER BY metrics.conversions_value DESC
LIMIT 50
```

### 2b. Zombie Products (Spend With Zero Conversions)

Products consuming budget with no return — candidates for exclusion or feed optimization.

```sql
SELECT
  segments.product_item_id,
  segments.product_title,
  segments.product_brand,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions
FROM shopping_performance_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.cost_micros > 0
  AND metrics.conversions = 0
ORDER BY metrics.cost_micros DESC
LIMIT 50
```

### 2c. Product Category Performance

Roll-up view to identify strong and weak categories before drilling to individual products.

```sql
SELECT
  segments.product_category_level1,
  segments.product_category_level2,
  metrics.impressions,
  metrics.clicks,
  metrics.cost_micros,
  metrics.conversions,
  metrics.conversions_value
FROM shopping_performance_view
WHERE segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```

### 2d. High-Impression Low-CTR Products (Feed Optimization Candidates)

Products getting shown but not clicked — usually a title, image, or pricing issue in the feed.

```sql
SELECT
  segments.product_item_id,
  segments.product_title,
  metrics.impressions,
  metrics.clicks,
  metrics.ctr,
  metrics.cost_micros
FROM shopping_performance_view
WHERE segments.date DURING LAST_30_DAYS
  AND metrics.impressions > 100
  AND metrics.ctr < 0.01
ORDER BY metrics.impressions DESC
LIMIT 50
```

---

## Step 3: Analyze Results

For each query result, present findings in a structured table and interpret:

### Top Converters

- Which products drive the most revenue?
- Is revenue concentrated (top 10 products = 80%+ of revenue) or distributed? *(Concentration is normal for PMax — the "hero product" pattern)*
- Are top converters from expected categories or surprising ones?
- ROAS per product: `conversions_value / (cost_micros / 1,000,000)`

### Zombie Products

Present all zombies in a table: `product_item_id | product_title | brand | impressions | clicks | spend`.

Triage by severity:
- **High priority** — spend > €10 equivalent (`cost_micros > 10,000,000`) with zero conversions → immediate action candidate
- **Monitor** — spend < €10, low impressions → may not have received enough budget to judge; extend date range to 90 days before acting
- **PMax caveat** — zombies in PMax are common because PMax allocates ~80% of budget to hero products; a product with zero spend is invisible/deprioritized, not necessarily broken

Ask: "Are any of these products seasonal or recently added?" before recommending exclusion.

### Category Performance

- Which categories have best/worst ROAS?
- Any categories with high spend but low conversions? (Structural issue vs. individual product issue)
- Compare category ROAS against account average

### Feed Optimization Candidates

For products with >100 impressions and <1% CTR, diagnose the likely cause:

| Symptom | Most Likely Cause | Fix |
|---------|------------------|-----|
| Generic title (e.g. "Blue Shirt") | Title not front-loaded with key terms | Rewrite: Brand + Product Type + Attributes |
| High CTR on similar products | Pricing uncompetitive | Review price vs. listed alternatives |
| Zero clicks on high impressions | Image quality / background issue | Update to white background, product fills 75-90% frame |
| Category-wide low CTR | Missing GTINs | Add correct GTINs — 20% avg click increase |
| Inconsistent CTR by product type | Product type too vague | Use more specific product type (5-level hierarchy) |

---

## Step 4: Recommend Actions

Based on analysis, recommend actions categorized by urgency and campaign type:

### Immediate — Safe During Learning Phase

> [!warning] Campaign type matters for exclusion method
> Standard Shopping and PMax require different exclusion approaches.

| Campaign Type | Zombie Exclusion Method |
|---------------|------------------------|
| Standard Shopping | Add as **negative product target** at ad group level |
| PMax | Edit **listing group** to exclude the product item ID from the asset group |
| Both | If excluding from all campaigns: suppress in Merchant Center via `excluded_destination` (affects all campaigns) |

- Identify and route top 5–10 zombies to exclusion (sorted by spend DESC)
- Flag feed optimization candidates for title/image improvements — report to the client with specific product IDs

### Requires Merchant Center Access — Manual

- Update product **titles** for low-CTR items: lead with Brand + Product Type + Key Attributes. First 70 chars visible in ads.
- Check **image quality** for underperformers: white/light background, no text overlays, product fills frame
- Add missing **GTINs** — expect ~20% click increase on affected products
- Review **pricing** for products with high impressions, low CTR, and competitive category landscape

> [!note] MCP boundary
> Feed health data (disapprovals, GTIN coverage, image issues) lives in Merchant Center, not the Google Ads API. Use `shopping_product` resource for current product state diagnosis. Product-level feed recommendations must be actioned in Merchant Center or via Content API.

### Strategic — After Learning Period (post day 30+)

- Reallocate budget toward top-performing categories (Standard Shopping: adjust product group bids; PMax: use listing group bid adjustments)
- Consider campaign restructuring if zombie concentration is high in specific categories (e.g., separate zombies into a low-budget test campaign with Maximize Clicks)
- For PMax: create a supplemental Standard Shopping campaign for zombie products with manual CPC bidding — gives control that PMax AI doesn't provide

---

## Step 5: Route to Next Steps

Based on findings, suggest relevant skills:

| Finding | Route to |
|---------|----------|
| Feed needs systematic optimization | [[skills/pmax-guide/SKILL.md\|PMax Guide]] (feed optimization section) |
| Budget reallocation across campaigns | [[skills/budget-optimizer/SKILL.md\|Budget Optimizer]] |
| Campaign restructuring needed | [[skills/campaign-setup/SKILL.md\|Campaign Setup]] |
| Full account health check needed | [[skills/campaign-review/SKILL.md\|Campaign Review]] |
| Shopping → PMax migration considered | [[skills/pmax-guide/SKILL.md\|PMax Guide]] (migration path) |
| Post-launch monitoring (new campaigns) | [[skills/post-launch-monitor/SKILL.md\|Post-Launch Monitor]] |

---

## Report Output

When running inside an MWP client project, write report to files:

- **Stage:** `05-optimize`
- **File path:** `reports/{YYYY-MM-DD}/05-optimize/product-performance.md`
- **SUMMARY.md section:** Optimization & Reporting
- **Write sequence:** Follow 6-step protocol in [[_config/conventions#Report File-Writing Convention]]
- **Completeness:** Follow [[_config/conventions#Output Completeness Convention]] — every product row, every metric, no truncation. If zombie list exceeds ~500 lines, split into `product-performance-zombies.md` in the same stage folder.
- **Fallback:** If not in an MWP project, present all findings in conversation

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| No data returned | Account has no Shopping/PMax campaigns, or campaigns have no spend | Verify campaign types with `mcp__google-ads__list_campaigns` |
| Zero conversions everywhere | Conversion tracking not set up, or conversion window too short | Route to `/ad-platform-campaign-manager:conversion-tracking` |
| Very few products returned | Feed has limited inventory | Normal for small catalogs — lower `LIMIT` values |
| `UNSUPPORTED_DATE_SEGMENTATION` error | `segments.date` accidentally placed in SELECT | Move date filter to WHERE clause only |
| `shopping_performance_view` returns empty | Products never served any ads | Use `shopping_product` resource to diagnose current product state (eligibility, disapprovals) |
| All products show zero conversions in PMax | PMax learning phase active | Check with `/ad-platform-campaign-manager:post-launch-monitor` — may be too early to optimize |
