# MoEngage Flutter Android Plugin

# Release Date

## Release Version
- Android
  - [minor] `android-bom` version updated to `1.5.0`

# MoEngage Flutter Android Plugin

# 03-02-2026

## 4.4.0
- Bundling `MoEFireBaseMessagingService` in Plugin's manifest to reduce integration steps for developers using FCM Push.

# 19-11-2025

## 4.3.0

- Adding support for initialising the SDK using file configuration from xml resource
- Moving the internal native dependencies to bill-of-materials (BOM) for better version management.

# 14-10-2025

## 4.2.0
- `moe-android-sdk` version updated to `14.03.05`
- `inapp` version updated to `9.4.0`

# 09-09-2025

## 4.1.0
- `moe-android-sdk` version updated to `14.03.03`
- `inapp` version updated to `9.3.0`

# 03-07-2025

## 4.0.0
- Android
    - Compiled SDK Version updated to 35
    - Min SDK Version updated to 23

# 24-04-2025 

## 3.3.1

- `inapp` version updated to `8.8.1`

# 25-03-2025

## 3.3.0
- Adding support for identify user based on multiple identities
- Android
    - Added support for AGP version `8.7.3` and above

# 29-01-2025

## 3.2.0
- Add `jsonEncode()` for missing APIs 
- `moe-android-sdk` version updated to `13.05.02`
- `inapp` version updated to `8.7.1`

# 25-11-2024

## 3.1.1
- Internal improvements.

# 30-09-2024

## 3.1.0

- Bundling `moe-android-sdk` & `inapp` dependencies with the plugin 
- `moe-android-sdk` version updated to `13.05.00`
- `inapp` version updated to `8.6.0`
- Added support for multiple self-handled in-apps

# 07-08-2024

## 3.0.0
- Internal Improvements

# 15-07-2024

## 2.1.1
- `moe-android-sdk` version updated to `13.03.00`

# 03-07-2024

## 2.1.0
- Added support for JSONObject values in user attributes
- Added Support for Enforcing SDK into Specific Environment

# 18-06-2024

## 2.0.1

- BugFix:
  - ANR in `MoEInitializer` while accessing Plugin version from assets in Main Thread

# 21-03-2024

## 2.0.0
- Non-intrusive Nudges support
- Support for `moe-android-sdk` version `13.00.00` and above
- Add support for AGP `8.2.2` and above

# 07-12-2023

## 1.1.0
- Fix: Android to Dart Method Channel Communication Breaking when `FirebaseMessaging.onBackgroundMessage` is used
- Google Policy - Delete User details API
- Add support for AGP `8.0.2` and above
- Upgrade Kotlin Version to `1.7.10`
- Support for `moe-android-sdk` version `12.10.01` and above

# 13-09-2023

## 1.0.0
- Initial Release