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
  status_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 --retry 2 "$PUB_DEV_API/$1")
  if [ -z "$status_code" ] || [ "$status_code" = "000" ]; then
    fail "could not reach pub.dev to check whether '$1' is published (network error or" \
         "timeout) - aborting rather than risk treating it as never-published."
  fi
  [ "$status_code" = "200" ]
}

prompt_yes_no() {
  local answer
  while true; do
    # 'read' returns non-zero without setting answer on EOF
    if ! read -r -p "$1 [y/n] " answer; then
      echo "No input on stdin - treating as 'n'." >&2
      echo "n"
      return 0
    fi
    case "$answer" in
      [Yy]) echo "y"; return 0 ;;
      [Nn]) echo "n"; return 0 ;;
      *) echo "Please answer y or n." >&2 ;;
    esac
  done
}

find_candidate_packages() {
  local scope="${1:-}" dir
  if [ -n "$scope" ]; then
    if [ -f "$scope/pubspec.yaml" ]; then
      echo "$scope"
      return 0
    fi
    for dir in "$scope"/*/; do
      [ -f "${dir}pubspec.yaml" ] && echo "${dir%/}"
    done
    # Explicit: the loop's last '&&' is false for any non-package dir, and under 'set -e' a
    # failing command substitution would abort the caller's assignment silently.
    return 0
  fi

  for dir in packages/*/*/; do
    [ -f "${dir}pubspec.yaml" ] && echo "${dir%/}"
  done
  return 0
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

CHANGELOG_FILES=()
CHANGELOG_BACKUPS=()

# The CHANGELOG.md rewrite below exists only to satisfy pub.dev's publish validation - the real
# [major]/[minor]/[patch] entry is already committed and is what pre-release.main.kts reads.
# Restore it on exit so a forgotten 'git checkout --' can't wipe that marker.
restore_changelogs() {
  local i
  [ "${#CHANGELOG_FILES[@]}" -gt 0 ] || return 0
  for i in "${!CHANGELOG_FILES[@]}"; do
    [ -f "${CHANGELOG_BACKUPS[$i]}" ] || continue
    # cp (not mv) so the destination keeps its own permissions/group - a rename would replace
    # its inode with the temp file's (mktemp defaults to 600), silently tightening the restored
    # CHANGELOG.md's mode even though the content ends up identical.
    cp "${CHANGELOG_BACKUPS[$i]}" "${CHANGELOG_FILES[$i]}"
    rm -f "${CHANGELOG_BACKUPS[$i]}"
    echo "restored ${CHANGELOG_FILES[$i]}" >&2
  done
  CHANGELOG_FILES=()
  CHANGELOG_BACKUPS=()
}
trap restore_changelogs EXIT

write_initial_changelog() {
  local pkg_path="$1" backup
  [ -f "$pkg_path/CHANGELOG.md" ] || return 0
  backup=$(mktemp)
  cp "$pkg_path/CHANGELOG.md" "$backup"
  CHANGELOG_FILES+=("$pkg_path/CHANGELOG.md")
  CHANGELOG_BACKUPS+=("$backup")
  printf "$CHANGELOG_TEMPLATE" "$(date +%d-%m-%Y)" "$BOOTSTRAP_VERSION" \
    > "$pkg_path/CHANGELOG.md"
}

show_local_changes() {
  # These packages are *expected* to be dirty here: RELEASING.md Step 1 has the publisher
  # stage 'version: 0.0.1' (and matching sibling constraints) in the working tree only, never
  # in git, and this script rewrites CHANGELOG.md on top of that. So this lists what will go
  # into the archive - 'dart pub publish' packs whatever is on disk - instead of gating on it.
  local dirty
  dirty=$(git status --porcelain -- "$@" || true)
  [ -n "$dirty" ] || return 0
  echo "Uncommitted changes in these packages - they WILL be part of what is published:"
  echo "$dirty"
}

main() {
  cd "$(dirname "$0")/.." || exit 1
  local scope="${1:-}"

  # Checked up front: the publish step below delegates to melos, and finding out after the
  # CHANGELOGs have been rewritten and pub.dev queried would be a needlessly late failure.
  command -v melos >/dev/null 2>&1 ||
    fail "'melos' is not on PATH - run 'dart pub global activate melos' first."

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

  local pkg_paths=() pkg_names=() pkg_name
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

  # These dry-runs are for human review, not a pass/fail gate: this repo pins federated
  # siblings at an exact version, which 'dart pub publish' always reports as a "constraints
  # are too tight" warning and exits 65 for - true of every already-published package too.
  # (It is also why the dry-run isn't delegated to 'melos publish -n', which fails fast on
  # the first non-zero exit and would never reach the remaining packages.)
  for pkg_path in "${pkg_paths[@]}"; do
    echo ""
    echo "-- Dry-run publish: $pkg_path --"
    (cd "$pkg_path" && dart pub publish --dry-run) || true
  done

  echo ""
  echo "Logging in to pub.dev (token-based, human account - opens a browser if needed)."
  dart pub login

  echo ""
  echo "Publishing from $(git rev-parse --abbrev-ref HEAD) @ $(git rev-parse --short HEAD)."
  show_local_changes "${pkg_paths[@]}"
  if [ "$(prompt_yes_no "Dry-runs above look correct. Publish all ${#pkg_names[@]} package(s) at $BOOTSTRAP_VERSION to pub.dev now?")" != "y" ]; then
    echo "Aborted before publishing. Nothing was published; re-run this script when ready."
    exit 0
  fi

  local scope_args=()
  for pkg_name in "${pkg_names[@]}"; do
    scope_args+=("--scope=$pkg_name")
  done
  echo ""
  melos publish --no-dry-run --no-git-tag-version --yes "${scope_args[@]}"

  echo ""
  echo "Published: ${pkg_names[*]} at $BOOTSTRAP_VERSION. No git tag, commit, or push was made."
  echo "The temporary CHANGELOG.md edit is restored automatically on exit - your real entry stays in git. See RELEASING.md for the remaining pub.dev/CD hand-off steps."
}

main "$@"
