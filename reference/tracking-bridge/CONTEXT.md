---
title: "Tracking Bridge — Context"
tags:
  - mwp
  - layer-2
  - context
---

# Tracking Bridge — Context

8 files documenting the full data pipeline from tracking infrastructure to Google Ads. This is the plugin's **differentiator** — unique to a tracking specialist's workflow.

Used by: `skills/conversion-tracking/`, `agents/tracking-auditor.md`, and `skills/campaign-setup/` (conversion tracking step).

> [!info] Companion resource
> `reference/platforms/meta-ads/capi-server-events.md` — Meta CAPI payload structure, `fbc` construction, hashing rules, and event deduplication. Referenced by `iclosed-attribution.md` (WF3) and `n8n-pipeline-patterns.md`.

## Reading Order by Scenario

| Scenario | Start with | Then |
|----------|-----------|------|
| New client-side conversion setup | `gtm-to-gads.md` | `data-flow-diagrams.md` (client-side flow) |
| New server-side conversion setup | `sgtm-to-gads.md` | `data-flow-diagrams.md` (server-side flow) |
| Offline conversion import | `bq-to-gads.md` | `data-flow-diagrams.md` (offline flow) |
| Profit-based bidding | `profit-based-bidding.md` | `sgtm-to-gads.md`, `data-flow-diagrams.md` (VBB flow) |
| ML-predicted value bidding | `value-based-bidding.md` | `sgtm-to-gads.md` |
| Full architecture understanding | `data-flow-diagrams.md` | Then the specific flow file |
| iClosed scheduling attribution | `iclosed-attribution.md` | `platforms/meta-ads/capi-server-events.md` (for WF3 CAPI payload) |
| n8n webhook + BQ pipeline setup | `n8n-pipeline-patterns.md` | `iclosed-attribution.md` (tool-specific flows), reporting layer |
| Troubleshooting | Start with the layer where the issue is | Then adjacent layers |

## File Index

| File | Scope |
|------|-------|
| `gtm-to-gads.md` | Client-side GTM → Google Ads conversion pipeline |
| `sgtm-to-gads.md` | Server-side GTM → Google Ads pipeline |
| `bq-to-gads.md` | BigQuery offline conversion import |
| `data-flow-diagrams.md` | Architecture diagrams for all tracking flows |
| `profit-based-bidding.md` | Profit-based bidding via sGTM |
| `value-based-bidding.md` | ML-predicted value-based bidding |
| `iclosed-attribution.md` | iClosed GTM integration (Scenario A), 5 confirmed dataLayer events, 12 webhook events, fbclid passthrough, WF1–WF4 n8n pipeline flows, attribution gap workaround, consent gating, platform defaults to override |
| `n8n-pipeline-patterns.md` | Generic n8n tracking bridge patterns — webhook security, BigQuery streaming conventions, node reference, client account pattern |

## Open-Source References

These files draw knowledge from:
- `google-marketing-solutions/gps_soteria` — profit-based bidding architecture
- `google-marketing-solutions/gps-phoebe` — ML value-based bidding
- `google/megalista` — BQ → Google Ads data pipeline
- `stape-io/gads-offline-conversion-tag` — sGTM offline conversion tag
