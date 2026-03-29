---
title: Conventions
tags:
  - layer-3
  - reference
---

# Conventions

%% LAYER 3 — STABLE REFERENCE %%
%% Naming, file organisation, and structural rules for this plugin. %%
%% Split into plugin development conventions and campaign output conventions. %%

---

## Plugin Development Conventions

### SKILL.md Frontmatter

Every skill file must include YAML frontmatter with these fields:

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Lowercase, hyphen-separated. Must match the parent folder name. |
| `description` | Yes | One sentence. Used in skill discovery and help output. |
| `disable-model-invocation` | Yes | `true` for wizard skills (step-by-step), `false` for reference skills (question-driven). |
| `argument-hint` | No | Placeholder hint shown to the user (e.g., `"[campaign-type]"`). |

### Reference File Naming

- **Format:** `kebab-case.md` (e.g., `bidding-strategies.md`, `gtm-to-gads.md`)
- **Grouping:** files live in topic subdirectories under `reference/` (e.g., `platforms/google-ads/`, `tracking-bridge/`, `reporting/`)
- **Sub-topics:** use nested directories (e.g., `platforms/google-ads/pmax/`, `platforms/google-ads/audit/`)

### Reference File Structure

1. YAML frontmatter: `title`, `date`, `tags`
2. H1 title matching the `title` frontmatter property
3. Sections with H2/H3 headings
4. Tables for structured data, fenced code blocks for examples
5. Wikilinks for cross-references to other reference files: `[[filename]]` or `[[path/filename|display text]]`

### Agent File Naming

- **Format:** `kebab-case.md` in `agents/` directory
- **Frontmatter:** `name`, `description`, `tools` (array), `model` (e.g., `sonnet`)

### Skill Directory Naming

- Lowercase, hyphen-separated: `campaign-setup/`, `keyword-strategy/`
- Must match the `name` field in the SKILL.md frontmatter
- Each directory contains exactly one `SKILL.md` file

### Internal Cross-References

- Within reference files: `[[filename]]` or `[[filename|display text]]`
- From SKILL.md to reference: `[[../../reference/path/filename|filename.md]]`
- External URLs: standard markdown `[text](https://url)`

### Version Control

- Commit message format: `type: description` where type is one of `feat`, `fix`, `chore`, `refactor`, `docs`
- Tag releases: `v[major].[minor]`
- Commit after each logical change (not batched at end of session)

---

## Campaign Output Conventions

### Campaign Plan Format

Campaign plans produced by the `campaign-setup` skill follow this structure:

1. **Campaign overview** — name, type, goal, budget, bid strategy, targeting
2. **Ad groups / asset groups** — names, themes, keywords or audience signals
3. **Ad copy** — all headlines, descriptions, and assets
4. **Extensions** — sitelinks, callouts, structured snippets with copy
5. **Negative keywords** — initial negative keyword list
6. **Conversion tracking status** — what's set up, what's needed
7. **Next steps** — checklist for implementing in Google Ads

### Ad Copy Format

| Asset type | Character limit | Notes |
|-----------|----------------|-------|
| RSA headline | 30 characters | 15 per ad group, varied themes |
| RSA description | 90 characters | 4 per ad group |
| PMax headline | 30 characters | 5 per asset group |
| PMax long headline | 90 characters | 5 per asset group |
| PMax description | 90 characters | 5 per asset group |

Rules:
- Sentence case (not Title Case or ALL CAPS)
- No repetition across headlines
- Include: keywords, value propositions, CTAs, brand name, differentiators
- Pin only when necessary (prefer unpinned for RSA optimization)

### Keyword List Format

| Column | Description |
|--------|-------------|
| Keyword | The keyword phrase |
| Match type | Broad, Phrase, or Exact |
| Ad group | Which ad group this keyword belongs to |
| Rationale | Why this match type was chosen |

Group keywords by ad group. Include negative keywords as a separate section.

### Audit Report Format

Campaign audits (from `campaign-review` skill or `campaign-reviewer` agent):

1. **Scorecard** — X/Y checks passing, overall score
2. **Findings** — each issue tagged with severity: `Critical`, `Warning`, `Info`
3. **Action plan** — prioritized list, critical items first
4. **Quick wins** — changes that take <5 minutes with high impact

### Tracking Audit Format

Tracking audits (from `conversion-tracking` skill or `tracking-auditor` agent):

1. **Layer-by-layer results** — Google Ads → GTM → sGTM → BigQuery
2. **Data discrepancy table** — expected vs actual conversion counts per layer
3. **Architecture diagram** — text-based data flow
4. **Recommendations** — fixes per layer, ordered by data loss impact

---

## Folder Naming

- Lowercase, hyphen-separated: `my-folder-name`
- No spaces, no underscores (exception: `_config/` per MWP convention)
- Plugin root directories are convention-locked: `skills/`, `agents/`, `reference/`, `_config/`, `.claude-plugin/`
