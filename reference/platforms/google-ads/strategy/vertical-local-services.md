---
title: "Vertical Playbook — Local Services"
date: 2026-04-03
tags:
  - reference
  - strategy
  - vertical
---

# Vertical Playbook — Local Services

%%
Audience: tracking specialists learning campaign strategy.
Covers the Google Ads local services vertical — location-bound, call-heavy, budget-constrained, high-intent.
%%

> [!abstract] What This Covers
> Radius targeting, call tracking, Google Business Profile integration, Local Services Ads, budget management for small geographic audiences. Cross-references: [[vertical-ecommerce]], [[vertical-lead-gen]], [[vertical-b2b-saas]], [[account-profiles]].

---

## 1. Overview

Local services accounts are geographically constrained by definition. A plumber in Amsterdam cannot serve a customer in Rotterdam. This constraint defines everything: the addressable audience is small, competition is local rather than national, and most leads come in via phone call, not form submission.

The upside: intent is very high. Someone searching `loodgieter amsterdam spoed` (emergency plumber Amsterdam) needs help now. CVRs of 10-20% are achievable with a well-structured campaign because the query-to-intent match is so tight.

**What defines this vertical:**
- Geographic boundary is hard — service area defines maximum reach
- Most conversions are phone calls, not web forms
- Budgets are typically small (€500-€3K/month) relative to other verticals
- Google Business Profile is a traffic source in its own right and affects ad performance
- Local Services Ads (LSA) are a parallel paid channel separate from standard Google Ads
- High urgency sub-verticals (plumbing, locksmith, glazing) have no planning phase — the query is the conversion

**Key business metrics:**

| Metric | Definition | Why It Matters |
|--------|------------|----------------|
| **Cost per call** | Total spend ÷ tracked calls | Primary KPI for most local services |
| **Cost per booking** | Total spend ÷ confirmed bookings | For sub-verticals with booking systems |
| **Call connection rate** | Answered calls ÷ total calls | Low rate wastes ad spend |
| **Booking rate** | Bookings ÷ total calls | Measures call quality and business conversion |
| **Service area CPL** | CPL within target radius | Filters out-of-area clicks |

**Typical conversion types:**

| Conversion | Tracking method | Notes |
|------------|----------------|-------|
| Phone call (from ad) | Google call extension, call-only ad | Native Google tracking via forwarding number |
| Phone call (from website) | Google Ads website call tracking snippet | Tracks calls that come after a click to the site |
| Form submission (booking) | GTM form event → sGTM → Google Ads | Secondary — many local businesses prefer calls |
| Online booking (third-party) | Integration via booking platform (Treatwell, Booksy, etc.) | Platform-dependent tracking |
| Direction request | Google Business Profile tracking | Not a Google Ads conversion, but a signal |

%%fact-check: Google Ads website call tracking snippet (phone number swap) available for Google Ads conversions — verified 2026-04-03%%

---

## 2. Recommended Campaign Mix by Maturity

| Maturity Stage | Primary Campaigns | Supporting Campaigns | Consider Adding |
|---------------|------------------|---------------------|----------------|
| **Cold start** (0-3 mo) | Search — exact, core services | Brand Search | Call-only campaign (mobile) |
| **Early data** (3-6 mo) | Search (exact + phrase) + Call-only | Brand | LSA (parallel channel, not Google Ads) |
| **Established** (6-18 mo) | Search + Call-only | DSA (catch-all) | Location-specific campaigns (multi-location) |
| **Mature** (18+ mo) | Search + Call-only + DSA | Demand Gen (remarketing — low priority) | — |

> [!info] Local Services Ads (LSA) Are a Separate Product
> LSA is not managed through Google Ads — it is a separate Google product accessed via the Local Services Ads platform. LSA charges per lead (not per click), is verified-business only, and shows above standard ads in local searches. For eligible business categories (plumbers, locksmiths, cleaners, etc.), LSA and Google Ads can run simultaneously and complement each other.
> LSA eligibility varies by country and category. Check: [ads.google.com/local-services-ads](https://ads.google.com/local-services-ads)

%%fact-check: Local Services Ads availability by category and country (NL coverage for plumbing, cleaning, locksmith) — verified 2026-04-03%%

---

## 3. Campaign Structure

**Naming convention:**

```
[Brand|NB|CallOnly|DSA] — [Service] — [Match Type] — [City/Region]
```

Examples:
- `Brand — Exact — Amsterdam`
- `NB — Plumbing Emergency — Exact — Amsterdam`
- `NB — Plumbing Planned — Phrase — Amsterdam`
- `CallOnly — Emergency — Mobile — Amsterdam`
- `DSA — All Services — Amsterdam`

**Geographic segmentation:**

For multi-location businesses, separate campaigns by city or service area — do not use one national campaign with radius targeting. Reasons:
- Separate budgets allow you to scale high-performing areas and cap low-performing ones
- Location-specific ad copy outperforms generic copy (`Amsterdam plumber available today` beats `local plumber`)
- Competition levels differ by area — separate bids needed

**Ad group organisation by service type:**

| Ad Group | Keyword examples | Expected intent |
|----------|-----------------|----------------|
| Emergency (spoed) | `loodgieter spoed amsterdam`, `emergency plumber amsterdam 24h` | Immediate — high CVR |
| Planned work | `cv ketel vervangen amsterdam`, `central heating installation` | Consider — 1-7 day decision |
| Specific service | `toilet installeren`, `lekkage repareren` | Medium intent |
| Brand | `[company name]` | Branded |

> [!tip] Separate Emergency and Planned Campaigns
> Emergency and planned-work keywords attract completely different users with different urgency and price sensitivity. Emergency searchers will pay more and decide faster. Planned-work searchers compare quotes. Separate campaigns allow different bids, different ad copy (tone: calm vs. urgent), and different landing pages.

**Call-only campaigns — when to use:**

Use call-only campaigns on mobile when:
- The primary conversion is a phone call (true for most local services)
- Your landing page load time is > 3 seconds on mobile (common for small businesses)
- Your service has high urgency (locksmith, plumbing, drainage, glazing)

Call-only ads bypass the landing page entirely — the call button is the ad. This eliminates landing page friction and is often the lowest-CPL campaign type in this vertical.

---

## 4. Bidding Strategy

**Recommended path:**

```
Manual CPC (cold start — especially important with small budgets)
  → Maximize Conversions (once 10+ calls/month)
  → tCPA (once 20+ conversions/month, stable)
```

> [!warning] Maximize Conversions Can Overspend Small Budgets
> Local services accounts often have daily budgets of €20-€60. Maximize Conversions without a tCPA cap will sometimes spend the entire daily budget before 9am to reach its conversion target. For small-budget accounts, Manual CPC with strong negative keyword hygiene frequently outperforms automation because it keeps each click within a controlled cost range.

**Bid adjustments that matter for local:**

| Adjustment Type | Recommendation | Notes |
|----------------|---------------|-------|
| Location (radius) | -50% outside primary service area | Limit waste on out-of-area searches |
| Device (mobile) | +20-30% for call-oriented services | Mobile drives calls |
| Time of day | +20% business hours; -50% or off overnight (unless 24h service) | Match operational hours |
| Day of week | Monitor — Saturday/Sunday varies by service type | Some services peak weekends |

%%fact-check: location bid adjustments and device bid adjustments available in standard Google Ads Search campaigns — verified 2026-04-03%%

**Typical benchmarks (NL local services, 2025):**

%%fact-check: local services Google Ads benchmarks — sourced from Wordstream 2024 local services data, Google Local Services Ads metrics guidance — verified 2026-04-03%%

| Metric | Weak | Average | Strong |
|--------|------|---------|--------|
| CTR (Search, exact) | < 3% | 6-12% | 15%+ |
| CVR (call or form) | < 3% | 5-15% | 20%+ |
| CPC (NL, local services) | — | €1-€5 | — |
| Cost per call | > €60 | €10-€40 | < €10 |
| Call connection rate | < 30% | 50-70% | 80%+ |

---

## 5. Conversion Tracking

Call tracking is the most important — and most frequently neglected — part of local services Google Ads tracking.

**Call tracking setup:**

Three layers of call tracking for full coverage:

| Layer | What It Tracks | Setup |
|-------|---------------|-------|
| Call extension reporting | Calls directly from ad call button | Enable call reporting in Google Ads — auto-tracks |
| Website call tracking | Calls after user clicks to website | Google Ads website call tracking snippet swaps phone number; tracks duration |
| Third-party call tracking | Advanced: call recording, CRM integration | CallRail, Ringba, CallTrackingMetrics — passes call events to Google Ads |

%%fact-check: Google Ads website call tracking dynamic number insertion available for NL phone numbers — verified 2026-04-03%%

**Minimum call duration threshold:**

Set a minimum call duration of 60-90 seconds before counting a call as a conversion. Calls under 60 seconds are typically voicemails, wrong numbers, or immediate hang-ups — not genuine leads. Without a duration threshold, short calls inflate your conversion count and mislead Smart Bidding.

> [!tip] For Tracking Specialists
> Google Ads call tracking uses dynamic number insertion (DNI) — the same concept as UTM parameter tracking but for phone numbers. The Google Ads tag swaps the static phone number on the page for a Google forwarding number that ties back to the click. In a sGTM setup, you can capture call events server-side and pipe them to GA4 and Google Ads simultaneously, maintaining the clean sGTM → BigQuery pipeline.

**Form tracking:**

For local services businesses with booking forms:
- Many use third-party booking platforms (Calendly, Acuity, Treatwell, Booksy)
- Track form submissions via GTM if the platform supports it, or use thank-you page URL tracking
- Pass `conversion_value` only if you know the booking value (e.g., fixed-price service)

---

## 6. Audience Strategy

Local services has a simpler audience strategy than other verticals. The geo-constraint limits your universe, and the high-intent nature of local searches means audiences play a smaller role than in awareness-heavy verticals.

**Priority audiences:**

| Audience | Type | Use |
|----------|------|-----|
| Past callers/bookers | Customer Match (phone/email) | Exclusion (existing clients) OR loyalty remarketing for repeat services |
| Website visitors (3d, no conversion) | RLSA | Bid up 20-30% — they researched but did not call |
| In-market (home services) | Google in-market segments | Observation mode — measure CVR uplift before bidding |
| Similar audiences | Google auto-generated | Cautious: may expand outside radius |

> [!warning] Audience Expansion Can Break Geographic Targeting
> When using audience-based targeting or similar audiences, Google may expand reach outside your radius if the audience match is strong. Always confirm that geographic targeting is set to "People in target location" (not "People interested in target location") — especially important for radius-targeted local service accounts.

%%fact-check: Google Ads location targeting option — "People in or regularly in your targeted locations" vs "People searching for your targeted locations" — verified 2026-04-03%%

**Seasonal remarketing:**

For planned-work services (annual boiler service, garden work, gutter cleaning), a seasonal remarketing strategy outperforms year-round nurture:
- Export past customer list in October → upload to Customer Match → run boiler service ad in November
- This is a simple but effective repeat business strategy for local service businesses

---

## 7. Common Mistakes

> [!failure] Mistake 1 — Targeting too wide a radius
> A plumber serving Amsterdam targeting "Netherlands" or a 50km radius wastes budget on areas they cannot serve. Start with a 10-15km radius around the business centre, or use city-level targeting. Monitor the location report in Google Ads to see where clicks are actually coming from — then tighten.

> [!failure] Mistake 2 — Not using call-only ads on mobile for high-urgency services
> Local services users on mobile want to call — not read a landing page. A locksmith or emergency plumber with no call-only campaign is making customers click through to a site, wait for it to load, find the number, and tap it. Call-only ads shortcut this to one tap. Mobile call-only CPL in emergency sub-verticals is typically 30-50% lower than standard ad CPL.

> [!failure] Mistake 3 — Not setting call duration thresholds
> Without a minimum call duration, every voicemail and misdial is counted as a conversion. Smart Bidding trains on this noise and pushes spend toward traffic that generates short calls, not genuine leads. Set 60-90 seconds as the minimum qualifying duration.

> [!failure] Mistake 4 — Ignoring location bid adjustments
> Running flat bids across a radius means paying the same for a click from 1km away as from 25km away. Use the location report (segment by distance from business) to identify where conversions are concentrating — then apply positive bid adjustments to the core area and negative adjustments to the periphery.

> [!failure] Mistake 5 — Not optimising Google Business Profile
> Google Business Profile (GBP) is directly linked to Local Services Ads performance and influences ad quality signals for standard Search campaigns. A GBP with few reviews, outdated hours, or incorrect categories signals low quality to Google. Before launching or auditing a local services account, check GBP first: reviews, categories, photos, service areas, and business hours must all be accurate.

---

## 8. KPI Benchmarks

%%fact-check: local services CVR and CPC benchmarks NL/EU — sourced from Wordstream 2024, Google local search statistics — verified 2026-04-03%%

| KPI | Weak | Average | Strong | Notes |
|-----|------|---------|--------|-------|
| CTR (Search, exact) | < 3% | 6-12% | 15%+ | High CTR expected — high intent queries |
| CVR (call or form) | < 3% | 5-15% | 20%+ | Emergency sub-verticals reach 20%+ |
| Cost per call | > €60 | €10-€40 | < €10 | Depends heavily on service type |
| CPC | — | €1-€5 | — | Locksmith and legal can reach €8-€15 |
| Quality Score | < 5 | 6-8 | 9-10 | Low QS amplifies every CPC |
| Call connection rate | < 30% | 50-70% | 80%+ | Low rate = wasted spend, fix staffing first |
| Booking rate (post-call) | < 20% | 35-60% | 70%+ | Measures business conversion, not ad quality |

---

## 9. Seasonal Patterns

Local services seasonality is service-type dependent. Many sub-verticals are highly weather-driven.

| Sub-vertical | Peak Period | Trough | Trigger |
|-------------|------------|--------|---------|
| **Plumbing / heating** | Oct-Feb (boiler season) | Jun-Aug | Cold weather, broken boilers |
| **Aircon / cooling** | Jun-Aug | Oct-Mar | Hot weather |
| **Garden services** | Mar-May, Sep | Dec-Feb | Growing season |
| **Cleaning (residential)** | Year-round; slight spring (Mar-Apr) and pre-holiday peaks | — | Relatively stable |
| **Locksmith** | Year-round; slight summer spike (lock-outs during moves) | — | Incident-driven |
| **Electrician** | Year-round | August (vacations) | Relatively stable |
| **Pest control** | May-Sep | Oct-Mar | Warm weather |
| **Roofing / gutters** | Aug-Oct (pre-winter) | Jan-Mar | Storm-season prep |

> [!tip] Weather-Triggered Budget Increases
> For plumbing and heating, the first cold snap of autumn reliably spikes search volume for boiler service and heating repair. Set up automated budget rules in Google Ads: increase daily budget by 50% when max temperature drops below 10°C in the target city. This is a simple rule-based setup that can be managed via Google Ads automated rules or Ads Scripts.
> Cross-ref: [[ads-scripts-api]]

**Budget planning for small local budgets:**

With a monthly budget of €1,000-€2,000, seasonality is critical. Concentrate spend in peak months rather than spreading evenly. A plumber with €1,500/month should spend €250/month in June and €200/month in July (slow) and €300/month in November and €350/month in December (peak).

---

## 10. Cross-references

| Topic | Document |
|-------|----------|
| Account maturity model | [[account-profiles]] |
| Bidding strategy selection | [[bidding-strategies]] |
| Ad extensions and call extensions | [[ad-extensions]] |
| Conversion action setup | [[conversion-actions]] |
| DSA catch-all campaigns | [[dsa]] |
| Match type strategy | [[match-types]] |
| Negative keyword lists | [[audit/negative-keyword-lists]] |
| Ads Scripts (automated budget rules) | [[ads-scripts-api]] |
| Common mistakes (all verticals) | [[audit/common-mistakes]] |
| Quality Score reference | [[quality-score]] |

---

## Further Reading

- [Google Local Services Ads — overview and eligibility](https://ads.google.com/local-services-ads) — official LSA platform and category eligibility
- [Google Business Profile help](https://support.google.com/business) — GBP setup, categories, and review management
- [Google Ads call tracking setup guide](https://support.google.com/google-ads/answer/6100664) — call extension and website call tracking documentation
- [Wordstream Local Business Benchmarks 2024](https://www.wordstream.com/blog/ws/2016/02/29/google-adwords-industry-benchmarks) — local services CVR and CPA benchmarks
- [BrightLocal Local Consumer Review Survey](https://www.brightlocal.com/research/local-consumer-review-survey/) — local search behaviour and review impact on click-through
