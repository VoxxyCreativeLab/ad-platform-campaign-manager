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
