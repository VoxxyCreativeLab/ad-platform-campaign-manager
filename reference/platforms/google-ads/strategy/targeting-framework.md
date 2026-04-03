---
title: Google Ads Targeting Framework
date: 2026-04-03
tags: [reference, strategy, targeting, audiences, remarketing]
---

# Google Ads Targeting Framework

%%
Audience strategy reference for a tracking specialist managing Google Ads accounts.
Covers audience types, remarketing segmentation, vertical strategies, PMax signals,
layered targeting, and frequency capping.
%%

> [!info] Scope
> This document covers audience targeting in Google Ads Search, Display, Video, and Performance Max. It is written for a tracking specialist who understands data infrastructure (GTM, sGTM, BigQuery) but is building campaign strategy knowledge from the ground up.

---

## 1. Audience Types in Google Ads

Google Ads organises audiences into several distinct types. The table below maps each type to its mechanism, best placement, and minimum list requirements where applicable.

%%fact-check: Audience type availability and minimum sizes — verified 2026-04-03%%

| Audience Type | What It Is | Best Placements | Minimum Size |
|---|---|---|---|
| **Customer Match** | Upload hashed email, phone, or address lists. Google matches to signed-in users. | Search, Display, YouTube, Shopping, PMax | 1,000 matched users for Search; 100 for Display/Video |
| **In-Market** | Users Google classifies as actively researching or buying in a category. Google-defined segments only. | Search, Display, YouTube, Shopping | No minimum — segment-based |
| **Affinity** | Users with long-term, habitual interest in a category. Google-defined or custom. | Display, YouTube | No minimum — segment-based |
| **Custom Segments** | You define the segment by: keywords people search, URLs people visit, or apps people use. | Display, YouTube, Discovery/Demand Gen | No minimum — segment-based |
| **Your Data (Remarketing)** | First-party: site visitors, app users, YouTube viewers, customer lists. Most granular control. | All placements | 1,000 active users (Search); 100 (Display/Video) |
| **Combined Segments** | AND/OR logic across any combination of the above types. Narrows or broadens reach deliberately. | Display, Video, Discovery | Depends on component lists |
| **Similar Segments** | ~~Lookalike audiences based on your data lists~~ — **deprecated March 2026** | N/A | N/A — removed |
| **Demographics** | Age, gender, household income, parental status. Applied as observation or targeting layer. | All placements | No minimum — applies to all traffic |

%%fact-check: Similar/lookalike audience deprecation — Google deprecated Similar Segments in May 2023 for most campaign types and fully removed support in early 2024; "audience suggestions" replaced the feature — verified 2026-04-03%%

> [!warning] Similar Segments Removed
> Google deprecated Similar Segments (lookalike audiences) in 2023–2024. The replacement is **Audience Suggestions**, which Google generates automatically based on your seed lists. You no longer manually create lookalike audiences — Google's AI handles expansion. In PMax this happens via audience signals + optimised targeting.

> [!tip] Tracking Specialist Angle
> Customer Match is where your GTM/sGTM infrastructure has direct leverage. If you're firing a `purchase` event to sGTM and writing to BigQuery, you can automate Customer Match uploads via the Google Ads API using the hashed email field. The `[[../../tracking-bridge/bq-to-gads]]` pipeline enables this without manual CSV exports.

---

## 2. Remarketing Segmentation Framework

Raw remarketing — "everyone who visited the site" — underperforms because it treats a 2-second bounce the same as a cart abandoner. Segment by recency, behaviour, value, and engagement depth to unlock meaningful bid differentiation and creative tailoring.

### 2.1 Segmentation Dimensions

**Recency** — how recently the user visited. Recent visitors convert at higher rates; bid accordingly.

| Window | Signal Strength | Typical Bid Modifier |
|---|---|---|
| 0–7 days | Highest intent | +40–60% |
| 8–14 days | High intent | +20–40% |
| 15–30 days | Moderate intent | +10–20% |
| 31–90 days | Lower intent | 0–+10% |
| 90+ days | Prospecting territory | 0% or exclude |

**Behaviour** — what the user did during the visit. More intent-rich actions = higher bids.

| Behaviour Segment | Definition (GTM event trigger) | Intent Level |
|---|---|---|
| Homepage only | `page_view` on `/` only | Low |
| Category/listing page | `page_view` on `/category/*` | Low–Medium |
| Product page | `page_view` on `/product/*` | Medium–High |
| Add to cart | `add_to_cart` event | High |
| Checkout started | `begin_checkout` event | Very High |
| Purchasers | `purchase` event | Exclude or upsell |

**Value** — segment purchasers by their spend level to differentiate retention messaging.

- First-time purchasers: nurture toward second purchase
- Repeat purchasers: loyalty / higher-AOV offers
- High-AOV purchasers (top 20%): premium retention, similar segments seed

**Engagement Depth** — quality of session, not just the page visited.

| Depth Tier | Signal | GA4 Event / GTM Trigger |
|---|---|---|
| Bounce | Single page, <10 seconds | Exclude or suppress |
| Light | 2+ pages viewed | `page_view` count ≥ 2 |
| Engaged | 5+ minutes on site | `user_engagement` threshold |
| Deep | Scrolled 75%+ on product page | Custom scroll trigger |

%%
GTM implementation note: build these as Google Ads Remarketing audiences in GTM using
the Google Ads Remarketing tag with dynamic membership duration rules, or use GA4
Audiences exported to Google Ads via the GA4 ↔ Google Ads account link.
%%

### 2.2 Remarketing Audience Matrix

| Segment | Bid Modifier | Creative Approach | List Type |
|---|---|---|---|
| 0–7 day cart abandoners | +50–60% | Product-specific, urgency ("still available") | RLSA + Display |
| 0–7 day product viewers | +30–40% | Same product category, social proof | RLSA + Display |
| 0–7 day homepage only | +10% | Brand awareness, category intro | Display only |
| 8–30 day product viewers | +15–25% | Broader category, offers | Display |
| 30–90 day visitors | +0–10% | Re-engagement, new arrivals | Display |
| Past purchasers (repeat targets) | +20–30% (or separate campaign) | Cross-sell, loyalty, new range | Customer Match |
| High-AOV purchasers | Separate campaign | Premium products, VIP framing | Customer Match |
| Bounces / <10s | Exclude | — | Exclusion list |

---

## 3. Audience Strategy by Vertical

Different verticals have different funnel shapes, sales cycles, and data availability. This table maps the most effective audience approaches per vertical.

| Vertical | Primary Audience Types | Remarketing Approach | Seed List Strategy |
|---|---|---|---|
| **E-commerce** | Customer Match (purchasers), In-Market (product categories), Dynamic Remarketing | Segment by product viewed, cart vs browse, short windows (7–30 days) | Export purchaser emails from CRM/BigQuery monthly; seed Customer Match with top 20% AOV buyers |
| **Lead Generation** | Customer Match (closed leads as exclusions), Custom Segments (competitor URLs, industry keywords), Remarketing (form interactions) | Segment by form page visited vs form submitted vs converted lead; exclude converted | Upload closed leads as exclusion list to avoid re-targeting converted customers; use open leads as lookalike seed |
| **B2B SaaS** | Custom Segments (job title keywords, industry terms), Remarketing (long windows: 90–180 days), Customer Match (trial users, churned accounts) | Long windows — B2B buying cycles are 30–180 days; keep users in remarketing pools for up to 180 days | Import CRM contact lists (MQL/SQL stage) as Customer Match for bid boosting; churned accounts for win-back |
| **Local Services** | Location targeting + In-Market (relevant service categories), Remarketing (7–14 days max) | Short windows — local intent is perishable (plumber, locksmith); suppress after 14 days | Small markets — lists may fall below minimums; use observation-only if list <1,000 matched users |

> [!note] B2B and List Sizes
> B2B Customer Match lists are almost always small. A CRM with 500 contacts will typically match 150–300 Google accounts — below the Search minimum of 1,000. Use these lists in observation mode for bid adjustment signals rather than as hard targeting. Export larger lists by going up-funnel (all contacts, not just MQLs).

---

## 4. Audience Signals for PMax

Performance Max treats audiences differently from Search or Display. Signals are **probabilistic hints** to the algorithm, not hard targeting constraints. This is a fundamental shift from traditional audience targeting.

%%fact-check: PMax audience signals as hints not constraints — verified 2026-04-03%%

### 4.1 How Signals Work

- Google uses your signals to **seed** the smart bidding model's initial learning
- After learning, the algorithm expands beyond your signals to find converting users
- You cannot see who outside your signals is being targeted
- Providing no signals forces Google to start cold — slower learning, less efficient early performance

### 4.2 Signal Setup Best Practices

| Best Practice | Rationale |
|---|---|
| One signal group per asset group | Keeps signal intent matched to the creative and product segment |
| Customer Match as primary signal | Your purchaser list is the highest-quality signal — tells Google who actually converts |
| Layer in-market + custom segments | Adds intent context; Customer Match alone may be too narrow for the seed |
| Do NOT add signals from unrelated categories | Dilutes the signal — Google has enough breadth data; your value is specificity |
| Seed list minimum: 1,000 matched; ideal: 5,000+ | Below 1,000 matched users, the signal has limited statistical value for PMax learning |

### 4.3 Search Themes

PMax can access Search inventory. Search themes guide what queries the PMax campaign targets on Search.

- Up to **50 search themes per asset group**
%%fact-check: PMax 50 search themes per asset group limit — verified 2026-04-03%%
- Use themes that match the asset group's product/service focus
- Search themes complement (do not replace) your existing Search campaigns
- If you have a Standard Shopping or Search campaign covering the same queries, PMax will typically win the auction for your own account — manage this with campaign priority or budget allocation

> [!warning] PMax and Search Campaign Conflict
> PMax campaigns do NOT respect negative keywords the same way Search campaigns do (as of early 2026, shared negative keyword lists apply to PMax, but individual campaign negatives work differently). Review the `[[../../pmax/pmax-negatives]]` reference before launching PMax alongside Search campaigns.

---

## 5. Layered Targeting Strategy

Single-dimension targeting — audience only, or keyword only — leaves performance on the table. Layering combines signals to find high-probability converting users.

### 5.1 Observation vs Targeting Mode

| Mode | Effect | When to Use |
|---|---|---|
| **Observation** | Audience added for monitoring and bid adjustment. Does NOT restrict reach. | Default for most audiences. Gather data first. |
| **Targeting** | Restricts delivery to ONLY users in that audience. Significantly narrows reach. | Only when you are certain the audience is both large enough and right for the campaign goal |

> [!tip] Start with Observation
> Add all relevant audiences in observation mode first. Run for 2–4 weeks. Review the "Audiences" report to see conversion rate by audience segment. Then apply bid modifiers, or promote high-converting segments to targeting mode if your reach data supports it.

### 5.2 Three-Axis Layering

The most effective layered strategy combines **audience × device × time-of-day** adjustments:

| Dimension | Example Adjustment | Rationale |
|---|---|---|
| Audience | +40% for 7-day cart abandoners | Highest purchase intent |
| Device | +20% for mobile in local campaigns | Local searches heavily mobile |
| Time of day | −30% between 00:00–06:00 | Low conversion hours, save budget |
| Combination | 7-day cart abandoner + mobile + 12:00–18:00 | Peak intent + device + time overlap |

> [!note] Adjustment Stacking
> Google applies bid adjustments multiplicatively, not additively. A +40% audience modifier on a base bid of €1.00, with a +20% device modifier, yields €1.00 × 1.40 × 1.20 = €1.68. Plan combined adjustments carefully — stacked modifiers can push bids to unintended levels.

### 5.3 Demographic Layering

Demographics (age, gender, household income) layer over all campaign types via observation or targeting.

- **Household income** data is US-centric and unreliable in NL/EU — treat as indicative only
- **Age** targeting is useful for products with strong demographic skew (e.g., retirement planning, student services)
- **Parental status** is useful for children's products and family services
- Default: leave all demographics in observation mode; adjust only with 4+ weeks of data

---

## 6. Frequency Capping

Showing the same ad too many times to the same user wastes budget, damages brand perception, and signals poor audience health to Google's algorithm.

%%fact-check: Frequency capping availability by campaign type — verified 2026-04-03%%

### 6.1 Recommended Caps by Objective

| Campaign Type | Objective | Recommended Cap |
|---|---|---|
| Display — Awareness | Brand reach | 3–5 impressions / user / day |
| Display — Remarketing | Conversion | 5–7 impressions / user / day |
| Video (YouTube) — Awareness | View frequency | 3 impressions / user / week |
| Video — Remarketing | Conversion | 5 impressions / user / week |
| Demand Gen | Mixed | 3–5 per week — monitor in reports |

> [!info] Smart Campaigns and PMax
> Frequency capping is not directly available in Smart campaigns or Performance Max. Google manages frequency algorithmically. If you are seeing signs of fatigue in PMax (declining CTR, rising CPCs), check audience list recency and rotate creative assets.

### 6.2 Remarketing Fatigue: Signs and Mitigation

Remarketing fatigue occurs when the same pool of users is over-served ads without converting.

**Signs:**
- CTR declining week-over-week (>20% drop) while impressions hold steady
- Conversion rate falling despite stable CPC
- Rising frequency per user in placement reports
- Negative comments or "Why am I seeing this?" reports

**Mitigation:**
- Reduce daily frequency cap
- Shorten remarketing window (e.g., drop from 30 days to 14 days)
- Rotate creative assets — minimum 2–3 ad variants per ad group
- Add purchasers and recent converters to exclusion lists to prevent re-showing to non-targets
- Apply a "sequential" logic: show Brand → Product → Offer in stages rather than the same ad repeatedly

---

## Further Reading

- [Google Ads Audience Targeting — Official Help](https://support.google.com/google-ads/answer/2497941)
- [Customer Match Policy and Requirements](https://support.google.com/google-ads/answer/6379332)
- [Performance Max Audience Signals — Google Help](https://support.google.com/google-ads/answer/11396093)
- [About observation and targeting — Google Ads Help](https://support.google.com/google-ads/answer/7653410)
- [Remarketing Lists for Search Ads (RLSA) — Google Help](https://support.google.com/google-ads/answer/2701222)

---

%%
Related references:
- [[../account-profiles]] — vertical-specific account configuration notes
- [[../../tracking-bridge/bq-to-gads]] — automating Customer Match uploads from BigQuery
- [[../conversion-actions]] — conversion action setup that feeds remarketing list membership
- [[../pmax/feed-only-pmax]] — PMax audience signals in feed-only configuration
%%
