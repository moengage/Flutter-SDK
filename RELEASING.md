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

So when you add a brand-new module (e.g. `moengage_sample`) to `packages/`:

1. `.github/scripts/release.main.kts` will detect that the package has never been
   published (via the pub.dev API) and **skip it** from the automated `melos publish`
   batch, so it no longer fails the release job for every other package.
2. Once, by hand, a publisher-admin (a member of the `moengage.com` verified pub.dev
   publisher) runs:
   ```
   scripts/publish-new-package.sh packages/<feature>/<package-name>
   ```
   This does `dart pub login` (token-based, human-authenticated OAuth session - not
   the service account) and then `dart pub publish` for just that package.
3. After that first publish, go to `https://pub.dev/packages/<package-name>/admin`
   and enable "Automated publishing" for `moengage/Flutter-SDK`'s `release-plugins.yml`
   (or add the release service account as an uploader). From then on the package is
   released automatically like every other module.