# MoEngage Flutter Plugin

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
