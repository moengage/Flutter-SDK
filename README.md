![Logo](/.github/logo.png)

## MoEngage Flutter Plugin

This repository contains the Flutter plugins for the [MoEngage](https://www.moengage.com) platform.

### Repository Description

| Folder    | Description                                                                       |
|-----------|-----------------------------------------------------------------------------------|
| core      | Contains the implementation for the SDK implementation for Core MoEngage Platform |
| inbox     | Contains the implementation for the SDK implementation for Inbox Feature          |
| example   | Sample Integration for reference.                                                 |
| cards     | Contains the implementation for the SDK implementation for Cards Feature          |
| geofence  | Contains the implementation for the SDK implementation for Geofence Feature       |


# How to run the sample application?

## Update MoEngage App ID

Before running the sample application, you need to update your MoEngage app-id in various files as follows:

### Dart

- In the `example/lib/constants.dart` file, update the `APP_ID` constant with your actual App ID from the MoEngage Dashboard.

    ```dart
    const String APP_ID = '<Your_App_ID>';
    ```

### Android

- In the `example/android/app/src/main/com/moengage/sampleapp/SampleApplication.kt` file, update the `APP_ID` constant with your actual App ID.

    ```kotlin
    private const val APP_ID = "<YOUR_APP_ID>"
    ```

- Place your `google-services.json` file in the `example/android/app` directory.

### iOS

- In the `example/ios/Runner/AppDelegate.swift` file, update the `yourAppID` variable with your actual App ID.

    ```swift
    let yourAppID = "<YOUR_APP_ID>"
    ```

- Add your `GoogleService-Info.plist` file to the `example/ios/Runner` directory.

### Web

- In the `example/web/index.html` file, update the `moeAppID` variable with your actual App ID.

    ```html
    <script>
     var moeAppID = "<Your_App_ID>";
    </script>
    ```

## Running the Application

After updating the App ID and placing the necessary platform-specific files, follow the instructions below to run the application:

1. Open the terminal and navigate to the `example` directory.
2. Run `flutter pub get` to fetch all the dependencies.
3. To run on Android or iOS, connect a device or start an emulator.
4. Run the application with `flutter run` for your targeted platform.

Ensure that you have set up the development environment for Flutter and the respective platform you are targeting (Android Studio/Xcode for Android/iOS, updated web browser for Web) before attempting to run the sample application.