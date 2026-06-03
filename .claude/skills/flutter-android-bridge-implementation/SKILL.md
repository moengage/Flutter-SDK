---
name: flutter-android-bridge-implementation
description: >
  Implements the Android Kotlin bridge layer for a Flutter MoEngage SDK feature.
  This is Step 1 of the Flutter feature pipeline — run AFTER plugin-base-feature-implementation
  has completed. Produces Constants.kt, MoEngage<featureNameCamel>Plugin.kt,
  PlatformMethodCallHandler.kt, optional EventEmitterImpl.kt, and build.gradle
  for a new moengage_<featureName>_android package under packages/moengage_<featureName>/.
  Follows the moengage_cards_android module standard exactly.
  On completion, asks the user whether to also run flutter-ios-bridge-implementation (Step 2).
  Do NOT use for iOS-only features or Dart-only changes.
parameters:
  - name: "ticket_id"
    description: "JIRA ticket ID, e.g. 'MOEN-44072'. Extracted from command text if not supplied."
    optional: true
  - name: "feature_description"
    description: "Natural language description of the feature. E.g. 'JWT authentication parity'."
  - name: "contract_branch"
    description: "Branch in 'mobile-sdk-contracts' with the feature contract. E.g. 'MOEN-44072_jwt_contract'."
  - name: "android_bom_version"
    description: "Target MoEngage Android BOM version. E.g. '2.2.2'."
  - name: "plugin_base_bom_version"
    description: "Target MoEngage plugin-base BOM version. E.g. '3.0.1'."
  - name: "android_plugin_base_pr_url"
    description: "URL of the android-plugin-base PR from plugin-base-feature-implementation."
---

## Overview

Implements the **Android Kotlin bridge** inside the Flutter SDK repo (`Flutter-SDK`) for a
MoEngage feature whose plugin-base module already exists in `../android-plugin-base`.

**Prerequisite chain:**
1. `plugin-base-feature-implementation` — creates/extends the Android plugin-base module ✅
2. **`flutter-android-bridge-implementation`** ← you are here
3. `flutter-ios-bridge-implementation` — iOS Swift bridge (same branch)

**Architecture standard:** Follow the **moengage_cards_android** package exactly.
Path: `packages/moengage_cards/moengage_cards_android/`

**Example files:** Templates are in `examples/` adjacent to this SKILL.md. Read each
template before generating the corresponding file.

---

## Example Files Index

```
examples/
  Constants.kt              ← com.moengage.flutter.<featureName>/Constants.kt
  Plugin.kt                 ← MoEngage<featureNameCamel>Plugin.kt
  PlatformMethodCallHandler.kt  ← PlatformMethodCallHandler.kt
  EventEmitterImpl.kt       ← EventEmitterImpl.kt (only if nativeToFlutter events exist)
  build.gradle              ← android/build.gradle
  pubspec.yaml              ← pubspec.yaml for moengage_<featureName>_android
  dart_plugin.dart          ← lib/moengage_<featureName>_android.dart
```

---

## Phase 0 — Clarify Inputs

### 0.1 Extract ticket ID
Scan the user's full command for `MOEN-\d+` → **`ticketId`**.
If not found in the command or parameters, ask before proceeding.

---

## Phase 1 — Parse Inputs & Derive All Identifiers

### 1.1 Extract from `contract_branch`
Strip everything up to and including the first `/` or `_MOEN-XXXXX_` prefix:
- `feature/experience_contracts` → **`contractSuffix`** = `experience_contracts`
- `MOEN-44072_jwt_contract` → **`contractSuffix`** = `jwt_contract`

### 1.2 Identifiers table

| Identifier | Example | Rule |
 --- || --- | --- || --- | --- || --- | --- || --- |
 --- || `ticketId` | `MOEN-44072` | `MOEN-\d+` from raw command or parameter |
| `contractSuffix` | `jwt_contract` | branch name after first `/` or `_MOEN-XXXXX_` |
| `featureName` | `jwt` | lowercase slug from feature_description |
| `featureNameCamel` | `Jwt` | PascalCase of featureName |
| `featureNameUpper` | `JWT` | UPPER_SNAKE of featureName |
| `contractDir` | `authentication` | subdirectory found in contracts `json/` after checkout |
| `androidPackage` | `com.moengage.flutter.jwt` | `com.moengage.flutter.<featureName>` |
| `androidModuleName` | `plugin-base-jwt` | `plugin-base-<featureName>` (verify from plugin-base PR) |
| `packageDir` | `packages/moengage_flutter` | see rule below |
| `androidPkgDir` | `packages/moengage_flutter/moengage_flutter_android` | `<packageDir>/moengage_<featureName>_android` |
| `channelName` | `com.moengage/jwt` | `com.moengage/<featureName>` |
| `branchName` | `feature/MOEN-44072-jwt_contract` | `feature/<ticketId>-<contractSuffix>` |

### 1.3 Resolve `packageDir`

Scan `feature_description` for a framework keyword and map to the existing package directory:

| Keyword in `feature_description` | `packageDir` |
 --- || --- | --- || --- | --- || --- |
 --- || `core`, `analytics`, `inapps`, or `messaging` | `packages/moengage_flutter` |
| `cards` | `packages/moengage_cards` |
| `geofence` | `packages/moengage_geofence` |
| `inbox` | `packages/moengage_inbox` |
| `personalize` | `packages/moengage_personalize` |
| none of the above | ask the user which package to add the feature to |

Examples:
- `"setDeviceAttribute from analytics"` → `packages/moengage_flutter`
- `"cardShown from cards"` → `packages/moengage_cards`
- `"start geofence monitoring"` → `packages/moengage_geofence`

---

## Phase 2 — Read Contracts

```bash
cd ../mobile-sdk-contracts
git fetch
git stash
git checkout <contract_branch>
```

1. List `json/hybridToNative/` to identify `contractDir`
   - If no matching directory → list available dirs and ask the user
2. For each `.json` in `json/hybridToNative/<contractDir>/`:
   - Filename (without `.json`) = **method name** (camelCase)
   - File content = **input payload shape**
3. For each `.json` in `json/nativeToHybrid/<contractDir>/`:
   - File content = **event/response payload shape**
4. Read all `.proto` files in `protos/<contractDir>/` for field names and types

### Method classification

| Condition | Type | Android pattern | Files needed |
 --- || --- | --- || --- | --- || --- | --- || --- | --- || --- |
 --- || `hybridToNative` only | **fire-and-forget** | `call.arguments.toString()` → helper, no result | Plugin + Handler only |
| both `hybridToNative` + `nativeToHybrid` | **auto-detect from plugin-base** | depends | see below |
| `nativeToHybrid` only | **event** | `EventEmitterImpl` → `methodChannel?.invokeMethod(name, payload)` | Plugin + Handler + EventEmitterImpl |

**When both `hybridToNative` and `nativeToHybrid` exist**, auto-detect the type by reading the plugin-base branch:

```bash
gh pr view <android_plugin_base_pr_url> --json headRefName
# then read the changed Kotlin files on that branch
```

Look for the method in the plugin-base helper class:

| Plugin-base pattern found | Type | Android pattern | Files needed |
 --- || --- | --- || --- | --- || --- | --- || --- | --- || --- |
 --- || Method returns a value / calls `result.success(...)` directly | **result** | `GlobalResources.executor` → `result.success(...)` | Plugin + Handler |
| Method registers/calls an `EventEmitter` interface | **event** | direct call + `EventEmitterImpl` → `methodChannel?.invokeMethod(name, payload)` | Plugin + Handler + EventEmitterImpl |

If the plugin-base branch is unreadable or the pattern is still ambiguous after reading it, **then** ask the user.

**Build a complete method table before writing any code.**

---

## Phase 3 — Android Bridge Implementation

### 3.1 Create branch
```bash
cd Flutter-SDK
git fetch
git checkout -b feature/<ticketId>-<contractSuffix>
```

### 3.2 Create package directory structure
```bash
mkdir -p <androidPkgDir>/android/src/main/kotlin/<androidPackage/slash-form>
mkdir -p <androidPkgDir>/lib
```

### 3.3 build.gradle
→ See `examples/build.gradle`
Copy `packages/moengage_cards/moengage_cards_android/android/build.gradle`, then update:
- `group` → `'com.moengage.flutter_<featureName>'`
- `namespace` → `"<androidPackage>"`
- `moengageNativeBomVersion` → `<android_bom_version>`
- `moengagePluginBaseBomVersion` → `<plugin_base_bom_version>`
- `implementation("com.moengage:plugin-base-cards")` → `implementation("com.moengage:<androidModuleName>")`
- `api("com.moengage:cards-core")` → `api("com.moengage:<featureName>-core")` *(ask user if unknown)*

### 3.4 Constants.kt
→ See `examples/Constants.kt`
Generate at: `<androidPkgDir>/android/src/main/kotlin/<androidPackage>/Constants.kt`

Rules:
- `CHANNEL_NAME = "com.moengage/<featureName>"`
- `MODULE_TAG = "MoEFlutter<featureNameCamel>_"`
- One `const val METHOD_*` per hybridToNative method (camelCase, matching contract filename exactly)
- One `const val METHOD_*` per nativeToHybrid event method name

### 3.5 PlatformMethodCallHandler.kt
→ See `examples/PlatformMethodCallHandler.kt`
Generate at: `<androidPkgDir>/android/src/main/kotlin/<androidPackage>/PlatformMethodCallHandler.kt`

Rules:
- Implements `MethodChannel.MethodCallHandler`
- Constructor takes `context: Context` and `pluginHelper: <featureNameCamel>PluginHelper`
- `onMethodCall` wraps everything in try/catch; logs `call.method`
- **Fire-and-forget**: `val payload = call.arguments.toString()` → call helper method directly, no result
- **Result methods**: `GlobalResources.executor.submit { val r = helper.method(context, payload); GlobalResources.mainThread.post { result.success(r) } }`
- `else →` log error "Method Not supported"
- Log entry and result at every method

### 3.6 EventEmitterImpl.kt *(only if nativeToHybrid events exist)*
→ See `examples/EventEmitterImpl.kt`
Generate at: `<androidPkgDir>/android/src/main/kotlin/<androidPackage>/EventEmitterImpl.kt`

Rules:
- Constructor takes `callBack: (methodName: String, payload: String) -> Unit`
- Implements the plugin-base `<featureNameCamel>EventEmitter` interface
- `emit(event)` — switch on event type, call private `emitXxxEvent(event)`
- Each private emitter: serialize to JSON via plugin-base helper; determine method name constant; call `callBack.invoke(methodName, payload.toString())`

### 3.7 MoEngage<featureNameCamel>Plugin.kt
→ See `examples/Plugin.kt`
Generate at: `<androidPkgDir>/android/src/main/kotlin/<androidPackage>/MoEngage<featureNameCamel>Plugin.kt`

Rules:
- Implements `FlutterPlugin`, `ActivityAware`
- Lazy-init `pluginHelper: <featureNameCamel>PluginHelper`
- `onAttachedToEngine`: store `context`, store `flutterPluginBinding`, call `initPlugin` if `methodChannel == null`
- `initPlugin`: create `MethodChannel(binaryMessenger, CHANNEL_NAME)`, set `PlatformMethodCallHandler`, call `set<featureNameCamel>EventEmitter(EventEmitterImpl(::emitEvent))` (only if events exist)
- `onDetachedFromEngine`: call `pluginHelper.onFrameworkDetached()`
- `emitEvent(methodName, payload)`: post to `GlobalResources.mainThread` → `methodChannel?.invokeMethod(methodName, payload)`
- `onAttachedToActivity`: call `initPlugin(flutterPluginBinding?.binaryMessenger)`
- `onDetachedFromActivity`: set `methodChannel = null`
- Companion object: `var methodChannel: MethodChannel?`, `var flutterPluginBinding: FlutterPluginBinding?`

### 3.8 pubspec.yaml
→ See `examples/pubspec.yaml`
Copy `packages/moengage_cards/moengage_cards_android/pubspec.yaml`, then update:
- `name` → `moengage_<featureName>_android`
- `description` → `Android implementation of the moengage_<featureName> plugin`
- `version` → `1.0.0`
- `flutter.plugin.implements` → `moengage_<featureName>`
- `flutter.plugin.platforms.android.package` → `<androidPackage>`
- `flutter.plugin.platforms.android.pluginClass` → `MoEngage<featureNameCamel>Plugin`
- `flutter.plugin.platforms.android.dartPluginClass` → `MoEngage<featureNameCamel>Android`
- `dependencies.moengage_<featureName>_platform_interface` → `^1.0.0`

### 3.9 Dart plugin registration file
→ See `examples/dart_plugin.dart`
Generate at: `<androidPkgDir>/lib/moengage_<featureName>_android.dart`

Rules:
- `class MoEngage<featureNameCamel>Android extends MoEngage<featureNameCamel>Platform`
- `static void registerWith() { MoEngage<featureNameCamel>PlatformInterface.instance = MoEngage<featureNameCamel>Android(); }`
- Implements all platform interface methods; each calls `methodChannel.invokeMethod(methodName, jsonEncode(payload))`

### 3.10 CHANGELOG

Create or update `<androidPkgDir>/CHANGELOG.md`.

**If the file does not exist**, create it with:
```markdown
# Release Date

## Release Version

- [minor] Added support for <feature_description>
```

**If the file already exists** and has a `# Release Date` / `## Release Version` pending block at the top, append to it:
```markdown
- [minor] Added support for <feature_description>
```

**If the file exists but has no pending block**, prepend one before the first dated entry.

### 3.11 Commit
```bash
git add <androidPkgDir>/
git commit -m "<ticketId>: Add Flutter Android bridge for <featureName>"
```

---

## Phase 4 — Create Pull Request

```bash
git push -u origin feature/<ticketId>-<contractSuffix>
gh pr create \
  --title "<ticketId>: Add Flutter Android bridge for <featureName>" \
  --base development \
  --body "$(cat <<'EOF'
## Summary
- Adds Android Kotlin bridge (`<androidPkgDir>/android/`) for the <featureName> feature
- PlatformMethodCallHandler routes all Dart→Native calls to `<featureNameCamel>PluginHelper`
- Plugin emits native events back to Flutter via MethodChannel
- Android BOM: <android_bom_version>, plugin-base BOM: <plugin_base_bom_version>

## Related PRs
- android-plugin-base: <android_plugin_base_pr_url>

## Contract
Branch: `<contract_branch>` in mobile-sdk-contracts

## Methods
| Method | Type |
 --- || --- | --- || --- | --- || --- |
 --- |<table rows from method table>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

---

## Phase 5 — Report & Hand-off

Print:
1. PR URL
2. Full method table (name, type, plugin-base helper method called)
3. All `// TODO` items left for manual verification
4. List of all files created or modified

Then **ask the user**:
> "Android bridge for `<featureName>` is done (PR: <pr_url>).
> Would you like to also run the iOS bridge now (`flutter-ios-bridge-implementation`)?
> It needs the same contract branch, plugin version, and plugin-base PR URL."

---

## Codebase Reference Files

Read these before generating output — copy logging conventions, patterns, and structure exactly.

| What | Codebase path |
 --- || --- | --- || --- | --- || --- |
 --- || Plugin.kt reference | `packages/moengage_cards/moengage_cards_android/android/src/main/kotlin/com/moengage/flutter/cards/MoEngageCardsPlugin.kt` |
| PlatformMethodCallHandler reference | `packages/moengage_cards/moengage_cards_android/android/src/main/kotlin/com/moengage/flutter/cards/PlatformMethodCallHandler.kt` |
| EventEmitterImpl reference | `packages/moengage_cards/moengage_cards_android/android/src/main/kotlin/com/moengage/flutter/cards/EventEmitterImpl.kt` |
| Constants.kt reference | `packages/moengage_cards/moengage_cards_android/android/src/main/kotlin/com/moengage/flutter/cards/Constants.kt` |
| build.gradle reference | `packages/moengage_cards/moengage_cards_android/android/build.gradle` |
| pubspec.yaml reference | `packages/moengage_cards/moengage_cards_android/pubspec.yaml` |
| Dart plugin file reference | `packages/moengage_cards/moengage_cards_android/lib/moengage_cards_android.dart` |

---

## Error Handling Rules

- `contract_branch` not found in `../mobile-sdk-contracts` → stop and tell the user
- `contractDir` not found in `json/hybridToNative/` → list available dirs and ask
- `androidPkgDir` already exists with source files → read existing files, add only missing methods
- Plugin-base helper class name unknown → add `// TODO: verify helper class name` and continue
- `<featureName>-core` artifact name unknown → add `// TODO: verify native SDK artifact` in build.gradle and continue
- Push fails → report error and local branch name so the user can push manually
