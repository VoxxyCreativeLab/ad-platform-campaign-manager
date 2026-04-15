---
title: Primer - Session Handoff
date: 2026-04-14
tags:
  - mwp
---

# Primer - Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.20.0 — Claude Code plugin for Google Ads campaign management, built for tracking specialists. v1.21.0 in progress (Sessions 3-5).

---

## Last Completed

### Session 2026-04-14 (Session 3): iClosed Attribution + n8n Pipeline Patterns

- **Research completed:** iClosed webhook events (12 from Zapier, key 5 for tracking), GTM dataLayer events (5 confirmed in iClosed docs — NOT unverified), native Meta CAPI integration (auto-captures fbc/fbp), UTM field format, n8n webhook auth methods (Basic/Header/JWT + IP whitelist), Airtable trigger (polling, execution cost implications), BigQuery node, Meta CAPI action_source values, fbc construction format. Saved to design spec Appendix Session 3.
- **`reference/tracking-bridge/iclosed-attribution.md`** — New reference doc: 12 webhook events table, GTM Scenario A/B embedding, fbclid passthrough (tracking object caveat), callOutcome attribution gap + contactId workaround, native Meta CAPI context (when to use native vs n8n), consent gating, confirmed GTM dataLayer events.
- **`reference/tracking-bridge/n8n-pipeline-patterns.md`** — New reference doc: 4-workflow pattern (WF1 Booking→CRM, WF2 Outcome→CRM, WF3 CRM→CAPI, WF4 Events→BQ), webhook security options (no HMAC from iClosed), Meta CAPI payload with fbc construction, n8n node reference table, pricing guide (Pro €50/mo recommended, Starter insufficient for frequent polling).
- **`reference/tracking-bridge/CONTEXT.md`** — Updated: 6 → 8 files, new reading order scenarios, file index table added.
- **Design spec appendix** — Session 3 research saved.
- **PLAN.md** — Session 3 items checked off.
- **Commit:** `5395be5` — `feat: iClosed attribution + n8n pipeline patterns`

---

### Session 2026-04-14 (Session 2): Product Performance Skill (v1.20.0)

- `skills/product-performance/SKILL.md` — 5-step interactive flow, 4 GAQL queries, zombie triage, feed diagnosis, campaign-type-aware exclusions. Stage: 05-optimize.
- `CONTEXT.md`, `CLAUDE.md`, `BACKLOG.md` updated for v1.20.0.

---

## Current State

### Plugin (ad-platform-campaign-manager) — v1.20.0 (v1.21.0 in progress)

| Layer | Count | Notes |
|-------|-------|-------|
| Reference files | 48 | +2 from Session 3 (iclosed-attribution, n8n-pipeline-patterns) |
| Script docs | 17 | under `reference/scripts/` |
| Tracking-bridge docs | 8 | +2 new (iClosed, n8n) — was 6 |
| Reporting docs | 5 | expanding to 6 in v1.21.0 Session 4 (Meta BQ) |
| Skills | 15 | product-performance added in v1.20.0 |
| Agents | 3 | campaign-reviewer, tracking-auditor, strategy-advisor |
| Audit areas | 21 | All Priority 1-3 complete |

### Branch

`main` — all releases committed directly on main (plugin convention).

### MCP Server (google-ads-mcp-server)

- 25 tools: 3 session + 9 read + 11 write + 2 confirm
- Connected to MCC 7244069584 via Explorer Access (2,880 ops/day)
- Write passphrase: `voxxy-writes`
- Credentials at `C:\Users\VCL1\google-ads.yaml`
- Wrapper at `C:\mcp\google-ads.cmd`

---

## What Still Needs to Happen

### Next session (Session 4): Research Meta BQ (#11) + Cross-Platform (#13)

1. **Online research:** BigQuery Data Transfer Service for Meta/Facebook (connector capabilities, field coverage, setup), OWOX Data Marts GitHub repo (architecture, supported metrics), Meta Marketing API (fields, rate limits), comparison of all 3 approaches (cost, latency, maintenance). Save to design spec Appendix Session 4.
2. **Write:** `reference/reporting/meta-ads-bigquery.md` — 3 pipeline approaches (BQ Data Transfer, OWOX, n8n HTTP), decision matrix, BQ schema
3. **Extend:** `reference/reporting/cross-platform-data-model.md` — 5-source architecture table (GA4, Meta Ads, iClosed, Airtable, sGTM), join key strategy (contactId, callPreviewId), lead lifecycle stages, fbc reconstruction formula
4. **Commit** Session 4 + PRIMER.md rewrite

### Session 5: Integration + Release v1.21.0

- **Wire:** `CONTEXT.md` (3 new routing entries: iClosed, n8n, Meta Ads BQ)
- **Update:** `CLAUDE.md` — relax "Google Ads only" for tracking-bridge scope
- **Update:** `_config/ecosystem.md` — add n8n-plugin note
- **Update:** `BACKLOG.md` — mark #10–#13 Done (v1.21.0)
- **Release:** v1.21.0 — CHANGELOG entry, commit, final PRIMER.md rewrite

### Housekeeping

- **Rotate OAuth client secret** — exposed in session screenshot (2026-04-01). Do in GCP Console before production use.
- **Priority 4 audit:** DSA-specific section (~4 checks), App Campaigns (~4 checks) — niche, defer
- **Phase 4 Multi-platform:** meta-ads/, linkedin-ads/, tiktok-ads/ platform skills — no demand, defer

---

## Key Research Notes for Session 4

From Session 3 research — carry forward for cross-platform data model work:

- **fbc format:** `fb.1.{subdomainIndex}.{creationTime_ms}.{fbclid}` — NOT `fb.1.{bookingTime}.{fbclid}`
- **contactId:** iClosed's internal contact identifier — primary join key across iClosed, Airtable, and CAPI events
- **callPreviewId:** unique per call — use as `event_id` for CAPI deduplication
- **iClosed native CAPI events:** Page view, Potential, Qualified, Disqualified, Call booked (`invitee_meeting_scheduled`) — these come from native integration; custom purchase events need n8n

---

## Design Documents

- **Backlog expansion design:** `docs/superpowers/specs/2026-04-14-backlog-expansion-design.md` (includes Session 3 research in Appendix)
- **Backlog expansion plan (25 tasks):** `docs/superpowers/plans/2026-04-14-backlog-expansion.md`
- **Backlog gap fill plan:** `docs/superpowers/plans/2026-04-08-backlog-gap-fill.md`
- **Report output structure spec:** `docs/superpowers/specs/2026-04-04-report-output-structure-design.md`

## Open Blockers

- **Credential rotation:** OAuth client secret exposed (2026-04-01) — rotate before production
