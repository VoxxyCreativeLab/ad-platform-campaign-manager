---
title: "Account Profiles — Strategic Framework"
date: 2026-04-03
tags:
  - reference
  - google-ads
  - strategy
  - account-profiles
---

# Account Profiles

Every Google Ads recommendation should be profile-aware. A B2B SaaS account with EUR 3K/mo needs fundamentally different strategy than an e-commerce account with EUR 25K/mo. Different verticals convert differently, different budgets allow different structures, and different maturity levels dictate different bidding strategies.

This framework classifies any Google Ads account across **3 tiers and 10 dimensions**, producing a strategy archetype that guides every downstream decision: campaign types, bidding strategies, keyword approach, budget allocation, and reporting cadence.

> [!abstract] How This Document Fits
> This is the foundational reference for the entire strategic layer. All other strategy docs reference it:
> - [[account-maturity-roadmap]] uses the maturity stages defined here
> - [[vertical-ecommerce]], [[vertical-lead-gen]], [[vertical-b2b-saas]], [[vertical-local-services]] expand on vertical-specific guidance
> - [[targeting-framework]] adapts audience strategy per archetype
> - [[attribution-guide]] maps tracking maturity to attribution models

---

## Tier 1 — Core Axes

Three axes that together select a broad strategy archetype. Every account has exactly one value for each axis.

### Vertical

The vertical defines what a "conversion" means, which campaign types dominate, and how the optimization cycle works.

| Vertical | Primary conversion | Typical CVR | Key campaign types | Core metric | Feed required? |
|----------|-------------------|-------------|-------------------|-------------|---------------|
| **E-commerce** | Purchase | 1-3% | Shopping, feed-only PMax, Search | ROAS | Yes (Merchant Center) |
| **Lead Gen** | Form fill / call | 2-5% | Search, non-feed PMax | CPA | No |
| **B2B SaaS** | Demo request / trial | 0.5-2% | Search, Demand Gen | CPA (with offline value) | No |
| **Local Services** | Call / booking | 3-8% | Search, Local Services Ads | CPA | No |

%%fact-check: typical CVR ranges — industry averages from WordStream, Unbounce 2024-2025 conversion benchmark reports — verified 2026-04-03%%

**E-commerce** accounts are ROAS-driven. Average order value (AOV) determines whether you optimize for volume or margin. The product feed is the single biggest lever — feed quality directly determines Shopping and PMax performance. Conversion tracking is straightforward (purchase = known value), making value-based bidding viable earlier than in other verticals.

**Lead Gen** accounts face the quality-vs-volume tension. A form fill is not a sale — you need to track downstream lead quality. Without offline conversion imports, Smart Bidding optimizes for the cheapest leads (often the lowest quality). Common verticals: legal, home services, insurance, healthcare, education. Call tracking is frequently the most valuable conversion action.

**B2B SaaS** accounts have long sales cycles (30-180 days) and low conversion volumes. The funnel is multi-step: lead, MQL, SQL, opportunity, closed-won. Google Ads sees only the top of this funnel unless you import offline conversions. Low volume makes Smart Bidding unreliable for months. High deal values (EUR 5K-100K+ ACV) mean each conversion matters enormously.

**Local Services** accounts are geographically constrained. The service radius limits your addressable audience. Conversions are calls and bookings — phone call tracking is essential. Google Business Profile integration drives local pack visibility. Budget constraints are common because the business serves a fixed area.

### Account Maturity

Maturity determines which bidding strategies, campaign types, and optimization tactics are available. You cannot shortcut this — Google's algorithms need data.

| Stage | Timeline | Conversions/month | Viable bidding | Viable campaign types |
|-------|----------|-------------------|---------------|-----------------------|
| **Cold start** | 0-3 months | 0-15 | Manual CPC, Maximize Clicks | Search (exact/phrase) |
| **Early data** | 3-6 months | 15-30 | Maximize Conversions (test) | Search + Shopping (if feed) |
| **Established** | 6-18 months | 30-50+ | tCPA, tROAS | Search + PMax + DSA |
| **Mature** | 18+ months | 50+ reliably | Value-based bidding, portfolio | Full mix: Search + PMax + Demand Gen + Display |

%%fact-check: Smart Bidding minimum conversion thresholds — Google recommends 15+ conv/30 days for Maximize Conversions, 30+ for tCPA, 50+ for tROAS — verified 2026-04-03%%

**Cold start (0-3 months).** No conversion data. Manual CPC or Maximize Clicks. You are learning what converts, what the CPCs look like, and what the competitive landscape is. Key rule: do NOT over-invest in automation yet. PMax without conversion data will burn budget with no learning signal. Stick to Search with exact and phrase match. Gather at least 15 conversions before considering Smart Bidding.

**Early data (3-6 months).** Some conversions trickling in (15-30/month). You can test Maximize Conversions on your best-performing campaign. Expand the keyword universe cautiously. If you have a product feed, start Shopping or feed-only PMax. Key rule: resist the urge to add PMax too early for non-ecommerce accounts — it needs conversion data to work.

**Established (6-18 months).** Reliable conversion data. Smart Bidding (tCPA, tROAS) is viable and should be the default. Focus shifts from "getting conversions" to "getting better conversions" — Quality Score optimization, negative keyword mining, ad copy testing, landing page experiments. PMax works well here with 30+ monthly conversions.

**Mature (18+ months).** Rich historical data across campaigns. Value-based bidding becomes viable (assign different values to different conversion actions). Portfolio bid strategies can balance across campaigns. PMax has enough signal for full multi-channel reach. The optimization focus shifts from growth to efficiency and incremental reach.

### Budget Tier

Budget determines how many campaigns you can run, how much testing is feasible, and which campaign types are viable.

| Tier | Monthly spend | Max campaigns | Testing capacity | PMax viable? |
|------|--------------|---------------|-----------------|-------------|
| **Micro** | < EUR 1K | 1 | None | No |
| **Small** | EUR 1-5K | 2-3 | Basic A/B | Marginal |
| **Medium** | EUR 5-25K | 4-6 | Proper testing | Yes |
| **Large** | EUR 25K+ | 6+ | Aggressive testing | Yes, multiple |

**Micro (< EUR 1K/mo).** Laser focus. One campaign, 1-2 ad groups, exact and phrase match only. No room for experiments. Every euro counts. PMax is not viable — it needs ~EUR 50/day minimum to learn effectively. Brand campaigns may not be worth separating. The entire account is essentially one ad group doing one thing well.

%%fact-check: PMax minimum budget — Google recommends at least EUR 50/day but will run on less; practical minimum for learning is ~EUR 30-50/day — verified 2026-04-03%%

**Small (EUR 1-5K/mo).** Room for 2-3 campaigns. You can separate brand from non-brand Search. Basic A/B testing on ad copy is feasible. PMax is marginal — at EUR 3K/mo you could allocate ~EUR 50/day to PMax but it leaves little for Search. Better to master Search first, then graduate PMax when the budget grows.

**Medium (EUR 5-25K/mo).** Full campaign mix becomes viable. Dedicated PMax with adequate budget. Multiple ad groups per campaign with proper theme separation. You can run meaningful tests: ad copy, landing pages, audience segments. This is where the standard best-practice playbook applies.

**Large (EUR 25K+/mo).** Multiple campaign types running simultaneously. Aggressive testing on copy, landing pages, audiences, and bid strategies. Custom scripts for automation (bulk negatives, performance alerts, budget pacing). Full attribution pipeline from click to close. Agency-level reporting with dashboards and automated alerts.

---

## Strategy Archetypes

The 3 Tier 1 axes produce 64 theoretical combinations (4 verticals x 4 maturities x 4 budgets). In practice, many combinations collapse into similar playbooks. Below are the **15 most common archetypes** with actionable recommendations.

> [!tip] Reading This Table
> Find your vertical, then scan for the maturity + budget combination that fits. The archetype tells you what to run, how to bid, and when to graduate to the next level.

### E-commerce Archetypes

| # | Archetype | Campaign types | Bidding | Key actions | Graduate when |
|---|-----------|---------------|---------|-------------|--------------|
| 1 | **E-com Cold Start Micro/Small** | Standard Shopping, Search brand | Manual CPC | Optimize feed titles/images. Exact match on brand terms. Set manual bids conservatively. Monitor search terms daily. | 15+ purchases/month, stable CPCs |
| 2 | **E-com Early Data Small/Medium** | Shopping + Search brand + Search non-brand | Maximize Conversions (test on 1 campaign) | Expand Shopping with feed segmentation. Add non-brand Search with phrase match. Test Smart Bidding on highest-volume campaign. | 30+ purchases/month across campaigns |
| 3 | **E-com Established Medium** | Feed-only PMax + Search brand + Search non-brand | tROAS on PMax, tCPA on Search | See [[feed-only-pmax]] for setup. Segment PMax by product margin. Mine negatives aggressively on Search. Test ad copy variations. | 50+ purchases/month, stable ROAS for 3+ months |
| 4 | **E-com Mature Large** | Full PMax + Search brand + Search non-brand + Demand Gen | tROAS (portfolio across campaigns) | Value-based bidding with profit margins. Demand Gen for top-of-funnel. Custom scripts for feed monitoring and bid alerts. Full BQ pipeline. | N/A — optimize and scale |

> [!info] Feed-Only vs Full PMax
> For e-commerce, feed-only PMax is the default starting point. 90% of PMax spend goes to feed-based surfaces anyway. Only add creative assets (images, video) when you specifically need YouTube or Display presence. See [[feed-only-pmax]] for the full breakdown.

### Lead Gen Archetypes

| # | Archetype | Campaign types | Bidding | Key actions | Graduate when |
|---|-----------|---------------|---------|-------------|--------------|
| 5 | **Lead Gen Cold Start Micro/Small** | Search only | Manual CPC | Phrase + exact match. Call extensions on every ad. Track form fills AND calls as conversions. Tight geographic targeting if local. | 15+ leads/month, understood which keywords produce quality leads |
| 6 | **Lead Gen Early Data Small** | Search + call extensions | tCPA (test) | Set tCPA at current average, do not lower yet. Expand phrase match cautiously. Start negative keyword list from search term reports. | 30+ leads/month, tCPA performing within 20% of target |
| 7 | **Lead Gen Established Medium** | Search + DSA + non-feed PMax | tCPA | DSA to discover new queries. Non-feed PMax with audience signals. Offline conversion imports if tracking quality to close. Regular search term mining. | Offline conversion pipeline built, 50+ leads/month |
| 8 | **Lead Gen Mature Large** | Search + PMax + Demand Gen + Display remarketing | tCPA with offline values | Value-based bidding using offline close data. Display remarketing for nurture. Demand Gen for awareness. Full attribution from click to close. | N/A — optimize lead quality, not just volume |

> [!warning] Lead Quality Trap
> Without offline conversion imports, Smart Bidding will optimize for the cheapest leads — which are often the lowest quality. The single most impactful upgrade for a lead gen account is importing offline conversion data (lead → closed-won) back into Google Ads. See [[conversion-actions]] for the import pipeline.

### B2B SaaS Archetypes

| # | Archetype | Campaign types | Bidding | Key actions | Graduate when |
|---|-----------|---------------|---------|-------------|--------------|
| 9 | **B2B SaaS Cold Start (any budget)** | Search only | Maximize Clicks (capped) | Exact match on high-intent terms (demo, pricing, free trial). Set a max CPC cap. Volume will be low — that is normal. Do not panic and go broad. | 10+ demo requests/month, identified 3-5 converting keyword themes |
| 10 | **B2B SaaS Early Data + Offline** | Search | tCPA on leads, offline import pipeline | Build the offline conversion import pipeline (CRM → Google Ads). See [[conversion-actions]]. Import MQL/SQL stages. This unlocks everything downstream. | Pipeline importing reliably, 30+ leads/month |
| 11 | **B2B SaaS Established + Multi-Step** | Search + LinkedIn complement | Value-based bidding (on imported stages) | Assign ascending values: lead = 1, MQL = 5, SQL = 25, close = 100. Google optimizes for higher-value actions. LinkedIn for ABM targeting (outside Google Ads). | Value-based bidding stable, LTV data available |
| 12 | **B2B SaaS Mature + Full Attribution** | Search + Demand Gen + PMax | Predicted LTV bidding | Full attribution pipeline via sGTM + BigQuery. Predicted LTV from closed deals feeds back into bidding. Demand Gen for retargeting decision-makers. PMax for incremental reach. | N/A — continuously refine LTV models |

> [!info] B2B SaaS and the Tracking Bridge
> B2B SaaS accounts benefit most from Jerry's tracking infrastructure expertise. The sGTM → BigQuery → offline import pipeline is the single biggest competitive advantage you can build for a B2B client. Without it, Google Ads is flying blind on a 90-day sales cycle. See `reference/tracking-bridge/` for the full pipeline documentation.

### Local Services Archetypes

| # | Archetype | Campaign types | Bidding | Key actions | Graduate when |
|---|-----------|---------------|---------|-------------|--------------|
| 13 | **Local Micro Budget** | Search + call extensions + location assets | Manual CPC | Tight radius targeting (5-25km). Call-only ads or call extensions on every ad. Location assets linked to Google Business Profile. Exact/phrase match on "[service] + [city]" terms. | 15+ calls/bookings per month |
| 14 | **Local Small Established** | Search + Local Services Ads | tCPA | Local Services Ads (LSAs) for top-of-SERP placement. tCPA on Search. Expand radius cautiously. Track call duration (30+ seconds = likely conversion). | Budget allows broader geographic reach |
| 15 | **Local Medium Budget** | Search + local PMax | tCPA | Local PMax with store goals. Broader radius or multi-location targeting. Seasonal bid adjustments. Review-based reputation strategy tied to GBP. | N/A — optimize by location, season, service type |

%%fact-check: Local Services Ads availability — LSAs available in US, Canada, UK, select EU countries, expanding. Not all service categories eligible. — verified 2026-04-03%%

### Archetype Quick-Reference Matrix

For fast lookup, find your vertical (row) and maturity + budget (column):

| | Cold Start Micro/Small | Early Data Small/Med | Established Medium | Mature Large |
|---|---|---|---|---|
| **E-commerce** | #1 Standard Shopping + brand Search | #2 Shopping + non-brand Search | #3 Feed-only PMax + Search | #4 Full PMax + Search + Demand Gen |
| **Lead Gen** | #5 Search only, manual CPC | #6 Search + calls, test tCPA | #7 Search + DSA + non-feed PMax | #8 Full mix + offline values |
| **B2B SaaS** | #9 Search exact, Maximize Clicks | #10 Search + offline import pipeline | #11 Search + value-based bidding | #12 Search + Demand Gen + LTV bidding |
| **Local Services** | #13 Search + calls + location, manual | #14 Search + LSAs, tCPA | #15 Search + local PMax | (rare — most stay at #15) |

---

## Tier 2 — Strategic Modifiers

Each modifier independently adjusts specific recommendations within the selected archetype. An account has one value per modifier.

### Tracking Maturity

This is where Jerry's tracking expertise translates directly into campaign advantage.

| Level | Stack | Unlocks | Limitations |
|-------|-------|---------|-------------|
| **Basic** | GA4 only | Maximize Clicks / Maximize Conversions, last-click attribution | No offline data, no enhanced matching, limited Smart Bidding signal |
| **Intermediate** | GTM + enhanced conversions | Smart Bidding viable, data-driven attribution, better conversion matching via hashed PII | No offline pipeline, no profit-level data |
| **Advanced** | sGTM + BigQuery + offline imports | Value-based bidding, profit-based bidding, full attribution pipeline, predicted LTV, cross-device matching | Requires maintenance; pipeline can break silently |

> [!tip] Tracking Maturity Is Your Competitive Advantage
> Most agencies operate at Basic or Intermediate. Moving a client to Advanced tracking maturity (sGTM + BQ + offline imports) is the single highest-leverage consulting service Jerry can offer. It unlocks bidding strategies that competitors literally cannot access.

**Impact on archetype recommendations:**
- Basic tracking → cap Smart Bidding at Maximize Conversions; avoid value-based strategies
- Intermediate → tCPA and tROAS are viable; data-driven attribution improves signal quality
- Advanced → value-based bidding, profit-based optimization, predicted LTV feeding back into campaigns

### Conversion Complexity

| Complexity | Examples | Tracking requirement | Attribution impact |
|-----------|---------|---------------------|-------------------|
| **Single-step** | Purchase, form fill, call | Standard conversion tracking | Straightforward — one action = one conversion |
| **Multi-step** | Lead → MQL → SQL → close | Offline conversion imports required | Need micro-conversions as proxy; longer attribution windows (90+ days for B2B) |

**Impact on archetype recommendations:**
- Single-step → Standard conversion setup; Smart Bidding works out of the box once volume thresholds are met
- Multi-step → Must build the offline import pipeline before Smart Bidding can optimize for what actually matters. Use micro-conversions (e.g., form fill) as interim proxy while building the pipeline. Assign ascending values to each stage so Google learns which leads are worth more.

### Geographic Scope

| Scope | Targeting approach | Budget implication | Campaign structure |
|-------|-------------------|-------------------|-------------------|
| **Local** (single city / radius) | Radius targeting, location assets, call tracking | Lower budgets viable (smaller audience) | Single campaign, tight geo |
| **National** (single country) | Standard geo targeting, language settings | Standard budgets | Separate brand/non-brand, regional bid adjustments |
| **Multi-country** | Separate campaigns per country/language | Higher budgets needed (multiplied per market) | One campaign per country-language pair, different CPC expectations per market, currency considerations |

**Impact on archetype recommendations:**
- Local → radius bidding adjustments, location extensions critical, call tracking essential
- National → regional bid adjustments based on performance data, consider separating top-performing regions
- Multi-country → never mix countries in one campaign (CPCs, competition, and user intent differ). Create separate campaigns per country. Budget allocation by market potential, not equal split.

### Competition Level

| Level | Indicator | Keyword strategy | Budget implication |
|-------|-----------|-----------------|-------------------|
| **Niche** (low CPCs, few competitors) | Search CPCs under EUR 1, few ads on SERPs | Can afford broad match earlier, less negative keyword work | Lower budgets viable |
| **Moderate** | CPCs EUR 1-5, 3-4 competitors visible | Standard approach: phrase + exact, regular negative mining | Standard budgets |
| **Saturated** (high CPCs, many competitors) | CPCs EUR 5+, 5+ ads on every SERP, competitors bidding on your brand | Exact/phrase match critical, strong negatives, Quality Score is king | Higher budgets for same impression share; differentiation in ad copy essential |

**Impact on archetype recommendations:**
- Niche → can be more aggressive with match types and audience expansion; lower budgets go further
- Moderate → follow the archetype playbook as written
- Saturated → tighten match types, invest heavily in Quality Score (landing page experience, ad relevance), consider brand bidding defense campaigns, differentiate on ad copy (not just keywords)

---

## Tier 3 — Operational Context

Shapes workflow, reporting, and access patterns. Does not change strategy — changes how strategy is executed.

### Management Model

| Model | Reporting cadence | Access pattern | Change velocity |
|-------|------------------|---------------|----------------|
| **In-house** | Weekly | Direct access, fast changes | High — can react to data daily |
| **Agency** | Monthly (sometimes bi-weekly) | Shared access, approval workflows | Medium — changes require client sign-off |
| **Freelancer** | Flexible (weekly to monthly) | Single point of contact, often multi-account | Variable — depends on client engagement |

### Feed Presence

| Feed | Available campaign types | Implication |
|------|------------------------|-------------|
| **Yes** (Merchant Center linked) | Shopping, feed-only PMax, full PMax | Feed optimization is a primary lever. See [[feed-optimization]]. |
| **No** | Search, Display, Demand Gen, non-feed PMax, Video | Cannot use Shopping or feed-based PMax. Creative assets required for PMax. |

### Business Model

| Model | Core metric | Bidding implication | Key consideration |
|-------|------------|--------------------|--------------------|
| **One-time purchase** | ROAS (order value) | Conversion value = order value | Straightforward value-based bidding |
| **Subscription** | LTV (lifetime value) | First-purchase ROAS may be negative | Need retention data to calculate true ROAS; import LTV predictions for bidding |
| **Recurring service** | LTV + rebooking rate | Lifetime value calculation | Seasonal patterns matter; rebooking/retention rate defines true customer value |

---

## How to Use This Framework

When approaching any Google Ads account — new client, audit, or strategic review — follow these steps:

### Step 1: Establish Tier 1 Profile

Answer three questions:
1. **Vertical?** E-commerce / Lead Gen / B2B SaaS / Local Services
2. **Maturity?** Cold start / Early data / Established / Mature
3. **Budget?** Micro / Small / Medium / Large

This gives you an archetype number (#1-#15) from the matrix above.

### Step 2: Check Tier 2 Modifiers

For each modifier, note the current state:
- **Tracking maturity:** Basic / Intermediate / Advanced
- **Conversion complexity:** Single-step / Multi-step
- **Geographic scope:** Local / National / Multi-country
- **Competition level:** Niche / Moderate / Saturated

Adjust the archetype recommendations based on each modifier's impact (documented above).

### Step 3: Note Tier 3 Context

Record operational context:
- **Management model:** In-house / Agency / Freelancer
- **Feed presence:** Yes / No
- **Business model:** One-time purchase / Subscription / Recurring service

This shapes reporting templates, access workflows, and value calculations.

### Step 4: Apply to Downstream Decisions

With the full profile established, use it to guide every recommendation:

| Decision area | Reference |
|--------------|-----------|
| Maturity-stage transitions and timelines | [[account-maturity-roadmap]] |
| Vertical-specific deep-dives | [[vertical-ecommerce]], [[vertical-lead-gen]], [[vertical-b2b-saas]], [[vertical-local-services]] |
| Audience and targeting strategy | [[targeting-framework]] |
| Attribution model selection | [[attribution-guide]] |
| Campaign type selection | [[campaign-types]] |
| Bidding strategy selection | [[bidding-strategies]] |
| Conversion tracking setup | [[conversion-actions]], [[enhanced-conversions]] |
| PMax configuration | [[feed-only-pmax]], [[audience-signals]] |

> [!example] Profile in Practice
> **Client:** Dutch e-commerce store, 200 products, EUR 8K/month budget, running 6 months, GTM + enhanced conversions, Merchant Center feed linked, one-time purchases, national (NL), moderate competition.
>
> **Profile:** E-commerce / Established / Medium = **Archetype #3**
> **Modifiers:** Intermediate tracking, single-step conversion, national scope, moderate competition
>
> **Recommendation:** Feed-only PMax (tROAS) + Search brand (tCPA) + Search non-brand (tCPA). Next step: upgrade to sGTM + BQ for profit-based bidding (Advanced tracking). Mine negatives weekly on Search. Test ad copy variations monthly.

---

## Further Reading

- [About automated bidding - Google Ads Help](https://support.google.com/google-ads/answer/2979071) — Google's official Smart Bidding documentation and minimum thresholds
- [Google Skillshop: Google Ads Certifications](https://skillshop.withgoogle.com/googleads) — Free training covering campaign types, bidding strategies, and measurement
- [The Ultimate Guide to Google Ads Account Structure (WordStream)](https://www.wordstream.com/blog/ws/2023/01/04/google-ads-account-structure) — Account structure best practices with budget-tier considerations
- [Google Ads Benchmarks for Your Industry (WordStream)](https://www.wordstream.com/blog/ws/2016/02/29/google-adwords-industry-benchmarks) — Industry-level CVR, CPC, and CPA benchmarks by vertical
- [Smart Bidding: When to Use What (Search Engine Journal)](https://www.searchenginejournal.com/google-ads-smart-bidding-strategies/388951/) — Practical guide to choosing between tCPA, tROAS, and Maximize strategies
- [Performance Max Best Practices (Google Ads Help)](https://support.google.com/google-ads/answer/11576060) — Official PMax setup guidance including budget and conversion minimums
- [Offline Conversion Tracking Guide (Google Ads Help)](https://support.google.com/google-ads/answer/2998031) — Setting up offline conversion imports for lead gen and B2B
- [Optmyzr Blog: Google Ads Strategy](https://www.optmyzr.com/blog/) — Advanced optimization tactics from former Google Ads evangelists
