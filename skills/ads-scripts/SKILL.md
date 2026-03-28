---
name: ads-scripts
description: Google Ads Scripts library — browse, customize, and generate automation scripts for bidding, reporting, and cleanup. Use for Google Ads automation.
disable-model-invocation: false
allowed-tools: "Read, Grep, Glob"
---

# Google Ads Scripts

You are helping the user browse, customize, or generate Google Ads Scripts (JavaScript that runs inside Google Ads for automation).

## Reference Material

- **Scripts catalog:** [catalog.md](../../reference/scripts/catalog.md)
- **Scripts API reference:** [ads-scripts-api.md](../../reference/platforms/google-ads/ads-scripts-api.md)

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

## Open-Source Script Resources

For reference implementations, point users to:
- `Brainlabs-Digital/Google-Ads-Scripts` (145 stars) — agency-quality scripts
- `Czarto/Adwords-Scripts` (50 stars) — bidding automation
- `agencysavvy/pmax` (276 stars) — PMax scripts
- `pamnard/Google-Ads-Scripts` (23 stars) — general collection
