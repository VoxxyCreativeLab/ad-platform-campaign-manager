---
title: Google Ads Attribution Guide
date: 2026-04-03
tags: [reference, strategy, attribution, measurement, CPA, ROAS]
---

# Google Ads Attribution Guide

%%
Attribution and measurement reference for a tracking specialist managing Google Ads accounts.
Covers models, windows, cross-channel challenges, CPA vs CAC, ROAS vs profit metrics,
multi-touch analysis in GA4, and offline conversion imports.
%%

> [!info] Scope
> This document covers how Google Ads attributes value to campaigns, ads, and keywords — and how that maps (or doesn't) to real business outcomes. Written for a tracking specialist who already understands the data pipeline but needs to apply that knowledge to campaign measurement decisions.

---

## 1. Attribution Models in Google Ads

Attribution models determine how conversion credit is distributed across the touchpoints in a user's path before converting. Your choice of model directly affects what Smart Bidding optimises toward — it changes bid signals at the keyword and ad group level.

%%fact-check: Data-driven attribution 300 conversion threshold — verified 2026-04-03%%
%%fact-check: Attribution model deprecation — Google defaulting to data-driven for new actions since 2023 — verified 2026-04-03%%

| Model | How It Works | When to Use | Impact on Smart Bidding |
|---|---|---|---|
| **Data-Driven (recommended)** | Machine learning distributes fractional credit to each touchpoint based on its actual contribution to conversion probability. Requires conversion history. | Default for established accounts with sufficient volume. Best signal for Target CPA/ROAS. | Highest quality signal. Bidding uses partial credit per keyword — upper-funnel keywords get appropriate value. |
| **Last Click** | 100% credit to the last ad the user clicked before converting. Ignores all prior touchpoints. | Legacy accounts; benchmarking against historical data; when you need the simplest, most auditable model. | Over-values bottom-of-funnel keywords. Under-funds discovery and brand awareness campaigns. |
| **First Click** | 100% credit to the first ad clicked. Ignores all subsequent touchpoints. | Rarely recommended. Use only when measuring pure acquisition/discovery campaigns where first-touch is the KPI. | Over-values top-of-funnel. Smart Bidding will over-invest in awareness placements at the expense of conversion close. |
| **Linear** | Equal credit split across all touchpoints in the path. | Useful for understanding which touchpoints participate in the path — good for exploratory analysis. | Flattens the performance signal. Bidding can't differentiate high- and low-value moments. |
| **Time Decay** | More credit to touchpoints closer to conversion. Exponential decay with 7-day half-life. | When recency of ad interaction is genuinely important — e.g., short buying cycles, flash sales. | Biases toward lower-funnel. Somewhat better than Last Click but still under-values upper funnel. |
| **Position-Based** | 40% to first click, 40% to last click, 20% split evenly among middle touchpoints. | When you want to reward both discovery and close, with some middle-path credit. | Reasonable balance for multi-step funnels. Better than last click; less sophisticated than data-driven. |

> [!warning] Model Deprecation in Progress
> Google has been consolidating toward data-driven attribution as the default for new conversion actions since 2023. As of early 2026, First Click, Linear, Time Decay, and Position-Based are still available but Google may deprecate them for Smart Bidding signals. New accounts should start with data-driven from day one.

> [!tip] Minimum Volume for Data-Driven
> Data-driven attribution requires **300+ conversions in a 30-day window** to build its model. Below this threshold, Google falls back to Last Click automatically. Track your monthly conversion volume — if a conversion action regularly falls below 300, either consolidate conversion actions (e.g., combine micro-conversions into a single action) or accept Last Click for that action and plan accordingly.

---

## 2. Attribution Windows

Attribution windows define how far back Google looks for ad interactions when crediting a conversion. Longer windows capture longer buying cycles; shorter windows keep data fresh.

%%fact-check: Google Ads attribution window ranges (click-through 1–90 days, view-through 1–30 days) — verified 2026-04-03%%

### 2.1 Window Types

| Window Type | Range | Default | Applies To |
|---|---|---|---|
| **Click-through** | 1–90 days | 30 days | All campaign types |
| **Engaged-view** | 1–30 days | 3 days | Video campaigns (YouTube) |
| **View-through** | 1–30 days | 1 day | Display, Video |

**Click-through window** — how many days after a click Google will credit a conversion to that click. A 30-day window means a user who clicked your ad on Day 1 and purchased on Day 28 is credited.

**Engaged-view window** — for video ads only. Applies when a user watched at least 10 seconds of a skippable in-stream ad (without clicking) and then converted.

**View-through window** — applies when a user saw (but did not click) a Display or Video ad and then converted directly (not via another ad click). View-through conversions are reported separately and should NOT be included in Smart Bidding conversion column by default — they represent a weaker signal and inflate apparent performance.

### 2.2 Window Selection by Vertical

| Vertical | Recommended Click-Through Window | Rationale |
|---|---|---|
| E-commerce (impulse) | 7–14 days | Purchase decision is fast; longer windows dilute the signal with unrelated sessions |
| E-commerce (considered) | 30 days | Higher-price products (furniture, electronics) have longer research phases |
| Lead Generation (B2C) | 30 days | Inquiry-to-contact cycle is typically days to weeks |
| Lead Generation (B2B) | 60–90 days | B2B sales cycles are long; a 30-day window loses late converters |
| Local Services | 7–14 days | Local intent is immediate; long windows capture unrelated actions |
| B2B SaaS | 90 days | Enterprise buying cycles can span months |

> [!note] Window vs Buying Cycle
> Set your click-through window to match your typical purchase decision window — not longer. An inflated window flatters your CPA numbers (more conversions attributed to ads) but degrades Smart Bidding signal quality by attributing conversions that were genuinely driven by other factors.

---

## 3. Cross-Channel Attribution Challenges

Google Ads and GA4 will never report identical conversion numbers. Understanding why is essential before reporting to clients or making budget decisions.

### 3.1 Why Numbers Don't Match

| Source of Discrepancy | Google Ads Reports | GA4 Reports |
|---|---|---|
| **Default attribution model** | Data-driven (fractional credit) or Last Click per conversion action setting | Last non-direct click (in GA4 reports); data-driven available in Explore |
| **Conversion counting** | Configurable: "Every" counts all conversions; "One" counts one per click window | GA4 counts one conversion event per session by default |
| **Cross-device** | Google stitches signed-in user IDs across devices | GA4 depends on user_id or client_id; cross-device matching is partial |
| **Click-through window** | Up to 90 days | GA4 session attribution looks back at the session, not a 90-day window |
| **View-through** | Included if configured | Not included in standard GA4 acquisition reports |
| **Spam/invalid clicks** | Google filters invalid clicks automatically | GA4 may include sessions Google classified as invalid |

### 3.2 How to Reconcile

> [!tip] Pick One Source of Truth per Decision
> - **In-platform optimisation** (bidding, keyword decisions): use Google Ads conversion data
> - **Cross-channel budget allocation** (Google vs Meta vs organic): use GA4
> - **Business reporting** (to clients, CFO): use CRM or BigQuery as the canonical source — neither platform knows about offline revenue

**Reconciliation checklist:**
1. Confirm the same conversion window is configured in both Google Ads and GA4
2. Use "One" conversion counting in Google Ads for primary conversion actions (avoids inflating CPA)
3. In GA4, use the "Advertising" > "Attribution" reports (not standard Acquisition) for model-aligned comparisons
4. Export raw conversion events from sGTM to BigQuery and join on GCLID for the most accurate cross-platform view — see `[[../../tracking-bridge/bq-to-gads]]`

---

## 4. CPA vs CAC (True Cost Analysis)

The most important distinction in performance measurement is between what the platform reports and what the business actually pays to acquire a customer.

### 4.1 Definitions

**CPA (Cost Per Acquisition)** — an in-platform metric.

```
CPA = Ad spend ÷ Conversions (as tracked by Google Ads)
```

CPA only counts the ad spend in that campaign. It ignores everything else.

**CAC (Customer Acquisition Cost)** — a business metric.

```
CAC = Total acquisition cost ÷ New customers acquired
```

Total acquisition cost includes:
- Ad spend (all channels)
- Agency/consultant fees
- Landing page and CRO tool costs (Unbounce, VWO, etc.)
- Marketing automation platform costs (Klaviyo, HubSpot, etc.)
- Sales team time (for B2B: SDR hours × hourly cost)
- Attribution tooling (Northbeam, Triple Whale, etc.)

### 4.2 Why the Gap Matters

| Scenario | CPA | CAC | Verdict |
|---|---|---|---|
| Ad spend €50, agency fee adds €30 overhead per acquisition | €50 | €80 | Acceptable if LTV > €80 |
| CPA looks fine but sales team closes 1 in 5 MQLs at €40/hour (5 hours each) | €60 | €260 | Loss at most product price points |
| High CPA but no other acquisition cost | €150 | €150 | Simple — evaluate against LTV |

### 4.3 Calculating Blended CAC from Google Ads Data

When you have BigQuery data from the sGTM pipeline:

```sql
-- Blended CAC calculation
-- Assumes all costs are loaded to a costs table
SELECT
  DATE_TRUNC(conversion_date, MONTH) AS month,
  SUM(ad_spend) AS total_ad_spend,
  SUM(agency_fees) AS agency_fees,
  SUM(tool_costs) AS tool_costs,
  COUNT(DISTINCT new_customer_id) AS new_customers,
  SAFE_DIVIDE(
    SUM(ad_spend) + SUM(agency_fees) + SUM(tool_costs),
    COUNT(DISTINCT new_customer_id)
  ) AS blended_cac
FROM costs_table c
JOIN conversions_table conv USING (month)
WHERE conv.is_new_customer = TRUE
GROUP BY 1
ORDER BY 1 DESC
```

%%
This query is illustrative. Adapt to your BigQuery schema.
New customer identification requires first_purchase logic in the conversions table.
%%

> [!warning] CPA as the Only Metric Is Dangerous
> A CPA of €50 with a 10% product margin means €5 profit before acquisition cost. At €50 CPA, every conversion loses money. Always sanity-check CPA targets against: (a) product margin, (b) average order value, (c) expected repeat purchase rate, and (d) customer lifetime value.

---

## 5. ROAS vs Profit-Based Metrics

ROAS is the most-cited performance metric in Google Ads. It is also one of the most misleading when used without margin context.

%%fact-check: Google Ads target ROAS smart bidding availability — verified 2026-04-03%%

### 5.1 ROAS Definition

```
ROAS = Conversion Value ÷ Cost
```

A ROAS of 5x means €5 in reported revenue for every €1 of ad spend.

### 5.2 Why ROAS Can Be Misleading

**Example — the 5x ROAS trap:**

| Item | Value |
|---|---|
| Product price | €100 |
| Product margin | 10% (€10 gross profit) |
| Ad spend to generate sale | €20 (5x ROAS = €100 / €20) |
| Gross profit after ad spend | €10 − €20 = **−€10 loss** |

A 5x ROAS on a low-margin product loses money. The break-even ROAS depends entirely on margin:

```
Break-even ROAS = 1 ÷ Gross Margin %
```

| Gross Margin | Break-Even ROAS |
|---|---|
| 10% | 10x |
| 25% | 4x |
| 50% | 2x |
| 75% | 1.33x |

> [!danger] Target ROAS Without Margin Data
> If you set a Target ROAS of 5x on a product with 10% margin, Smart Bidding will optimise for a configuration that loses money on every conversion. Always calculate break-even ROAS before setting tROAS targets.

### 5.3 Profit-Based Bidding

The solution is to feed **margin-adjusted conversion values** into Google Ads, so Smart Bidding optimises for profit rather than revenue.

**Implementation options:**

| Option | Mechanism | Complexity |
|---|---|---|
| Static margin multiplier | Set conversion value = sale price × margin % in GTM tag | Low — one-time GTM change |
| Product-level margin from feed | Pass margin as custom variable from the product feed or data layer | Medium — requires data layer + feed hygiene |
| Dynamic margin from BigQuery | Write margin data to BQ, batch-import via Offline Conversion Import | High — requires sGTM pipeline |

For the full implementation, see `[[../../tracking-bridge/profit-based-bidding]]` and `[[../../tracking-bridge/value-based-bidding]]`.

> [!tip] Tracking Specialist Advantage
> This is where your infrastructure expertise is a direct competitive advantage. Most agencies set conversion value = transaction revenue and call it done. You can pipe actual margin data from a BigQuery `products` table into sGTM and pass it as the conversion value dynamically — making Smart Bidding optimise for profit from day one.

---

## 6. Multi-Touch Analysis with GA4

Last-click data shows you what closed the sale. Multi-touch analysis shows you what built the path to the sale. Skipping this leads to under-funding campaigns that drive reach and consideration.

### 6.1 Key GA4 Reports

**Advertising > Attribution > Top Conversion Paths**
- Shows the sequence of channel touchpoints before conversion
- Identifies which channels appear most often in multi-step paths
- Look for patterns: e.g., "Paid Search (brand) always follows Organic (non-brand)" → non-brand organic is driving discovery

**Advertising > Attribution > Assisted Conversions**
- Shows conversions where a channel was in the path but not the last touchpoint
- A campaign with 10 last-click conversions but 60 assisted conversions is doing more work than it appears

**Explore > Funnel Exploration**
- Build custom funnel steps using GA4 events
- Identify where users drop out of the conversion funnel by channel segment

### 6.2 Identifying Hidden Contributors

Look for campaigns with:
- High impression share + low conversion volume → possible assist role
- High CTR + low conversion rate → driving consideration, not direct conversion
- Declining last-click conversions when paused, but other campaigns also decline → halo effect

> [!warning] Never Pause on Last-Click Alone
> If a campaign has zero last-click conversions but high assisted conversion volume, pausing it will hurt overall account performance — even though the Google Ads dashboard makes it look like a waste. Always cross-reference with GA4 assisted conversion data before pausing any campaign that has been running for more than 4 weeks.

### 6.3 Recommended Workflow

1. Export Top Conversion Paths from GA4 weekly
2. Flag any campaign appearing in 20%+ of paths but showing low Google Ads last-click CPA
3. Calculate "true" contribution: (last-click conversions × 1.0) + (assisted conversions × 0.3–0.5)
4. Include the assisted value in budget justification, not just in-platform CPA

---

## 7. Attribution for Offline Conversions

For lead generation and B2B accounts, the most important conversions happen offline — a phone call, a CRM deal closed, a signed contract. Google Ads needs these signals to optimise Smart Bidding toward real outcomes.

%%fact-check: GCLID offline conversion import 90-day upload window — verified 2026-04-03%%

### 7.1 GCLID-Based Matching

The GCLID (Google Click ID) is the foundation of offline conversion import. When a user clicks a Google Ad, a GCLID is appended to the URL. Your form or CRM must capture and store it.

**Implementation checklist:**
1. Enable auto-tagging in Google Ads account settings
2. Capture GCLID from URL parameter on landing page (GTM: URL variable → hidden form field)
3. Store GCLID in CRM alongside lead record
4. When lead converts (sale closed, contract signed), export: GCLID + conversion time + conversion value
5. Upload to Google Ads via UI, API, or scheduled BigQuery export

**GCLID upload window: 90 days from the click date.** Any conversion uploaded more than 90 days after the click will not be attributed.

### 7.2 Enhanced Conversions for Leads

Enhanced Conversions for Leads (ECL) is the alternative for situations where GCLID capture is unreliable or missing.

- User submits a form with their email address
- GTM sends a hashed (SHA-256) version of the email to Google
- When Google later identifies that user converted offline (via CRM upload with hashed email), it matches them
- Fills the gap when GCLID is missing (e.g., cross-device, direct URL navigation back to form)

> [!note] ECL vs GCLID Import
> These are complementary, not competing. Use GCLID import as the primary method (more reliable matching) and ECL as supplementary (captures cases where GCLID was lost). See `[[../enhanced-conversions]]` for GTM implementation.

### 7.3 Import Latency and Smart Bidding Impact

CRM data lags real-world events. A lead that converted offline on Day 5 might only be updated in the CRM on Day 30 when the deal is marked Closed Won.

| Import Lag | Impact on Smart Bidding |
|---|---|
| 0–7 days | Minimal impact; bidding model adjusts quickly |
| 7–30 days | Moderate lag; Smart Bidding may under-invest in campaigns that are performing well offline |
| 30+ days | Significant signal delay; bidding model has materially incomplete data; consider micro-conversion signals as a proxy |

**Mitigation for long-lag verticals:**
- Import micro-conversions earlier in the funnel (MQL stage, demo booked) as lower-value conversion actions to give the model faster signal
- Set conversion values to reflect stage value: MQL = €50, SQL = €200, Closed Won = €1,500
- Smart Bidding will optimise toward the value-weighted combination

> [!warning] Delayed Offline Imports Can Flip Smart Bidding Signals
> If you import a batch of 60-day-old conversions all at once, Smart Bidding interprets this as a sudden surge in conversions from that period — which has already passed. Import continuously (weekly or daily) rather than in large historical batches to keep the model's signal temporally accurate.

### 7.4 Offline Conversion with BigQuery Pipeline

If you have the sGTM → BigQuery pipeline running, you can automate offline conversion imports:

1. sGTM writes GCLID + user identifiers to `raw_events` table on form submission
2. CRM updates deal stage → webhook triggers a Cloud Function
3. Cloud Function joins GCLID from BigQuery with CRM deal data
4. Writes to `offline_conversions` table in BigQuery
5. Scheduled job uploads to Google Ads Offline Conversion Import API daily

For the full schema and pipeline, see `[[../../tracking-bridge/bq-to-gads]]`.

---

## Further Reading

- [About attribution models — Google Ads Help](https://support.google.com/google-ads/answer/6259715)
- [Set up conversion tracking for offline conversions — Google Help](https://support.google.com/google-ads/answer/2998031)
- [Enhanced conversions for leads — Google Help](https://support.google.com/google-ads/answer/11347292)
- [About data-driven attribution — Google Ads Help](https://support.google.com/google-ads/answer/6394265)
- [Google Ads and Google Analytics 4 conversion discrepancies — Google Help](https://support.google.com/analytics/answer/9443983)

---

Cross-reference: [[../conversion-actions]] | [[../../tracking-bridge/bq-to-gads]] | [[../../tracking-bridge/profit-based-bidding]] | [[../../tracking-bridge/value-based-bidding]] | [[account-profiles]]

%%
Related references:
- [[../enhanced-conversions]] — GTM implementation for enhanced conversions for leads
- [[../../tracking-bridge/bq-to-gads]] — full BigQuery to Google Ads pipeline
- [[../../tracking-bridge/profit-based-bidding]] — margin-adjusted conversion value implementation
- [[../../tracking-bridge/value-based-bidding]] — value-based bidding strategy
- [[account-profiles]] — per-client attribution configuration notes
%%
