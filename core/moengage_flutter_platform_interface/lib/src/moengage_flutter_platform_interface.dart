import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../src/model/app_status.dart';
import '../src/model/gender.dart';
import '../src/model/geo_location.dart';
import '../src/model/moe_init_config.dart';
import '../src/model/permission_type.dart';
import '../src/model/properties.dart';
import '../src/model/push/moe_push_service.dart';
import 'internal/method_channel_moengage_flutter.dart';

/// Platform Interface for MoEngage Flutter Plugin
abstract class MoEngageFlutterPlatform extends PlatformInterface {
  /// [MoEngageFlutterPlatform] Constructor
  MoEngageFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static MoEngageFlutterPlatform _instance = MethodChannelMoEngageFlutter();

  /// The default instance of [MoEngageFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelMoEngageFlutter].
  static MoEngageFlutterPlatform get instance => _instance;

  static set instance(MoEngageFlutterPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Initialize the MoEngage SDK
  void initialise(MoEInitConfig moEInitConfig, String appId);

  /// Track user behaviour as events with properties
  /// [eventName] - Name of the Event to be tracked
  /// [eventAttributes] - Instance of [MoEProperties]
  void trackEvent(
      String eventName, MoEProperties eventAttributes, String appId);

  /// Set an Unique Identifier for the user
  void setUniqueId(String uniqueId, String appId);

  /// Update user's unique id which was previously set by setUniqueId().
  void setAlias(String newUniqueId, String appId);

  /// Tracks user-name as a user attribute.
  void setUserName(String userName, String appId);

  /// Tracks first name as a user attribute.
  void setFirstName(String firstName, String appId);

  /// Tracks last name as a user attribute.
  void setLastName(String lastName, String appId);

  /// Tracks user's email-id as a user attribute.
  void setEmail(String emailId, String appId);

  /// Tracks phone number as a user attribute.
  void setPhoneNumber(String phoneNumber, String appId);

  /// Tracks gender as a user attribute.
  void setGender(MoEGender gender, String appId);

  /// Set's user's location
  void setLocation(MoEGeoLocation location, String appId);

  /// Set user's birth-date.
  /// Birthdate should be sent in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setBirthDate(String birthDate, String appId);

  /// Tracks a user attribute.
  void setUserAttribute(
      String userAttributeName, dynamic userAttributeValue, String appId);

  /// Tracks the given time as user-attribute.<br/>
  /// Date should be passed in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  void setUserAttributeIsoDate(
      String userAttributeName, String isoDateString, String appId);

  /// Tracks the given location as user attribute.
  void setUserAttributeLocation(
      String userAttributeName, MoEGeoLocation location, String appId);

  /// This API tells the SDK whether it is a fresh install or an existing application was updated.
  void setAppStatus(MoEAppStatus appStatus, String appId);

  /// Try to show an InApp Message.
  void showInApp(String appId);

  /// Invalidates the existing user and session. A new user
  /// and session is created.
  void logout(String appId);

  /// Try to return a self handled in-app to the callback listener.
  /// Ensure self handled in-app listener is set before you call this.
  void getSelfHandledInApp(String appId);

  /// Self Handled InApp Action Callback
  void selfHandledCallback(Map<String, dynamic> payload);

  ///Set the current context for the given user for InApps
  void setCurrentContext(List<String> contexts, String appId);

  /// Reset Current Context for InApps
  void resetCurrentContext(String appId);

  /// Pass Push Token To Native SDK
  void passPushToken(
      String pushToken, MoEPushService pushService, String appId);

  ///Opt Out Data Tracking
  void optOutDataTracking(bool shouldOptOutDataTracking, String appId);

  /// Push Notification Registration
  void registerForPushNotification();

  /// Pass Push Payload to the MoEngage SDK.
  void passPushPayload(
      Map<String, dynamic> payload, MoEPushService pushService, String appId);

  /// Update SDK State
  void updateSdkState(bool shouldEnableSdk, String appId);

  /// To be called when Orientation of the App Is Changed
  void onOrientationChanged();

  /// Update Device tracking status for the identifider type
  void updateDeviceIdentifierTrackingStatus(
      String appId, String identifierType, bool state);

  ///API to create notification channels on Android.
  void setupNotificationChannel();

  /// Notify the SDK on notification permission granted to the application.
  void permissionResponse(bool isGranted, PermissionType type);

  /// Navigates the user to the Notification settings
  void navigateToSettings();

  /// Requests the push notification permission
  void requestPushPermission();

  /// Update Push Permission Request Count
  void updatePushPermissionRequestCountAndroid(int requestCount, String appId);
}
