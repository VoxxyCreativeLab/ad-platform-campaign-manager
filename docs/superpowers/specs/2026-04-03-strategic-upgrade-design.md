---
title: "Design — Strategic Upgrade v2.0"
date: 2026-04-03
tags:
  - mwp
  - design
  - strategy
---

# Design — Strategic Upgrade v2.0

**Status:** Phase 1 ✅ Complete (1a v1.3.0 + 1b v1.4.0 + 1c v1.5.0) — Phase 2 next
**Approach:** Phased releases (3 phases)
**Driver:** Practice toolkit — building campaign strategy capability alongside existing tracking expertise
**Companion doc:** [[2026-04-03-skill-review-audit]] — full scored review of all 11 skills (avg 82/100)

---

## Problem Statement

The ad-platform-campaign-manager plugin excels at *execution* (tracking pipeline, campaign setup, feed optimization) but lacks *strategic guidance*. It cannot answer: "What should I do differently for a B2B SaaS account with €3K/mo vs an e-commerce account with €25K/mo?" Every skill gives the same advice regardless of account context.

### Audit Findings (2026-04-03)

**Current state:**
- 11 skills (9 knowledge-based, 2 MCP-powered)
- 2 agents (campaign-reviewer, tracking-auditor)
- 34 reference files
- Tracking bridge: 9/10 quality (plugin's differentiator)
- Google Ads core: 8/10 (comprehensive but strategy-blind)
- PMax: 9/10 (exceptional depth)

**Strengths:**
- Tracking bridge is unique and battle-tested (6 files, real Google patterns)
- Execution detail is high (step-by-step, specs, examples)
- Accuracy is current (fact-checked against 2025-2026 Google Ads changes)

**Weaknesses:**
- No account-specific strategy (vertical, maturity, budget all ignored)
- No targeting/audience framework
- No attribution modeling guide
- No remarketing segmentation
- No seasonal planning
- Existing skills have workflow dead-ends (Finding #3) and lecture instead of asking (Finding #4)

**30 specific missing topics identified** across 9 categories — see Appendix A.

---

## Core Concept: Tiered Account Profile Framework

Every strategic recommendation flows through the account profile. Three tiers avoid combinatorial explosion.

### Tier 1 — Core Axes (define the account type)

Asked first. Together they select the broad strategy archetype.

| Axis | Options |
|------|---------|
| **Vertical** | E-commerce, Lead Gen, B2B SaaS, Local Services |
| **Account Maturity** | Cold start (0-3mo), Early data (3-6mo), Established (6-18mo), Mature (18+mo) |
| **Budget Tier** | Micro (<€1K/mo), Small (€1-5K/mo), Medium (€5-25K/mo), Large (€25K+/mo) |

~64 combinations, collapsible to ~15-20 distinct strategy archetypes.

### Tier 2 — Strategic Modifiers (refine within the archetype)

Each modifier independently adjusts specific recommendations.

| Modifier | Options | What It Changes |
|----------|---------|-----------------|
| **Tracking Maturity** | Basic (GA4) / Intermediate (GTM + enhanced conv) / Advanced (sGTM + BQ + offline) | What bid strategies and attribution are *possible* |
| **Conversion Complexity** | Single-step (purchase) / Multi-step (lead → MQL → SQL → close) | Attribution model, offline imports, value definition |
| **Geographic Scope** | Local / National / Multi-country | Campaign structure, language, currency, location bids |
| **Competition Level** | Niche / Moderate / Saturated | Keyword strategy, CPC expectations, differentiation |

### Tier 3 — Operational Context (shapes workflow, not strategy)

| Context | Options | What It Changes |
|---------|---------|-----------------|
| **Management Model** | In-house / Agency / Freelancer | Reporting cadence, approvals, access, communication |
| **Feed Presence** | Yes (Merchant Center) / No | Available campaign types (Shopping, feed-only PMax) |
| **Business Model** | One-time / Subscription / Recurring service | LTV calculation, value-based bidding, conversion definition |

### Tier Interaction Flow

1. **Core axes** → select strategy archetype
2. **Modifiers** → adjust specific recommendations within archetype
3. **Context** → shape execution details

---

## Delivery Architecture

The strategic layer is delivered through four mechanisms:

1. **Reference docs** (knowledge base) — foundational knowledge each topic can draw from
2. **Strategy skill** (guided planning) — interactive account profiling and tailored recommendations
3. **Enhanced existing skills** (account-aware guidance) — current skills adapt based on profile
4. **Strategy agent** (autonomous analysis) — MCP-powered account analysis and strategy generation

---

## Skill Review Findings (2026-04-03)

Full review: [[2026-04-03-skill-review-audit]]

**Average score: 82/100** — pmax-guide (90) is the gold standard. live-report (62) needs redesign.

### Systemic Issues (All or Most Skills)

1. **Missing `argument-hint`** — 9 of 11 skills lack it
2. **No `{{placeholder}}` template syntax** — all 11 use `[brackets]` instead
3. **Missing inter-skill cross-references** — 6 of 11 skills are isolated islands
4. **Dependency map drift** — 2 skills reference files not listed in CONTEXT.md
5. **No companion files** — all 11 are single SKILL.md (acceptable at current size, monitor)
6. **Inconsistent $ARGUMENTS handling** — 5 of 11 don't document argument behavior

### Priority Skill Fixes

| Tier | Skill | Score | Fix Needed |
|------|-------|-------|------------|
| Critical | live-report | 62 | Redesign: add error handling, GAQL mapping, sample output, reconsider disable flag |
| Significant | budget-optimizer | 76 | Add argument-hint, $ARGUMENTS, output format, inter-skill refs, fix dependency map |
| Significant | keyword-strategy | 82 | Add troubleshooting, inter-skill refs, fix dependency map |
| Significant | campaign-review | 82 | Add inter-skill ref to conversion-tracking, error handling for insufficient data |
| Polish | 7 remaining skills | 82-90 | Mostly argument-hint + placeholder syntax fixes |

### Key Insight: Skill Flow Graph

Currently each skill is an island. The upgrade should create a clear flow:

```
account-strategy (new) → campaign-setup → keyword-strategy → budget-optimizer
                       → conversion-tracking → campaign-review
                       → pmax-guide (if feed present)
```

---

## Phase 1 — Strategic Foundation

**Goal:** Build the reference doc knowledge base + fix existing skill issues (systemic + strategic).

### Phase 1a — Systemic Skill Fixes (Mechanical)

Fix the 6 systemic issues across all 11 skills before adding strategy content. These are non-creative, mechanical fixes:

1. Add `argument-hint` to 9 skills
2. Replace `[bracket]` placeholders with `{{placeholder}}` syntax across all 11
3. Add inter-skill cross-references to 6 skills
4. Fix dependency maps in skills/CONTEXT.md and root CONTEXT.md for 2 skills
5. Add $ARGUMENTS handling to 5 skills
6. Redesign live-report: add troubleshooting table, GAQL query per report type, sample output table, MCP tool mapping, `references/report-templates.md` companion file, change `disable-model-invocation` to `false`

### Phase 1b — New Reference Documents (8 files)

All placed in `reference/platforms/google-ads/strategy/`.

| # | File | Purpose |
|---|------|---------|
| 1 | `account-profiles.md` | Framework definition. All 10 dimensions, 3 tiers, ~15-20 strategy archetypes, "pick your profile" decision tree |
| 2 | `account-maturity-roadmap.md` | Timeline guide: campaigns, bidding, data expectations, graduation criteria per maturity stage |
| 3 | `vertical-ecommerce.md` | E-commerce playbook: feed-centric, ROAS-driven, Shopping/PMax, seasonal patterns, benchmarks |
| 4 | `vertical-lead-gen.md` | Lead gen playbook: CPA-driven, form optimization, call tracking, lead quality vs volume |
| 5 | `vertical-b2b-saas.md` | B2B SaaS playbook: long cycles, offline conversions, low volume/high value, content funnels |
| 6 | `vertical-local-services.md` | Local services playbook: location targeting, call-only, Google Business Profile, radius bidding |
| 7 | `targeting-framework.md` | Audience & targeting strategy: Customer Match, in-market, affinity, remarketing tiers, layered targeting, seed sizing |
| 8 | `attribution-guide.md` | Attribution & measurement: models, cross-channel, GA4 integration, true CAC calculation |

### Enhanced Existing Reference Docs (3 files)

| File | Enhancement |
|------|-------------|
| `bidding-strategies.md` | Add "Which strategy by account profile" section + learning period tactics + scaling guidance |
| `account-structure.md` | Add maturity-based structure recommendations + budget-tier guidance |
| `campaign-types.md` | Add vertical-specific campaign mix recommendations + decision tree by profile |

### Phase 1c — Skill Fixes (Findings #3, #4 + Strategy Hooks)

%% Phase 1c adds the *hooks* — routing, Socratic patterns, and initial references to account-profiles.md. Phase 2 does the full strategy-aware rewrite once the account-strategy skill exists. %%

| Skill | Fix #3 (Dead-ends) | Fix #4 (Socratic) | Strategy Hook |
|-------|--------------------|--------------------|---------------|
| `campaign-setup` | Add "next step" routing at end (→ keyword-strategy or conversion-tracking) | Convert lecture sections to profile-building questions | Reference account-profiles.md, ask vertical/maturity early |
| `keyword-strategy` | Link to budget-optimizer at end | Add questions about competition level, conversion complexity | Reference account-profiles.md for match type progression |
| `budget-optimizer` | Link to campaign-review for validation | Add maturity-aware questioning | Reference account-profiles.md for budget-tier targets |
| `campaign-cleanup` | Route to campaign-setup for rebuilding | Add diagnostic questions before prescribing | Reference account-profiles.md for triage priority |

### External Research Approach

For each new reference doc:
1. **Research** — Pull from authoritative sources (Google Skillshop, Search Engine Land, PPC Hero, WordStream, Optmyzr, Stape.io, Simo Ahava, Analytics Mania)
2. **Distill** — Write in the plugin's voice (tracking-specialist-friendly)
3. **Link** — "Further reading" section with curated external URLs
4. **Fact-check markers** — `%%fact-check: [feature] — verified [date]%%` for claims that depend on Google Ads features

---

## Phase 2 — Account Strategy Skill + Skill Enhancement

**Goal:** Build the interactive strategy layer on top of the Phase 1 knowledge base.

### New Skill: `account-strategy`

Interactive skill that:
1. Asks Tier 1 questions (vertical, maturity, budget)
2. Asks relevant Tier 2 modifiers
3. Notes Tier 3 operational context
4. Generates a tailored strategy document referencing the appropriate reference docs
5. Routes to the right next skill (campaign-setup, keyword-strategy, etc.)

### Enhanced Existing Skills (strategy-aware)

| Skill | Enhancement |
|-------|-------------|
| `campaign-setup` | Ask for account profile early; adapt campaign type recommendations, bidding, and structure accordingly |
| `keyword-strategy` | Adjust match type strategy, keyword volume, and competition approach based on profile |
| `budget-optimizer` | Use maturity + budget tier to set realistic targets; vertical-specific ROAS/CPA benchmarks |
| `pmax-guide` | Route feed-only vs full PMax based on feed presence; adjust asset strategy by vertical |
| `conversion-tracking` | Adjust tracking recommendation by tracking maturity; suggest appropriate conversion complexity setup |

---

## Phase 3 — Strategy Agent + Remaining Gaps

**Goal:** Autonomous strategy generation from live data + fill remaining reference gaps.

### New Agent: `strategy-advisor`

MCP-powered agent that:
1. Reads live account data (campaigns, conversions, spend, structure)
2. Infers account profile from data (vertical from conversion types, maturity from age/data volume, budget from spend)
3. Generates a strategy document with specific recommendations
4. Compares current state to ideal state for the inferred profile
5. Prioritizes recommendations by impact

### Remaining Reference Docs

| File | Topic |
|------|-------|
| `seasonal-planning.md` | Q4 budgeting, holiday calendars, bid multiplier examples |
| `remarketing-strategies.md` | Audience segments by recency/behavior/value, dynamic remarketing, frequency capping |
| `ad-testing-framework.md` | RSA testing, landing page A/B, statistical significance |
| `bid-adjustment-framework.md` | Device, location, audience, time-of-day adjustments |
| `shopping-feed-strategy.md` | Feed segmentation, margin-based bidding, inventory sync |

### Remaining Skill Enhancements

- `campaign-review` / `campaign-review-mcp` — profile-aware audit scoring
- `reporting-pipeline` — profile-aware report templates
- `ads-scripts` — profile-aware script recommendations

---

## Appendix A: Full Gap Analysis (30 Topics)

### Strategic / Account-Level
1. Account maturity roadmap
2. Vertical-specific strategies
3. Competitive analysis
4. Account growth trajectories

### Audience & Targeting
5. Audience building framework
6. Layered targeting strategy
7. Remarketing segmentation

### Landing Page & Conversion Optimization
8. Landing page checklist for ads
9. A/B testing framework for ads
10. Form optimization

### Seasonality & Scheduling
11. Seasonal campaign planning
12. Ad schedule strategy

### Attribution & Analysis
13. Attribution modeling
14. Multi-touch analysis
15. CAC (Customer Acquisition Cost) analysis

### Shopping & Feed Specifics
16. Feed segmentation strategy
17. Margin-based bidding
18. Inventory synchronization

### Advanced Bidding & Optimization
19. Bid adjustment framework
20. Budget allocation between campaigns
21. ROAS target setting

### Ad Creative & Testing
22. Ad copy best practices by vertical
23. RSA testing
24. Ad rotation & optimization

### Remarketing
25. Remarketing audience strategies
26. Dynamic remarketing
27. Frequency capping

### Technical & Tracking Advanced
28. Click fraud detection
29. Cross-domain tracking issues
30. Safari & iOS tracking changes
