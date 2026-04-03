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

## Review Areas

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
```
