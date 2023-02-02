# MoEngage Flutter Plugin

## Next Release
- Security improvement: controlled logging for release, debug and profile mode
- Android
  - Support for 2 Step Push Optin InApps

# 23-01-2023
## 5.2.0
- iOS
    - MoEngage-iOS-SDK version updated to `~>9.2.0`.
    - Updated API

      | Then                                                                                                                                     | Now                                                                                                                                                        |
      |:----------------------------------------------------------------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------:|
      | public func initializeDefaultInstance(config: MOSDKConfig, sdkState: MoEngageSDKState = .enabled, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil)   |public func initializeDefaultInstance(config: MoEngageSDKConfig, sdkState: MoEngageSDKState = .enabled, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil)                                       |
      | public func initializeDefaultInstance(_ config: MOSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) | public func initializeDefaultInstance(_ config: MoEngageSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) |
      
# 04-11-2022

## 5.1.1
- Bugfix
  - Typo fix in API name `enableAdIdTracking()`

# 27-10-2022

## 5.1.0
- Android
  - Support for Android 13 notification permission.
  - Android Gradle Plugin version updated to `7.3.1`
  - Gradle version updated to `7.4`
  - Build Configuration Updates
    - Compile SDK Version - 31
    - Target SDK version - 31
  - Support for Android SDK version `12.4.00`
  - InApp `6.4.0`
- iOS
  - Deprecated API

| Then                                                                                                                                 | Now                                                                                                                                                 |
|:------------------------------------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------------------------------------:|
| initializeDefaultInstance(_ config: MOSDKConfig, sdkState: Bool = true, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) | initializeDefaultInstance(config: MOSDKConfig, sdkState: MoEngageSDKState = .enabled, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil)  |
  

## 27.09.2022

### 5.0.0
- Support for Android SDK version `12.2.05` and above.
- Support for iOS SDK version `8.3.1` and above.
- Breaking Changes

| Then                      | Now                                |
|---------------------------|------------------------------------|
| MoEngageFlutter()         | MoEngageFlutter("YOUR_APP_ID")     |
| optOutDataTracking(false) | enableDataTracking()               |
| optOutDataTracking(true)  | disableDataTracking()              |

  - InApp Model `InAppCampaign` broken down from a single object to multiple objects
    - `InAppData`
    - `ClickData`
    - `SelfHandledCampaignData`
  - InApp `setUpInAppCallbacks` removed and callbacks broken down into multiple listeners.
  
| Callback Type                            | Method                                                          |
|------------------------------------------|-----------------------------------------------------------------|
| InApp Shown                              | setInAppShownCallbackHandler(InAppShownCallbackHandler)         |
| InApp Dismissed                          | setInAppDismissedCallbackHandler(InAppDismissedCallbackHandler) |
| InApp Clicked(Navigation, Custom Action) | setInAppClickHandler(InAppClickCallbackHandler)                 |
| InApp Self Handled                       | setSelfHandledInAppHandler(SelfHandledInAppCallbackHandler)     |
  
  - Push campaign Model is restructured and renamed from `PushCampaign` to `PushCampaignData`
  - Push callback APIs are renamed.

| Then                                             | Now                                                   |
|--------------------------------------------------|-------------------------------------------------------|
| setUpPushCallbacks(PushCallbackHandler)          | setPushClickCallbackHandler(PushClickCallbackHandler) |
| setUpPushTokenCallback(PushTokenCallbackHandler) | setPushTokenCallbackHandler(PushTokenCallbackHandler) |

- Removed APIs

| Removed APIs                |
|-----------------------------|
| selfHandledPrimaryClicked() |
| enableSDKLogs()             |
| optOutInAppNotification()   |
| optOutPushNotification()    |
| startGeofenceMonitoring()   |

- Android
  - Build Configuration Updates
    - Minimum SDK version - 21
    - Target SDK version - 30
    - Compile SDK Version - 30
  - Mi SDK update to Version 5.x.x, refer to the [Configuring Xiaomi Push](https://developers.moengage.com/hc/en-us/articles/4403466194708) and update the integration.
  - Removed and replaced APIs

| Then                                                          | Now                                                                 |
|---------------------------------------------------------------|---------------------------------------------------------------------|
| MoEInitializer.initialize(Context, MoEngage.Builder)          | MoEInitializer.initialiseDefaultInstance(Context, MoEngage.Builder) |
| MoEInitializer.initialize(Context, MoEngage.Builder, Boolean) | MoEInitializer.initialiseDefaultInstance(Context, MoEngage.Builder) |

- iOS
  -  `MOFlutterInitializer` has been renamed to `MoEngageInitializer`

| Then                                                                                                                                            | Now                                                                                                                                  |
|-------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| initializeWithSDKConfig(_ config: MOSDKConfig, andLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)                          | initializeDefaultInstance(_ config: MOSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil)                        |
| initializeWithSDKConfig(_ config: MOSDKConfig, withSDKState state:Bool, andLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) | initializeDefaultInstance(_ config: MOSDKConfig, sdkState: Bool = true, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) |


### 4.2.0 (29th July 2022)
- Added Flutter 3 support
- Device identifier tracking update as per Google's User Data policy. Advertising Id is only tracked after user consent.
- Android
  - Native SDK updated to support version `11.6.02` and above. 

### 4.1.0 *(6th September 2021)*
- Support for HTML InApps
- Android
  - Native SDK updated to support version `11.4.00` and above.
- iOS
  - Native Dependencies updated to support MoEngage-iOS-SDK `7.1.0` and above
  
### 4.0.2 (21st July 2021)
- Bugfix
  - Calling MoEngage APIs when application in background is not working on Android.

### 4.0.1 *(15th June 2021)*
- Bugfix: 
    - Push click notification callback is not received when clicked action is null.
    
### 4.0.0 *(12th May 2021)*
- Migrated the main library to null safety.
    - Require Dart 2.12 or greater.
- Bumped flutter dependency constraint to min version `1.17.0`
- Android
    - Native SDK updated to support version `11.2.00` and above.
    
### 3.0.1 *(28th April 2021)*
- iOS
    - Added ObjC support for `MOFlutterInitializer` class
    - PodSpec changes to set deployment target to iOS 10.0.  
 
### 3.0.0 *(26th February 2021)*
- Android 
    - Native SDK updated to support version `11.0.04` and above.
    - Plugin Base `2.0.00`
- iOS 
    - Plugin now supports iOS 10.0 and above.
    - Native Dependencies updated to support MoEngage-iOS-SDK `7.*` and above
    - Base plugin version dependency updated to `~> 2.0.2`.
- Added Dart APIs to enable and disable MoEngage Sdk.
- Added Dart API to register a callback for push token generated event.


### 2.0.3 *(15th February 2021)*
- Android artifacts use maven central instead of Jcenter.
- Native SDK version `10.6.01`
- Plugin Base `1.2.01`

### 2.0.2 *(7th December 2020)*

- Android Base plugin update for enabling callback extension.
- Android Native SDK updated to `10.5.00`

### 2.0.1  *(6th November, 2020)*

- Bugfix: AppStatus method was getting called for other channel method calls as well.


### 2.0.0  *(23rd October, 2020)*

- Support for Self-Handled In-App
- Support for In-App V3
- Android SDK updated to support `10.4.03` and above.
- iOS SDK dependency changed to support versions greater than `6.0.0`.
- Deprecated APIs

|                         Then                        	|                       Now                      	|
|:---------------------------------------------------:	|:----------------------------------------------:	|
| MoEProperties().addInteger(String, int)             	| MoEProperties().addAttribute.(String, dynamic) 	|
| MoEProperties().addString(String, String)           	| MoEProperties().addAttribute(String, dynamic)  	|
| MoEProperties().addBoolean(String, bool)            	| MoEProperties().addAttribute(String, dynamic)  	|
| MoEProperties().addDouble(String, double)           	| MoEProperties().addAttribute(String, dynamic)  	|
| MoEProperties().addLocation(String, MoEGeoLocation) 	| MoEProperties().addAttribute(String, dynamic)  	|

- Removed APIs

|                         Then                        	|                       Now                      	|
|:---------------------------------------------------:	|:----------------------------------------------:	|
| onPushClick(Map<String, dynamic>)                   	| onPushClick(PushCampaign)                      	|
| onInAppClick(Map<String, dynamic>)                  	| onInAppClick(InAppCampaign)                    	|
| onInAppShown(Map<String, dynamic>)                  	| onInAppShown(InAppCampaign)                    	|
| onInAppShown(Map<String, dynamic> message)          	| onInAppShown(InAppCampaign message)            	|
| passPushToken(String)                               	| passFCMPushToken(String)                       	|
| passPushPayload(Map<String, String>)                	| passFCMPushPayload(Map<String, String>)        	|

- Removed APIs Android 

|                 Then                |                          Now                         |
|:-----------------------------------:|:----------------------------------------------------:|
| MoEInitializer.initialize(MoEngage) | MoEInitializer.initialize(Context, MoEngage.Builder) |


### 1.1.0 *(10th February, 2020)*

- Add Dart APIs for passing FCM Push Token and FCM Push Payload from Android Platform.


### 1.0.1 *(17th December, 2019)*
- Sample Updated
- ReadMe Updated
- Improved logging


### 1.0.0 *(16th December, 2019)*

- Initial Release
