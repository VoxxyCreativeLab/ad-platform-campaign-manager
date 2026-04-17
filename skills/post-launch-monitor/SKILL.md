---
name: post-launch-monitor
description: "Phase-aware post-launch campaign monitoring — Day 1 through Month 2+ MCP checks, learning phase safety, and next-action routing."
argument-hint: "[campaign-name or phase]"
disable-model-invocation: false
---

# Post-Launch Monitor

You are monitoring a recently launched Google Ads campaign. Work through each phase systematically: establish context, determine the monitoring phase, run phase-appropriate MCP checks, assess the learning phase safety gate, and route to action.

## Reference Material

- **Learning phase guide:** [[../../reference/platforms/google-ads/learning-phase|learning-phase.md]]
- **Post-launch playbook:** [[../../reference/platforms/google-ads/post-launch-playbook|post-launch-playbook.md]]
- **Bid strategy reference:** [[../../reference/platforms/google-ads/bidding-strategies|bidding-strategies.md]]
- **Account maturity roadmap:** [[../../reference/platforms/google-ads/strategy/account-maturity-roadmap|account-maturity-roadmap.md]]
- **MCP capabilities:** [[../../reference/platforms/google-ads/mcp/mcp-capabilities|mcp-capabilities.md]]

## Step 1: Establish Context

Before doing anything, ask these four questions:

1. Campaign name and type (Search / Shopping / PMax / Demand Gen / Display / Video)
2. Launch date (or approximate days since launch)
3. Bid strategy (Manual CPC / Max Clicks / Max Conversions / tCPA / tROAS / Maximize Conversion Value)
4. Is there a baseline report from campaign-setup? (Y/N — used for performance comparison)

> [!info] Smart Bidding note
> For campaigns using Smart Bidding (Max Conversions, tCPA, tROAS, Maximize Conversion Value), do not evaluate ROAS or CPA until the campaign exits learning. Always check learning status before drawing performance conclusions.

## Step 2: Determine Monitoring Phase

Based on days since launch, map to the correct phase:

| Days Since Launch | Phase | Primary Focus |
|---|---|---|
| 0–2 | Launch | Verify serving, tracking, budget pacing |
| 3–7 | First Week | Learning status, first search terms, early negatives |
| 8–14 | Mid-Learning | Learning exit assessment, performance vs baseline |
| 15–30 | Post-Learning | Bid strategy upgrade decision, optimization |
| 31–60 | Month 2 | Expansion signals, creative refresh, ROAS review |
| 60+ | Ongoing | Quarterly review cadence |

State the phase clearly before proceeding: "This campaign is in the **[Phase]** phase (Day [X]). Here is what we check at this stage."

## Step 3: Phase-Appropriate MCP Checks

Run the MCP checks for the active phase. Flag anything that requires manual verification.

### Phase: Launch (Days 0–2)

**MCP checks:**
- `get_campaign` — verify `STATUS = ENABLED`. If PAUSED, something blocked it at launch; investigate before continuing.
- `get_campaign_metrics` — check impressions > 0. Zero impressions after 24 hours = likely ad disapproval or targeting too narrow.
- `run_gaql` on `campaign_budget` — verify budget is correct (not accidentally set too low).

**Manual verification required (MCP cannot do this):**
- Tracking tag firing → use Google Tag Assistant
- Consent mode state → use GTM Preview mode
- Landing page loading correctly → manual browser check
- Baseline screenshots → manual capture in Google Ads UI

### Phase: First Week (Days 3–7)

**MCP checks:**
- `run_gaql` on `search_term_view` — pull the first week of search terms. Flag: brand competitor names, spam queries, irrelevant intent.
- `get_campaign` — check `serving_status` for learning state.
- `get_campaign_metrics` — CTR check. Flag if CTR < 2% for Search campaigns.

**Example GAQL for search terms:**
```gaql
SELECT search_term_view.search_term, search_term_view.status,
  metrics.impressions, metrics.clicks, metrics.cost_micros, metrics.conversions
FROM search_term_view
WHERE segments.date DURING LAST_7_DAYS
ORDER BY metrics.cost_micros DESC
LIMIT 100
```

**Manual verification required:**
- Adding negative keywords → Google Ads UI only (MCP cannot write negatives)
- Consent mode → GTM Preview

### Phase: Mid-Learning (Days 8–14)

**MCP checks:**
- `get_campaign_metrics` — impressions, clicks, cost, conversions. Compare to baseline if available.
- `run_gaql` on `keyword_view` — quality scores. Flag: QS ≤ 4 → investigate ad relevance and landing page alignment.
- For PMax: `run_gaql` on `asset_group` — check `ad_strength`. Flag POOR asset groups. **Exception: feed-only PMax created via Merchant Center always shows AD STRENGTH = POOR — this is expected, not a defect. Confirm creation path (MC-created = feed-only) before flagging.**

**Example GAQL for keyword quality scores:**
```gaql
SELECT ad_group_criterion.keyword.text, ad_group_criterion.quality_info.quality_score,
  ad_group_criterion.quality_info.creative_quality_score,
  ad_group_criterion.quality_info.post_click_quality_score,
  ad_group_criterion.quality_info.search_predicted_ctr,
  metrics.impressions, metrics.clicks
FROM keyword_view
WHERE segments.date DURING LAST_14_DAYS
  AND ad_group_criterion.status = 'ENABLED'
ORDER BY metrics.impressions DESC
```

**Manual verification required:**
- Learning exit status → Google Ads UI → Status column (displays "Learning" explicitly)
- If still in learning at Day 14: common causes are budget too low, too few conversions, or account-level changes made during learning.

### Phase: Post-Learning (Days 15–30)

**MCP checks:**
- `get_campaign_metrics` — calculate actual CPA or ROAS. Compare to target from baseline.
- `run_gaql` on `search_term_view` — second pass: identify more negatives + new keyword candidates.
- `run_gaql` on `keyword_view` — ongoing QS monitoring.

**MCP write actions available (after `unlock_writes` + `confirm_change`):**
- `update_campaign_budget` — if budget is limiting performance (check impression share first)
- `update_keyword_bid` — if specific keywords are over- or under-performing
- `update_ad_group_bid` — if ad group-level bid adjustment is needed

**Manual only:**
- Bid strategy upgrade (e.g., Max Conversions → tCPA) → Google Ads UI
- Adding new keywords or negative keywords → Google Ads UI

### Phase: Month 2 (Days 31–60)

**MCP checks:**
- `get_account_metrics` — portfolio view, overall budget allocation across campaigns.
- `run_gaql` on campaign impression share — identify impression share gaps.

**Example GAQL for impression share:**
```gaql
SELECT campaign.name, campaign.id,
  metrics.search_impression_share,
  metrics.search_budget_lost_impression_share,
  metrics.search_rank_lost_impression_share,
  metrics.cost_micros
FROM campaign
WHERE campaign.status = 'ENABLED'
  AND segments.date DURING LAST_30_DAYS
ORDER BY metrics.cost_micros DESC
```

**What to look for:**
- High impression share loss due to budget → budget increase candidate
- CTR declining week-over-week → creative refresh needed (RSA assets in UI)

### Phase: Ongoing (Day 60+)

At this stage, the campaign has exited learning and has sufficient data for performance evaluation. Recommend a quarterly review cadence using `/ad-platform-campaign-manager:campaign-review` for a full 21-area audit.

## Step 4: Compare Against Baseline

**If baseline report exists (from campaign-setup):**

| Metric | Baseline Target | Actual | Delta |
|--------|----------------|--------|-------|
| CTR | {{target}} | {{actual}} | {{delta}} |
| CPA or ROAS | {{target}} | {{actual}} | {{delta}} |
| Impression Share | {{target}} | {{actual}} | {{delta}} |

Flag deviations > 20% from baseline as a warning. Deviations > 50% as critical.

> [!danger] Shopping Campaign ROAS Drop — Special Routing
> If a **Shopping or feed-only PMax campaign** shows ROAS dropped **>30% vs. baseline**, do NOT immediately recommend structural changes. Before any action, load [[../../reference/platforms/google-ads/shopping-performance-regression-diagnosis|shopping-performance-regression-diagnosis.md]] and run the 7-hypothesis diagnosis protocol. Common causes (attribution shift, bid disruption, tracking gap) require investigation before intervention.

**If no baseline exists:**

Note current performance as the Day 30 baseline for Month 2 comparison. Record: impressions, clicks, CTR, cost, conversions, CPA or ROAS.

## Step 5: Learning Phase Safety Gate

> [!warning] Check this before recommending ANY change
> Load [[../../reference/platforms/google-ads/learning-phase|learning-phase.md]] and confirm whether the campaign is still in learning. Do not recommend disruptive changes during the learning phase.

**SAFE during learning — these will not reset the learning period:**
- Add negative keywords (Google Ads UI)
- Update ad copy or RSA assets
- Add observation audiences
- Minor ad schedule tweaks
- Pausing clearly irrelevant keywords

**DISRUPTIVE — avoid these during learning:**
- Bid strategy switch (e.g., Max Conversions → tCPA)
- tCPA or tROAS target change > 10%
- Budget change > 20%
- Conversion action change (adding, removing, or modifying primary conversion)
- Adding or removing ad groups

> [!danger] If the user asks to make a disruptive change while the campaign is still in learning
> Explain the risk clearly: "This change will reset the learning period, which means the campaign restarts its data collection from Day 0. The campaign typically needs 7–14 days to exit learning after a reset. If the account has limited conversion volume, this significantly delays optimization. Recommend waiting until learning is complete unless there is a critical performance problem that outweighs the risk."

## Step 6: Action Routing — MCP vs Manual

After identifying what needs to change, split actions into two lists.

**MCP can execute (after `unlock_writes`):**

| Action | MCP Tool | Cap |
|--------|----------|-----|
| Increase or decrease budget | `update_campaign_budget` | ±50% |
| Adjust keyword bids up | `update_keyword_bid` | +30% |
| Adjust keyword bids down | `update_keyword_bid` | −50% |
| Adjust ad group bids | `update_ad_group_bid` | — |
| Pause underperforming keywords | `pause_keyword` | — |
| Pause underperforming ads | `pause_ad` | — |

Always call `unlock_writes` first, then call `confirm_change` before any write executes.

**Manual only — output as a numbered action list for the Google Ads UI:**

Present manual actions in this format:

"These actions require the Google Ads UI:
1. …
2. …"

Manual-only actions include:
- Add or remove negative keywords
- Edit RSA assets (headlines, descriptions)
- Add or remove ad groups or keywords
- Change bid strategy
- Upload offline conversions
- Create or modify remarketing audiences
- Review ad disapprovals and resubmit

## Step 7: Route to Next Skill

Based on what the monitoring session reveals:

| Finding | Next Skill |
|---|---|
| Structural problems (wasted spend, wrong structure) | `/ad-platform-campaign-manager:campaign-cleanup` |
| Full performance audit needed | `/ad-platform-campaign-manager:campaign-review` |
| Keyword expansion or search term opportunities | `/ad-platform-campaign-manager:keyword-strategy` |
| Bid strategy or budget decision | `/ad-platform-campaign-manager:budget-optimizer` |
| PMax-specific issues (feed, asset groups) | `/ad-platform-campaign-manager:pmax-guide` |
| Tracking gaps (tags not firing, consent issues) | `/ad-platform-campaign-manager:conversion-tracking` |
| **Shopping ROAS dropped >30% vs. baseline** | **Load [[../../reference/platforms/google-ads/shopping-performance-regression-diagnosis\|shopping-performance-regression-diagnosis.md]] — follow the 7-hypothesis protocol before recommending any structural change** |

---

## Report Output

When inside an MWP client project, write output to `reports/{YYYY-MM-DD}/05-optimize/post-launch-monitor.md`.

Follow the 6-step write sequence and Output Completeness Convention in [[_config/conventions]]:
1. Detect MWP project root (look for `_config/conventions.md`)
2. Ensure `reports/{YYYY-MM-DD}/05-optimize/` directory exists
3. Write full report — include phase, all MCP findings, MCP-executable action table, manual action list
4. Update `reports/CONTEXT.md` with new file entry
5. Update `reports/SUMMARY.md` under "Optimization & Reporting"
6. Summarize in conversation: phase, key findings, actions taken vs actions for UI

**Stage:** `05-optimize` | **Summary section:** Optimization & Reporting
