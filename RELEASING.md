# Release Process

- Create a new branch from `development` for any new feature or bugfix
- While working on feature update the changelog in the format of
    - Release Header Placeholder = `# Release Date`
    - Release Date Placeholder = `## Release Version`
    - [Release Type (major / minor / patch)] TicketNumber: <Content>
- After QA, merge the feature/bugfix branch into `development`
- Trigger the release workflow from `development`

## Publishing a brand-new module for the first time

The `release-plugins.yml` workflow publishes with a Google service-account-derived
pub.dev token (`gcloud auth print-identity-token | dart pub token add ...`). pub.dev
does **not** allow that (or any other automated/CI credential) to publish the first
version of a package that has never existed on pub.dev before - see
[Automated publishing](https://dart.dev/tools/pub/automated-publishing):

> Today, you can only automate publishing of existing packages. To create a new
> package, you must publish the first version using `dart pub publish`.

So when you add a brand-new module (e.g. `moengage_sample`) to `packages/`, and it
has never been published on pub.dev before, `.github/scripts/release.main.kts` will
detect that (via the pub.dev API) and **skip it** from the automated `melos publish`
batch, so it no longer fails the release job for every other package. Its real
release then requires one manual step, done locally, before the normal CD workflow
can take over:

### Step 1 - scaffold the new package(s) at version 0.0.1

Before publishing anything:

- Set `version: 0.0.1` in every new package's `pubspec.yaml`, including every
  federated sibling (`_android`/`_ios`/`_platform_interface`).
  `scripts/publish-new-package.sh` **only publishes -
  it does not choose version numbers for you.** If an unpublished package isn't
  already staged at `0.0.1`, the script throws an error and refuses to proceed,
  rather than silently rewriting the version for you.
- Register the new package(s) in:
  - the root `pubspec.yaml`'s `workspace:` list (required for `flutter pub get` /
    `melos bootstrap` to resolve them at all - see the note below on why this
    used to break CI), and
  - `.github/scripts/flutter-utils.main.kts`'s `packageParentFolder` and
    `dependencyMapping` maps (required for the pre-release/release automation to
    version-bump and publish them later).

> **Why `melos bootstrap` used to fail when adding a new module:** this repo uses
> Dart's native pub workspaces (the root `workspace:` list + each member's
> `resolution: workspace`). `melos bootstrap`/`pub get` resolve *exactly* that list -
> there's no separate melos package-glob discovery. If a new package (or a federated
> sibling like `_android`/`_ios`/`_platform_interface`) is added under `packages/`
> without being added to that `workspace:` list, any package that depends on it
> (e.g. the app-facing package depending on its own `_android`/`_ios`/
> `_platform_interface`) has an unresolvable dependency - pub tries to fetch it from
> pub.dev, where it doesn't exist yet, and the whole workspace fails to resolve.

The `flutter-new-module-review` Claude Code skill checks all of the above for any
PR that adds a new module.

### Step 2 - bootstrap-publish 0.0.1 locally

Run, from the repo root:
```
scripts/publish-new-package.sh                              # scans the whole workspace
scripts/publish-new-package.sh packages/<feature>            # scopes to one module's packages
```
This must be run by a publisher-admin (a member of the `moengage.com` verified
pub.dev publisher), authenticated via `dart pub login` (token-based, human OAuth
session - not the CI service account, which pub.dev blocks for a first publish).
It:

1. Finds every package under the given path (or the whole workspace) and lists
   the ones that have never been published on pub.dev - anything already
   published is skipped.
2. For each unpublished one, **validates** it's already staged at `0.0.1` in
   `pubspec.yaml` - throwing an error naming the exact version found if not,
   rather than fixing it for you.
3. Overwrites its `CHANGELOG.md` with the standard first-release entry (today's
   date, version `0.0.1`, "Initial release.") purely so pub.dev's publish
   validation has something to check - this is a **working-tree-only** edit,
   and the script restores the original file automatically when it exits (on
   success, abort, or error). Your real `[major]/[minor]/[patch]` changelog
   entry for the feature is committed from Step 1 and is never touched in git.
4. Runs `flutter pub get` (catches any stale cross-references between the new
   packages with a clear pub error) and `dart pub publish --dry-run` for review.
5. Asks for a single `y`/`n` confirmation, then, only on `y`, hands the actual
   publishing to `melos publish --no-dry-run --no-git-tag-version --yes`
   scoped to those packages - the same command `release-plugins.yml` uses, so
   melos's own topological ordering puts a federated module's
   `_platform_interface` on pub.dev before the `_android`/`_ios` packages and
   the app-facing package that pin it.

It creates **no git tag** and does **no `git commit`/`git push`**.

### Step 3 - hand off to the normal CD pipeline

1. Confirm the working tree is clean - the script restores its temporary
   `CHANGELOG.md` edit itself, so your real entry from Step 1 is what ships.
2. On `https://pub.dev/packages/<package-name>/admin` for each newly-published
   package, go to the "Admin" tab -> "Publishing with Google Cloud Service
   account" and enter the service account's email address (the `client_email`
   field inside the JSON key stored in this repo's `SERVICE_ACCOUNT` GitHub
   secret, the same one `release-plugins.yml` authenticates with). This is
   what authorizes that service account to publish this package automatically
   from here on - it can only be done after the first version exists.
3. Trigger the "Release Plugins" workflow from `development` as normal.
   Pre-release automation reads your already-committed `[major]/[minor]/[patch]`
   marker and bumps the version from the `0.0.1` baseline accordingly - e.g. a
   `[major]` marker takes `0.0.1` straight to `1.0.0`, the expected first real
   release. From here on the package is released automatically like every
   other module - no more manual steps.
