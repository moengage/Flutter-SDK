# MoEngage Geofence Plugin

# 24-03-2025

## 5.2.0
- Android
    - Added support for AGP version `8.7.3` and above
- iOS
  - Internal improvements

# 18-02-2025

## 5.1.1
- Internal improvements

# 29-01-2025

## 5.1.0
- Add `jsonEncode()` for missing APIs
- Android
  - `geofence` version updated to `4.2.1`
- iOS
  - Updated MoEngageGeofence to `5.19.0`

# 25-11-2024

## 5.0.2
- Internal improvements.

# 03-10-2024

## 5.0.1
- Fixed dependency version incompatibility issue with `moengage_flutter`

# 30-09-2024

## 5.0.0

- Android
  - Bundling `geofence` dependency with the plugin
  - `geofence` version updated to `4.2.0`
  - **Note**: Developers should remove the `com.moengage:geofence` dependency from the `build.gradle` as it is now included with the plugin.
- iOS
  - Updated MoEngageGeofence to `5.18.0`

## 4.1.0
- This version might have unintentional breaking changes. We recommend not to use this version. Please upgrade to `5.0.0`.

# 07-08-2024

## 4.0.0
- Exact version pinning for Geofence Module dependencies
- iOS
  - Internal Improvements
  
# 31-07-2024

## 3.2.0
- Exact version pinning for Geofence Module dependencies
- iOS
  - Updated MoEngageGeofence to 5.17.0

# 15-07-2024

## 3.1.1
- `moe-android-sdk` version updated to `13.03.00`
- `geofence` version updated to `4.1.0`

# 03-07-2024

## 3.1.0
- Internal Improvements

# 21-03-2024

## 3.0.0
- Updated Minimum Supported `moengage_flutter` version to `7.0.0`
- Android
  - Support for `moe-android-sdk` version `13.00.00` and above
  - Add support for AGP `8.2.2` and above
  - Support for `geofence` version `4.0.0` and above
- iOS
  - Updated MoEngageGeofence to `5.15.0`

# 07-12-2023

## 2.1.0
- Updated Minimum Supported `moengage_flutter` version to `6.1.0`
- Android
  - Native SDK updated to support version `12.10.01` and above.

# 13-09-2023

## 2.0.0
- Federated Plugin Implementation 
- Breaking Change: Use import 'package:moengage_geofence/moengage_goefence.dart'; to import any files in the `moengage_geofence` package. Remove the existing import related to `moengage_geofence`

# 19-07-2023

## 1.6.0
- iOS
  - MoEngageGeofence SDK version Updated to `5.10.0`

# 31-05-2023

## 1.5.0
- Android
  - Compile SDK Version Updated to 33
  - Native SDK updated to support version `12.9.00` and above.
- iOS
    - MoEngageGeofence SDK version updated to `~>5.8.0`.
    
# 21-02-2023

## 1.4.0
- Android
    - Support for GeoFence Start/Stop API
- iOS
    - Added support for `stopGeofenceMonitoring` API.

# 08-02-2023

## 1.3.0
-  Security improvement: controlled logging for release, debug and profile mode
- MoEngageGeofence SDK version updated to `~>5.4.0`.

# 23-01-2023

## 1.2.0
- MoEngageGeofence SDK version updated to `~>5.2.0`.

# 27-10-2022

## 1.1.0
- MoEngageGeofence SDK version updated to `~>4.4.0`.

## 27.09.2022

### 1.0.0
- MoEngageGeofence SDK version updated to `~>4.3.0`.