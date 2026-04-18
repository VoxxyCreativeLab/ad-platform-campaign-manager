---
title: Lessons Learned
date: 2026-03-31
tags:
  - mwp
---

# Lessons Learned

Campaign management and plugin development lessons captured over time. Each entry includes the date, context, and takeaway.

## Plugin Development

- **2026-04-18** — When a sibling plugin becomes the authoritative source for knowledge a consuming plugin was planning to document, add cross-plugin routing edges instead of duplicating content. When n8n-workflow-builder-plugin v0.2.0 shipped 14 tracking-stack recipes covering exactly what ad-platform backlog items #10–#14 needed, adding 4 routing edges across 4 skill files closed 5 items as Done with no content duplication. Keeps the ecosystem DRY; sibling plugin owners are the right maintainers for their domain.
- **2026-03-31** — Marketplace clone sync is the #1 recurring failure mode. After pushing new skills to GitHub, you must manually update the local marketplace clone: `cd ~/.claude/plugins/marketplaces/{plugin-name}/` → `git pull` → `claude plugin uninstall` → `claude plugin install` → VSCode `Ctrl+Shift+P` → Reload Window. Skipping any step means Claude won't see your changes.
- **2026-03-31** — `marketplace.json` must use the `plugins[]` array with `source` field. Custom `skills[]` arrays are silently ignored.
- **2026-03-31** — `disable-model-invocation: true` in skill frontmatter hides the skill from model discovery entirely. Use for Phase 2+ skills that aren't ready yet. Set to `false` to make them visible.
- **2026-03-31** — VSCode extension requires a full window reload (`Ctrl+Shift+P` → `Developer: Reload Window`) after plugin install. Opening new tabs or restarting terminals is not enough.
- **2026-03-31** — Skill names must be globally unique across ALL installed plugins. Prefix with plugin name to prevent collisions.
- **2026-03-31** — Claude (the AI) MUST run the marketplace clone sync as part of every commit+push workflow, NOT just remind the user to do it manually. The sync commands (`git pull` marketplace clone → `claude plugin uninstall` → `claude plugin install`) must be executed by Claude immediately after `git push`, in the same workflow. Telling the user "don't forget to sync" is not acceptable — the user asked Claude to handle the full process. If Claude cannot execute the sync commands (e.g. plan mode), it must flag this as a blocker before pushing.
- **2026-04-01** — Plugin installation can silently half-complete. The marketplace clone (`known_marketplaces.json`), the cache (`plugins/cache/`), and the `additionalDirectories` entry can all exist while `installed_plugins.json` and `enabledPlugins` in `settings.json` are missing. This means the plugin LOOKS installed but skills never load. Root cause: the `claude plugin install` step either failed silently, was interrupted, or was skipped during a batch install. Always verify all 5 registration points after installing: (1) `known_marketplaces.json`, (2) `plugins/cache/{name}/`, (3) `additionalDirectories` in `settings.json`, (4) `installed_plugins.json`, (5) `enabledPlugins` in `settings.json`. If skills don't appear, check `enabledPlugins` first — that's the gate.

## Third-Party Plugins

- **2026-04-04 — Superpowers plugin (v5.0.6) deprecated old slash commands.** `/brainstorm`, `/write-plan`, `/execute-plan` now show deprecation notices. Use the skill-based equivalents: `/brainstorming`, `/writing-plans`, `/executing-plans`. The old commands will be removed in the next major superpowers release. This is a third-party plugin change — no action needed in our custom plugins.

## MCP Server Development

- **2026-04-02** — Machine migration gotcha: `google-ads.yaml` (home directory credential file) is NOT covered by OneDrive sync or git. It must be backed up separately during machine migrations. The wrapper script (`C:\mcp\google-ads.cmd`), `.venv`, `config.yaml`, and even tool permissions in `settings.json` all survived — but the credential file was the single point of failure. Add `~/google-ads.yaml` to the migration runbook checklist.
- **2026-04-02** — MCP server registration (`mcpServers` in `~/.claude.json`) does NOT survive machine migration. Must re-register with `claude mcp add google-ads -s user -- "C:\mcp\google-ads.cmd"` after migration. Note: this writes to `~/.claude.json`, not `~/.claude/settings.json` — they are different files with different purposes.
- **2026-04-01** — Google's own MCP server (`googleads/google-ads-mcp`) is deliberately read-only. ~70% of all Google Ads MCP repos are read-only. Write operations through LLM-controlled tools are high-risk. Always implement a multi-gate safety architecture for write operations.
- **2026-04-01** — The #1 costly error in Google Ads API work is micros confusion (1,000,000 micros = 1 EUR). Accept human currency only, convert internally, reject values > 10,000 as likely raw micros.
- **2026-04-01** — Draft-then-confirm with `ChangePlan` objects + `validate_only` dry-runs + stale-state re-reads before mutation is the gold-standard safety pattern. Learned from `kLOsk/adloop` and `TheMattBerman/google-ads-copilot`.
- **2026-04-01** — Session passphrase write lock is an effective additional gate. Even if Claude calls a write tool, it cannot execute without the user first unlocking writes for the session.
- **2026-04-01** — The `mcp` Python SDK requires `async def` for tool handlers, but synchronous Google Ads API calls work fine inside them. The `async` is cosmetic — no event loop complexity needed.
- **2026-04-01** — MCP server config: use `claude mcp add <name> -s user -- <command>` to register. This writes to `~/.claude.json` `mcpServers`. Do NOT manually edit `~/.claude/.mcp.json` (not read by VS Code extension) or `~/.claude.json` directly (gets overwritten on startup).
- **2026-04-01** — Python `-m` module bug: when `server.py` defines a shared object (like `mcp = FastMCP(...)`) and is also the `__main__` entrypoint, `from package.server import obj` creates a SECOND instance. Fix: move the shared object to its own module (e.g., `app.py`) so all imports resolve to the same object. Classic `__main__` vs module-name split.
- **2026-04-01** — On Windows, MCP server paths with spaces break shell spawning. Use a wrapper `.cmd` script in a clean path (e.g., `C:\mcp\google-ads.cmd`) that `cd /d` to the real directory and runs the command.
- **2026-04-01** — Explorer Access (2,880 ops/day) is auto-granted with no application. Sufficient for interactive Claude use. Try this before applying for Basic/Standard access.
- **2026-04-01** — Google Ads API version must match the `google-ads` Python client library. Library v30.0.0 ships v20-v23 only. Always check available versions with `pkgutil.iter_modules(google.ads.googleads.__path__)` before hardcoding.
- **2026-04-01** — Never share OAuth client secrets in screenshots or conversation. If exposed, rotate immediately in GCP Console → Credentials → Reset Secret.
- **2026-04-18** — When adding a new skill in a release commit, update `skills/CONTEXT.md` skill count and the README skills table in that same commit. Two releases in a row (v1.23.0 `account-scaling`, v1.24.0 `ad-campaign-war-council`) shipped without updating either file — both were caught and fixed by `/cut-release` during v1.25.0. Fix: add README + skills/CONTEXT.md count update to the standard per-skill release checklist.

## Campaign Strategy

- **2026-04-18** — The "20% budget change resets learning" rule is industry consensus, not an official Google rule. Google's official docs (`answer/13020501`) list learning triggers as: new strategy, setting change (bid strategy settings), composition change (campaigns/ad groups). Budget changes are absent. The 20% step rule comes from WordStream, KlientBoost, Dilate. Practically, large increases can cause pacing re-adjustment, but no formal "Learning" status is triggered. Reference docs should say "may cause algorithm re-adjustment" rather than "resets learning."
- **2026-04-01** — Feed-only PMax is a distinct configuration from full PMax. When a client has a Merchant Center feed but no creative assets, the answer is NOT "you can't launch PMax" — it's feed-only PMax with auto-generated creative from the feed. The campaign-setup skill previously blocked this path entirely with a factually wrong blocker.
- **2026-04-01** — Account restructuring (messy Shopping+PMax → clean feed-based PMax) must be stepwise: create new PMax paused → pause overlapping Shopping → enable new PMax → monitor 2-4 weeks. Never cold-turkey. Keep old campaigns paused (not deleted) for 30 days as rollback.
- **2026-04-01** — Since late 2024, PMax is no longer auto-prioritized over Standard Shopping in auctions. Both compete on Ad Rank. Running both (70/30 or 80/20 split favoring PMax) is a viable strategy — restructuring to PMax-only is a choice, not a necessity.

## Skill Quality & Architecture

- **2026-04-03** — Full skill audit revealed 6 systemic issues across all 11 skills: missing argument-hints (9/11), wrong placeholder syntax (11/11), missing inter-skill refs (6/11), dependency map drift (2/11), missing $ARGUMENTS handling (5/11), no companion files (11/11). The live-report skill was the weakest (62/100) — essentially a table of contents with no actionable content. pmax-guide (90/100) was the gold standard: Step 0 decision tree, task-specific paths, troubleshooting table, inter-skill refs. Use pmax-guide as the template when designing or improving skills.
- **2026-04-03** — `effort`, `maxTurns`, and `tools` are NOT valid SKILL.md frontmatter fields. Claude Code silently ignores them. Valid fields: `name`, `description`, `argument-hint`, `compatibility`, `license`, `metadata`, `disable-model-invocation`, `user-invocable`. Test frontmatter fields before assuming they work.
- **2026-04-08 — Claude keeps using `skill:` instead of `name:` as the identifier field when creating new SKILL.md files.** `skill:` is silently ignored — the skill may still appear in the list (Claude Code falls back to directory name) but the registration is broken. Same problem with `version:` and `tags:` — both are invalid and silently ignored. **Root cause: generating frontmatter from memory instead of copying from an existing working skill.** Fix: ALWAYS copy frontmatter from an existing correct skill in the same plugin before creating a new one. Never generate SKILL.md frontmatter from memory.
- **2026-04-03** — Subagent-driven development works well for mechanical skill fixes (batch frontmatter changes, add sections). Use haiku for simple edits (CONTEXT.md routing fixes), sonnet for content additions (troubleshooting tables, output templates), opus for research-heavy work (strategy reference docs). The tiering saved significant time and cost.
- **2026-04-03** — Strategy docs should use `%%fact-check: [feature] — verified [date]%%` markers on any claims tied to specific Google Ads features. Google changes features frequently — these markers create an audit trail for future fact-check sweeps.

## Strategic Layer

- **2026-04-03** — Docs-first agent development is the right pattern for knowledge-heavy agents. Writing the 5 reference docs before the strategy-advisor agent meant: (1) existing skills benefited immediately, (2) the agent had a complete knowledge base on day one, (3) no rework cycle. This mirrors Phase 1b/1c where reference docs preceded skill hooks.
- **2026-04-03** — Two-mode agents (with/without profile) provide flexibility without compromising quality. The strategy-advisor produces a full gap analysis with a profile, or a quick structural health check without one. This matches the "profile skip shortcut" pattern already in 10 skills — consistency across the plugin.

## Audit & Reviews

- **2026-04-06** — Having comprehensive reference docs for a campaign type does NOT mean the audit checklist covers it. Reference docs and audit checklist items must be added as **paired units**. The Vaxteronline Shopping campaign (biggest spender) passed a full audit with EUR 0.10 product group bids, 35% click share, and 40% impression share undetected — because the audit checklist had zero Shopping-specific items despite `shopping-campaigns.md` and `shopping-feed-strategy.md` both existing. Lesson: after adding any reference doc, immediately wire at least a stub section into `audit-checklist.md` and `campaign-review` SKILL.md.
- **2026-04-06** — Audience strategy is a near-universal audit gap. Most audit checklists focus on campaign structure, keywords, and bids — and completely miss whether remarketing lists are configured, whether converters are excluded from prospecting, and whether RLSA layering exists. This gap existed in our plugin despite having `remarketing-strategies.md` and `targeting-framework.md`. Added an 11-item Audience Strategy section as Area 13 in campaign-review.

## Keyword Management

_(No entries yet)_

## Bidding & Budget

_(No entries yet)_

## Performance Max

- **2026-04-01** — Listing groups are the PMax equivalent of Shopping product groups. They control which products from the feed appear in which asset group. Critical difference from Shopping: listing groups are for inclusion/exclusion ONLY — they do NOT set bids. Without proper listing group configuration, all products dump into a single bucket — defeating the purpose of asset group segmentation.
- **2026-04-01** — Seven listing group dimension types available: ProductBrandInfo, ProductCategoryInfo, ProductChannelInfo, ProductConditionInfo, ProductCustomAttributeInfo, ProductItemIdInfo, ProductTypeInfo. Custom attributes (custom_label_0-4) are the most flexible. Google's API docs say listing groups work "best when targeting groups of products" — use item ID sparingly.
- **2026-04-01** — SMEC data (4,000+ campaigns): 90% of PMax spend goes to feed-based ads (74-97% range). "There is little-to-no downside of using a feed-only campaign and little-to-no upside of using a full-asset campaign." The choice is strategic, not performance-driven.
- **2026-04-04** — **Feed-only PMax can ONLY be created from Merchant Center** (Marketing > Advertising campaigns). Google Ads now requires 3+ headlines to save an asset group — you cannot create a zero-asset asset group from Google Ads UI anymore. The MC path creates a single asset group with no asset minimums. This is the only true feed-only path. Creating from Google Ads with minimal text assets is "feed-first PMax," not "feed-only." Our reference doc previously described both paths as equal — corrected.
- **2026-04-04** — After creating feed-only PMax via Merchant Center, immediately lock it down in Google Ads: (1) disable Text customization / Automatically created assets, (2) disable Final URL Expansion, (3) remove Final URL from asset group so only product feed URLs are used. Without these steps, Google auto-generates creative and expands to non-product URLs.
- **2026-04-04** — MC-created feed-only PMax has a **single-asset-group limitation**. You get one asset group. If you later add asset groups in Google Ads, Google enforces minimums (3+ headlines), breaking the feed-only approach for those additional groups. Plan around this.
- **2026-04-04** — Since Q2 2025, feed-only PMax campaigns auto-generate **Connected TV (CTV) ads** from product images — 80% of PMax advertisers now generate CTV impressions, many unknowingly. No opt-in required. Use channel-level reporting (available since Aug 2025, API v23 Jan 2026) to monitor: healthy benchmark is 60-80% Shopping spend.
- **2026-04-04** — The "90% to feed-based" SMEC claim needs nuance. The 90% figure includes feed-based ads on ALL surfaces (dynamic remarketing on Display, product cards on Gmail/Discover). Channel reporting shows **60-80% to Shopping proper** as the more accurate benchmark for where the money actually goes on Shopping surfaces specifically.

## Conversion Tracking

_(No entries yet)_

## Reporting & Analytics

_(No entries yet)_

## Account Scaling & Growth Management

- **2026-04-16 — A skill cannot fully replace dynamic account scaling.** The `/account-scaling` skill (v1.23.0) was designed with 6 conditional trajectories (T1-T6) that cover the most common scaling situations. But true dynamic scaling — real-time multi-variable interactions, PMax/Shopping cannibalization in motion, predictive signal reading across changing account states — is beyond what a skill can achieve. The skill's value is MCP-powered gate evaluation + trajectory routing + evidence-gated recommendations + projection guardrail. It is a rigorous starting point, not a complete substitute for experienced campaign management judgment. Always present the skill's output as: "here is what the data says and here are the data-supported next steps" — not "here is what will happen."
- **2026-04-16 — "No canonical docs" claims need web verification before writing.** Before stating that "no published playbook exists" for a topic, run a web search. The initial claim for the account scaling skill was wrong — a dense body of agency and Google playbooks already covered the numbers (±10-20% budget steps, 14-day wait periods, PMax 50+ conv/mo thresholds). The actual gap was a *tooling gap* (nothing couples existing playbooks to live MCP reads + evidence gates), not an information gap. Getting this wrong in a spec leads to scope creep and missed citations.
- **2026-04-16 — Projection guardrail requires a documented strategy gate.** The root cause of the "5x ROAS in June/July" fabrication (Vaxteronline April 16 session) was simple: no skill enforced a check asking "where is this number documented?" before it went into client communication. The rule — "never state a future target that does not appear in a dated strategy document" — belongs in `_config/conventions.md` so it applies to every skill and agent, not just post-launch-monitor.

## Client Management

_(No entries yet)_

## Workflow & Skill Execution

- **2026-04-18 — Skill staged-interaction gates override plan-mode "single approval" pattern.** When a skill prescribes multi-step user-input gates (parse → surface blocked → propose groups → stale-check → research → execute → batch diff approval), the staged interaction *is* the deliverable. Do not collapse those gates into a single plan-mode "write plan, ExitPlanMode, approve all" cycle. Plan mode constrains tool use to read-only — it should sit *inside* the skill's gates (Steps 1–7 of `plugin-backlog-execute` are all read-only-compatible), not replace them. Symptom of the failure: the user loses per-step decision points (which blocked items to unblock, which groups to execute, which stale items to confirm) and is forced into one big yes/no on a pre-baked plan they cannot see yet. **Rule: when a skill explicitly says "wait for response" between steps, follow that gate even in plan mode.** The plan file becomes a running record updated between gates, not a single-shot approval artifact. If genuinely unsure how the two systems interact, ask the user up front before doing either. Source: `/plugin-backlog-execute` session 2026-04-18.
