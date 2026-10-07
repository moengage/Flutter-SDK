# MoEngage Recommendations iOS Plugin

# Release Date

## Release Version

- [major] MOEN-47187: Added support for fetching Recommendations.
- [patch] Declared the iOS plugin pod as a static framework. The MoEngage iOS SDK now links its app-only
  modules statically, and CocoaPods rejects a target using `use_frameworks!` whose transitive
  dependencies include statically linked binaries — without this, `pod install` fails for
  integrating apps.
