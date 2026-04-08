---
title: "Plan — Backlog Fix + Gap Analysis (v1.13–v1.19)"
date: 2026-04-08
tags:
  - plan
  - ad-platform-campaign-manager
---

# Plan — Backlog Fix + Comprehensive Gap Fill

## Context

During real-world usage on the Vaxteronline (vaxteronline.se) campaign, the plugin gave contradictory guidance about what changes are safe during a Smart Bidding learning phase. This surfaced 9 backlog items (3 contradictions, 4 gaps, 2 future capabilities). A full gap analysis revealed 15+ additional issues: no MCP capability map, orphaned reference files, missing GAQL queries, an absent Consent Mode v2 reference, missing Display campaigns doc, and the biggest workflow gap — no post-launch monitoring skill.

Additionally, the MCP server research revealed a documentation discrepancy (`claude-settings-template.md` lists wrong tool names) and confirmed that skills reference data outside the MCP boundary without telling the user.

This plan groups everything into 7 shippable releases (v1.13.0–v1.19.0), prioritizing correctness fixes first, then the MCP capability foundation, then high-value gaps, then enhancements.

---

## Release Overview

| Release | Name | Size | New Files | Edits | Key Deliverable | Status |
|---------|------|------|-----------|-------|-----------------|--------|
| v1.13.0 | Learning Phase Authority | M | 1 | 5 | `learning-phase.md` + 3 contradiction fixes | ✅ Done (2026-04-08) |
| v1.14.0 | MCP Capability Map | M | 1 | 4 | `mcp-capabilities.md` + settings template fix | ✅ Done (2026-04-08) |
| v1.15.0 | Shopping Queries + Post-Launch Playbook | L | 1 | 5 | `post-launch-playbook.md` + Shopping GAQL | ✅ Done (2026-04-08) |
| v1.16.0 | GAQL Expansion + Orphaned File Wiring | M | 0 | 6 | 8 new GAQL sections + 3 orphaned files wired | ⬜ Open |
| v1.17.0 | Consent Mode v2 | M | 1 | 3 | `consent-mode-v2.md` + conversion-tracking enhancement | ⬜ Open |
| v1.18.0 | Post-Launch Monitor Skill | L | 1 | 5 | New `post-launch-monitor` skill + live-report expansion | ⬜ Open |
| v1.19.0 | Display, Brand Restrictions, NCA | M | 1 | 3 | `display-campaigns.md` + Search brand restrictions + NCA goal | ⬜ Open |

**Totals:** 6 new files, ~31 file edits across 7 releases.

## Dependency Graph

```
v1.13.0 (Learning Phase) ─── must be first (correctness fix) ✅
    │
    ▼
v1.14.0 (MCP Capability Map) ─── foundational for all MCP-using releases ✅
    │
    ▼
v1.15.0 (Shopping + Playbook) ─── references learning-phase.md, uses MCP boundary awareness ✅
    │
    ├──▶ v1.16.0 (GAQL + Wiring) ─── independent, logically after ← NEXT
    │
    └──▶ v1.18.0 (Monitor Skill) ─── references learning-phase.md + playbook + capability map
         │
         ▼
         v1.19.0 (Display, Brand, NCA) ─── lowest priority, last

v1.17.0 (Consent Mode) ─── independent, references capability map for "not in API" boundary
```

---

## v1.13.0 — Learning Phase Authority ✅ Done

**Why first:** Users are actively hitting contradictions in live client work. This is a correctness fix.

**Backlog items addressed:** #1, #2, #3, #4, #7

### New file
- **`reference/platforms/google-ads/learning-phase.md`** — Single source of truth: safe/disruptive tables, per-type durations, UI status guide, post-learning checklist.

### Files modified
1. `reference/platforms/google-ads/bidding-strategies.md` — lines 123, 151
2. `reference/platforms/google-ads/pmax/feed-only-pmax.md` — Post-Launch restructured + migration step 6
3. `reference/platforms/google-ads/audit/common-mistakes.md` — mistake #20 expanded
4. `reference/platforms/google-ads/demand-gen.md` — "before making changes" clarified
5. `reference/platforms/google-ads/audit/audit-checklist.md` — Demand Gen learning check
6. `reference/platforms/google-ads/CONTEXT.md` + root `CONTEXT.md`

---

## v1.14.0 — MCP Capability Map ✅ Done

**Why second:** Foundational for all MCP-using releases. Also fixes live documentation discrepancy.

### New file
- **`reference/mcp/mcp-capabilities.md`** — 6 sections: 25 tools by category, GAQL resources (21), blocked operations (12), external data systems (10), data flow map, per-skill usage summary (17).

### Files modified
1. `reference/mcp/claude-settings-template.md` — 4 wrong tool names fixed + `get_campaign` added
2. `reference/mcp/CONTEXT.md` — file count 3→4
3. Root `CONTEXT.md` — 5 Load columns updated
4. `CLAUDE.md` — MCP boundary awareness permanent rule added

---

## v1.15.0 — Shopping Queries + Post-Launch Playbook ✅ Done

**Why third:** Fills the biggest knowledge gap (guidance scattered across 6+ files) + unblocks e-commerce audit completeness.

**Backlog items addressed:** #5, #6, #9 (partial)

### New file
- **`reference/platforms/google-ads/strategy/post-launch-playbook.md`** — Day 0 through Week 8: launch checklist, Smart Bidding upgrade gates, per-type milestones, MCP boundary table per task.

### Files modified
1. `reference/reporting/gaql-query-templates.md` — 4 Shopping queries (top products, zombies, category, low-CTR)
2. `skills/live-report/references/report-templates.md` — Shopping Product Performance template
3. `skills/live-report/SKILL.md` — 7th report type added
4. `reference/platforms/google-ads/CONTEXT.md` + root `CONTEXT.md`

---

## v1.16.0 — GAQL Expansion + Orphaned File Wiring

**Why fourth:** High value-to-effort ratio. Expands reporting foundation from ~12 → ~24 queries. Connects 3 existing reference files never wired into skills.

### Files to modify

1. **`reference/reporting/gaql-query-templates.md`** — Add 8 new query sections:
   - PMax Campaign Performance (channel breakdown)
   - PMax Asset Group Performance (`asset_group_asset`, `asset_group_listing_group_filter`)
   - Display Placement Report (`group_placement_view`)
   - Demand Gen Performance (filter by `DEMAND_GEN` channel)
   - Video Campaign Performance (video metrics)
   - Auction Insights (note: limited GAQL support, partial UI-only)
   - Conversion Action Breakdown (`conversion_action`)
   - Asset Performance (`ad_group_ad_asset_view`)

2. **`skills/budget-optimizer/SKILL.md`** — Add `[[seasonal-planning]]` + `[[bid-adjustment-framework]]` references + callouts

3. **`skills/keyword-strategy/SKILL.md`** — Add `[[remarketing-strategies]]` reference + "### Existing Account: Search Term Analysis Workflow" section

4. **`skills/campaign-cleanup/SKILL.md`** — Add `campaign-review` to "Recommend next skills" routing

5. **`skills/CONTEXT.md`** — Update dependency maps for budget-optimizer, keyword-strategy, campaign-cleanup

6. **`reference/platforms/google-ads/CONTEXT.md`** — Update Used By table for seasonal-planning, bid-adjustment-framework, remarketing-strategies

### Verification
- All 3 formerly orphaned files appear in at least one skill's Reference Material
- GAQL query count in gaql-query-templates.md is now ~24
- Every new GAQL query uses a resource listed in `mcp-capabilities.md` Section 2

---

## v1.17.0 — Consent Mode v2

**Why independent:** Critical for EU clients (NL/SE). 16 files mention consent mode as one-liners. Fully independent — can ship in any order after v1.14.0.

### New file
- **`reference/platforms/google-ads/consent-mode-v2.md`** — v1 vs v2 comparison, four signals, Advanced vs Basic mode, behavioral modeling, CMP requirements (TCF v2.2), EEA enforcement (March 2024), Smart Bidding impact, GTM/sGTM implementation, verification via Tag Assistant, common mistakes. MCP boundary note: consent state NOT in Google Ads API.

### Files to modify
1. **`skills/conversion-tracking/SKILL.md`** — Add "## Consent Mode" section with diagnostic questions, `[[consent-mode-v2]]` reference, testing checklist, MCP boundary note
2. **`reference/platforms/google-ads/CONTEXT.md`** — Add `consent-mode-v2.md`
3. **Root `CONTEXT.md`** — Add to Load for conversion tracking row

---

## v1.18.0 — Post-Launch Monitor Skill + Live Report Expansion

**Why:** Biggest workflow gap. Plugin covers strategy→plan→build→launch but drops off at launch.

### New skill
- **`skills/post-launch-monitor/SKILL.md`** — Phase-based monitoring (Day 1/7/14/30): MCP checks per phase, safe-only actions during learning, MCP-executable vs manual-only action routing, references `[[learning-phase]]` + `[[post-launch-playbook]]` + `[[mcp-capabilities]]`. Report Output: stage `05-optimize`.

### Files to modify
1. `skills/live-report/SKILL.md` — Add 3 new report types: Audience Performance, PMax Asset Group Performance, Conversion Action Breakdown
2. `skills/live-report/references/report-templates.md` — GAQL + templates for 3 new types
3. `skills/campaign-setup/SKILL.md` — Add `post-launch-monitor` to "What to Do Next"
4. `skills/CONTEXT.md` — Skill count 13→14, dependency map
5. Root `CONTEXT.md` + `CLAUDE.md` — Routing row + quick navigation

---

## v1.19.0 — Display, Brand Restrictions, NCA

**Why last:** Medium priority content gaps. Display needs a full reference doc (20 audit checks exist with no backing reference).

### New file
- **`reference/platforms/google-ads/display-campaigns.md`** — Standard Display vs Smart Display, Responsive Display Ad specs, targeting types, exclusion management, frequency capping, performance benchmarks, common mistakes, cross-references to 20 audit checks.

### Files to modify
1. `reference/platforms/google-ads/match-types.md` — Add "## Brand Restrictions for Search" section
2. `reference/platforms/google-ads/campaign-types.md` — Add NCA goal to PMax and Search sections
3. `reference/platforms/google-ads/CONTEXT.md` — Add `display-campaigns.md`

---

## Deferred Items

| Item | Reason |
|------|--------|
| Product-level performance skill (Backlog #9) | Partially addressed in v1.15 (Shopping GAQL); standalone skill deferred |
| Phase 4: Multi-platform | No user demand |
| Privacy Sandbox / Topics API | Google handles server-side; limited direct action |
| MCP server tool expansion (add negatives, create) | Requires MCP server dev, not plugin changes |
| Remarketing/audience strategy skill | Reference wired in v1.16; full skill deferred |
| A/B testing / experimentation skill | `ad-testing-framework.md` exists; skill deferred |
| DSA / App Campaign audit (Priority 4) | Low priority, niche |
