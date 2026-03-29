---
name: pmax-guide
description: Performance Max guidance — asset groups, audience signals, feed optimization, PMax metrics interpretation. Use when working with PMax campaigns.
disable-model-invocation: false
---

# Performance Max Guide

You are helping with Performance Max (PMax) campaign setup, optimization, or analysis. PMax campaigns are complex — explain clearly.

## Reference Material

- **Asset requirements:** [[../../reference/platforms/google-ads/pmax/asset-requirements|asset-requirements.md]]
- **Audience signals:** [[../../reference/platforms/google-ads/pmax/audience-signals|audience-signals.md]]
- **Feed optimization:** [[../../reference/platforms/google-ads/pmax/feed-optimization|feed-optimization.md]]
- **PMax metrics & reporting:** [[../../reference/platforms/google-ads/pmax/pmax-metrics|pmax-metrics.md]]
- **Campaign types overview:** [[../../reference/platforms/google-ads/campaign-types|campaign-types.md]] (PMax section)
- **Bidding strategies:** [[../../reference/platforms/google-ads/bidding-strategies|bidding-strategies.md]]

## Common Tasks

### Setting Up a New PMax Campaign
1. Define campaign goal and bid strategy
2. Design asset group structure (by product category or audience)
3. Configure audience signals per asset group
4. List required creative assets with specifications
5. Set up listing groups (if Shopping/feed-based)
6. Configure brand exclusions
7. Discuss conversion tracking requirements

### Optimizing an Existing PMax Campaign
1. Review asset performance ratings (Best/Good/Low)
2. Identify and replace underperforming assets
3. Refine audience signals based on Insights tab data
4. Check search term categories for brand cannibalization
5. Evaluate channel distribution (Search vs Display vs YouTube)
6. Assess whether PMax is truly incremental vs cannibalizing Search

### Interpreting PMax Reports
Help the user understand PMax-specific metrics:
- Asset group performance and status
- Asset performance ratings and what they mean
- Search term insights (categories, not individual terms)
- Audience insights
- Channel distribution

### Feed Optimization (Shopping/E-commerce)
Walk through product feed improvements:
- Title optimization formula and examples
- Required vs recommended attributes
- Custom labels for campaign segmentation
- Supplemental feed strategy

## Key Points to Emphasize

- PMax needs 30+ conversions/month for effective optimization
- Audience signals are **hints**, not hard targeting
- Always provide custom video (don't rely on auto-generated)
- Brand exclusion lists prevent cannibalizing brand Search campaigns
- Allow 2-4 weeks before making asset changes (learning period)
- PMax works best with good conversion tracking — check with `/ad-platform-campaign-manager:conversion-tracking`

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| PMax spending but few or no conversions | Insufficient conversion volume for optimization (needs 30+/month) or wrong conversion action set as primary | Verify primary conversion action is correct; if volume is too low, consider pausing PMax and building history with Search first |
| Asset ratings all "Low" | Assets don't match audience expectations or too few variations provided | Replace low-rated assets with new variations; ensure 15+ headlines, 5+ descriptions, and a mix of image ratios; allow 2 weeks before re-evaluating |
| PMax cannibalizing brand Search campaigns | PMax serves brand terms by default and captures conversions that Search would have won | Add brand exclusion lists to PMax; compare incrementality by pausing PMax for 2 weeks and measuring total conversions |
| Search term categories show irrelevant traffic | Audience signals are too broad or product feed titles are vague | Narrow audience signals; improve feed titles with specific product attributes; add negative keywords at account level |
| Campaign stuck in "Learning" for 3+ weeks | Too many changes or not enough conversion data | Stop making edits for 2 weeks; if volume is too low, increase budget or consolidate asset groups to concentrate conversions |
| Auto-generated video looks poor | No custom video was provided — Google assembles one from images | Upload at least one custom video (even a simple slideshow); auto-generated videos consistently underperform |
