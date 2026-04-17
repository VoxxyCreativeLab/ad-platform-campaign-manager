---
title: Top 32 Google Ads Mistakes & Fixes
date: 2026-04-01
tags:
  - reference
  - google-ads
  - audit
---

# Top 32 Google Ads Mistakes & Fixes

## Structure & Setup

### 1. All keywords in one ad group
**Problem:** Ad copy can't be relevant to all keywords.
**Fix:** Group keywords by theme/intent. One topic per ad group.

### 2. Not separating brand and non-brand
**Problem:** Brand traffic inflates performance metrics, masking poor non-brand performance.
**Fix:** Separate brand campaigns. Evaluate non-brand performance independently.

### 3. Location targeting set to "Presence or interest"
**Problem:** Ads show to people "interested in" your location, not just people there.
**Fix:** Change to "Presence: People in or regularly in your targeted locations."

### 4. Not setting up conversion tracking properly
**Problem:** Smart bidding can't optimize. Performance data is meaningless.
**Fix:** Implement proper conversion tracking via GTM/sGTM before launching campaigns.

### 5. Too many primary conversion actions
**Problem:** Smart bidding optimizes for all primary actions equally — a newsletter sign-up counts the same as a purchase.
**Fix:** Set only your main business goal as primary. Make micro-conversions secondary.

## Keywords & Targeting

### 6. Using only broad match without smart bidding
**Problem:** Broad match + manual bidding = irrelevant traffic and wasted spend.
**Fix:** Use broad match only with smart bidding (Target CPA/ROAS). Or use phrase/exact match with manual bidding.

### 7. Not reviewing search terms
**Problem:** You don't know what queries actually trigger your ads.
**Fix:** Review search terms weekly. Add irrelevant terms as negatives.

### 8. No negative keywords
**Problem:** Ads show for irrelevant searches, wasting budget.
**Fix:** Add negative keyword lists immediately. Review and expand regularly.

### 9. Duplicate keywords across ad groups/campaigns
**Problem:** Your own campaigns compete against each other (cannibalization).
**Fix:** Use cross-campaign negatives. Each keyword should live in one place.

### 10. Ignoring Quality Score
**Problem:** Low Quality Score = higher CPCs and worse positions.
**Fix:** Check which component is low (CTR, relevance, landing page) and address it.

## Ads & Creative

### 11. Not using all RSA headline/description slots
**Problem:** Fewer combinations for Google to test = suboptimal performance.
**Fix:** Use all 15 headline slots and 4 description slots.

### 12. Generic ad copy (no differentiation)
**Problem:** Ads look like every competitor's.
**Fix:** Include unique value props, specific numbers, social proof, clear CTAs.

### 13. Sending all traffic to the homepage
**Problem:** Users can't find what they searched for → they bounce.
**Fix:** Create or use specific landing pages matching ad messaging and keywords.

### 14. Not using ad assets
**Problem:** Ads take up less space, lower CTR, no additional info shown.
**Fix:** Add sitelinks, callouts, and structured snippets at minimum.

### 15. Over-pinning RSA headlines
**Problem:** Pinning limits Google's testing ability, reducing ad strength.
**Fix:** Only pin when legally required. Let Google test combinations.

## Bidding & Budget

### 16. Setting Target CPA/ROAS too aggressively
**Problem:** Google restricts spend to meet impossible targets → campaigns stop delivering.
**Fix:** Start with your actual CPA/ROAS, then gradually improve.

### 17. Switching bid strategies too frequently
**Problem:** Each switch resets the learning period → weeks of suboptimal performance.
**Fix:** Commit to a strategy for at least 2-4 weeks before evaluating.

### 18. Too many campaigns with tiny budgets
**Problem:** Each campaign has too little data for optimization.
**Fix:** Consolidate campaigns. Google needs budget to learn.

### 19. Not using conversion values
**Problem:** All conversions treated equally — a €5 sale optimized like a €500 sale.
**Fix:** Pass dynamic conversion values to Google Ads.

### 20. Ignoring the learning period
**Problem:** Making disruptive changes during learning resets it, causing a cycle of poor performance. Disruptive changes include: bid strategy switches, target CPA/ROAS changes, budget changes >20%, conversion action changes, and major campaign restructuring.
**Fix:** Wait for "Eligible" status before making structural changes. Note: adding negatives, updating ad copy, and adjusting assets are safe during learning and do not reset it. See [[learning-phase]] for the full list.

## Optimization & Monitoring

### 21. "Set and forget" campaigns
**Problem:** Performance degrades over time without optimization.
**Fix:** Weekly search term review, monthly ad and asset review, quarterly strategy review.

### 22. Making too many changes at once
**Problem:** Can't attribute performance changes to specific actions.
**Fix:** One significant change at a time. Wait for data before the next change.

### 23. Ignoring mobile performance
**Problem:** Mobile may convert differently (higher CPC, different conversion path).
**Fix:** Review performance by device. Optimize mobile landing pages.

### 24. Not testing ad variations
**Problem:** Running the same ads indefinitely.
**Fix:** Rotate in new RSA variations. Test different value props and CTAs.

### 25. Focusing on vanity metrics (impressions, clicks)
**Problem:** High clicks ≠ business results.
**Fix:** Optimize for conversions, CPA, and ROAS. Clicks and impressions are supporting metrics.

## PMax-Specific Mistakes

### 26. Not providing custom video assets
**Problem:** Google auto-generates videos from images and text — quality is poor and conversion rates suffer.
**Fix:** Upload at least one custom video per asset group in landscape, square, and vertical orientations.
**Exception: feed-only PMax** — campaigns created via Merchant Center (no creative assets) always auto-generate from the feed. AD STRENGTH = POOR is expected and intentional. Do not flag the absence of video as a mistake for feed-only PMax. Applies only to full PMax campaigns with creative asset groups.

### 27. Not using campaign-level negative keywords
**Problem:** PMax serves ads on irrelevant queries, wasting budget on non-converting traffic.
**Fix:** Add campaign-level negative keywords (up to 10,000 supported). Review search terms report regularly.

### 28. Not reviewing PMax search terms
**Problem:** You don't know what queries PMax is matching against your campaigns.
**Fix:** Review the search terms report — full query visibility has been available since March 2025.

### 29. Reducing PMax budget by more than 20% at once
**Problem:** Large budget cuts reset the learning period, causing weeks of suboptimal performance.
**Fix:** Reduce budget incrementally (max 20% at a time) and wait for stabilization between changes.

### 30. Setting Target ROAS too far above actual performance
**Problem:** Google severely restricts spend to meet unrealistic targets — campaigns stop delivering.
**Fix:** Set Target ROAS within 20% of actual ROAS, then gradually increase over time.

### 31. Not using audience exclusions
**Problem:** PMax spends budget re-targeting existing customers who would convert anyway.
**Fix:** Configure audience exclusions to exclude existing customer lists where appropriate.

### 32. Same audience signal across all asset groups
**Problem:** No differentiation between asset groups — Google treats them the same, defeating the purpose of separate groups.
**Fix:** Assign distinct audience signals per asset group aligned with the product/theme of that group.
