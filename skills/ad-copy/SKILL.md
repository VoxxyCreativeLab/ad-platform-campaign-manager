---
name: ad-copy
description: "Multilingual ad copy generator — RSA headlines/descriptions, extensions (sitelinks, callouts, structured snippets), PMax text assets, and Shopping feed titles. Character-counted, language-aware, research-backed."
argument-hint: "[language or campaign-type]"
disable-model-invocation: false
---

# Ad Copy Generator

You are helping generate production-ready, character-counted Google Ads copy in any language. The user is a tracking/campaign specialist, not a copywriter — guide them through copy that follows best practices and fits within character limits.

If `$ARGUMENTS` specifies a language (e.g., "swedish") or campaign type (e.g., "RSA"), skip the corresponding input-gathering step and proceed directly.

## Reference Material

- **Ad copy generation rules & CTA libraries:** [[../../reference/platforms/google-ads/ad-copy-framework|ad-copy-framework.md]]
- **RSA testing framework & headline categories:** [[../../reference/platforms/google-ads/ad-testing-framework|ad-testing-framework.md]]
- **Extension types & specifications:** [[../../reference/platforms/google-ads/ad-extensions|ad-extensions.md]]
- **PMax text asset specifications:** [[../../reference/platforms/google-ads/pmax/asset-requirements|asset-requirements.md]]
- **Shopping feed title formulas:** [[../../reference/platforms/google-ads/shopping-feed-strategy|shopping-feed-strategy.md]]
- **Account profiles (maturity context):** [[../../reference/platforms/google-ads/strategy/account-profiles|account-profiles.md]]

## Process

### Step 0: Establish Context

If this is part of an ongoing session where the account profile is already known, confirm: "I see we're working on [account name]. Continuing with the established profile."

If no profile is established, ask:
- "What business vertical? (e-commerce, lead gen, SaaS, local services)"
- "Account maturity? (new, 3-6 months, established, mature)"
- "Budget tier? (< EUR 500/mo, EUR 500-2000, EUR 2000-10000, > EUR 10000)"

This determines the creative approach — new accounts need conservative, proven copy; mature accounts can experiment.

### Step 1: Language & Market

Ask (unless provided via `$ARGUMENTS`):
- "What language should the ad copy be in?"
- "What market/country are you targeting?"

After establishing language:

1. Load the language-specific section from [[../../reference/platforms/google-ads/ad-copy-framework|ad-copy-framework.md]]
2. Confirm the address form: "For [language], the standard is [du/Sie/je/you]. Should I use this, or does the brand prefer a different register?"
3. If the language is **Swedish, Dutch, German, or Finnish** — warn: "This language uses compound words that can eat into the 30-character headline limit. I'll calculate character counts for every element and suggest compound breaks where needed."

### Step 2: Campaign Type Selection

Ask: "What type of ad copy do you need?"

| Option | What Gets Generated |
|---|---|
| **Search RSA** | 15 headlines (30 chars) + 4 descriptions (90 chars) + display URL paths (15 chars) |
| **Extensions** | 4 sitelinks (25+35+35 chars) + 4-6 callouts (25 chars) + 1-2 structured snippets (25 chars per value) |
| **PMax text assets** | 5 headlines (30 chars) + 5 long headlines (90 chars) + 5 descriptions (90 chars) |
| **Shopping feed titles** | Title formula + 5-10 product title examples |
| **All of the above** | Full copy package for a campaign launch |

If the user selects multiple types, generate them in the order listed above.

### Step 3: Business & Copy Inputs

Gather these inputs (skip any already known from context):

| Input | Why It Matters | Example |
|---|---|---|
| **Brand name** | Consumes fixed chars in headlines. Calculate: `30 - [brand length] - 1 = remaining chars` | "VaxterOnline" (12 chars → 17 remaining) |
| **Product categories** | Drive product/service headlines and structured snippets | "Indoor plants, outdoor plants, succulents, pots" |
| **Top 3-5 target keywords** | Headlines should include or reflect these terms | "[vaxteronline], [köpa växter online], [inomhusväxter]" |
| **USPs / differentiators** | What competitors can't say | "500+ varieties, Swedish-grown, carbon-neutral shipping" |
| **Shipping / delivery offer** | Major trust signal in e-commerce | "Free shipping over EUR 50, next-day in Stockholm" |
| **Returns policy** | Risk reduction headline | "30-day easy returns" |
| **Price points** | For offer/price headlines | "Plants from EUR 9.99" |
| **Existing CTAs the client uses** | Brand consistency | Check website, existing ads |
| **Compliance / legal requirements** | Pinning decisions | Disclaimers, regulated industry terms |

### Step 4: Research Phase (Recommended for Non-English Markets)

> [!tip] When to Research
> If you are generating copy in a language where the operator does not have native-speaker validation available, run this research step. It validates and extends the embedded CTA library with market-specific phrasing.

1. **Web search** for: `[language] e-commerce Google Ads copy examples`, `[language] CTA phrases`, `[market] online advertising conventions`
2. **Validate embedded CTAs** from ad-copy-framework.md against current market usage
3. **Identify market-specific conventions** not in the framework (e.g., seasonal phrases, cultural references)
4. **Check competitor ads** if possible: search the target keywords on Google in the target market and note the phrasing patterns

If research does not find additional CTAs beyond the embedded library, proceed with the embedded CTAs — they are sufficient for production-quality copy.

### Step 5: Generate Copy

Generate all requested copy types. **Every text element must show its character count in `(XX/YY chars)` format.**

#### Search RSA Output Format

```markdown
## Search RSA: [Campaign Name]

### Headlines (15)

| # | Category | Headline | Chars |
|---|----------|----------|-------|
| H1 | Brand | [headline text] | XX/30 |
| H2 | Brand | [headline text] | XX/30 |
| H3 | Product | [headline text] | XX/30 |
| H4 | Product | [headline text] | XX/30 |
| H5 | Product | [headline text] | XX/30 |
| H6 | Product | [headline text] | XX/30 |
| H7 | Benefit | [headline text] | XX/30 |
| H8 | Benefit | [headline text] | XX/30 |
| H9 | CTA | [headline text] | XX/30 |
| H10 | CTA | [headline text] | XX/30 |
| H11 | CTA | [headline text] | XX/30 |
| H12 | Social proof | [headline text] | XX/30 |
| H13 | Offer/Price | [headline text] | XX/30 |
| H14 | Urgency | [headline text] | XX/30 |
| H15 | Differentiator | [headline text] | XX/30 |

### Descriptions (4)

| # | Purpose | Description | Chars |
|---|---------|-------------|-------|
| D1 | Value prop + CTA | [description text] | XX/90 |
| D2 | Trust + proof | [description text] | XX/90 |
| D3 | Offer/differentiator | [description text] | XX/90 |
| D4 | Category/seasonal | [description text] | XX/90 |

### Display URL Paths

| Path 1 | Path 2 |
|--------|--------|
| [path] (XX/15) | [path] (XX/15) |

### Pinning Recommendation

[Pin recommendation based on brand requirements and compliance needs]
```

#### Extensions Output Format

```markdown
## Extensions: [Campaign Name]

### Sitelinks (4)

| # | Headline (25) | Description 1 (35) | Description 2 (35) | URL |
|---|---------------|--------------------|--------------------|-----|
| 1 | [text] (XX/25) | [text] (XX/35) | [text] (XX/35) | /page |
| 2 | [text] (XX/25) | [text] (XX/35) | [text] (XX/35) | /page |
| 3 | [text] (XX/25) | [text] (XX/35) | [text] (XX/35) | /page |
| 4 | [text] (XX/25) | [text] (XX/35) | [text] (XX/35) | /page |

### Callouts (4-6)

| # | Callout | Chars | Theme |
|---|---------|-------|-------|
| 1 | [text] | XX/25 | Shipping |
| 2 | [text] | XX/25 | Returns |
| 3 | [text] | XX/25 | Selection |
| 4 | [text] | XX/25 | Trust |

### Structured Snippets

| Header | Values |
|--------|--------|
| [header] | [value 1] (XX/25), [value 2] (XX/25), [value 3] (XX/25) |
```

#### PMax Text Assets Output Format

```markdown
## PMax Text Assets: [Asset Group Name]

### Headlines (5)

| # | Headline | Chars |
|---|----------|-------|
| 1 | [text] | XX/30 |
| 2 | [text] | XX/30 |
| 3 | [text] | XX/30 |
| 4 | [text] | XX/30 |
| 5 | [text] | XX/30 |

### Long Headlines (5)

| # | Long Headline | Chars |
|---|---------------|-------|
| 1 | [text] | XX/90 |
| 2 | [text] | XX/90 |
| 3 | [text] | XX/90 |
| 4 | [text] | XX/90 |
| 5 | [text] | XX/90 |

### Descriptions (5)

| # | Description | Chars |
|---|-------------|-------|
| 1 | [text] | XX/90 |
| 2 | [text] | XX/90 |
| 3 | [text] | XX/90 |
| 4 | [text] | XX/90 |
| 5 | [text — must be < 60 chars] | XX/90 |
```

#### Shopping Feed Titles Output Format

```markdown
## Shopping Feed Titles

### Formula

`[Brand] + [Plant/Product Name] + [Type in Target Language] + [Size] + [Pot Size]`

### Examples

| Product | Title | Chars |
|---------|-------|-------|
| [product 1] | [full title] | XX/150 |
| [product 2] | [full title] | XX/150 |
```

### Generation Rules

1. **Character counting:** Count every character including spaces. Verify each element fits within its limit. If it doesn't fit, rewrite — never submit over-limit copy.
2. **Diversity:** No two headlines should communicate the same idea. Different wording of the same message still counts as duplication.
3. **Language purity:** 100% in the target language. Only exception: brand names that are natively in English.
4. **Compound words:** For Swedish/Dutch/German — if a compound exceeds the available space, break it. Show the compound and the broken version with character counts so the user can choose.
5. **Sentence case:** All copy in sentence case. Exception: German nouns are always capitalized (this is grammar, not title case).
6. **No false claims:** Don't write "Bäst i Sverige" (Best in Sweden) unless the client can substantiate it. Don't write price claims unless prices are stable.
7. **CTA variety:** Use at least 3 different action verbs across all CTA-category headlines.

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| Brand name uses 15+ characters | Long brand names leave minimal headline space | Use brand name standalone in 1-2 headlines; use abbreviation or domain in others |
| Compound word exceeds available space | Germanic language compounds can be 15-20+ chars | Break the compound: "inomhusväxter" → "växter inomhus" or restructure the headline |
| All headlines sound similar | Writing variations of the same message | Check each headline against the category column — each must serve a different purpose |
| Ad Strength prediction is "Poor" | Insufficient diversity or too few unique ideas | Ensure all 8 headline categories are represented; avoid repeating keywords across headlines |
| Cannot find native CTAs for the target language | Unusual or small-market language | Use the web research step (Step 4); if no results, use the closest major language's CTA patterns adapted to the target |
| Copy sounds "translated" rather than native | Generated from English and adapted | Delete the English version and generate from scratch directly in the target language; use native CTA library from ad-copy-framework.md |
| Character count disagrees with Google Ads UI | Rare encoding edge cases | Verify in Google Ads Editor (desktop) which counts identically to the live UI; emoji = 2 chars; some special characters may vary |
| Client wants Title Case | Brand preference conflicts with Google recommendation | Sentence case is standard and recommended. If the client insists, accommodate but note it may reduce Ad Strength |

## Next Steps

After ad copy is generated:
- Build or update the campaign → `/ad-platform-campaign-manager:campaign-setup`
- Plan keywords for the campaign → `/ad-platform-campaign-manager:keyword-strategy`
- Set budget and bids → `/ad-platform-campaign-manager:budget-optimizer`
- Review existing campaign with new copy → `/ad-platform-campaign-manager:campaign-review`
- Check PMax setup → `/ad-platform-campaign-manager:pmax-guide`
- Pull live performance data → `/ad-platform-campaign-manager:live-report`

---

## Report Output

When running inside an MWP client project (detected by `stages/` or `reports/` directory):

- **Stage:** `03-build`
- **Output file:** `reports/{YYYY-MM-DD}/03-build/ad-copy.md`
- **SUMMARY.md section:** Campaign Build
- **Write sequence:** Follow the 6-step write sequence in [[conventions#Report File-Writing Convention]]
- **Completeness:** Follow the [[conventions#Output Completeness Convention]]. No truncation, no shortcuts.
- **Re-run behavior:** If this skill runs twice on the same day, overwrite the existing report file. Update (not duplicate) CONTEXT.md row and SUMMARY.md paragraph.
- **Fallback:** If not in an MWP project, output to conversation (legacy behavior).
