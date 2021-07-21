# MoEngage Flutter Plugin

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
- Android artifacts use manven central instead of Jcenter.
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
