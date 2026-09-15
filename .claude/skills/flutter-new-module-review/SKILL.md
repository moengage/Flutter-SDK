---
name: flutter-new-module-review
description: >
  Reviews a PR/branch/diff that adds a new Flutter SDK module or package under
  packages/ (either a full federated plugin - app-facing + _android + _ios +
  _platform_interface - or a single Dart-only package) for completeness: workspace
  registration, release-automation registration, federated plugin wiring, package
  metadata, example-app wiring, tests, and pub.dev/CI publish readiness. Reports
  missing pieces via ReportFindings, most-severe first. Use this whenever a
  PR/branch/diff adds a new directory under packages/, or when asked to review a
  "new module" or "new package" PR. Not a general bug-hunting review - use
  code-review for that.
parameters:
  - name: "target"
    description: "PR number, branch name, or 'diff' for the working tree diff against development. Defaults to the current diff against development if not supplied."
    optional: true
---

## Overview

New modules in this repo fail in two different, easy-to-miss ways when a step is
skipped:

1. **Silently absent** - e.g. forgetting to register a package in the workspace
   means `melos bootstrap`/`flutter pub get` doesn't just skip it, it breaks
   dependency resolution for every package that depends on it.
2. **Silently broken at release time** - e.g. forgetting to register it in
   `flutter-utils.main.kts` means the release automation doesn't know to version-bump
   or publish it, and it never surfaces as an error until someone notices the
   package is stuck on `0.0.1` weeks later.

This skill's job is to catch both classes *before merge*, by checking the new
module against every place this repo requires a new package to be wired in.

## Step 0 - identify what's new

Get the diff for `target` (PR number via `gh pr diff <n>`, a branch via
`git diff development...<branch>`, or the working tree via
`git diff development...HEAD`). From it, find:

- every new directory under `packages/<group>/<package>/` (a new `pubspec.yaml`
  is the reliable signal - renames/moves are not "new")
- for each, whether it's an **app-facing package** (has a `lib/` with a public API
  class, no `flutter: plugin: platforms:` pointing at itself), a **platform
  implementation** (`_android`/`_ios` suffix), a **platform interface**
  (`_platform_interface` suffix), or a **standalone Dart-only package** (no
  federated siblings at all - check whether `_android`/`_ios`/
  `_platform_interface` siblings exist under the same group folder)

Group findings per new module (a "module" = the app-facing package + whichever
federated siblings it has), not per file.

## Checklist

For each new module, check every item below. Read the actual files - don't infer
compliance from file names alone.

### 1. Workspace registration (blocks `melos bootstrap`/`pub get` for everyone if missing)

- [ ] Every new package path is listed under `workspace:` in the root `pubspec.yaml`
      (not just the app-facing one - every federated sibling too).
- [ ] Every new package's own `pubspec.yaml` has `resolution: workspace`.

**Why this is severity-high, not a style nit:** if package B depends on new
package A and A isn't in the root `workspace:` list, pub tries to fetch A from
pub.dev (where it doesn't exist) instead of resolving it locally - `flutter pub
get`/`melos bootstrap` fails for the *whole workspace*, not just A. This is the
literal mechanism behind "adding a new module breaks CI."

### 2. Release-automation registration (blocks release, doesn't block CI)

In `.github/scripts/flutter-utils.main.kts`:

- [ ] Every new package has an entry in `packageParentFolder` mapping to its group
      folder name.
- [ ] Every new package has an entry in `dependencyMapping`:
  - the app-facing package maps its `_android`/`_ios`/`_platform_interface`
    siblings as `"pinned"` and `moengage_flutter` as `"incremental"`
  - each platform implementation maps its `_platform_interface` sibling and
    `moengage_flutter` as `"incremental"`
  - the platform interface maps `moengage_flutter` as `"incremental"`
  - a standalone Dart-only package (no siblings) just needs its own entry with
    whatever it actually depends on

Missing this doesn't fail CI - it fails *silently* at release time: pre-release
automation won't know to version-bump the package, so it never gets released
until someone notices.

### 3. Package metadata (per new package)

- [ ] `pubspec.yaml` has `name`, `description`, `version`, `homepage`, `environment`
- [ ] **`version:` is exactly `0.0.1`** for every new (never-published) package -
      not `0.1.0`, not `1.0.0`. This is a hard requirement, not a preference:
      `scripts/publish-new-package.sh` refuses to bootstrap-publish any
      unpublished package whose `pubspec.yaml` version isn't `0.0.1`, and throws
      an error instead of fixing it for you. Flag any new package pinned at a
      different starting version as a blocking finding, and check that every
      *other* package's dependency on it (pinned or caret) is consistent with
      `0.0.1`/`^0.0.1` too.
- [ ] `LICENSE` present (standard MoEngage license text - compare against a sibling
      package's `LICENSE`, don't accept a placeholder)
- [ ] `README.md` present, with an SDK-installation snippet
- [ ] `CHANGELOG.md` present, using the placeholder convention from `RELEASING.md`:
      a `# Release Date` / `## Release Version` header followed by at least one
      `- [major|minor|patch] TICKET-ID: <content>` bullet
- [ ] if the app-facing package ships a `config.json` (version marker asset), it's
      declared under `flutter: assets:` in its `pubspec.yaml` - `config.json` is
      optional, and `scripts/publish-new-package.sh` doesn't check or touch it,
      but keeping its version in sync with `pubspec.yaml`'s `0.0.1` is a
      nice-to-have for consistency

### 4. Federated plugin wiring (skip this section for a standalone Dart-only package)

- [ ] App-facing package's `pubspec.yaml` has
      `flutter: plugin: platforms: android/ios: default_package: <..._android/_ios>`
- [ ] `_android` package's `pubspec.yaml` has
      `flutter: plugin: implements: <app-facing-name>` and
      `platforms: android: package/pluginClass/dartPluginClass` all set
- [ ] `_android/android/build.gradle` exists, with the same AGP/Kotlin/compileSdk
      scaffolding as an existing sibling module (e.g. `moengage_inbox_android`'s),
      and `namespace` matches the Kotlin package
- [ ] `_android/android/src/main/AndroidManifest.xml` package matches that namespace
- [ ] `_ios` package's `pubspec.yaml` has `flutter: plugin: implements: <app-facing-name>`
      and `platforms: ios: pluginClass/dartPluginClass` set
- [ ] `_ios/ios/<name>.podspec` and `.../Package.swift` both exist and reference the
      same deployment target (`13.0`) used elsewhere in the repo
- [ ] `_platform_interface` package exposes an `abstract class ...Platform extends
      PlatformInterface` using the singleton-token pattern (private static `_token`,
      `instance` getter/setter calling `PlatformInterface.verify`) - not a bare
      abstract class without that guard
- [ ] The app-facing Dart class calls through `<X>Platform.instance.<method>()` -
      it does **not** construct its own `MethodChannel` directly (that's the
      platform interface/implementations' job, not the app-facing package's)
- [ ] `_android`'s and `_ios`'s Dart wrapper classes (`MoEngage<X>Android`/`...IOS`)
      each have a `static void registerWith()` and are only ever a fallback -
      confirm they actually override every method the platform interface declares,
      not a partial subset (a missed override silently falls through to the
      method-channel default, which usually throws `UnimplementedError` at runtime)

### 5. pub.dev / CI publish readiness

- [ ] Because this module has never been published, confirm `RELEASING.md`'s
      "Publishing a brand-new module" flow applies and is referenced/understood by
      the PR author - it is **not** something this PR itself needs to run (that
      happens locally, after merge, via `scripts/publish-new-package.sh`)
- [ ] Cross-check that every new package name registered in step 2 above will
      actually be recognized as "never published" by `isPublishedOnPubDev()` in
      `flutter-utils.main.kts` - i.e. the package name in `pubspec.yaml` is the
      exact name that will be queried against `https://pub.dev/api/packages/<name>`

### 6. Example app wiring (expected unless the PR explicitly says this module isn't user-demoable)

- [ ] `example/pubspec.yaml` has a dependency entry for the app-facing package
- [ ] `example/lib/main.dart` imports it, holds an instance, and has at least one
      `ListTile`/trigger that exercises it end-to-end (so `flutter build apk`/`ipa`
      in CI actually compiles against the new module, not just `flutter analyze`)

### 7. Tests

- [ ] Every new package has a `test/` directory with at least a placeholder test
      (CI's `melos unittest` selects packages with a `test/` dir - a missing one
      isn't an error, it's just silently never run)
- [ ] The platform interface package's method-channel implementation has a real
      test (mock `MethodChannel.setMockMethodCallHandler`), not just a placeholder
- [ ] The app-facing package's test sets a fake `<X>Platform.instance` rather than
      hitting a real method channel

## Reporting

Report findings with `ReportFindings`, most-severe first:

- **Missing workspace registration (§1)** and **missing release-automation
  registration (§2)** are always the highest-severity findings - they have
  repo-wide blast radius (breaks everyone's `pub get`, or silently strands the
  package unreleased).
- Missing federated wiring (§4) that would cause a runtime `UnimplementedError`
  (a platform implementation not overriding a method the interface declares) is
  next.
- Missing metadata/tests/example wiring (§3, §6, §7) are lower-severity but still
  worth flagging - use `category: "completeness"`.

For each finding, set `file` to the actual file that's missing the change (or
where it should be added if the file doesn't exist yet), and `failure_scenario` to
the concrete consequence (e.g. "flutter pub get fails workspace-wide with a
version-solving error because moengage_sample_ios isn't in the root workspace
list" - not just "not registered").

If every check passes, report an empty findings list - don't invent nitpicks to
avoid an empty report.
