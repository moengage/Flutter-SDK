---
name: flutter-feature-implementation
description: >
  Orchestrator skill for Flutter MoEngage SDK feature implementation. Runs the Android bridge,
  iOS bridge, and Dart interface steps in sequence. Use this when you want to do all layers in
  one command. If you only need one layer, invoke the focused skills directly:
  - Android Kotlin bridge only: flutter-android-bridge-implementation
  - iOS Swift bridge only: flutter-ios-bridge-implementation
  - Dart platform interface + public API only: flutter-dart-interface-implementation
  Requires: a ticket ID (MOEN-XXXXX), a contract branch in 'mobile-sdk-contracts', and at least
  one platform's plugin-base data. Android inputs (android_bom_version, plugin_base_bom_version,
  android_plugin_base_pr_url) are required for the Android bridge step — if all three are absent,
  the Android step is skipped. iOS inputs (ios_plugin_version, ios_plugin_base_pr_url) are required
  for the iOS bridge step — if both are absent, the iOS step is skipped. At least one of Android
  or iOS must be provided; if neither is present, the skill stops and asks.
  Run AFTER plugin-base-feature-implementation.
  Do NOT use for Dart-only changes or before plugin-base changes exist.
parameters:
  - name: "ticket_id"
    description: "JIRA ticket ID, e.g. 'MOEN-44072'. Extracted from command text if not supplied."
    optional: true
  - name: "feature_description"
    description: "Natural language description of the feature, including framework keyword for iOS routing (analytics/inapps/messaging/core/cards/geofence). E.g. 'JWT authentication parity from core'."
  - name: "contract_branch"
    description: "Branch in 'mobile-sdk-contracts' with the feature contract."
  - name: "android_bom_version"
    description: "Target MoEngage Android BOM version. E.g. '2.2.2'. Optional — if absent (along with plugin_base_bom_version and android_plugin_base_pr_url), Android step is skipped."
    optional: true
  - name: "plugin_base_bom_version"
    description: "Target MoEngage plugin-base BOM version. E.g. '3.0.1'. Optional — required only when Android step runs."
    optional: true
  - name: "android_plugin_base_pr_url"
    description: "URL of the android-plugin-base PR from plugin-base-feature-implementation. Optional — required only when Android step runs."
    optional: true
  - name: "ios_plugin_version"
    description: "Target MoEngagePlugin<featureNameCamel> pod version for iOS. Optional — if not provided, iOS bridge step is skipped."
    optional: true
  - name: "ios_plugin_base_pr_url"
    description: "URL of the iOS-PluginBase PR from plugin-base-feature-implementation. Optional — if not provided, iOS bridge step is skipped."
    optional: true
---

## Overview

This skill is a **three-step orchestrator**. It runs:

1. **`flutter-android-bridge-implementation`** — Android Kotlin bridge (Constants.kt,
   MoEngage<featureNameCamel>Plugin.kt, PlatformMethodCallHandler.kt, optional EventEmitterImpl.kt,
   build.gradle, pubspec.yaml, Dart registration file)
2. **`flutter-ios-bridge-implementation`** — iOS Swift bridge (Plugin.swift, Constants.swift,
   optional EventListener.swift, optional Util.swift, podspec, pubspec.yaml, Dart registration file)
3. **`flutter-dart-interface-implementation`** — Dart platform interface + public API
   (platform interface abstract class, MethodChannel impl, constants, payload mapper, controller,
   models, enums, main public API class)

All three steps operate on the same `feature/<ticketId>-<contractSuffix>` branch in `Flutter-SDK`
and produce a single PR covering all layers.

**Full pipeline:**
```
plugin-base-feature-implementation
    ↓
flutter-android-bridge-implementation   (Step 1 — Android)
flutter-ios-bridge-implementation       (Step 2 — iOS, same branch)
    ↓
flutter-dart-interface-implementation   (Step 3 — Dart, same branch)
```

---

## Pre-flight Check

Before starting, verify at least one platform's data is present:

- **Android data present** = all three of `android_bom_version`, `plugin_base_bom_version`, `android_plugin_base_pr_url` are provided
- **iOS data present** = both `ios_plugin_version` and `ios_plugin_base_pr_url` are provided

| Android data | iOS data | Action |
 --- || --- | --- || --- | --- || --- | --- || --- |
 --- || ✓ present | ✓ present | Run all three steps |
| ✓ present | ✗ absent | Run Android + Dart; skip iOS |
| ✗ absent | ✓ present | Skip Android; run iOS + Dart; create branch in iOS step |
| ✗ absent | ✗ absent | **Stop and ask** — at least one platform's data is required |

---

## Execution

### Step 1 — Run Android bridge

**Pre-check:** If any of `android_bom_version`, `plugin_base_bom_version`, or `android_plugin_base_pr_url` is missing, **skip this step entirely**. Note in the final report that Android was skipped and can be run later with `flutter-android-bridge-implementation`. The branch will be created in Step 2 (iOS) or Step 3 (Dart) instead.

If all three are present, follow every phase of **`flutter-android-bridge-implementation`** in full:
- Phase 0: Clarify inputs / extract ticketId
- Phase 1: Derive all identifiers
- Phase 2: Read contracts and build method table
- Phase 3: Scaffold Android bridge files, update CHANGELOG, and commit
- Phase 4: Push and create PR → capture `androidBridgePrUrl`
- Phase 5: Report (abbreviated — full report comes at the end)

Do **not** ask the user whether to continue — always proceeds to Step 2.

### Step 2 — Run iOS bridge

**Pre-check:** If either `ios_plugin_version` or `ios_plugin_base_pr_url` is missing, **skip this step entirely** — do not ask the user, do not attempt partial iOS work. Note in the final report that iOS was skipped and can be run later with `flutter-ios-bridge-implementation`.

If both are present, follow every phase of **`flutter-ios-bridge-implementation`** in full (which internally delegates version updates to **`flutter-ios-version-update`**):
- Phase 0: Reuse `ticketId` already extracted in Step 1
- Phase 1: Reuse identifiers from Step 1; derive `iosPluginBridge` from `feature_description`
  per the iOS skill's auto-detection rule (analytics/inapps/messaging/core → `MoEngagePluginBridge`;
  otherwise `MoEngagePlugin<featureNameCamel>Bridge`)
- Phase 2: Contracts are already read — reuse the method table from Step 1
- Phase 3: Scaffold iOS bridge files and commit to the same branch
- Phase 4: Push additional commit to the existing PR (do **not** create a second PR); use `ios_plugin_base_pr_url` in the PR comment
- Phase 5: Report (abbreviated)

Do **not** ask the user whether to continue — always proceeds to Step 3.

### Step 3 — Run Dart interface

Follow every phase of **`flutter-dart-interface-implementation`** in full:
- Phase 0: Reuse all identifiers already derived
- Phase 1: Skip re-derivation
- Phase 2: Reuse the method table from Step 1
- Phase 3: Scaffold platform interface package and commit
- Phase 4: Scaffold main public API package and commit
- Phase 5: Verify native package pubspec dependencies
- Phase 6: Push additional commits; update the existing PR body with combined template
- Phase 7: Full report combining all three steps

### Combined PR body

When updating the PR body after Step 3, replace it with:

```
## Summary
- Android: Constants.kt + MoEngage<featureNameCamel>Plugin + PlatformMethodCallHandler (+ EventEmitterImpl if events)  ← omit if Android skipped
- iOS: Plugin.swift + Constants.swift (+ EventListener + Util as needed) + podspec  ← omit if iOS skipped
- Dart: platform interface, MethodChannel impl, models, constants, payload mapper, public API class
- Android BOM: <android_bom_version>, plugin-base BOM: <plugin_base_bom_version>    ← omit if Android skipped
- iOS plugin version: <ios_plugin_version>                                           ← omit if iOS skipped

## Related PRs
- android-plugin-base: <android_plugin_base_pr_url>   ← omit if Android skipped
- ios-plugin-base: <ios_plugin_base_pr_url>           ← omit if iOS skipped

## Contract
Branch: `<contract_branch>` in mobile-sdk-contracts

## Changelogs updated
- `<androidPkgDir>/CHANGELOG.md` — Android bridge
- `<iosPkgDir>/CHANGELOG.md` — iOS bridge                                    ← omit if iOS skipped
- `<mainDir>/CHANGELOG.md` — main package (consumer-facing)

## Methods
| Method | Type | Android | iOS | Dart return |
 --- || --- | --- || --- | --- || --- | --- || --- | --- || --- | --- || --- |
 --- |<combined table rows>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

---

## Final Report

Print:
1. PR URL
2. Combined method table (name, type, Android handler, iOS plugin-bridge method, Dart return type)
3. All `// TODO` items from all three steps
4. Complete list of all files created or modified (Android + iOS + Dart + CHANGELOGs)

---

## Focused Skills (use these when you only need one layer)

| When | Use |
 --- || --- | --- || --- | --- || --- |
 --- || Android bridge only | `flutter-android-bridge-implementation` |
| iOS bridge only | `flutter-ios-bridge-implementation` |
| Dart interface only (bridges already done) | `flutter-dart-interface-implementation` |
| All layers at once | `flutter-feature-implementation` (this skill) |

---

## Error Handling Rules

Apply the error handling rules from all three focused skills. If any step fails, stop and do
not proceed to the next step — report the error and the local branch state so the user
can resume with the focused skill directly.
