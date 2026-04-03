---
title: Design Decisions
date: 2026-03-28
tags:
  - mwp
---

# Design Decisions

Architecture rationale for ad-platform-campaign-manager. Documents the *why* behind structural choices.

## Platform-Agnostic Structure

**Decision:** All platform knowledge lives under `reference/platforms/[platform-name]/`. Google Ads is the only populated platform; Meta, LinkedIn, TikTok are empty placeholders.

**Why:** Jerry will eventually manage campaigns across multiple platforms. Structuring this from day one means adding a platform is just populating a new folder — no refactoring of skills, agents, or the reporting layer. The `reporting/cross-platform-data-model.md` already defines the unified schema.

## Tracking Bridge as Differentiator

**Decision:** Dedicated `reference/tracking-bridge/` section with 6 files documenting GTM → sGTM → BigQuery → Google Ads pipelines.

**Why:** Jerry is a tracking specialist, not a campaign specialist. No generic Google Ads plugin has documentation for profit-based bidding via sGTM + Firestore, or Vertex AI predicted LTV via sGTM. This section bridges his existing expertise with the campaign management domain. It's the plugin's unique value.

## Phased Approach

**Decision:** Phase 1 = knowledge/guidance (no API). Phase 2 = content completion & MCP prep. Phase 3 = MCP API integration. Phase 4 = multi-platform.

**Why:** Phase 1 provides immediate value — guided campaign setup, keyword strategy, conversion tracking docs, reporting pipeline designs — all without API access. Phase 2 filled content gaps (scripts, repos, fact-check sweep) and prepared MCP configuration. Phase 3 delivered a custom MCP server (`voxxy/google-ads-mcp-server`) with 25 tools, three-gate safety, and Explorer Access (2,880 ops/day). Phase 4 (multi-platform) is deferred — only Google Ads is populated.

## Skills vs Agents

**Decision:** 11 skills (invoked by user) + 2 agents (autonomous audit).

**Why:** Skills are interactive — the user triggers them and works through them step by step. Agents are autonomous — they run a full audit checklist without user interaction and produce a report. The split maps to two usage patterns:
- "Help me build/plan something" → skill
- "Check everything for me" → agent

The `campaign-review` skill and `campaign-reviewer` agent cover the same domain but differ in interaction model. Same for `conversion-tracking` skill vs `tracking-auditor` agent.

## Reference Docs Loaded on Demand

**Decision:** Skills reference specific files from `reference/` via relative links in SKILL.md. No skill bundles its own copy of domain knowledge.

**Why:** Prevents duplication. When Google Ads changes (new campaign types, API versions), updating one reference file updates all skills that use it. The CONTEXT.md routing tables document which skill loads which files, so context is predictable.

## CONTEXT.md at Every Junction

**Decision:** 10 CONTEXT.md files throughout the directory tree (root + 9 junctions). One CLAUDE.md at root only.

**Why:** CLAUDE.md is permanent identity/rules — it doesn't need to exist at every folder. CONTEXT.md is task routing — it tells Claude "what's here and how to use it" at each directory level. This keeps navigation context close to the files it describes without polluting every folder with identity declarations.

## Root Documentation Files

**Decision:** 7 root files with distinct roles (CLAUDE.md, CONTEXT.md, PRIMER.md, MEMORY.sh, LESSONS.md, DESIGN.md, CHANGELOG.md).

**Why:** Each file has a clear lifecycle:
- **CLAUDE.md** — never changes (permanent rules)
- **CONTEXT.md** — changes when skills/reference structure changes
- **PRIMER.md** — rewrites every session (living handoff)
- **MEMORY.sh** — runs at launch (live git state)
- **LESSONS.md** — grows over time (knowledge capture)
- **DESIGN.md** — this file, changes when architecture decisions change
- **CHANGELOG.md** — appends with each version

No file tries to do two jobs.

## Feed-Only PMax as Distinct Configuration

**Decision:** Created a dedicated reference doc (`pmax/feed-only-pmax.md`) for feed-only PMax rather than patching it into `asset-requirements.md` or `feed-optimization.md`. Restructured `pmax-guide` skill with a decision fork at Step 0.

**Why:** The plugin treated PMax as a single archetype requiring full creative assets. This caused a real failure: Claude couldn't guide campaign restructuring for an e-commerce client because it thought PMax "cannot launch" without creative. Feed-only PMax is a distinct configuration with its own setup flow (listing groups, not asset groups), its own auto-generation behavior, and its own restructuring pattern. It shares audience signals and bidding with full PMax, but the setup workflow is fundamentally different. A decision fork at the top of the skill routes to the correct path.

## Custom MCP Server (Three-Gate Safety)

**Decision:** Built a custom `voxxy/google-ads-mcp-server` rather than using community alternatives (`googleads/google-ads-mcp`, `kLOsk/adloop`, `TheMattBerman/google-ads-copilot`). Write operations use three gates: session passphrase lock → ChangePlan draft-then-confirm → `validate_only` dry-run.

**Why:** Google's official MCP server is deliberately read-only. ~70% of all Google Ads MCP repos are read-only — write operations through LLM-controlled tools are high-risk. The three-gate safety pattern ensures: (1) writes require explicit user intent per session, (2) every mutation is previewed as a draft before execution, (3) the API validates the change without applying it. Additional safeguards: budget ±50% / bid +30% caps, stale-state re-reads before mutation, REMOVE operations blocked entirely, full JSON audit log.

## External Source Verification

**Decision:** `feed-only-pmax.md` includes an External Sources section with Google API docs, code samples, and SMEC industry research URLs.

**Why:** Campaign management knowledge can become stale quickly. By citing specific Google support pages, API documentation, and industry research (SMEC's 4,000+ campaign study), future sessions can verify claims against the source rather than trusting training data. The listing group dimensions were verified against the actual API proto definition, not guessed from memory.

## Tiered Account Profile Framework (Strategic Upgrade v2.0)

**Decision:** Strategic recommendations flow through a 10-dimension account profile organized in 3 tiers: Core Axes (vertical × maturity × budget → select archetype), Strategic Modifiers (tracking maturity, conversion complexity, geographic scope, competition → adjust archetype), Operational Context (management model, feed presence, business model → shape workflow). ~64 core combinations collapse into ~15 strategy archetypes.

**Why:** The plugin's biggest gap was context-blindness — every skill gave the same advice regardless of whether the account was a cold-start B2B SaaS on €2K/mo or a mature e-commerce store on €50K/mo. A flat list of "account types" would create either too many buckets (unmanageable) or too few (useless). The tiered approach lets the strategy skill ask 3 core questions first to narrow the archetype, then refine with modifiers only when relevant. The 15 archetypes are the sweet spot between actionability and coverage.

## Strategy Docs in reference/platforms/google-ads/strategy/

**Decision:** Strategic reference docs live in `reference/platforms/google-ads/strategy/` as a subdirectory alongside `pmax/` and `audit/`, not as a separate top-level `reference/strategy/` directory.

**Why:** Strategy is platform-specific — Google Ads bidding strategies differ from Meta bid strategies. When Phase 4 adds other platforms, each will get its own `strategy/` subdirectory with platform-specific playbooks. This preserves the existing pattern (all Google Ads knowledge under one tree) and the reference-loading convention (skills load from `reference/platforms/google-ads/`).

## Skill Flow Graph (Inter-Skill Routing)

**Decision:** Skills are no longer islands. Each skill routes to relevant next skills at completion. The intended flow is: account-strategy (Phase 2) → campaign-setup → keyword-strategy → budget-optimizer, with conversion-tracking and campaign-review as cross-cutting skills.

**Why:** The skill review audit (2026-04-03) found 6 of 11 skills had no inter-skill references — users would finish keyword planning with no guidance on what to do next. The flow graph ensures every skill ends with a clear "next step" recommendation, creating a natural workflow through the plugin's capabilities.
