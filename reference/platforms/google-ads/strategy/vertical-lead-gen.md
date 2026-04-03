---
title: "Vertical Playbook — Lead Generation"
date: 2026-04-03
tags:
  - reference
  - strategy
  - vertical
---

# Vertical Playbook — Lead Generation

%%
Audience: tracking specialists learning campaign strategy.
Covers Google Ads lead gen vertical — CPA-driven, quality/quantity tension, call tracking essential, offline conversions transformative.
%%

> [!abstract] What This Covers
> Search-heavy campaign structure, lead quality vs. quantity tension, call tracking, offline conversion imports, and sub-vertical benchmarks. Cross-references: [[vertical-ecommerce]], [[vertical-b2b-saas]], [[vertical-local-services]], [[account-profiles]].

---

## 1. Overview

Lead generation accounts optimise for an outcome they do not fully control — the conversion (form fill, call, chat) is an intent signal, not a sale. A client receives a lead and qualifies it offline. This gap between the Google Ads conversion event and the actual business outcome is the defining challenge of the vertical.

**What defines this vertical:**
- CPA is the primary metric, not ROAS (unless lead values are assigned)
- Lead quality is often more important than lead volume
- Phone calls are frequently the highest-converting channel and the hardest to track
- Sub-verticals vary enormously in value: a legal lead is worth 10x a home services lead
- Conversion windows are short — most leads convert (or do not) within 7-30 days

**Key business metrics:**

| Metric | Definition | Why It Matters |
|--------|------------|----------------|
| **CPL** | Cost per lead (any lead) | Top-line efficiency, but hides quality problems |
| **CPQL** | Cost per qualified lead | What actually matters — requires offline signal |
| **Lead-to-close rate** | % of leads that become clients | Reveals traffic quality issues |
| **Lead value** | Revenue per closed lead | Enables value-based bidding if tracked |
| **Call connection rate** | % of calls answered | Low rate = wrong call volume, wrong time-of-day targeting |

**Typical conversion types:**

| Conversion | Tracking method | Notes |
|------------|----------------|-------|
| Form fill | GTM form submit event → sGTM → Google Ads | Deduplicate by form submission ID |
| Phone call (from ad) | Google call extension / call-only ad | Tracked natively via Google Ads forwarding number |
| Phone call (from website) | Google Ads website call tracking tag | Requires Google call tracking snippet on site |
| Live chat | Chat platform event (e.g., Intercom, Tidio) | Push to dataLayer, import via GTM |
| Offline conversion (qualified lead) | GCLID-based offline import | Transformative — assign value to closes, not just leads |

%%fact-check: Google Ads call tracking via forwarding numbers (call extensions and website call tracking) — verified 2026-04-03%%

---

## 2. Recommended Campaign Mix by Maturity

> [!info] Lead Gen Is Search-First
> Unlike e-commerce, there is no feed-based campaign type. Search captures intent directly. PMax without a feed (non-feed PMax) exists but should only be tested once the account has established CPA data.

| Maturity Stage | Primary Campaigns | Supporting Campaigns | Not Yet |
|---------------|------------------|---------------------|---------|
| **Cold start** (0-3 mo) | Search — exact/phrase, top services | Call-only ads (if calls are primary) | PMax, DSA, Display |
| **Early data** (3-6 mo) | Search (core keywords) | DSA (catch-all for site coverage) | Non-feed PMax |
| **Established** (6-18 mo) | Search + DSA | Non-feed PMax (test, 1 campaign) | Demand Gen |
| **Mature** (18+ mo) | Search (optimised structure) + Non-feed PMax | Demand Gen (remarketing) | — |

**Call-only campaigns** deserve special mention. In high-call sub-verticals (plumbing, legal emergency, medical urgent care), a call-only ad campaign targeting mobile devices frequently delivers lower CPL than standard text ads because it bypasses the landing page entirely.

%%fact-check: call-only campaigns available for mobile traffic targeting on Google Search — verified 2026-04-03%%

---

## 3. Campaign Structure

**Naming convention:**

```
[Brand|NB|DSA|PMax|CallOnly] — [Service/Sub-vertical] — [Match Type if Search] — [Country]
```

Examples:
- `Brand — Exact — NL`
- `NB — Personal Injury Law — Phrase — NL`
- `NB — Emergency Plumbing — Exact — NL`
- `CallOnly — Emergency Plumbing — Mobile — NL`
- `DSA — All Pages — NL`

**Ad group organisation:**

Segment by **service type and intent stage**, not just topic:

| Ad Group Theme | Example keywords | Intent |
|---------------|-----------------|--------|
| Brand | `[firm name]`, `[firm name] contact` | Branded — defend |
| Core service (exact) | `[personal injury lawyer]`, `[emergency plumber near me]` | High intent |
| Long-tail service | `[personal injury lawyer after car accident amsterdam]` | Very high intent, lower volume |
| Informational (optional) | `how to claim compensation` | Low intent — use only with tight audience targeting |
| Competitor conquest | `[competitor name] reviews` | Risky, monitor quality score |

> [!tip] Long-Tail Often Wins in Lead Gen
> Head terms (`lawyer amsterdam`) are expensive and attract mixed intent — researchers, job seekers, students. Long-tail terms (`personal injury lawyer car accident amsterdam no win no fee`) attract buyers. In lead gen, CTR matters less than CVR. A long-tail keyword with 2% CTR and 10% CVR beats a head term with 8% CTR and 1% CVR.

---

## 4. Bidding Strategy

**Recommended path:**

```
Manual CPC (cold start, control spend while testing)
  → Maximize Conversions (once 10+ leads/month — use cautiously)
  → tCPA (once 30+ leads/month, stable for 4+ weeks)
  → Value-based bidding — tROAS (once offline values are imported)
```

> [!warning] Maximize Conversions Without a tCPA Floor
> Using Maximize Conversions without a tCPA cap in a lead gen account can drain budget on high-volume, low-quality traffic. Always set a Max CPC bid limit or switch to tCPA as soon as you have enough data. Twenty leads/month is the minimum threshold for tCPA to have signal.

**Value-based bidding for lead gen:**

Once you import offline conversion values (see Section 5), you can run Maximize Conversion Value or tROAS. This is a significant capability upgrade — the algorithm learns that a "legal consultation" lead worth €2,000 (if it closes) outweighs five "home services" leads worth €200 each.

**Typical benchmarks by sub-vertical (NL/EU, 2025):**

%%fact-check: EU lead gen CPL benchmarks — sourced from Wordstream 2024 B2C industry data, Google Think with Google vertical benchmarks — verified 2026-04-03%%

| Sub-vertical | Typical CPL | Typical CVR | Notes |
|-------------|------------|------------|-------|
| Legal (personal injury, employment) | €50-€200 | 3-6% | High value per client, competitive |
| Home services (plumbing, HVAC, roofing) | €15-€50 | 5-12% | High call volume, local |
| Insurance (life, mortgage, health) | €30-€100 | 2-5% | Regulated, compliance-sensitive |
| Healthcare (dental, physio, clinics) | €20-€60 | 4-8% | GDPR-sensitive in NL |
| Education (courses, adult learning) | €25-€80 | 3-7% | Long consideration phase |
| Financial services (mortgages, loans) | €40-€150 | 2-4% | AFM-regulated in NL |

---

## 5. Conversion Tracking

This is the section that separates functional lead gen tracking from truly effective lead gen tracking.

**Minimum viable tracking:**

| Conversion | Setup | Why |
|------------|-------|-----|
| Form submission | GTM dataLayer push on form success → sGTM → Google Ads | Core conversion event |
| Phone call (ad click) | Google Ads call extension with call reporting enabled | Native tracking, no extra setup |
| Phone call (website) | Google Ads website call tracking snippet | Captures calls from organic and paid |

**Recommended tracking (with offline imports):**

%%fact-check: Google Ads offline conversion import via GCLID — verified 2026-04-03%%

The GCLID-based offline conversion import is the single biggest upgrade available for lead gen accounts. Setup:

1. Capture `gclid` parameter on every form submission (store in hidden field, push to CRM)
2. When a lead qualifies (MQL, SQL, or closes), export a CSV: `GCLID, conversion_name, conversion_time, conversion_value`
3. Upload to Google Ads (manual or API) — Google matches to the original click
4. Google Ads now optimises for qualified leads, not just any lead

> [!success] Offline Conversions Transform Smart Bidding
> Before offline imports: Smart Bidding optimises for the cheapest form fills (often low-quality traffic). After offline imports: Smart Bidding learns to find traffic that actually converts to clients. Accounts that implement offline conversion imports typically see CPL increase short-term but CPQL drop 20-40%.

**Attribution window:**

- Form fills: 30-day click attribution is standard
- Offline conversion import: the `conversion_time` you upload should reflect when the lead qualified (not when the form was submitted), but the GCLID ties it back to the original click

---

## 6. Audience Strategy

**Priority audiences:**

| Audience | Type | Use |
|----------|------|-----|
| Past converters | RLSA / Customer Match | Exclusion (already a lead — do not retarget) |
| Website visitors (7d, did not convert) | RLSA | Bid up — showed intent, no conversion |
| Landing page visitors (no form view) | RLSA | Mid-funnel retargeting |
| Customer list (all closed clients) | Customer Match | Exclusion + lookalike seed |
| In-market segments (Google) | In-market audiences | Observation mode first — measure CVR difference |

> [!warning] Exclude Past Converters
> In lead gen, past converters who re-encounter your search ads are almost always existing clients doing research — not new leads. Failing to exclude them wastes budget and skews CVR data. Upload your client list as a Customer Match audience and exclude from all prospecting campaigns.

**Remarketing approach:**

Lead gen remarketing has a short half-life. A visitor who did not convert within 72 hours is already 5x less likely to convert than a same-day visitor. Segment remarketing windows:

- **0-3 days**: High intent, bid up aggressively in RLSA
- **3-7 days**: Moderate bid adjustment
- **7-30 days**: Low bid, generic messaging
- **30+ days**: Exclude or move to Demand Gen awareness

---

## 7. Common Mistakes

> [!failure] Mistake 1 — Optimising for form fills without tracking lead quality
> The cheapest leads are usually the worst leads. Without offline conversion imports, Smart Bidding finds the traffic most likely to fill a form — not the traffic most likely to become a client. Fix: implement GCLID-based offline import within 60-90 days of launch.

> [!failure] Mistake 2 — Running broad match without Smart Bidding
> Broad match expands to unexpected queries. Without Smart Bidding to constrain it, broad match in a lead gen account can drain budget on irrelevant searches within days. Either keep exact/phrase match with manual CPC, or use broad match exclusively with tCPA Smart Bidding (which naturally constrains expansion to queries that meet your CPA target).

> [!failure] Mistake 3 — Not tracking phone calls
> In many lead gen sub-verticals (legal, home services, healthcare), 30-60% of leads come via phone, not form. If you are not tracking calls, you are optimising on half the data. Set up both call extension tracking and website call tracking. Minimum call duration threshold: 60 seconds (filters out voicemails and misdials).

> [!failure] Mistake 4 — Using informational keywords without audience targeting
> Keywords like `how to find a lawyer` or `what does a plumber cost` attract researchers, not buyers. If you use them at all, overlay an in-market or remarketing audience and bid down significantly for the non-audience traffic.

> [!failure] Mistake 5 — Not using call-only ads on mobile
> In high-urgency sub-verticals (emergency plumbing, locksmith, legal emergencies), mobile users want to call — not read a landing page. Call-only campaigns on mobile deliver the phone number directly in the ad. Many accounts see 50-70% lower CPL from call-only campaigns compared to standard ads in these sub-verticals.

---

## 8. KPI Benchmarks

%%fact-check: lead gen conversion rate benchmarks by sub-vertical — sourced from Wordstream 2024, Unbounce Conversion Benchmark Report 2024 — verified 2026-04-03%%

| KPI | Weak | Average | Strong |
|-----|------|---------|--------|
| CTR (non-brand Search) | < 2% | 4-7% | 10%+ |
| CVR (landing page) | < 2% | 3-8% | 12%+ |
| CPL (home services) | > €70 | €15-€50 | < €15 |
| CPL (legal) | > €250 | €50-€200 | < €50 |
| Quality Score (core keywords) | < 5 | 6-8 | 9-10 |
| Call conversion rate (from ad) | < 20% | 40-60% | 70%+ |
| Lead-to-close rate | < 5% | 10-25% | 30%+ |

---

## 9. Seasonal Patterns

Lead gen seasonality is sub-vertical dependent. Unlike e-commerce, there is no universal Q4 peak.

| Sub-vertical | Peak Period | Trough | Notes |
|-------------|------------|--------|-------|
| **Home services** (HVAC, roofing) | Spring (Mar-May), Autumn (Sep-Oct) | December-January | Weather-driven |
| **Legal** | Year-round with slight Jan spike | August | Many people resolve to act in January |
| **Insurance** | Jan-Feb (annual renewals) | Summer | Policy year-end drives comparisons |
| **Healthcare / dental** | Jan (new year intent), Sep (back to routine) | Jul-Aug | Healthcare is less seasonal than others |
| **Education** | Aug-Sep (enrolment) | Dec-Jan, Jun-Jul | Academic calendar driven |
| **Financial (mortgages)** | Spring (property season) | Winter | Correlates with property market |

> [!tip] Budget Reserve for Urgency Sub-verticals
> Emergency plumbing, locksmiths, and similar urgency-driven services have no season — but weather events can cause sudden spikes (burst pipes in frost, storm damage). Maintain a budget buffer or set automated rules to increase daily budgets when weather-related searches spike.

---

## 10. Cross-references

| Topic | Document |
|-------|----------|
| Account maturity model | [[account-profiles]] |
| Bidding strategy selection | [[bidding-strategies]] |
| Conversion action setup | [[conversion-actions]] |
| DSA campaign setup | [[dsa]] |
| Call tracking setup | [[ad-extensions]] |
| Match type strategy | [[match-types]] |
| Negative keyword lists | [[audit/negative-keyword-lists]] |
| Common mistakes (all verticals) | [[audit/common-mistakes]] |
| Offline conversion tracking | [[enhanced-conversions]] |

---

## Further Reading

- [Google Ads call reporting setup](https://support.google.com/google-ads/answer/6100664) — official call tracking configuration guide
- [Google Ads offline conversion import documentation](https://support.google.com/google-ads/answer/2998031) — GCLID-based import reference
- [Wordstream Lead Generation Benchmarks 2024](https://www.wordstream.com/blog/ws/2016/02/29/google-adwords-industry-benchmarks) — CVR and CPA by industry
- [Unbounce Conversion Benchmark Report 2024](https://unbounce.com/conversion-benchmark-report/) — landing page CVR by industry
- [Think with Google — B2C Lead Generation](https://www.thinkwithgoogle.com/intl/en-emea/marketing-strategies/automation/smart-bidding-offline-conversions/) — Smart Bidding with offline conversions
