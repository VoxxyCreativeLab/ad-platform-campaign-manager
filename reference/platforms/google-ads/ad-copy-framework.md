---
title: Ad Copy Generation Framework
date: 2026-04-04
tags:
  - reference
  - google-ads
---

# Ad Copy Generation Framework

Reusable knowledge base for generating Google Ads copy across languages and campaign types. Covers character limits, headline formulas, language-specific rules, CTA libraries, and extension copy patterns. For RSA testing methodology and creative iteration, see [[ad-testing-framework]]. For extension type specifications, see [[ad-extensions]].

%%fact-check: Character limits verified against Google Ads Help 2026-04-04. Language CTA libraries compiled from Swedish, Dutch, German e-commerce advertising research.%%

## Character Limits Quick Reference

### Search RSA

| Asset | Limit | Count per Ad | Notes |
|---|---|---|---|
| Headline | 30 chars | 3-15 | Google shows 2-3 per impression |
| Description | 90 chars | 2-4 | Google shows 1-2 per impression |
| Display URL path | 15 chars | 2 | Keyword-relevant paths improve CTR |

### Extensions (Assets)

| Asset | Limit | Count | Notes |
|---|---|---|---|
| Sitelink headline | 25 chars | 2-8 per campaign | Link to distinct pages |
| Sitelink description | 35 chars | 2 per sitelink | Expand on the headline |
| Callout | 25 chars | 4-6 per campaign | Short benefit phrases, no links |
| Structured snippet value | 25 chars | 3+ per header | Predefined header categories |
| Promotion headline | 20 chars | — | Occasion-based or general |

### PMax Text Assets

| Asset | Limit | Min | Max | Notes |
|---|---|---|---|---|
| Headline | 30 chars | 3 | 15 | Per asset group |
| Long headline | 90 chars | 1 | 5 | Full value proposition |
| Description | 90 chars | 2 | 5 | At least 1 must be < 60 chars |
| Business name | 25 chars | 1 | 1 | — |
| Display URL path | 15 chars | 0 | 2 | — |

### Shopping Feed Titles

| Element | Limit | Notes |
|---|---|---|
| Product title | 150 chars | Google Shopping uses first ~70 chars in results |
| Product description | 5,000 chars | First 150-200 chars most important |

---

## Headline Generation Framework

Write headlines across diverse categories to maximize RSA Ad Strength and give Google more combinations to test. Each headline should communicate a **distinct idea** — see [[ad-testing-framework#Headline Strategy]] for the full category system.

### Headline Category Distribution (15-headline RSA)

| Category | Count | Formula | Example (English) |
|---|---|---|---|
| **Brand** | 1-2 | `[Brand]` or `[Brand] + [qualifier]` | "Nike Official Store" |
| **Product/Service** | 3-4 | `[Product] + [modifier]` | "Men's Running Shoes" |
| **Benefit** | 2-3 | `[Benefit statement]` | "Free Returns on All Orders" |
| **Call to action** | 2-3 | `[Action verb] + [object]` | "Shop the Collection Today" |
| **Social proof** | 1-2 | `[Number] + [proof type]` | "Rated 4.8/5 by 10K+ Buyers" |
| **Offer/Price** | 1-2 | `[Offer] + [detail]` | "Starting From EUR 49.99" |
| **Urgency** | 0-1 | `[Time pressure] + [action]` | "Limited Stock — Order Now" |
| **Differentiator** | 1-2 | `[Unique value prop]` | "Same-Day Delivery Available" |

### Brand Headline Math

The brand name consumes a fixed portion of the 30-character limit. Calculate remaining space before writing:

```
Available chars = 30 - [brand length] - 1 (space)

Examples:
  "VaxterOnline" (12 chars) → 17 chars remaining
  "Plantentotaal" (13 chars) → 16 chars remaining  
  "Nike" (4 chars) → 25 chars remaining
```

If the brand name is 15+ characters, consider using it standalone as one headline and not combining it with other text.

### Description Strategy

| Slot | Purpose | Formula |
|---|---|---|
| D1 | Primary value prop + CTA | `[Core benefit]. [Selection/range]. [CTA].` |
| D2 | Trust + social proof | `[Trust signal]. [Guarantee/returns]. [Proof].` |
| D3 | Offer or differentiator | `[Offer detail]. [Unique selling point].` |
| D4 | Category/seasonal | `[Category focus]. [Seasonal/timely hook].` |

---

## Language-Specific Rules

### General Rules (All Non-English Markets)

1. **Never mix languages** within a single headline or description. Brand names in English are acceptable (proper nouns).
2. **Accented characters count as 1 character** in Google Ads. This includes å, ä, ö, é, è, ü, ß, ñ, etc.
3. **Emoji count as 2 characters** and are generally not recommended in Search ads.
4. **Sentence case** is standard across all languages. Not Title Case, not ALL CAPS.
5. **Currency formatting** follows market convention: "EUR 49" (Nordic/Dutch formal), "49 €" (informal), "49 kr" (Swedish krona if applicable).
6. **Generate directly in the target language** — never translate from English. Translated copy sounds unnatural and misses market-specific phrasing.

### Swedish (sv-SE)

**Compound words:** Swedish forms long compound words that consume headline character limits quickly.

| Swedish Compound | English | Chars | Strategy |
|---|---|---|---|
| inomhusväxter | indoor plants | 14 | Use as-is when it fits |
| trädgårdsväxter | garden plants | 15 | Break: "växter för trädgård" (20) or shorten context |
| krukväxter | potted plants | 10 | Compact — preferred in headlines |
| snabbleverans | fast delivery | 13 | Break: "snabb leverans" (14) — only 1 char longer |
| onlinebeställning | online ordering | 17 | Break: "beställ online" (14) — shorter split wins |

**Strategy:** Prefer the compound when it fits within the limit. Break with a space when it doesn't — the split is always acceptable in Swedish ad copy.

**CTA Library:**

| Swedish | English | Chars | Register |
|---|---|---|---|
| Köp nu | Buy now | 6 | Direct, commercial |
| Handla | Shop | 6 | Softer, browsing |
| Beställ | Order | 7 | Formal purchase |
| Handla nu | Shop now | 9 | Urgency + browsing |
| Köp online | Buy online | 10 | E-commerce specific |
| Beställ idag | Order today | 12 | Urgency |
| Upptäck | Discover | 7 | Exploratory |
| Utforska | Explore | 8 | Exploratory |
| Hitta din favorit | Find your favorite | 17 | Personalized |
| Se sortimentet | See the range | 14 | Category browsing |
| Välj bland 100+ | Choose from 100+ | 15 | Selection emphasis |

**Trust Signals:**

| Swedish | English | Chars |
|---|---|---|
| Snabb leverans | Fast delivery | 14 |
| Fri frakt | Free shipping | 9 |
| Stort utbud | Wide selection | 11 |
| Tryggt köp | Safe purchase | 10 |
| Enkel retur | Easy returns | 11 |
| Säker betalning | Secure payment | 15 |
| Snabb frakt i Sverige | Fast shipping in Sweden | 21 |

**Address form:** "du" (informal) is standard in Swedish advertising. "ni" (formal plural) is archaic and should not be used.

**Special considerations:**
- Swedish uses "och" (3 chars) not "&" (1 char) — use "&" in headlines to save space when needed
- Numbers: use numerals in ads, not spelled out ("100+" not "hundra")
- Periods in brand names count: "VaxterOnline.se" = 15 chars vs "VaxterOnline" = 12 chars

### Dutch (nl-NL / nl-BE)

**Compound words:** Dutch compounds are generally shorter than Swedish/German but still present.

| Dutch Compound | English | Chars | Strategy |
|---|---|---|---|
| kamerplanten | houseplants | 12 | Use as-is |
| tuinplanten | garden plants | 11 | Use as-is |
| snellevering | fast delivery | 12 | Break: "snelle levering" (15) — compound is shorter |
| onlinewinkel | online store | 12 | Break: "online winkel" (13) — either works |

**CTA Library:**

| Dutch | English | Chars | Register |
|---|---|---|---|
| Koop nu | Buy now | 7 | Direct |
| Bestel | Order | 6 | Direct |
| Bestel nu | Order now | 9 | Urgency |
| Shop nu | Shop now | 7 | Casual |
| Bekijk | View/Check out | 6 | Browsing |
| Ontdek | Discover | 6 | Exploratory |
| Bekijk het aanbod | View the range | 17 | Category |
| Vraag aan | Request | 9 | Lead gen |
| Profiteer nu | Take advantage now | 12 | Promotional |

**Trust Signals:**

| Dutch | English | Chars |
|---|---|---|
| Gratis verzending | Free shipping | 17 |
| Snelle levering | Fast delivery | 15 |
| Groot assortiment | Wide range | 17 |
| Veilig betalen | Secure payment | 14 |
| Eenvoudig retour | Easy returns | 16 |
| Klantwaardering 4.8/5 | Customer rating 4.8/5 | 21 |

**Address form:** "je/jij" (informal) is standard in NL advertising. "u" (formal) is more common in BE and for older audiences. Default to "je" for Netherlands, "u" for Belgium unless the brand has a specific preference.

**Special considerations:**
- "ij" is two characters, not one (unlike in handwriting)
- Dutch uses "en" (2 chars) for "and" — save space with "&" in headlines
- Belgium Dutch (Flemish) differs in vocabulary: "gsm" not "mobiel", "proper" not "schoon" — match the target market

### German (de-DE / de-AT / de-CH)

**Compound words:** German produces the longest compounds of any European language. Aggressive breaking is often necessary.

| German Compound | English | Chars | Strategy |
|---|---|---|---|
| Zimmerpflanzen | houseplants | 14 | Use as-is |
| Gartenzubehör | garden accessories | 13 | Use as-is |
| Pflanzendünger | plant fertilizer | 14 | Use as-is |
| Zimmerpflanzendünger | houseplant fertilizer | 20 | Break: must split |
| Versandkostenfrei | free shipping | 17 | Use as-is (barely fits 25-char callout) |

**CTA Library:**

| German | English | Chars | Register |
|---|---|---|---|
| Jetzt kaufen | Buy now | 12 | Standard |
| Jetzt bestellen | Order now | 15 | Direct |
| Entdecken | Discover | 9 | Exploratory |
| Jetzt entdecken | Discover now | 15 | Exploratory + urgency |
| Ansehen | View | 7 | Browsing |
| Jetzt shoppen | Shop now | 13 | Casual |
| Angebot sichern | Secure offer | 15 | Promotional |

**Trust Signals:**

| German | English | Chars |
|---|---|---|
| Kostenloser Versand | Free shipping | 19 |
| Schnelle Lieferung | Fast delivery | 18 |
| Große Auswahl | Wide selection | 14 |
| Sicher bezahlen | Pay securely | 15 |
| Einfache Rückgabe | Easy returns | 17 |
| Trusted Shops Siegel | Trusted Shops seal | 20 |

**Address form:** "Sie" (formal) is standard in German advertising. "du" is acceptable for young/casual brands (fashion, music, tech startups). Default to "Sie" unless the brand explicitly uses "du".

**Special considerations:**
- ß counts as 1 character; "ss" alternative is 2 characters — use ß when correct
- German nouns are always capitalized: "Große Auswahl" not "große auswahl" — this is NOT Title Case, it's German grammar
- AT/CH may use different terminology: "Zustellung" (AT) vs "Lieferung" (DE) for delivery

### English (en-GB / en-US) — Baseline

**CTA Library:**

| English | Chars | Register |
|---|---|---|
| Shop Now | 8 | Standard e-commerce |
| Buy Now | 7 | Direct purchase |
| Get Started | 11 | SaaS/services |
| Learn More | 10 | Informational |
| Try Free | 8 | Free trial |
| Discover | 8 | Exploratory |
| Browse Collection | 17 | Category |
| Claim Your Offer | 16 | Promotional |

**Trust Signals:**

| English | Chars |
|---|---|
| Free Shipping | 13 |
| Fast Delivery | 13 |
| Easy Returns | 12 |
| Price Match Guarantee | 21 |
| Rated 4.8/5 Stars | 17 |

**No compound-word issues.** English rarely creates compounds longer than 12-15 characters.

---

## Shopping Feed Title Formulas

Effective Shopping titles follow a predictable structure. The first ~70 characters are displayed in search results — front-load the most important attributes.

### Formula by Vertical

| Vertical | Formula | Example |
|---|---|---|
| **E-commerce (general)** | `Brand + Product Type + Key Attribute + Variant` | `Nike Air Max 90 Running Shoe Black Size 42` |
| **Fashion** | `Brand + Product + Color + Size + Material` | `Levi's 501 Original Jeans Blue Denim W32 L32` |
| **Plants/Garden** | `Brand + Plant Name + Type + Size + Pot` | `VaxterOnline Monstera Deliciosa Krukväxt 80cm 19cm Kruka` |
| **Electronics** | `Brand + Model + Key Spec + Color` | `Samsung Galaxy S24 Ultra 256GB Titanium Black` |
| **Home/Furniture** | `Brand + Product + Material + Dimension` | `IKEA KALLAX Shelf Unit White 77x147cm` |

### Localized Feed Title Examples

| Market | Example | Notes |
|---|---|---|
| **Swedish** | `VaxterOnline Monstera Deliciosa Krukväxt 80cm` | Use Swedish product type ("krukväxt" not "potted plant") |
| **Dutch** | `Plantentotaal Monstera Deliciosa Kamerplant 80cm` | Use Dutch product type ("kamerplant") |
| **German** | `Pflanzenversand Monstera Deliciosa Zimmerpflanze 80cm` | Use German product type ("Zimmerpflanze" — capitalized) |
| **English** | `GreenThumb Monstera Deliciosa Houseplant 80cm` | English product type |

### Feed Title Rules

1. **No promotional text** in titles ("Sale!", "Free Shipping", "Best Price")
2. **No ALL CAPS** except brand names that are naturally uppercase
3. **Include size/variant** when relevant — Google matches more specific queries
4. **Use common names AND Latin names** for plants/specialty products — searchers use both
5. **Keep under 150 chars** total; optimize the first 70 chars for display

---

## Extension Copy Framework

### Sitelink Topics by Business Type

| Business Type | Sitelink 1 | Sitelink 2 | Sitelink 3 | Sitelink 4 |
|---|---|---|---|---|
| **E-commerce** | Top category | Second category | Sale/Offers | About/Trust |
| **Lead gen** | Services | Pricing | Case studies | Contact |
| **Local service** | Services | Areas served | Reviews | Book now |
| **SaaS** | Features | Pricing | Free trial | Demo |

### Sitelink Copy Pattern

```
Headline (25 chars): [Category/Page Name]
Description 1 (35 chars): [What the page offers]
Description 2 (35 chars): [Benefit or CTA for that page]
```

### Callout Themes

Generate 4-6 callouts covering different themes:

| Theme | Purpose | Examples (EN) |
|---|---|---|
| **Shipping** | Delivery promise | "Free Shipping", "Next-Day Delivery" |
| **Returns** | Risk reduction | "Easy Returns", "30-Day Guarantee" |
| **Selection** | Range/variety | "500+ Products", "Wide Selection" |
| **Trust** | Credibility | "Rated 4.8/5", "Trusted Since 2015" |
| **Price** | Value message | "Price Match", "No Hidden Fees" |
| **Convenience** | Ease of purchase | "Order 24/7", "Click & Collect" |

### Structured Snippet Headers

| Header | When to Use | Example Values |
|---|---|---|
| **Types** | Product/service categories | "Indoor Plants, Outdoor Plants, Succulents" |
| **Brands** | Multi-brand retailers | "Monstera, Ficus, Calathea, Strelitzia" |
| **Styles** | Fashion, home decor | "Modern, Classic, Minimalist" |
| **Amenities** | Hotels, venues | "WiFi, Pool, Parking, Breakfast" |
| **Service catalog** | Service businesses | "Consulting, Audit, Setup, Training" |
| **Destinations** | Travel, shipping | "Stockholm, Göteborg, Malmö" |

---

## Common Mistakes

| Mistake | Impact | Fix |
|---|---|---|
| Translating English copy instead of writing native | Unnatural phrasing, lower CTR | Generate directly in the target language using native CTA libraries |
| Ignoring compound-word length in Germanic languages | Headlines exceed 30 chars, truncated | Calculate brand + compound length before writing; break compounds when needed |
| Same CTA in every headline | Poor Ad Strength, limited testing | Vary across categories: brand, product, benefit, CTA, social proof |
| Missing character counts in output | No way to verify before pasting into Google Ads | Always show `(XX/YY chars)` for every text element |
| Mixing formal/informal address | Inconsistent brand voice | Pick one address form per market and use it everywhere |
| Using English words in non-English copy | Reduces relevance, may confuse searchers | Keep 100% in target language (exception: English brand names) |
| Price claims that change | Policy violation risk, misleading | Use relative terms ("Vanaf EUR 29", "Från 99 kr") only if prices are stable |

## Related

- [[ad-testing-framework]] — RSA testing methodology, headline categories, pinning, Ad Strength, performance evaluation
- [[ad-extensions]] — extension types, specifications, and strategy
- [[pmax/asset-requirements]] — PMax text and image asset specifications
- [[shopping-feed-strategy]] — feed architecture, multi-market feeds, health scoring
- [[pmax/feed-optimization]] — feed title formulas, custom labels, attribute optimization
- [[strategy/account-profiles]] — account archetype for creative strategy context
