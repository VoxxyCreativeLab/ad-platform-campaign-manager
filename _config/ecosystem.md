---
title: Claude Plugin & Tool Ecosystem
date: 2026-03-28
tags:
  - reference
  - ecosystem
  - plugins
---

# Claude Plugin & Tool Ecosystem

%% REFERENCE FILE — Load this when you need to know what plugins, CLIs, or MCPs are available for a given domain. %%
%% Keep entries concise. This file should stay under ~800 tokens. %%

---

## Claude Code Plugins

### Domain Plugins

#### gtm-template-builder-plugin ✅ Active
- **Skills:** `scaffold-template`, `sandboxed-js`, `permissions`, `parameters`, `template-tests`, `gallery-submit`
- **Agent:** `template-reviewer`
- **Domains:** GTM custom templates, analytics, tag management, tracking
- **When to use:** Building or reviewing Google Tag Manager custom templates (.tpl files)
- **Companion trigger:** Run `/gtm-template-builder-plugin:scaffold-template` after project scaffold

---

#### wordpress-fse-builder-plugin ✅ Active
- **Skills:** `scaffold-theme`, `apply-design-system`, `generate-css`, `create-pattern`, `create-template`, `deploy-ftp`, `validate-theme`
- **Agent:** `theme-reviewer`
- **Domains:** WordPress FSE, block themes, theme.json, Gutenberg patterns, WooCommerce
- **When to use:** Building or reviewing WordPress FSE block themes
- **Companion trigger:** Run `/wordpress-fse-builder-plugin:scaffold-theme` after project scaffold

---

#### ad-platform-campaign-manager ✅ Active
- **Skills:** `campaign-setup`, `keyword-strategy`, `conversion-tracking`, `reporting-pipeline`, `campaign-review`, `campaign-cleanup`, `pmax-guide`, `budget-optimizer`, `ads-scripts`, `live-report`
- **Agents:** `campaign-reviewer`, `tracking-auditor`
- **Domains:** Google Ads, PPC, campaign management, conversion tracking, BigQuery reporting
- **When to use:** Setting up, auditing, or optimizing Google Ads campaigns; building conversion tracking pipelines
- **Companion trigger:** Run `/ad-platform-campaign-manager:campaign-setup` for new campaigns

---

### Reference & Planned Plugins

#### kepano/obsidian-skills 📖 Reference
- **Skills:** `obsidian-markdown`, `obsidian-bases`, `json-canvas`, `obsidian-cli`, `defuddle`
- **Domains:** Obsidian vault management, Obsidian-flavored markdown, Canvas, Bases
- **Relationship:** Our `obsidian-format` skill draws conventions from this plugin's spec. Not a runtime dependency — our skill is standalone.
- **Source:** [github.com/kepano/obsidian-skills](https://github.com/kepano/obsidian-skills)

#### nextjs-plugin 🔲 Planned
- **Skills:** TBD (scaffold, build, deploy)
- **Domains:** Next.js apps, React, static sites, JAMstack
- **When to use:** Building Next.js / React applications
- **Status:** Not yet built — use `tech-standards.md` + `component-library.md` stubs manually

#### n8n-plugin 🔲 Planned
- **Skills:** TBD (design, build, test, deploy)
- **Domains:** N8N workflow automation, API integrations, agent pipelines
- **When to use:** Designing or building N8N automation workflows
- **Status:** Not yet built — use `tech-standards.md` + `conventions.md` stubs manually

### Methodology & Workflow Plugins

#### superpowers ✅ Active
- **Author:** Jesse Vincent (obra) — claude-plugins-official marketplace
- **Skills:** brainstorming, writing plans, TDD, systematic debugging, subagent-driven development, verification, code review (giving/receiving), parallel agent dispatch, git worktrees, branch finishing, plan execution, skill writing
- **Domains:** All — cross-cutting methodology plugin, not domain-specific
- **When to use:** Brainstorming requirements, writing granular plans, TDD workflows, systematic debugging, dispatching parallel agents, code review, git worktree management
- **Install:** `claude plugin install superpowers@claude-plugins-official`

---

#### frontend-design ✅ Active
- **Author:** Anthropic (Prithvi Rajasekaran, Alexander Bricken) — claude-plugins-official marketplace
- **Skills:** `frontend-design`
- **Domains:** All — cross-cutting design quality plugin, not domain-specific
- **When to use:** Building frontend interfaces with distinctive design quality — typography, color, animations, spatial composition. Avoids generic AI aesthetics.
- **Install:** `claude plugin install frontend-design@claude-plugins-official`

---

### email-marketing-plugin 🔲 Planned
- **Skills:** TBD (copy, design, build, test)
- **Domains:** Email campaigns, newsletters, drip sequences, MailChimp, ActiveCampaign
- **When to use:** Creating email marketing campaigns or sequences
- **Status:** Not yet built — use `voice.md` + `conventions.md` stubs manually

---

## CLIs by Domain

| CLI | Domain | What it does |
|-----|--------|-------------|
| `git` | All | Version control |
| `gh` | All | GitHub operations from terminal |
| `node` / `npm` / `pnpm` | Software, Next.js, N8N | Run and build JavaScript projects |
| `wp-cli` | WordPress | Manage WordPress installs from terminal |
| `n8n` | N8N | Start local N8N instance, import/export workflows |
| `vercel` | Next.js, landing pages | Deploy to Vercel from terminal |
| `wrangler` | Edge / Cloudflare | Deploy to Cloudflare Workers/Pages |
| `adsctl` | Google Ads | kubectl-style CLI — GAQL REPL, campaign editing, multi-account |
| `gaql-cli` | Google Ads | GAQL-focused REPL with autocomplete (by GetYourGuide) |

---

## MCPs (Model Context Protocols)

| MCP | Domain | What it enables | Status |
|-----|--------|----------------|--------|
| Notion MCP | All | Read/write Notion pages, databases, comments | ✅ Active |
| googleads/google-ads-mcp | Google Ads | Read-only — diagnostics, analytics, GAQL, anomaly detection | 🔲 Awaiting credentials |
| cohnen/mcp-google-ads | Google Ads | Read + Write — full CRUD, keywords, budget, GAQL | 🔲 Awaiting credentials |
| GitHub MCP | All | Read/write GitHub repos, issues, PRs | 🔲 Not configured |
| Browser MCP | QA, testing, scraping | Automate browser actions | 🔲 Not configured |
| Database MCP | Software, finance, N8N | Query databases directly | 🔲 Not configured |
| Filesystem MCP | All | Enhanced file operations | 🔲 Not configured |

---

## External Tools by Domain

| Tool | Domain | Purpose |
|------|--------|---------|
| Google Tag Manager UI | GTM | Template upload, container management, preview |
| GTM Template Gallery | GTM | Community template submission |
| Google Ads UI | Google Ads | Campaign management, Scripts editor, API Center |
| Google Ads API Center | Google Ads | Developer token management, access level requests |
| Google Merchant Center | Google Ads / PMax | Product feeds for Shopping and PMax campaigns |
| WordPress Admin | WordPress | Content, plugins, theme management |
| Vercel Dashboard | Next.js | Deployment monitoring |
| N8N Cloud / Self-hosted | N8N | Workflow execution and management |
| Mailchimp / ActiveCampaign | Email marketing | Campaign deployment and analytics |

---

%% To add a domain plugin: copy a "Planned" block under Domain Plugins, fill in the skills, change status to ✅ Active. %%
%% To add a methodology plugin: add an entry under Methodology & Workflow Plugins. %%
%% To add a new MCP: add a row to the MCPs table and change status once configured. %%
