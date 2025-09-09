# MoEngage Cards Plugin

# Release Date

## Release Version
- Android
  - Updated `cards-core` version to `3.1.2`
- iOS
  - Updated MoEngagePluginCards to `3.4.1`

# 18-07-2025

## 6.0.1
- Export `static_image_type.dart` in the platform interface barrel file

# 03-07-2025

## 6.0.0
- Added Accessibility support in Cards.
- Android
    - Compiled SDK Version updated to 35
    - Min SDK Version updated to 23
    - `cards-core` version updated to `3.1.0`
- iOS
  - **Breaking Change**: Minimum deployment target updated to 13
  
# 25-03-2025

## 5.2.0
- Android
  - Added support for AGP version `8.7.3` and above
- iOS
  - Updated MoEngageCards to `4.20.0`
  
# 18-02-2025

## 5.1.1
- iOS
  - Updated MoEngageCards to `4.19.2`

# 29-01-2025

## 5.1.0
- Add `jsonEncode()` for missing APIs
- Android
  - `cards-core` version updated to `2.3.2`
- iOS
    - Updated MoEngageCards to `4.19.1`
          
# 25-11-2024

## 5.0.2
- Internal improvements.

# 03-10-2024

## 5.0.1
- Fixed dependency version incompatibility issue with `moengage_flutter`

# 30-09-2024

## 5.0.0
- Refresh cards on uniqueID set
- Breaking Changes:

|                     Then                      |                   Now                   |
|:---------------------------------------------:|:---------------------------------------:|
| MoEngageCards#setAppOpenCardsSyncListener()   | MoEngageCards#setSyncCompleteListener() |

- Android
    - Bundling `cards-core` dependency with the plugin
    - `cards-core` version updated to `2.3.0`
    - **Breaking Change**: Developers should remove the `com.moengage:cards-core` dependencies from the `build.gradle` as it is now included with the plugin.

- iOS
    - Updated MoEngageCards to `4.18.0`

# 07-08-2024

## 4.0.0
- Exact version pinning for Cards Module dependencies
- iOS
  - Internal Improvements

# 31-07-2024

## 3.2.0
- Exact version pinning for Cards Module dependencies
- iOS
  - Updated MoEngageCards to `4.17.0`

# 15-07-2024

## 3.1.1
- `moe-android-sdk` version updated to `13.03.00`
- `cards-core` version updated to `2.1.0`

# 03-07-2024

## 3.1.0
- Internal Improvements

# 21-03-2024

## 3.0.0
- Updated Minimum Supported `moengage_flutter` version to `7.0.0`
- Android
  - Native SDK updated to support version `13.00.00` and above.
  - Add support for AGP `8.2.2` and above
  - Support for `cards-core` version `2.0.0` and above
- iOS
  - Updated MoEngageCards to `4.15.0`

# 07-12-2023

## 2.1.0
- Updated Minimum Supported `moengage_flutter` version to `6.1.0`
- Android
    - Native SDK updated to support version `12.10.01` and above.

# 13-09-2023

## 2.0.0
- Federated Plugin Implementation

# 19-07-2023

## 1.0.0
- Initial Release
