# MoEngage Geofence Plugin

Geofence Plugin for MoEngage Platform

## SDK Installation

To add the MoEngage Geofence SDK to your application, edit your application's `pubspec.yaml` file and add the below dependency to it:

![Download](https://img.shields.io/pub/v/moengage_geofence.svg)

```yaml
dependencies:
 moengage_geofence: $latestSdkVersion
```
replace `$latestSdkVersion` with the latest SDK version.

Run flutter packages get to install the SDK.
 
 Note: This plugin is dependent on `moengage_flutter` plugin. Make sure you have installed the `moengage_flutter
 ` make sure you have installed the `moengage_flutter` plugin as well.

### Android Installation

Note: From `moengage_geofence` plugin version `4.1.0` onwards, the plugin will bundle the `geofence` version.
Application developers need not add the `geofence` in the `build.gradle` file.

![MavenBadge](https://maven-badges.herokuapp.com/maven-central/com.moengage/geofence/badge.svg)

For `moengage_geofence` version less than`4.1.0`,
Once you install the Flutter Plugin add MoEngage's native Android SDK dependency to the Android
project of your application.
Navigate to `android --> app --> build.gradle`. Add the MoEngage Android SDK's dependency in
the `dependencies` block

```groovy
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    implementation("com.moengage:geofence:$sdkVersion")
}
```