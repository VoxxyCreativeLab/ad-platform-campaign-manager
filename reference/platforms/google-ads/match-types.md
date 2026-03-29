---
title: Google Ads Keyword Match Types
date: 2026-03-28
tags:
  - reference
  - google-ads
---

# Google Ads Keyword Match Types

## The Three Match Types

### Broad Match (default)
**Syntax:** `keyword` (no symbols)

Matches searches related to your keyword, including synonyms, related searches, and implied intent.

**Example:** `running shoes` matches "buy sneakers online", "best jogging footwear"

**When to use:** With smart bidding + solid conversion data. Maximum reach.

### Phrase Match
**Syntax:** `"keyword"`

Matches searches that include the meaning of your keyword in the specified order.

**Example:** `"running shoes"` matches "buy running shoes online", "running shoes sale"

**When to use:** More control than broad, more reach than exact. Good for testing.

### Exact Match
**Syntax:** `[keyword]`

Matches searches with the same meaning/intent. Allows close variants (plurals, misspellings).

**Example:** `[running shoes]` matches "running shoes", "shoes for running"

**When to use:** High-value terms, brand terms, top performers.

## Strategy by Campaign Maturity

| Stage | Approach |
|-------|----------|
| New, limited data | Phrase + exact. Gather conversion data first. |
| 30+ conversions/month | Add broad match with smart bidding. |
| Mature, rich data | Primarily broad + smart bidding, exact for top terms. |

## Negative Keywords

Prevent ads from showing for irrelevant searches.

| Type | Syntax | Blocks |
|------|--------|--------|
| Negative broad | `keyword` | Queries containing ALL terms (any order) |
| Negative phrase | `"keyword"` | Queries containing exact phrase |
| Negative exact | `[keyword]` | Queries matching exactly |

**Important:** Negative keywords do NOT include close variants. Add singular + plural forms.

### Best Practices
1. Review search terms weekly
2. Build shared negative keyword lists at account level
3. Common negatives: "jobs", "careers", "free", "how to", "what is"
4. Use cross-campaign negatives to prevent ad group competition
