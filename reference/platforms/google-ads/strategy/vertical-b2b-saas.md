---
title: "Vertical Playbook — B2B SaaS"
date: 2026-04-03
tags:
  - reference
  - strategy
  - vertical
---

# Vertical Playbook — B2B SaaS

%%
Audience: tracking specialists learning campaign strategy.
Covers the Google Ads B2B SaaS vertical — long sales cycles, low conversion volume, multi-step funnel, offline conversion imports essential.
%%

> [!abstract] What This Covers
> Campaign strategy for software products sold to businesses — long cycles, thin conversion volume, multi-step funnels, CRM integration. Cross-references: [[vertical-ecommerce]], [[vertical-lead-gen]], [[vertical-local-services]], [[account-profiles]].

---

## 1. Overview

B2B SaaS is the hardest Google Ads vertical to run well. The business metrics that matter (pipeline value, closed-won revenue, CAC payback period) are months removed from the Google Ads click. The conversion volumes needed for Smart Bidding automation are often absent for months. And the queries that look like intent (`HR software`, `project management tool`) attract everyone from students doing research to CTOs evaluating vendors.

**What defines this vertical:**
- Long sales cycles: 30-180 days from click to closed-won, depending on ACV
- Low conversion volume: most B2B SaaS accounts generate fewer than 30 leads/month from Google Ads
- Multi-step funnel: click → lead → MQL → SQL → opportunity → closed-won
- High deal values: ACV from €1K (SMB tools) to €100K+ (enterprise platforms)
- Content interplay: many ads lead to blog posts, case studies, or calculators — not direct conversion pages
- Google Ads sees only the top of the funnel unless offline conversions are imported

**Key business metrics:**

| Metric | Definition | Why It Matters |
|--------|------------|----------------|
| **CPL** | Cost per lead (any form fill) | Top-line efficiency — meaningful only with quality data |
| **CPMQL** | Cost per Marketing Qualified Lead | First quality signal after scoring |
| **CPSQL** | Cost per Sales Qualified Lead | What sales actually works |
| **Pipeline CAC** | Ad spend ÷ pipeline influenced | Attribution-adjusted customer acquisition cost |
| **CAC payback period** | CAC ÷ monthly recurring revenue | How long to recover acquisition cost |
| **ACV** | Annual Contract Value | Determines how much you can afford to spend per lead |

**Typical conversion types:**

| Conversion | Tracking method | Notes |
|------------|----------------|-------|
| Demo request | GTM form submit → sGTM → Google Ads | Primary conversion — should carry offline value eventually |
| Free trial signup | GTM form submit / app event | High volume, lower quality signal than demo request |
| Content download (gated) | Form submit | Weak signal — use as micro-conversion only |
| MQL (offline) | GCLID import from CRM | Assign value based on average lead-to-close rate |
| SQL (offline) | GCLID import from CRM | Higher value than MQL |
| Closed-won (offline) | GCLID import from CRM | Ultimate signal — import ACV as conversion value |

%%fact-check: Google Ads GCLID-based offline conversion import for multi-step CRM funnels — verified 2026-04-03%%

---

## 2. Recommended Campaign Mix by Maturity

> [!warning] PMax Rarely Works in B2B SaaS
> Performance Max is built for high-volume conversion signals. B2B SaaS accounts with fewer than 30 conversions/month give PMax insufficient signal to operate effectively. Non-feed PMax campaigns will often exhaust budget on broad, low-intent traffic. Do not introduce PMax until you have 50+ lead-level conversions/month and are importing downstream CRM signals.

| Maturity Stage | Primary Campaigns | Supporting Campaigns | Not Yet |
|---------------|------------------|---------------------|---------|
| **Cold start** (0-3 mo) | Search — exact match, bottom-funnel keywords only | Brand Search | PMax, Demand Gen, DSA |
| **Early data** (3-6 mo) | Search (exact + phrase, core intent) | Brand + Demand Gen (warm remarketing) | Non-feed PMax |
| **Established** (6-18 mo) | Search (optimised) + Demand Gen (prospecting) | Brand + content-targeting campaign | Non-feed PMax (only with CRM imports) |
| **Mature** (18+ mo) | Search + Demand Gen (full funnel) | Non-feed PMax (with offline values) | — |

**Demand Gen for B2B SaaS:**

Demand Gen (formerly Discovery) is underused in B2B SaaS but valuable for mid-funnel. Use it to retarget:
- Website visitors who viewed a pricing page but did not convert
- Blog readers who visited 3+ pages
- Trial users who did not convert to paid

Do not use Demand Gen for top-of-funnel prospecting until Search campaigns are profitable.

---

## 3. Campaign Structure

**Naming convention:**

```
[Brand|NB|Competitor|DemandGen] — [Intent Level / Segment] — [Match Type if Search] — [Country]
```

Examples:
- `Brand — Exact — NL`
- `NB — BOFU — Demo Request — Exact — NL`
- `NB — MOFU — Comparison Keywords — Phrase — NL`
- `Competitor — Conquest — Exact — NL`
- `DemandGen — Remarketing — Pricing Page — NL`

**Intent segmentation — the core structural principle:**

Unlike e-commerce or local services, B2B SaaS must segment campaigns by **funnel stage (intent level)**, not just product:

| Funnel Stage | Keyword Intent Examples | Expected CVR | Budget Priority |
|-------------|------------------------|-------------|----------------|
| **BOFU** (bottom) | `[product] pricing`, `buy [product]`, `[product] demo`, `[competitor] alternative` | 3-8% | Highest — spend here first |
| **MOFU** (middle) | `best [category] software`, `[product] vs [competitor]`, `[category] tools 2025` | 1-3% | Medium — only after BOFU is funded |
| **TOFU** (top) | `how to [problem]`, `[category] guide`, `what is [concept]` | 0.1-0.5% | Low or none — content channel, not paid |

> [!danger] Do Not Bid on TOFU Keywords
> Informational keywords (`what is project management software`, `how to track employee time`) attract people with zero purchase intent. CPL from TOFU keywords is typically 5-10x BOFU CPL with far lower lead quality. In a budget-constrained B2B SaaS account, TOFU keywords are a budget drain.

**Competitor campaign considerations:**

Competitor keyword targeting is common in SaaS (`salesforce alternative`, `hubspot vs activedemand`). Considerations:
- Quality Scores will be low (5-6) because your landing page is not about the competitor — factor in higher CPCs
- Use dedicated landing pages that acknowledge the comparison honestly
- Works best for established competitors with unhappy customers actively searching alternatives

---

## 4. Bidding Strategy

**Recommended path:**

```
Manual CPC (cold start — control spend in low-volume environment)
  → Maximize Conversions (only when 15+ leads/month — risky below this)
  → tCPA (once 30+ leads/month, 4+ stable weeks)
  → Maximize Conversion Value + offline values (once CRM import is live)
```

> [!warning] Smart Bidding Requires Volume B2B SaaS Often Cannot Provide
> Google recommends 30+ conversions/month per campaign for Smart Bidding to work reliably. Many B2B SaaS accounts generate 5-15 leads/month from Google Ads. Running tCPA on a campaign with 8 conversions/month produces erratic behaviour — the algorithm oscillates, spending in spikes. Options: (a) stay on manual CPC longer than you would in other verticals, (b) consolidate all campaigns into one or two to pool data, (c) use a micro-conversion as the bid signal (trial signup) while tracking demo requests as a secondary conversion.

%%fact-check: Google's 30-conversion/month recommendation for Smart Bidding — Google Ads Help documentation on Smart Bidding — verified 2026-04-03%%

**Typical benchmarks (NL/EU B2B SaaS, 2025):**

%%fact-check: B2B SaaS Google Ads benchmarks — sourced from Databox State of Google Ads 2024, Wordstream B2B benchmarks — verified 2026-04-03%%

| Metric | Weak | Average | Strong |
|--------|------|---------|--------|
| CTR (non-brand, BOFU) | < 2% | 3-6% | 8%+ |
| CVR (landing page, demo request) | < 1% | 2-5% | 8%+ |
| CPL (demo request, SMB SaaS) | > €200 | €50-€150 | < €40 |
| CPL (enterprise SaaS) | > €500 | €100-€400 | < €100 |
| CPC (BOFU Search) | — | €3-€12 | — |

> [!info] High CPL Is Not Always a Problem
> A €150 CPL for a SaaS product with €15K ACV means you spend €150 to acquire a lead with a potential value of €15K. If your lead-to-close rate is 5%, your effective CAC from Google Ads is €3,000 — still potentially acceptable for enterprise SaaS. Always evaluate CPL relative to ACV.

---

## 5. Conversion Tracking

For tracking specialists, B2B SaaS is the most technically interesting vertical because the full value stack requires CRM integration, not just on-site event tracking.

**Phase 1 — On-site events (minimum viable):**

| Event | GTM trigger | sGTM route | Google Ads action |
|-------|------------|-----------|------------------|
| Demo request (form) | Form success page view or form submit event | sGTM → Google Ads | Primary conversion, no value initially |
| Free trial signup | Form success or redirect | sGTM → Google Ads | Secondary conversion |
| Pricing page view | Virtual pageview | sGTM → GA4 | Audience segment only |

**Phase 2 — Offline conversion imports (recommended, critical for maturity):**

Architecture for GCLID capture → CRM → Google Ads:

1. On form submit: capture `gclid` from URL parameter → store in hidden field → pass to CRM with lead record
2. CRM workflow: when lead status changes to MQL → export row: `gclid, conversion_name=MQL, conversion_time, conversion_value=300`
3. CRM workflow: when lead status changes to SQL → export row: `gclid, conversion_name=SQL, conversion_time, conversion_value=1000`
4. CRM workflow: when deal closes → export row: `gclid, conversion_name=ClosedWon, conversion_time, conversion_value=[ACV]`
5. Upload to Google Ads (manual weekly CSV or Google Ads API)

%%fact-check: Google Ads offline conversion import accepting CRM-sourced GCLID data up to 90 days after the original click — verified 2026-04-03%%

> [!success] Offline Imports Change Everything
> Without offline imports, Smart Bidding optimises for the cheapest demo requests — often from small companies or students who fill out forms but never buy. With closed-won offline imports, the algorithm learns to find traffic that generates revenue. Accounts that implement full CRM offline imports report 30-50% improvement in pipeline quality from Google Ads within 3-6 months.

**Attribution window:**

- Demo request: 30-day click, 7-day view
- Offline imports: the GCLID has a 90-day lifetime — import closed-won events that occurred within 90 days of the original click

**Attribution model:** Use last-click until you have 300+ conversions/month. With thin data, data-driven attribution becomes unreliable and can misattribute credit to branded keywords.

---

## 6. Audience Strategy

**Priority audiences:**

| Audience | Type | Use |
|----------|------|-----|
| Pricing page visitors (7d) | RLSA / Demand Gen | Highest-intent non-converters — bid up 30-50% |
| Demo page visitors, no submit (3d) | RLSA | Retarget: remove friction (show testimonials, case studies) |
| Blog readers (14d, 3+ pages) | Demand Gen | Content-engaged non-converts |
| Customer list (all clients) | Customer Match | Exclusion from prospecting |
| Trial users (non-paid) | Customer Match (CRM export) | Upsell / convert to paid — Demand Gen |
| Job title targeting (Google) | In-market / demographic | Observation only — B2B job title targeting on Google is imprecise |

> [!warning] Job Title Targeting on Google Is Imprecise
> Unlike LinkedIn, Google does not have reliable B2B job title data. Google's `professional audience` segments are inferred from behaviour, not profile data. Use them in **observation mode** first — add the audience segment, observe CTR and CVR differences, then bid adjust based on data. Do not rely on them for precise persona targeting.

**Account-based marketing (ABM) integration:**

For enterprise SaaS with named-account selling:
- Upload target account domain lists as Customer Match (email format: pull from LinkedIn/ZoomInfo, export to Customer Match)
- Bid up 2-3x for visitors from target accounts
- Dedicate separate ad copy and landing pages to ABM accounts

---

## 7. Common Mistakes

> [!failure] Mistake 1 — Optimising for demo requests without CRM quality signal
> The demo request is a form fill, not a sale. Without CRM integration, Smart Bidding optimises for the cheapest form fills — often SMBs, students, or competitors doing research. Without offline imports, you may be winning CPL battles while losing the war on pipeline quality.

> [!failure] Mistake 2 — Introducing PMax before volume exists
> Non-feed PMax with 10 leads/month will exhaust budget on broad, irrelevant traffic within weeks. Google's algorithm needs signal to constrain itself. With low volume, PMax reverts to broad Display/YouTube inventory. Hold off until you have 50+ tracked conversions/month and have imported at least one layer of offline qualification signal.

> [!failure] Mistake 3 — Bidding on TOFU and informational keywords
> `how to manage projects` is not a SaaS purchase query. Bidding on educational or awareness-stage keywords in a budget-constrained B2B SaaS account generates leads at 5-10x the CPL of BOFU keywords with a fraction of the close rate. Starve TOFU spend until BOFU campaigns are fully funded.

> [!failure] Mistake 4 — Not capturing the GCLID on form submission
> The GCLID is the bridge between Google Ads and your CRM. If it is not captured at the point of form submission and stored against the lead record, offline conversion imports become impossible. Implement GCLID capture in the first week of any campaign — do not wait until the CRM integration is ready.

> [!failure] Mistake 5 — Expecting results in 30 days
> B2B SaaS evaluation cycles are 30-180 days. A campaign launched in January may generate its first closed-won in May. Teams that judge B2B SaaS campaigns by 30-day metrics almost always under-invest and kill campaigns before the data matures. Set stakeholder expectations at campaign launch: meaningful optimisation data requires 3-6 months minimum.

---

## 8. KPI Benchmarks

%%fact-check: B2B SaaS Google Ads CVR and CPA benchmarks — sourced from Databox 2024 B2B Benchmark Report, HubSpot benchmarks — verified 2026-04-03%%

| KPI | Weak | Average | Strong | Notes |
|-----|------|---------|--------|-------|
| CTR (BOFU Search) | < 2% | 3-6% | 8%+ | Low CTR on exact match = wrong ad copy |
| CVR (demo request LP) | < 1% | 2-5% | 8%+ | LP quality is the biggest lever |
| CPL (demo, SMB SaaS) | > €200 | €50-€150 | < €40 | |
| Quality Score (core keywords) | < 5 | 6-8 | 9-10 | Low QS = pay 20-50% more per click |
| Lead-to-MQL rate | < 10% | 20-40% | 50%+ | Measures traffic quality |
| Lead-to-close rate | < 1% | 3-8% | 15%+ | Measures full-funnel health |

---

## 9. Seasonal Patterns

B2B SaaS has a distinctive seasonality tied to corporate buying cycles, budget allocation, and holiday periods.

| Period | Typical Impact | Action |
|--------|---------------|--------|
| **January** | +15-25% intent spike — new budgets, new resolutions | Increase budgets Jan 2; decision-makers return from holiday |
| **Q1 (Jan-Mar)** | Strong — new fiscal year budgets available | Full spend, aggressive bidding |
| **Q2 (Apr-Jun)** | Moderate — mid-cycle evaluations | Maintain spend |
| **Summer (Jul-Aug)** | -20-40% — decision-makers on holiday | Reduce budgets 20-30%; maintain brand and remarketing |
| **September** | Recovery spike — people return and resume evaluations | Increase budgets mid-August |
| **Q4 Oct-Nov** | Strong — year-end budget spend | Increase budgets; decision-makers have use-it-or-lose-it budgets |
| **December** | -30-50% — offices closing, decisions stall | Pause or heavily reduce by Dec 15 |

> [!tip] Year-End Budget Flush
> Many enterprise B2B buyers have use-it-or-lose-it year-end budgets. November through mid-December can see a spike in purchase intent from buyers who need to commit budget before the fiscal year closes. This is not universal — depends on your buyer's industry — but worth testing with a budget increase in November.

---

## 10. Cross-references

| Topic | Document |
|-------|----------|
| Account maturity model | [[account-profiles]] |
| Bidding strategy selection | [[bidding-strategies]] |
| Conversion action setup | [[conversion-actions]] |
| Enhanced conversions | [[enhanced-conversions]] |
| Demand Gen campaigns | [[demand-gen]] |
| Match type strategy | [[match-types]] |
| GAQL for CRM reporting | [[gaql-reference]] |
| Common mistakes (all verticals) | [[audit/common-mistakes]] |
| Audience signals (for Demand Gen) | [[pmax/audience-signals]] |

---

## Further Reading

- [Google Ads offline conversion import documentation](https://support.google.com/google-ads/answer/2998031) — GCLID-based CRM import reference
- [Google Ads Smart Bidding guide](https://support.google.com/google-ads/answer/7065882) — official Smart Bidding documentation including volume requirements
- [Databox State of Google Ads 2024](https://databox.com/google-ads-benchmarks) — B2B conversion benchmarks
- [Think with Google — B2B buyer journey research](https://www.thinkwithgoogle.com/intl/en-emea/marketing-strategies/automation/b2b-digital-growth/) — enterprise buyer behaviour
- [HubSpot Marketing Benchmarks by Industry](https://www.hubspot.com/marketing-statistics) — B2B lead and funnel benchmarks
