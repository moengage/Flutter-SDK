# Release Process

- Create a new branch from `development` for any new feature or bugfix
- After QA, merge the feature/bugfix branch into `development`
- Once all the releasing features/changes into `development`, checkout release branch from `development`
- Update Changelog release date and version 
- Update versions in the `pubspec.yaml`
- Update versions in `config.json`
- and raise a PR to `development`
- Once PR is merged, trigger the Release Plugins action to publish the updated plugins to `pub.dev`.
- Create a github release