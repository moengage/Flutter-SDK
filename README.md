# MoEngage Flutter Plugin

Flutter Plugin for MoEngage Platform

## SDK Installation

To add the MoEngage Flutter SDK to your application, edit your application's `pubspec.yaml` file and add the below dependency to it:

```yaml
dependencies:
 moengage_flutter: 1.0.0
```
 Run flutter packages get to install the SDK.
 
 ### Android Installation
 
 ![Download](https://api.bintray.com/packages/moengage/android-sdk/moe-android-sdk/images/download.svg)

 
  Once you install the Flutter Plugin add MoEngage's native Android SDK dependency to the Android project of your application.
  Navigate to `android --> app --> build.gradle`. Add the MoEngage Android SDK's dependency in the `dependencies` block
  
  ```groovy
  dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    implementation 'com.android.support:appcompat-v7:26.0.1'
    implementation "com.moengage:moe-android-sdk:$sdkVersion"
}
  ```
where `$sdkVersion` should be replaced by the latest version of the MoEngage SDK.

## SDK Initialization

### Android SDK Initialization
Get APP ID from the [Settings Page](http://app.moengage.com/v3/#/settings/0/0) on the MoEngage dashboard and initialize the MoEngage SDK in the `Application` class's `onCreate()`

```kotlin
// this is the instance of the application class and "XXXXXXXXXXX" is the APP ID from the dashboard.
val moEngage =
        new MoEngage.Builder(this, "XXXXXXXXXXX")
        .build()
MoEngage.initialise(moEngage)
```
Refer to the [API reference doc](https://moengage.github.io/MoEngage-Android-SDK/) for a detailed list of possible configurations.

```
Note:
All the configuration should be added to the builder before calling initialize. If you are calling initialize at multiple places please ensure that all the required flags and configuration are set each time you initialize to maintain consistency in behavior.
```

### iOS SDK Initialization


Refer to the [Documentation](https://docs.moengage.com/docs/sdk-integration-4) for complete integration guide. 