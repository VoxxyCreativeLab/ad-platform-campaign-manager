---
title: "Tracking Bridge — Context"
tags:
  - mwp
  - layer-2
  - context
---

# Tracking Bridge — Context

6 files documenting the full data pipeline from tracking infrastructure to Google Ads. This is the plugin's **differentiator** — unique to a tracking specialist's workflow.

Used by: `skills/conversion-tracking/`, `agents/tracking-auditor.md`, and `skills/campaign-setup/` (conversion tracking step).

## Reading Order by Scenario

| Scenario | Start with | Then |
|----------|-----------|------|
| New client-side conversion setup | `gtm-to-gads.md` | `data-flow-diagrams.md` (client-side flow) |
| New server-side conversion setup | `sgtm-to-gads.md` | `data-flow-diagrams.md` (server-side flow) |
| Offline conversion import | `bq-to-gads.md` | `data-flow-diagrams.md` (offline flow) |
| Profit-based bidding | `profit-based-bidding.md` | `sgtm-to-gads.md`, `data-flow-diagrams.md` (VBB flow) |
| ML-predicted value bidding | `value-based-bidding.md` | `sgtm-to-gads.md` |
| Full architecture understanding | `data-flow-diagrams.md` | Then the specific flow file |
| Troubleshooting | Start with the layer where the issue is | Then adjacent layers |

## Open-Source References

These files draw knowledge from:
- `google-marketing-solutions/gps_soteria` — profit-based bidding architecture
- `google-marketing-solutions/gps-phoebe` — ML value-based bidding
- `google/megalista` — BQ → Google Ads data pipeline
- `stape-io/gads-offline-conversion-tag` — sGTM offline conversion tag
