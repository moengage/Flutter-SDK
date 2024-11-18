# Release Process

- Create a new branch from `development` for any new feature or bugfix
- After QA, merge the feature/bugfix branch into `development`
- Once all the releasing features/changes into `development`, checkout release branch from `development`
- Update Changelog date and package release versions and raise a PR to `development`
- Once PR is merged, trigger the Release Plugins action to publish the updated plugins to `pub.dev`.