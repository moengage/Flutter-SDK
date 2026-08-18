---
name: flutter-dart-interface-implementation
description: >
  Implements the Dart layer for a Flutter MoEngage SDK feature.
  This is Step 3 of the Flutter feature pipeline — run AFTER at least one native bridge
  (Android or iOS) has been implemented. Produces the platform interface package
  (moengage_<featureName>_platform_interface) and the main public package
  (moengage_<featureName>), following the moengage_cards structure exactly.
  Platform interface package contains: platform interface abstract class, method channel
  implementation, constants, payload mapper, controller (for events), instance provider,
  callback cache, and model/enum files from the contract protos.
  Main package contains: public API class and pubspec wiring both native implementations.
  Also updates the ALREADY-REGISTERED Android/iOS Dart platform classes
  (moengage_<featureName>_android, moengage_<featureName>_ios) with an override for every
  new method — the MethodChannel class is only a fallback default and is never what runs in
  a real app, so skipping this step leaves the method throwing UnimplementedError at runtime.
  Also wires the new APIs into the top-level shared sample app (example/lib/main.dart) with a
  demo trigger and, if the feature has events, listener registration — skip only if the user
  explicitly opts out.
  Do NOT use before at least one native bridge exists.
parameters:
  - name: "ticket_id"
    description: "JIRA ticket ID, e.g. 'MOEN-44072'. Extracted from command text if not supplied."
    optional: true
  - name: "feature_description"
    description: "Natural language description of the feature. E.g. 'JWT authentication parity'."
  - name: "contract_branch"
    description: "Branch in 'mobile-sdk-contracts' with the feature contract. If this is 'master' (or 'main') and no native bridge has run yet to derive a suffix, the skill asks for a branch name/suffix (and an optional prefix) before proceeding."
  - name: "android_bridge_pr_url"
    description: "URL of the Flutter Android bridge PR."
    optional: true
  - name: "ios_bridge_pr_url"
    description: "URL of the Flutter iOS bridge PR."
    optional: true
  - name: "android_plugin_base_pr_url"
    description: "URL of the android-plugin-base PR from plugin-base-feature-implementation."
    optional: true
  - name: "ios_plugin_base_pr_url"
    description: "URL of the iOS-PluginBase PR from plugin-base-feature-implementation."
    optional: true
---

## Overview

Implements the **Dart platform interface and public API** inside the Flutter SDK repo
(`Flutter-SDK`) for a MoEngage feature whose native bridges already exist.

**Prerequisite chain:**
1. `plugin-base-feature-implementation` ✅
2. `flutter-android-bridge-implementation` + `flutter-ios-bridge-implementation` ✅
3. **`flutter-dart-interface-implementation`** ← you are here

**Architecture standard:** Follow the **moengage_cards** package structure exactly.

Produces two packages:
- `moengage_<featureName>_platform_interface/` — abstract contract + MethodChannel impl + models
- `moengage_<featureName>/` — public API class that consumers import

**Critical architecture fact — read before touching Phase 3:** In every existing package
(moengage_flutter, moengage_cards, moengage_geofence, moengage_inbox, moengage_personalize),
the classes that actually get registered at runtime —
`MoEngage<featureNameCamel>Android` in `<androidPkgDir>/lib/moengage_<featureName>_android.dart`
and `MoEngage<featureNameCamel>IOS` in `<iosPkgDir>/lib/moengage_<featureName>_ios.dart` —
extend `MoEngage<featureNameCamel>Platform` (the platform_base/platform_interface abstract
class) **directly**. Neither one extends `MethodChannelMoEngage<featureNameCamel>`. So
`method_channel.dart` is a fallback default that is not exercised by a real Android or iOS
build. **Writing a new method's body only into `method_channel.dart` is not enough** — do
this once and the abstract class's `throw UnimplementedError()` default is what actually
runs, exactly the bug this skill previously shipped for `passAuthenticationDetails` in
moengage_flutter. Every method added to the platform interface needs a matching `@override`
copied into both registered classes (Phase 3.13).

**Example files:** Templates are in `examples/` adjacent to this SKILL.md.

---

## Example Files Index

```
examples/
  platform_interface/
    platform_interface.dart   ← lib/moengage_<featureName>_platform_interface.dart (top-level export + abstract class)
    constants.dart            ← lib/src/internal/constants.dart
    method_channel.dart       ← lib/src/internal/method_channel_moengage_<featureName>.dart
    platform_base.dart        ← lib/src/internal/<featureName>_platform.dart (only if event listener caching needed)
    controller.dart           ← lib/src/internal/<featureName>_controller.dart (only if nativeToFlutter events)
    instance_provider.dart    ← lib/src/internal/<featureName>_instance_provider.dart (only if event listener caching)
    callback_cache.dart       ← lib/src/internal/callback_cache.dart (only if event listener caching)
    payload_mapper.dart       ← lib/src/internal/payload_mapper.dart
    model.dart                ← lib/src/model/model.dart (barrel export)
    SomeModel.dart            ← lib/src/model/<ModelName>.dart (one per proto entity)
    SomeEnum.dart             ← lib/src/model/enums/<EnumName>.dart (one per proto enum)
    pubspec.yaml              ← pubspec.yaml for platform interface package
    registered_platform_impl.dart ← edits to make in the EXISTING
                                    <androidPkgDir>/lib/moengage_<featureName>_android.dart and
                                    <iosPkgDir>/lib/moengage_<featureName>_ios.dart (Phase 3.13)
  main_package/
    public_api.dart           ← lib/src/moengage_<featureName>.dart
    pubspec.yaml              ← pubspec.yaml for main package
```

---

## Phase 0 — Clarify Inputs

### 0.1 Extract ticket ID
Scan the user's full command for `MOEN-\d+` → **`ticketId`**.
If not found, ask before proceeding.

---

## Phase 1 — Parse Inputs & Derive All Identifiers

### 1.1 Extract from `contract_branch`
Strip everything up to and including the first `/` or `_MOEN-XXXXX_` prefix:
- `feature/experience_contracts` → **`contractSuffix`** = `experience_contracts`
- `MOEN-44072_jwt_contract` → **`contractSuffix`** = `jwt_contract`

If a native bridge step already ran, reuse its `contractSuffix` as-is instead of re-deriving.
Otherwise, **if `contract_branch` is `master` or `main`**, there is no feature suffix to strip —
ask the user for the branch name/suffix to use for the `Flutter-SDK` implementation branch. If
they don't provide one, offer to default `contractSuffix` to a prefix derived from `featureName`
(e.g. `<featureName>_contract`) and confirm before using it.

### 1.2 Identifiers table

| Identifier         | Example                                                         | Rule                                                     |
| ------------------ | --------------------------------------------------------------- | -------------------------------------------------------- |
| `ticketId`         | `MOEN-44072`                                                    | `MOEN-\d+` from raw command or parameter                 |
| `contractSuffix`   | `jwt_contract`                                                  | branch name after first `/` or `_MOEN-XXXXX_`            |
| `featureName`      | `jwt`                                                           | lowercase slug from feature_description                  |
| `featureNameCamel` | `Jwt`                                                           | PascalCase of featureName                                |
| `featureNameUpper` | `JWT`                                                           | UPPER_SNAKE                                              |
| `contractDir`      | `authentication`                                                | subdirectory found in contracts `json/` after checkout   |
| `packageDir`       | `packages/moengage_flutter`                                     | see rule below                                           |
| `piDir`            | `packages/moengage_flutter/moengage_flutter_platform_interface` | `<packageDir>/moengage_<featureName>_platform_interface` |
| `mainDir`          | `packages/moengage_flutter/moengage_flutter`                    | `<packageDir>/moengage_<featureName>`                    |
| `androidPkgDir`    | `packages/moengage_flutter/moengage_flutter_android`            | `<packageDir>/moengage_<featureName>_android`            |
| `iosPkgDir`        | `packages/moengage_flutter/moengage_flutter_ios`                | `<packageDir>/moengage_<featureName>_ios`                |
| `channelName`      | `com.moengage/jwt`                                              | `com.moengage/<featureName>`                             |
| `branchName`       | `feature/MOEN-44072-jwt_contract`                               | `feature/<ticketId>-<contractSuffix>`                    |

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

---

## Phase 2 — Read Contracts

```bash
cd ../mobile-sdk-contracts
git fetch
git stash
git checkout <contract_branch>
```

1. List `json/hybridToNative/` to identify `contractDir`
2. For each `.json` in `json/hybridToNative/<contractDir>/`:
   - Filename (without `.json`) = **method name** (camelCase)
   - File content = **input payload shape**
3. For each `.json` in `json/nativeToHybrid/<contractDir>/`:
   - File content = **event/response payload shape**
4. Read all `.proto` files in `protos/<contractDir>/` for model field names and types

### Method classification

| Condition                                | Type                             | Dart pattern                                                         |
| ---------------------------------------- | -------------------------------- | -------------------------------------------------------------------- |
| `hybridToNative` only                    | **fire-and-forget**              | `void methodName(...)` → `methodChannel.invokeMethod(...)`           |
| both `hybridToNative` + `nativeToHybrid` | **auto-detect from plugin-base** | depends                                                              |
| `nativeToHybrid` only                    | **event**                        | listener callback registered by caller; fired from `controller.dart` |

**When both `hybridToNative` and `nativeToHybrid` exist**, auto-detect the type by reading the plugin-base branch (Android takes priority; iOS used as fallback):

```bash
# Android plugin-base
gh pr view <android_plugin_base_pr_url> --json headRefName
# read changed Kotlin helper/handler files on that branch

# iOS plugin-base (fallback if Android result is ambiguous)
gh pr view <ios_plugin_base_pr_url> --json headRefName
# read changed Swift files on that branch
```

| Plugin-base pattern found                                                    | Type       | Dart pattern                                                                                  |
| ---------------------------------------------------------------------------- | ---------- | --------------------------------------------------------------------------------------------- |
| Method returns a value / calls `result.success(...)` / has `completionBlock` | **result** | `Future<ModelType> methodName(...)` → `await methodChannel.invokeMethod(...)` → deserialize   |
| Method registers/calls an `EventEmitter` / delegate / `flushMessage` pattern | **event**  | `void methodName(...)` + listener callback registered by caller; fired from `controller.dart` |

If the plugin-base branch is unreadable or the pattern is still ambiguous after reading it, **then** ask the user.

**Build a complete method table before writing any code.**

---

## Phase 3 — Platform Interface Package

### 3.1 Check out the branch
```bash
cd Flutter-SDK
git fetch
git checkout feature/<ticketId>-<contractSuffix>
```

### 3.2 Create directory structure
```bash
mkdir -p <piDir>/lib/src/internal
mkdir -p <piDir>/lib/src/model/enums
```

### 3.3 constants.dart
→ See `examples/platform_interface/constants.dart`
Generate at: `<piDir>/lib/src/internal/constants.dart`

Rules:
- `const String moduleTag = '<featureNameCamel>_'`
- `const String <featureName>MethodChannel = 'com.moengage/<featureName>'`
- One `const String method<MethodNameCamel>` per hybridToNative method (value = contract filename)
- One `const String method<EventNameCamel>` per nativeToHybrid event
- JSON key constants (`keyXxx`) for all fields in the contract payloads and proto models
- Argument constants (`argument<Xxx>`) for enum string values used in JSON

### 3.4 Model files
→ See `examples/platform_interface/SomeModel.dart`
Generate one file per logical proto entity at: `<piDir>/lib/src/model/<ModelName>.dart`

Rules:
- Use `class` with named required/optional fields
- `factory <ModelName>.fromJson(Map<String, dynamic> data)` — parse using `keyXxx` constants
- `Map<String, dynamic> toJson()` — serialize using `keyXxx` constants
- Optional/nullable proto fields → `Type? fieldName`
- Nested models → call `NestedModel.fromJson(...)`

### 3.5 Enum files
→ See `examples/platform_interface/SomeEnum.dart`
Generate one file per proto enum at: `<piDir>/lib/src/model/enums/<EnumName>.dart`

Rules:
- Plain Dart `enum` (not const enum)
- One value per proto enum value (camelCase in Dart)

### 3.6 model.dart barrel
→ See `examples/platform_interface/model.dart`
Generate at: `<piDir>/lib/src/model/model.dart`
Export every model and enum file.

### 3.7 payload_mapper.dart
→ See `examples/platform_interface/payload_mapper.dart`
Generate at: `<piDir>/lib/src/internal/payload_mapper.dart`

Rules:
- One `deSerialize<ModelName>(String payload)` function per Future result method:
  - `jsonDecode(payload)[keyData]` → `<ModelName>.fromJson(...)`
- One `get<MethodName>Payload(...)` function per hybridToNative method that needs non-trivial payload:
  - Returns `Map<String, dynamic>` with `keyAccountMeta: {keyAppId: appId}` + `keyData: {...}` shape
- Enum↔string converters: `<enumName>FromString(String? s)` and `<enumName>ToString(<EnumName> e)` — only if event methods carry enum fields

### 3.8 callback_cache.dart *(only if event listener methods exist)*
→ See `examples/platform_interface/callback_cache.dart`
Generate at: `<piDir>/lib/src/internal/callback_cache.dart`

Rules:
- `class CallbackCache` with one nullable listener field per nativeToHybrid event type
- Typedef `<FeatureNameCamel>SyncListener = void Function(<SyncModel>? data)`

### 3.9 instance_provider.dart *(only if event listener methods exist)*
→ See `examples/platform_interface/instance_provider.dart`
Generate at: `<piDir>/lib/src/internal/<featureName>_instance_provider.dart`

Rules:
- Singleton factory pattern (same as `CardsInstanceProvider`)
- `Map<String, CallbackCache> _caches`
- `CallbackCache getCallbackCacheForInstance(String appId)` — lazy-create per appId

### 3.10 controller.dart *(only if event listener methods exist)*
→ See `examples/platform_interface/controller.dart`
Generate at: `<piDir>/lib/src/internal/<featureName>_controller.dart`

Rules:
- Singleton factory that sets up `MethodChannel.setMethodCallHandler` in `_internal()` constructor
- `_handler(MethodCall call)`: `jsonDecode(call.arguments)` → extract `accountMeta.appId` → switch on `call.method`:
  - Each nativeToHybrid method name → deserialize payload → call appropriate listener from `CallbackCache` per appId
- Import `InstanceProvider` to retrieve the cache

### 3.11 platform_base.dart *(only if event listener caching needed)*
→ See `examples/platform_interface/platform_base.dart`
Generate at: `<piDir>/lib/src/internal/<featureName>_platform.dart`

Rules:
- `abstract class MoEngage<featureNameCamel>Platform extends MoEngage<featureNameCamel>PlatformInterface`
- `MethodChannel methodChannel = const MethodChannel(<featureName>MethodChannel)`
- Override listener-caching methods: store the listener in `InstanceProvider().getCallbackCacheForInstance(appId).xxxListener = listener`
- Leave Future/void methods unimplemented (subclass handles those)

### 3.12 method_channel.dart
→ See `examples/platform_interface/method_channel.dart`
Generate at: `<piDir>/lib/src/internal/method_channel_moengage_<featureName>.dart`

Rules:
- `class MethodChannelMoEngage<featureNameCamel> extends MoEngage<featureNameCamel>Platform` (or extends `MoEngage<featureNameCamel>PlatformInterface` if no platform_base)
- Fire-and-forget: `methodChannel.invokeMethod(method<Name>, jsonEncode(getAccountMeta(appId)))`
  - Methods with extra data: `jsonEncode(get<MethodName>Payload(...))`
- Future result: `final result = await methodChannel.invokeMethod(method<Name>, jsonEncode(...)); return deSerialize<ModelName>(result as String)`
- Listener-setting methods: call `super.setXxxListener(listener, appId)` then `methodChannel.invokeMethod(...)` if native needs to know

### 3.13 Update the existing Android/iOS Dart platform implementations

→ See `examples/platform_interface/registered_platform_impl.dart`

This step is **not optional** and is separate from Phase 6 (which only checks pubspec
dependency wiring). Do it every time this skill adds a method to a platform interface —
whether the package is brand new (native bridge steps 1/2 just created a minimal
`registerWith()` stub) or already existed (moengage_flutter, moengage_cards, etc.).

1. Open `<androidPkgDir>/lib/moengage_<featureName>_android.dart`. Find
   `class MoEngage<featureNameCamel>Android extends MoEngage<featureNameCamel>Platform`.
   For every method just added to the platform interface abstract class, add a matching
   `@override` here, copying the invocation style of the neighboring methods in the same
   file exactly (e.g. `jsonEncode(...)` + the file's own `MethodChannel` field name —
   do not introduce a new pattern or delegate to `MethodChannelMoEngage<featureNameCamel>`).
2. Do the same in `<iosPkgDir>/lib/moengage_<featureName>_ios.dart` for
   `class MoEngage<featureNameCamel>IOS extends MoEngage<featureNameCamel>Platform`.
3. If a method is genuinely not supported on one platform, follow the existing convention
   in that file (e.g. `Logger.v('methodName(): Not supported in iOS Platform')`) instead of
   leaving the abstract default in place silently.
4. **Verify no method falls through to the abstract default**: for each new method name,
   grep both files —
   `grep -n "<methodName>" <androidPkgDir>/lib/*.dart <iosPkgDir>/lib/*.dart` — and confirm
   an `@override` exists in both, not just in `method_channel.dart`.
5. Run `flutter analyze` on `<androidPkgDir>` and `<iosPkgDir>` (and the workspace) to catch
   missing overrides of other abstract methods before committing.

### 3.14 platform_interface.dart (top-level file)
→ See `examples/platform_interface/platform_interface.dart`
Generate at: `<piDir>/lib/moengage_<featureName>_platform_interface.dart`

Rules:
- `export` all internal and model files needed by consumers and by Android/iOS packages
- `typedef <FeatureNameCamel>SyncListener = void Function(<SyncModel>? data)` — only if event methods
- `abstract class MoEngage<featureNameCamel>PlatformInterface extends PlatformInterface`
  - Token + singleton pattern identical to Cards
  - One abstract method per feature method (throw UnimplementedError() as default)
  - `void`, `Future<ModelType>`, or listener-accepting methods depending on type
  - JSDoc comment on every method

### 3.15 pubspec.yaml
→ See `examples/platform_interface/pubspec.yaml`
Copy `packages/moengage_cards/moengage_cards_platform_interface/pubspec.yaml`, then update:
- `name` → `moengage_<featureName>_platform_interface`
- `description` → `A common platform interface for the moengage_<featureName> plugin.`
- `version` → `1.0.0`

### 3.16 Commit
```bash
git add <piDir>/ <androidPkgDir>/lib/ <iosPkgDir>/lib/
git commit -m "<ticketId>: Add Flutter Dart platform interface for <featureName>"
```

---

## Phase 4 — Main Public Package

### 4.1 Create directory structure
```bash
mkdir -p <mainDir>/lib/src
```

### 4.2 public_api.dart
→ See `examples/main_package/public_api.dart`
Generate at: `<mainDir>/lib/src/moengage_<featureName>.dart`

Rules:
- `class MoEngage<featureNameCamel>` with `String _appId` constructor field
- Constructor calls `<FeatureNameCamel>Controller.init()` — only if event methods exist
- `final MoEngage<featureNameCamel>PlatformInterface _platform = MoEngage<featureNameCamel>PlatformInterface.instance`
- One public method per feature method — thin wrapper over `_platform.method(_appId, ...)` with `Logger.v(...)` call
- Fire-and-forget → `void`; result methods → `Future<ModelType>`; event setter → `void set<Xxx>Listener(...)`

### 4.3 lib/moengage_<featureName>.dart
Generate at: `<mainDir>/lib/moengage_<featureName>.dart`
```dart
export 'src/moengage_<featureName>.dart';
export 'package:moengage_<featureName>_platform_interface/moengage_<featureName>_platform_interface.dart';
```

### 4.4 pubspec.yaml
→ See `examples/main_package/pubspec.yaml`
Copy `packages/moengage_cards/moengage_cards/pubspec.yaml`, then update:
- `name` → `moengage_<featureName>`
- `description` → `MoEngage <featureNameCamel> Plugin`
- `version` → `1.0.0`
- `flutter.plugin.platforms.android.default_package` → `moengage_<featureName>_android`
- `flutter.plugin.platforms.ios.default_package` → `moengage_<featureName>_ios`
- `dependencies`:
  - `moengage_<featureName>_android: 1.0.0`
  - `moengage_<featureName>_ios: 1.0.0`
  - `moengage_<featureName>_platform_interface: 1.0.0`

### 4.5 CHANGELOG

Update `<mainDir>/CHANGELOG.md` (the main package changelog that consumers see).

**If the file does not exist**, create it with:
```markdown
# MoEngage <featureNameCamel> Plugin

# Release Date

## Release Version

- [minor] Added support for <feature_description>
```

**If the file already exists** and has a `# Release Date` / `## Release Version` pending block at the top, append to it. Follow the platform-section convention matching the existing Flutter changelogs:
```markdown
# Release Date

## Release Version

- [minor] Added support for <feature_description>
```

If Android and/or iOS entries are already in the pending block (added by bridge steps), append after them. **Do not add a ticket number.**

**If the file exists but has no pending block**, prepend one before the first dated entry.

### 4.6 Commit
```bash
git add <mainDir>/
git commit -m "<ticketId>: Add Flutter Dart public API for <featureName>"
```

---

## Phase 5 — Wire New APIs into the Sample App

Demonstrate the new feature in the top-level sample app at `example/` (the shared Flutter
sample app used across all MoEngage packages — **not** the per-package `example/` stub, which
just points here). This is expected for every Dart interface step; skip only if the user
explicitly says not to.

### 5.1 Import the package

If `<mainDir>`'s package isn't already imported in `example/lib/main.dart`, add:
```dart
import 'package:moengage_<featureName>/moengage_<featureName>.dart';
```
(Skip if `packageDir` is `packages/moengage_flutter` — `moengage_flutter` is already imported
and `_moengagePlugin` already exists.)

### 5.2 Register event listeners *(only if event methods exist)*

In `_MyAppState.initState()` in `example/lib/main.dart`, alongside the other
`_moengagePlugin.setXxxCallbackHandler(...)` calls, register the new listener:
```dart
_moengagePlugin.set<EventNameCamel>CallbackHandler(_on<EventNameCamel>);
```
Add the corresponding top-level handler function near the other `_onXxx` handlers (e.g. next to
`_onLogoutCallbackHandler`):
```dart
void _on<EventNameCamel>(<ModelName> data) {
  debugPrint('$tag Main : _on<EventNameCamel>(): $data');
}
```

### 5.3 Add a demo trigger per hybridToNative / result method

For each fire-and-forget or `Future` method, add one `ListTile` to the `ListView` in
`example/lib/main.dart`, near the other feature demos (e.g. next to the `Logout` tile):
```dart
ListTile(
  title: const Text('<Human-readable label>'),
  onTap: () {
    _moengagePlugin.<methodName>(<placeholder arguments>);
  },
),
```
For `Future`-returning methods, make `onTap` `async` and `debugPrint` the result, following the
`Inbox: Get all messages` tile as the template.

Use realistic placeholder values for arguments (e.g. a dummy token/identifier) — add a
`// TODO: replace with a real value` comment if the value is only a stand-in.

### 5.4 Commit
```bash
git add example/
git commit -m "Demonstrate <featureName> APIs in the sample app"
```

---

## Phase 6 — Update Native Package pubspec files

This phase only covers pubspec *dependency* wiring. The actual Dart method overrides in
`<androidPkgDir>/lib/` and `<iosPkgDir>/lib/` are handled in Phase 3.13 — do not treat this
phase as a substitute for that one.

The Android and iOS pubspec.yaml files generated in earlier steps reference
`moengage_<featureName>_platform_interface: ^1.0.0`. Verify these references are correct.
If native packages were scaffolded without the platform interface dependency, add it now:

```bash
# In moengage_<featureName>_android/pubspec.yaml and moengage_<featureName>_ios/pubspec.yaml
# ensure:
#   dependencies:
#     moengage_<featureName>_platform_interface: ^1.0.0
```

Commit if any changes were needed:
```bash
git add <androidPkgDir>/pubspec.yaml <iosPkgDir>/pubspec.yaml
git commit -m "<ticketId>: Wire platform interface dependency in native packages"
```

---

## Phase 7 — Create / Update Pull Request

```bash
git push -u origin feature/<ticketId>-<contractSuffix>

# Check if PR already exists:
gh pr list --head feature/<ticketId>-<contractSuffix> --json number,url
```

**If PR already exists** (from native bridge steps): push new commits to the same branch. Do
**not** just add a comment and leave the title/body stale — refresh **both** the PR title and
body with `gh pr edit <number>` to the combined template below, so the PR reflects every layer
implemented on the branch (native bridges + Dart), not only what the title said before:
```bash
gh pr edit <number> \
  --title "<ticketId>: Add Flutter <combined layers, e.g. \"Android bridge, iOS bridge, and Dart interface\"> for <featureName>" \
  --body "$(cat <<'EOF'
<combined template below, filled in>
EOF
)"
```

**If no PR exists:**
```bash
gh pr create \
  --title "<ticketId>: Add Flutter Dart interface and public API for <featureName>" \
  --base development \
  --body "$(cat <<'EOF'
## Summary
- Platform interface (`<piDir>/`): abstract class, MethodChannel impl, models, constants, payload mapper
- Public API (`<mainDir>/`): MoEngage<featureNameCamel> class wrapping the platform interface
- Models derived from proto contracts in `<contractDir>/`
- Sample app (`example/`): new APIs wired up with a demo trigger (and listener registration, if events exist)

## Related PRs
- android-plugin-base: <android_plugin_base_pr_url>
- ios-plugin-base: <ios_plugin_base_pr_url>
- Flutter Android bridge: <android_bridge_pr_url>
- Flutter iOS bridge: <ios_bridge_pr_url>

## Contract
Branch: `<contract_branch>` in mobile-sdk-contracts

## Methods
| Method | Type | Dart return |
| ------ | ---- | ----------- |
<table rows from method table>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

---

## Phase 8 — Report

Print:
1. PR URL
2. Full method table (name, type, Dart return type, models involved)
3. All `// TODO` items (model field types to verify, enum string values to confirm)
4. List of all files created or modified

---

## Codebase Reference Files

| What                              | Codebase path                                                                                                   |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| Platform interface abstract class | `packages/moengage_cards/moengage_cards_platform_interface/lib/moengage_cards_platform_interface.dart`          |
| constants.dart                    | `packages/moengage_cards/moengage_cards_platform_interface/lib/src/internal/constants.dart`                     |
| method_channel                    | `packages/moengage_cards/moengage_cards_platform_interface/lib/src/internal/method_channel_moengage_cards.dart` |
| platform_base                     | `packages/moengage_cards/moengage_cards_platform_interface/lib/src/internal/cards_platform.dart`                |
| controller                        | `packages/moengage_cards/moengage_cards_platform_interface/lib/src/internal/cards_controller.dart`              |
| instance_provider                 | `packages/moengage_cards/moengage_cards_platform_interface/lib/src/internal/cards_instance_provider.dart`       |
| callback_cache                    | `packages/moengage_cards/moengage_cards_platform_interface/lib/src/internal/callback_cache.dart`                |
| payload_mapper                    | `packages/moengage_cards/moengage_cards_platform_interface/lib/src/internal/payload_mapper.dart`                |
| model barrel                      | `packages/moengage_cards/moengage_cards_platform_interface/lib/src/model/model.dart`                            |
| SyncCompleteData model            | `packages/moengage_cards/moengage_cards_platform_interface/lib/src/model/sync_data.dart`                        |
| SyncType enum                     | `packages/moengage_cards/moengage_cards_platform_interface/lib/src/model/sync_type.dart`                        |
| platform interface pubspec        | `packages/moengage_cards/moengage_cards_platform_interface/pubspec.yaml`                                        |
| public API class                  | `packages/moengage_cards/moengage_cards/lib/src/moengage_cards.dart`                                            |
| main package pubspec              | `packages/moengage_cards/moengage_cards/pubspec.yaml`                                                           |
| Registered Android impl (extends platform_base directly, NOT method_channel) | `packages/moengage_cards/moengage_cards_android/lib/moengage_cards_android.dart` |
| Registered iOS impl (extends platform_base directly, NOT method_channel)     | `packages/moengage_cards/moengage_cards_ios/lib/moengage_cards_ios.dart`         |
| Real-world example of the missing-override bug this phase prevents | `packages/moengage_flutter/moengage_flutter_android/lib/moengage_flutter_android.dart` and `..._ios/lib/moengage_flutter_ios.dart` — `passAuthenticationDetails` was added only to `method_channel_moengage_flutter.dart` and threw `UnimplementedError` at runtime until overrides were added here too |
| Sample app                        | `example/lib/main.dart` (top-level shared sample app — not the per-package `example/` stub)                     |

---

## Error Handling Rules

- `contract_branch` not found → stop and tell the user
- `contractDir` not found in `json/hybridToNative/` → list available dirs and ask
- `piDir` already has source files → read existing files, add only missing items. This is the common case (adding a method to an existing feature) — Phase 3.13 (updating `<androidPkgDir>`/`<iosPkgDir>`) applies just as much here as for a brand-new package; do not skip it just because the platform interface itself already existed.
- **New method placement**: always insert a new method as the *last* method in the class — after every existing method, never interleaved between existing ones (applies to the platform interface abstract class, the MethodChannel impl, the registered `<androidPkgDir>`/`<iosPkgDir>` classes, and the public API class in `<mainDir>`)
- **Never treat `method_channel.dart` as sufficient on its own.** If asked to "just add the method" without more detail, still perform Phase 3.13 — a method that only exists in `method_channel.dart` is unreachable in a shipped app because the registered Android/iOS classes never delegate to it.
- Proto field type unknown → use `dynamic` and add `// TODO: verify type` comment
- Enum string value unknown → add `// TODO: verify enum value` and use placeholder string
- Push fails → report error and local branch name
- Skip Phase 5 (sample app wiring) only if the user explicitly opts out — otherwise always wire the new APIs into `example/lib/main.dart`
