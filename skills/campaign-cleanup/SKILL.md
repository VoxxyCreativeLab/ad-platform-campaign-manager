---
name: campaign-cleanup
description: "Account cleanup and triage — stop the bleeding in messy accounts before optimization. Use when inheriting a neglected Google Ads account or when performance has degraded."
argument-hint: "[client-name]"
disable-model-invocation: false
---

# Campaign Cleanup & Triage

Structured process for cleaning up messy or neglected Google Ads accounts. Use this before optimization — you can't optimize what's broken.

If `$ARGUMENTS` provides a client name or account context, use it throughout the triage report. Otherwise, ask the user to identify the account before starting.

## When to Use

- Inheriting a client account with unknown history
- Account performance has degraded over time
- Multiple people have made changes without a plan
- Before running `/ad-platform-campaign-manager:campaign-review` on a messy account

## Reference Material

- **Audit checklist:** [[../../reference/platforms/google-ads/audit/audit-checklist|audit-checklist.md]]
- **Common mistakes:** [[../../reference/platforms/google-ads/audit/common-mistakes|common-mistakes.md]]
- **Negative keyword lists:** [[../../reference/platforms/google-ads/audit/negative-keyword-lists|negative-keyword-lists.md]]
- **Account structure:** [[../../reference/platforms/google-ads/account-structure|account-structure.md]]
- **Account profiles (vertical-specific triage priorities):** [[../../reference/platforms/google-ads/strategy/account-profiles|account-profiles.md]]

## Triage Assessment

Before diving into fixes, gather diagnostic context. Ask:
1. What vertical is this account? (e-commerce, lead gen, B2B SaaS, local services)
2. Is conversion tracking working? (Conversions column > 0 in last 30 days)
3. What is the approximate monthly spend?
4. How many conversions last month?
5. What maturity stage? (< 3 months, 3-6 months, 6+ months, 18+ months)

Use answers to determine triage priority:
- **E-commerce with Shopping campaigns:** run the Shopping triage checklist below before Phase 1
- **E-commerce PMax-only:** prioritize PMax asset quality, listing group segmentation, Shopping overlap
- **B2B/Lead gen:** prioritize conversion tracking and offline import pipeline
- **Local services:** prioritize geographic targeting, call tracking, location assets
- **No conversion data at all:** stop — fix tracking first (`/ad-platform-campaign-manager:conversion-tracking`)

### Shopping Triage (E-commerce — run before Phase 1)

When MCP is connected, pull Shopping competitive metrics immediately. These are often the first sign of throttled spend:

```gaql
SELECT campaign.name, metrics.search_impression_share, metrics.search_click_share,
  metrics.search_budget_lost_impression_share, metrics.search_rank_lost_impression_share
FROM campaign
WHERE campaign.advertising_channel_type = 'SHOPPING'
  AND segments.date DURING LAST_30_DAYS
```

Flag immediately if:
- **Click share < 40%** — losing majority of eligible clicks; product group bids likely too low
- **Budget utilization < 70%** — bids so low the campaign cannot spend its daily budget
- **Search IS lost to rank > 30%** — bids or feed quality is the primary constraint
- **Search IS lost to budget > 20%** — budget is the constraint (increase budget)

Also check:
- Ad group naming: does it follow account convention or is it a platform default / wrong language?
- Product groups: are all bids identical? Is everything going through one catch-all group?
- Individual product groups (gla_XXXX, custom IDs): any with zero impressions for 30+ days?
- Budget utilization vs daily cap: compare actual spend/day against daily budget

These checks can catch critical Shopping issues in the first 5 minutes — before any other analysis.

### Display / Demand Gen Triage (if Display or Demand Gen campaigns present — run before Phase 1)

When MCP is connected, pull Display and Demand Gen spend immediately — these campaign types are common sources of invisible waste in messy accounts:

```gaql
SELECT campaign.name, campaign.advertising_channel_type,
  metrics.impressions, metrics.clicks, metrics.ctr,
  metrics.cost_micros, metrics.conversions,
  metrics.view_through_conversions
FROM campaign
WHERE campaign.advertising_channel_type IN ('DISPLAY', 'DEMAND_GEN')
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```

Flag immediately if:
- **Display CTR < 0.2%** — likely junk placements (mobile apps, accidental clicks); review placement report
- **Display spend > 0, conversions = 0** — pause and investigate targeting; could be burning budget with no return
- **Demand Gen running < 14 days with recent budget changes** — still in learning; stop making changes
- **VTC > 70% of Demand Gen conversions** — view-through conversion window likely too wide (30-day default); reduce to 7

Also check:
- Placement report: any mobile app placements active? (Settings > Placements > Where ads showed)
- Audience targeting: any Display campaigns targeting "All users" with no audience signals?
- Creative age: any Display or Demand Gen ads older than 8 weeks? (creative fatigue is the #1 Demand Gen performance killer)

These checks take under 5 minutes and can expose significant waste before any deep analysis.

### Video / YouTube Triage (if Video campaigns present — run before Phase 1)

When MCP is connected, pull Video campaign performance — video spend with no views or conversions is a common source of quiet budget drain:

```gaql
SELECT campaign.name, campaign.id,
  metrics.impressions, metrics.video_views, metrics.video_view_rate,
  metrics.average_cpv, metrics.cost_micros, metrics.conversions,
  metrics.view_through_conversions
FROM campaign
WHERE campaign.advertising_channel_type = 'VIDEO'
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```

Flag immediately if:
- **View rate < 10%** — creative is failing; hook not landing within first 5 seconds; review creative urgently
- **CPV > 2× account average CPV** — bids too aggressive or audience too narrow; investigate targeting
- **Spend > €50, conversions = 0, VTC = 0** — video may be purely branding with no measurement; confirm goal alignment
- **VTC > 70% of Video conversions** — 30-day VTC window likely inflating results; reduce to 7 days

Also check:
- Placement report: any placements on kids content (COPPA risk), competitor channels, or low-quality sites?
- Frequency: is frequency capping set? Uncapped video campaigns run users into creative fatigue quickly
- Creative age: any video ads older than 8 weeks? Video fatigue sets in faster than display

These checks take under 5 minutes and prevent ongoing budget waste on ineffective video placements.

## Triage Process

### Phase 1: Stop the Bleeding (Day 1)

Identify and fix the highest-impact problems immediately:

1. **Pause wasteful spend**
   - Find campaigns/ad groups with high cost and zero conversions (last 30 days)
   - Find keywords with Cost > 3× target CPA and zero conversions
   - Pause (don't delete) — you may need to restore later

2. **Check conversion tracking**
   - Are conversions actually recording? (Conversions column > 0 for the account)
   - Are there duplicate conversion actions counting the same event twice?
   - Is the attribution model set correctly? (Not last-click if using smart bidding)
   - Run `/ad-platform-campaign-manager:conversion-tracking` if tracking is broken

3. **Review budget allocation**
   - Are budgets distributed across campaigns or is one campaign eating everything?
   - Are any campaigns limited by budget that are performing well?
   - Are there campaigns spending on brand terms that should be separated?

### Phase 2: Structural Assessment (Day 2-3)

Understand the account's shape before restructuring:

4. **Map the account structure**
   - List all campaigns, their types, and their purpose
   - Identify overlapping campaigns (same keywords in multiple campaigns)
   - Flag campaigns with no clear goal or naming convention

5. **Keyword hygiene**
   - Check for duplicate keywords across ad groups
   - Review search terms report (last 90 days) for irrelevant queries
   - Add negative keywords from [[../../reference/platforms/google-ads/audit/negative-keyword-lists|pre-built lists]]
   - Check match type strategy — are broad match keywords running without smart bidding?

6. **Ad copy and extensions**
   - Check for disapproved ads
   - Check ad group ad count (minimum 2 RSAs per ad group)
   - Verify extensions are set up (sitelinks, callouts, structured snippets)

### Phase 3: Rebuild Plan (Day 3-5)

Create a plan for the cleaned-up account:

7. **Document the cleanup**
   - What was paused and why
   - What structural issues were found
   - What the account should look like after cleanup

8. **Prioritize next actions**
   - Critical: conversion tracking fixes, budget reallocation
   - High: keyword restructuring, negative keyword additions
   - Medium: ad copy refresh, extension setup
   - Low: campaign consolidation, naming convention cleanup

9. **Recommend next skills**
   - `/ad-platform-campaign-manager:campaign-setup` — for restructured campaigns
   - `/ad-platform-campaign-manager:keyword-strategy` — for keyword cleanup
   - `/ad-platform-campaign-manager:budget-optimizer` — for budget reallocation

## Output Format

Present findings as a triage report:

```
## Account Triage Report: {{client_name}}

### Severity: {{severity_rating}}

### Immediate Actions Taken
- [ ] Paused [X] keywords with $[Y] spend and 0 conversions
- [ ] Fixed [describe conversion tracking issue]
- [ ] Reallocated $[Z] from [underperformer] to [top performer]

### Structural Issues Found
1. {{issue}} — {{impact}} — [Recommended fix]
2. ...

### Cleanup Plan (Priority Order)
1. [Action] — [Timeline]
2. ...

### Estimated Recovery Timeline
- Week 1: [what changes]
- Week 2-4: [expected impact]
```

## Troubleshooting

| Scenario | Response |
|----------|----------|
| Account has no conversion data at all | Fix tracking first — cleanup without data is guessing. Use `/ad-platform-campaign-manager:conversion-tracking` |
| Account is spending but getting conversions | Focus on efficiency, not triage — use `/ad-platform-campaign-manager:campaign-review` instead |
| Client wants to keep everything running | Explain the "stop the bleeding" principle — spending on waste funds competition. Pause, don't delete. |
| Multiple conversion actions with unclear purpose | Audit each action against the actual website events. Remove duplicates. Set one primary action per campaign goal. |
| PMax campaigns mixed with Search | Keep PMax separate in triage. PMax uses different signals — evaluate it against its own benchmarks. See `/ad-platform-campaign-manager:pmax-guide` |

---

## Report Output

When running inside an MWP client project (detected by `stages/` or `reports/` directory):

- **Stage:** `01-audit`
- **Output file:** `reports/{YYYY-MM-DD}/01-audit/campaign-cleanup.md`
- **SUMMARY.md section:** Account Health
- **Write sequence:** Follow the 6-step write sequence in [[conventions#Report File-Writing Convention]]
- **Completeness:** Follow the [[conventions#Output Completeness Convention]]. No truncation, no shortcuts.
- **Re-run behavior:** If this skill runs twice on the same day, overwrite the existing report file. Update (not duplicate) CONTEXT.md row and SUMMARY.md paragraph.
- **Fallback:** If not in an MWP project, output to conversation (legacy behavior).
