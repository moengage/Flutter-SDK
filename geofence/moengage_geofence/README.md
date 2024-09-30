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

> **Breaking Change:**
> As of `moengage_geofence` plugin version `5.0.0`, the `geofence` dependency is included within the plugin itself
> Developers should remove the `geofence` dependency from the `build.gradle` as it is now included with the plugin.

![MavenBadge](https://maven-badges.herokuapp.com/maven-central/com.moengage/geofence/badge.svg)

For `moengage_geofence` version less than`5.0.0`,
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