---
title: Dynamic Search Ads (DSA)
date: 2026-03-31
tags:
  - reference
  - google-ads
---

# Dynamic Search Ads (DSA)

Auto-generated Search ads where Google creates headlines from your website content and matches queries to relevant landing pages. Supplements keyword-based Search campaigns by capturing queries you haven't explicitly targeted.

## When to Use

- **Supplement keyword campaigns:** capture long-tail queries your keyword list misses
- **Large catalogs:** e-commerce sites or content-heavy sites with hundreds/thousands of pages
- **Keyword gap discovery:** mine DSA search terms to find new keywords for regular Search campaigns
- **Quick launches:** get Search ads running fast without extensive keyword research first
- **Not for:** single-page sites, tightly controlled messaging (headlines are auto-generated), or when you need exact headline control

### DSA vs Regular Search

| Factor | DSA | Regular Search |
|--------|-----|----------------|
| Headlines | Auto-generated from page content | Written by you (RSAs) |
| Targeting | Pages / page categories / page feeds | Keywords |
| Control | Medium — control descriptions + page targeting | High — control all ad copy + keywords |
| Long-tail coverage | Excellent — catches queries you'd never think of | Limited to your keyword list |
| Best for | Supplementing Search, large catalogs | Core campaigns, high-intent targeting |

## How It Works

### How Google Generates DSA Ads

1. Google **crawls your website** (like organic search indexing)
2. When a user searches, Google **matches the query to the most relevant page** on your site
3. Google **auto-generates a headline** from the page title / content
4. Your **descriptions** (written by you) appear below the headline
5. The **landing page** is selected automatically based on relevance

### Targeting Methods

| Method | Control Level | Use Case |
|--------|---------------|----------|
| All web pages | Lowest | Quick launch, broad coverage |
| Page categories | Medium | Google's auto-categorization of your site |
| Page feeds | Highest | Upload specific URLs with labels — full control |
| URL rules | Medium | Target pages matching URL patterns (contains, equals) |

> [!tip] Always Use Page Feeds
> Page feeds give you the most control. Upload a spreadsheet of URLs with Custom Labels (e.g., "category:shoes", "margin:high") and target by label. This prevents Google from creating ads for pages you don't want to advertise.

### Ad Group Structure

```
DSA Campaign
├── Ad Group: Products (page feed label: "products")
│   ├── Dynamic ad target: custom label = "products"
│   └── 2 descriptions (manual)
├── Ad Group: Services (page feed label: "services")
│   ├── Dynamic ad target: custom label = "services"
│   └── 2 descriptions (manual)
└── Ad Group: Blog/Content (page feed label: "content")
    ├── Dynamic ad target: custom label = "content"
    └── 2 descriptions (manual)
```

### Ad Specs

| Element | Limit | Notes |
|---------|-------|-------|
| Headline | Auto-generated | From page title/content — you cannot edit |
| Description 1 | 90 characters | Written by you |
| Description 2 | 90 characters | Written by you |
| Display URL | Auto-generated | From the landing page URL |
| Final URL | Auto-selected | Google picks the most relevant page |

### Bidding Strategies

| Strategy | When to Use |
|----------|-------------|
| Maximize Conversions | Starting out — let Google learn which pages convert |
| Target CPA | Once you have 15+ conversions/month and a CPA target |
| Manual CPC | When you want full bid control (less common for DSA) |
| Enhanced CPC | Transitional — manual with Google's adjustment |

## Best Practices

### Page Feed Control

- **Always use page feeds** — don't rely on "All web pages" for production campaigns
- Upload a CSV/Google Sheet with columns: `Page URL`, `Custom Label`
- Label by category, margin tier, or business priority
- Update the feed when new pages are added (or automate via Google Sheets + script)

### Exclusions (Critical)

Exclude pages that should never trigger ads:

- Careers / job listings
- Privacy policy, terms of service, legal pages
- Blog posts (unless content marketing is the goal)
- Support / help center / FAQ
- 404 / error pages
- Out-of-stock product pages
- Internal-only pages

### Negative Keywords

- Cross-reference with existing Search campaigns to avoid **keyword cannibalization**
- If a query is already covered by a keyword campaign, add it as a negative in DSA
- This ensures DSA catches only queries your keyword campaigns miss
- Regular approach: mine DSA search terms weekly → promote good queries to Search → add them as DSA negatives

### Search Term Mining Workflow

1. Run DSA for 2-4 weeks
2. Pull the search terms report
3. Identify high-performing queries (conversions, low CPA)
4. Add them as keywords in regular Search campaigns
5. Add them as negative keywords in DSA
6. Repeat monthly — DSA is a keyword discovery engine

### Common Mistakes

| Mistake | Fix |
|---------|-----|
| Targeting all web pages | Use page feeds with explicit URL lists |
| No exclusions | Exclude careers, legal, support, error pages |
| No negative keywords | Cross-reference with Search campaigns weekly |
| Ignoring headline quality | Check "Dynamic ad targets" report — poor headlines = poor pages |
| Not mining search terms | Review DSA search terms monthly for new keyword opportunities |

## Tracking Implications

### Standard Click-Based Tracking

- DSA uses the same conversion tracking as regular Search campaigns
- Click → landing page → tag fires → conversion tracked
- No special tag configuration needed beyond standard Search setup
- See [[conversion-actions]] for conversion action setup

### Landing Page Coverage Audit (Critical)

> [!warning] DSA Can Send Traffic to Pages Without Tracking
> Because Google auto-selects landing pages, DSA may send users to pages where your conversion tag is NOT deployed. This is the #1 tracking risk with DSA.

**Verification checklist:**

1. Export your page feed URLs (or let Google show you targeted pages)
2. For each URL, verify the GTM container is installed
3. Verify the conversion tag fires on the confirmation/thank-you page that follows each targeted page's CTA
4. If using enhanced conversions, verify user data capture works on all targeted pages
5. Run a test: click through from each major page category → complete a conversion → verify it appears in Google Ads

### Page Feed → GTM Alignment

- Every URL in your page feed should be a page where GTM is deployed
- Use a broken URL checker script (see [[scripts/catalog]]) to verify all page feed URLs return 200 status
- If you add new pages to the feed, verify GTM is on those pages BEFORE adding them
- Set up a monthly audit: page feed URLs vs GTM-deployed URLs

### Search Terms for Keyword Campaigns

- DSA search terms data helps identify queries to add to keyword campaigns
- When promoting a query to a Search campaign, ensure the landing page you assign has full tracking
- DSA may have been sending that query to a different page — verify the conversion path still works

## Related

- [[campaign-types]] — campaign type overview and decision tree
- [[conversion-actions]] — conversion action types and configuration
- [[gtm-to-gads]] — GTM conversion tag implementation
- [[audit-checklist]] — includes landing page tracking verification
