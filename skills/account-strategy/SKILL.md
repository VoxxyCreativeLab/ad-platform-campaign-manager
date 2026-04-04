---
name: account-strategy
description: Interactive account profiling — walks through 10 dimensions, maps to strategy archetype, generates tailored strategy document with campaign mix, bid roadmap, tracking upgrade path, and budget allocation.
argument-hint: "[new-client or account-context]"
disable-model-invocation: false
---

# Account Strategy

You are building a complete strategic profile for a Google Ads account. Walk the user through all 10 profile dimensions, map to a strategy archetype, and generate a tailored strategy document. The user is a tracking specialist — teach campaign strategy concepts clearly while you profile.

This skill is the **entry point** for any new client engagement or strategic review. The strategy document it produces feeds into every downstream skill.

If `$ARGUMENTS` provides account context (client name, vertical, budget, etc.), use it to pre-fill known dimensions and skip questions you can already answer.

## Reference Material

- **Account profiles and archetypes:** [[../../reference/platforms/google-ads/strategy/account-profiles|account-profiles.md]]
- **Maturity progression:** [[../../reference/platforms/google-ads/strategy/account-maturity-roadmap|account-maturity-roadmap.md]]
- **E-commerce playbook:** [[../../reference/platforms/google-ads/strategy/vertical-ecommerce|vertical-ecommerce.md]]
- **Lead gen playbook:** [[../../reference/platforms/google-ads/strategy/vertical-lead-gen|vertical-lead-gen.md]]
- **B2B SaaS playbook:** [[../../reference/platforms/google-ads/strategy/vertical-b2b-saas|vertical-b2b-saas.md]]
- **Local services playbook:** [[../../reference/platforms/google-ads/strategy/vertical-local-services|vertical-local-services.md]]
- **Targeting framework:** [[../../reference/platforms/google-ads/strategy/targeting-framework|targeting-framework.md]]
- **Attribution guide:** [[../../reference/platforms/google-ads/strategy/attribution-guide|attribution-guide.md]]
- **Campaign types:** [[../../reference/platforms/google-ads/campaign-types|campaign-types.md]]
- **Bidding strategies:** [[../../reference/platforms/google-ads/bidding-strategies|bidding-strategies.md]]

## Step 0: Determine Context

Before profiling, establish what you're working with:

- **New client engagement?** Start from scratch — ask all 10 dimensions.
- **Existing account review?** Ask for current campaign structure and performance data — many dimensions can be inferred from what's running.
- **Strategic pivot?** The account exists but strategy needs rethinking — profile fresh, compare to current state.

If the user has already run this skill before and has a strategy document, ask: "Has anything changed since your last profile? If so, what?" Update only the changed dimensions.

## Step 1: Tier 1 — Core Axes

These three questions determine the strategy archetype. Ask them one at a time. Do NOT present multiple-choice lists — ask open-ended questions and map the answers yourself.

### 1. Vertical

Ask: **"What does this business sell, and who buys it?"**

Listen for the answer and map to one of:
- **E-commerce** — sells physical products online, ROAS-driven, product feed is the primary lever
- **Lead Gen** — generates leads (form fills, calls) for a sales team, CPA-driven, lead quality matters more than volume
- **B2B SaaS** — sells software subscriptions, long sales cycles (30-180 days), low conversion volume, high deal values
- **Local Services** — geographically constrained service business, calls and bookings are conversions

State your mapping: "Based on what you've described, this is a **[vertical]** account. That means [1-sentence implication]. Does that match?"

If the business doesn't fit neatly (e.g., B2B e-commerce, SaaS with physical product), explain which vertical model is the closest fit and why. Hybrid profiles are rare but valid — note both and weight recommendations toward the primary model.

### 2. Account Maturity

Ask: **"How long has this Google Ads account been running, and roughly how many conversions per month?"**

Map to:
- **Cold start** (0-3 months, 0-15 conv/mo) — learning phase, manual bidding, limited campaign types
- **Early data** (3-6 months, 15-30 conv/mo) — can test Smart Bidding, cautious expansion
- **Established** (6-18 months, 30-50+ conv/mo) — Smart Bidding viable, full campaign mix possible
- **Mature** (18+ months, 50+ conv/mo reliably) — value-based bidding, full optimization

State the mapping with reasoning: "With [X] months running and [Y] conversions/month, this account is at the **[stage]** stage. That means [what's viable and what isn't]."

### 3. Budget Tier

Ask: **"What's the approximate monthly Google Ads budget?"**

Map to:
- **Micro** (< EUR 1K/mo) — 1 campaign max, no PMax, no testing room
- **Small** (EUR 1-5K/mo) — 2-3 campaigns, basic testing, PMax marginal
- **Medium** (EUR 5-25K/mo) — full campaign mix, proper testing, PMax viable
- **Large** (EUR 25K+/mo) — aggressive testing, multiple PMax campaigns, scripts and automation

### Archetype Mapping

After all three Tier 1 answers, look up the archetype in the Archetype Quick-Reference Matrix in [[../../reference/platforms/google-ads/strategy/account-profiles|account-profiles.md]].

State it explicitly:

> "Based on your answers, this is **Archetype #[X]: [Name]** — [1-2 sentence summary of what this archetype means for strategy]. Let me continue with a few more questions to fine-tune the recommendations."

## Step 2: Tier 2 — Strategic Modifiers

These refine recommendations within the archetype. Ask only the modifiers that are relevant — not all 4 for every account.

### 4. Tracking Maturity

Ask: **"What tracking is currently in place? Just GA4, or do you have GTM, enhanced conversions, server-side tagging?"**

Map to:
- **Basic** (GA4 only) — limited Smart Bidding signal, last-click attribution
- **Intermediate** (GTM + enhanced conversions) — Smart Bidding viable, data-driven attribution
- **Advanced** (sGTM + BigQuery + offline imports) — value-based bidding, profit-based optimization

This is where Jerry's expertise is the lever. Note: "Tracking maturity at [level]. Upgrading to [next level] would unlock [specific capabilities]."

### 5. Conversion Complexity

Ask only if the vertical is Lead Gen or B2B SaaS: **"What counts as a conversion for this business — a single action like a form fill, or a multi-step process like lead → qualified → closed?"**

- **Single-step** — standard tracking, Smart Bidding works out of the box
- **Multi-step** — offline imports needed, micro-conversions as interim proxy, ascending value assignment

### 6. Geographic Scope

Ask: **"Where are the customers — local area, national, or multiple countries?"**

- **Local** — radius targeting, call tracking essential, lower budgets viable
- **National** — standard geo, regional bid adjustments
- **Multi-country** — separate campaigns per country-language, multiplied budget

### 7. Competition Level

Ask: **"How competitive is this market? Do you know the typical CPCs, or how many competitors show up on search results?"**

- **Niche** (CPCs < EUR 1, few competitors) — broader match types viable, lower budgets go further
- **Moderate** (CPCs EUR 1-5, 3-4 competitors) — standard playbook
- **Saturated** (CPCs EUR 5+, 5+ competitors) — exact/phrase critical, Quality Score is king

## Step 3: Tier 3 — Operational Context

Lighter touch — these shape workflow, not strategy. Ask briefly.

### 8. Management Model

Ask: **"Who manages the ads day-to-day — in-house team, agency, or freelancer?"**

### 9. Feed Presence

Ask: **"Does the business have a Merchant Center product feed?"**

If the vertical is not e-commerce, this is typically "No" — confirm briefly.

### 10. Business Model

Ask: **"Is this one-time purchases, subscriptions, or recurring services?"**

## Step 4: Generate Strategy Document

With all 10 dimensions gathered, generate a structured strategy document. Consult the archetype tables and vertical playbooks from the reference material.

### Output Format

```
## Account Strategy — {{client_name}}

### Profile Summary

| Dimension | Value | Notes |
|-----------|-------|-------|
| Vertical | {{vertical}} | |
| Account Maturity | {{stage}} ({{months}} months, {{conv}}/mo) | |
| Budget Tier | {{tier}} (EUR {{budget}}/mo) | |
| Tracking Maturity | {{level}} | |
| Conversion Complexity | {{type}} | |
| Geographic Scope | {{scope}} | |
| Competition Level | {{level}} | |
| Management Model | {{model}} | |
| Feed Presence | {{yes/no}} | |
| Business Model | {{model}} | |

**Archetype: #{{X}} — {{Name}}**

{{2-3 sentence archetype summary from account-profiles.md}}

### Recommended Campaign Mix

| Campaign | Type | Purpose | Budget % | Priority |
|----------|------|---------|----------|----------|
| {{campaign_1}} | {{type}} | {{purpose}} | {{pct}}% | {{1-n}} |
| ... | | | | |

Total: EUR {{budget}}/mo

### Bid Strategy Roadmap

| Current Stage | Current Strategy | Next Strategy | Graduate When |
|---------------|-----------------|---------------|---------------|
| {{stage}} | {{current_bid}} | {{next_bid}} | {{trigger}} |

{{Explain the full maturity progression path for this account}}

### Tracking Upgrade Path

| Current Level | Next Upgrade | What It Unlocks | Effort |
|---------------|-------------|-----------------|--------|
| {{current}} | {{next}} | {{capabilities}} | {{estimate}} |

{{If tracking is already Advanced, note what to maintain/optimize instead}}

### Budget Allocation

| Campaign | Monthly | Daily | Notes |
|----------|---------|-------|-------|
| {{campaign_1}} | EUR {{monthly}} | EUR {{daily}} | |
| ... | | | |
| **Total** | **EUR {{budget}}** | **EUR {{daily_total}}** | |

### Vertical-Specific Notes

{{Pull 3-5 key recommendations from the relevant vertical playbook}}

### Key Risks

{{List 2-4 archetype-specific risks with mitigations}}

Examples:
- Cold start + PMax desire → "PMax needs 30+ conv/month — start with Search"
- B2B SaaS without offline imports → "Smart Bidding is flying blind on a 90-day cycle"
- Micro budget + multiple campaigns → "Budget too thin to split"
- Saturated market + broad match → "CPCs will spike without tight match control"
```

## Step 5: What to Do Next

Based on the strategy document, route to the next skill. Recommend based on what's missing or what the highest-priority action is:

| Situation | Next Skill |
|-----------|-----------|
| New account, no campaigns built | `/ad-platform-campaign-manager:campaign-setup` |
| Keywords not yet planned | `/ad-platform-campaign-manager:keyword-strategy` |
| Conversion tracking not set up or needs upgrade | `/ad-platform-campaign-manager:conversion-tracking` |
| Inheriting a messy existing account | `/ad-platform-campaign-manager:campaign-cleanup` |
| Budget needs detailed allocation or bid strategy | `/ad-platform-campaign-manager:budget-optimizer` |
| Has feed, ready for PMax setup | `/ad-platform-campaign-manager:pmax-guide` |
| Needs reporting pipeline or dashboards | `/ad-platform-campaign-manager:reporting-pipeline` |
| Existing campaigns need audit | `/ad-platform-campaign-manager:campaign-review` |

Tell the user which skill to run next and why — based on the profile, not just a generic list. For example: "Your tracking is at Basic level, which is the biggest bottleneck for this archetype. I'd recommend running `/ad-platform-campaign-manager:conversion-tracking` next to upgrade to Intermediate — that unlocks Smart Bidding."
