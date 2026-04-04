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
1. Tell the user which of the 11 review areas you cannot evaluate
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

Not all 11 review areas are equally important for every account. Weight based on the profile:

| Profile | High Priority | Medium Priority | Lower Priority / Skip |
|---------|--------------|-----------------|----------------------|
| **E-commerce** | PMax, Budget, Conversion Tracking | Keywords, Bidding | (all relevant) |
| **Lead Gen** | Conversion Tracking, Keywords, Ads | Bidding, Budget | PMax (unless running) |
| **B2B SaaS** | Conversion Tracking, Keywords, Bidding | Ads, Targeting | PMax (unless mature + 50+ conv) |
| **Local Services** | Targeting, Conversion Tracking, Extensions | Ads, Budget | PMax (unless medium+ budget) |
| **Micro budget** | Budget, Keywords, Bidding | Ads, Conversion Tracking | PMax (skip), Extensions (basic only) |
| **Cold start** | Conversion Tracking, Campaign Structure, Keywords | Bidding, Ads | PMax (too early) |
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
- Feed health: check Merchant Center for disapprovals, feed freshness, missing attributes
- PMax listing groups: verify segmentation (not "All products" default)
- Shopping campaign bid strategy: matches conversion volume?
- ROAS tracking: is purchase value being passed correctly?

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
