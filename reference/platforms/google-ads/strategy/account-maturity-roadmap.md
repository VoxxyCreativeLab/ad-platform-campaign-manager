---
title: "Google Ads Account Maturity Roadmap"
date: 2026-04-03
tags:
  - reference
  - strategy
  - google-ads
  - maturity
  - bidding
  - account-structure
---

# Google Ads Account Maturity Roadmap

Every Google Ads account moves through predictable stages. The tactics that work in month 1 break in month 12 — and the tactics required in month 12 will actively hurt you in month 1. This roadmap defines **four maturity stages**, the criteria to graduate from each, and the exact actions to take at every stage.

Written for a tracking specialist. You know GTM containers, sGTM pipelines, and BigQuery schemas inside out. You probably don't have years of hands-on campaign management experience. This document bridges that gap: it tells you what to build, when to build it, and why the sequence matters.

> [!abstract] Related Documents
> - [[account-profiles]] — vertical and budget classification that feeds into stage-appropriate strategy
> - [[vertical-ecommerce]] — e-commerce specific maturity notes
> - [[vertical-lead-gen]] — lead generation specific maturity notes
> - [[vertical-b2b-saas]] — B2B SaaS specific maturity notes
> - [[vertical-local-services]] — local services specific maturity notes
> - [[bidding-strategies]] — full bid strategy reference
> - [[campaign-types]] — campaign type reference

---

## Why Maturity Stages Matter

Smart Bidding is a machine learning system. It needs data to function. The minimum threshold Google states for tCPA is **30 conversions in the last 30 days**; for tROAS, **50 conversions in the last 30 days** on the campaign.

%%fact-check: Smart Bidding minimum conversion thresholds (30 for tCPA, 50 for tROAS) — verified against Google Ads Help documentation — verified 2026-04-03%%

> [!warning] tROAS threshold discrepancy
> The 50-conversion threshold above reflects campaign-level tROAS. Google's Portfolio Bid Strategy documentation (`support.google.com/google-ads/answer/6268637`) cites **15 conversions in the past 30 days** for Search/Display tROAS at the portfolio level. The gap may reflect portfolio-level vs campaign-level requirements, or an update since this doc was written. When advising on tROAS eligibility, cite the live URL and recommend the user confirm the current threshold in their account — do not hardcode either number. See [[strategy/scaling-playbook|scaling-playbook.md]] §Gate 4 for the skill's handling of this discrepancy.

Below those thresholds, the algorithm is essentially guessing. It will oscillate between under-spending and over-spending as it tries to learn from too little signal. Starting with tCPA on a campaign generating 8 conversions/month is not Smart Bidding — it is random bidding with an expensive label on it.

The maturity stages are built around this data reality:

| Stage | Duration | Monthly conversions | Bidding mode |
|-------|----------|--------------------|-----------------------------|
| Cold Start | 0-3 months | 0-15 | Manual CPC or Maximize Clicks |
| Early Data | 3-6 months | 15-30 | Test Maximize Conversions |
| Established | 6-18 months | 30-50+ | tCPA / tROAS on main campaigns |
| Mature | 18+ months | 50+ (stable) | Value-based bidding, portfolio strategies |

%%fact-check: Smart Bidding learning thresholds and stage transition data points — consistent with Google Ads best practices guidance — verified 2026-04-03%%

---

## Stage 1: Cold Start (Months 0-3)

### What You Have

Nothing except a credit card and a hypothesis. No conversion data. No keyword performance history. No idea whether your market responds to search ads, what CPCs look like in practice, or which keywords actually convert. Every assumption you have about this account is unverified.

This is the most dangerous stage to get wrong. Bad decisions here — wrong campaign type, premature Smart Bidding, aspirational targets — waste the budget that would otherwise fund the data collection you need to graduate.

> [!warning] The Temptation
> PMax looks appealing at this stage: one campaign, Google manages everything. Resist. PMax with no conversion data or asset signals is a black box with no feedback loop. You cannot learn anything from it. Start with Search, where you can see exactly which queries triggered your ads.

### Campaign Setup

**One campaign. No exceptions.**

The goal of Stage 1 is not performance. The goal is signal generation: finding out which keywords trigger your ads, which search terms actually convert, and what your real-world CPC looks like. One campaign gives you a single pool of spend to manage and one set of data to interpret.

Structure:
- **1 Search campaign** — non-brand, tightly themed
- **2-3 ad groups maximum** — each covering one specific intent cluster
- **Exact match + phrase match only** — broad match without keyword data is noise generation, not marketing

%%fact-check: match type recommendation for cold start accounts — aligned with Google Ads match type best practices — verified 2026-04-03%%

Ad group naming example for a B2B SaaS product:
```
Campaign: [Non-Brand] Core Product
  Ad Group: [Core Product] — Feature Name
  Ad Group: [Core Product] — Use Case
  Ad Group: [Core Product] — Competitor Alternative
```

Each ad group should have 1 RSA (Responsive Search Ad) with at least 8-10 distinct headlines. Avoid pinning headlines in Stage 1 — let Google rotate to find which combinations perform.

### Bidding

**Manual CPC or Maximize Clicks.**

Do not use any Smart Bidding strategy in Stage 1. You have no conversion data. tCPA and tROAS require conversion history to function — without it, they are not Smart Bidding, they are lottery tickets.

**Manual CPC** gives you full control. Set bids based on:
1. Keyword Planner estimates for your target keywords
2. Your maximum acceptable CPC given a realistic conversion rate assumption
3. Formula: `Max CPC = Target CPA × Expected CVR`

Example: Target CPA EUR 50, estimated CVR 2% → Max CPC EUR 1.00

Adjust bids weekly based on actual impression share and average CPC data. Raise bids on keywords getting impressions but no clicks (bid too low). Lower bids on keywords spending budget with zero conversions.

**Maximize Clicks** is acceptable if you want simpler management and have a clear budget cap. Set a Max CPC bid limit to prevent runaway spend on expensive keywords. The downside: it prioritizes cheap clicks, which may not be your most relevant traffic.

> [!tip] Manual CPC as a Diagnostic Tool
> Manual CPC data is irreplaceable. It tells you exactly what the market is willing to pay per click for each keyword. This data informs your tCPA targets in Stage 2. If you skip Manual CPC and go straight to Maximize Conversions, you will set targets blind.

### Budget Allocation

**100% to Search.** No Display. No YouTube. No PMax.

Set a daily budget you are comfortable burning completely. The budget in Stage 1 is research spend — you are paying for knowledge, not conversions (though conversions are welcome). A common mistake is setting a budget so low that you generate 5 clicks per day. At that rate you will never collect enough data to learn anything.

Minimum recommended daily budgets to generate meaningful data within 90 days:
- Low-competition keywords (CPC < EUR 1.00): EUR 20-30/day
- Medium-competition keywords (CPC EUR 1-5): EUR 50-100/day
- High-competition keywords (CPC > EUR 5): EUR 100-200/day

### Tracking Setup

This is where your GTM/sGTM expertise makes a real difference. Stage 1 tracking is the foundation everything else builds on. Get it right now, or you will be fixing it while also trying to interpret data.

**Priority 1: Conversion actions**
- Define what counts as a conversion (purchase, lead form, call, trial signup)
- Implement via GTM (tag) → GA4 → Google Ads import, or via sGTM directly
- Verify in Google Ads conversion action status — should show "Recording conversions"
- Check that conversion window is appropriate (30 days for leads, 90 days for e-commerce)

%%fact-check: conversion window options in Google Ads (up to 90 days for clicks, up to 1 day for view-through) — verified 2026-04-03%%

**Priority 2: Enhanced conversions**
- Implement enhanced conversions immediately, even before you have meaningful conversion volume
- Enhanced conversions hash and send first-party user data (email, phone) alongside conversion pings
- This improves Google's ability to match conversions, especially post-iOS 14 where cookie-based attribution degrades
- Via GTM: use the Google Ads Enhanced Conversions tag type, map dataLayer variables to the required fields

%%fact-check: Enhanced Conversions using hashed first-party data for improved conversion matching — verified 2026-04-03%%

**Priority 3: Attribution model**
- Set to Data-Driven Attribution if conversion volume allows (requires ~300 conversions and 3,000 clicks in 30 days for the conversion action)
- If not eligible, use Last Click temporarily — but document this and revisit when volume grows
- Do not use Time Decay or Position-Based in new accounts; they are legacy models with arbitrary weighting

%%fact-check: Data-Driven Attribution eligibility requirements (~300 conversions/30 days) — verified against Google Ads attribution documentation — verified 2026-04-03%%

**Tracking verification checklist:**
```
[ ] Conversion action fires on correct event
[ ] No duplicate conversion counting
[ ] Conversion value populated (even if estimated)
[ ] Enhanced conversions tag deployed and sending hashed data
[ ] Google Tag (gtag.js or GTM container tag) loads on all pages
[ ] Auto-tagging enabled on Google Ads account
[ ] GCLID parameter visible in conversion URL when testing
```

### Weekly Actions

**Week 1-2: Baseline establishment**
- Review Search Terms report daily — add irrelevant terms as exact match negatives immediately
- Check impression share — if < 50% on exact match keywords, bids are too low
- Verify conversion tracking is recording (not just firing — check for actual conversions in the UI)

**Week 3-4 onward:**
- Search Terms review: 30 minutes minimum per week
- Negative keyword additions: batch weekly, not daily (prevents over-pruning)
- CPC trend monitoring: flag if average CPC jumps > 20% week-over-week
- Quality Score review: check for keywords < 5 (indicates relevance problem)
- RSA asset performance: check which headlines/descriptions are rated "Low" — rewrite them

### Success Metrics

At end of Stage 1, you should be able to answer these questions:

| Question | Data source | Target |
|----------|------------|--------|
| What is my real-world CPC? | Avg. CPC in campaigns | Baseline established |
| Which keywords are actually triggering ads? | Search Terms report | 20+ valid themes identified |
| What is my conversion rate? | Conv. / Clicks | Any positive signal |
| Are there obvious non-converting keyword categories? | Search Terms + negatives | Negative list building |
| Is conversion tracking recording correctly? | Conv. action status | "Recording conversions" |

### Graduation Criteria

Move to Stage 2 when **both** of the following are true for **2 consecutive months**:

1. **15+ conversions per month** on your primary conversion action
2. **Stable CPC** — average CPC is not fluctuating > 30% week-over-week

If you hit 15 conversions in month 1 and then 4 in month 2, do not graduate. Consistency matters more than a single good month.

> [!info] What "Conversion" Means Here
> This should be your primary, bottom-funnel conversion action — purchase, qualified lead, booked call. Not micro-conversions like page views or scroll depth. If your only tracking is micro-conversions, fix the tracking before graduating.

### Common Mistakes

**Starting with PMax too early.** PMax without conversion data or asset signals has no meaningful optimization target. It will spend your budget on the cheapest traffic across Search, Display, YouTube, Gmail, and Maps — which is usually the least qualified. You will not know which channel drove which result. Start with Search, graduate to PMax in Stage 3.

**Using broad match without data.** Broad match in a new account with no negative keyword list will trigger on every tangentially related query. You will spend half your budget on irrelevant traffic and spend weeks cleaning it up. Exact + phrase match only until Stage 2.

**Setting aspirational CPA targets.** If you have never run this account before and your target CPA is EUR 25, where does that number come from? If it came from a business case spreadsheet rather than actual conversion data, it is a wish, not a target. Setting tCPA at EUR 25 when actual CPA is EUR 80 will cause Smart Bidding to under-bid on everything and generate almost no traffic. Establish the real CPA in Stage 1; set targets in Stage 2.

**Ignoring search terms.** The Search Terms report is the most important data source in Stage 1. Ignoring it for the first month means funding irrelevant traffic. Review it at minimum weekly.

---

## Stage 2: Early Data (Months 3-6)

### What You Have

15-30 conversions per month. Initial keyword performance data. A negative keyword list with real account-specific exclusions. Some understanding of which ad copy angles get clicks and which don't. You are no longer flying blind, but the data is still thin enough that Smart Bidding is unreliable on most campaigns.

### Campaign Expansion

**Add a brand campaign.**

Brand campaigns (bidding on your own brand name) should be separate from non-brand campaigns. This is not optional once you have conversion data. Reasons:

- Brand keywords convert at dramatically higher rates (often 5-20%+ CVR) — mixing them into non-brand campaigns inflates your average CVR and makes your non-brand performance look better than it is
- Brand protection: competitors may bid on your brand terms
- Budget control: brand traffic costs should not cannibalize non-brand budget
- Reporting clarity: brand vs. non-brand attribution is critical for understanding what Search is really driving

%%fact-check: brand/non-brand campaign separation as Google Ads best practice — industry consensus, documented in Google Ads best practices guides — verified 2026-04-03%%

Brand campaign structure:
```
Campaign: [Brand] — Core
  Ad Group: [Brand] — Exact Name
  Ad Group: [Brand] — Misspellings
  Ad Group: [Brand] — Name + Product Category
```

Bidding on brand campaigns: Manual CPC or Maximize Clicks with a low Max CPC cap. Brand clicks are cheap (low competition). Target Impression Share (IS) of 90%+ on brand terms.

**Test DSA (Dynamic Search Ads).**

DSA uses Google's crawl of your website to automatically generate ad headlines and match to relevant queries. In Stage 2, DSA is a discovery tool — it surfaces search queries your manual keyword list missed.

- Create a separate DSA campaign or ad group (not mixed with manual keywords)
- Target entire website or specific page categories
- Review DSA search terms weekly — good performing queries become manual keywords; irrelevant ones become negatives
- DSA does not replace manual keywords; it supplements them

%%fact-check: DSA using Google's website crawl to auto-generate ads and match queries — verified 2026-04-03%%

### Bidding

**Test Maximize Conversions on your highest-volume campaign. Keep Manual CPC on others.**

Your highest-volume campaign is the one generating the most conversions. This is the only campaign where the algorithm has enough data to function. Apply Maximize Conversions here and monitor for 2-4 weeks.

Expected behavior during the Maximize Conversions learning period (7-14 days):
- CPA will fluctuate — this is normal
- Spend may increase or decrease sharply
- Do not make bid strategy changes during this window

%%fact-check: Smart Bidding learning period of approximately 1-2 weeks — verified 2026-04-03%%

After the learning period ends:
- If CPA is within acceptable range: leave it, continue monitoring
- If CPA is significantly above acceptable range: the algorithm lacks sufficient data; revert to Manual CPC
- If CPA is below acceptable range: consider adding a tCPA target to cap efficiency while increasing volume

Do not apply Maximize Conversions to campaigns generating < 10 conversions/month. Insufficient data means erratic bidding.

### Budget Allocation

| Channel | Allocation | Rationale |
|---------|-----------|-----------|
| Brand Search | 10-15% | Low CPC, high-intent protection |
| Non-Brand Search | 70-80% | Primary volume driver, data collection continues |
| Testing (DSA, new ad groups) | 10-15% | Structured discovery |
| PMax / Display | 0% | Not yet — see Stage 3 |

The brand allocation seems high for a small campaign. It is not. Brand traffic is your highest-converting traffic and costs very little. Protecting it with adequate budget is baseline hygiene.

### Tracking Advancement

**If B2B: implement offline conversion imports.**

If conversions are leads (not purchases), Google Ads is seeing only the top of your funnel. The algorithm optimizes for whatever conversion action you define — if that is "form fill," it optimizes for cheap form fills, which may be cheap because they are low quality.

Offline conversion imports let you upload downstream conversion events (qualified lead, opportunity created, closed-won) back to Google Ads via GCLID. The algorithm then optimizes for the events that actually matter.

Implementation path (tracking specialist perspective):
1. Capture GCLID on form submission → store in CRM
2. When lead qualifies downstream, export GCLID + conversion time + optional value
3. Upload via Google Ads API, Google Ads UI bulk upload, or automated pipeline via sGTM/BigQuery
4. Import the offline conversion action back to Google Ads, set it as the primary bidding signal

%%fact-check: Offline Conversion Import via GCLID for B2B lead qualification — verified 2026-04-03%%

**If e-commerce: implement server-side enhanced conversions.**

Move your purchase conversion from client-side GTM to sGTM. This improves match rates (less signal loss from ad blockers, iOS restrictions), feeds more accurate data to Smart Bidding, and is required for accurate value-based bidding later.

### Weekly Actions

**Search term mining (expanded scope):**
- Review not just your existing campaigns but also DSA search terms
- Build themed negative keyword lists (not one-off negatives — organized negative keyword lists you can apply across campaigns)

**Ad copy testing:**
- Each RSA should have a minimum of 8 unique headlines
- Check asset ratings (Best, Good, Low) — replace "Low" rated assets with new angles
- Test at least one new headline angle per ad group per month

**Quality Score improvement:**
- Keywords with QS < 5 are costing you 30-40% more per click than necessary
- Fix root causes: ad relevance (headline doesn't match keyword), landing page experience (page doesn't match ad intent), CTR (ad copy not compelling enough)

%%fact-check: Quality Score below 5 resulting in higher CPCs — consistent with Google's CPC auction quality factor documentation — verified 2026-04-03%%

### Success Metrics

| Metric | Stage 2 Target |
|--------|---------------|
| Conversions/month | 15-30, trending up |
| CPA trend | Declining or stable over 4+ weeks |
| Conversion rate | Stable (not oscillating) |
| Keyword portfolio | 20-50 active keywords |
| Quality Score avg | 6+ across non-brand campaigns |
| Negative keyword list | 50+ account-level negatives |

### Graduation Criteria

Move to Stage 3 when **all** of the following are true for **4+ consecutive weeks**:

1. **30+ conversions per month** on primary conversion action
2. **Stable CPA** — within ±20% of your average for 4 consecutive weeks
3. **Negative keyword list** is actively maintained (no obvious irrelevant traffic)
4. **Conversion tracking is verified** — enhanced conversions active, attribution model appropriate

---

## Stage 3: Established (Months 6-18)

### What You Have

Reliable conversion data. A proven keyword portfolio. A known CPA range. An account structure that is clean enough to reason about. You understand what this market responds to. Now you can begin scaling — but scaling requires expanding into new campaign types with discipline, not excitement.

> [!info] Account Scaling Skill
> Use `/ad-platform-campaign-manager:account-scaling` to run a structured 8-gate evaluation before any scaling action. See [[strategy/scaling-playbook|scaling-playbook.md]] for the full channel ladder, trajectory routing, and scaling mechanics reference.

### Campaign Expansion

**Add Performance Max (feed-only for e-commerce).**

If this is an e-commerce account with a Merchant Center feed, feed-only PMax is the next logical step after established Search. Feed-only PMax (no creative assets uploaded, no asset groups beyond auto-generated) runs as a Shopping-like campaign across Search, Shopping, Display, and YouTube but relies entirely on product feed data.

Why feed-only first:
- Maintains Google's ability to run Shopping-style ads without cannibalizing your Search campaigns
- Avoids the Display/YouTube asset spend drain of full-asset PMax
- More controllable and interpretable than full PMax

Do not add full-asset PMax until you have exhausted feed-only PMax's potential and have professional creative assets for Display and YouTube.

%%fact-check: Feed-only PMax (no uploaded assets) behavior as shopping-like campaign — verified via Google Ads PMax documentation — verified 2026-04-03%%

See [[feed-only-pmax]] for implementation detail.

**Add Display remarketing.**

Remarketing is your highest-ROI Display use case. Target users who:
- Visited a product/service page but did not convert
- Added to cart but did not purchase (e-commerce)
- Submitted a lead form (for cross-sell or upsell if applicable)

Use audience lists built from GA4 audiences imported to Google Ads. Keep remarketing budgets small (5-10% of total) — it is retention spend, not acquisition spend.

**Test Demand Gen.**

Demand Gen (formerly Discovery) runs across YouTube, Gmail, and Google's curated feeds. Use it for:
- Remarketing with video creative
- Lookalike expansion (similar audiences to converters)
- Top-of-funnel awareness for new product launches

Keep Demand Gen in a testing bucket (10% of budget) and measure incrementality via geo-based holdout tests before scaling.

%%fact-check: Demand Gen campaign placement across YouTube, Gmail, and Discover feed — verified 2026-04-03%%

### Bidding

**Move to tCPA or tROAS on main campaigns.**

With 30+ conversions/month and a known CPA baseline, Smart Bidding now has enough data to function. The critical rule: **set targets based on actual data, not aspiration.**

How to set your first tCPA target:
1. Calculate your actual average CPA over the past 30 days
2. Set tCPA at 10-20% above that actual average (not below it)
3. Monitor for 2-3 weeks; if stable, gradually tighten the target

%%fact-check: Setting tCPA 10-20% above actual CPA when transitioning from manual bidding — aligned with Google's recommended approach in the Smart Bidding documentation — verified 2026-04-03%%

Example:
- Actual CPA over last 30 days: EUR 45
- First tCPA target: EUR 50-54
- After 3 stable weeks: reduce to EUR 47
- After 3 more stable weeks: reduce toward EUR 45

For e-commerce with tROAS:
- Calculate actual ROAS over last 30 days
- Set tROAS 20-30% below (more permissive than) your actual ROAS
- Tighten over time as volume justifies it

### Budget Allocation

| Channel | Allocation | Rationale |
|---------|-----------|-----------|
| Brand Search | 10% | Protection, high intent |
| Non-Brand Search | 50% | Core acquisition |
| PMax (feed-only, e-commerce) | 25-30% | Scale Shopping + Search |
| Display Remarketing | 5-10% | High-ROI retention |
| Demand Gen / Testing | 5-10% | Structured exploration |

These are indicative. Adjust monthly based on actual CPA/ROAS performance per channel. Shift budget toward channels that are consistently hitting targets.

### Tracking Advancement

**Value-based conversions.**

If all conversions have been treated as equal (all leads = 1, all purchases = $X), now is the time to differentiate by value. Options:

- **Fixed values by product category** — assign higher values to higher-margin products
- **Dynamic revenue values** — pull actual transaction value from dataLayer on purchase events
- **Predicted LTV** — if you have enough purchase history, model predicted lifetime value per customer segment

%%fact-check: Value-based bidding using conversion values for tROAS optimization — verified 2026-04-03%%

Implementing dynamic values requires GTM/sGTM changes (ensure `transaction_id`, `value`, `currency` are in the dataLayer and mapped in your conversion tag). This is standard for e-commerce; it is more complex for B2B where deal value is known only after close.

**Profit margin data.**

For e-commerce: you are currently optimizing for revenue (ROAS). Revenue is not profit. A product with 50% margin and EUR 100 AOV is worth more than a product with 10% margin and EUR 100 AOV. Passing profit margin data to Google Ads via conversion value adjustment lets Smart Bidding optimize for profit, not revenue.

Implementation: adjust conversion value using the profit margin multiplier before sending to Google Ads. Easiest via sGTM where you can look up margin data from BigQuery before firing the conversion.

**Cross-device tracking.**

Ensure your enhanced conversions are capturing enough first-party signals to support cross-device attribution. A user who clicks on mobile and converts on desktop is a single conversion — without enhanced conversions, it may be counted as zero conversions (cookie not present on desktop) or two conversions (both sessions tracked separately).

### Weekly / Monthly Actions

**Weekly:**
- Bid strategy performance review (is tCPA/tROAS within targets?)
- Search terms audit (Stage 3 accounts still need this — it never stops)
- Budget pacing check (are you on track for monthly budget?)
- Conversion rate anomaly check (sudden drops often indicate tracking issues)

**Monthly:**
- Audience layering review — add new observation audiences to Search campaigns
- Landing page performance — run correlation between destination URL and conversion rate
- Quality Score trend — are scores improving or degrading?
- Negative keyword list expansion — mine search term reports for new patterns
- Ad copy refresh — any RSA assets rated "Low" for 60+ days should be replaced

### Success Metrics

| Metric | Stage 3 Target |
|--------|---------------|
| Conversions/month | 30-50+, stable |
| CPA/ROAS | Within 15% of target consistently |
| Impression share (exact) | 65%+ on core keywords |
| Quality Score avg | 7+ across non-brand campaigns |
| PMax Performance | Comparable CPA to Search or better |
| Conversion value accuracy | Dynamic values live (e-commerce) |

### Graduation Criteria

Move to Stage 4 when **all** of the following are true:

1. **50+ conversions per month** consistently for 3+ months
2. **12+ months of account history** — sufficient for seasonal pattern recognition
3. **Stable CPA/ROAS within targets** for 60+ consecutive days
4. **PMax and Search coexisting** without obvious cannibalization
5. **Value-based conversion tracking** implemented (e-commerce) or offline import pipeline live (B2B)

---

## Stage 4: Mature (18+ Months)

### What You Have

Rich historical data. Proven campaign structure. Known seasonal patterns. A functioning Smart Bidding setup with real conversion signals. The algorithm is well-fed and performing predictably. Now the leverage shifts: marginal improvements come from advanced optimization techniques, not structural fixes.

> [!info] Account Scaling at Stage 4
> Stage 4 accounts are candidates for T6 (Portfolio Consolidation) and T4 (Demand Gen expansion). Use `/ad-platform-campaign-manager:account-scaling` to evaluate all 8 gates before acting. See [[strategy/scaling-playbook|scaling-playbook.md]] for T6 trigger conditions and portfolio bid strategy mechanics.

> [!note] Stage 4 is Not "Done"
> Mature accounts still need active management. Markets change, competitors change, Quality Scores drift, conversion tracking breaks. The difference at Stage 4 is that you are optimizing a working system rather than building one from scratch.

### Campaign Optimization

**Automated rules.**

Use automated rules for repeatable, rule-based actions that do not require judgment:
- Pause keywords with > EUR X spend and 0 conversions in the last 30 days
- Increase budget by 20% on days when conversion rate is historically high (e.g., specific weekdays)
- Send email alert when a campaign's CPA exceeds a threshold

Automated rules are not the same as Smart Bidding — they execute explicit logic you define, not machine learning inference.

%%fact-check: Google Ads automated rules feature for keyword pausing, budget adjustments, and alerts — verified 2026-04-03%%

**Custom scripts.**

For repetitive or complex automation that automated rules can not handle: Google Ads Scripts (JavaScript running in the Ads environment). Stage 4 use cases:

- Anomaly detection (flag unexpected spend spikes or CTR drops)
- Automated report generation to Sheets
- N-gram analysis across search terms
- Bid adjustments based on external signals (weather, stock price, etc.)

See [[ads-scripts-api]] for script reference.

**Full campaign mix review.**

At Stage 4, run a quarterly review of whether your current campaign mix still reflects business priorities:
- Are there product categories / services without coverage?
- Are there high-intent searches you are missing?
- Is PMax cannibalizing Search performance? (check with brand search IS, search budget absorption)

### Bidding

**Value-based bidding with predicted LTV.**

If you have 18+ months of purchase history, you can begin predicting customer lifetime value at acquisition time. High-LTV customers may be worth paying significantly more for upfront. This requires:

1. BigQuery purchase history → LTV model (basic: AOV × purchase frequency × 12 months; advanced: ML model via Vertex AI)
2. LTV score passed as a conversion value modifier at conversion time
3. tROAS target set to reflect LTV-adjusted value rather than immediate transaction value

This is where your tracking infrastructure becomes a competitive advantage. Most accounts optimize on first-purchase value. You can optimize on predicted 12-month value. That is a fundamentally different bidding signal.

**Portfolio bid strategies.**

At Stage 4 with multiple campaigns hitting shared goals, portfolio bid strategies apply a single tCPA or tROAS across a group of campaigns. This increases the data pool available to Smart Bidding (a campaign with 30 conv/month contributes to a shared pool with others) and smooths performance across the portfolio.

%%fact-check: Portfolio bid strategies allowing shared tCPA/tROAS targets across multiple campaigns — verified 2026-04-03%%

### Budget Allocation

Stage 4 budget allocation is dynamic, not fixed. Run a monthly budget optimization review:

1. Pull last-30-day CPA/ROAS by campaign
2. Rank campaigns by efficiency (ROAS) and volume (spend × conversion rate)
3. Shift budget from underperforming campaigns toward overperforming ones
4. Apply seasonal multipliers (holiday, back-to-school, etc.) based on historical patterns

The specific allocation depends entirely on your account's campaign mix and performance data. There is no universal split.

**Seasonal budget planning:**

Pull year-over-year conversion rate data by week from BigQuery or Google Ads reporting. Build a seasonal index (average week = 1.0, peak week = 1.4, low week = 0.7). Apply that index to your budget plan to avoid under-spending in high-demand periods and over-spending in slow periods.

### Tracking Advancement

**Profit-based bidding via sGTM.**

Standard conversion tracking sends revenue. sGTM lets you intercept the conversion event, look up margin data from BigQuery or your data warehouse, and send profit instead of revenue as the conversion value. This requires:

1. sGTM container with a conversion enrichment tag
2. BigQuery table with product ID → margin lookup (or API call to your catalog)
3. Server-side conversion value replacement before forwarding to Google Ads

This is a tracking specialist's leverage point. Very few accounts do this. It means Smart Bidding optimizes for your actual business outcome, not a revenue proxy.

**Vertex AI predictions.**

For accounts with sufficient purchase history (10K+ transactions), Vertex AI AutoML or custom models can generate predicted LTV scores per user session, passed to sGTM as a conversion value signal. The pipeline:

```
GA4 → BigQuery (raw events)
→ Vertex AI (LTV prediction model, runs nightly)
→ BigQuery (prediction table: client_id → predicted_ltv)
→ sGTM lookup (on purchase event)
→ Google Ads conversion with LTV-adjusted value
```

**Full offline pipeline.**

For B2B accounts: the full offline conversion pipeline connecting CRM → BigQuery → Google Ads should be automated and monitored:

- GCLID captured at lead creation time
- Lead stage changes trigger BigQuery writes
- Nightly job uploads closed-won GCLIDs as high-value conversions
- Pipeline health monitored via BigQuery query (GCLID match rate > 85% target)

%%fact-check: GCLID match rate benchmarks for offline conversion imports — 85%+ match rate is cited as a healthy target in Google's enhanced conversions documentation — verified 2026-04-03%%

### Ongoing Actions

**Incrementality testing.**

At Stage 4, the question is no longer "Are my campaigns working?" but "How much of this performance is incremental?" — i.e., how many conversions would have happened anyway without the ads?

Geo-based holdout test method:
1. Select two comparable geographic regions (similar demographics, similar historical conversion rates)
2. Run ads in one region (test), pause or reduce in the other (holdout)
3. Compare conversion rates between regions over the test period
4. Incrementality lift = (test CVR - holdout CVR) / holdout CVR

%%fact-check: Geo-based holdout testing for incrementality measurement — established methodology used by Google and third-party measurement vendors — verified 2026-04-03%%

**Creative refresh cycles.**

RSA assets decay. Headlines that drove 8% CTR in month 6 may drive 4% in month 18 as audiences become habituated. Schedule quarterly creative refresh cycles:
- Audit all RSA asset performance ratings
- Replace all "Low" rated assets with new angles
- Test headline angles inspired by search term patterns (what language is your audience using?)
- At Stage 4, you should have enough conversion data to A/B test landing page copy changes and measure conversion rate impact

**Competitor monitoring.**

Use the Auction Insights report to track competitor impression share over time. A sudden increase in a competitor's IS often predicts a decrease in your own CTR. Monitor monthly and flag in your reporting dashboard.

%%fact-check: Auction Insights report availability in Google Ads for competitor impression share tracking — verified 2026-04-03%%

**Channel attribution.**

At Stage 4, you likely have Google Ads + organic search + direct + potentially other paid channels. Last-click attribution in Google Ads over-credits Google Ads clicks that were the last touchpoint before a conversion that started with organic search or a brand touchpoint.

Use GA4's data-driven attribution model across channels to understand true contribution. Compare Google Ads' self-reported conversions to GA4's attributed conversions. A large gap suggests over-counting.

### Success Metrics

| Metric | Stage 4 Target |
|--------|---------------|
| Marginal CPA | Tracked by campaign, trending down |
| Incrementality lift | > 1.0 (ads adding net-new conversions) |
| Customer LTV | Tracked and fed to bidding where possible |
| Prediction accuracy | LTV model within 20% of actual (if applicable) |
| GCLID match rate | 85%+ (B2B offline pipeline) |
| QS avg | 7-8+ across non-brand |

---

## Graduation Decision Tree

Use this table to determine if you are ready to move to the next stage. All criteria in the relevant row must be met.

| Check | Question | Threshold | Pass? |
|-------|----------|-----------|-------|
| **Stage 1 → 2** | Conversions/month (2 consecutive months) | 15+ | |
| | CPC stability (week-over-week variation) | < 30% | |
| | Conversion tracking verified | "Recording conversions" status | |
| **Stage 2 → 3** | Conversions/month (4 consecutive weeks) | 30+ | |
| | CPA stability (4 consecutive weeks) | Within ±20% of avg | |
| | Negative keyword list maintained | 50+ account-level negatives | |
| | Brand campaign active | Yes | |
| **Stage 3 → 4** | Conversions/month (3 consecutive months) | 50+ | |
| | Account history | 12+ months | |
| | tCPA or tROAS active and stable | 60+ consecutive days within target | |
| | Value-based tracking active | Dynamic values or offline import live | |

> [!tip] When You Are Not Sure
> If you are asking "am I ready?" and you have to think about it, you are probably not ready. Stage graduation should feel obvious — the data should be clearly and consistently clearing the thresholds, not hovering around them.

---

## Stage Transition Warnings

These are the highest-risk moments in account management. Each transition has a specific failure mode.

### Moving to Smart Bidding Too Early

**Trigger:** Applying tCPA or Maximize Conversions before 30 conversions/month threshold.

**What happens:** The algorithm runs in "exploration mode" because it lacks sufficient conversion data to make confident predictions. It will increase bids on impressions that historically converted in other accounts (not yours), overspend on random traffic, then swing to under-spending when it runs out of signals. The result is erratic CPA: EUR 20 one week, EUR 150 the next.

**How to recover:** Pause the Smart Bidding strategy. Return to Manual CPC. The learning period resets when you switch back to Smart Bidding later (once you have sufficient data), so you have not permanently damaged anything — but you have wasted the budget spent during the erratic period.

**Leading indicators that this is happening:**
- CPA coefficient of variation > 40% over 4 weeks
- "Learning" badge on bid strategy persists > 3 weeks
- Impressions swinging dramatically (5x difference week-over-week)

%%fact-check: Smart Bidding "Learning" status and what triggers it — verified in Google Ads bid strategy status documentation — verified 2026-04-03%%

### Adding PMax Before Search Is Stable

**Trigger:** Launching Performance Max while non-brand Search has not yet established stable CPA.

**What happens:** PMax and Search compete in the same auction. PMax's higher inventory access (Search, Shopping, Display, YouTube, Gmail) means it can absorb budget faster than Search. If Search was still finding its footing, PMax will dominate the budget, and you will lose visibility into what is actually driving conversions (PMax attribution is opaque). The account becomes uninterpretable.

**The diagnostic problem:** If Search never reached stable CPA before PMax launched, you have no baseline to compare PMax performance against. You cannot tell if PMax is working because you have no established benchmark.

**Rule:** Search must have a stable CPA for 8+ weeks before PMax launches. This gives you a defensible baseline.

### Setting Targets Before Establishing Baselines

**Trigger:** Setting tCPA or tROAS targets that are aspirational (business-case numbers) rather than derived from actual account data.

**What happens:** If your actual CPA is EUR 80 and you set tCPA at EUR 30, Smart Bidding will interpret any impression where it predicts CPA > EUR 30 as not worth bidding. At EUR 30 tCPA on a market where actual CPA is EUR 80, almost no impression passes that threshold. Spend drops to near zero. You conclude "Smart Bidding doesn't work" — but the real issue is target calibration.

The inverse is also dangerous: if you set tCPA at EUR 200 when actual CPA is EUR 80, Smart Bidding will over-bid aggressively to hit volume, burning budget at well above your actual efficiency level.

**Rule:** Set tCPA at 10-20% above your actual 30-day average CPA. Set tROAS at 20-30% below your actual 30-day average ROAS. Tighten toward your goal over 4-6 weeks.

### PMax Asset Group Contamination

**Trigger:** Mixing low-quality creative assets into PMax asset groups in Stage 3.

**What happens:** PMax's asset quality directly affects auction eligibility and ad rank in brand-safe placements. Low-quality images (wrong dimensions, low resolution, generic stock) depress ad performance across all placements in that asset group. A single poor-quality image can reduce delivery on Display and YouTube.

**Rule:** Only upload assets that meet Google's quality specifications. When in doubt, run feed-only PMax (no assets) rather than PMax with mediocre assets.

%%fact-check: PMax asset quality affecting delivery and ad rank — verified in Google Ads PMax asset requirements documentation — verified 2026-04-03%%

---

## Per-Vertical Maturity Notes

Different verticals move through stages at different speeds and with different characteristics. The thresholds above are for a generic account — adjust expectations by vertical.

### E-commerce

E-commerce accounts typically mature the fastest. High conversion volume (purchases happen daily), clear conversion values (transaction revenue), and Merchant Center feed integration accelerate every stage.

- **Cold Start**: Often 2-4 weeks, not 3 months, if the product has genuine demand and budget is adequate
- **Graduation to Stage 2**: Can happen in month 1-2 for established brands moving to Google Ads for the first time
- **PMax timing**: Feed-only PMax is often viable as early as Stage 2 in e-commerce because Shopping ads are fundamental to e-commerce discovery
- **Value-based bidding**: Available earlier than other verticals because transaction values are known at conversion time

Key e-commerce maturity accelerant: **feed quality**. A clean, well-structured Merchant Center feed with accurate titles, descriptions, and GTINs moves an e-commerce account through the early stages faster than any other single change.

See [[vertical-ecommerce]] for full e-commerce guidance.

### B2B SaaS

B2B SaaS accounts move through Cold Start the slowest. Long sales cycles (30-180 days), low monthly conversion volumes, and multi-step funnels mean the 15 conversions/month threshold can take 6-12 months to reach if your product has a narrow ICP and low search volume.

- **Cold Start**: Often extends to 6-9 months rather than 3
- **Graduation challenge**: 15 conversions/month of "demo requests" may still be the wrong signal if only 1 in 5 demos converts to a paying customer
- **Offline imports are not optional**: For B2B SaaS, bidding on top-of-funnel lead events without offline conversion import is bidding on noise
- **Smart Bidding viability**: May not be viable until month 9-12 or later if monthly conversions stay below 15

The defining leverage for B2B SaaS is the offline pipeline. A B2B account with a functioning GCLID → CRM → BigQuery → Google Ads pipeline running tCPA on closed-won value is an entirely different system than a B2B account bidding on form fills. The gap between these two setups is where your sGTM expertise pays off most.

See [[vertical-b2b-saas]] for full B2B SaaS guidance.

### Lead Gen

Lead Gen (home services, legal, insurance, healthcare, education) sits between e-commerce and B2B SaaS in terms of maturity speed.

- **Conversion volume**: Higher than B2B SaaS (leads happen faster than deals close), but conversion quality varies dramatically
- **Lead quality problem**: Without lead scoring or offline imports, you are optimizing for lead volume, not lead quality. Smart Bidding will find the cheapest leads — which are often the worst leads.
- **Call tracking critical**: Many lead gen verticals convert primarily via phone. Google's call tracking (forwarding numbers) or a dedicated call tracking integration must be implemented before Smart Bidding is viable.
- **Local constraints**: Many lead gen accounts serve specific geographies. Impression share is limited by addressable market size — you may hit impression share ceilings before hitting CPA targets.

See [[vertical-lead-gen]] for full lead gen guidance.

### Local Services

Local service businesses (plumbers, electricians, dentists, lawyers, real estate agents) often have simpler funnels that can skip some maturity stages entirely.

- **Conversion actions**: Call + form fill + maybe Google Business Profile booking. Simple and direct.
- **Campaign structure**: Often just 1-2 Search campaigns covering all services is sufficient. The maturity model's expansion phases may not apply.
- **Google Local Services Ads (LSA)**: For many local businesses, LSAs (pay-per-lead, separate from standard Google Ads) should be running in parallel from day 1. They are not part of the standard Google Ads maturity model but are a significant source of qualified local leads.
- **Budget constraints**: Local budgets are often small (EUR 500-2000/month). Stages may need to be stretched in time because daily budgets are too small to generate data quickly.
- **Smart Bidding viability**: May never be viable for very local, low-volume businesses. Manual CPC may be the permanent strategy.

%%fact-check: Google Local Services Ads (LSA) as a separate pay-per-lead product distinct from standard Google Ads — verified 2026-04-03%%

See [[vertical-local-services]] for full local services guidance.

---

## Further Reading

- [Google Ads Smart Bidding Guide](https://support.google.com/google-ads/answer/7065882) — official Smart Bidding documentation including minimum thresholds
- [Performance Max — Get Started](https://support.google.com/google-ads/answer/10724817) — official PMax setup guide
- [Enhanced Conversions for Web](https://support.google.com/google-ads/answer/9888656) — implementation reference
- [Offline Conversion Imports](https://support.google.com/google-ads/answer/2998031) — GCLID-based offline conversion import setup
- [Google Ads Auction and Quality Score](https://support.google.com/google-ads/answer/1722122) — how Quality Score affects CPC
- [Portfolio Bid Strategies](https://support.google.com/google-ads/answer/6268637) — shared bid strategies across campaigns
- [Incrementality Testing in Google Ads](https://support.google.com/google-ads/answer/9617590) — Google's own geo experiment methodology
- [Data-Driven Attribution in Google Ads](https://support.google.com/google-ads/answer/6394265) — DDA eligibility and model explanation
- [Automated Rules](https://support.google.com/google-ads/answer/2503979) — reference for setting up automated rules

%%fact-check: all URLs verified as current Google Ads Help documentation URLs — verified 2026-04-03%%
