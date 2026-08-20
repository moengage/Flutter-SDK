#!/bin/bash
# Bootstraps brand-new (never-published) MoEngage Flutter SDK package(s) by
# publishing their FIRST version - fixed at 0.0.1 - to pub.dev directly from
# a human's machine.
#
# Why this exists / why it can't be done in CI:
# pub.dev refuses to let automated publishing (the Google service-account /
# `dart pub token add` flow used by .github/workflows/release-plugins.yml, and
# GitHub OIDC automated publishing too) create a package that has never been
# published before:
#   "Today, you can only automate publishing of existing packages. To create
#    a new package, you must publish the first version using `dart pub publish`."
#   - https://dart.dev/tools/pub/automated-publishing
# So the very first version of a new module has to be published once, by hand,
# by a human who is a member of the `moengage.com` verified pub.dev publisher,
# authenticated via `dart pub login` (token-based OAuth session) rather than
# the CI service account.
#
# What this script does, for every workspace package that has never been
# published (skips anything already on pub.dev - "release only unpublished
# modules"):
#   1. Sets its pubspec.yaml version to 0.0.1 (and config.json's, if present).
#   2. Re-points any *other* workspace package's dependency on it - pinned
#      (`name: 1.2.3`) or caret (`name: ^1.2.3`) - to 0.0.1 / ^0.0.1, so the
#      workspace still resolves.
#   3. Appends a dated "# <today> / ## 0.0.1" CHANGELOG entry recording the
#      bootstrap publish. The existing pending "# Release Date" / "## Release
#      Version" placeholder (with its real [major]/[minor]/[patch] entry) is
#      left untouched - that's what the next CD release will consume.
#   4. Runs `dart pub publish --dry-run` for review, then (after one
#      confirmation) `dart pub publish --force` for real.
#
# What this script deliberately does NOT do:
#   - No git tag is created for this bootstrap 0.0.1 release.
#   - No git commit or push - review the changes with `git diff` and commit
#     them yourself.
#   - No version bump beyond 0.0.1 - the real release (whatever version the
#     pending CHANGELOG entry's [major]/[minor]/[patch] marker implies, e.g.
#     1.0.0 for a first real release) happens afterwards through the normal
#     "Release Plugins" CD workflow, since the package now exists on pub.dev
#     and its automated-publishing credentials work from here on.
#
# Usage:
#   scripts/publish-new-package.sh                              # scan the whole workspace
#   scripts/publish-new-package.sh packages/moengage_sample      # scope to one module's packages
#   scripts/publish-new-package.sh packages/moengage_sample/moengage_sample_android  # scope to one package
#
# See RELEASING.md for the full new-module publish flow.

set -euo pipefail

ORIGINAL_DIR=$(pwd)
cd "$(dirname "$0")/.." || exit 1
REPO_ROOT=$(pwd)
TODAY=$(date +%d-%m-%Y)

cleanup() {
  cd "$ORIGINAL_DIR" || true
}
trap cleanup EXIT

# ---- 1. Find candidate package directories --------------------------------

CANDIDATES=()
if [ -n "${1:-}" ]; then
  if [ -f "$1/pubspec.yaml" ]; then
    CANDIDATES=("$1")
  else
    for dir in "$1"/*/; do
      [ -f "${dir}pubspec.yaml" ] && CANDIDATES+=("${dir%/}")
    done
  fi
else
  for dir in packages/*/*/; do
    [ -f "${dir}pubspec.yaml" ] && CANDIDATES+=("${dir%/}")
  done
fi

if [ ${#CANDIDATES[@]} -eq 0 ]; then
  echo "No packages found under '${1:-packages}'."
  exit 1
fi

# ---- 2. Filter to packages never published on pub.dev ----------------------

TO_BOOTSTRAP_PATHS=()
TO_BOOTSTRAP_NAMES=()
for pkg_path in "${CANDIDATES[@]}"; do
  pkg_name=$(grep '^name:' "$pkg_path/pubspec.yaml" | head -1 | sed 's/^name:[[:space:]]*//')
  status_code=$(curl -s -o /dev/null -w "%{http_code}" "https://pub.dev/api/packages/$pkg_name")
  if [ "$status_code" = "200" ]; then
    echo "skip: '$pkg_name' is already published - nothing to bootstrap."
  else
    TO_BOOTSTRAP_PATHS+=("$pkg_path")
    TO_BOOTSTRAP_NAMES+=("$pkg_name")
  fi
done

if [ ${#TO_BOOTSTRAP_NAMES[@]} -eq 0 ]; then
  echo "Every package under '${1:-packages}' is already published. Nothing to do."
  exit 0
fi

echo ""
echo "Will bootstrap-publish these never-published package(s) at version 0.0.1:"
for name in "${TO_BOOTSTRAP_NAMES[@]}"; do
  echo "  - $name"
done
echo ""

# ---- 3. Update pubspec.yaml / config.json / CHANGELOG.md for each ----------

for pkg_path in "${TO_BOOTSTRAP_PATHS[@]}"; do
  echo "Updating metadata for $pkg_path ..."

  # version: <anything> -> version: 0.0.1
  sed -i '' 's/^version:.*/version: 0.0.1/' "$pkg_path/pubspec.yaml"

  if [ -f "$pkg_path/config.json" ]; then
    sed -i '' 's/"version":[[:space:]]*"[^"]*"/"version": "0.0.1"/' "$pkg_path/config.json"
  fi

  if [ -f "$pkg_path/CHANGELOG.md" ]; then
    # Insert a dated "0.0.1" entry right after the pending placeholder's
    # content (before the next top-level "# " heading, or at EOF if there
    # isn't one yet). The placeholder itself, and the real pending
    # [major]/[minor]/[patch] entry under it, are left untouched.
    awk -v date="$TODAY" '
      BEGIN { seen=0; inserted=0 }
      /^## Release Version/ { seen=1; print; next }
      seen && /^# / && !inserted {
        print "# " date
        print ""
        print "## 0.0.1"
        print ""
        print "- Initial pub.dev package registration (bootstrap publish - see RELEASING.md)."
        print ""
        inserted=1
        print
        next
      }
      { print }
      END {
        if (seen && !inserted) {
          print ""
          print "# " date
          print ""
          print "## 0.0.1"
          print ""
          print "- Initial pub.dev package registration (bootstrap publish - see RELEASING.md)."
        }
      }
    ' "$pkg_path/CHANGELOG.md" > "$pkg_path/CHANGELOG.md.tmp"
    mv "$pkg_path/CHANGELOG.md.tmp" "$pkg_path/CHANGELOG.md"
  fi
done

# ---- 4. Re-point any workspace package's dependency on a bootstrapped ------
#         package (pinned or caret) to the new 0.0.1 version.

ALL_PUBSPECS=(packages/*/*/pubspec.yaml example/pubspec.yaml example_spm/pubspec.yaml)
for i in "${!TO_BOOTSTRAP_NAMES[@]}"; do
  dep_name="${TO_BOOTSTRAP_NAMES[$i]}"
  for pubspec in "${ALL_PUBSPECS[@]}"; do
    [ -f "$pubspec" ] || continue
    sed -i '' \
      -e "s/^\([[:space:]]*\)$dep_name:[[:space:]]*[0-9][^[:space:]]*$/\1$dep_name: 0.0.1/" \
      -e "s/^\([[:space:]]*\)$dep_name:[[:space:]]*\^[0-9][^[:space:]]*$/\1$dep_name: ^0.0.1/" \
      "$pubspec"
  done
done

echo ""
echo "== Refreshing workspace pub resolution =="
flutter pub get

# ---- 5. Dry-run, confirm once, then publish for real ------------------------

for pkg_path in "${TO_BOOTSTRAP_PATHS[@]}"; do
  echo ""
  echo "== Dry-run publish: $pkg_path =="
  (cd "$pkg_path" && dart pub publish --dry-run)
done

echo ""
echo "== Logging in to pub.dev (token-based, human account - opens a browser if not already logged in) =="
dart pub login

echo ""
read -r -p "Dry-runs above look correct. Publish ALL ${#TO_BOOTSTRAP_NAMES[@]} package(s) above at 0.0.1 to pub.dev for real now? [y/N] " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "Aborted before publishing. The metadata edits above are still on disk (uncommitted) - review with 'git diff', then re-run this script, or 'git checkout' to discard them."
  exit 0
fi

for i in "${!TO_BOOTSTRAP_PATHS[@]}"; do
  pkg_path="${TO_BOOTSTRAP_PATHS[$i]}"
  pkg_name="${TO_BOOTSTRAP_NAMES[$i]}"
  echo ""
  echo "== Publishing $pkg_name 0.0.1 =="
  (cd "$pkg_path" && dart pub publish --force)
done

echo ""
echo "✅ Published: ${TO_BOOTSTRAP_NAMES[*]}"
echo ""
echo "No git tag, commit, or push was made. Next steps:"
echo "  1. Review the working tree ('git diff') and commit the version/CHANGELOG changes."
echo "  2. On https://pub.dev/packages/<name>/admin for each package above, enable"
echo "     'Automated publishing' for moengage/Flutter-SDK's release-plugins.yml"
echo "     (or add the release service account as an uploader)."
echo "  3. Merge as usual, then trigger the 'Release Plugins' CD workflow from"
echo "     'development' - it will read the still-pending [major]/[minor]/[patch]"
echo "     CHANGELOG entry for each package and publish the real release version"
echo "     (e.g. 1.0.0 for a first real release) automatically."
