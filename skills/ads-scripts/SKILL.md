---
name: ads-scripts
description: Google Ads Scripts library — browse, customize, and generate automation scripts for bidding, reporting, and cleanup. Use for Google Ads automation.
argument-hint: "[browse|script-description]"
disable-model-invocation: false
---

# Google Ads Scripts

You are helping the user browse, customize, or generate Google Ads Scripts (JavaScript that runs inside Google Ads for automation).

## Reference Material

- **Scripts catalog:** [[../../reference/scripts/catalog|catalog.md]]
- **Scripts API reference:** [[../../reference/platforms/google-ads/ads-scripts-api|ads-scripts-api.md]]
- **Account profiles and archetypes:** [[../../reference/platforms/google-ads/strategy/account-profiles|account-profiles.md]]

## Establish Account Profile

Before recommending scripts, understand the account's context. If the user has already run `/ad-platform-campaign-manager:account-strategy`, ask them to share the profile summary to skip these questions.

Ask:
1. **"What's the monthly Google Ads budget?"** → determines script complexity worth the overhead
2. **"How many conversions per month?"** → determines account maturity
3. **"What vertical is this?"** → determines which scripts are most valuable

## Script Recommendations by Budget Tier

Scripts add maintenance overhead. Match script investment to budget tier:

| Budget Tier | Recommendation | Scripts |
|-------------|---------------|---------|
| **Micro** (< EUR 1K/mo) | **Skip scripts** — manual management is sufficient and scripts add maintenance overhead | None |
| **Small** (EUR 1-5K/mo) | **Critical only** — 2 scripts max for basic monitoring | Conversion drop alert, broken URL checker |
| **Medium** (EUR 5-25K/mo) | **Standard suite** — automated monitoring + reporting | Budget pacing, QS monitor, search term mining, weekly performance report |
| **Large** (EUR 25K+/mo) | **Full suite** — monitoring + automation + custom reporting | All standard + bidding automation, budget reallocation, day-parting, PMax scripts |

## Scripts by Account Maturity

Even within the right budget tier, match script complexity to account maturity:

| Maturity | Recommended Scripts | Why |
|----------|-------------------|-----|
| **Cold start** (0-3 mo) | None | Not enough data for automation. Manual review teaches you the account. |
| **Early data** (3-6 mo) | Broken URL checker, conversion drop alert | Canary scripts — catch problems before they waste budget |
| **Established** (6-18 mo) | + Budget pacing alert, QS monitor, search term mining, weekly performance report | Enough data for meaningful automated analysis |
| **Mature** (18+ mo) | + Automated bid rules, budget reallocation, day-parting adjustments, PMax scripts | Rich data supports automated decision-making |

## Vertical-Specific Script Recommendations

Prioritize scripts that address each vertical's biggest risks:

**E-commerce:**
- PMax search terms extractor (find what PMax is bidding on)
- PMax asset performance tracker (identify low-rated assets)
- Feed monitoring (detect disapprovals, stock-outs)
- Category label automation (auto-tag products by margin tier)

**Lead Gen:**
- Conversion drop alert (critical — a day without leads is a day without pipeline)
- Search term mining (catch low-quality queries early)
- Landing page performance checker (monitor page speed, 404s)

**B2B SaaS:**
- Conversion drop alert (fewer conversions makes each one important)
- Low-QS pauser (protect expensive high-intent keywords from QS decay)
- Weekly performance report with CPA trending

**Local Services:**
- Budget pacing alert (fixed monthly budgets must last the whole month)
- Broken URL checker (local landing pages change frequently)
- Call extension performance tracker

## Common Tasks

### Browse Available Scripts
When the user wants to see what's available, present the catalog organized by category:
- Monitoring & Alerts (budget pacing, conversion drops, broken URLs)
- Bidding & Budget (day parting, reallocation, automated rules)
- Reporting (weekly reports to Sheets, search term mining)
- Cleanup & Maintenance (negative keyword conflicts, duplicates, low QS)
- PMax Specific (search terms, asset performance, category labels)

### Generate a Custom Script
When the user describes an automation need:
1. Understand the exact requirement
2. Write a complete, working Google Ads Script
3. Use the AdsApp API correctly (reference the API reference)
4. Include configuration section at the top (CONFIG object)
5. Add inline comments explaining the logic
6. Include error handling and logging
7. Recommend a scheduling frequency

### Customize an Existing Script
When the user wants to modify a script from the catalog:
1. Reference the original script source
2. Explain what the script does
3. Make the requested modifications
4. Test for common issues (selector limits, date ranges)

## Script Template

All generated scripts should follow this structure:

```javascript
/**
 * [Script Name]
 * [Description of what this script does]
 *
 * Schedule: [Recommended frequency]
 * Author: Generated via ad-platform-campaign-manager plugin
 */

// ============ CONFIGURATION ============
var CONFIG = {
  // User-configurable values
  SPREADSHEET_URL: '',     // Optional: Google Sheets URL for output
  EMAIL: '',               // Optional: Email for alerts
  DATE_RANGE: 'LAST_7_DAYS',
  // Script-specific settings
};

// ============ MAIN ============
function main() {
  // Script logic here

  Logger.log('Script completed successfully');
}
```

## Best Practices to Follow

1. **Always include a CONFIG section** — makes scripts easy to customize
2. **Use Logger.log** for debugging output
3. **Handle empty results** — iterators may return zero results
4. **Respect rate limits** — use `.withLimit()` for large accounts
5. **Test in preview mode first** — run without changes, check Logger output
6. **Use descriptive variable names** — scripts should be self-documenting
7. **Include error handling** — wrap risky operations appropriately

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| Script runs but does nothing | Selector returns zero results — campaign/ad group names, date range, or status filters don't match any entities | Log the iterator count before the loop: `Logger.log('Found: ' + iterator.totalNumEntities())` and widen filters |
| `exceeded maximum execution time` | Script hits the 30-minute limit (single account) or 60-minute limit (MCC) | Add `.withLimit()` to selectors, process in batches, or split into multiple scripts |
| `Cannot read property of undefined` | Accessing a metric or field that doesn't exist for the entity type | Check the AdsApp API reference for available methods on that entity |
| Sheets output is empty | `SPREADSHEET_URL` is blank or the script lacks edit permission on the Sheet | Verify the URL is set in CONFIG and the script's Google account has editor access |
| Script works in Preview but fails when scheduled | Preview runs as the signed-in user; scheduled runs use the script owner's permissions | Ensure the script owner has access to all referenced Sheets, emails, and account entities |

## What to Do Next

Based on the scripts work completed, recommend the next skill:

| Situation | Next Skill |
|-----------|-----------|
| Scripts deployed, need automated reporting pipeline | `/ad-platform-campaign-manager:reporting-pipeline` |
| Budget issues found, need reallocation | `/ad-platform-campaign-manager:budget-optimizer` |
| Need live data check to verify script impact | `/ad-platform-campaign-manager:live-report` |
| No strategy profile established yet | `/ad-platform-campaign-manager:account-strategy` |
| Migrate ad-hoc scripts to maintainable n8n automation workflows | `/n8n-workflow-builder-plugin:workflow-architect` |

## Open-Source Script Resources

For reference implementations, point users to:
- `Brainlabs-Digital/Google-Ads-Scripts` (145 stars) — agency-quality scripts
- `Czarto/Adwords-Scripts` (50 stars) — bidding automation
- `agencysavvy/pmax` (276 stars) — PMax scripts
- `pamnard/Google-Ads-Scripts` (23 stars) — general collection

---

## Report Output

When running inside an MWP client project (detected by `stages/` or `reports/` directory):

- **Stage:** `03-build`
- **Output file:** `reports/{YYYY-MM-DD}/03-build/ads-scripts.md`
- **SUMMARY.md section:** Campaign Build
- **Write sequence:** Follow the 6-step write sequence in [[conventions#Report File-Writing Convention]]
- **Completeness:** Follow the [[conventions#Output Completeness Convention]]. No truncation, no shortcuts.
- **Re-run behavior:** If this skill runs twice on the same day, overwrite the existing report file. Update (not duplicate) CONTEXT.md row and SUMMARY.md paragraph.
- **Fallback:** If not in an MWP project, output to conversation (legacy behavior).
