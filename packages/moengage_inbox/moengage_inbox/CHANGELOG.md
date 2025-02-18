# MoEngage Flutter Inbox Plugin

# 18-02-2025

## 8.1.1
- Internal improvements
          
# 29-01-2025

## 8.1.0
- Android
  - `inbox-core` version updated to `3.2.1`
- iOS
  - Updated MoEngageInbox to `2.19.0`

# 25-11-2024

## 8.0.2
- Internal improvements.

# 03-10-2024

## 8.0.1
- Fixed dependency version incompatibility issue with `moengage_flutter`

# 30-09-2024

## 8.0.0
- Android
  - Bundling `inbox-core` dependency with the plugin
  - `inbox-core` version updated to `3.2.0`
  - **Breaking Change**: Developers should remove the `com.moengage:inbox-core` dependency from the `build.gradle` as it is now included with the plugin.
- iOS
  - Updated MoEngageInbox to `2.18.0`

## 7.1.0
- This version might have unintentional breaking changes. We recommend not to use this version. Please upgrade to `7.0.0`.

# 07-08-2024

## 7.0.0
- Exact version pinning for Inbox Module dependencies
- iOS
  - Internal Improvements
  
# 31-07-2024

## 6.2.0
- Exact version pinning for Inbox Module dependencies
- iOS
  - Updated MoEngageInbox to 2.17.0

# 15-07-2024

## 6.1.1
- `moe-android-sdk` version updated to `13.03.00`
- `inbox-core` version updated to `3.0.2`

# 03-07-2024

## 6.1.0
- Internal Improvements

# 18-06-2024

## 6.0.1

- Android
  - BugFix:
    - ANR while accessing Plugin version from assets in Main Thread

# 21-03-2024

## 6.0.0
- Updated Minimum Supported `moengage_flutter` version to `7.0.0`
- Android
  - Native SDK updated to support version `13.00.00` and above.
  - Add support for AGP `8.2.2` and above
  - Support for `inbox-core` version `3.0.0` and above
- iOS
  - Updated MoEngageInbox to `2.15.0`

# 07-12-2023

## 5.1.0
- Android
  - Native SDK updated to support version `12.10.01` and above.

# 13-09-2023

## 5.0.0
- Federated Plugin Implementation
- Breaking Change: Use import 'package:moengage_inbox/moengage_inbox.dart'; to import any files in the `moengage_inbox` package. Remove the existing import related to `moengage_inbox`
- Android
  - Native SDK updated to support version `12.9.00` and above.

# 26-07-2023

## 4.5.1
- iOS
  - BugFix: Fixed parsing issue in `fetchAllMessages` API.
  
# 19-07-2023

## 4.5.0
- iOS
  - MoEngageInbox SDK version Updated to `2.10.0`

# 31-05-2023

## 4.4.0
- Android
  - Compile SDK Version Updated to 33
  - Native SDK updated to support version `12.9.00` and above.
- iOS
    - MoEngageInbox SDK version updated to `~>2.8.0`.
    
# 08-02-2023
## 4.3.0
- Security improvement: controlled logging for release, debug and profile mode
- iOS
    - MoEngageInbox SDK version updated to `~>2.4.0`.

# 23-01-2023
## 4.2.0
- iOS
    - MoEngageInbox SDK version updated to `~>2.2.0`.
    
# 27-10-2022

## 4.1.0
- Android
    - Android Gradle Plugin version updated to `7.3.1`
    - Gradle version updated to `7.4`
    - Compile SDK Version - 31
    - Target SDK version - 31
    - Support for Android SDK version `12.4.00`
    - Inbox Core `2.2.0`

## 27.09.2022

### 4.0.0
- Support for Android SDK version `12.2.05` and above and Native Inbox SDK Version `2.1.1` and above.
- Support for iOS SDK version `8.3.1` and above Native Inbox SDK Version `1.3.0` and above.
- Breaking changes

| Then            | Now                         |
|-----------------|-----------------------------|
| MoEngageInbox() | MoEngageInbox("YOUR_APP_ID) |

- Android
  - Build Configuration Updates
    - Minimum SDK version - 21
    - Target SDK version - 30
    - Compile SDK Version - 30

### 3.2.0 (29th July 2022)
- Added Flutter 3 support

### 3.1.0 *(6th September 2021)*
- Android
  - Native SDK updated to support version `11.4.00` and above.
  
### 3.0.0 *(12th May 2021)*
- Migrated the main library to null safety.
    - Require Dart 2.12 or greater.
- Android
    - Native SDK updated to support version `11.2.00` and above.
    - Removed Native `addon-inbox` SDK support
    - Native Inbox artifact changed to support `inbox-core`, version `1.0.00` and above.

### 2.0.1 *(28th April 2021)*
- iOS
    - Podspec changes to set deployment target to iOS 10.0.

### 2.0.0 *(26th February 2021)*
- iOS 
    - Native Dependencies updated to support MoEngage-iOS-SDK `7.*` and above
    - Base plugin version dependency updated to `~> 2.0.2`.
- Android 
    - Native SDK updated to support version `11.0.04` and above.
    - Native Inbox SDK updated to support version `6.0.2` and above.
    - Plugin Base `2.0.00`

### 1.0.2 *(15th February 2021)*
- Android artifacts use manven central instead of Jcenter.
- Native SDK version `5.3.1`
- Plugin Base `1.0.01`

### 1.0.1  *(7th November, 2020)*
- Media Content parsing fixes

### 1.0.0  *(6th November, 2020)*
- Initial release
- APIs
  - Fetch All Messages
  - Get unclicked count
  - Track message clicked
  - Delete message
