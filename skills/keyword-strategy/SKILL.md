---
name: keyword-strategy
description: Keyword research, match type strategy, negative keyword planning, and structured keyword list generation. Use when planning keywords for a Google Ads campaign.
argument-hint: "[business-description]"
disable-model-invocation: false
---

# Keyword Strategy

You are helping develop a keyword strategy for a Google Ads campaign. Generate comprehensive, actionable keyword plans.

If `$ARGUMENTS` provides a business description, use it as the starting point. Otherwise, ask the user about their business, products/services, and target audience.

## Reference Material

- **Match type strategy:** [[../../reference/platforms/google-ads/match-types|match-types.md]]
- **Negative keyword lists:** [[../../reference/platforms/google-ads/audit/negative-keyword-lists|negative-keyword-lists.md]]
- **Account structure (for ad group theming):** [[../../reference/platforms/google-ads/account-structure|account-structure.md]]

## Process

### 1. Understand the Business
- What products/services are offered?
- Who is the target audience?
- What geographic area?
- What language(s)?
- Who are the main competitors?
- What is the approximate budget?

### 2. Generate Keyword Ideas

Organize keywords by intent:

**High Intent (Bottom of Funnel):**
- Buy/purchase keywords: "buy [product]", "[product] price", "order [product]"
- Service keywords: "[service] near me", "hire [professional]", "[service] quote"
- Brand + product: "[brand] [product]"

**Medium Intent (Middle of Funnel):**
- Comparison keywords: "best [product]", "[product] vs [competitor]", "[product] reviews"
- Feature keywords: "[product] with [feature]", "[material] [product]"

**Low Intent (Top of Funnel — use cautiously with limited budgets):**
- Informational: "how to [related task]", "what is [concept]"
- Problem-aware: "[problem] solutions", "fix [issue]"

### 3. Group into Ad Group Themes

Each ad group should contain 10-15 tightly themed keywords. Group by:
- Product/service category
- User intent (buy vs research)
- Geographic modifier
- Audience segment

### 4. Assign Match Types

For each keyword, recommend a match type. Follow the strategy in the match types reference:
- **New campaign, limited data:** Phrase + exact match
- **30+ conversions/month:** Add broad match with smart bidding
- **Mature campaign:** Broad + smart bidding for discovery, exact for top terms

### 5. Generate Negative Keywords

Provide a curated negative keyword list:
- **Universal negatives** appropriate for the business (jobs, free, how to, etc.)
- **Industry-specific negatives** based on common irrelevant searches
- **Cross-ad-group negatives** to prevent internal competition

### 6. Output Format

Present the keyword plan as a structured table:

```
AD GROUP: {{theme_name}}
Match Type | Keyword                  | Est. Intent | Notes
Broad      | running shoes            | High        | Core term
Phrase      | "best running shoes"     | Medium      | Comparison
Exact       | [buy running shoes]      | High        | Purchase intent
```

Then a separate negative keyword list:

```
NEGATIVE KEYWORDS (Account Level)
Type    | Keyword
Broad   | jobs
Phrase  | "how to"
Exact   | [free]
```

### Edge Cases

| Situation | Adjustment |
|-----------|------------|
| Very niche business with few keywords | Focus on exact and phrase match only; expand via long-tail variations and related services rather than broad terms |
| Monthly budget under €500 | Stick to high-intent keywords only (bottom of funnel); skip informational/top-of-funnel terms entirely; use exact match to control spend |
| Broad match producing irrelevant traffic | Add the irrelevant terms as negative keywords; if persistent, downgrade to phrase match until enough conversion data exists for smart bidding |
| Multiple locations with different languages | Create separate ad groups (or campaigns) per language; don't mix languages in one ad group |
| Client already has a keyword list | Audit existing list first — check for conflicts, missing negatives, and match type alignment before generating new keywords |

### 7. Expansion Recommendations

Suggest additional keyword opportunities:
- Long-tail variations to explore
- Seasonal keywords to add/pause
- Competitor terms to consider
- Questions people ask (People Also Ask / FAQ keywords)

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| User has no keyword ideas to start from | No familiarity with the industry or product | Ask for the client's website URL, competitor names, or Google Search Console data; use these as seed inputs for brainstorming |
| All suggested keywords have zero estimated volume | Niche business or very specific terms | Broaden to category-level terms, use phrase match to capture long-tail variations, check if the target location is too narrow |
| Keywords generate clicks but no conversions | Intent mismatch — keywords are informational, not transactional | Review the keyword intent tier; move informational keywords to a separate campaign with lower bids or pause them |
| Internal keyword competition across ad groups | Same keyword appears in multiple ad groups | Run a duplicate keyword audit; consolidate into the most relevant ad group; add cross-group negatives for the others |
| Client's existing list conflicts with new strategy | Legacy keywords don't match the proposed ad group themes | Present the gap analysis; recommend phased migration — don't delete old keywords immediately, add new ones alongside and shift budget |

## Next Steps

After keyword research is complete:
- Build the campaign structure → `/ad-platform-campaign-manager:campaign-setup`
- Set budget and bids for the keyword plan → `/ad-platform-campaign-manager:budget-optimizer`
- Review existing campaigns against the new keyword strategy → `/ad-platform-campaign-manager:campaign-review`
