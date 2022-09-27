# MoEngage Flutter Inbox Plugin

## Next Release

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
