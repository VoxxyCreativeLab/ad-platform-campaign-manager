---
title: Audit Checklist Gap Analysis
date: 2026-04-06
tags:
  - reference
  - google-ads
  - audit
  - roadmap
---

# Audit Checklist Gap Analysis

> This document preserves the complete findings from a systematic gap analysis conducted on 2026-04-06 using the Vaxteronline client account as a test case. The Shopping campaign audit miss that triggered this analysis is documented in LESSONS.md of the client project.

## How to Use This Document

This is the implementation roadmap for expanding the audit checklist beyond Search+PMax. When addressing a gap:
1. Pull the relevant section below
2. Add items to `audit-checklist.md`
3. Wire into `campaign-review` SKILL.md as a new review area
4. Update the scoring total
5. Mark the section below as `[DONE]`

---

## Coverage Matrix (Current State as of 2026-04-06)

| Campaign Type | Audit Checklist Items | Reference Docs | Priority |
|---|---|---|---|
| Search | ~50 items across 11 areas | Strong | — |
| PMax | 14 dedicated items | 5 dedicated docs | — |
| **Shopping** | ~~ZERO~~ → 28 items added (v1.10.0) | shopping-campaigns.md, shopping-feed-strategy.md | **✅ Done** |
| **Audience Strategy** | ~~ZERO~~ → 11 items added (v1.10.0) | targeting-framework.md, remarketing-strategies.md | **✅ Done** |
| **Display** | ~~ZERO~~ → 20 items added (v1.11.0) | 15 lines in campaign-types.md | **✅ Done** |
| **Demand Gen** | ~~ZERO~~ → 14 items added (v1.11.0) | demand-gen.md (solid, 204 lines) | **✅ Done** |
| **Competitive Analysis** | ~~ZERO~~ → 6 items added (v1.11.0) | Not documented | **✅ Done** |
| **Feed Health** | ~~1 mention in PMax~~ → 10 items added (v1.11.0) | shopping-feed-strategy.md (166 lines) | **✅ Done** |
| **Video/YouTube** | ~~ZERO~~ → 12 items added (v1.12.0) | video-campaigns.md (135 lines) | **✅ Done** |
| **Cross-campaign Cannibalization** | ~~1 generic line~~ → 5 items added (v1.12.0) | Partial in vertical-ecommerce.md | **✅ Done** |
| **Attribution Depth** | ~~1 item~~ → 5 items added (v1.12.0) | attribution-guide.md (360 lines, excellent) | **✅ Done** |
| DSA | ZERO | dsa.md (196 lines, AI Max context) | Priority 4 |
| App Campaigns | ZERO | No doc | Priority 4 |

---

## Priority 1: Already Implemented in v1.10.0

### Shopping Specific (28 checks) — ✅ Added to audit-checklist.md
### Audience Strategy (11 checks) — ✅ Added to audit-checklist.md

---

## Priority 2: Implement Next — ✅ Done (v1.11.0)

### Display Campaign Audit Section — ✅ Done (v1.11.0)

No dedicated audit coverage. No standalone reference doc. Display is commonly used (remarketing is near-universal for e-commerce).

**Checklist items to add (~20 checks):**

**Campaign Settings:**
- [ ] Display campaigns separated from Search (never mixed)
- [ ] Campaign objective matches actual goal (awareness vs remarketing vs conversions)
- [ ] Frequency capping configured (3-5 impressions/week for awareness; 5-7/week for remarketing)
- [ ] Ad rotation: Optimize for best-performing ads
- [ ] Location targeting: Presence (not Presence or interest)

**Targeting:**
- [ ] Targeting expansion / optimized targeting reviewed and intentionally enabled/disabled
- [ ] Audience segments appropriate for goal (affinity=awareness; in-market=conversions; remarketing lists=retargeting)
- [ ] Remarketing campaigns using product feed for dynamic display ads
- [ ] No overly broad targeting (all users, no audience signals)
- [ ] Audience exclusions configured (exclude converters from prospecting campaigns)

**Placement Controls:**
- [ ] Placement exclusion lists applied (poor-quality sites, apps, kids content)
- [ ] Automatic placements reviewed for quality (Where ads showed report)
- [ ] Mobile app placements excluded or reviewed (notorious for accidental clicks)
- [ ] Content exclusions configured (sensitive categories, parked domains, error pages)

**Responsive Display Ads:**
- [ ] All asset slots populated (landscape 1200x628, square 1200x1200, logo 1200x1200)
- [ ] Up to 5 short headlines, 1 long headline, 5 descriptions provided
- [ ] Ad strength: Good or Excellent
- [ ] Custom uploaded images used (not relying solely on auto-generated)

**Performance:**
- [ ] CTR benchmarks checked (Display CTR typically 0.5-1.0%; below 0.3% = investigate)
- [ ] View-through conversions reviewed separately from click-through
- [ ] VTC window set appropriately (consider 7 days, not default 30-day)

**KPI benchmarks (add to vertical-ecommerce.md or display-campaigns.md):**
- CTR: 0.5-1.0% (awareness); higher for remarketing
- Viewable impression rate: above 70%
- Frequency: 3-5 per week per user
- Conversion rate: 0.5-1.5% typical

**Action required:** Create `reference/platforms/google-ads/display-campaigns.md` (currently only 15 lines in campaign-types.md). Add display section to audit-checklist.md.

---

### Demand Gen Audit Section — ✅ Done (v1.11.0)

Growing in importance (absorbed GDN + Video Action Campaigns). Strong reference doc exists but not wired into audit.

**Checklist items to add (~12 checks):**

**Campaign Settings:**
- [ ] Campaign objective aligned with actual goal
- [ ] Channel controls configured at ad group level (YouTube, GDN, Discover, Gmail selected intentionally)
- [ ] Budget: minimum 10-15x target CPA daily
- [ ] Learning period respected (2-3 weeks before judging)

**Creative:**
- [ ] Lifestyle imagery used (no corporate stock, heavy text overlays)
- [ ] All formats tested: image, video, carousel
- [ ] Vertical video provided for Shorts (native, not repurposed landscape)
- [ ] Creative refreshed within last 4-6 weeks (fatigue is major risk for static)

**Audiences:**
- [ ] Lookalike / audience suggestion segments configured from best customers
- [ ] Customer list exclusions: existing customers excluded
- [ ] Optimized targeting reviewed after first 2 weeks
- [ ] Prospecting and remarketing separated into distinct campaigns

**Measurement:**
- [ ] View-through conversion window reviewed (default 30 days — consider reducing to 7)
- [ ] VTC analyzed separately from click-through

---

### Competitive Analysis Section (Cross-Campaign) — ✅ Done (v1.11.0)

Currently zero mentions of auction insights anywhere in the plugin. This is a standard part of any professional audit.

**Checklist items to add (~6 checks):**

- [ ] Auction Insights reviewed for top campaigns (impression share, overlap rate, outranking share)
- [ ] Top competitors identified from auction insights
- [ ] Impression share lost to rank vs budget distinguished (rank = quality/bid issue; budget = spend constraint)
- [ ] Absolute top impression share reviewed for brand campaigns
- [ ] Competitor bidding on brand terms detected
- [ ] Price Competitiveness report reviewed (MC: products priced 20%+ above market get fewer Shopping impressions)

**Action required:** Add "Competitive Analysis" section to audit-checklist.md. No new reference file needed — add content to existing account-structure.md or create a new competitive-analysis.md.

---

### Feed Health Section (E-commerce) — ✅ Done (v1.11.0)

Currently only a passing mention in PMax section ("Product feed optimized"). The shopping-feed-strategy.md has a 6-dimension Feed Health Scoring framework that should flow into the checklist.

**Checklist items to add (~10 checks):**

- [ ] Feed update frequency: daily minimum; 4-6h for dynamic pricing
- [ ] Disapproval rate below 2% (check MC > Diagnostics)
- [ ] Price accuracy: feed prices match landing page prices (mismatches cause disapprovals)
- [ ] GTIN coverage above 90% for branded products
- [ ] Image quality: minimum 800x800px, white background, no watermarks/text
- [ ] All required attributes populated (id, title, description, link, image_link, price, availability)
- [ ] Supplemental feed in use for title overrides, custom labels, promotions
- [ ] Content API migration planned (sunset: August 18, 2026)
- [ ] Feed rules configured for title/description optimization where needed
- [ ] MC Price Competitiveness report reviewed

---

## Priority 3: Address in Future Iterations — ✅ Done (v1.12.0)

### Video/YouTube Audit Section — ✅ Done (v1.12.0)

Good reference doc (video-campaigns.md, 135 lines). Needs dedicated checklist items.

**Key items to add (~10 checks):**

- [ ] Hook in first 5 seconds (value proposition before skip button)
- [ ] Brand shown within first 5 seconds
- [ ] Companion banners uploaded for in-stream ads (300x60)
- [ ] Frequency capping: 3/week awareness; 5/week remarketing
- [ ] Placement exclusions: kids content, competitor channels
- [ ] VTC window reviewed (default 30 days — consider reducing to 7)
- [ ] Engaged-view window appropriate (default 3 days)
- [ ] YouTube channel linked to Google Ads account
- [ ] Creative refreshed every 4-6 weeks (prevent fatigue)
- [ ] Brand Lift study eligibility assessed (EUR 10k+ spend; Google rep required)

---

### Cross-Campaign Cannibalization — ✅ Done (v1.12.0)

Currently one generic item: "No campaign overlap (competing for same traffic)." Should be specific.

**Items to add (~5 checks):**
- [ ] PMax brand search cannibalization assessed (brand exclusions applied)
- [ ] PMax vs Shopping product overlap mapped
- [ ] Search vs DSA keyword overlap managed (cross-negatives)
- [ ] Brand campaign protected from non-brand spillover via campaign-level negatives
- [ ] Cross-campaign negative keywords preventing internal competition

---

### Attribution Depth — ✅ Done (v1.12.0)

attribution-guide.md is excellent (360 lines) but only one item flows into the checklist. Should add:
- [ ] Attribution windows match vertical sales cycle (e-commerce 30d; B2B 90d)
- [ ] View-through conversion window reviewed (default may inflate results)
- [ ] Google Ads vs GA4 conversion discrepancy documented (< 15% acceptable)
- [ ] Assisted conversions reviewed before pausing any upper-funnel campaign
- [ ] Value-based bidding eligibility assessed (need reliable conversion values)

---

## Priority 4: Low Priority / Niche

### DSA Specific

dsa.md is good (196 lines, AI Max migration context). DSA is being deprecated for AI Max. Low priority.

**Key items:**
- [ ] Page feed connected and URLs approved
- [ ] Category exclusions set (careers, legal, privacy pages)
- [ ] Negative keywords heavily used (DSA is broad by nature)
- [ ] AI Max migration plan in place

---

### App Campaign Audit

Zero coverage. No reference doc. Add if client base includes app advertisers.

**Key items:**
- [ ] App campaign objective matches goal (installs vs in-app actions)
- [ ] Conversion events correctly mapped to in-app actions
- [ ] Creative assets in all formats (text, image, video, HTML5)
- [ ] Deep linking for re-engagement campaigns

---

## Account-Level Strengthening — ✅ Done (v1.12.0)

Items missing from the general account-level audit section:

- [ ] Conversion Linker tag verified on all pages (currently only in conversion-tracking skill troubleshooting)
- [ ] Account-level automated extensions reviewed (auto-generated may be inappropriate)
- [ ] Cross-campaign budget allocation follows 70/20/10 rule (proven/optimization/testing)
- [ ] Change history reviewed for too-frequent changes resetting learning (max 2x/week for smart bidding campaigns)
- [ ] Data exclusions configured for known measurement issues (down periods, tracking outages)

---

## Sources

Research conducted 2026-04-06 using web search + analysis of existing plugin codebase.

- [Promodo — Google Ads Audit Checklist 2026](https://www.promodo.com/blog/google-ads-audit-checklist)
- [Store Growers — 44-Point Google Ads Audit for Ecommerce](https://www.storegrowers.com/google-ads-audit/)
- [PPC Panos — 33 Areas to Audit in Google Shopping Campaigns](https://ppcpanos.com/how-to-audit-shopping-campaigns-in-google-ads/)
- [ZATO Marketing — Shopping Performance Drop Audit Checklist](https://zatomarketing.com/blog/audit-checklist-for-shopping-performance-change)
- [BigFlare — Weekly Google Ads Audit for Ecommerce](https://www.bigflare.com/blog/the-exact-weekly-google-ads-audit-checklist-my-agency-uses-to-scale-ecommerce-brands)
- [Google Ads Help — About Click Share](https://support.google.com/google-ads/answer/6299696)
- [Google Ads Help — About Impression Share](https://support.google.com/google-ads/answer/2497703)
- [Google Ads Help — Auction Insights](https://support.google.com/google-ads/answer/2579754)
- [Google Ads Help — Monitor Shopping Campaigns](https://support.google.com/google-ads/answer/3455573)
- [Google Ads Help — Custom Labels](https://support.google.com/google-ads/answer/6275295)
- [Optmyzr — Google Shopping Campaign Structure](https://www.optmyzr.com/blog/google-shopping-campaign-structure/)
- [Wixpa — Google Shopping Feed Audit Checklist 2026](https://wixpa.com/google-shopping-feed-audit-step-by-step-checklist/)
- [SKU Analyzer — Impression Share Benchmarks](https://skuanalyzer.com/guides/impression-share/benchmarks/)
- [ALM Corp — Demand Gen Best Practices February 2026](https://almcorp.com/blog/google-demand-gen-best-practices-february-2026/)
- [Channable — Display Ads Best Practices 2025](https://www.channable.com/blog/google-display-ads-best-practices)
- [PPC Hero — Audit Google Display Placements](https://ppchero.com/audit-google-display-placements-like-a-boss/)
- [GROAS — Google Ads Conversion Tracking Setup 2026](https://groas.ai/post/google-ads-conversion-tracking-setup-2026-the-complete-guide-ga4-enhanced-conversions-consent-mode)
