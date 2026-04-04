---
title: Bid Adjustment Framework
date: 2026-04-03
tags:
  - reference
  - google-ads
  - strategy
---

# Bid Adjustment Framework

Systematic framework for device, geographic, schedule, and audience bid adjustments in Google Ads. Maps adjustment decisions to account archetype, maturity tier, and data availability. For bid *strategy* selection (tCPA, tROAS, Manual CPC), see [[bidding-strategies]].

%%fact-check: Bid adjustment availability, stacking rules, and Smart Bidding interaction — verified against Google Ads Help 2026-04-03%%

> [!info] Smart Bidding and Bid Adjustments
> When using Smart Bidding (tCPA, tROAS, Maximize Conversions, Maximize Conversion Value), Google ignores most manual bid adjustments — the algorithm handles device, location, and time optimization automatically. The exception is **device bid adjustments of −100%** (opt-out), which Smart Bidding respects. This framework is most relevant for Manual CPC and Maximize Clicks campaigns, and for understanding what Smart Bidding optimizes on your behalf.

## When to Use Manual Bid Adjustments

```
Are you using Smart Bidding?
├── Yes (tCPA, tROAS, Max Conv, Max Conv Value)
│   ├── Want to exclude a device entirely? → Set −100% device adjustment
│   └── Everything else → Smart Bidding handles it automatically; don't set adjustments
├── No (Manual CPC, Maximize Clicks)
│   ├── Have 4+ weeks of data? → Apply adjustments based on data
│   └── < 4 weeks of data → Wait; collect baseline performance first
└── Portfolio bid strategy?
    └── Same rules as individual Smart Bidding — adjustments ignored except −100% device
```

## Adjustment Types

### Device Adjustments

Modify bids for desktop, mobile, and tablet traffic.

| Device | When to Increase | When to Decrease | Data Signal |
|---|---|---|---|
| **Mobile** | Local services, click-to-call, mobile-first audiences | Complex B2B forms, large catalogs with poor mobile UX | Compare mobile vs desktop CVR and CPA |
| **Desktop** | B2B, long research cycles, complex purchases | Mobile-dominant audience with desktop as afterthought | Desktop CVR > mobile CVR by 30%+ |
| **Tablet** | Generally follows desktop patterns | Low traffic volume — often not worth separate adjustment | Usually too little data; merge with desktop |

**Adjustment ranges:**

| Scenario | Typical Adjustment |
|---|---|
| Strong performer (CVR 50%+ above average) | +20% to +40% |
| Slightly above average | +10% to +20% |
| Average performance | 0% (no adjustment) |
| Below average (CVR 20-50% below) | −15% to −30% |
| Poor performer or excluded | −50% to −100% |

> [!warning] Don't Over-Adjust on Low Data
> A device segment with < 100 clicks has insufficient data for reliable adjustment. Wait for statistical significance. A device showing 2 conversions from 50 clicks (4% CVR) vs 5 from 200 clicks (2.5%) may just be noise — don't set a +60% adjustment based on 2 conversions.

### Geographic Adjustments

Modify bids by country, region, city, or radius targeting.

| Level | When to Use | Example |
|---|---|---|
| **Country** | Multi-country campaigns with performance variation | NL +20%, BE −10%, DE 0% based on CVR |
| **Region/Province** | Service-area businesses, regional demand differences | Noord-Holland +15% (more demand), Limburg −20% (less) |
| **City** | High-competition metro areas, local businesses | Amsterdam +25% (high intent, high competition) |
| **Radius** | Physical location targeting (stores, offices) | 5km radius +40%, 5-15km +10%, 15-30km −20% |

**How to identify geographic performance:**
1. Google Ads → Insights & Reports → Locations
2. Segment by city/region → compare CVR, CPA, ROAS
3. Apply adjustments only to locations with 50+ clicks minimum

> [!tip] Tracking Specialist Angle
> If you have sGTM + BigQuery, you can build a geographic performance dashboard that combines Google Ads click data with backend conversion data. This gives you true profit-by-geography, not just Google Ads reported conversions. Use `[[../../tracking-bridge/bq-to-gads]]` to push offline conversion values back by location.

### Schedule Adjustments (Ad Scheduling)

Modify bids by day of week and hour of day.

| Pattern | Typical Adjustment | When |
|---|---|---|
| Business hours peak (B2B) | +20% to +30% | Mon-Fri 09:00-17:00 |
| Evening peak (B2C e-commerce) | +15% to +25% | Mon-Sun 19:00-22:00 |
| Weekend boost (local services) | +10% to +20% | Sat-Sun daytime |
| Late night suppression | −30% to −50% | 00:00-06:00 |
| Complete pause | −100% | Hours with zero historical conversions and high spend |

**How to identify schedule performance:**
1. Google Ads → Insights & Reports → Time (Hour of day, Day of week)
2. Look for consistent patterns over 4+ weeks (not single-week anomalies)
3. Segment by conversion type — calls may peak at different hours than form fills

> [!note] Time Zone Awareness
> Ad scheduling uses the account time zone, not the user's time zone. For multi-country campaigns, verify which time zone the account is set to and adjust accordingly. A campaign targeting NL + UK has a 1-hour offset.

### Audience Adjustments

Modify bids for specific audience segments layered on campaigns.

| Audience Type | Typical Adjustment | Rationale |
|---|---|---|
| 7-day cart abandoners (RLSA) | +40% to +60% | Highest purchase intent |
| 14-day site visitors (RLSA) | +20% to +30% | Recent interest, warm audience |
| Customer Match — past purchasers | +20% to +40% (or separate campaign) | Known converters, high LTV potential |
| In-market segments (performing) | +10% to +20% | Google-identified active shoppers |
| In-market segments (neutral) | 0% | Monitor before adjusting |
| Demographic: top income tier | +10% to +20% | Higher AOV potential (if data supports it) |

> [!warning] Audience List Sizes
> Audience adjustments only work if the list is large enough to match. Search requires 1,000+ matched users; Display/Video requires 100+. Below these thresholds, use observation mode for data collection only. See [[strategy/targeting-framework]] for full size requirements.

## Adjustment Stacking

Google applies bid adjustments **multiplicatively**, not additively:

```
Final Bid = Base Bid × (1 + Device Adj) × (1 + Location Adj) × (1 + Schedule Adj) × (1 + Audience Adj)
```

**Example:**
- Base bid: €1.00
- Mobile: +30% → ×1.30
- Amsterdam: +20% → ×1.20
- Evening (19:00-22:00): +15% → ×1.15
- Cart abandoner RLSA: +50% → ×1.50
- **Final bid: €1.00 × 1.30 × 1.20 × 1.15 × 1.50 = €2.69**

> [!danger] Stacking Can Explode Bids
> Four moderate adjustments (+15-30% each) can push a €1.00 bid to €2.50+. Always calculate the maximum stacked bid before applying adjustments. Set a max CPC cap as a safety net when using Manual CPC.

## Framework by Account Archetype

Adjustment strategy depends on account maturity and data volume. See [[strategy/account-profiles]] for the full archetype framework.

| Account Stage | Data Available | Recommended Approach |
|---|---|---|
| **Cold start (0-3mo)** | < 100 conversions total | No adjustments — collect baseline data. All segments at 0%. |
| **Early data (3-6mo)** | 100-500 conversions | Device adjustments only (most visible signal). Geographic and schedule adjustments only if pattern is obvious (e.g., B2B with zero weekend conversions). |
| **Established (6-18mo)** | 500-2,000 conversions | Full adjustment framework — device, geo, schedule, audience. Review quarterly. |
| **Mature (18+mo)** | 2,000+ conversions | Transition to Smart Bidding — the algorithm handles adjustments better than manual at this data volume. Keep −100% device exclusions if needed. |

### Vertical-Specific Patterns

| Vertical | Key Adjustments | Why |
|---|---|---|
| **E-commerce** | Schedule: evening/weekend boost. Device: mobile +20-30% (if mobile UX is good). Audience: cart abandoners +50%. | Buying happens outside work hours; mobile shopping is dominant. |
| **Lead generation** | Schedule: business hours +25%. Device: desktop +15% (forms convert better). Geo: service-area focus. | Leads convert during work hours; desktop form completion rates are higher. |
| **B2B SaaS** | Schedule: Mon-Fri 09-17 +30%, nights −50%. Device: desktop +20%. Audience: in-market B2B segments +15%. | B2B decision-makers research during work hours, almost exclusively on desktop. |
| **Local services** | Geo: 5km radius +40%. Device: mobile +30% (click-to-call). Schedule: varies by service type. | Local intent is mobile-dominant; proximity to business is the strongest signal. |

## Review Cadence

| Review Type | Frequency | Action |
|---|---|---|
| Performance scan | Weekly | Check for dramatic shifts (>30% CVR change) |
| Full adjustment review | Monthly | Recalculate all adjustments based on last 30 days |
| Seasonal reset | Quarterly | Reset adjustments for seasonal changes (see [[strategy/seasonal-planning]]) |
| Strategy review | Annually or on bid strategy change | Reassess whether manual adjustments are needed or Smart Bidding should take over |

## Common Mistakes

| Mistake | Impact | Fix |
|---|---|---|
| Setting adjustments on day one | No data → random adjustments → budget waste | Wait 4+ weeks for baseline data |
| Adjusting on low data (< 50 clicks) | Statistical noise → wrong direction | Minimum 50 clicks per segment before adjusting |
| Forgetting stacking math | Bids explode beyond intended max | Calculate max stacked bid; set CPC cap |
| Applying adjustments with Smart Bidding | Adjustments ignored → false sense of control | Remove all adjustments except −100% device when using Smart Bidding |
| Never reviewing after initial setup | Stale adjustments → performance drift | Monthly review cadence |
| Copying adjustments across campaigns | Different campaigns have different patterns | Each campaign gets its own analysis |

## Related

- [[bidding-strategies]] — bid strategy selection (tCPA, tROAS, Manual CPC)
- [[strategy/account-profiles]] — account archetype framework
- [[strategy/account-maturity-roadmap]] — maturity stage progression
- [[strategy/targeting-framework]] — audience targeting and layering
- [[strategy/seasonal-planning]] — seasonal adjustment resets
