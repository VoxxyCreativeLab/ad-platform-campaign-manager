# Google Ads Account Structure

## Hierarchy

```
Google Ads Account (MCC or standalone)
└── Campaign (budget, bid strategy, targeting settings, campaign type)
    └── Ad Group (keyword theme, audience segment)
        ├── Keywords (search terms to trigger ads)
        ├── Ads (RSAs, responsive display ads, video ads)
        └── Extensions/Assets (sitelinks, callouts, structured snippets)
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
