---
name: live-report
description: "[Phase 2] Pull live campaign data via MCP and generate formatted performance reports. Use when generating live Google Ads reports. Requires MCP connection."
disable-model-invocation: true
---

# Live Campaign Reports

**Phase 2 Skill** — Requires a connected Google Ads MCP server. Set up via `/ad-platform-campaign-manager:connect-mcp`.

## Prerequisites Check

Before running reports, verify:
1. MCP server is configured and running
2. Test with a simple campaign list query
3. If not connected, direct the user to `/ad-platform-campaign-manager:connect-mcp`

## Reference Material

- **GAQL query templates:** [[../../reference/reporting/gaql-query-templates|gaql-query-templates.md]]
- **Report formats:** [[../../reference/reporting/looker-studio-templates|looker-studio-templates.md]]
- **GAQL reference:** [[../../reference/platforms/google-ads/gaql-reference|gaql-reference.md]]

## Available Reports

### Campaign Performance Summary
Pull via MCP and format as a table:
- All enabled campaigns with spend, impressions, clicks, CTR, conversions, CPA, ROAS
- Compare to previous period (WoW or MoM)
- Flag anomalies (>20% change)

### Keyword Performance
- Top keywords by cost with Quality Score
- Keywords with spend but no conversions (waste)
- High-converting keywords (potential budget increase candidates)

### Search Terms Analysis
- Top search terms triggering ads
- Search terms with conversions (add as keywords?)
- Irrelevant search terms (add as negatives?)

### Ad Copy Performance
- RSA performance comparison within each ad group
- CTR and conversion rate by ad

### Budget Pacing
- Current spend vs daily budget
- Projected monthly spend at current pace
- Campaigns limited by budget

### Device & Geographic Breakdown
- Performance by device type
- Performance by location

## Report Format

Format all reports as clean markdown tables with:
- Key metrics highlighted
- Period-over-period comparisons
- Clear recommendations based on the data
- Action items (keywords to add/remove, budgets to adjust, etc.)

## Scheduling

For recurring reports, suggest the user set up:
- Weekly performance summaries (Monday morning)
- Monthly deep-dive reports
- Daily budget pacing alerts
