---
title: "Start Here — Ad Platform Campaign Manager"
tags:
  - mwp
  - onboarding
---

# Start Here — Ad Platform Campaign Manager

Welcome. This is your entry point.

---

## What This Plugin Does

A Claude Code plugin that provides campaign management guidance for Google Ads — bridging tracking infrastructure expertise with campaign operations.

---

## How the Plugin Is Organized

1. **[[reference/CONTEXT|Reference]]** (`reference/`) — Domain knowledge base: Google Ads fundamentals, tracking-bridge docs (GTM/sGTM/BQ), reporting patterns, PMax (including feed-only PMax), audit checklists, Ads Scripts API
2. **[[skills/CONTEXT|Skills]]** (`skills/`) — 13 interactive guidance tools that load reference docs on demand (account strategy, campaign setup, keyword strategy, conversion tracking, PMax, reporting, ad copy, etc.)
3. **[[agents/CONTEXT|Agents]]** (`agents/`) — 3 autonomous agents (campaign reviewer, tracking auditor, strategy advisor) that produce scored reports

Reference feeds into both Skills and Agents. Skills and Agents are independent of each other.

---

## Where Things Live

| I need to... | Go here |
|---|---|
| Profile an account and build strategy | `/ad-platform-campaign-manager:account-strategy` |
| Set up a new campaign | `/ad-platform-campaign-manager:campaign-setup` |
| Plan keywords | `/ad-platform-campaign-manager:keyword-strategy` |
| Set up conversion tracking | `/ad-platform-campaign-manager:conversion-tracking` |
| Build a reporting pipeline | `/ad-platform-campaign-manager:reporting-pipeline` |
| Audit a campaign | `/ad-platform-campaign-manager:campaign-review` |
| Work with PMax | `/ad-platform-campaign-manager:pmax-guide` |
| Optimize budget/bids | `/ad-platform-campaign-manager:budget-optimizer` |
| Browse Ads Scripts | `/ad-platform-campaign-manager:ads-scripts` |
| Write ad copy in any language | `/ad-platform-campaign-manager:ad-copy` |
| Clean up messy account | `/ad-platform-campaign-manager:campaign-cleanup` |
| Validate account against strategy | `strategy-advisor` agent |
| Understand task routing | [[CONTEXT]] |
| See what's in progress | [[PLAN]] |
| Check available plugins/tools | [[_config/ecosystem|_config/ecosystem.md]] |

---

## The Golden Rule

> [!important] Stop and Review
> After each skill or agent produces output, **stop and review it**. Edit what needs editing before acting on it. The guidance is only as good as the context you provide.

---

## If Something Looks Wrong

Check the skill's reference files via [[CONTEXT]]. If output is consistently off, the fix is usually in the reference docs (`reference/`) — not in patching the output.
