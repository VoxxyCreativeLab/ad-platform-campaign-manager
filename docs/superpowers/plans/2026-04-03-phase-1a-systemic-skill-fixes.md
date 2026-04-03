---
title: "Phase 1a — Systemic Skill Fixes"
date: 2026-04-03
tags:
  - mwp
  - plan
  - implementation
---

# Phase 1a — Systemic Skill Fixes

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix 6 systemic issues across all 11 skills identified in the skill review audit (avg 82/100 → target 90+/100).

**Architecture:** Mechanical fixes to YAML frontmatter, template syntax, cross-references, routing tables, and content gaps. No new features — only quality improvements to existing skills. The live-report skill gets a complete rewrite (62/100 → 85+).

**Tech Stack:** Markdown (SKILL.md files), YAML frontmatter, Obsidian-flavored syntax, wikilinks

**Spec:** [[../specs/2026-04-03-strategic-upgrade-design|Strategic Upgrade v2.0 Design]]
**Audit:** [[../specs/2026-04-03-skill-review-audit|Skill Review Audit]]

---

## File Map

| Action | File | Changes |
|--------|------|---------|
| Modify | `skills/CONTEXT.md` | Add missing dependency entries for keyword-strategy and budget-optimizer |
| Modify | `CONTEXT.md` | Add missing Load entries for keyword-strategy and budget-optimizer |
| Modify | `skills/budget-optimizer/SKILL.md` | Add argument-hint, {{placeholders}}, $ARGUMENTS, output format, inter-skill refs |
| Modify | `skills/keyword-strategy/SKILL.md` | {{placeholders}}, troubleshooting section, inter-skill refs |
| Modify | `skills/campaign-review/SKILL.md` | Add argument-hint, {{placeholders}}, inter-skill ref, error handling |
| Modify | `skills/reporting-pipeline/SKILL.md` | Add argument-hint, {{placeholders}}, inter-skill ref, tooling gap note |
| Modify | `skills/connect-mcp/SKILL.md` | Add argument-hint, OAuth error handling, .gitignore security |
| Modify | `skills/campaign-setup/SKILL.md` | {{placeholders}} only |
| Modify | `skills/campaign-cleanup/SKILL.md` | Add argument-hint, {{placeholders}}, $ARGUMENTS handling |
| Modify | `skills/conversion-tracking/SKILL.md` | Add argument-hint, output template |
| Modify | `skills/pmax-guide/SKILL.md` | Add argument-hint only |
| Modify | `skills/ads-scripts/SKILL.md` | Add argument-hint only |
| Rewrite | `skills/live-report/SKILL.md` | Complete rewrite: error handling, GAQL mapping, MCP tool mapping, sample output, companion ref |
| Create | `skills/live-report/references/report-templates.md` | Report output templates with GAQL queries per report type |
| Modify | `CHANGELOG.md` | Add v1.3.0 entry |

---

## Task 1: Fix Dependency Maps in skills/CONTEXT.md

**Files:**
- Modify: `skills/CONTEXT.md`

The dependency map is missing entries for keyword-strategy (references `account-structure.md` but it's not listed) and budget-optimizer (references `account-structure.md` and `common-mistakes.md` but they're not listed).

- [ ] **Step 1: Add missing dependencies**

In `skills/CONTEXT.md`, replace:

```
keyword-strategy ────→ match-types, negative-keyword-lists
```

with:

```
keyword-strategy ────→ match-types, negative-keyword-lists, account-structure
```

And replace:

```
budget-optimizer ────→ bidding-strategies, campaign-types
```

with:

```
budget-optimizer ────→ bidding-strategies, campaign-types, account-structure,
                       audit/common-mistakes
```

- [ ] **Step 2: Verify all 11 dependency entries match SKILL.md references**

For each skill, confirm every wikilink in SKILL.md's "Reference Material" section appears in the dependency map. The remaining 9 skills should already match.

- [ ] **Step 3: Commit**

```bash
git add skills/CONTEXT.md
git commit -m "fix: update skills/CONTEXT.md dependency maps for keyword-strategy and budget-optimizer"
```

---

## Task 2: Fix Dependency Maps in Root CONTEXT.md

**Files:**
- Modify: `CONTEXT.md`

The root routing table's "Load" column for keyword planning and budget/bids tasks is missing files that the skills actually reference.

- [ ] **Step 1: Update keyword planning row**

In `CONTEXT.md`, replace the Load cell for "Keyword planning":

```
| Keyword planning | `skills/keyword-strategy/SKILL.md` | `reference/platforms/google-ads/match-types.md`, `audit/negative-keyword-lists.md` | PMax, tracking-bridge, reporting, mcp |
```

with:

```
| Keyword planning | `skills/keyword-strategy/SKILL.md` | `reference/platforms/google-ads/match-types.md`, `audit/negative-keyword-lists.md`, `account-structure.md` | PMax, tracking-bridge, reporting, mcp |
```

- [ ] **Step 2: Update budget/bids row**

Replace:

```
| Budget / bids | `skills/budget-optimizer/SKILL.md` | `reference/platforms/google-ads/bidding-strategies.md`, `campaign-types.md` | Tracking-bridge, reporting, pmax, scripts |
```

with:

```
| Budget / bids | `skills/budget-optimizer/SKILL.md` | `reference/platforms/google-ads/bidding-strategies.md`, `campaign-types.md`, `account-structure.md`, `audit/common-mistakes.md` | Tracking-bridge, reporting, pmax, scripts |
```

- [ ] **Step 3: Commit**

```bash
git add CONTEXT.md
git commit -m "fix: update root CONTEXT.md routing table for keyword-strategy and budget-optimizer dependencies"
```

---

## Task 3: Add argument-hint to 9 Skills

**Files:**
- Modify: 9 SKILL.md files (all except campaign-setup and keyword-strategy which already have it)

Add `argument-hint` field to YAML frontmatter of each skill. Insert after the `description` field, before `disable-model-invocation`.

- [ ] **Step 1: budget-optimizer**

Add after the `description` line:

```yaml
argument-hint: "[budget-amount or campaign-name]"
```

- [ ] **Step 2: campaign-cleanup**

Add after the `description` line:

```yaml
argument-hint: "[client-name]"
```

- [ ] **Step 3: campaign-review**

Add after the `description` line:

```yaml
argument-hint: "[campaign-name or account-data]"
```

- [ ] **Step 4: conversion-tracking**

Add after the `description` line:

```yaml
argument-hint: "[setup|troubleshoot|enhanced-conversions]"
```

- [ ] **Step 5: pmax-guide**

Add after the `description` line:

```yaml
argument-hint: "[feed-only|full|optimize|report]"
```

- [ ] **Step 6: reporting-pipeline**

Add after the `description` line:

```yaml
argument-hint: "[gaql|bigquery|dbt|looker-studio]"
```

- [ ] **Step 7: ads-scripts**

Add after the `description` line:

```yaml
argument-hint: "[browse|script-description]"
```

- [ ] **Step 8: connect-mcp**

Add after the `description` line:

```yaml
argument-hint: "[account-name or MCC-ID]"
```

- [ ] **Step 9: live-report**

Add after the `description` line:

```yaml
argument-hint: "[report-type and date-range]"
```

- [ ] **Step 10: Commit**

```bash
git add skills/*/SKILL.md
git commit -m "feat: add argument-hint frontmatter to 9 skills"
```

---

## Task 4: Replace [bracket] Placeholders with {{placeholder}} Syntax

**Files:**
- Modify: All SKILL.md files that contain output templates with `[bracket]` placeholders

Scan each SKILL.md for output templates (usually in a code block after "Output Format" or "Report Format" section). Replace `[text]` placeholders with `{{snake_case}}`.

- [ ] **Step 1: campaign-setup** (`skills/campaign-setup/SKILL.md`)

In Step 3, replace:

```
`[Type] | [Goal] | [Targeting] | [Region]`
```

with:

```
`{{type}} | {{goal}} | {{targeting}} | {{region}}`
```

- [ ] **Step 2: keyword-strategy** (`skills/keyword-strategy/SKILL.md`)

In the Output Format section, replace:

```
AD GROUP: [Theme Name]
```

with:

```
AD GROUP: {{theme_name}}
```

- [ ] **Step 3: campaign-review** (`skills/campaign-review/SKILL.md`)

In the Report Format section, replace all `[bracketed]` placeholders:

```
**Overall Health:** [Excellent / Good / Needs Work / Critical]
**Score:** [X/Y checklist items passing]
```

with:

```
**Overall Health:** {{health_rating}}
**Score:** {{passing_count}}/{{total_count}} checklist items passing
```

And replace:

```
1. [Issue] — [Impact] — [Fix]
```

with (in all three severity sections):

```
1. {{issue}} — {{impact}} — {{fix}}
```

And replace:

```
1. [Highest impact fix]
2. [Second priority]
3. ...
```

with:

```
1. {{highest_impact_fix}}
2. {{second_priority}}
3. {{additional_actions}}
```

- [ ] **Step 4: campaign-cleanup** (`skills/campaign-cleanup/SKILL.md`)

In the Output Format section, replace:

```
## Account Triage Report: [Client Name]

### Severity: [Critical / High / Medium / Low]
```

with:

```
## Account Triage Report: {{client_name}}

### Severity: {{severity_rating}}
```

And replace:

```
- [ ] Paused [X] keywords with $[Y] spend and 0 conversions
- [ ] Fixed [describe conversion tracking issue]
- [ ] Reallocated $[Z] from [underperformer] to [top performer]
```

with:

```
- [ ] Paused {{paused_count}} keywords with €{{wasted_spend}} spend and 0 conversions
- [ ] Fixed {{tracking_issue_description}}
- [ ] Reallocated €{{reallocated_amount}} from {{underperformer}} to {{top_performer}}
```

And replace:

```
1. [Issue] — [Impact] — [Recommended fix]
```

with:

```
1. {{issue}} — {{impact}} — {{recommended_fix}}
```

And replace:

```
1. [Action] — [Timeline]
```

with:

```
1. {{action}} — {{timeline}}
```

- [ ] **Step 5: budget-optimizer** (`skills/budget-optimizer/SKILL.md`)

The framework code block uses inline variable references, not bracket placeholders. No changes needed here — skip.

- [ ] **Step 6: Verify no remaining [bracket] placeholders**

Search all SKILL.md files for the pattern `\[.*\]` in output template sections. Confirm all remaining brackets are markdown checkboxes `- [ ]` or legitimate syntax, not placeholders.

- [ ] **Step 7: Commit**

```bash
git add skills/*/SKILL.md
git commit -m "fix: replace [bracket] placeholders with {{placeholder}} syntax in all skill output templates"
```

---

## Task 5: Fix keyword-strategy — Add Troubleshooting, Inter-Skill Refs

**Files:**
- Modify: `skills/keyword-strategy/SKILL.md`

- [ ] **Step 1: Add troubleshooting section**

After the "Expansion Recommendations" section (end of SKILL.md), add:

```markdown
## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| User has no keyword ideas to start from | No familiarity with the industry or product | Ask for the client's website URL, competitor names, or Google Search Console data; use these as seed inputs for brainstorming |
| All suggested keywords have zero estimated volume | Niche business or very specific terms | Broaden to category-level terms, use phrase match to capture long-tail variations, check if the target location is too narrow |
| Keywords generate clicks but no conversions | Intent mismatch — keywords are informational, not transactional | Review the keyword intent tier; move informational keywords to a separate campaign with lower bids or pause them |
| Internal keyword competition across ad groups | Same keyword appears in multiple ad groups | Run a duplicate keyword audit; consolidate into the most relevant ad group; add cross-group negatives for the others |
| Client's existing list conflicts with new strategy | Legacy keywords don't match the proposed ad group themes | Present the gap analysis; recommend phased migration — don't delete old keywords immediately, add new ones alongside and shift budget |
```

- [ ] **Step 2: Add inter-skill references**

After the troubleshooting section, add:

```markdown
## Next Steps

After keyword research is complete:
- Build the campaign structure → `/ad-platform-campaign-manager:campaign-setup`
- Set budget and bids for the keyword plan → `/ad-platform-campaign-manager:budget-optimizer`
- Review existing campaigns against the new keyword strategy → `/ad-platform-campaign-manager:campaign-review`
```

- [ ] **Step 3: Commit**

```bash
git add skills/keyword-strategy/SKILL.md
git commit -m "feat: add troubleshooting and inter-skill references to keyword-strategy"
```

---

## Task 6: Fix budget-optimizer — Add Output Format, Inter-Skill Refs, $ARGUMENTS

**Files:**
- Modify: `skills/budget-optimizer/SKILL.md`

- [ ] **Step 1: Add $ARGUMENTS handling**

After the opening paragraph ("You are helping with budget allocation..."), add:

```markdown
If `$ARGUMENTS` provides a budget amount, campaign name, or context, use it to scope the guidance. Otherwise, ask the user what they need help with: allocation, forecasting, bid strategy, or CPA/ROAS targets.
```

- [ ] **Step 2: Add output format**

Before the "Troubleshooting" section, add:

```markdown
## Output Format

Present budget recommendations as a structured plan:

```
## Budget & Bid Strategy Plan

### Current State
| Campaign | Monthly Spend | Conv. | CPA | ROAS | Budget Limited? |
|----------|--------------|-------|-----|------|-----------------|
| {{campaign_name}} | €{{spend}} | {{conversions}} | €{{cpa}} | {{roas}} | {{yes_no}} |

### Recommended Changes
| Campaign | Action | Current → Proposed | Expected Impact |
|----------|--------|-------------------|-----------------|
| {{campaign_name}} | {{action}} | {{current}} → {{proposed}} | {{impact}} |

### Bid Strategy Recommendation
- **Current:** {{current_strategy}}
- **Recommended:** {{recommended_strategy}}
- **Rationale:** {{rationale}}
- **Data requirement:** {{min_conversions}} conversions/month (currently at {{current_conversions}})

### Timeline
- Week 1-2: {{initial_changes}}
- Week 3-4: {{monitoring_actions}}
- Month 2+: {{optimization_actions}}
```
```

- [ ] **Step 3: Add inter-skill references**

After the "Troubleshooting" section, add:

```markdown
## Next Steps

- Validate the optimized campaign → `/ad-platform-campaign-manager:campaign-review`
- Fix structural issues found during budget analysis → `/ad-platform-campaign-manager:campaign-cleanup`
- Set up or fix conversion tracking (required for smart bidding) → `/ad-platform-campaign-manager:conversion-tracking`
```

- [ ] **Step 4: Commit**

```bash
git add skills/budget-optimizer/SKILL.md
git commit -m "feat: add output format, $ARGUMENTS handling, and inter-skill refs to budget-optimizer"
```

---

## Task 7: Fix campaign-review — Add Error Handling, Inter-Skill Ref

**Files:**
- Modify: `skills/campaign-review/SKILL.md`

- [ ] **Step 1: Add data sufficiency handling**

After the "How to Review" section's three paths (data provided, verbal, MCP), add a fourth path:

```markdown
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
```

- [ ] **Step 2: Add inter-skill reference for conversion tracking**

After the "Review Areas" section, before "Report Format", add:

```markdown
> [!tip] Conversion Tracking Issues
> If conversion tracking is missing or misconfigured during the audit, recommend the user run `/ad-platform-campaign-manager:conversion-tracking` before continuing the review — most other review areas depend on reliable conversion data.
```

- [ ] **Step 3: Commit**

```bash
git add skills/campaign-review/SKILL.md
git commit -m "feat: add data sufficiency handling and conversion-tracking cross-ref to campaign-review"
```

---

## Task 8: Fix reporting-pipeline — Add Inter-Skill Ref, Tooling Gap Note

**Files:**
- Modify: `skills/reporting-pipeline/SKILL.md`

- [ ] **Step 1: Add inter-skill reference to live-report**

After the opening paragraph, add:

```markdown
> [!info] Pipeline Design vs Live Data
> This skill helps **design** reporting pipelines (GAQL → BQ → dbt → dashboards). For pulling **live ad-hoc data** interactively, use `/ad-platform-campaign-manager:live-report` instead.
```

- [ ] **Step 2: Add tooling gap note**

After the "Pipeline Tooling Options" table, add:

```markdown
> [!note] Getting Started Without All Tools
> Not all tools need to be in place from day one. Start with what's available:
> - **No BigQuery yet?** Start with GAQL queries via MCP → export to Sheets
> - **No dbt yet?** Use BigQuery views for transformation — migrate to dbt later
> - **No Data Transfer?** Use gaarf or Cloud Functions for scheduled exports
> - **No Looker Studio?** BigQuery Console + Sheets dashboards work for early reporting
```

- [ ] **Step 3: Commit**

```bash
git add skills/reporting-pipeline/SKILL.md
git commit -m "feat: add inter-skill ref to live-report and tooling gap guidance in reporting-pipeline"
```

---

## Task 9: Fix connect-mcp — Add OAuth Error Handling, Security

**Files:**
- Modify: `skills/connect-mcp/SKILL.md`

- [ ] **Step 1: Add OAuth-flow error handling rows**

In the Troubleshooting table, add these rows after the existing 5 rows:

```markdown
| OAuth consent screen rejected | User clicked "Deny" on the Google consent screen, or the app is not verified and user chose not to proceed | For internal use: set the consent screen to "Internal" (G Workspace only). For external: click through the "unverified app" warning or submit for verification. |
| OAuth redirect URI mismatch | The redirect URI in the `credentials.json` doesn't match the one registered in GCP Console | Go to GCP Console → APIs & Credentials → OAuth 2.0 Client IDs → Authorized redirect URIs — ensure it matches exactly (including trailing slash) |
| `invalid_client` during token exchange | Client ID or secret is incorrect, or the OAuth client was deleted/recreated | Verify `client_id` and `client_secret` in `~/google-ads.yaml` match the GCP Console values; regenerate the client secret if needed |
```

- [ ] **Step 2: Strengthen security section**

Replace the "Security Reminders" section:

```markdown
## Security Reminders

- Never commit credentials to git — verify `.gitignore` includes `google-ads.yaml`, `credentials.json`, and any `*.secret` files
- Use environment variables for tokens when possible
- Review API access permissions regularly
- Use read-only MCP for day-to-day analysis, full-access only when making changes
- **Rotate credentials** if they were ever exposed in logs, screenshots, or conversation history
```

- [ ] **Step 3: Commit**

```bash
git add skills/connect-mcp/SKILL.md
git commit -m "feat: add OAuth error handling and strengthen security reminders in connect-mcp"
```

---

## Task 10: Fix campaign-cleanup — Add $ARGUMENTS Handling

**Files:**
- Modify: `skills/campaign-cleanup/SKILL.md`

- [ ] **Step 1: Add $ARGUMENTS handling**

After the opening line ("Structured process for cleaning up messy or neglected Google Ads accounts."), add:

```markdown
If `$ARGUMENTS` provides a client name or account context, use it throughout the triage report. Otherwise, ask the user to identify the account before starting.
```

- [ ] **Step 2: Commit**

```bash
git add skills/campaign-cleanup/SKILL.md
git commit -m "feat: add $ARGUMENTS handling to campaign-cleanup"
```

---

## Task 11: Fix conversion-tracking — Add Output Template

**Files:**
- Modify: `skills/conversion-tracking/SKILL.md`

- [ ] **Step 1: Add output template**

Before "Key Concepts to Explain When Asked" section, add:

```markdown
## Output: Conversion Tracking Setup Summary

After setting up or troubleshooting, produce a summary:

```
## Conversion Tracking Setup — {{client_name}}

### Conversion Actions
| Action | Type | Counting | Window | Attribution | Value | Status |
|--------|------|----------|--------|-------------|-------|--------|
| {{action_name}} | {{type}} | {{one_or_every}} | {{window_days}}d | {{model}} | {{value_or_dynamic}} | {{active_or_issue}} |

### Implementation
- **Method:** {{gtm_or_sgtm_or_api}}
- **Enhanced conversions:** {{enabled_or_not}}
- **Consent mode:** {{configured_or_not}}
- **GCLID capture:** {{yes_or_not_needed}}

### Verification
- [ ] Conversion Linker firing on all pages
- [ ] Conversion tag firing on correct event
- [ ] Test conversion visible in Google Ads (allow 24h)
- [ ] Google Tag Assistant shows no errors

### Issues Found
{{issues_or_none}}
```
```

- [ ] **Step 2: Commit**

```bash
git add skills/conversion-tracking/SKILL.md
git commit -m "feat: add structured output template to conversion-tracking"
```

---

## Task 12: Redesign live-report — Complete Rewrite

**Files:**
- Rewrite: `skills/live-report/SKILL.md`
- Create: `skills/live-report/references/report-templates.md`

This is the biggest task. live-report scored 62/100 — it reads like a table of contents with no actionable content. The rewrite adds: error handling, GAQL-to-report mapping, MCP tool mapping, sample output, and a companion file.

- [ ] **Step 1: Create the references directory**

```bash
mkdir -p "skills/live-report/references"
```

- [ ] **Step 2: Write the companion reference file**

Create `skills/live-report/references/report-templates.md`:

```markdown
---
title: "Live Report Templates"
date: 2026-04-03
tags:
  - reference
  - reporting
---

# Live Report Templates

%% Companion file for the live-report skill. Contains GAQL queries, MCP tool mappings, and output templates for each report type. %%

## Campaign Performance Summary

### MCP Tools
1. `get_campaign_metrics` — pull campaign-level metrics for a date range
2. `list_campaigns` — get campaign names, types, and statuses

### GAQL Query (if using run_gaql)

%%
```sql
SELECT
  campaign.name,
  campaign.status,
  metrics.cost_micros,
  metrics.impressions,
  metrics.clicks,
  metrics.ctr,
  metrics.conversions,
  metrics.cost_per_conversion,
  metrics.conversions_value,
  metrics.all_conversions
FROM campaign
WHERE campaign.status != 'REMOVED'
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```
%%

### Output Template

```
## Campaign Performance Summary — {{date_range}}

| Campaign | Status | Spend | Impr. | Clicks | CTR | Conv. | CPA | ROAS |
|----------|--------|-------|-------|--------|-----|-------|-----|------|
| {{campaign_name}} | {{status}} | €{{cost}} | {{impressions}} | {{clicks}} | {{ctr}}% | {{conversions}} | €{{cpa}} | {{roas}} |

**Total:** €{{total_spend}} | {{total_conversions}} conversions | €{{avg_cpa}} avg CPA

### Anomalies (>20% change vs previous period)
| Campaign | Metric | Previous | Current | Change |
|----------|--------|----------|---------|--------|
| {{campaign_name}} | {{metric}} | {{previous}} | {{current}} | {{change_pct}}% |
```

---

## Keyword Performance

### MCP Tools
1. `list_keywords` — pull keyword-level data (requires ad_group_id)
2. `list_ad_groups` — enumerate ad groups first
3. `run_gaql` — for custom keyword queries with Quality Score

### GAQL Query

%%
```sql
SELECT
  ad_group.name,
  ad_group_criterion.keyword.text,
  ad_group_criterion.keyword.match_type,
  metrics.cost_micros,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions,
  metrics.cost_per_conversion,
  ad_group_criterion.quality_info.quality_score
FROM keyword_view
WHERE segments.date DURING LAST_30_DAYS
  AND ad_group_criterion.status != 'REMOVED'
ORDER BY metrics.cost_micros DESC
LIMIT 50
```
%%

### Output Template

```
## Keyword Performance — {{date_range}}

### Top Keywords by Cost
| Keyword | Match | Ad Group | Spend | Conv. | CPA | QS |
|---------|-------|----------|-------|-------|-----|----|
| {{keyword}} | {{match_type}} | {{ad_group}} | €{{cost}} | {{conv}} | €{{cpa}} | {{qs}}/10 |

### Wasted Spend (cost > €0, conversions = 0)
| Keyword | Match | Spend | Clicks | Action |
|---------|-------|-------|--------|--------|
| {{keyword}} | {{match_type}} | €{{cost}} | {{clicks}} | Pause / add negative / adjust match |

### High Performers (low CPA, room to grow)
| Keyword | CPA | Conv. | Impr. Share | Action |
|---------|-----|-------|-------------|--------|
| {{keyword}} | €{{cpa}} | {{conv}} | {{impr_share}}% | Increase bid / broaden match |
```

---

## Search Terms Analysis

### MCP Tools
1. `run_gaql` — search_term_view requires GAQL

### GAQL Query

%%
```sql
SELECT
  search_term_view.search_term,
  campaign.name,
  metrics.cost_micros,
  metrics.impressions,
  metrics.clicks,
  metrics.conversions
FROM search_term_view
WHERE segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
LIMIT 100
```
%%

### Output Template

```
## Search Terms Analysis — {{date_range}}

### Converting Search Terms (potential keywords to add)
| Search Term | Campaign | Spend | Conv. | CPA |
|-------------|----------|-------|-------|-----|
| {{term}} | {{campaign}} | €{{cost}} | {{conv}} | €{{cpa}} |

### Irrelevant Search Terms (add as negatives)
| Search Term | Campaign | Spend | Clicks | Why Irrelevant |
|-------------|----------|-------|--------|----------------|
| {{term}} | {{campaign}} | €{{cost}} | {{clicks}} | {{reason}} |
```

---

## Budget Pacing

### MCP Tools
1. `get_campaign_metrics` — current spend for the period
2. `list_campaigns` — daily budget per campaign

### Output Template

```
## Budget Pacing Report — {{date}}

| Campaign | Daily Budget | Today's Spend | MTD Spend | Projected Monthly | Budget Utilization |
|----------|-------------|---------------|-----------|-------------------|-------------------|
| {{campaign}} | €{{daily_budget}} | €{{today_spend}} | €{{mtd_spend}} | €{{projected}} | {{utilization}}% |

### Campaigns Limited by Budget
| Campaign | Lost Impr. Share (Budget) | Recommended Budget |
|----------|--------------------------|-------------------|
| {{campaign}} | {{lost_share}}% | €{{recommended}} |
```

---

## Ad Copy Performance

### MCP Tools
1. `list_ads` — pull ad-level data with RSA asset performance
2. `list_ad_groups` — enumerate ad groups

### Output Template

```
## Ad Copy Performance — {{date_range}}

### Per Ad Group
#### {{ad_group_name}}
| Ad | Impr. | Clicks | CTR | Conv. | Conv. Rate |
|----|-------|--------|-----|-------|------------|
| {{ad_label}} | {{impr}} | {{clicks}} | {{ctr}}% | {{conv}} | {{conv_rate}}% |
```

---

## Device & Geographic Breakdown

### MCP Tools
1. `run_gaql` — requires segments.device and geographic_view

### Output Template

```
## Device & Location Breakdown — {{date_range}}

### By Device
| Device | Spend | Conv. | CPA | Conv. Rate | Action |
|--------|-------|-------|-----|------------|--------|
| {{device}} | €{{cost}} | {{conv}} | €{{cpa}} | {{rate}}% | {{recommendation}} |

### By Location (Top 10)
| Location | Spend | Conv. | CPA | Action |
|----------|-------|-------|-----|--------|
| {{location}} | €{{cost}} | {{conv}} | €{{cpa}} | {{recommendation}} |
```
```

- [ ] **Step 3: Rewrite SKILL.md**

Replace the entire content of `skills/live-report/SKILL.md` with:

```markdown
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
| GAQL query returns `Unrecognized field` | Field name wrong or not available on the queried resource | Check [[../../reference/platforms/google-ads/gaql-reference\|gaql-reference.md]] — field names are resource-specific |
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
```

- [ ] **Step 4: Verify references resolve**

Check that `references/report-templates.md` exists in the skill directory and that all wikilinks in the new SKILL.md resolve to real files.

- [ ] **Step 5: Commit**

```bash
git add skills/live-report/
git commit -m "feat: redesign live-report skill — add GAQL mapping, MCP tools, error handling, report templates"
```

---

## Task 13: Update CHANGELOG

**Files:**
- Modify: `CHANGELOG.md`

- [ ] **Step 1: Read current CHANGELOG**

Read `CHANGELOG.md` to find the latest version entry.

- [ ] **Step 2: Add v1.3.0 entry**

Add at the top of the changelog (after frontmatter):

```markdown
## v1.3.0 — Systemic Skill Quality Fixes (2026-04-03)

Phase 1a of the Strategic Upgrade v2.0. Fixes 6 systemic issues across all 11 skills identified in the full skill review audit (avg 82/100 → 90+).

### Added
- `argument-hint` frontmatter to 9 skills (was missing from all except campaign-setup and keyword-strategy)
- Troubleshooting section to keyword-strategy (5 failure scenarios)
- Output format template to budget-optimizer and conversion-tracking
- Inter-skill cross-references: keyword-strategy → campaign-setup/budget-optimizer/campaign-review; budget-optimizer → campaign-review/campaign-cleanup/conversion-tracking; campaign-review → conversion-tracking; reporting-pipeline → live-report
- Data sufficiency error handling to campaign-review (minimum data threshold, fallback guidance)
- OAuth flow error handling to connect-mcp (3 new troubleshooting rows)
- `$ARGUMENTS` handling to budget-optimizer and campaign-cleanup
- Report templates companion file for live-report (`references/report-templates.md`)

### Changed
- **live-report: complete redesign** — was 271 words / 62 score, now ~600 words / 85+ with GAQL mapping, MCP tool mapping, sample output, error handling (7 scenarios), and proper companion reference file
- `disable-model-invocation` changed to `false` for live-report (was incorrectly `true` for a read-only skill)
- `[bracket]` placeholder syntax replaced with `{{placeholder}}` across all skill output templates
- Security reminders in connect-mcp strengthened (.gitignore verification, credential rotation)

### Fixed
- Dependency map in `skills/CONTEXT.md` — keyword-strategy and budget-optimizer now list all referenced files
- Dependency map in root `CONTEXT.md` — matching fixes for keyword planning and budget/bids routing rows
```

- [ ] **Step 3: Commit**

```bash
git add CHANGELOG.md
git commit -m "docs: add v1.3.0 changelog — systemic skill quality fixes"
```

---

## Verification

After all tasks are complete:

- [ ] **Run a full skill review** — invoke `/project-structure-and-scaffolding-plugin:review-skill` on live-report (target: 85+/100) and budget-optimizer (target: 85+/100)
- [ ] **Check routing consistency** — every wikilink in every SKILL.md should have a matching entry in `skills/CONTEXT.md`
- [ ] **Trigger test** — ask Claude "I want to generate a live report" and verify `live-report` loads (not blocked by `disable-model-invocation`)
- [ ] **Git status** — verify all changes committed, working tree clean
