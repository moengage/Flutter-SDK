# MoEngage Inbox Plugin

Inbox Plugin for MoEngage Platform

## SDK Installation

To add the MoEngage Flutter SDK to your application, edit your application's `pubspec.yaml` file and add the below dependency to it:

![Download](https://img.shields.io/pub/v/moengage_inbox.svg)

```yaml
dependencies:
 moengage_inbox: $latestSdkVersion
```
replace `$latestSdkVersion` with the latest SDK version.

Run flutter packages get to install the SDK.
 
 Note: This plugin is dependent on `moengage_flutter` plugin. Make sure you have installed the `moengage_flutter
 ` make sure you have installed the `moengage_flutter` plugin as well. Refer to the 
 
 ### Android Installation

> **Breaking Change:**
> Starting from `moengage_inbox` plugin version `8.0.0`, the `inbox-core` dependency is included within the plugin itself.
> Developers should remove the `inbox-core` dependency from the `build.gradle` as it is now included with the plugin.

![MavenBadge](https://maven-badges.herokuapp.com/maven-central/com.moengage/inbox-core/badge.svg) 

For `moengage_inbox` version less than`8.0.0`,
  Once you install the Flutter Plugin add MoEngage's native Android SDK dependency to the Android project of your application.
  Navigate to `android --> app --> build.gradle`. Add the MoEngage Android SDK's dependency in the `dependencies` block
  
  ```groovy
  dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    implementation("com.moengage:inbox-core:$sdkVersion")
}
  ```
where `$sdkVersion` should be replaced by the latest version of the MoEngage SDK.

Refer to the [Documentation](https://developers.moengage.com/hc/en-us/articles/4404365709588-Notification-Center) for complete integration guide.
