---
title: Primer - Session Handoff
date: 2026-04-16
tags:
  - mwp
---

# Primer - Session Handoff

> This file rewrites itself at the end of every session. Read it first.

## Active Project

**ad-platform-campaign-manager** v1.21.1. v1.21.0 Sessions 4/5 are **paused** pending `n8n-plugin` creation. See pause memo: `docs/superpowers/plans/2026-04-16-session-4-paused.md`.

---

## Last Completed

### v1.21.1 — 2026-04-16 (backlog fix patch)

Two fixes shipped:

| Fix | Files | BACKLOG |
|-----|-------|---------|
| Feed-only PMax AD STRENGTH = POOR exception — added to 8 files | `pmax/feed-only-pmax.md`, `skills/pmax-guide/SKILL.md`, `skills/post-launch-monitor/SKILL.md`, `audit-checklist.md`, `agents/campaign-reviewer.md`, `agents/strategy-advisor.md`, `audit/common-mistakes.md`, `skills/live-report/references/report-templates.md` | #22 ✅ Closed |
| post-launch-monitor → Shopping regression routing | `skills/post-launch-monitor/SKILL.md` Step 4 + Step 7 routing table | #19 ✅ Closed |

Also fixed in this session (housekeeping, part of cut-release checklist):
- `README.md` — added `post-launch-monitor` and `product-performance` rows (were missing)
- `skills/CONTEXT.md` — count updated 14 → 15; `product-performance` added to dependency map
- `agents/campaign-reviewer.md`, `agents/strategy-advisor.md`, `agents/tracking-auditor.md` — added `title` and `tags` frontmatter (were missing)

### v1.21.0 — 2026-04-16 (same day, earlier)

- Shopping ROAS regression diagnostic protocol — `shopping-performance-regression-diagnosis.md` + `shopping-campaigns.md` Troubleshooting section
- Tracking-bridge Phase 1 restructure: `iclosed-attribution.md`, `n8n-pipeline-patterns.md`, `capi-server-events.md` (new)

### #14 BigQuery Native Connectors — Drafted (v1.22.0 seed)

`reference/reporting/bigquery-native-connectors.md` written this session. Committed separately from v1.21.1 — this is v1.22.0 material. Covers:
- GA4 native BQ export (streaming + daily, `ga4_dataform` transformation layer)
- Google Ads BQ Data Transfer Service (standard + custom GAQL reports — 2026 feature)
- Meta Ads BQ Data Transfer Service (Facebook Ads connector — now GA; corrects prior error)
- When to upgrade to OWOX / n8n
- 6 reference repos with star counts and licenses

**Key research finding (2026-04-16):** Meta Ads / Facebook Ads BigQuery Data Transfer Service is now generally available (official Google Cloud). Previous PRIMER error ("BDTS for Meta doesn't exist") is **corrected** — native connector exists, zero-cost for first-party use, daily 24h refresh.

---

## Current State

### Plugin — v1.21.1

| Layer | Count | Notes |
|-------|-------|-------|
| Reference files | 50 | +1 (`shopping-performance-regression-diagnosis.md`) vs v1.20.0 |
| Script docs | 17 | `reference/scripts/` |
| Tracking-bridge docs | 8 | iClosed, n8n pipeline, Meta CAPI (all rewritten/added v1.21.0) |
| Meta Ads docs | 1 | `capi-server-events.md` |
| Reporting docs | 5 | expanding to 6 in v1.22.0 (`bigquery-native-connectors.md` drafted this session) |
| Skills | 15 | `product-performance` added v1.20.0 |
| Agents | 3 | campaign-reviewer, tracking-auditor, strategy-advisor |
| Audit areas | 21 | All Priority 1-3 complete |

### Branch

`main` — all releases committed directly on main.

### MCP Server (google-ads-mcp-server)

- 25 tools: 3 session + 9 read + 11 write + 2 confirm
- Connected to MCC 7244069584 via Explorer Access (2,880 ops/day)
- Write passphrase: `voxxy-writes`
- Credentials at `C:\Users\VCL1\google-ads.yaml`
- Wrapper at `C:\mcp\google-ads.cmd`

---

## What Still Needs to Happen

### IMMEDIATE: Build n8n-plugin (prerequisite for v1.21.0 Sessions 4-5)

v1.21.0 Sessions 4 and 5 are **paused**. The Meta → BQ pipeline and cross-platform data model both depend on n8n as the transport layer. The `n8n-plugin` must exist first.

**Full pause memo:** `docs/superpowers/plans/2026-04-16-session-4-paused.md`

**After n8n-plugin ships** — return here and resume: Session 4 — Research Meta BQ (#11) + Cross-Platform (#13)

---

### Session 4 (after n8n-plugin) — Meta BQ + Cross-Platform Data Model

**Step 1 — Online research:** Meta BQ BDTS (now GA — confirm field coverage, historical backfill, 24h latency), OWOX Data Marts, Meta Marketing API for sub-daily needs.

**Step 2 — Create** `reference/reporting/meta-ads-bigquery.md`

Sections: Overview, BDTS (GA — free, daily 24h), OWOX Data Marts (sub-daily, MIT), n8n HTTP Request (real-time, custom fields), Decision Matrix, Schema (`meta_ads_performance`), Cross-References.

**Step 3 — Extend** `reference/reporting/cross-platform-data-model.md`

Add: 5-source architecture table, join key strategy (contactId, callPreviewId, fbc), lead lifecycle stages.

---

### Session 5 (after Session 4) — Integration + Release v1.21.0 (retag)

> [!note] Version note
> v1.21.0 tag was consumed by the Shopping regression diagnostic. The cross-platform tracking expansion may need a new version number (v1.22.0 if we merge it with BigQuery Baseline). Decide at Session 5 start.

| Step | File | Change |
|------|------|--------|
| 5.1 | `CONTEXT.md` | Add routing: Meta Ads BQ pipeline → `reference/reporting/meta-ads-bigquery.md` |
| 5.2 | `BACKLOG.md` | Mark #10-#13 Done |
| 5.3 | `CHANGELOG.md` | Add release entry |
| 5.4 | `PRIMER.md` | Final rewrite |

---

### After Sessions 4-5: v1.22.0 BigQuery Baseline (#14, #16, #17, #18)

**v1.22.0 seed content drafted this session (2026-04-16):**
- `reference/reporting/bigquery-native-connectors.md` — native BQ connectors for GA4, Google Ads DTS, Meta Ads DTS (all three native paths; n8n reverse pipeline deferred)

**Still blocked on Jerry's inputs:**
- **Watermelon plan path** — Jerry to provide at v1.22.0 Session 1 start (for #18)
- **GTM scripts inventory** — Jerry to provide at v1.22.0 Session 1 start (for #17)

**Meta-plan:** `C:\Users\VCL1\.claude\plans\wise-scribbling-cat.md`

---

## Key Research Notes for Session 4

From Session 3 research — carry forward:

- **fbc format:** `fb.1.{subdomainIndex}.{creationTime_ms}.{fbclid}` — creationTime_ms is LANDING time in ms, NOT booking time. Do NOT hash fbc — send as plain string.
- **subdomainIndex:** 1 for root domain (`example.com`), 2 for www subdomain (`www.example.com`)
- **contactId:** iClosed's internal contact identifier — primary join key across iClosed records, Airtable, and CAPI events
- **callPreviewId:** unique per call — use as `event_id` for CAPI deduplication
- **iClosed native CAPI events:** Page view, Potential, Qualified, Disqualified, Call booked — from native integration. Must be disabled when using n8n WF3 (or ensure matching event_id)
- **n8n Airtable trigger:** polling only — 5-min polling = ~8,640 executions/month, exceeds Starter (2,500). Use webhook-based triggers wherever possible; poll at 15-min intervals if polling is required
- **action_source for offline conversions:** `system_generated` — automated system event with no browser session present
- **Meta Ads BQ DTS (2026-04-16 research):** Facebook Ads connector is generally available on BQ DTS. Free for first-party (Google-owned) connectors. Daily refresh, ~24h latency. This corrects the Session 3 paused-state error ("BDTS for Meta doesn't exist").

---

## Design Documents

| File | Purpose |
|------|---------|
| `docs/superpowers/specs/2026-04-14-backlog-expansion-design.md` | Backlog expansion design (Sessions 2-5) |
| `docs/superpowers/plans/2026-04-14-backlog-expansion.md` | Implementation plan (Tasks 1-25) — Tasks 17-20 = Session 4, Tasks 21-25 = Session 5 |
| `docs/superpowers/specs/2026-04-14-tracking-bridge-restructure-design.md` | Restructure spec (Phase 1) — fully executed 2026-04-16 |
| `docs/superpowers/specs/2026-04-04-report-output-structure-design.md` | Report output structure spec (v1.8.0) |
| `C:\Users\VCL1\.claude\plans\wise-scribbling-cat.md` | v1.22.0 BigQuery Baseline meta-plan (outside codebase) |

---

## Housekeeping

- **Rotate OAuth client secret** — exposed in session screenshot (2026-04-01). Do in GCP Console before production use.
- **#21 ClickFunnels 2.0 deferred** — CF2.0 event names (`cfPageView`, `cfLead`) unverifiable in public docs. Resume when Hyros doc index is accessible or Jerry confirms from a live container.
- **Phase 4 Multi-platform:** `linkedin-ads/` and `tiktok-ads/` are placeholders only — no demand, defer.

---

## Open Blockers

- **OAuth client secret rotation:** GCP Console — must do before production MCP write use
- **n8n-plugin build:** hard prerequisite for Sessions 4-5 (cross-platform tracking expansion)
- **Watermelon plan path:** Jerry to provide at v1.22.0 Session 1 start
- **GTM scripts inventory:** Jerry to provide at v1.22.0 Session 1 start
