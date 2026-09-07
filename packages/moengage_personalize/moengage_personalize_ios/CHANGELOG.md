# MoEngage Personalize iOS Plugin

# Release Date

## Release Version

- [patch] Declared the iOS plugin pod as a static framework. The MoEngage iOS SDK now links its app-only modules statically, and CocoaPods rejects a target using `use_frameworks!` whose transitive dependencies include statically linked binaries — without this, `pod install` fails for integrating apps.
- [patch] Updated `MoEngagePluginPersonalize` to `2.1.0`.

# 01-09-2026

## 2.0.0

- Updated minimum supported Dart SDK to `3.6.0` and minimum Flutter SDK to `3.44.0`
- Updated `MoEngage-iOS-SDK` to `11.00.0`.

# 13-08-2026

## 1.1.0

- Updated `MoEngage-iOS-SDK` to `10.14.0`.

# 07-05-2026

## 1.0.0

- Added Personalize module and feature support.

# 07-05-2026

## 0.0.1

- Added Personalize module and feature support
