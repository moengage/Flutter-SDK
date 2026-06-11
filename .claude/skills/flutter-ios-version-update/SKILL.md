---
name: flutter-ios-version-update
description: >
  Updates the iOS plugin dependency version for one or more Flutter MoEngage SDK packages.
  For each specified package, updates two files: the podspec (s.dependency version) and
  Package.swift (exact: version). Also prepends a CHANGELOG entry to the iOS package
  CHANGELOG and to the parent (main) package CHANGELOG.
  Use this when a new ios-plugin-base or feature-specific iOS plugin version is released.
parameters:
  - name: "ticket_id"
    description: "JIRA ticket ID, e.g. 'MOEN-44072'. Extracted from command text if not supplied."
    optional: true
  - name: "packages"
    description: "Comma-separated list of package names to update. E.g. 'moengage_flutter,moengage_cards'. If 'all', updates every package."
  - name: "ios_plugin_version"
    description: "New iOS plugin version to set. E.g. '7.0.0'."
  - name: "changelog_description"
    description: "One-line changelog entry describing the update. E.g. 'Updated MoEngage-iOS-SDK to 10.10.2'."
---

## Overview

Updates the iOS plugin dependency version inside the Flutter SDK repo (`Flutter-SDK`) for one
or more packages. Touches exactly **4 files per package**: podspec, Package.swift, iOS package
CHANGELOG, main package CHANGELOG.

**This is the single source of truth for iOS version updates.** All other skills that accept
`ios_plugin_version` delegate here when the package already exists:
- `flutter-ios-bridge-implementation` §3.7 → delegates here for existing packages
- `flutter-feature-implementation` Step 2 → inherits via the iOS bridge step

Do **not** duplicate version-update logic in any other skill.

**Package → file mapping:**

| `packageName`          | podspec path                                                                                  | Package.swift path                                                                                  | iOS CHANGELOG                                                         | Main CHANGELOG                                                    |
| ---------------------- | --------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | ----------------------------------------------------------------- |
| `moengage_flutter`     | `packages/moengage_flutter/moengage_flutter_ios/ios/moengage_flutter_ios.podspec`             | `packages/moengage_flutter/moengage_flutter_ios/ios/moengage_flutter_ios/Package.swift`             | `packages/moengage_flutter/moengage_flutter_ios/CHANGELOG.md`         | `packages/moengage_flutter/moengage_flutter/CHANGELOG.md`         |
| `moengage_cards`       | `packages/moengage_cards/moengage_cards_ios/ios/moengage_cards_ios.podspec`                   | `packages/moengage_cards/moengage_cards_ios/ios/moengage_cards_ios/Package.swift`                   | `packages/moengage_cards/moengage_cards_ios/CHANGELOG.md`             | `packages/moengage_cards/moengage_cards/CHANGELOG.md`             |
| `moengage_geofence`    | `packages/moengage_geofence/moengage_geofence_ios/ios/moengage_geofence_ios.podspec`          | `packages/moengage_geofence/moengage_geofence_ios/ios/moengage_geofence_ios/Package.swift`          | `packages/moengage_geofence/moengage_geofence_ios/CHANGELOG.md`       | `packages/moengage_geofence/moengage_geofence/CHANGELOG.md`       |
| `moengage_inbox`       | `packages/moengage_inbox/moengage_inbox_ios/ios/moengage_inbox_ios.podspec`                   | `packages/moengage_inbox/moengage_inbox_ios/ios/moengage_inbox_ios/Package.swift`                   | `packages/moengage_inbox/moengage_inbox_ios/CHANGELOG.md`             | `packages/moengage_inbox/moengage_inbox/CHANGELOG.md`             |
| `moengage_personalize` | `packages/moengage_personalize/moengage_personalize_ios/ios/moengage_personalize_ios.podspec` | `packages/moengage_personalize/moengage_personalize_ios/ios/moengage_personalize_ios/Package.swift` | `packages/moengage_personalize/moengage_personalize_ios/CHANGELOG.md` | `packages/moengage_personalize/moengage_personalize/CHANGELOG.md` |

**Package → GitHub repo URL (for Package.swift):**

| `packageName`          | GitHub URL                                                 |
| ---------------------- | ---------------------------------------------------------- |
| `moengage_flutter`     | `https://github.com/moengage/iOS-PluginBase.git`           |
| `moengage_cards`       | `https://github.com/moengage/apple-plugin-cards.git`       |
| `moengage_geofence`    | `https://github.com/moengage/apple-plugin-geofence.git`    |
| `moengage_inbox`       | `https://github.com/moengage/apple-plugin-inbox.git`       |
| `moengage_personalize` | `https://github.com/moengage/apple-plugin-personalize.git` |

---

## Phase 0 — Clarify Inputs

### 0.1 Extract ticket ID
Scan the user's full command for `MOEN-\d+` → **`ticketId`**.
If not found, ask before proceeding.

### 0.2 Resolve package list
- If `packages` = `all` → process every package in the mapping table above.
- Otherwise split by comma → process only the listed packages.
- For each unknown package name → warn and skip.

---

## Phase 1 — Check out / create branch

```bash
cd Flutter-SDK
git fetch
git checkout -b feature/<ticketId>-ios-version-update
```

If the branch already exists:
```bash
git checkout feature/<ticketId>-ios-version-update
```

---

## Phase 2 — Update files (repeat for each package)

### 2.1 podspec — update dependency version

Read the podspec, find the `s.dependency` line for the iOS plugin, update to `<ios_plugin_version>`.

```
# Before:
s.dependency 'MoEngagePluginCards', '3.9.0'

# After:
s.dependency 'MoEngagePluginCards', '7.0.0'
```

Rules:
- Find the line matching `s.dependency 'MoEngage.*', '.*'` (not `Flutter`, not `React`)
- Replace only the version string — do not change the pod name or anything else

### 2.2 Package.swift — update exact version

Read Package.swift, find the `.package(url: "<githubUrl>", exact: "...")` line, update to `<ios_plugin_version>`.

```swift
// Before:
.package(url: "https://github.com/moengage/apple-plugin-cards.git", exact: "3.9.0"),

// After:
.package(url: "https://github.com/moengage/apple-plugin-cards.git", exact: "7.0.0"),
```

Rules:
- Match by the GitHub URL from the mapping table — do not change the URL
- Replace only the version string in `exact: "..."`
- Do not touch the commented-out `// .package(path: ...)` line

### 2.3 iOS package CHANGELOG.md — prepend entry

Read the iOS package CHANGELOG. Find the line immediately after the title (`# MoEngage <X> iOS Plugin`).

**If the next section is already `# Release Date` / `## Release Version`** (i.e. a pending unreleased block exists):
- Append the new bullet under the existing `## Release Version` block.

**If no pending block exists** (next line is a dated release like `# 11-02-2026`):
- Insert a new pending block before the dated release.

Format to insert/append:
```markdown
# Release Date

## Release Version

- [patch] <changelog_description>
```

Example result at top of file (new block):
```markdown
# MoEngage Cards iOS Plugin

# Release Date

## Release Version

- [patch] Updated MoEngagePluginCards to `7.0.0`

# 07-05-2026

## 5.4.0
...
```

### 2.4 Main package CHANGELOG.md — prepend iOS bullet

Read the main package CHANGELOG. Find or create the `# Release Date` / `## Release Version` pending block (same logic as §2.3).

Add an iOS bullet under the block. If an `- iOS` section already exists in the block, append to it. If not, add a new `- iOS` section:

```markdown
# Release Date

## Release Version

- iOS
  - [patch] <changelog_description>
```

If an Android bullet is already present, place iOS after it:
```markdown
# Release Date

## Release Version

- Android
  - [minor] `android-bom` version updated to `x.x.x`
- iOS
  - [patch] <changelog_description>
```

---

## Phase 3 — Commit

```bash
git add packages/<packageName>/
git commit -m "<ticketId>: Update iOS plugin version to <ios_plugin_version> for <packageName>"
```

One commit per package, or a single combined commit if updating multiple packages in one run:

```bash
git add packages/
git commit -m "<ticketId>: Update iOS plugin versions to <ios_plugin_version>"
```

---

## Phase 4 — Push and create PR

```bash
git push -u origin feature/<ticketId>-ios-version-update

gh pr create \
  --title "<ticketId>: Update Flutter iOS plugin version to <ios_plugin_version>" \
  --base development \
  --body "$(cat <<'EOF'
## Summary
- Updated iOS plugin dependency to `<ios_plugin_version>` for: <comma-separated package list>
- Updated podspec `s.dependency` version in each iOS package
- Updated `Package.swift` `exact:` version in each iOS package
- Updated CHANGELOG in iOS packages and main packages

## Packages Updated
| Package | podspec | Package.swift |
| ------- | ------- | ------------- |
<one row per package>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

---

## Phase 5 — Report

Print:
1. PR URL
2. Table of all files modified (package → podspec, Package.swift, iOS CHANGELOG, main CHANGELOG)
3. Any packages skipped and why

---

## Error Handling Rules

- Package name not in mapping table → warn user, skip that package, continue with others
- podspec not found at expected path → report error, skip that package
- Package.swift not found at expected path → report error, skip that package
- Version string already matches `<ios_plugin_version>` → skip that file, note in report
- Push fails → report error and local branch name so user can push manually
