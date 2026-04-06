---
name: campaign-review
description: Audit a campaign against best practices — structure, keywords, ads, bids, conversions, budget. Use when reviewing an existing Google Ads campaign.
argument-hint: "[campaign-name or account-data]"
disable-model-invocation: false
---

# Campaign Review

You are auditing a Google Ads campaign against best practices. Work through the checklist systematically and produce a scored report.

## Reference Material

- **Full audit checklist:** [[../../reference/platforms/google-ads/audit/audit-checklist|audit-checklist.md]]
- **Common mistakes:** [[../../reference/platforms/google-ads/audit/common-mistakes|common-mistakes.md]]
- **Negative keyword lists:** [[../../reference/platforms/google-ads/audit/negative-keyword-lists|negative-keyword-lists.md]]
- **Quality Score guide:** [[../../reference/platforms/google-ads/quality-score|quality-score.md]]
- **Bid strategy reference:** [[../../reference/platforms/google-ads/bidding-strategies|bidding-strategies.md]]
- **Account structure patterns:** [[../../reference/platforms/google-ads/account-structure|account-structure.md]]
- **Conversion actions:** [[../../reference/platforms/google-ads/conversion-actions|conversion-actions.md]]
- **Account profiles and archetypes:** [[../../reference/platforms/google-ads/strategy/account-profiles|account-profiles.md]]

## How to Review

### If the user provides campaign data (pasted text, screenshots, exports):
1. Parse the provided information
2. Run through the relevant sections of the audit checklist
3. Identify issues and categorize by severity
4. Produce the report

### If the user describes a campaign verbally:
1. Ask clarifying questions about the areas you can't evaluate from the description
2. Audit what you can based on the information provided
3. Note which areas need more data to evaluate

### If MCP is connected (Phase 2):
1. Pull campaign data directly via MCP tools
2. Run the full audit automatically
3. Produce a comprehensive report

### If insufficient data is provided:
1. Tell the user which of the 17 review areas you cannot evaluate
2. List the minimum data needed for a useful audit:
   - Campaign names and types
   - Last 30-day spend, conversions, and CPA per campaign
   - Current bid strategies
   - Whether conversion tracking is configured
3. If fewer than 3 areas can be evaluated, recommend:
   - Export campaign data from Google Ads (Reports → Predefined → Campaigns)
   - Or connect MCP for direct access: `/ad-platform-campaign-manager:connect-mcp`

## Establish Account Profile

Before auditing, establish the account's profile to weight the review correctly. If the user has already run `/ad-platform-campaign-manager:account-strategy`, ask them to share the profile summary to skip these questions.

Ask:
1. **"What does this business do?"** → map to vertical (e-commerce, lead gen, B2B SaaS, local services)
2. **"How long has this account been running, and roughly how many conversions per month?"** → map to maturity stage
3. **"What's the monthly budget?"** → map to budget tier
4. **"What tracking is in place — GA4, GTM, sGTM?"** → map to tracking maturity

Map to a strategy archetype from [[../../reference/platforms/google-ads/strategy/account-profiles|account-profiles.md]]. State it: "This is **Archetype #[X]** — I'll weight the audit accordingly."

### Review Area Weighting by Profile

Not all 17 review areas are equally important for every account. Weight based on the profile:

| Profile | High Priority | Medium Priority | Lower Priority / Skip |
|---------|--------------|-----------------|----------------------|
| **E-commerce** | Shopping Specific, PMax, Budget, Conversion Tracking, Feed Health, Competitive Analysis | Keywords, Bidding, Audience Strategy, Display (remarketing), Demand Gen (if running) | (all relevant) |
| **Lead Gen** | Conversion Tracking, Keywords, Ads | Bidding, Budget, Competitive Analysis, Display (remarketing) | PMax (unless running), Feed Health (skip), Demand Gen (skip) |
| **B2B SaaS** | Conversion Tracking, Keywords, Bidding | Ads, Targeting, Competitive Analysis, Demand Gen (if running) | PMax (unless mature + 50+ conv), Feed Health (skip), Display (skip) |
| **Local Services** | Targeting, Conversion Tracking, Extensions | Ads, Budget, Competitive Analysis | PMax (unless medium+ budget), Feed Health (skip), Demand Gen (skip), Display (if remarketing) |
| **Micro budget** | Budget, Keywords, Bidding | Ads, Conversion Tracking, Competitive Analysis | PMax (skip), Extensions (basic only), Feed Health (skip), Display (skip), Demand Gen (skip) |
| **Cold start** | Conversion Tracking, Campaign Structure, Keywords | Bidding, Ads | PMax (too early), Feed Health (skip), Display (skip), Demand Gen (skip), Competitive Analysis (too early) |
| **Mature + Large** | (all areas weighted equally — full audit) | | |

### Severity Thresholds by Maturity

Adjust how you grade issues based on account maturity:

| Finding | Cold Start | Early Data | Established | Mature |
|---------|-----------|------------|-------------|--------|
| No Smart Bidding | Informational — expected | Suggestion | Warning | Critical |
| No value-based bidding | N/A | N/A | Suggestion | Warning |
| No PMax | Informational — too early | Informational | Suggestion if 30+ conv | Warning if feed present |
| Limited budget on top campaign | Warning | Warning | Critical | Critical |
| No negative keywords | Warning | Critical | Critical | Critical |
| No enhanced conversions | Suggestion | Warning | Warning | Critical |

## Review Areas

> [!tip] Conversion Tracking Issues
> If conversion tracking is missing or misconfigured during the audit, recommend the user run `/ad-platform-campaign-manager:conversion-tracking` before continuing the review — most other review areas depend on reliable conversion data.

Work through these areas from the audit checklist:

1. **Conversion Tracking** — Is it set up correctly? Primary vs secondary? Enhanced conversions?
2. **Account Settings** — Auto-tagging? IP exclusions? Linked accounts?
3. **Campaign Structure** — Naming? Brand/non-brand separation? Purpose clarity?
4. **Targeting** — Location (Presence only)? Language? Ad schedule?
5. **Bidding** — Strategy matches goal? Sufficient data? Realistic targets?
6. **Budget** — Sufficient? Not limited on top campaigns? Pacing correctly?
7. **Ad Groups** — Themed correctly? Right number of keywords? No conflicts?
8. **Keywords** — Match types intentional? Negatives in place? Search terms reviewed?
9. **Ads** — RSA quality? All slots used? Landing pages match?
10. **Extensions** — Sitelinks, callouts, structured snippets at minimum?
11. **PMax** (if applicable) — Asset quality? Audience signals? Brand exclusions?
12. **Shopping Specific** (if Shopping campaigns present) — Product group structure? Bids vs benchmark? Click share? Impression share? Feed health? See Shopping Specific section in audit-checklist.md. Use MCP GAQL to pull Shopping metrics when connected.
13. **Audience Strategy** — Remarketing lists built and sized? Converter exclusions? RLSA layered? Customer Match? See Audience Strategy section in audit-checklist.md.
14. **Display Campaign** (if Display campaigns present) — Separated from Search? Frequency capping configured? Placement exclusions applied? Responsive display ad quality? CTR benchmarks? VTC window? See Display Campaign section in audit-checklist.md. Use MCP GAQL to pull Display metrics when connected.
15. **Demand Gen** (if Demand Gen campaigns present) — Channel controls configured? Creative fresh (< 6 weeks)? Prospecting vs remarketing separated? VTC window reviewed? See Demand Gen section in audit-checklist.md. Use MCP GAQL to pull Demand Gen metrics when connected.
16. **Competitive Analysis** (cross-campaign) — Impression share reviewed? IS lost to rank vs budget distinguished? Brand absolute top IS > 80%? Competitor brand bidding detected? See Competitive Analysis section in audit-checklist.md. Use MCP GAQL to pull IS metrics when connected.
17. **Feed Health** (if e-commerce with MC feed) — Feed updated daily? Disapproval rate < 2%? GTIN coverage > 90%? Supplemental feed in use? Content API migration planned? See Feed Health section in audit-checklist.md. (MC-only — no GAQL available)

### MCP Verification: Shopping Campaigns

When MCP is connected and Shopping campaigns are present, run these GAQL queries:

**Product group performance and bids:**
```gaql
SELECT ad_group.name, ad_group_criterion.cpc_bid_micros,
  metrics.impressions, metrics.clicks, metrics.cost_micros,
  metrics.conversions, metrics.conversions_value
FROM product_group_view
WHERE campaign.advertising_channel_type = 'SHOPPING'
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```

**Shopping competitive metrics (click share + impression share):**
```gaql
SELECT campaign.name, campaign.id,
  metrics.search_impression_share,
  metrics.search_click_share,
  metrics.search_budget_lost_impression_share,
  metrics.search_rank_lost_impression_share
FROM campaign
WHERE campaign.advertising_channel_type = 'SHOPPING'
  AND segments.date DURING LAST_30_DAYS
```

**Ad group details for Shopping:**
```gaql
SELECT ad_group.name, ad_group.status, ad_group.cpc_bid_micros,
  campaign.name, metrics.impressions, metrics.clicks
FROM ad_group
WHERE campaign.advertising_channel_type = 'SHOPPING'
  AND segments.date DURING LAST_30_DAYS
```

Flag these thresholds as issues:
- Click share < 40%: **Critical** — losing majority of eligible clicks; bids too low
- Click share 40-60%: **Warning** — room for improvement
- Search IS < 50%: **Warning** — significant missed impression opportunity
- Search IS lost to budget > 20%: **Warning** — budget is the constraint, not bids
- Search IS lost to rank > 30%: **Critical** — bids or feed quality is the constraint
- Budget utilization < 70%: **Warning** — bids may be too low to spend the daily budget

### MCP Verification: Display Campaigns

When MCP is connected and Display campaigns are present, run this GAQL query:

```gaql
SELECT campaign.name, campaign.id,
  metrics.impressions, metrics.clicks, metrics.ctr,
  metrics.cost_micros, metrics.conversions,
  metrics.view_through_conversions,
  metrics.content_impression_share,
  metrics.content_rank_lost_impression_share,
  metrics.content_budget_lost_impression_share
FROM campaign
WHERE campaign.advertising_channel_type = 'DISPLAY'
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```

Flag these thresholds as issues:
- CTR < 0.3%: **Warning** — likely junk placements or poor creative; check placement report
- VTC > 50% of total conversions: **Warning** — VTC window may be too wide; review attribution
- Content IS lost to rank > 30%: **Warning** — bids or targeting too restrictive
- Content IS lost to budget > 20%: **Warning** — budget is the constraint

### MCP Verification: Demand Gen Campaigns

When MCP is connected and Demand Gen campaigns are present, run this GAQL query:

```gaql
SELECT campaign.name, campaign.id,
  metrics.impressions, metrics.clicks, metrics.ctr,
  metrics.cost_micros, metrics.conversions,
  metrics.view_through_conversions
FROM campaign
WHERE campaign.advertising_channel_type = 'DEMAND_GEN'
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```

Flag these thresholds as issues:
- VTC > 60% of total conversions: **Warning** — Demand Gen VTC can inflate results; reduce window to 7 days
- Cost per conversion > 2x account average: **Warning** — may need audience refresh or creative update
- Campaign running < 14 days: **Informational** — still in learning period; do not judge performance yet

### MCP Verification: Competitive Analysis

When MCP is connected, pull impression share metrics for all active campaigns:

```gaql
SELECT campaign.name, campaign.id,
  metrics.search_impression_share,
  metrics.search_absolute_top_impression_share,
  metrics.search_budget_lost_impression_share,
  metrics.search_rank_lost_impression_share
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```

Flag these thresholds as issues:
- Brand campaign absolute top IS < 80%: **Critical** — brand position at risk; increase bids or budget
- Search IS lost to rank > 30%: **Warning** — quality score or bid issue on this campaign
- Search IS lost to budget > 20%: **Warning** — budget is constraining reach

> [!info] Auction Insights detail (competitor names, overlap rate, outranking share) requires the Google Ads UI — export from Tools > Auction Insights. This cannot be pulled via GAQL.

## Report Format

```
# Campaign Audit Report

## Summary
**Overall Health:** {{health_rating}}
**Score:** {{passing_count}}/{{total_count}} checklist items passing

## Critical Issues (fix immediately)
1. {{issue}} — {{impact}} — {{fix}}

## Warnings (fix soon)
1. {{issue}} — {{impact}} — {{fix}}

## Suggestions (nice to have)
1. {{issue}} — {{impact}} — {{fix}}

## Section-by-Section Results
### Conversion Tracking: [Pass/Needs Work]
- [x] Item
- [ ] Item (issue description)
...

## Prioritized Action Plan
1. {{highest_impact_fix}}
2. {{second_priority}}
3. ...

## Vertical-Specific Checks
{{Include the relevant section below based on profile}}
```

### Vertical-Specific Audit Items

When generating the report, include checks specific to the account's vertical:

**E-commerce:**
- Run full **Area 12: Shopping Specific** (28 checks) — the primary e-commerce differentiator. Pull competitive metrics via MCP GAQL. See Shopping Specific section in audit-checklist.md.
- Run **Area 13: Audience Strategy** — remarketing lists, converter exclusions, RLSA.
- Run **Area 14: Display Campaign** (if running) — placement exclusions, remarketing configuration, CTR benchmarks.
- Run **Area 15: Demand Gen** (if running) — creative freshness, channel controls, VTC window.
- Run **Area 16: Competitive Analysis** — IS metrics via MCP GAQL; Auction Insights via UI.
- Run **Area 17: Feed Health** — full feed audit beyond the Shopping pre-flight (10 checks).
- PMax listing groups: verify segmentation (not "All products" default) — covered in Area 11.
- ROAS tracking: purchase value passed correctly — covered in Area 1 (Conversion Tracking).
- Reference: [[../../reference/platforms/google-ads/shopping-campaigns|shopping-campaigns.md]] and [[../../reference/platforms/google-ads/audit/audit-gap-analysis|audit-gap-analysis.md]]

**Lead Gen:**
- Call tracking: is it set up? Duration threshold for conversion (30+ seconds)?
- Offline conversion imports: are lead quality signals being sent back to Google Ads?
- Form fills: are they deduplicated? Using transaction ID?
- Lead quality: is Smart Bidding optimizing for quantity over quality (the Lead Quality Trap)?

**B2B SaaS:**
- Offline pipeline: is the CRM → Google Ads import pipeline working?
- Multi-step value assignment: are MQL/SQL/close stages assigned ascending values?
- Low volume handling: is the account below Smart Bidding thresholds? Should campaigns be consolidated?
- Landing page experience: demo/trial pages convert differently — are they split-tested?

**Local Services:**
- Geographic targeting: is it set to "Presence" (not "Presence or interest")?
- Location assets: are they linked to Google Business Profile?
- Radius targeting: is the radius appropriate for the service area?
- Call extensions: on every ad group?
- LSA eligibility: is the business eligible for Local Services Ads?

## What to Do Next

Based on the audit findings, recommend the next skill:

| Finding | Next Skill |
|---------|-----------|
| Conversion tracking broken or missing | `/ad-platform-campaign-manager:conversion-tracking` |
| Budget allocation issues or bid strategy mismatch | `/ad-platform-campaign-manager:budget-optimizer` |
| Account structure messy, overlapping campaigns | `/ad-platform-campaign-manager:campaign-cleanup` |
| PMax campaign needs setup or restructuring | `/ad-platform-campaign-manager:pmax-guide` |
| Keywords need rework, poor search terms | `/ad-platform-campaign-manager:keyword-strategy` |
| No strategy profile established | `/ad-platform-campaign-manager:account-strategy` |

---

## Report Output

When running inside an MWP client project (detected by `stages/` or `reports/` directory):

- **Stage:** `01-audit`
- **Output file:** `reports/{YYYY-MM-DD}/01-audit/campaign-review.md`
- **SUMMARY.md section:** Account Health
- **Write sequence:** Follow the 6-step write sequence in [[conventions#Report File-Writing Convention]]
- **Completeness:** Follow the [[conventions#Output Completeness Convention]]. No truncation, no shortcuts.
- **Re-run behavior:** If this skill runs twice on the same day, overwrite the existing report file. Update (not duplicate) CONTEXT.md row and SUMMARY.md paragraph.
- **Fallback:** If not in an MWP project, output to conversation (legacy behavior).
