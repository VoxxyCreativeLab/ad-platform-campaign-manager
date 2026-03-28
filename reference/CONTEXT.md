# Reference — Context

Stable domain knowledge loaded by skills and agents on demand. **Never overwrite** during normal skill execution. Only `google-ads/` is populated; `meta-ads/`, `linkedin-ads/`, `tiktok-ads/` are Phase 3 placeholders.

To add a new platform: populate `platforms/[platform-name]/`, update `reporting/cross-platform-data-model.md`, add or extend skills.

## File Index by Topic

### Google Ads Fundamentals
| File | Content |
|------|---------|
| `platforms/google-ads/campaign-types.md` | Decision tree + all campaign types (Search, PMax, Display, Demand Gen, Video) |
| `platforms/google-ads/account-structure.md` | Hierarchy, naming conventions, structure patterns |
| `platforms/google-ads/match-types.md` | Broad/phrase/exact, strategy by maturity, negatives |
| `platforms/google-ads/quality-score.md` | Components, impact, diagnostics, improvement |
| `platforms/google-ads/ad-extensions.md` | All extension types, specs, strategy |
| `platforms/google-ads/bidding-strategies.md` | Decision tree, smart bidding, manual, awareness |

### Conversion Tracking
| File | Content |
|------|---------|
| `platforms/google-ads/conversion-actions.md` | Types, configuration, primary vs secondary |
| `platforms/google-ads/enhanced-conversions.md` | Setup via GTM, sGTM, API; consent; verification |
| `platforms/google-ads/gaql-reference.md` | GAQL syntax, resources, fields, example queries |

### Tracking Bridge (GTM/sGTM/BQ ↔ Ads)
| File | Content |
|------|---------|
| `tracking-bridge/gtm-to-gads.md` | Client-side conversion tracking architecture |
| `tracking-bridge/sgtm-to-gads.md` | Server-side conversion tracking architecture |
| `tracking-bridge/bq-to-gads.md` | Offline conversions, Customer Match, pipelines |
| `tracking-bridge/data-flow-diagrams.md` | Full-stack architecture diagrams (text-based) |
| `tracking-bridge/profit-based-bidding.md` | sGTM + Firestore margin lookup (gps_soteria) |
| `tracking-bridge/value-based-bidding.md` | Vertex AI pLTV predictions (gps-phoebe) |

### PMax
| File | Content |
|------|---------|
| `platforms/google-ads/pmax/asset-requirements.md` | Text, image, video specs and best practices |
| `platforms/google-ads/pmax/audience-signals.md` | Signal types, strategy, per-asset-group design |
| `platforms/google-ads/pmax/feed-optimization.md` | Merchant Center feed attributes, title optimization |
| `platforms/google-ads/pmax/pmax-metrics.md` | Asset ratings, search insights, optimization cadence |

### Audit
| File | Content |
|------|---------|
| `platforms/google-ads/audit/audit-checklist.md` | 60+ item checklist with scoring guide |
| `platforms/google-ads/audit/negative-keyword-lists.md` | Pre-built lists by category and industry |
| `platforms/google-ads/audit/common-mistakes.md` | Top 25 mistakes with fixes |

### Reporting
| File | Content |
|------|---------|
| `reporting/gaql-query-templates.md` | 15+ ready-to-use GAQL queries |
| `reporting/bigquery-table-schemas.md` | BQ table definitions + views |
| `reporting/dbt-model-patterns.md` | Staging → intermediate → mart architecture |
| `reporting/looker-studio-templates.md` | Dashboard specs, calculated fields, filters |
| `reporting/cross-platform-data-model.md` | Unified schema for multi-platform reporting |
