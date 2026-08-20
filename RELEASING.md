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

### Step 1 - register the new package(s) so tooling knows about them

Before publishing anything, make sure the new package(s) are registered in:

- the root `pubspec.yaml`'s `workspace:` list (required for `flutter pub get` /
  `melos bootstrap` to resolve them at all - see the note below on why this used
  to break CI), and
- `.github/scripts/flutter-utils.main.kts`'s `packageParentFolder` and
  `dependencyMapping` maps (required for the pre-release/release automation to
  version-bump and publish them).

> **Why `melos bootstrap` used to fail when adding a new module:** this repo uses
> Dart's native pub workspaces (the root `workspace:` list + each member's
> `resolution: workspace`). `melos bootstrap`/`pub get` resolve *exactly* that list -
> there's no separate melos package-glob discovery. If a new package (or a federated
> sibling like `_android`/`_ios`/`_platform_interface`) is added under `packages/`
> without being added to that `workspace:` list, any package that depends on it
> (e.g. the app-facing package depending on its own `_android`/`_ios`/
> `_platform_interface`) has an unresolvable dependency - pub tries to fetch it from
> pub.dev, where it doesn't exist yet, and the whole workspace fails to resolve.

### Step 2 - bootstrap-publish 0.0.1 locally

Run, from the repo root:
```
scripts/publish-new-package.sh                              # scans the whole workspace
scripts/publish-new-package.sh packages/<feature>            # scopes to one module's packages
```
This must be run by a publisher-admin (a member of the `moengage.com` verified
pub.dev publisher), authenticated via `dart pub login` (token-based, human OAuth
session - not the CI service account, which pub.dev blocks for a first publish).
For every package under the given path that has never been published, it:

- releases **only the unpublished ones** - anything already on pub.dev is skipped;
- sets its version to a fixed `0.0.1` (in `pubspec.yaml` and `config.json`), and
  re-points any other workspace package's dependency on it to `0.0.1`;
- appends a dated `0.0.1` entry to its `CHANGELOG.md`, **leaving the pending
  `# Release Date` / `## Release Version` placeholder and its real
  `[major]/[minor]/[patch]` entry untouched** - that's what the next real CD
  release will consume;
- does **not** create a git tag for this bootstrap release, and does **not**
  `git commit` or `git push` anything - review the changes (`git diff`) and commit
  them yourself;
- runs `dart pub publish --dry-run` for review, then, after one confirmation,
  `dart pub publish --force` for real.

### Step 3 - hand off to the normal CD pipeline

1. Commit and push the version/CHANGELOG changes the script made, and merge as usual.
2. On `https://pub.dev/packages/<package-name>/admin` for each newly-published
   package, enable "Automated publishing" for `moengage/Flutter-SDK`'s
   `release-plugins.yml` (or add the release service account as an uploader).
3. Trigger the "Release Plugins" workflow from `development` as normal. Because the
   pending placeholder entry (with its real release-type marker) was left in place,
   pre-release automation still sees it and bumps the version accordingly from the
   new `0.0.1` baseline - e.g. a `[major]` marker takes `0.0.1` straight to `1.0.0`,
   the expected first real release. From here on the package is released
   automatically like every other module - no more manual steps.