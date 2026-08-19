#!/bin/bash
# Publishes the FIRST version of a brand-new Flutter SDK package to pub.dev.
#
# Why this script exists:
# pub.dev refuses to let automated publishing (the Google service-account /
# `dart pub token add` flow used by .github/workflows/release-plugins.yml)
# create a package that has never been published before:
#   "Today, you can only automate publishing of existing packages. To create
#    a new package, you must publish the first version using `dart pub publish`."
#   - https://dart.dev/tools/pub/automated-publishing
#
# So the very first release of a new module (e.g. moengage_sample) has to be
# done once, by hand, by a human who is a member of the `moengage.com`
# verified pub.dev publisher, authenticated via `dart pub login` (token-based
# OAuth session) rather than the CI service account. This script wraps that
# one-time flow so it isn't done ad-hoc.
#
# After this script succeeds once for a package, ask a pub.dev publisher-admin
# to enable "Automated publishing" (or add the release service account as an
# uploader) for that package on https://pub.dev - from then on
# release-plugins.yml will publish subsequent versions automatically, and
# .github/scripts/release.main.kts will stop skipping it.
#
# Usage:
#   scripts/publish-new-package.sh packages/moengage_sample/moengage_sample

set -euo pipefail

ORIGINAL_DIR=$(pwd)
cd "$(dirname "$0")/.." || exit 1
REPO_ROOT=$(pwd)

PACKAGE_PATH="${1:-}"
if [ -z "$PACKAGE_PATH" ]; then
  echo "Usage: $0 <path-to-package>  (e.g. packages/moengage_sample/moengage_sample)"
  cd "$ORIGINAL_DIR" || exit 1
  exit 1
fi

if [ ! -f "$REPO_ROOT/$PACKAGE_PATH/pubspec.yaml" ]; then
  echo "No pubspec.yaml found at $PACKAGE_PATH - check the path."
  cd "$ORIGINAL_DIR" || exit 1
  exit 1
fi

PACKAGE_NAME=$(grep '^name:' "$REPO_ROOT/$PACKAGE_PATH/pubspec.yaml" | head -1 | sed 's/^name:[[:space:]]*//')
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://pub.dev/api/packages/$PACKAGE_NAME")
if [ "$STATUS_CODE" = "200" ]; then
  echo "'$PACKAGE_NAME' is already published on pub.dev - this script is only for a package's"
  echo "first-ever release. Subsequent releases go through the normal release-plugins.yml flow."
  cd "$ORIGINAL_DIR" || exit 1
  exit 1
fi

echo "== Logging in to pub.dev (token-based, human account - opens a browser if not already logged in) =="
dart pub login

echo ""
echo "== Dry-run publish of '$PACKAGE_NAME' from $PACKAGE_PATH =="
(cd "$PACKAGE_PATH" && dart pub publish --dry-run)

echo ""
read -r -p "Dry-run looks correct above. Publish '$PACKAGE_NAME' to pub.dev for real now? [y/N] " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "Aborted. Nothing was published."
  cd "$ORIGINAL_DIR" || exit 1
  exit 0
fi

(cd "$PACKAGE_PATH" && dart pub publish)

echo ""
echo "✅ Published the first version of '$PACKAGE_NAME'."
echo "Next step: on https://pub.dev/packages/$PACKAGE_NAME/admin, enable 'Automated publishing'"
echo "for moengage/Flutter-SDK's release-plugins.yml (or add the release service account as an"
echo "uploader), so future versions publish automatically via the normal release workflow."

cd "$ORIGINAL_DIR" || exit 1
