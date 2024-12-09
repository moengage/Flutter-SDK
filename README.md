![Logo](/.github/logo.png)

## MoEngage Flutter Plugin

This repository contains the Flutter plugins for the [MoEngage](https://www.moengage.com) platform.

### Repository Description

| Folder                      | Description                                                                       |
|-----------------------------|-----------------------------------------------------------------------------------|
| packages/moengage_flutter   | Contains the implementation for the SDK implementation for Core MoEngage Platform |
| packages/moengage_inbox     | Contains the implementation for the SDK implementation for Inbox Feature          |
| packages/moengage_cards     | Contains the implementation for the SDK implementation for Cards Feature          |
| packages/moengage_geofence  | Contains the implementation for the SDK implementation for Geofence Feature       |
| example                     | Sample Integration for reference.                                                 |

# How to run the sample application?

## Update MoEngage Workspace Id/AppId

Before running the sample application, you need to update your MoEngage workspace-id(Previously referred as AppId)  in various files as follows:

### Dart

- In the `example/lib/constants.dart` file, update the `WORKSPACE_ID` constant with your actual Workspace ID from the MoEngage Dashboard.

    ```dart
    const String WORKSPACE_ID = '<YOUR_WORKSPACE_ID>';
    ```

### Android
Add the MoEngage app-id in the `local.properties` file of `example --> android`. Add the below key and value and replace `moengageWorkspaceId`` with the Workspace Id on the MoEngage Dashboard.
```
moengageWorkspaceId=YOUR_WORKSPACE_ID
```
- Replace your `google-services.json` file in the `example/android/app` directory.

### iOS

- In the `example/ios/Runner/AppDelegate.swift` file, update the `yourWorkspaceID` variable with your actual App ID.

    ```swift
    let yourWorkspaceID = "<YOUR_WORKSPACE_ID>"
    ```

- Add your `GoogleService-Info.plist` file to the `example/ios/Runner` directory.

### Web

- In the `example/web/index.html` file, update the `moeWorkspaceID` variable with your actual App ID.

    ```html
    <script>
     var moeWorkspaceID = "<YOUR_WORKSPACE_ID>";
    </script>
    ```

## Running the Application

After updating the Workspace ID and placing the necessary platform-specific files, follow the instructions below to run the application:

1. Setting Up the Project, Install Melos and Fetch Flutter dependencies

   a. Using setup script
      - Simply run the following command in the root directory
      ```sh
      sh scripts/setup.sh
      ```
   b. Using the Command-Line Interface (CLI)
      - Install Melos CLI tool using `dart pub global activate melos` if not installed already
      - Setup project using `melos bootstrap` command in the root directory
      - Run `melos get` command in the root directory to fetch all the dependencies.
2. Open the terminal and navigate to the `example` directory.
3. To run on Android or iOS, connect a device or start an emulator.
4. Run the application with `flutter run` for your targeted platform.

Ensure that you have set up the development environment for Flutter and the respective platform you are targeting (Android Studio/Xcode for Android/iOS, updated web browser for Web) before attempting to run the sample application.