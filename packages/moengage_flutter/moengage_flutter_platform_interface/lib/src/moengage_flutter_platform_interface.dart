import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../src/model/inapp/self_handled_campaigns_data.dart';
import '../src/model/permission_type.dart';
import '../src/model/properties.dart';
import '../src/model/push/moe_push_service.dart';
import 'internal/method_channel_moengage_flutter.dart';
import 'model/app_status.dart';
import 'model/design_mode_element_tag.dart';
import 'model/gender.dart';
import 'model/geo_location.dart';
import 'model/inapp/nudge_position.dart';
import 'model/moe_init_config.dart';
import 'model/native_tooltip_overlay_type.dart';
import 'model/user_deletion_data.dart';

/// Platform Interface for MoEngage Flutter Plugin
abstract class MoEngageFlutterPlatform extends PlatformInterface {
  /// [MoEngageFlutterPlatform] Constructor
  MoEngageFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static MoEngageFlutterPlatform _instance = MethodChannelMoEngageFlutter();

  /// Returns instance of [MoEngageFlutterPlatform] to use.
  /// Defaults to [MethodChannelMoEngageFlutter].
  static MoEngageFlutterPlatform get instance => _instance;

  static set instance(MoEngageFlutterPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Initialize the MoEngage SDK
  /// [moEInitConfig] - Instance of [MoEInitConfig]
  /// [appId] - MoEngage App ID
  void initialise(MoEInitConfig moEInitConfig, String appId);

  /// Track user behaviour as events with properties
  /// [eventName] - Name of the Event to be tracked
  /// [eventAttributes] - Instance of [MoEProperties]
  /// [appId] - MoEngage App ID
  void trackEvent(
      String eventName, MoEProperties eventAttributes, String appId);

  /// Set an Unique Identifier for the user
  /// [uniqueId] - Unique User Id of type [String]
  /// [appId] - MoEngage App ID
  void setUniqueId(String uniqueId, String appId);

  /// Update user's unique id which was previously set by setUniqueId().
  /// [newUniqueId] - New Unique Id of the user
  /// [appId] - MoEngage App ID
  void setAlias(String newUniqueId, String appId);

  /// Tracks user-name as a user attribute.
  /// [userName] - User Name Attribute
  /// [appId] - Full Name value passed by user
  void setUserName(String userName, String appId);

  /// Tracks first name as a user attribute.
  /// [firstName] - First Name of the User
  /// [appId] - MoEngage App ID
  void setFirstName(String firstName, String appId);

  /// Tracks last name as a user attribute.
  /// [lastName] - Last Name of the User
  /// [appId] - MoEngage App ID
  void setLastName(String lastName, String appId);

  /// Tracks user's email-id as a user attribute.
  /// [emailId] - Email Id of the User
  /// [appId] - MoEngage App ID
  void setEmail(String emailId, String appId);

  /// Tracks phone number as a user attribute.
  /// [phoneNumber] - Phone Number of the User
  /// [appId] - MoEngage App ID
  void setPhoneNumber(String phoneNumber, String appId);

  /// Tracks gender as a user attribute.
  /// [gender] - Instance of [MoEGender]
  /// [appId] - MoEngage App ID
  void setGender(MoEGender gender, String appId);

  /// Set's user's location
  /// [location] - Instance of [MoEGeoLocation]
  /// [appId] - MoEngage App ID
  void setLocation(MoEGeoLocation location, String appId);

  /// Set user's birth-date.
  /// Birthdate should be sent in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  /// [birthDate] - ISO Formatted Date String
  /// [appId] - MoEngage App ID
  void setBirthDate(String birthDate, String appId);

  /// Tracks a user attribute.
  /// [userAttributeValue] - Data of type [dynamic]
  /// [userAttributeName] - Name of User Attribute
  /// [appId] - MoEngage App ID
  void setUserAttribute(
      String userAttributeName, dynamic userAttributeValue, String appId);

  /// Tracks the given time as user-attribute.<br/>
  /// Date should be passed in the following format - yyyy-MM-dd'T'HH:mm:ss.fff'Z'
  /// [userAttributeName] - Name of User Attribute
  /// [isoDateString] - ISO Formatted Date String
  /// [appId] - MoEngage App ID
  void setUserAttributeIsoDate(
      String userAttributeName, String isoDateString, String appId);

  /// Tracks the given location as user attribute.
  /// [userAttributeName] - Name of User Attribute
  /// [location] - Instance of [MoEGeoLocation]
  /// [appId] - MoEngage App ID
  void setUserAttributeLocation(
      String userAttributeName, MoEGeoLocation location, String appId);

  /// This API tells the SDK whether it is a fresh install or an existing application was updated.
  /// [appStatus] - Instance of [MoEAppStatus]
  /// [appId] - MoEngage App ID
  void setAppStatus(MoEAppStatus appStatus, String appId);

  /// Try to show an InApp Message.
  /// [appId] - MoEngage App ID
  void showInApp(String appId);

  /// Invalidates the existing user and session. A new user
  /// and session is created.
  /// [appId] - MoEngage App ID
  void logout(String appId);

  /// Try to return a self handled in-app to the callback listener.
  /// Ensure self handled in-app listener is set before you call this.
  /// [appId] - MoEngage App ID
  void getSelfHandledInApp(String appId);

  /// Self Handled InApp Action Callback
  /// [appId] - MoEngage App ID
  /// [payload] - SelfHandled InApp Payload of type [Map]
  void selfHandledCallback(Map<String, dynamic> payload);

  ///Set the current context for the given user for InApps
  /// [appId] - MoEngage App ID
  /// [contexts] - [List] of Context
  void setCurrentContext(List<String> contexts, String appId);

  /// Reset Current Context for InApps
  /// [appId] - MoEngage App ID
  void resetCurrentContext(String appId);

  /// Pass Push Token To Native SDK
  /// [appId] - MoEngage App ID
  /// [pushService] - Type of [MoEPushService]
  /// [pushToken] - Device Push Token
  void passPushToken(
      String pushToken, MoEPushService pushService, String appId);

  ///Opt Out Data Tracking
  /// [appId] - MoEngage App ID
  /// [optOutDataTracking] - Data Tracking OptOut State
  void optOutDataTracking(bool optOutDataTracking, String appId);

  /// Push Notification Registration
  /// [appId] - MoEngage App ID
  void registerForPushNotification();

  /// Pass Push Payload to the MoEngage SDK.
  /// [appId] - MoEngage App ID
  /// [payload] - Push Payload Data
  /// [pushService] - Type of [MoEPushService]
  void passPushPayload(
      Map<String, dynamic> payload, MoEPushService pushService, String appId);

  /// Update SDK State
  /// [appId] - MoEngage App ID
  /// [shouldEnableSdk] - SDK Enable State
  void updateSdkState(bool shouldEnableSdk, String appId);

  /// To be called when Orientation of the App Is Changed
  void onOrientationChanged();

  /// Update Device tracking status for the identifier type
  /// [appId] - MoEngage App ID
  /// [identifierType] - Type of Identifier
  /// [state] - [Bool] value for Enable/Disable State
  void updateDeviceIdentifierTrackingStatus(
      String appId, String identifierType, bool state);

  ///API to create notification channels on Android.
  void setupNotificationChannel();

  /// Notify the SDK on notification permission granted to the application.
  /// [isGranted] - Push Permission Granted Flag
  /// [type] - Type of [PermissionType]
  void permissionResponse(bool isGranted, PermissionType type);

  /// Navigates the user to the Notification settings
  void navigateToSettings();

  /// Requests the push notification permission
  void requestPushPermission();

  /// Update Push Permission Request Count
  /// [requestCount] This count will be incremented to existing value
  /// [appId] - MoEngage App ID
  void updatePushPermissionRequestCountAndroid(int requestCount, String appId);

  /// Delete User Data from MoEngage Server
  /// [appId] - MoEngage App ID
  /// @returns - Instance of [Future] of type [UserDeletionData]
  /// @since 1.1.0
  Future<UserDeletionData> deleteUser(String appId) =>
      throw UnimplementedError('deleteUser() not implemented for Platform');

  /// Try to show a non-intrusive In-App nudge.
  /// [position] - Nudge InApp Position of type [MoEngageNudgePosition]
  /// [appId] - MoEngage App ID
  /// @since 2.0.0
  void showNudge(MoEngageNudgePosition position, String appId) =>
      throw UnimplementedError('showNudge() not implemented for Platform');

  /// Get Multiple Self Handled InApps
  /// @returns - Instance of [Future] of type [SelfHandledCampaignsData]
  /// @since 3.1.0
  Future<SelfHandledCampaignsData> getSelfHandledInApps(String appId) =>
      throw UnimplementedError(
          'getSelfHandledInApps() not implemented for Platform');

  /// Register for Provisional Push
  /// @since 3.1.0
  void registerForProvisionalPush() => throw UnimplementedError(
      'registerForProvisionalPush() not implemented for Platform');

  /// Identify the user with the given identity.
  /// @since 3.2.0
  void identifyUser(dynamic identity, String appId) =>
      throw UnimplementedError('identifyUser() not implemented for Platform');

  /// Return Identities of the user that has been set.
  /// @since 3.2.0
  Future<Map<String, String>?> getUserIdentities(String appId) =>
      throw UnimplementedError(
          'getUserIdentities() not implemented for Platform');

  /// Notifies native that the Design Mode element picker has been activated.
  void activateDesignMode() => throw UnimplementedError(
      'activateDesignMode() not implemented for Platform');

  /// Notifies native that the Design Mode element picker has been deactivated.
  void deactivateDesignMode() => throw UnimplementedError(
      'deactivateDesignMode() not implemented for Platform');

  /// Reports a marketer-confirmed Design Mode element selection to native.
  /// [tag] - Instance of [DesignModeElementTag]
  void reportDesignModeElementSelected(DesignModeElementTag tag) =>
      throw UnimplementedError(
          'reportDesignModeElementSelected() not implemented for Platform');

  /// Sets the handler invoked when native asks Flutter to activate/deactivate
  /// the Design Mode element picker (e.g. from a native debug menu).
  /// [onActivate] - called when native requests activation
  /// [onDeactivate] - called when native requests deactivation
  void setDesignModeActivationHandler(
    void Function() onActivate,
    void Function() onDeactivate,
  ) =>
      throw UnimplementedError(
          'setDesignModeActivationHandler() not implemented for Platform');

  /// Asks native to render a tooltip anchored to [anchor]'s resolved bounds,
  /// e.g. when a hardcoded/backend campaign matches the currently active
  /// screen.
  /// [anchor] - Instance of [DesignModeElementTag] identifying the target
  /// widget and its bounds.
  /// [message] - Tooltip copy to render natively. Only honoured by the
  /// [NativeTooltipOverlayType.tooltip] overlay type, and only if the
  /// native SDK's public API supports custom copy - `com.moengage:tooltip`
  /// 1.0.0's imperative helpers currently always render fixed default copy.
  /// [overlayType] - which native overlay to render; defaults to
  /// [NativeTooltipOverlayType.tooltip].
  void showElementTooltip({
    required DesignModeElementTag anchor,
    required String message,
    NativeTooltipOverlayType overlayType = NativeTooltipOverlayType.tooltip,
  }) =>
      throw UnimplementedError(
          'showElementTooltip() not implemented for Platform');

  /// Dismisses the tooltip shown by [showElementTooltip], if any. Called
  /// whenever the active screen changes so the tooltip doesn't outlive the
  /// screen it was anchored to.
  void dismissElementTooltip() => throw UnimplementedError(
      'dismissElementTooltip() not implemented for Platform');

  /// Moves the tooltip already showing for [nodeId] to freshly measured
  /// [bounds], so it follows its anchor element through a scroll.
  ///
  /// This re-anchors the existing overlay rather than showing a new one:
  /// re-showing would track a second impression per scroll frame and leave the
  /// previous card on screen. A no-op natively when no tooltip is showing for
  /// [nodeId].
  ///
  /// [bounds] - the element's current bounds, in physical pixels.
  /// [nodeId] - identity of the anchor element, as sent in
  /// [showElementTooltip]'s [DesignModeElementTag].
  /// [overlayType] - which overlay to move; the tooltip and the beacon are
  /// separate native objects with separate re-anchor calls.
  void updateElementTooltipAnchor({
    required DesignModeElementBounds bounds,
    required String nodeId,
    NativeTooltipOverlayType overlayType = NativeTooltipOverlayType.tooltip,
  }) =>
      throw UnimplementedError(
          'updateElementTooltipAnchor() not implemented for Platform');

  /// Asks native to show coach marks highlighting every element in [steps] at
  /// once - one dimmed overlay with a cutout per target.
  ///
  /// Unlike the single-element overlays this takes a list, because a coach mark
  /// is inherently a multi-target tour: all of its targets are highlighted on
  /// the same scrim. Each entry carries the element's resolved `bounds` plus its
  /// own copy - see `MoECoachMarkStep.toMap()`.
  ///
  /// Coach marks don't follow their elements: several cutouts and cards are
  /// placed together and native has no API to move them once shown.
  void showElementCoachMarks({
    required List<Map<String, dynamic>> steps,
  }) =>
      throw UnimplementedError(
          'showElementCoachMarks() not implemented for Platform');

  /// Dismisses the coach mark overlay shown by [showElementCoachMarks], if any.
  void dismissElementCoachMarks() => throw UnimplementedError(
      'dismissElementCoachMarks() not implemented for Platform');
}
