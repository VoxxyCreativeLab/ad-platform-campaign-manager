---
title: Google Ads Account Structure
date: 2026-04-01
tags:
  - reference
  - google-ads
---

# Google Ads Account Structure

## Hierarchy

```
Google Ads Account (MCC or standalone)
└── Campaign (budget, bid strategy, targeting settings, campaign type)
    └── Ad Group (keyword theme, audience segment)
        ├── Keywords (search terms to trigger ads)
        ├── Ads (RSAs, responsive display ads, video ads)
        └── Assets (sitelinks, callouts, structured snippets)
```

## Naming Conventions

### Campaign Naming
```
[Type] | [Goal] | [Targeting] | [Region]
```
Examples:
- `Search | Leads | Brand | NL`
- `Search | Sales | Non-Brand | NL`
- `PMax | Sales | Shopping | EU`
- `Display | Remarketing | All Visitors | NL`

### Ad Group Naming
```
[Theme/Category] | [Match Type or Audience]
```
Examples:
- `Running Shoes | Broad`
- `Past Purchasers | 30 Days`

## Structure Patterns

### Search — Single Product/Service
```
Campaign: Search | Leads | Non-Brand | NL
├── Ad Group: [Core Service] | Broad
│   ├── Keywords: broad match keywords
│   └── RSA: 15 headlines, 4 descriptions
├── Ad Group: [Core Service] | Exact
│   ├── Keywords: [exact match]
│   └── RSA: tailored to exact intent
└── Ad Group: [Competitor Terms] | Broad
```

### Search — Brand vs Non-Brand Split
```
Campaign: Search | Brand | NL
├── Ad Group: Brand Exact
├── Ad Group: Brand + Product
└── Ad Group: Brand Misspellings

Campaign: Search | Non-Brand | Generic | NL
├── Ad Group: [Generic Category 1]
└── Ad Group: [Generic Category 2]
```

### PMax Structure
```
Campaign: PMax | Sales | Shopping | NL
├── Asset Group: [Product Category A]
│   ├── Audience Signal: In-market for [category]
│   ├── Assets: text, images, videos
│   └── Listing Group: filtered to Category A
└── Asset Group: [Bestsellers]
    ├── Audience Signal: Past purchasers + lookalikes
    └── Listing Group: top products
```

### Display Remarketing
```
Campaign: Display | Remarketing | NL
├── Ad Group: All Visitors | 7-30 Days
├── Ad Group: Cart Abandoners | 1-14 Days
└── Ad Group: Past Customers | 30-90 Days
```

## Rules of Thumb

1. **One theme per ad group** — keywords should share intent so ad copy stays relevant
2. **Separate brand and non-brand** — different CPCs, conversion rates, and strategies
3. **Budget = priority** — campaigns with separate budgets can be prioritized independently
4. **Don't over-segment** — too many campaigns with small budgets limits optimization
5. **Max 7-10 ad groups per campaign** — 3-5 is ideal for small accounts
6. **Max 15-20 keywords per ad group** — fewer focused keywords is better

## Account-Level Checklist

- [ ] Conversion tracking configured
- [ ] Auto-tagging enabled (for GA4)
- [ ] IP exclusions set (your office IPs)
- [ ] Brand exclusion lists (for PMax)
- [ ] Negative keyword lists at account level
- [ ] Location targeting: "Presence" (not "Presence or interest")
- [ ] Language targeting matches audience

## PMax Negative Keywords

PMax campaigns support campaign-level negative keywords (up to 10,000 per campaign). You can also apply shared negative keyword lists across multiple PMax campaigns for consistency. This is critical for preventing PMax from cannibalizing your Search campaigns on branded terms.

## AI Max for Search

> [!info] AI Max is not a new campaign type
> AI Max is a Search campaign feature layer (opt-in per campaign). It enables broader matching, auto-generated creative variations, and expanded URL targeting within existing Search campaigns. Think of it as "PMax-like automation layered onto Search" — your campaign structure stays the same.

## Structure by Account Profile

Account structure should match maturity and budget. See [[strategy/account-profiles]] for the full framework.

### By Maturity Stage

| Stage | Campaigns | Ad Groups per Campaign | Keywords per Ad Group |
|-------|-----------|----------------------|---------------------|
| Cold start | 1 (Search) | 2-3 | 10-15 exact+phrase |
| Early data | 2-3 (Brand + Non-brand + test) | 3-5 | 10-20 |
| Established | 4-6 (Brand + Non-brand + PMax + remarketing) | 5-10 | 15-25 |
| Mature | 6-10+ (full mix) | 7-10 | 15-30 |

### By Budget Tier

| Budget | Max Campaigns | Campaign Types | Testing Capacity |
|--------|--------------|----------------|-----------------|
| Micro (<€1K/mo) | 1-2 | Search only | None — every euro counts |
| Small (€1-5K/mo) | 2-3 | Search + brand | Minimal — one ad copy test at a time |
| Medium (€5-25K/mo) | 4-6 | Search + PMax + remarketing | Moderate — ad copy + landing page tests |
| Large (€25K+/mo) | 6-10+ | Full mix | Aggressive — continuous multivariate testing |

> [!tip] Start Simple, Grow With Data
> New accounts with limited budgets should resist the urge to build complex structures. One well-optimized Search campaign outperforms five underfunded campaigns competing with each other.
