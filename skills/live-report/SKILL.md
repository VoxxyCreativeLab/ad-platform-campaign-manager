---
name: live-report
description: "Pull live campaign data via MCP and generate formatted performance reports — campaign summary, keyword analysis, search terms, budget pacing, ad copy, device/geo breakdown. Use when generating live Google Ads reports."
argument-hint: "[report-type and date-range]"
disable-model-invocation: false
---

# Live Campaign Reports

Pull live data from Google Ads via MCP and generate formatted performance reports.

## Prerequisites

Before running reports, verify MCP is connected:
1. Call `list_campaigns` — if it returns data, MCP is working
2. If not connected → direct the user to `/ad-platform-campaign-manager:connect-mcp`

## Reference Material

- **Report templates (GAQL, MCP tools, output formats):** [[references/report-templates|report-templates.md]]
- **GAQL query reference:** [[../../reference/platforms/google-ads/gaql-reference|gaql-reference.md]]
- **GAQL templates library:** [[../../reference/reporting/gaql-query-templates|gaql-query-templates.md]]

## Available Reports

If `$ARGUMENTS` specifies a report type, jump directly to it. Otherwise, ask what the user needs.

| Report | MCP Tools | Best For |
|--------|-----------|----------|
| Campaign Performance Summary | `get_campaign_metrics`, `list_campaigns` | Weekly/monthly overview |
| Keyword Performance | `list_keywords`, `list_ad_groups`, `run_gaql` | Keyword optimization |
| Search Terms Analysis | `run_gaql` (search_term_view) | Finding new keywords, adding negatives |
| Budget Pacing | `get_campaign_metrics`, `list_campaigns` | Daily budget monitoring |
| Ad Copy Performance | `list_ads`, `list_ad_groups` | RSA optimization |
| Device & Geographic Breakdown | `run_gaql` (segments.device, geographic_view) | Bid adjustment decisions |
| Shopping Product Performance | `run_gaql` (shopping_performance_view) | E-commerce: zombie products, top converters, feed issues |
| Audience Performance | Ad group audience performance by list | audience-performance |
| PMax Asset Group Performance | Asset group metrics + ad strength | pmax-asset-groups |
| Conversion Action Breakdown | Per-conversion-action performance + attribution | conversion-breakdown |

### For each report:
1. Consult [[references/report-templates|report-templates.md]] for the GAQL query and MCP tool sequence
2. Pull the data via the appropriate MCP tools
3. Convert `cost_micros` to currency: divide by 1,000,000
4. Calculate derived metrics: CTR = clicks/impressions, CPA = cost/conversions, ROAS = value/cost
5. Format as a clean markdown table using the output template
6. Add period-over-period comparison where applicable (WoW or MoM)
7. Flag anomalies: any metric changing >20% vs previous period
8. End with clear action items based on the data

## Report Principles

- **Always show the date range** at the top of every report
- **Sort by spend** (highest first) unless the user asks otherwise
- **Flag zero-conversion spend** as wasted — show total wasted amount
- **Include action items** — don't just show data, recommend what to do
- **Use currency symbols** (€) — never show raw micros values

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| MCP returns "not connected" or tool not found | MCP server not running or session not unlocked | Run `/ad-platform-campaign-manager:connect-mcp` to set up or restart |
| GAQL query returns `Unrecognized field` | Field name wrong or not available on the queried resource | Check [[../../reference/platforms/google-ads/gaql-reference|gaql-reference.md]] — field names are resource-specific |
| Report shows €0 cost for all campaigns | Date range has no data, or all campaigns are paused | Check campaign statuses; try a wider date range (LAST_30_DAYS); verify the account has active campaigns |
| CPA shows as "∞" or undefined | Campaigns have spend but zero conversions | Show CPA as "—" (no data); flag these campaigns for conversion tracking check |
| ROAS shows as 0 | No conversion value is being tracked | Check if conversion actions have value configured; recommend `/ad-platform-campaign-manager:conversion-tracking` |
| Rate limit errors from MCP | Too many API calls in sequence | Batch queries — pull account-level metrics first, then drill into specific campaigns/ad groups only as needed |
| Data doesn't match Google Ads UI | Different date range, attribution model, or conversion counting | Verify date range matches; note that API uses the default attribution model and may include all conversions vs primary only |

## Scheduling

For recurring reports, suggest the user set up automated reporting:
- **Weekly performance summary** — Monday morning, last 7 days
- **Monthly deep-dive** — 1st of month, previous month
- **Daily budget pacing** — daily, current month-to-date
- For automated pipelines (not ad-hoc), use `/ad-platform-campaign-manager:reporting-pipeline`
- For deploying reports as n8n scheduled workflows (push to Slack, Sheets, email) → `/n8n-workflow-builder-plugin:deploy-workflow`

---

## Report Output

When running inside an MWP client project (detected by `stages/` or `reports/` directory):

- **Stage:** `01-audit`
- **Output file:** `reports/{YYYY-MM-DD}/01-audit/live-report.md`
- **SUMMARY.md section:** Account Health
- **Write sequence:** Follow the 6-step write sequence in [[conventions#Report File-Writing Convention]]
- **Completeness:** Follow the [[conventions#Output Completeness Convention]]. No truncation, no shortcuts.
- **Re-run behavior:** If this skill runs twice on the same day, overwrite the existing report file. Update (not duplicate) CONTEXT.md row and SUMMARY.md paragraph.
- **Fallback:** If not in an MWP project, output to conversation (legacy behavior).
