# MoEngage Flutter Plugin

Flutter Plugin for MoEngage Platform

## SDK Installation

To add the MoEngage Flutter SDK to your application, edit your application's `pubspec.yaml` file and add the below dependency to it:

![Download](https://img.shields.io/pub/v/moengage_flutter.svg)

```yaml
dependencies:
 moengage_flutter: $latestSdkVersion
```
replace `$latestSdkVersion` with the latest SDK version.

 Run flutter packages get to install the SDK.
 
 ### Android Installation
 
![MavenBadge](http://maven-badges.herokuapp.com/maven-central/com.moengage/moe-android-sdk/badge.svg)
 
  Once you install the Flutter Plugin add MoEngage's native Android SDK dependency to the Android project of your application.
  Navigate to `android --> app --> build.gradle`. Add the MoEngage Android SDK's dependency in the `dependencies` block
  
  ```groovy
  dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    implementation("androidx.core:core:1.3.1")
    implementation("androidx.appcompat:appcompat:1.2.0")
    implementation("androidx.lifecycle:lifecycle-process:2.2.0")
    implementation "com.moengage:moe-android-sdk:$sdkVersion"
}
  ```
where `$sdkVersion` should be replaced by the latest version of the MoEngage SDK.

## SDK Initialization

### Android SDK Initialization
Get APP ID from the [Settings Page](https://app.moengage.com/v3/#/settings/0/0) on the MoEngage dashboard and
 initialize the MoEngage SDK in the `Application` class's `onCreate()`

```kotlin
// this is the instance of the application class and "XXXXXXXXXXX" is the APP ID from the dashboard.
val moEngage = new MoEngage.Builder(this, "XXXXXXXXXXX")
MoEInitializer.initialize(appicationContext, builder)
```
Refer to the [API reference doc](https://moengage.github.io/MoEngage-Android-SDK/) for a detailed list of possible configurations.

```
Note:
All the configuration should be added to the builder before calling initialize. If you are calling initialize at multiple places please ensure that all the required flags and configuration are set each time you initialize to maintain consistency in behavior.
```

### iOS SDK Initialization

Make sure to run `flutter build` command to make sure all the CocoaPods dependencies are added to your project. (i.e, `MoEngage-iOS-SDK` and `moengage_flutter`)

To initialize the iOS Application with the MoEngage App ID from Settings in Dashboard. In your project, go to AppDelegate file and call the initialize method of `MOFlutterInitializer` instance in applicationdidFinishLaunchingWithOptions() method as shown below:

```swift
 var sdkConfig : MOSDKConfig
 let yourAppID = "Your App ID" //App ID: You can be obtain it from App Settings in MoEngage Dashboard.
 if let config = MoEngage.sharedInstance().getDefaultSDKConfiguration() {
    sdkConfig = config
    sdkConfig.moeAppID = yourAppID
 }
 else{
    sdkConfig = MOSDKConfig.init(appID: yourAppID)
 }
 sdkConfig.appGroupID = "Your App Group ID"
 sdkConfig.moeDataCenter = <DATA CENTER Value> // use MODataCenter enum to set the datacenter for your account
 
 MOFlutterInitializer.sharedInstance.initializeWithSDKConfig(sdkConfig, andLaunchOptions: launchOptions)
```

Refer to the [Documentation](https://docs.moengage.com/docs/flutter-sdk-integration) for complete integration guide. 
