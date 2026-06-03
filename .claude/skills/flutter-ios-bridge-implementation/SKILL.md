---
name: flutter-ios-bridge-implementation
description: >
  Implements the iOS Swift bridge layer for a Flutter MoEngage SDK feature.
  This is Step 2 of the Flutter feature pipeline (parallel to or after
  flutter-android-bridge-implementation). Produces MoEngage<featureNameCamel>Plugin.swift,
  MoEngageFlutter<featureNameCamel>Constants.swift, optional event listener .swift,
  optional util .swift, podspec, and pubspec.yaml for a new
  moengage_<featureName>_ios package under packages/moengage_<featureName>/.
  Follows the moengage_cards_ios module standard exactly.
  On completion, asks the user whether to also run flutter-dart-implementation.
  Do NOT use for Android-only features or Dart-only changes.
parameters:
  - name: "ticket_id"
    description: "JIRA ticket ID, e.g. 'MOEN-44072'. Extracted from command text if not supplied."
    optional: true
  - name: "feature_description"
    description: "Natural language description of the feature. E.g. 'JWT authentication parity'."
  - name: "contract_branch"
    description: "Branch in 'mobile-sdk-contracts' with the feature contract."
  - name: "ios_plugin_version"
    description: "Target MoEngagePlugin<featureNameCamel> pod version. E.g. '3.10.0'."
  - name: "ios_plugin_base_pr_url"
    description: "URL of the iOS-PluginBase PR from plugin-base-feature-implementation."
---

## Overview

Implements the **iOS Swift bridge** inside the Flutter SDK repo (`Flutter-SDK`) for a
MoEngage feature whose plugin-base module already exists.

**Prerequisite chain:**
1. `plugin-base-feature-implementation` — creates/extends the plugin-base module ✅
2. `flutter-android-bridge-implementation` — Android Kotlin bridge ✅ (or iOS-first flow)
3. **`flutter-ios-bridge-implementation`** ← you are here

**Architecture standard:** Follow the **moengage_cards_ios** package exactly.
Path: `packages/moengage_cards/moengage_cards_ios/`

**Example files:** Templates are in `examples/` adjacent to this SKILL.md. Read each
template before generating the corresponding file.

---

## Example Files Index

```
examples/
  Plugin.swift              ← MoEngage<featureNameCamel>Plugin.swift
  Constants.swift           ← MoEngageFlutter<featureNameCamel>Constants.swift
  EventListener.swift       ← MoEngage<featureNameCamel>SyncListener.swift (only if events)
  Util.swift                ← MoEngage<featureNameCamel>Util.swift (only if result methods)
  podspec                   ← moengage_<featureName>_ios.podspec
  pubspec.yaml              ← pubspec.yaml for moengage_<featureName>_ios
  dart_plugin.dart          ← lib/moengage_<featureName>_ios.dart
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

| Identifier         | Example                                          | Rule                                                   |
| ------------------ | ------------------------------------------------ | ------------------------------------------------------ |
| `ticketId`         | `MOEN-44072`                                     | `MOEN-\d+` from raw command or parameter               |
| `contractSuffix`   | `jwt_contract`                                   | branch name after first `/` or `_MOEN-XXXXX_`          |
| `featureName`      | `jwt`                                            | lowercase slug from feature_description                |
| `featureNameCamel` | `Jwt`                                            | PascalCase of featureName                              |
| `contractDir`      | `authentication`                                 | subdirectory found in contracts `json/` after checkout |
| `packageDir`       | `packages/moengage_flutter`                      | see rule below                                         |
| `iosPkgDir`        | `packages/moengage_flutter/moengage_flutter_ios` | `<packageDir>/moengage_<featureName>_ios`              |
| `channelName`      | `com.moengage/jwt`                               | `com.moengage/<featureName>`                           |
| `iosPluginBridge`  | see rule below                                   | see rule below                                         |
| `branchName`       | `feature/MOEN-44072-jwt_contract`                | `feature/<ticketId>-<contractSuffix>`                  |

### 1.3 Resolve `packageDir`

Scan `feature_description` for a framework keyword and map to the existing package directory:

| Keyword in `feature_description`              | `packageDir`                                     |
| --------------------------------------------- | ------------------------------------------------ |
| `core`, `analytics`, `inapps`, or `messaging` | `packages/moengage_flutter`                      |
| `cards`                                       | `packages/moengage_cards`                        |
| `geofence`                                    | `packages/moengage_geofence`                     |
| `inbox`                                       | `packages/moengage_inbox`                        |
| `personalize`                                 | `packages/moengage_personalize`                  |
| none of the above                             | ask the user which package to add the feature to |

Examples:
- `"setDeviceAttribute from analytics"` → `packages/moengage_flutter`
- `"cardShown from cards"` → `packages/moengage_cards`
- `"start geofence monitoring"` → `packages/moengage_geofence`

### 1.4 Resolve `iosPluginBridge`

Scan `feature_description` for a framework keyword:

| Keyword in feature_description                 | `iosPluginBridge`                        | Import                             |
| ---------------------------------------------- | ---------------------------------------- | ---------------------------------- |
| `analytics`, `inapps`, `messaging`, or `core`  | `MoEngagePluginBridge`                   | `MoEngagePluginBase`               |
| anything else (cards, geofence, inbox, jwt, …) | `MoEngagePlugin<featureNameCamel>Bridge` | `MoEngagePlugin<featureNameCamel>` |

### 1.5 Resolve `iosHandlerFile` and `iosHandlerClass`

Look up the existing handler class and file by `packageDir`. Do **not** generate these from a formula — use the actual names from the codebase.

| `packageDir`                    | `iosHandlerClass`                   | `iosHandlerFile`                          |
| ------------------------------- | ----------------------------------- | ----------------------------------------- |
| `packages/moengage_flutter`     | `MoEngageFlutterBridge`             | `MoEngageFlutterBridge.swift`             |
| `packages/moengage_cards`       | `MoEngageCardsPlugin`               | `MoEngageCardsPlugin.swift`               |
| `packages/moengage_geofence`    | `MoEngageFlutterGeofence`           | `MoEngageFlutterGeofence.swift`           |
| `packages/moengage_inbox`       | `MoEngageFlutterInbox`              | `MoEngageFlutterInbox.swift`              |
| `packages/moengage_personalize` | `MoEngageFlutterPersonalize`        | `MoEngageFlutterPersonalize.swift`        |
| unknown (new package)           | `MoEngageFlutter<featureNameCamel>` | `MoEngageFlutter<featureNameCamel>.swift` |

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

| Condition                                | Type                             | iOS pattern                                      | Files needed                       |
| ---------------------------------------- | -------------------------------- | ------------------------------------------------ | ---------------------------------- |
| `hybridToNative` only                    | **fire-and-forget**              | `pluginHelper.methodName(payload)`               | Plugin + Constants                 |
| both `hybridToNative` + `nativeToHybrid` | **auto-detect from plugin-base** | depends                                          | see below                          |
| `nativeToHybrid` only                    | **event**                        | delegate → `channel.invokeMethod(name, jsonStr)` | Plugin + Constants + EventListener |

**When both `hybridToNative` and `nativeToHybrid` exist**, auto-detect the type by reading the iOS plugin-base branch:

```bash
gh pr view <ios_plugin_base_pr_url> --json headRefName
# then read the changed Swift files on that branch from MoEngage-iPhone-SDK or iOS-PluginBase
```

Look for the method in the plugin-base bridge file:

| Plugin-base pattern found                                                 | Type       | iOS pattern                                                     | Files needed                       |
| ------------------------------------------------------------------------- | ---------- | --------------------------------------------------------------- | ---------------------------------- |
| Method has a `completionBlock` / `completionHandler` closure parameter    | **result** | `pluginHelper.methodName(payload) { data in Util.resume(...) }` | Plugin + Constants + Util          |
| Method uses a delegate protocol / `flushMessage` / `EventEmitter` pattern | **event**  | direct call + delegate → `channel.invokeMethod(name, jsonStr)`  | Plugin + Constants + EventListener |

If the plugin-base branch is unreadable or the pattern is still ambiguous after reading it, **then** ask the user.

**Build a complete method table before writing any code.**

---

## Phase 3 — iOS Bridge Implementation

### 3.1 Check out branch
```bash
cd Flutter-SDK
git fetch
git checkout feature/<ticketId>-<contractSuffix>   # created by Android bridge step
```
If the branch does not exist yet (iOS-first flow):
```bash
git checkout -b feature/<ticketId>-<contractSuffix>
```

### 3.2 Check if the iOS package already exists

```bash
ls <iosPkgDir>/ios/ 2>/dev/null
```

**Existing package** (files found — e.g. `moengage_flutter_ios`, `moengage_cards_ios`):
- Do **not** create new files for plugin, constants, podspec, pubspec, or dart file.
- Read `<iosHandlerFile>` and the existing constants file first, then **add only missing entries**.
- Constants file: add missing `static let` entries inside the appropriate `enum` block.
- Handler file (`<iosHandlerClass>`): add missing `case` blocks inside `handle(_:result:)` / `handleWithPayload`.
- Podspec: update the plugin-base dependency version only (see §3.7).
- Skip §3.3 through §3.6 for files that already exist; only add what is missing.

**New package** (no files found):
- Scaffold all files from §3.3 through §3.9.
- Generate handler class as `<iosHandlerClass>` in `<iosHandlerFile>`.

### 3.3 Constants file

**Existing package:** read the existing constants file, add only missing entries.
**New package:** generate `<iosPkgDir>/ios/moengage_<featureName>_ios/Sources/MoEngageFlutter<featureNameCamel>Constants.swift`

Rules:
- `enum MoEngageFlutter<featureNameCamel>Constants` (or add to existing enum)
- `static let pluginChannelName = "com.moengage/<featureName>"`
- `enum FlutterToNativeMethods` — one `static let` per hybridToNative method
- `enum NativeToFlutterMethods` — one `static let` per nativeToHybrid event (omit section if no events)
- String values must exactly match the Dart `constants.dart` method names

### 3.4 EventListener.swift *(only if nativeToHybrid events exist)*
→ See `examples/EventListener.swift`

**Existing package:** check if a listener file already exists; read and add only missing cases.
**New package:** generate `<iosPkgDir>/ios/moengage_<featureName>_ios/Sources/MoEngage<featureNameCamel>SyncListener.swift`

Rules:
- `class MoEngage<featureNameCamel>SyncListener: MoEngage<featureNameCamel>SyncDelegate`
- Constructor: `init(producingOnChannel channel: FlutterMethodChannel)`
- Delegate method: serialize `data` dict via `MoEngage<featureNameCamel>Util.serialize(data:)`; call `DispatchQueue.main.async { self.channel.invokeMethod(eventType.mappedMethodName, arguments: jsonStr) }`
- `extension MoEngage<featureNameCamel>SyncEventType` with `var mappedMethodName: String` — switch on each case → `NativeToFlutterMethods.*`
- Ask user for delegate protocol name if unknown; add `// TODO: verify delegate protocol` and continue

### 3.5 Util.swift *(only if result methods exist)*
→ See `examples/Util.swift`

**Existing package:** check if a util file exists; read and add only missing methods.
**New package:** generate `<iosPkgDir>/ios/moengage_<featureName>_ios/Sources/MoEngage<featureNameCamel>Util.swift`

Rules:
- `enum MoEngage<featureNameCamel>Util`
- `static func resume(channel method: String, havingResult result: @escaping FlutterResult, withData data: [String: Any])` — serializes to JSON string; dispatches `result(jsonStr)` on main thread
- `static func serialize(data: [String: Any]) -> String` — `JSONSerialization` → String; return `""` on failure

### 3.6 Handler file (`<iosHandlerFile>`)
→ See `examples/Plugin.swift` for new-package structure

**Existing package:** read `<iosHandlerFile>`, add only missing `case` blocks inside `handle(_:result:)` (or `handleWithPayload` for `moengage_flutter`). Do **not** recreate the file.
**New package:** generate `<iosPkgDir>/ios/moengage_<featureName>_ios/Sources/<iosHandlerFile>`

Rules:
- Class name: `<iosHandlerClass>: NSObject, FlutterPlugin`
- `private let pluginHelper = <iosPluginBridge>.sharedInstance` (or `private static var channel` pattern for `moengage_flutter`)
- `register(with registrar:)`: create `FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())`, set `addMethodCallDelegate`, set event listener delegate (if events exist)
- `detachFromEngine`: call `pluginHelper.onFrameworkDetached()`
- `handle(_:result:)`: `guard let payload = call.arguments as? [String: Any]`; log error and return if nil; `switch call.method` — one `case` per method
  - Fire-and-forget: `pluginHelper.methodName(payload)`
  - Result: `pluginHelper.methodName(payload) { data in MoEngage<featureNameCamel>Util.resume(channel: call.method, havingResult: result, withData: data) }`
  - `default:` log error
- Import `Flutter`, `MoEngageCore`, `<iosPluginImport>`

### 3.7 Podspec and Package.swift

**If `ios_plugin_version` was not provided:** skip version file changes entirely — do not touch podspec, Package.swift, or CHANGELOG.

**Existing package + `ios_plugin_version` provided:**
Delegate to **`flutter-ios-version-update`** skill — it handles podspec, Package.swift, and CHANGELOG updates for existing packages. Do **not** duplicate that logic here.

**New package + `ios_plugin_version` provided:**
→ See `examples/podspec`
Copy `packages/moengage_cards/moengage_cards_ios/ios/moengage_cards_ios.podspec`, then update:
- `s.name` → `"moengage_<featureName>_ios"`
- `s.summary` / `s.description` → update feature name
- `root = "#{s.name}/Sources"` — keep pattern
- `s.dependency 'MoEngagePlugin<featureNameCamel>', '<ios_plugin_version>'`
- Keep `s.dependency 'Flutter'`

Also copy `packages/moengage_cards/moengage_cards_ios/ios/moengage_cards_ios/Package.swift`, then update:
- `name` → `"moengage_<featureName>_ios"`
- `.library(name:` → `"moengage-<featureName>-ios"`
- `.package(url:` → correct GitHub URL for the new plugin (ask user if unknown; add `// TODO: verify GitHub URL`)
- `exact:` → `"<ios_plugin_version>"`
- `.product(name:` → `"MoEngagePlugin<featureNameCamel>"`, `package:` → correct package name

### 3.8 pubspec.yaml
→ See `examples/pubspec.yaml`
Copy `packages/moengage_cards/moengage_cards_ios/pubspec.yaml`, then update:
- `name` → `moengage_<featureName>_ios`
- `description` → `iOS implementation of the moengage_<featureName> plugin`
- `version` → `1.0.0`
- `flutter.plugin.implements` → `moengage_<featureName>`
- `flutter.plugin.platforms.ios.pluginClass` → `MoEngage<featureNameCamel>Plugin`
- `flutter.plugin.platforms.ios.dartPluginClass` → `MoEngage<featureNameCamel>IOS`
- `dependencies.moengage_<featureName>_platform_interface` → `^1.0.0`

### 3.9 Dart plugin registration file
→ See `examples/dart_plugin.dart`
Generate at: `<iosPkgDir>/lib/moengage_<featureName>_ios.dart`

Rules:
- `class MoEngage<featureNameCamel>IOS extends MoEngage<featureNameCamel>Platform`
- `static void registerWith() { MoEngage<featureNameCamel>PlatformInterface.instance = MoEngage<featureNameCamel>IOS(); }`
- Implements all platform interface methods; each calls `methodChannel.invokeMethod(methodName, payload)`
- iOS typically passes the map directly (no `jsonEncode`); mirror `moengage_cards_ios.dart` style

### 3.10 Commit
```bash
git add <iosPkgDir>/
git commit -m "<ticketId>: Add Flutter iOS bridge for <featureName>"
```

---

## Phase 4 — Create / Update Pull Request

```bash
git push -u origin feature/<ticketId>-<contractSuffix>

# Check if PR already exists (from Android bridge step):
gh pr list --head feature/<ticketId>-<contractSuffix> --json number,url
```

**If PR already exists** (Android bridge was done first): push new commit to same branch and add a PR comment explaining iOS was added. Do **not** create a second PR.

**If no PR exists** (iOS-first flow):
```bash
gh pr create \
  --title "<ticketId>: Add Flutter iOS bridge for <featureName>" \
  --base development \
  --body "$(cat <<'EOF'
## Summary
- Adds iOS Swift bridge (`<iosPkgDir>/ios/`) for the <featureName> feature
- Plugin delegates all calls to `<iosPluginBridge>.sharedInstance`
- Event listener delegate emits native events back to Flutter via MethodChannel
- iOS plugin version: <ios_plugin_version>

## Related PRs
- ios-plugin-base: <ios_plugin_base_pr_url>

## Contract
Branch: `<contract_branch>` in mobile-sdk-contracts

## Methods
| Method | Type |
| ------ | ---- |
<table rows from method table>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

---

## Phase 5 — Report & Hand-off

Print:
1. PR URL
2. Full method table (name, type, iOS plugin-bridge method called)
3. All `// TODO` items left for manual verification (delegate protocol name, pod dependency)
4. List of all files created or modified

Then **ask the user**:
> "iOS bridge for `<featureName>` is done (PR: <pr_url>).
> Would you like to also run the Dart layer now (`flutter-dart-implementation`)?
> It needs the same contract branch, versions, and both PR URLs."

---

## Codebase Reference Files

| What                                        | Codebase path                                                                                                                  |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Handler (core/analytics — bridge pattern)   | `packages/moengage_flutter/moengage_flutter_ios/ios/moengage_flutter_ios/Sources/MoEngageFlutterBridge.swift`                  |
| Constants (core/analytics)                  | `packages/moengage_flutter/moengage_flutter_ios/ios/moengage_flutter_ios/Sources/MoEngageFlutterConstants.swift`               |
| Handler (cards — plugin-is-handler pattern) | `packages/moengage_cards/moengage_cards_ios/ios/moengage_cards_ios/Sources/MoEngageCardsPlugin.swift`                          |
| Constants (cards)                           | `packages/moengage_cards/moengage_cards_ios/ios/moengage_cards_ios/Sources/MoEngageFlutterCardsConstants.swift`                |
| EventListener reference                     | `packages/moengage_cards/moengage_cards_ios/ios/moengage_cards_ios/Sources/MoEngageCardSyncListner.swift`                      |
| Util reference                              | `packages/moengage_cards/moengage_cards_ios/ios/moengage_cards_ios/Sources/MoEngageCardsUtil.swift`                            |
| Handler (geofence)                          | `packages/moengage_geofence/moengage_geofence_ios/ios/moengage_geofence_ios/Sources/MoEngageFlutterGeofence.swift`             |
| Handler (inbox)                             | `packages/moengage_inbox/moengage_inbox_ios/ios/moengage_inbox_ios/Sources/MoEngageFlutterInbox.swift`                         |
| Handler (personalize)                       | `packages/moengage_personalize/moengage_personalize_ios/ios/moengage_personalize_ios/Sources/MoEngageFlutterPersonalize.swift` |
| podspec reference                           | `packages/moengage_cards/moengage_cards_ios/ios/moengage_cards_ios.podspec`                                                    |
| pubspec.yaml reference                      | `packages/moengage_cards/moengage_cards_ios/pubspec.yaml`                                                                      |
| Dart plugin file reference                  | `packages/moengage_cards/moengage_cards_ios/lib/moengage_cards_ios.dart`                                                       |

---

## Error Handling Rules

- `contract_branch` not found in `../mobile-sdk-contracts` → stop and tell the user
- `contractDir` not found in `json/hybridToNative/` → list available dirs and ask
- `iosPkgDir` already has iOS source files → read `<iosHandlerFile>` and constants file, add only missing methods/constants — never recreate existing files
- Delegate protocol name unknown → add `// TODO: verify delegate protocol name` and continue
- iOS pod dependency name unknown → add `// TODO: verify iOS pod dependency` in podspec and continue
- Push fails → report error and local branch name so the user can push manually
