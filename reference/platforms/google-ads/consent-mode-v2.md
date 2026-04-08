---
title: Consent Mode v2
date: 2026-04-08
tags:
  - reference
  - google-ads
  - consent-mode
  - tracking
  - privacy
  - gtm
---

# Consent Mode v2

## Overview

Consent Mode is a Google framework that adjusts how Google tags behave based on the consent status of the user. When a user denies consent, tags do not fire cookies or collect personal data — but in Advanced mode, they do send cookieless, anonymous pings. Google uses those pings to model the conversions that would have been measured had consent been granted.

**Why it exists:** EU privacy law (GDPR) and the EEA enforcement framework require user consent before setting advertising cookies or collecting personal data. Without a compliant consent layer, Google Ads measurement in the EEA is illegal and also incomplete. Google made Consent Mode v2 mandatory for measurement in EEA from March 2024.

**Why it matters for Smart Bidding:** Smart Bidding runs on conversion signals. In EEA markets, a significant share of users deny consent. Without Consent Mode v2 (Advanced), those conversions are invisible to Smart Bidding — and it degrades toward random guessing. With Advanced mode, Google fills the gap with behavioral modeling.

---

## v1 vs v2 Comparison

| | Consent Mode v1 | Consent Mode v2 |
|---|---|---|
| Consent signals | `ad_storage`, `analytics_storage` | + `ad_user_data`, `ad_personalization` |
| Cookieless pings | No | Yes (Advanced mode only) |
| EEA mandatory | No | Yes (March 2024) |
| Behavioral modeling | No | Yes (Advanced mode only) |

The two new signals in v2 (`ad_user_data`, `ad_personalization`) give Google finer-grained control over how user data is used — separate from whether cookies are stored. This distinction matters because a user might consent to analytics cookies but deny audience creation.

---

## The Four Consent Signals

### `ad_storage`

Controls whether Google Ads cookies (e.g., `_gcl_au`, conversion linker) can be written and read in the user's browser.

- **Granted:** Full cookie-based tracking. Click IDs (GCLIDs) persist. Remarketing audiences built.
- **Denied:** No cookies set. Cookieless ping sent instead (Advanced mode). No remarketing. No GCLID persistence.
- **Downstream impact:** Without this, conversion attribution relies entirely on modeling. Remarketing lists stop growing for that user.

### `analytics_storage`

Controls whether GA4 measurement cookies (e.g., `_ga`) can be written and read.

- **Granted:** Sessions tracked normally in GA4.
- **Denied:** Session not tracked in GA4. Cookieless ping sent (Advanced mode).
- **Downstream impact:** GA4 audience building degrades. Cross-session analysis breaks. GA4 → Google Ads audience imports lose coverage.

### `ad_user_data`

Controls whether user-provided data (email, phone, address) can be sent to Google for audience matching and conversion measurement. This is the signal that gates Enhanced Conversions.

- **Granted:** Hashed first-party data sent to Google. Enhanced Conversions active. Audience matching via Customer Match works.
- **Denied:** No hashed data sent. Enhanced Conversions effectively disabled for that user. Customer Match upload still works for offline flows, but real-time web matching is blocked.
- **Downstream impact:** If denied by most users, Enhanced Conversions and Customer Match audience quality drop significantly.

### `ad_personalization`

Controls whether the user's data can be used for personalized advertising (remarketing, Similar Audiences, custom audiences).

- **Granted:** Remarketing pixels can add users to lists. Personalized ad targeting enabled.
- **Denied:** User excluded from all remarketing and personalized ad targeting even if `ad_storage` is granted.
- **Downstream impact:** Remarketing campaigns lose reach in EEA. RLSA (Remarketing Lists for Search Ads) and PMax audience signals degrade.

---

## Advanced vs Basic Mode

### Basic Mode

The entire Google tag is blocked from firing until after the user makes a consent decision. No data of any kind is sent before consent. If the user denies, nothing is sent.

- Simpler to implement (just block tags until consent granted)
- No cookieless pings — denied users are completely invisible to Google
- No behavioral modeling possible
- Compliant, but leaves measurement gaps unfilled

### Advanced Mode

The Google tag fires immediately (before the CMP renders) in a consent-denied state. It sends cookieless, non-identifying pings. If the user later grants consent, the tag upgrades to full measurement.

- Requires setting default consent state BEFORE the consent dialog fires
- Cookieless pings enable behavioral modeling
- Typically recovers 5–30% of "lost" conversions through Google's modeling
- Required for behavioral modeling to activate

> [!tip] Always implement Advanced mode
> Basic mode abandons all behavioral modeling. Advanced mode requires that Consent Mode is initialized with default-denied state BEFORE the CMP fires — meaning the GTM Consent Initialization trigger must load Consent Mode defaults before any other tags. If you initialize Consent Mode after the CMP fires, you lose the early pings and modeling cannot occur.

---

## Behavioral Modeling

When Advanced mode is active and a user denies consent, Google receives a cookieless ping. Across many such pings (aggregated, never individual), Google models what conversions likely occurred among that denied population, based on the behavior patterns of users who did consent.

**How it works in practice:**
- Google groups anonymous pings by observed patterns (time on site, page depth, device type, etc.)
- Modeling uses consenting users as a reference population
- The modeled conversion estimate is added to the reported total
- This is purely aggregated — no individual user is identified

**What to expect:**
- 5–30% of total conversions are typically modeled (range depends on consent rate, traffic volume, and conversion type)
- Lower consent rates = higher proportion of modeled conversions
- Modeled conversions visible in Google Ads under Columns → "Modeled Conversions"
- Smart Bidding uses both observed and modeled conversions as signal — but modeled conversions carry less certainty, so very low consent rates still degrade bidding quality

> [!warning] MCP cannot see modeled vs observed split
> The modeled/observed breakdown is NOT accessible via the Google Ads API. The MCP cannot query this. Check in the Google Ads UI: Campaigns → Columns → Conversions → Modeled Conversions. See [[../../../mcp/mcp-capabilities|mcp-capabilities]] Section 4.

---

## CMP Requirements

A Consent Management Platform (CMP) is the user-facing consent dialog that collects and records consent decisions. In the EEA, the CMP must meet the following requirements:

- **TCF v2.2 compliance:** IAB Europe's Transparency & Consent Framework version 2.2 is required for EEA compliance. The CMP must be registered with IAB Europe and must support TCF v2.2 signal encoding.
- **Google-certified CMP:** Google maintains a list of Google-certified CMPs. Only certified CMPs correctly pass consent signals to Google tags in a way Google recognizes for EEA compliance. Using a non-certified CMP may result in Google treating measurement as non-compliant even if the CMP is otherwise TCF v2.2 compliant.
- **Signal forwarding:** The CMP must pass consent decisions to GTM via `gtag('consent', 'update', {...})` or via the GTM Consent API. Without this, GTM never receives the update when a user grants consent.

**Common Google-certified CMPs:**

| Platform | Notes |
|---|---|
| Cookiebot (Usercentrics) | Popular in NL/BE; strong GTM integration |
| Didomi | Enterprise-grade; good sGTM support |
| OneTrust | Large enterprise; complex but feature-rich |
| Quantcast Choice | Free tier available |
| Usercentrics | Same group as Cookiebot; widely used in DE/NL |

> [!info] For NL clients
> Dutch regulatory guidance (AP — Autoriteit Persoonsgegevens) is strict on consent validity. Ensure the CMP uses no dark patterns (pre-ticked boxes, obscured reject buttons). This affects consent rates and therefore Smart Bidding quality.

---

## EEA Enforcement Timeline

| Date | Event |
|---|---|
| Early 2024 | Google announced Consent Mode v2 requirement for EEA |
| March 2024 | Deadline: Consent Mode v2 mandatory for measurement in EEA. Accounts without it stop reporting EEA conversions. |
| Ongoing | Remarketing audience sizes reduce for non-compliant accounts. Smart Bidding signal quality degrades for EU traffic. |

**What "mandatory" means in practice:** Google will not report conversions for EEA users in accounts that do not have Consent Mode v2 implemented. This is not a soft warning — conversion columns simply stop counting EEA traffic.

**NL/SE-specific impact:** Jerry's client base is primarily Dutch (and some Swedish). The Netherlands and Sweden are both EEA members with active data protection authorities. Consent rates in NL tend to be lower than EU average (Dutch users are privacy-aware). This means behavioral modeling plays an above-average role, and Advanced mode is especially important.

---

## Impact on Smart Bidding

Consent Mode v2 directly affects the quality of conversion signals available to Smart Bidding algorithms.

**Signal chain:**

```
Observed conversions (full consent)
  + Modeled conversions (Advanced mode, denied consent)
  = Total conversions reported to Smart Bidding
```

**Key thresholds to monitor:**

- **Consent rate > 60%:** Smart Bidding has enough observed signal. Modeling supplements. Expect normal behavior.
- **Consent rate 40–60%:** Increased reliance on modeling. Smart Bidding may need wider target windows to hit goals. Watch for increased CPA volatility.
- **Consent rate < 40%:** Significant Smart Bidding instability. Targets based on observed conversions alone will be unreachable. Expect longer learning phases and erratic bid behavior.

**Practical guidance:**
- Set tCPA/tROAS targets based on TOTAL conversions (observed + modeled), not just observed. If you base targets on observed-only, you're bidding against a floor that doesn't reflect real business outcomes.
- Smart Bidding learning phase extends when consent rates are low — see [[learning-phase]].
- During the learning phase after a Consent Mode v2 migration, expect performance fluctuation. This is normal — Smart Bidding is recalibrating its model with the new signal mix.

---

## Implementation via GTM / sGTM

### GTM (Web Container)

1. **Set default consent state** in a tag that fires on the Consent Initialization trigger (fires before all other tags):
   ```javascript
   gtag('consent', 'default', {
     'ad_storage': 'denied',
     'analytics_storage': 'denied',
     'ad_user_data': 'denied',
     'ad_personalization': 'denied',
     'wait_for_update': 500
   });
   ```
   - Use Google's official Consent Mode template in GTM (Community Templates → Consent Mode) or the CMP's native GTM tag
   - `wait_for_update` (milliseconds) tells the tag to hold and wait for the CMP to fire its update before proceeding

2. **CMP fires its update** via `gtag('consent', 'update', {...})` with the user's actual consent decision. This upgrades the signals from denied to granted (or leaves them denied).

3. **Trigger order matters:** Consent Initialization trigger fires first → default denied → CMP fires → update with actual decision → all other tags fire with correct consent state.

> [!warning] Trigger order is load-bearing
> If you set Consent Mode defaults in a tag that fires on DOM Ready or Page View rather than Consent Initialization, the defaults fire after the first measurement tags already attempted to fire. You lose the early pings that Advanced mode depends on.

### sGTM (Server Container)

Server-side containers do NOT automatically receive consent signals from the client. The sGTM container runs on your server — it has no visibility into what the user's browser consented to unless you explicitly forward that information.

**Two approaches:**

**Approach A — Forward via dataLayer:**
Include consent state in every event pushed to the dataLayer that gets forwarded to sGTM. Add consent signal fields to your event data, and map them in the sGTM client/tag configuration.
```javascript
dataLayer.push({
  'event': 'purchase',
  'consent_ad_storage': 'granted',
  'consent_ad_user_data': 'granted',
  // ... other event fields
});
```

**Approach B — Consent Mode API in sGTM:**
Use the `setConsent` and `getConsent` APIs available in sGTM (available in server-side tag templates). Requires a custom sGTM tag that sets consent state based on forwarded signals or a consent cookie you control.

**Recommended for Jerry's stack:** Approach A is simpler and more auditable. Add consent signals as standard fields in the data layer schema, forward them via GTM's event data, and map them in sGTM tags. Document the fields in your BigQuery schema so consent state is queryable downstream.

### Enhanced Conversions Interaction

`ad_user_data` must be GRANTED for Enhanced Conversions to send hashed first-party data. If `ad_user_data` is denied, the Enhanced Conversion tag will fire but strip the hashed fields before sending. Effectively, Enhanced Conversions is silently disabled for any user who denies `ad_user_data`. Monitor this via Google Ads Diagnostics → Enhanced Conversions.

See [[enhanced-conversions]] for full Enhanced Conversions setup.

---

## Verification

After implementing Consent Mode v2, verify each layer of the stack:

1. **Google Tag Assistant (Chrome extension)**
   - Load the page and observe consent state before the CMP fires
   - Confirm all four signals are in `denied` state on page load (Advanced mode)
   - Accept consent in the CMP dialog
   - Confirm Tag Assistant shows signals updating to `granted`

2. **GTM Preview mode — Consent Status tab**
   - Open GTM Preview → click into any event → Consent tab
   - Shows current state of all four signals at the time each tag fired
   - Verify tags that should not fire under denied state are blocked

3. **Google Ads Diagnostics**
   - Google Ads UI → Tools → Diagnostics → Consent Mode
   - Shows account-level Consent Mode status: Active / Inactive / Partial
   - Flags missing signals or misconfigured implementations

4. **DevTools — Network tab**
   - With consent denied: confirm `_gcl_au` cookie is absent (Basic mode) or that cookieless pings are sent to `google.com/pagead/` (Advanced mode — look for requests with no cookie headers but with consent state parameters)
   - With consent granted: confirm `_gcl_au` cookie is set

5. **Google Ads conversion report — Modeling column**
   - In Google Ads: Campaigns → Columns → Conversions → add "Modeled Conversions"
   - If Advanced mode is working, this column will show a non-zero value
   - A zero in this column means either no modeling is occurring (too few denied pings) or Advanced mode is not actually active

---

## Common Mistakes

| Mistake | Impact | Fix |
|---|---|---|
| Using Basic mode instead of Advanced | No behavioral modeling; 5–30% conversion loss invisible to Smart Bidding | Switch to Advanced; set Consent Mode defaults before CMP fires using Consent Initialization trigger |
| Not setting default consent state before CMP fires | Consent Mode initializes too late; early pings lost; modeling cannot occur | Set defaults in a tag on Consent Initialization trigger, not DOM Ready or Page View |
| Not testing the denial flow | Tags may not actually suppress cookies/data when consent is denied | Test with a fresh browser session that denies all consent; verify in DevTools and Tag Assistant |
| Missing `ad_user_data` signal | Enhanced Conversions silently disabled for denied users; attribution gap grows | Explicitly map `ad_user_data` in CMP signal configuration; verify in Google Ads Diagnostics |
| Using a CMP without TCF v2.2 | Not EEA-compliant; Google may not recognize consent signals | Use a Google-certified CMP with TCF v2.2 support |
| Not forwarding consent state to sGTM | Server-side tags fire regardless of user consent; GDPR risk | Implement consent signal forwarding from GTM to sGTM (Approach A or B — see above) |
| Setting targets based on observed conversions only | Targets unachievable after Consent Mode migration; Smart Bidding starves | Recalibrate targets using total conversions (observed + modeled) after 2–4 weeks of data |

---

## MCP Boundary

> [!warning] Consent state not visible in Google Ads API
> The Google Ads API (and therefore MCP) cannot see:
> - Which consent signals are set for any user or session
> - Whether Consent Mode v2 is correctly implemented on a website
> - Consent rate (percentage of users granting vs denying each signal)
> - The modeled vs observed conversion breakdown
>
> The only API-visible effect of Consent Mode problems is performance degradation — lower reported conversions, higher CPA, erratic Smart Bidding behavior. These are lagging indicators. For direct verification, use Google Tag Assistant, GTM Preview mode, or Google Ads Diagnostics (UI only).
>
> Reference: [[../../../mcp/mcp-capabilities|mcp-capabilities]] Section 4.

---

## Cross-References

- [[learning-phase]] — Low consent rates extend Smart Bidding learning phase; see thresholds
- [[enhanced-conversions]] — `ad_user_data` must be granted for hashed data to be sent
- [[conversion-actions]] — Modeled conversions affect reported attribution totals and Smart Bidding signal
- [[../../../mcp/mcp-capabilities|mcp-capabilities]] — What MCP cannot see (Section 4)
