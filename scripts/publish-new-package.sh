#!/bin/bash
# Lists workspace packages never published on pub.dev, validates each is staged
# at 0.0.1, then publishes them after confirmation. See RELEASING.md.

set -euo pipefail

readonly BOOTSTRAP_VERSION="0.0.1"
readonly PUB_DEV_API="https://pub.dev/api/packages"

readonly CHANGELOG_TEMPLATE='# %s

## %s

- Initial release.
'

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

package_name_of() {
  grep '^name:' "$1/pubspec.yaml" | head -1 | sed 's/^name:[[:space:]]*//'
}

package_version_of() {
  grep '^version:' "$1/pubspec.yaml" | head -1 | sed 's/^version:[[:space:]]*//'
}

is_published_on_pub_dev() {
  local status_code
  status_code=$(curl -s -o /dev/null -w "%{http_code}" "$PUB_DEV_API/$1")
  [ "$status_code" = "200" ]
}

prompt_yes_no() {
  local answer
  while true; do
    read -r -p "$1 [y/n] " answer
    case "$answer" in
      [Yy]) echo "y"; return ;;
      [Nn]) echo "n"; return ;;
      *) echo "Please answer y or n." >&2 ;;
    esac
  done
}

find_candidate_packages() {
  local scope="${1:-}" dir
  if [ -n "$scope" ]; then
    if [ -f "$scope/pubspec.yaml" ]; then
      echo "$scope"
      return
    fi
    for dir in "$scope"/*/; do
      [ -f "${dir}pubspec.yaml" ] && echo "${dir%/}"
    done
    return
  fi

  for dir in packages/*/*/; do
    [ -f "${dir}pubspec.yaml" ] && echo "${dir%/}"
  done
}

list_unpublished_packages() {
  local pkg_path pkg_name
  while IFS= read -r pkg_path; do
    [ -n "$pkg_path" ] || continue
    pkg_name=$(package_name_of "$pkg_path")
    if is_published_on_pub_dev "$pkg_name"; then
      echo "skip: '$pkg_name' is already published on pub.dev." >&2
    else
      echo "$pkg_path"
    fi
  done
}

validate_staged_at_bootstrap_version() {
  local pkg_path="$1" pkg_name="$2" found

  found=$(package_version_of "$pkg_path")
  if [ "$found" != "$BOOTSTRAP_VERSION" ]; then
    fail "'$pkg_name' is unpublished but $pkg_path/pubspec.yaml has version" \
         "'$found', not '$BOOTSTRAP_VERSION'. Set 'version: $BOOTSTRAP_VERSION'" \
         "there before running this script."
  fi
}

write_initial_changelog() {
  local pkg_path="$1"
  [ -f "$pkg_path/CHANGELOG.md" ] || return 0
  printf "$CHANGELOG_TEMPLATE" "$(date +%d-%m-%Y)" "$BOOTSTRAP_VERSION" \
    > "$pkg_path/CHANGELOG.md"
}

main() {
  cd "$(dirname "$0")/.." || exit 1
  local scope="${1:-}"

  echo "== Step 1/4: finding candidate packages under '${scope:-the whole workspace}' =="
  local candidates
  candidates=$(find_candidate_packages "$scope")
  [ -n "$candidates" ] || fail "no packages found under '${scope:-packages}'."

  echo ""
  echo "== Step 2/4: checking pub.dev for each candidate =="
  local unpublished
  unpublished=$(printf '%s\n' "$candidates" | list_unpublished_packages)
  if [ -z "$unpublished" ]; then
    echo "Every candidate package is already published on pub.dev. Nothing to do."
    exit 0
  fi

  local pkg_paths=() pkg_names=()
  while IFS= read -r pkg_path; do
    pkg_paths+=("$pkg_path")
    pkg_names+=("$(package_name_of "$pkg_path")")
  done <<< "$unpublished"

  echo ""
  echo "Unpublished packages found (will be bootstrap-published at $BOOTSTRAP_VERSION):"
  local i
  for i in "${!pkg_names[@]}"; do
    echo "  - ${pkg_names[$i]}  (${pkg_paths[$i]})"
  done

  echo ""
  echo "== Step 3/4: validating each is staged at $BOOTSTRAP_VERSION =="
  for i in "${!pkg_paths[@]}"; do
    validate_staged_at_bootstrap_version "${pkg_paths[$i]}" "${pkg_names[$i]}"
  done
  echo "OK - every unpublished package is staged at $BOOTSTRAP_VERSION."

  echo ""
  echo "== Step 4/4: preparing CHANGELOG.md, dry-run, then publish =="
  for pkg_path in "${pkg_paths[@]}"; do
    write_initial_changelog "$pkg_path"
  done

  echo ""
  echo "Refreshing workspace pub resolution..."
  flutter pub get

  for pkg_path in "${pkg_paths[@]}"; do
    echo ""
    echo "-- Dry-run publish: $pkg_path --"
    (cd "$pkg_path" && dart pub publish --dry-run) || true
  done

  echo ""
  echo "Logging in to pub.dev (token-based, human account - opens a browser if needed)."
  dart pub login

  echo ""
  if [ "$(prompt_yes_no "Dry-runs above look correct. Publish all ${#pkg_names[@]} package(s) at $BOOTSTRAP_VERSION to pub.dev now?")" = "n" ]; then
    echo "Aborted before publishing. The CHANGELOG.md edit above is uncommitted -"
    echo "discard it (e.g. 'git checkout') or just re-run this script when ready."
    exit 0
  fi

  for i in "${!pkg_paths[@]}"; do
    echo ""
    echo "-- Publishing ${pkg_names[$i]} $BOOTSTRAP_VERSION --"
    (cd "${pkg_paths[$i]}" && dart pub publish --force)
  done

  echo ""
  echo "Published: ${pkg_names[*]} at $BOOTSTRAP_VERSION. No git tag, commit, or push was made."
  echo "The CHANGELOG.md edit above is uncommitted - ignore/discard it, your real entry is already in git. See RELEASING.md for the remaining pub.dev/CD hand-off steps."
}

main "$@"
