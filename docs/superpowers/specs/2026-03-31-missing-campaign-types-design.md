---
title: "Design: Reference Knowledge Base — Completeness & Accuracy"
date: 2026-04-01
tags:
  - design
  - audit-finding-2
  - fact-check
---

# Design: Reference Knowledge Base — Completeness & Accuracy

## Problem

The plugin audit of 2026-03-31 identified two related issues:

1. **Finding #2 — Missing campaign types:** No standalone docs for Shopping, Video/YouTube, DSA, or Demand Gen.
2. **Fact-check sweep:** All 17 existing `reference/platforms/google-ads/` files contained outdated information, factual errors, or significant omissions against 2025-2026 Google Ads reality.

## What Was Done

### Phase 1: New Campaign Type Docs (2026-03-31)

Created 4 standalone reference files in `reference/platforms/google-ads/`:

| File | Topic |
|------|-------|
| `shopping-campaigns.md` | Google Shopping / Merchant Center — feed requirements, product groups, priority strategies, free listings, MC transitions |
| `video-campaigns.md` | YouTube Video campaigns — 3 Reach sub-options (Efficient, Non-skippable, Target frequency), Views subtype, format specs |
| `dsa.md` | Dynamic Search Ads — page feeds, exclusions, AI Max successor warning, deprecation context |
| `demand-gen.md` | Demand Gen campaigns — GDN expansion, VAC absorption, channel controls, Veo, Shoppable CTV |

Updated `campaign-types.md` (cross-references, decision tree, comparison table), both CONTEXT.md routing tables, and PLAN.md.

### Phase 2: Fact-Check Sweep (2026-04-01)

Updated all 17 reference files across 4 priority tiers:

#### Tier 1 — Factual Errors Fixed (4 files)

| File | What Was Wrong | Fix |
|------|----------------|-----|
| `bidding-strategies.md` | Enhanced CPC listed as active strategy | Replaced with deprecation warning (eCPC deprecated March 2025). Added Demand Gen Target CPC, Portfolio Bid Strategies, AI Max note. Updated Target ROAS minimum to 50+ conversions. |
| `pmax/pmax-metrics.md` | Said PMax shows "categories of search terms" | Replaced with full search term visibility (March 2025). Added channel-level reporting, asset group segmentation, demographic reporting, brand exclusion scope. |
| `campaign-types.md` | Video Action Campaigns listed as active subtype | Removed VAC, redirected to Demand Gen. Updated PMax (negatives 10k, search terms). Added AI Max. Updated Demand Gen (GDN, VAC, channel controls, Target CPC). Added DSA deprecation. |
| `ads-scripts-api.md` | AWQL reporting example deprecated; UrlFetchApp limit wrong (50 vs 20,000/day) | Replaced with `AdsApp.search()` + GAQL. Fixed limits. Clarified read vs mutation limits. |

#### Tier 2 — Significant Omissions Filled (6 files)

| File | What Was Added |
|------|----------------|
| `match-types.md` | AI Max for Search section (overrides match types). PMax negative keywords (10,000 campaign-level + shared lists). |
| `pmax/audience-signals.md` | Audience exclusions (Customer Match, website visitors). Demographic hard exclusions. Search themes (50 per asset group). |
| `shopping-campaigns.md` | Fixed PMax comparison table (negatives + reporting). Free listings section. Audience exclusions. Merchant Center transitions (MC Next, API sunset Aug 2026, product ID split). |
| `video-campaigns.md` | Removed Video Action + Demand Gen (video) subtypes. Expanded Video Reach to 3 sub-options. Updated Shorts to non-skippable. |
| `demand-gen.md` | GDN expansion (April 2025). VAC absorption. Channel controls. New features (Veo, Shoppable CTV, Target CPC, New Customer Only Mode, Creator partnerships). Lookalike → audience suggestions transition. |
| `dsa.md` | AI Max as confirmed successor with comparison table + migration steps. Deprecation warning. Removed eCPC from bidding. |

#### Tier 3 — Minor Updates (6 files)

| File | Changes |
|------|---------|
| `account-structure.md` | "Extensions" → "assets". PMax negatives note. AI Max mention. |
| `quality-score.md` | "Extensions" → "assets". Component weighting (CTR + LP = 2x Ad Relevance). Ad Rank contextual factors. |
| `ad-extensions.md` | Section headers → "Asset Types" / "Asset Strategy". Call-only deprecation (Feb 2026). "Degree programs" snippet header. PMax Brand Guidelines. |
| `conversion-actions.md` | Expanded categories. External Attribution model. Goals → Conversions nav path. Data Manager API. |
| `enhanced-conversions.md` | Account-level EC (Oct 2025 auto-upgrade). Automatic detection method. Data Manager for CRM. Updated nav paths. |
| `gaql-reference.md` | DEMAND_GEN channel type. PMax channel reporting (API v23). `omit_unselected_resource_names` parameter. |

#### Tier 4 — PMax & Audit (4 files)

| File | Changes |
|------|---------|
| `pmax/asset-requirements.md` | Description spec fix. Search themes (50). Brand guidelines. Video count (0-5). |
| `pmax/feed-optimization.md` | MC Next. Content API sunset. Product ID split. Feed frequency (15-60 min sync). |
| `audit/audit-checklist.md` | 7 new PMax checks (negatives, search terms, channel report, exclusions, demographics, search themes, brand exclusion scope). Consent Mode v2. AI Max check. "Assets" terminology. |
| `audit/common-mistakes.md` | 7 new PMax mistakes (#26-32): no custom video, no negatives, not reviewing search terms, budget cuts >20%, ROAS too aggressive, no exclusions, same signal all groups. |

#### Clean (1 file)

| File | Change |
|------|--------|
| `audit/negative-keyword-lists.md` | Added PMax shared lists note (August 2025). |

### Recurring Themes Resolved

| Theme | Resolution |
|-------|------------|
| PMax evolved massively in 2025 | All PMax docs updated (negatives, search terms, channel reporting, exclusions) |
| AI Max for Search absent | Added to match-types, campaign-types, dsa, account-structure, audit-checklist |
| "Extensions" → "assets" rebrand | Replaced throughout all files |
| Enhanced CPC deprecated March 2025 | Removed from all strategy/bidding tables, replaced with deprecation warnings |
| Video Action Campaigns gone | Removed from video-campaigns, campaign-types; redirected to demand-gen |
| Demand Gen expanded | GDN, VAC absorption, channel controls, new features all documented |

## What This Does NOT Include

- **Skill changes:** Existing skills not updated to reference new docs or use Socratic patterns (Finding #3 and #4).
- **Non-Google platforms:** Meta, LinkedIn, TikTok remain .gitkeep placeholders (Phase 4).
- **API integration:** No live data access (Phase 3 blocker — needs Google Ads API credentials).

## Verification Performed

1. Grep for "extensions" — only transitional/historical references remain
2. Grep for "Enhanced CPC" — only deprecation warnings remain
3. Grep for "Video Action" — only migration context remains
4. Grep for "CAMPAIGN_PERFORMANCE_REPORT" — only in legacy AWQL section (intentional)
5. All wikilinks verified — cross-references resolve to existing files
6. CONTEXT.md routing tables accurate
7. PLAN.md all tiers marked ✅ Done
