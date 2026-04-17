---
title: Account Scaling Skill + Projection Guardrail — Implementation Plan
date: 2026-04-17
tags: [plan, v1.23.0, account-scaling, projection-guardrail]
---

# Account Scaling Skill + Projection Guardrail — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship `/account-scaling` skill (8-gate MCP evaluation + T1-T6 trajectory routing + always-report) and a 3-layer projection guardrail preventing unsubstantiated client projections, bundled as v1.23.0.

**Architecture:** Two deliverables coordinated in one release. The skill is a new standalone file at `skills/account-scaling/SKILL.md` backed by a new reference at `reference/platforms/google-ads/strategy/scaling-playbook.md`. The guardrail is a convention rule added at 3 layers: `~/.claude/CLAUDE.md` (one-liner), `project-structure-and-scaffolding-plugin/_config/conventions.md` (generic), and `_config/conventions.md` (domain-specific with ROAS/CPA examples).

**Tech Stack:** Markdown, Obsidian-flavored syntax, YAML frontmatter, GAQL, Claude Code plugin conventions.

**Spec:** `docs/superpowers/specs/2026-04-17-account-scaling-design.md`

---

## Pre-flight: Check Uncommitted State

> [!warning] Pre-existing uncommitted changes
> Git status shows 9 modified files including n8n routing entries in `skills/CONTEXT.md` and 4 skills pointing to `n8n-workflow-builder-plugin:*` skills that do not exist yet. Before committing ANY v1.23.0 work, decide what to do with these:
>
> - (a) **Revert** — the n8n plugin doesn't exist; the routing rows are premature
> - (b) **Commit separately** as a standalone prep commit before v1.23.0 work begins
> - (c) **Bundle** with v1.23.0 (only if n8n plugin is imminent)
>
> **Ask Jerry before proceeding. Do not decide unilaterally.** Once resolved, all v1.23.0 commits should contain only v1.23.0 changes.

---

## File Map

### New files (2)
| File | Responsibility |
|---|---|
| `skills/account-scaling/SKILL.md` | Skill: entry gate, 4-phase flow (MCP pull → 8 gates → T1-T6 routing → report write), projection guardrail enforcement |
| `reference/platforms/google-ads/strategy/scaling-playbook.md` | Reference: gate rationale, channel ladder, T1-T6 full tables, honest gap statement, external playbooks, Google URLs, repos |

### Modified files — ad-platform (8)
| File | Change |
|---|---|
| `_config/conventions.md` | Add `## Client Communication Guardrails` section (Layer 3, domain-specific) |
| `CONTEXT.md` | Add routing row above "Budget / bids" entry |
| `CLAUDE.md` | Add Quick Navigation entry |
| `reference/platforms/google-ads/strategy/account-maturity-roadmap.md` | tROAS discrepancy footnote at line 32 + link to scaling-playbook at Stage 3/4 |
| `reference/platforms/google-ads/bidding-strategies.md` | Add PMax/Shopping Ad Rank callout (Oct 2024 change) |
| `BACKLOG.md` | Mark #23 + #28 done |
| `CHANGELOG.md` | Add v1.23.0 entry |
| `PRIMER.md` | Session handoff rewrite |

### Modified files — master plugin (1)
| File | Change |
|---|---|
| `c:\Users\VCL1\Voxxy Creative Lab Limited\08 - Projects\0001 - Claude Plugins\project-structure-and-scaffolding-plugin\_config\conventions.md` | Add `## Client Communication Guardrails` section (Layer 2, generic) |

### Modified files — global (1)
| File | Change |
|---|---|
| `C:\Users\VCL1\.claude\CLAUDE.md` | Add one-line rule under new `## Client Communication` heading |

---

## Task 1: Guardrail Layer 1 — Global CLAUDE.md

**Files:**
- Modify: `C:\Users\VCL1\.claude\CLAUDE.md`

- [ ] **Step 1: Read the file**

  Read `C:\Users\VCL1\.claude\CLAUDE.md` to see current content (currently only "# Global Rules" with a Markdown Format section).

- [ ] **Step 2: Add the Client Communication section**

  Append this to the end of the file:

  ```markdown
  ## Client Communication

  Never state a future ROAS/CPA/budget-return projection or timeline commitment in any client-facing output without a dated strategy document on file. See `ad-platform-campaign-manager/_config/conventions.md` §Client Communication Guardrails for full rule, regulatory basis, and examples.
  ```

- [ ] **Step 3: Verify**

  Re-read the file. Confirm the new section appears, the existing Markdown Format section is untouched, and the file has no stray whitespace or formatting errors.

- [ ] **Step 4: Commit**

  ```bash
  cd "c:/Users/VCL1/Voxxy Creative Lab Limited/08 - Projects/0001 - Claude Plugins/ad-platform-campaign-manager"
  git add "C:/Users/VCL1/.claude/CLAUDE.md"
  git commit -m "chore: add projection guardrail one-liner to global CLAUDE.md (v1.23.0 Layer 1)"
  ```

  Note: If git cannot stage a file outside the repo root, manually copy the text and update the file directly.

---

## Task 2: Guardrail Layer 2 — Master Plugin Conventions

**Files:**
- Modify: `c:\Users\VCL1\Voxxy Creative Lab Limited\08 - Projects\0001 - Claude Plugins\project-structure-and-scaffolding-plugin\_config\conventions.md`

- [ ] **Step 1: Read the file**

  Read the master plugin's `_config/conventions.md`. Current sections: File Naming, Folder Naming, Output Conventions, Version Control, Review & Handoff, Project-Specific Conventions.

- [ ] **Step 2: Append the Client Communication Guardrails section**

  Add this at the end of the file (after Project-Specific Conventions):

  ```markdown
  ## Client Communication Guardrails

  **Substantiation Before Projection.** Never state a future performance target, outcome projection, volume forecast, or timeline commitment in any client-facing output (report, summary, conversation text, message) that does not appear in a dated strategy document held on file — a spec, report, or plan approved by the client on a recorded date.

  If no documented target exists, describe the **data gate** that determines the next decision rather than the expected outcome.

  **Prohibited:** "This implementation should improve conversion tracking by 40%."
  **Required:** "Once Enhanced Conversions is active, compare reported conversions in Google Ads against the BigQuery event log for 30 days. If the delta is <5%, conversion data quality is confirmed."

  Regulatory backing: FTC Advertising Substantiation doctrine (reasonable basis before dissemination); UK CAP Code §§ 3.1 / 3.7 / 3.34 (documentary evidence held before the claim); DMCC Act 2024 fines.

  Reference: [FTC Advertising Substantiation](https://www.ftc.gov/legal-library/browse/ftc-policy-statement-regarding-advertising-substantiation) · [ASA Substantiation](https://www.asa.org.uk/advice-online/substantiation.html)

  > [!info] Domain-specific extensions
  > Plugins that work with performance metrics (conversion rates, ROAS, CPA, revenue projections) should add a domain-specific Client Communication Guardrails section to their own `_config/conventions.md` with concrete examples for their domain. The ad-platform-campaign-manager plugin's version includes Google Ads ROAS/CPA examples.
  ```

- [ ] **Step 3: Verify**

  Re-read the file. Confirm: generic framing (no Google-Ads jargon), FTC + UK CAP + DMCC cited, Prohibited/Required example uses GTM/tracking language (not campaign language), new section is at end, existing sections untouched.

- [ ] **Step 4: Commit in master plugin repo**

  ```bash
  cd "c:/Users/VCL1/Voxxy Creative Lab Limited/08 - Projects/0001 - Claude Plugins/project-structure-and-scaffolding-plugin"
  git add "_config/conventions.md"
  git commit -m "feat: add Client Communication Guardrails convention (projection substantiation rule)"
  ```

---

## Task 3: Guardrail Layer 3 — Ad-Platform Conventions

**Files:**
- Modify: `_config/conventions.md`

- [ ] **Step 1: Read the file**

  Read `_config/conventions.md`. Current final section is `## Report File-Writing Convention` (ends at line 272). New section goes after this.

- [ ] **Step 2: Append the Client Communication Guardrails section**

  Append at the end of the file:

  ```markdown
  ---

  ## Client Communication Guardrails

  > [!info] Cross-plugin rule
  > This section extends the master plugin's generic Client Communication Guardrails rule (in `project-structure-and-scaffolding-plugin/_config/conventions.md`) with Google Ads-specific language and examples.

  **Substantiation Before Projection.** Never state a future ROAS target, conversion volume projection, budget-return forecast, or timeline commitment in any client-facing output (report, SUMMARY.md, conversation text, message) that does not appear in a dated strategy document held on file — a spec, report, or plan approved by the client on a recorded date.

  If no documented target exists, describe the **data gate** that determines the next decision rather than the expected outcome.

  **Prohibited:** "Scaling to 2x budget should produce a 1.4x ROAS."
  **Required:** "Budget-lost-IS is 22% on the top five campaigns. If tCPA holds within 15% of target for 30 days after a +20% budget step, the next +20% step is data-supported."

  Additional prohibited forms:
  - "This account should hit [X] conversions by [month]."
  - "At this trajectory, ROAS will reach [X] in Q[Y]."
  - "Expect CPA to drop to [X] once Smart Bidding matures."

  ### Regulatory Basis

  - **FTC Advertising Substantiation doctrine** — reasonable basis required before dissemination. `ftc.gov/legal-library/browse/ftc-policy-statement-regarding-advertising-substantiation`
  - **UK CAP Code §§ 3.1 / 3.7 / 3.34** — documentary evidence held BEFORE the claim is made. `asa.org.uk/advice-online/substantiation.html`
  - **DMCC Act 2024** — backs CAP Code enforcement with material fines.

  ### Scope

  This rule applies to all 15 skills and 3 agents in this plugin. It covers every client-facing output surface: reports, SUMMARY.md, ad copy recommendations, conversation text, and any message intended for or shared with a client.

  ### Root Cause (for context)

  On 2026-04-16 an email was drafted for a client projecting "5x ROAS in June/July." That figure appeared in no strategy document, no spec, and no approved plan. This convention was introduced so no skill or agent can generate that output in the future.
  ```

- [ ] **Step 3: Verify**

  Re-read `_config/conventions.md`. Confirm: domain-specific examples (ROAS/CPA), references master as parent, all 3 regulatory citations present (FTC + UK CAP + DMCC), "additional prohibited forms" list is complete, scope explicitly names 15 skills + 3 agents, root cause note present.

- [ ] **Step 4: Commit**

  ```bash
  git add _config/conventions.md
  git commit -m "feat: add Client Communication Guardrails to conventions (v1.23.0 Layer 3)"
  ```

---

## Task 4: Update `account-maturity-roadmap.md`

**Files:**
- Modify: `reference/platforms/google-ads/strategy/account-maturity-roadmap.md`

Two changes: tROAS discrepancy footnote at line 32, and links to `scaling-playbook.md` from Stage 3 and Stage 4 sections.

- [ ] **Step 1: Read the file around line 32**

  Read lines 28-40. Current text at line 32:
  ```
  Smart Bidding is a machine learning system. It needs data to function. The minimum threshold Google states for tCPA is **30 conversions in the last 30 days**; for tROAS, **50 conversions in the last 30 days** on the campaign.
  ```

- [ ] **Step 2: Add tROAS discrepancy footnote**

  After the line 34 fact-check comment (`%%fact-check: Smart Bidding minimum conversion thresholds...%%`), add:

  ```markdown
  > [!warning] tROAS threshold discrepancy
  > The 50-conversion threshold above reflects campaign-level tROAS. Google's Portfolio Bid Strategy documentation (`support.google.com/google-ads/answer/6268637`) cites **15 conversions in the past 30 days** for Search/Display tROAS at the portfolio level. The gap may reflect portfolio-level vs campaign-level requirements, or an update since this doc was written. When advising on tROAS eligibility, cite the live URL and recommend the user confirm the current threshold in their account — do not hardcode either number. See [[strategy/scaling-playbook|scaling-playbook.md]] §Gate 4 for the skill's handling of this discrepancy.
  ```

- [ ] **Step 3: Find Stage 3 scaling section**

  Read lines 334-380 (Stage 3 content). The section "Now you can begin scaling" is around line 338. Find the paragraph that begins "Now you can begin scaling."

- [ ] **Step 4: Add scaling-playbook link to Stage 3**

  After the sentence "Now you can begin scaling — but scaling requires expanding into new campaign types with discipline, not excitement." (around line 338), add:

  ```markdown
  > [!info] Account Scaling Skill
  > Use `/ad-platform-campaign-manager:account-scaling` to run a structured 8-gate evaluation before any scaling action. See [[strategy/scaling-playbook|scaling-playbook.md]] for the full channel ladder, trajectory routing, and scaling mechanics reference.
  ```

- [ ] **Step 5: Find Stage 4 section**

  Read lines 475-540 (Stage 4 content). Find the opening paragraph of Stage 4.

- [ ] **Step 6: Add scaling-playbook link to Stage 4**

  After the Stage 4 intro paragraph (around line 481, note about "Stage 4 is Not Done"), add:

  ```markdown
  > [!info] Account Scaling at Stage 4
  > Stage 4 accounts are candidates for T6 (Portfolio Consolidation) and T4 (Demand Gen expansion). Use `/ad-platform-campaign-manager:account-scaling` to evaluate all 8 gates before acting. See [[strategy/scaling-playbook|scaling-playbook.md]] for T6 trigger conditions and portfolio bid strategy mechanics.
  ```

- [ ] **Step 7: Verify**

  Re-read the three modified locations. Confirm: discrepancy footnote cites both thresholds (50 and 15) + live URL + scaling-playbook link. Stage 3 callout links to skill + playbook. Stage 4 callout mentions T6 + T4. No existing content removed or altered.

- [ ] **Step 8: Commit**

  ```bash
  git add reference/platforms/google-ads/strategy/account-maturity-roadmap.md
  git commit -m "docs: tROAS threshold discrepancy footnote + scaling-playbook links (v1.23.0)"
  ```

---

## Task 5: Update `bidding-strategies.md`

**Files:**
- Modify: `reference/platforms/google-ads/bidding-strategies.md`

One addition: PMax vs Shopping Ad Rank callout (Oct 2024). ECPC deprecation is already present at line 70.

- [ ] **Step 1: Read lines 95-115**

  Current content around line 101:
  ```markdown
  | PMax | Max Conv Value + tROAS | PMax works best with value-based |
  ```
  The Strategy Recommendations table ends around line 101, followed by `## Additional Strategies` at line 103.

- [ ] **Step 2: Add the Ad Rank callout after the Strategy Recommendations table**

  After the table (after line 101, before `## Additional Strategies`), add:

  ```markdown
  > [!warning] PMax vs Shopping — Ad Rank decides (Oct 2024)
  > Since October 2024, Performance Max and Shopping campaigns compete through Ad Rank rather than PMax automatically winning. PMax no longer receives budget priority over Shopping campaigns by default. When an account runs both PMax and Standard Shopping, do not assume PMax dominates — check impression share per campaign type and verify budget allocation is intentional. The `/ad-platform-campaign-manager:account-scaling` skill branches on this when evaluating T3 (Channel Expansion — Feed-Only PMax).
  ```

- [ ] **Step 3: Verify**

  Re-read lines 95-120. Confirm: Ad Rank callout is present after the table, ECPC warning at line 70 is untouched, no other content altered.

- [ ] **Step 4: Commit**

  ```bash
  git add reference/platforms/google-ads/bidding-strategies.md
  git commit -m "docs: PMax vs Shopping Ad Rank correction Oct 2024 (v1.23.0)"
  ```

---

## Task 6: Create `scaling-playbook.md`

**Files:**
- Create: `reference/platforms/google-ads/strategy/scaling-playbook.md`

- [ ] **Step 1: Create the file with full content**

  Create `reference/platforms/google-ads/strategy/scaling-playbook.md` with this exact content:

  ````markdown
  ---
  title: Google Ads Scaling Playbook
  date: 2026-04-17
  tags:
    - reference
    - strategy
    - scaling
    - google-ads
  ---

  # Google Ads Scaling Playbook

  This file is the knowledge base for the `/ad-platform-campaign-manager:account-scaling` skill. Read it when you need the rationale behind a gate, the mechanics of a trajectory, or the research behind a threshold. The skill is the operational tool; this file is the reference.

  ---

  ## 1. Purpose + Entry Criteria

  This playbook applies to **Stage 3 and Stage 4 accounts only** — defined as 30+ conversions/month, stable CPA/ROAS, and a proven keyword portfolio. Stage 1 and Stage 2 accounts should not be scaled; they should be developed. See [[account-maturity-roadmap]] for stage definitions.

  Entry question: "Is this account ready to grow?" That question has a yes/no answer at any given moment. The 8 gates below produce that answer. A partial pass (5 of 8 gates) is not a pass — it is a list of what must be fixed before scaling.

  ---

  ## 2. The 8 Gates

  All gates must pass for a scaling trajectory to activate. Gate failures trigger T5 (Stabilization Required) before any budget step is considered.

  | # | Gate | Rationale | Failure means |
  |---|---|---|---|
  | 1 | Maturity stage (Stage 3+) | Scaling an immature account accelerates waste, not growth | Clear Stage 1/2 work first |
  | 2 | Monthly conversion volume (≥30/mo) | Smart Bidding needs data; scaling without volume locks the algorithm | Build volume before expanding budget |
  | 3 | CPA/ROAS stability (CoV ≤20%) | A volatile account scaled up just scales up the volatility | Find the root cause (attribution, tracking, seasonality) before adding budget |
  | 4 | Bid strategy fit (tCPA/tROAS active when eligible) | Max Conversions and Manual CPC leave conversion value on the table once volume allows Smart Bidding | Graduate bid strategy before expanding budget |
  | 5 | IS headroom (budget-lost IS ≥15% on any campaign) | If rank is the limiter (not budget), adding budget does not improve results | Address quality signals (QS, ad relevance, LPE) before budget steps |
  | 6 | Learning phase clear | Budget changes during learning restart the learning period, compounding the delay | Wait for learning to exit; only safe changes during learning (see [[learning-phase]]) |
  | 7 | Negative keyword hygiene (≤10% irrelevant in top-50 terms) | Scaling a dirty account scales up wasted spend proportionally | Clean negatives before adding budget |
  | 8 | Tracking infrastructure (EC active, DDA eligible) | Scaling without EC means Smart Bidding optimizes on incomplete data | Fix tracking before scaling; EC recovery is low-cost, scaling without it is high-cost |

  **Delegation map** — the skill links to these existing sources for gate logic; it does not restate them:

  | Gate | Delegates to |
  |---|---|
  | #4 (bid strategy fit) | [[../../skills/budget-optimizer/SKILL.md\|budget-optimizer]] L40-48 |
  | #5 (IS headroom) | [[../../skills/budget-optimizer/SKILL.md\|budget-optimizer]] L69-87 |
  | #2+#3 (volume + CoV thresholds) | [[account-maturity-roadmap]] L325-331, 465-471, 632-647 |
  | #6 (learning phase) | [[../learning-phase\|learning-phase.md]], [[../../skills/post-launch-monitor/SKILL.md\|post-launch-monitor]] L170-191 |
  | #7 (neg-kw hygiene) | [[../audit/audit-checklist\|audit-checklist.md]] Area 8 |

  **The skill's unique contribution:** Gate #3 CoV computation from daily MCP data (no other skill computes CoV), single go/no-go verdict, trajectory routing.

  ---

  ## 3. Scaling Playbook by Channel

  Channels are introduced sequentially. Do not expand to the next channel while the current one is unstable.

  ### Search (IS-led budget steps)

  Trigger: Gate #5 passes (budget-lost IS ≥15%).

  1. Identify campaigns where `search_budget_lost_impression_share ≥ 0.15`
  2. Apply +20% budget step to those campaigns only
  3. Wait minimum 14 days — no other changes during this period
  4. Re-run `/account-scaling` after 14 days
  5. Confirm CPA held within 15% of pre-step baseline before next +20% step

  **Note:** The +20% rule is Search-specific (IS-led). It does not apply universally — see §4 below.

  ### Feed-Only PMax *(e-commerce only)*

  Trigger: Stage 3 + Search stable for 8+ consecutive weeks + Merchant Center confirmed + no existing PMax campaign.

  1. Route to `/ad-platform-campaign-manager:pmax-guide` for creation
  2. Set PMax budget at 20-25% of current Search budget
  3. Monitor Search impression share weekly — if Search IS drops >10 percentage points, reduce PMax budget before investigating (PMax/Search cannibalization signal)
  4. Re-run `/account-scaling` after 4 weeks; T3 remains active until PMax is stable
  5. **Oct 2024 note:** PMax competes with Shopping via Ad Rank — not automatic priority. Monitor Shopping IS alongside Search IS.

  ### Display Remarketing

  Trigger: Stage 3+ + Search and Shopping hitting targets + remarketing list ≥1,000 users.

  1. Start with retention audience only (past 90-day converters or high-value pages)
  2. Budget cap: 5% of total account budget
  3. Wait 4 weeks of stable performance before expanding
  4. Do not mix retention and prospecting in the same campaign at this stage

  ### Demand Gen

  Trigger: Display remarketing stable 4+ weeks + remarketing list ≥1,000 users.

  1. Start with lookalike audience (similar to converters)
  2. Budget cap: 10% of total account budget (test bucket)
  3. **Geo-holdout required** before scaling Demand Gen past 15% of budget — Performance Planner does not model cross-campaign cannibalization; a geo-holdout experiment is the only way to confirm incrementality
  4. Do not combine Demand Gen expansion with a Search budget step in the same 14-day window

  ### YouTube / Video *(Stage 4 only)*

  Trigger: Stage 4 + Demand Gen stable + incrementality confirmed via geo-holdout.

  Full incrementality measurement (Conversion Lift or geo-experiment) required before any significant budget allocation. See [[../video-campaigns|video-campaigns.md]] and `support.google.com/google-ads/answer/12003020`.

  ---

  ## 4. Budget Step Mechanics

  The "+20% budget step" rule is commonly misattributed as universal. It is not.

  | Channel | Step rule | Source |
  |---|---|---|
  | Search (IS-led) | +10-20% per step, wait 14 days | Dilate, KlientBoost, WordStream (consensus) |
  | Display | +20% per step, wait for learning exit | Original Google guidance — Display-scoped |
  | PMax | +15-20% every 3-7 days (higher-budget accounts) | Solutions 8, clicksinmind |
  | Demand Gen | 10% test bucket max; hold until geo-holdout | — |

  **Search scaling does not use the Display +20% rule.** Search scaling is governed by CoV stability (Gate #3) and IS headroom (Gate #5). Applying Display step mechanics to Search produces budget growth without performance validation.

  **Minimum wait period:** 14 days after any budget step before the next step or bid strategy change. This ensures at least one full week of settled data on each side of the change. (WordStream, KlientBoost, clicksinmind — consistent across sources.)

  ---

  ## 5. The Six Scaling Trajectories (T1-T6)

  Multiple trajectories can be active simultaneously. Priority execution order: **T5 → T2 → T1 → T3 / T4 / T6.**

  When T5 is active, no other trajectory's budget or channel actions are taken until T5 gates clear.

  | Trajectory | Trigger conditions | Action sequence | Delta cap / wait |
  |---|---|---|---|
  | **T1: Budget Scale-Up** | Gate #5 PASS (IS lost to budget ≥15%) + Gates #1-3 PASS | +20% budget on IS-limited Search campaigns → wait 14 days, no other changes → re-run skill → confirm CPA within 15% of baseline → next +20% or hold | +20% per step; 14-day minimum between steps |
  | **T2: Bid Strategy Graduation** | Gates #2+#3 PASS (volume + stability at threshold) + Gate #4 FAIL (Max Conv or Manual CPC when tCPA/tROAS eligible) | Set tCPA at actual CPA × 1.15 → monitor 2-week learning → tighten 5-10% every 2 stable weeks → tROAS when 50+ conv/mo confirmed | tCPA at actual × 1.15 initial; tighten 5-10% per 2-week cycle |
  | **T3: Channel Expansion — Feed-Only PMax** *(e-comm only)* | Stage 3 + Search stable 8+ weeks + Merchant Center confirmed + no existing PMax | Route to `pmax-guide` for creation → PMax at 20-25% of Search budget → monitor cannibalization (Search IS drop = warning) → re-run after 4 weeks | PMax: 20-25% of Search budget cap; 4-week review cycle |
  | **T4: Channel Expansion — Display + Demand Gen** | Stage 3+, Search + Shopping hitting targets, remarketing list ≥1,000 | Display remarketing 5% budget (retention) → 4 weeks stable → Demand Gen test bucket 10% (lookalike) → geo-holdout before scaling Demand Gen >15% | Display: 5% cap; Demand Gen: 10% cap until geo-holdout confirms incrementality |
  | **T5: Stabilization Required** | Any of Gate #3 (CPA volatile), #6 (in learning), or #7 (hygiene) FAIL | Gate-clearing per failing gate: learning → wait, no changes; CPA volatile → attribution/tracking investigation first; hygiene → negatives via UI before any budget step | No budget steps or channel expansions until all T5 gates clear |
  | **T6: Portfolio Consolidation** *(Stage 4 only)* | 3+ campaigns, all tCPA/tROAS within targets 60+ days, target differences <15% across campaigns | Portfolio bid strategy setup → shared budget evaluation → IS review across portfolio → Vertex AI LTV consideration (B2B + e-commerce Stage 4) | — |

  > [!warning] Dynamic scaling limitation
  > The T1-T6 trajectories are a starting point, not a complete dynamic scaling system. True dynamic scaling — real-time multi-variable interaction, PMax/Shopping cannibalization in motion, predictive signal reading — is beyond current skill capability. The skill's value is: MCP-powered gate evaluation + conditional trajectory routing + evidence-gated recommendations + projection guardrail. It does not replace real-time algorithmic optimization.

  **Conflict handling:** T1 + T2 simultaneously active requires sequencing. Bid strategy graduation (T2) resets the learning period — budget scale-up (T1) must wait until learning exits post-graduation. Do not run T1 and T2 actions in the same 14-day window.

  ---

  ## 6. What This Skill Adds vs. Existing Playbooks — Honest Gap Statement

  A dense body of public scaling playbooks exists (see §8). The skill fills a **tooling gap**, not an information gap.

  | Feature | Public playbooks | This skill |
  |---|---|---|
  | Coupled to live MCP data | No — all assume manual inspection | ✅ Yes — 7 GAQL queries, live field reads |
  | Enforces a projection substantiation guardrail | No | ✅ Yes — prohibited patterns in report output |
  | Emits a single go/no-go verdict | No — descriptive, not prescriptive | ✅ Yes — binary verdict + trajectory routing |
  | CoV computation from daily data | No — stated as a rule without computation | ✅ Yes — computed from `segments.date` daily pull |
  | Performance Planner cross-campaign cannibalization | ❌ Not modeled | ⚠️ Flagged as manual-only throughout |
  | True dynamic scaling (multi-variable real-time) | Some agency frameworks describe it | ❌ Beyond current skill capability |

  ---

  ## 7. Major 2024-2026 Platform Changes

  These changes affect skill branching logic. Each is reflected in the skill's gate and trajectory steps.

  ### PMax vs Shopping — Ad Rank decides (Oct 2024)

  Before Oct 2024, Performance Max automatically received budget priority over Standard Shopping. Since Oct 2024, both campaign types compete via Ad Rank. PMax no longer dominates by default. Implication for T3: when recommending Feed-Only PMax addition, the skill must monitor both PMax and Shopping impression share. A PMax budget addition does not guarantee Shopping IS remains stable.

  ### Brand Exclusions — AI Max Migration (May 27, 2025)

  Brand exclusion configuration is different when AI Max for Search is enabled. The skill branches: if a Search campaign uses AI Max, direct the user to the AI Max brand exclusion UI path (`support.google.com/google-ads/answer/14505308`) rather than the standard brand keyword negative list path.

  ### ECPC Removed (March 31, 2025)

  Enhanced CPC was deprecated. Existing eCPC campaigns now run as Manual CPC. The skill flags any campaign with `bidding_strategy_type = ENHANCED_CPC` as deprecated under Gate #4 and recommends transitioning to Manual CPC → Max Conversions.

  ### Google Ads API v23 (Jan 2026)

  Monthly release cadence from Jan 2026. The MCP server (`voxxy/google-ads-mcp-server`) must target v23+ for current field availability. If GAQL queries return unexpected field errors, check API version.

  ---

  ## 8. Curated External Playbooks

  Research-verified 2026-04-16. The +20%/14-day consensus and PMax-specific thresholds below are corroborated across multiple independent sources.

  | Source | Key finding |
  |---|---|
  | Google: `business.google.com/us/google-ads/campaign-budget/` | Official budget guidance |
  | Solutions 8: "How to Scale a Performance Max Campaign" | +15-20% every 3-7 days (PMax, higher-budget accounts) |
  | clicksinmind: "Scaling PMax the Right Way (5 Tips)" | +15-20% PMax, 14-day wait minimum |
  | Accelerated Digital Media: "Performance Max: Tips for Bids and Budgets" | PMax 50+ conv/mo for reliable scaling |
  | WordStream: "How to Scale Success in Google Ads (& When)" | ±10-20% per step, 14+ day wait |
  | KlientBoost: "How to Scale Google Ads" | ±10-20% per step, 14+ day wait |
  | Dilate: "The right way to scale Google Ads budgets" | ±10-20% consensus, budget-first before keywords |
  | God Tier Ads: 400+ step optimization framework | Agency-grade scaling protocol |
  | Search Engine Journal: "2026 Google Ads Playbook" | tROAS target 70-80% of actual ROAS |
  | Store Growers: "Performance Max Campaigns: Ultimate Ecommerce Guide (2026)" | PMax 50+ conv/mo threshold corroborated |

  **Key consensus numbers** (multi-source corroboration):
  - Budget steps: ±10-20% per step
  - Wait period: 14+ days after any step
  - PMax reliable scaling: 50+ conv/mo
  - tROAS target: set at 70-80% of actual ROAS (leave headroom before tightening)

  ---

  ## 9. Reference Repositories

  Code repositories (not playbooks) for advanced implementation and incrementality measurement:

  | Repo | Stars | Purpose |
  |---|---|---|
  | `googleads/google-ads-python` | 684 | Official Python client for Google Ads API |
  | `Brainlabs-Digital/Google-Ads-Scripts` | 147 | Production Google Ads Scripts library |
  | `facebookincubator/GeoLift` | 242 | Geo-lift / incrementality testing |
  | `google/trimmed_match` | — | Geo-experiment methodology |
  | `google/matched_markets` | — | Geo-experiment market selection |
  | `googleads/google-ads-mcp` | — | Official Google Ads MCP server (Oct 2025) |
  | `google/GeoexperimentsResearch` | 142 | Geo-experiment research (**archived 2022 — methodology only, not maintained**) |

  ---

  ## 10. Authoritative Google URLs

  | Topic | URL |
  |---|---|
  | Learning period | `support.google.com/google-ads/answer/13020501` |
  | tROAS / Portfolio bid strategies | `support.google.com/google-ads/answer/6268637` |
  | Portfolio bid strategies (canonical) | `support.google.com/google-ads/answer/6263072` |
  | Impression share metrics | `support.google.com/google-ads/answer/7103314` |
  | Budget pacing insights | `support.google.com/google-ads/answer/13685469` |
  | Smart Bidding Exploration | `support.google.com/google-ads/answer/16294223` |
  | Brand exclusions (PMax) | `support.google.com/google-ads/answer/14505308` |
  | Conversion Lift experiments | `support.google.com/google-ads/answer/12003020` |
  | Experiments | `support.google.com/google-ads/answer/10682377` |
  | Performance Planner | `support.google.com/google-ads/answer/9230124` |

  ---

  ## 11. Cross-References

  This file is linked from:
  - [[account-maturity-roadmap]] Stage 3 scaling section + Stage 4 scaling section + tROAS discrepancy footnote
  - [[../bidding-strategies|bidding-strategies.md]] PMax/Shopping Ad Rank callout
  - [[../../skills/post-launch-monitor/SKILL.md|post-launch-monitor]] bid strategy readiness section
  ````

- [ ] **Step 2: Verify the file**

  Read `reference/platforms/google-ads/strategy/scaling-playbook.md`. Confirm:
  - All 11 sections present
  - T1-T6 table complete with trigger conditions, action sequences, and delta caps
  - Honest gap statement table has 6 rows
  - 10 Google URLs in table (count them)
  - 10 curated external playbooks in table (count them)
  - Dynamic scaling limitation warning callout present verbatim
  - PMax vs Shopping Oct 2024 change in §7
  - `GeoexperimentsResearch` marked as archived

- [ ] **Step 3: Commit**

  ```bash
  git add reference/platforms/google-ads/strategy/scaling-playbook.md
  git commit -m "docs: add scaling-playbook.md reference (v1.23.0)"
  ```

---

## Task 7: Create `skills/account-scaling/SKILL.md`

**Files:**
- Create: `skills/account-scaling/SKILL.md`

This is the largest single file. It implements the full 4-phase flow.

- [ ] **Step 1: Create the directory and file**

  Create `skills/account-scaling/SKILL.md` with this exact content:

  ````markdown
  ---
  name: account-scaling
  description: "Account scaling health check — 8-gate MCP evaluation of Stage 3/4 readiness to grow, conditional trajectory routing (T1-T6), and always-on diffable report. Trigger: 'account scaling / ready to scale / grow this account / scale up budget'."
  disable-model-invocation: false
  ---

  # Account Scaling Health Check

  You are running a structured account scaling evaluation. This skill is for **Stage 3+ accounts only** (30+ conversions/month). It uses live MCP data to run 8 gates and routes to conditional scaling trajectories.

  > [!warning] Projection Guardrail — Active
  > This skill enforces the Substantiation Before Projection rule from [[../../_config/conventions|conventions.md]] §Client Communication Guardrails. Never state a future ROAS target, CPA projection, conversion volume forecast, or timeline commitment in any output unless it appears in a dated strategy document on file. Describe data gates — not expected outcomes.

  ## Reference Material

  Load these on demand — not all at once:

  - **MCP capabilities:** [[../../reference/mcp/mcp-capabilities|mcp-capabilities.md]] — load first, confirm GAQL field availability
  - **Scaling playbook:** [[../../reference/platforms/google-ads/strategy/scaling-playbook|scaling-playbook.md]] — gate rationale, T1-T6 full detail, channel ladder, external playbooks, Google URLs
  - **Account maturity roadmap:** [[../../reference/platforms/google-ads/strategy/account-maturity-roadmap|account-maturity-roadmap.md]] — Stage 3/4 criteria, CoV thresholds
  - **Budget optimizer (Gates #4, #5):** [[../budget-optimizer/SKILL.md|budget-optimizer]] — maturity ladder L40-48, IS-headroom L69-87
  - **Learning phase (Gate #6):** [[../../reference/platforms/google-ads/learning-phase|learning-phase.md]]
  - **Campaign review (Gate #7):** [[../campaign-review/SKILL.md|campaign-review]] — Area 8 (neg-kw hygiene)
  - **Conventions:** [[../../_config/conventions|conventions.md]] — 6-step report write sequence, projection guardrail

  ## Step 0: Entry Gate

  Before running MCP queries, confirm Stage 3 or Stage 4 eligibility.

  Say: "Let me pull 90 days of conversion data to confirm Stage 3/4 status before running the full evaluation."

  Run:

  ```gaql
  SELECT campaign.id, campaign.name, campaign.status,
    metrics.conversions, metrics.cost_micros, metrics.conversion_value
  FROM campaign
  WHERE campaign.status = 'ENABLED'
    AND segments.date DURING LAST_90_DAYS
  ```

  **Classify from results:**
  - Total 90-day conversions ÷ 3 = monthly average
  - If monthly average ≥ 30 → **Stage 3+ confirmed. Proceed to Step 1.**
  - If below threshold → **Exit.** Say: "This account is not yet ready for scaling evaluation — it needs 30+ conversions/month (Stage 3). Current 90-day average: [X/month]. Load [[../../reference/platforms/google-ads/strategy/account-maturity-roadmap|account-maturity-roadmap.md]] for the Stage 2 → Stage 3 gate to work toward." **Do not write a report. Do not assign trajectories.**

  ## Step 1: Live MCP Data Pull

  Load [[../../reference/mcp/mcp-capabilities|mcp-capabilities.md]] to confirm available fields. All reads are read-only — never call `unlock_writes` in this skill.

  Run these 7 queries and collect all results before proceeding to gate evaluation.

  **Query A — Campaign summary, 90 days:**
  ```gaql
  SELECT campaign.id, campaign.name, campaign.status, campaign.serving_status,
    campaign.bidding_strategy_type,
    metrics.conversions, metrics.cost_micros, metrics.conversion_value,
    metrics.search_impression_share,
    metrics.search_budget_lost_impression_share,
    metrics.search_rank_lost_impression_share
  FROM campaign
  WHERE campaign.status = 'ENABLED'
    AND segments.date DURING LAST_90_DAYS
  ```

  **Query B — Daily campaign data, 30 days (CoV computation):**
  ```gaql
  SELECT campaign.id, campaign.name,
    segments.date,
    metrics.conversions, metrics.cost_micros, metrics.conversion_value
  FROM campaign
  WHERE campaign.status = 'ENABLED'
    AND segments.date DURING LAST_30_DAYS
  ORDER BY campaign.id, segments.date
  ```

  **Query C — Keyword quality scores:**
  ```gaql
  SELECT ad_group_criterion.keyword.text,
    ad_group_criterion.quality_info.quality_score,
    metrics.impressions, metrics.clicks
  FROM keyword_view
  WHERE segments.date DURING LAST_30_DAYS
    AND ad_group_criterion.status = 'ENABLED'
  ORDER BY metrics.impressions DESC
  ```

  **Query D — Top-50 search terms by cost (hygiene check):**
  ```gaql
  SELECT search_term_view.search_term, search_term_view.status,
    metrics.impressions, metrics.clicks, metrics.cost_micros, metrics.conversions
  FROM search_term_view
  WHERE segments.date DURING LAST_30_DAYS
  ORDER BY metrics.cost_micros DESC
  LIMIT 50
  ```

  **Query E — PMax asset groups (run only if PMax campaigns detected in Query A):**
  ```gaql
  SELECT asset_group.name, asset_group.ad_strength, campaign.name,
    campaign.shopping_setting.merchant_id
  FROM asset_group
  WHERE campaign.advertising_channel_type = 'PERFORMANCE_MAX'
    AND asset_group.status = 'ENABLED'
  ```

  > [!info] Feed-only PMax AD_STRENGTH = POOR exception
  > Feed-only PMax campaigns created via Merchant Center always show AD_STRENGTH = POOR. This is expected — not a defect. Confirm via `campaign.shopping_setting.merchant_id` presence before flagging. See v1.21.1 for the full exception rule.

  **Query F — Negative keyword shared sets:**
  ```gaql
  SELECT shared_set.name, shared_set.type, shared_set.member_count
  FROM shared_set
  WHERE shared_set.type = 'NEGATIVE_KEYWORDS'
    AND shared_set.status = 'ENABLED'
  ```

  **Query G — Campaign budgets:**
  ```gaql
  SELECT campaign_budget.amount_micros, campaign_budget.name,
    campaign_budget.has_recommended_budget,
    campaign_budget.recommended_budget_amount_micros
  FROM campaign_budget
  WHERE campaign_budget.status = 'ENABLED'
  ```

  **Not GAQL-accessible:** Auction Insights — manual verification only if competitive context is needed.

  ## Step 2: Gate Evaluation

  Evaluate all 8 gates using collected data. Each gate result = **PASS**, **FAIL**, or **WARNING**.

  > [!warning] Write all 8 gate results to the report — passes and fails alike. The report is designed to be diffable across sessions.

  ### Gate 1 — Maturity Stage

  Already confirmed in Step 0. Mark **PASS**.

  Reference: [[../../reference/platforms/google-ads/strategy/account-maturity-roadmap|account-maturity-roadmap.md]] Stage 3/4 criteria.

  ### Gate 2 — Monthly Conversion Volume (target: ≥30/mo)

  Using Query A (90-day) and Query B (30-day):
  - 90-day total ÷ 3 = rolling monthly average
  - Query B 30-day total = current month

  **PASS** = both ≥30. **WARNING** = rolling average ≥30 but last 30 days < 30 (declining trend). **FAIL** = below threshold.

  Reference: [[../../reference/platforms/google-ads/strategy/account-maturity-roadmap|account-maturity-roadmap.md]] L325-331, 465-471.

  ### Gate 3 — CPA/ROAS Stability (target: CoV ≤20%)

  Using Query B daily data, compute the Coefficient of Variation (CoV) for daily CPA (or daily ROAS for e-commerce accounts):

  - Daily CPA = daily `cost_micros` ÷ daily `conversions` (exclude days with 0 conversions)
  - CoV = (standard deviation of daily CPA ÷ mean daily CPA) × 100

  **PASS** = CoV ≤20%. **WARNING** = 20% < CoV ≤35%. **FAIL** = CoV > 35%.

  > [!info] This is the only place in the plugin that computes CoV from live data. The roadmap defines the ±20% rule; this skill executes it.

  Reference: [[../../reference/platforms/google-ads/strategy/account-maturity-roadmap|account-maturity-roadmap.md]] ±20% CoV rule.

  ### Gate 4 — Bid Strategy Fit

  Using Query A `campaign.bidding_strategy_type`, apply the maturity ladder from [[../budget-optimizer/SKILL.md|budget-optimizer]] L40-48:

  | Current strategy | Conversions/month | Gate result |
  |---|---|---|
  | `TARGET_CPA` or `TARGET_ROAS` | Any | **PASS** |
  | `MAXIMIZE_CONVERSIONS` or `MAXIMIZE_CONVERSION_VALUE` | ≥30 (Gate 2 pass) + CoV ≤20% (Gate 3 pass) | **FAIL** → T2 |
  | `MANUAL_CPC` | ≥30 | **FAIL** → T2 |
  | `MAXIMIZE_CLICKS` | Any | **FAIL** → T2 |
  | `ENHANCED_CPC` | Any | **FAIL** → T2 + flag as deprecated (removed March 2025) |

  > [!warning] tROAS threshold discrepancy
  > When advising on tROAS eligibility: account-maturity-roadmap.md states 50 conversions/month; Google's portfolio bid strategy docs (`support.google.com/google-ads/answer/6268637`) cite 15 conversions past 30 days for Search/Display. Do not hardcode either number. Cite the live URL and recommend the user confirm the current threshold in their account UI.

  ### Gate 5 — IS Headroom

  Using Query A `metrics.search_budget_lost_impression_share`:

  - Any campaign with `search_budget_lost_impression_share ≥ 0.15` = headroom exists
  - **PASS** = headroom detected (budget is limiting, not rank) → T1 candidate
  - **FAIL** = all campaigns < 0.15 (rank is the limiter — adding budget won't help)
  - **WARNING** = mixed across campaigns

  Reference: [[../budget-optimizer/SKILL.md|budget-optimizer]] IS-headroom L69-87, [[../../reference/platforms/google-ads/audit/audit-checklist|audit-checklist.md]] Area 16.

  ### Gate 6 — Learning Phase Clear

  Using Query A `campaign.serving_status`:

  - **PASS** = all enabled campaigns show `ELIGIBLE`
  - **FAIL** = any campaign shows `LEARNING` → T5 (no scaling until learning exits; list affected campaigns by name)

  Reference: [[../../reference/platforms/google-ads/learning-phase|learning-phase.md]], [[../post-launch-monitor/SKILL.md|post-launch-monitor]] L170-191.

  ### Gate 7 — Negative Keyword Hygiene

  Using Query D (top-50 search terms by cost), manually review for: branded competitor names, spam/bot queries, clear intent mismatch (e.g., job seekers on a product campaign).

  - **PASS** = ≤10% of top-50 terms are irrelevant
  - **WARNING** = 10-25% irrelevant
  - **FAIL** = >25% irrelevant → T5 (add negatives in Google Ads UI before any budget step)

  Reference: [[../campaign-review/SKILL.md|campaign-review]] Area 8.

  ### Gate 8 — Tracking Infrastructure

  Ask the user (MCP cannot verify this directly):
  1. Is Enhanced Conversions active on the primary conversion action? (Y/N)
  2. Is Data-Driven Attribution (DDA) shown in Google Ads → Goals → Conversions → Attribution? (Y/N)

  - **PASS** = EC active + DDA active or eligible (≥300 conversions/30 days)
  - **WARNING** = EC active, DDA not yet available (volume insufficient) — flag for future DDA switch, do not block scaling
  - **FAIL** = EC not active → load [[../conversion-tracking/SKILL.md|conversion-tracking]] before continuing

  Reference: [[../conversion-tracking/SKILL.md|conversion-tracking]], [[../../reference/platforms/google-ads/enhanced-conversions|enhanced-conversions.md]].

  ## Step 3: Trajectory Routing

  Based on gate results, assign one or more active trajectories. Multiple can be active simultaneously. Present in priority order: **T5 → T2 → T1 → T3 / T4 / T6.**

  Load [[../../reference/platforms/google-ads/strategy/scaling-playbook|scaling-playbook.md]] §5 for full decision tables, delta caps, and wait periods.

  | Trajectory | Active when | First action |
  |---|---|---|
  | **T5: Stabilization Required** | Gate #3, #6, or #7 FAIL | Gate-clearing before any budget step — no exceptions |
  | **T2: Bid Strategy Graduation** | Gates #2+#3 PASS + Gate #4 FAIL | Set tCPA at actual CPA × 1.15 |
  | **T1: Budget Scale-Up** | Gate #5 PASS + Gates #1-3 PASS | +20% on IS-limited Search campaigns |
  | **T3: Feed-Only PMax** *(e-comm only)* | Stage 3 + Search stable 8+ wks + MC confirmed + no existing PMax | Route to `/ad-platform-campaign-manager:pmax-guide` |
  | **T4: Display + Demand Gen** | Stage 3+ + targets hit + remarketing list ≥1,000 | Display remarketing at 5% budget |
  | **T6: Portfolio Consolidation** *(Stage 4 only)* | 3+ campaigns tCPA/tROAS within targets 60+ days, target difference <15% | Portfolio bid strategy setup |

  > [!warning] Dynamic scaling limitation
  > The T1-T6 trajectories are a starting point, not a complete dynamic scaling system. True dynamic scaling — real-time multi-variable interaction, PMax/Shopping cannibalization in motion, predictive signal reading — is beyond current skill capability. The skill's value is: MCP-powered gate evaluation + conditional trajectory routing + evidence-gated recommendations + projection guardrail. It does not replace real-time algorithmic optimization.

  > [!warning] T1 + T2 conflict
  > If both T1 and T2 are active: complete T2 (bid strategy graduation) first. The learning period triggered by the bid strategy switch means no budget steps should run during the 14-day learning window. Resume T1 evaluation after learning exits and Gate 3 (CoV) confirms stability post-graduation.

  > [!info] PMax vs Shopping — Oct 2024
  > Since October 2024, PMax and Shopping compete via Ad Rank. Do not assume PMax dominates Shopping budget when activating T3. Monitor both campaign types' impression share after PMax addition.

  ## Step 4: Report Write

  Write a report every run, regardless of gate outcomes. A report with all FAILs is valuable — it documents the baseline before T5 gate-clearing begins.

  **Report path:** `reports/{YYYY-MM-DD}/05-optimize/account-scaling.md`

  Follow the 6-step write sequence in [[../../_config/conventions|conventions.md]] §Report File-Writing Convention:
  1. Detect MWP project root (look for `_config/conventions.md`)
  2. Ensure `reports/{YYYY-MM-DD}/05-optimize/` directory exists
  3. Write full report (see template below)
  4. Update `reports/{YYYY-MM-DD}/CONTEXT.md`
  5. Update `reports/{YYYY-MM-DD}/SUMMARY.md` under "Optimization & Reporting"
  6. Summarize in conversation: gate results, active trajectories, first action

  **Report template:**

  ```markdown
  ---
  title: Account Scaling Health Check — {Client Name}
  date: {YYYY-MM-DD}
  skill: account-scaling
  stage: 05-optimize
  account: {Client Name} ({Account ID})
  tags: [report, google-ads, 05-optimize, account-scaling]
  ---

  # Account Scaling Health Check — {Client Name}

  ## Gate Evaluation Results

  | Gate | Result | Evidence |
  |---|---|---|
  | 1 — Maturity Stage | PASS/FAIL | {stage classification from live data} |
  | 2 — Conversion Volume | PASS/FAIL/WARNING | {30-day: X, 90-day avg: Y/mo} |
  | 3 — CPA/ROAS Stability | PASS/FAIL/WARNING | {CoV: X%} |
  | 4 — Bid Strategy Fit | PASS/FAIL | {current strategy per campaign} |
  | 5 — IS Headroom | PASS/FAIL/WARNING | {budget-lost IS: X% on [campaign name]} |
  | 6 — Learning Phase | PASS/FAIL | {serving_status per campaign} |
  | 7 — Neg-KW Hygiene | PASS/FAIL/WARNING | {X of top-50 terms flagged} |
  | 8 — Tracking Infrastructure | PASS/FAIL/WARNING | {EC: active/inactive, DDA: active/eligible/unavailable} |

  ## Verdict

  **[GO / NO-GO / CONDITIONAL-GO]**

  {One sentence explaining the verdict — which gates drove it.}

  ## Active Trajectories (in priority order)

  {Only list active trajectories. If none active, state: "All gates passed. No trajectory required at this time. Re-run in 30 days."}

  ### T[X]: [Trajectory Name]

  **Triggered by:** Gate #[X] result — {evidence}
  **First action:** {specific step from trajectory table}
  **Wait period:** {X days before re-evaluation}
  **Re-run trigger:** {condition that ends this trajectory}

  ## What This Report Does Not Cover

  - Auction Insights (requires manual Google Ads UI check)
  - DDA model confirmation (requires Goals → Conversions → Attribution in UI)
  - Real-time multi-variable cannibalization (beyond current skill capability)
  ```

  > [!warning] Projection guardrail — report content
  > Do not state any numeric future target (ROAS, CPA, conversion volume, timeline) in this report unless it appears in a dated strategy document on file. Describe data gates. See [[../../_config/conventions|conventions.md]] §Client Communication Guardrails.

  ## What to Do Next

  | Finding | Next Skill |
  |---|---|
  | T5 active — CPA volatile / attribution suspect | `/ad-platform-campaign-manager:conversion-tracking` |
  | T5 active — search term hygiene failing | `/ad-platform-campaign-manager:campaign-cleanup` |
  | T5 active — campaign still in learning | `/ad-platform-campaign-manager:post-launch-monitor` |
  | T2 active — bid strategy graduation needed | `/ad-platform-campaign-manager:budget-optimizer` |
  | T3 active — PMax channel expansion | `/ad-platform-campaign-manager:pmax-guide` |
  | Full structural audit needed before scaling | `/ad-platform-campaign-manager:campaign-review` |
  | Account strategy or stage classification | `/ad-platform-campaign-manager:account-strategy` |

  ---

  ## Report Output

  When inside an MWP client project, write output to `reports/{YYYY-MM-DD}/05-optimize/account-scaling.md`.

  Follow the 6-step write sequence and Output Completeness Convention in [[../../_config/conventions|conventions.md]]:
  1. Detect MWP project root (look for `_config/conventions.md`)
  2. Ensure `reports/{YYYY-MM-DD}/05-optimize/` directory exists
  3. Write full report — all 8 gate results (all passes and fails), active trajectories, MCP data summary, first recommended action per trajectory
  4. Update `reports/{YYYY-MM-DD}/CONTEXT.md` with new entry
  5. Update `reports/{YYYY-MM-DD}/SUMMARY.md` under "Optimization & Reporting"
  6. Summarize in conversation: verdict, active trajectories, next action

  **Stage:** `05-optimize` | **Summary section:** Optimization & Reporting
  ````

- [ ] **Step 2: Verify the skill file**

  Read `skills/account-scaling/SKILL.md`. Confirm:
  - Frontmatter has `name: account-scaling`, `description` includes trigger phrases, `disable-model-invocation: false`
  - All 7 GAQL queries present (A through G)
  - All 8 gate sections present with PASS/FAIL/WARNING criteria
  - T1-T6 routing table present
  - Dynamic scaling limitation warning callout present verbatim
  - Projection guardrail warning callout present twice (intro + report section)
  - Report template present with all 8 gate rows
  - "What to Do Next" table present
  - Report Output section at bottom specifies stage `05-optimize`

- [ ] **Step 3: Commit**

  ```bash
  git add skills/account-scaling/SKILL.md
  git commit -m "feat: add account-scaling skill (v1.23.0)"
  ```

---

## Task 8: Wire CONTEXT.md and CLAUDE.md

**Files:**
- Modify: `CONTEXT.md` (add routing row)
- Modify: `CLAUDE.md` (add Quick Navigation entry)

- [ ] **Step 1: Read CONTEXT.md lines 20-25**

  Current content around line 21:
  ```
  | Budget / bids | `skills/budget-optimizer/SKILL.md` | ... |
  ```

- [ ] **Step 2: Insert routing row above "Budget / bids"**

  Insert this row immediately before the `Budget / bids` row:

  ```markdown
  | Account scaling / ready to scale / grow this account / scale up budget | `skills/account-scaling/SKILL.md` | `reference/platforms/google-ads/strategy/scaling-playbook.md`, `reference/platforms/google-ads/strategy/account-maturity-roadmap.md`, `reference/mcp/mcp-capabilities.md`, `reference/platforms/google-ads/bidding-strategies.md`, `reference/platforms/google-ads/learning-phase.md` | Tracking-bridge, scripts, reporting |
  ```

- [ ] **Step 3: Read CLAUDE.md Quick Navigation table**

  Find the Quick Navigation table (the `| I want to... | Go here |` table). It currently ends with `campaign-cleanup`.

- [ ] **Step 4: Add account-scaling entry to Quick Navigation**

  Add this row to the Quick Navigation table (after the `campaign-cleanup` row, before the `strategy-advisor` row or at the appropriate alphabetical position):

  ```markdown
  | Run account scaling health check | `/ad-platform-campaign-manager:account-scaling` |
  ```

- [ ] **Step 5: Verify both files**

  - CONTEXT.md: confirm the new routing row is between post-launch-monitor and budget-optimizer rows, all columns filled, no existing rows displaced.
  - CLAUDE.md: confirm the new Quick Navigation entry is present and links to the right skill name.

- [ ] **Step 6: Commit**

  ```bash
  git add CONTEXT.md CLAUDE.md
  git commit -m "chore: wire account-scaling routing + Quick Navigation (v1.23.0)"
  ```

---

## Task 9: Release v1.23.0

- [ ] **Step 1: Update BACKLOG.md**

  Read BACKLOG.md. Find items #23 and #28. Change their status to `✅ Done (v1.23.0)`.

  Verify: both items marked done, no other items accidentally modified.

- [ ] **Step 2: Update CHANGELOG.md**

  Read CHANGELOG.md. Add a new entry at the top (after the frontmatter/header, before any existing entries):

  ```markdown
  ## v1.23.0 — 2026-04-17

  ### New Skills
  - `account-scaling` — 8-gate MCP-powered scaling health check for Stage 3/4 accounts. Evaluates maturity stage, conversion volume, CPA/ROAS stability (CoV computation from daily data), bid strategy fit, IS headroom, learning phase, neg-kw hygiene, and tracking infrastructure. Routes to conditional trajectories T1-T6. Always writes a diffable report to `05-optimize/`.

  ### New Reference Files
  - `reference/platforms/google-ads/strategy/scaling-playbook.md` — companion reference: 11 sections covering gate rationale, channel ladder, budget step mechanics, T1-T6 full tables, honest gap statement, major 2024-2026 platform changes, 10 curated external playbooks, 6 reference repos, 10 authoritative Google URLs.

  ### Conventions Update
  - `_config/conventions.md` — added `## Client Communication Guardrails` section: Substantiation Before Projection rule (FTC + UK CAP §§ 3.1/3.7/3.34 + DMCC Act 2024). Scope: all 15 skills + 3 agents. Three-layer enforcement: global `~/.claude/CLAUDE.md` + master plugin + ad-platform.
  - `project-structure-and-scaffolding-plugin/_config/conventions.md` — added generic Client Communication Guardrails section.
  - `~/.claude/CLAUDE.md` — added one-line projection guardrail pointer.

  ### Reference Updates
  - `account-maturity-roadmap.md` — tROAS threshold discrepancy footnote (50 vs 15 conv/mo), links to `scaling-playbook.md` from Stage 3 and Stage 4 sections.
  - `bidding-strategies.md` — added PMax vs Shopping Ad Rank callout (Oct 2024: PMax no longer auto-dominates Shopping).

  ### Wiring
  - `CONTEXT.md` — routing row: "Account scaling / ready to scale / grow this account / scale up budget" → `account-scaling`
  - `CLAUDE.md` — Quick Navigation: `/ad-platform-campaign-manager:account-scaling`

  ### Backlog
  - #23 Account Scaling Skill ✅ Done
  - #28 Projection Guardrail ✅ Done
  ```

- [ ] **Step 3: Commit BACKLOG + CHANGELOG**

  ```bash
  git add BACKLOG.md CHANGELOG.md
  git commit -m "chore: v1.23.0 release — BACKLOG #23 + #28 closed, CHANGELOG entry"
  ```

- [ ] **Step 4: Rewrite PRIMER.md**

  Rewrite `PRIMER.md` to reflect the completed v1.23.0 state. The new PRIMER should:
  - Set "Last Completed" to v1.23.0 (2026-04-17) with the full deliverables list
  - Clear the "What Still Needs to Happen" section — v1.23.0 is done
  - Carry forward the deferred backlog items (#24, #26, #29, #30) unchanged
  - Carry forward the open blockers section unchanged (OAuth rotation, MCP server update, n8n-plugin, Watermelon plan, GTM scripts, ClickFunnels)
  - Set the next milestone to the next available backlog item (likely #24 tROAS/tCPA transition gates in post-launch-monitor, or whatever Jerry designates)

  ```bash
  git add PRIMER.md
  git commit -m "chore: rewrite PRIMER.md for v1.23.0 session handoff"
  ```

- [ ] **Step 5: Tag the release**

  ```bash
  git tag v1.23.0
  ```

- [ ] **Step 6: Plugin reinstall**

  Every new skill requires a plugin reinstall:
  1. In Claude Code: run `/plugins uninstall ad-platform-campaign-manager`
  2. Run `/plugins install` (or reinstall from the plugin directory)
  3. Reload VSCode window (Ctrl+Shift+P → "Developer: Reload Window")
  4. Verify `/ad-platform-campaign-manager:account-scaling` appears in skill list

---

## Self-Review

**Spec coverage check:**

| Spec requirement | Covered in task |
|---|---|
| `/account-scaling` skill, 4 phases | Task 7 |
| 7 GAQL queries (A-G) | Task 7 |
| 8 gate evaluation | Task 7 |
| T1-T6 trajectory routing | Task 7 |
| Always-report to `05-optimize/` | Task 7 |
| Stage 1/2 exit message | Task 7 (Step 0) |
| scaling-playbook.md (11 sections) | Task 6 |
| All 10 Google URLs | Task 6 |
| All 10 external playbooks | Task 6 |
| Guardrail Layer 1 (global) | Task 1 |
| Guardrail Layer 2 (master plugin) | Task 2 |
| Guardrail Layer 3 (ad-platform) | Task 3 |
| tROAS discrepancy footnote | Task 4 |
| Stage 3/4 scaling-playbook links | Task 4 |
| PMax/Shopping Ad Rank Oct 2024 | Task 5 |
| CONTEXT.md routing row | Task 8 |
| CLAUDE.md Quick Navigation | Task 8 |
| BACKLOG #23 + #28 done | Task 9 |
| CHANGELOG v1.23.0 | Task 9 |
| PRIMER.md rewrite | Task 9 |
| Plugin reinstall | Task 9 |

**Pre-existing uncommitted n8n routing changes:** Flagged in Pre-flight. Must be resolved with Jerry before any v1.23.0 commit touches those files. If reverting, run `git checkout skills/CONTEXT.md skills/ads-scripts/SKILL.md skills/conversion-tracking/SKILL.md skills/live-report/SKILL.md skills/reporting-pipeline/SKILL.md` before Task 8.
