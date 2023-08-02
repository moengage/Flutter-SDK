import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../src/model/app_status.dart';
import '../src/model/gender.dart';
import '../src/model/geo_location.dart';
import '../src/model/moe_init_config.dart';
import '../src/model/permission_type.dart';
import '../src/model/properties.dart';
import '../src/model/push/moe_push_service.dart';
import 'method_channel_moengage_flutter.dart';

abstract class MoEngageFlutterPlatform extends PlatformInterface {
  MoEngageFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static MoEngageFlutterPlatform _instance = MethodChannelMoEngageFlutter();

  /// The default instance of [MoengageFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelMoengageFlutter].
  static MoEngageFlutterPlatform get instance => _instance;

  static set instance(MoEngageFlutterPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  void initialise(MoEInitConfig moEInitConfig, String appId);

  void trackEvent(
      String eventName, MoEProperties eventAttributes, String appId);

  void setUniqueId(String uniqueId, String appId);

  void setAlias(String newUniqueId, String appId);

  void setUserName(String userName, String appId);

  void setFirstName(String firstName, String appId);

  void setLastName(String lastName, String appId);

  void setEmail(String emailId, String appId);

  void setPhoneNumber(String phoneNumber, String appId);

  void setGender(MoEGender gender, String appId);

  void setLocation(MoEGeoLocation location, String appId);

  void setBirthDate(String birthDate, String appId);

  void setUserAttribute(
      String userAttributeName, dynamic userAttributeValue, String appId);

  void setUserAttributeIsoDate(
      String userAttributeName, String isoDateString, String appId);

  void setUserAttributeLocation(
      String userAttributeName, MoEGeoLocation location, String appId);

  void setAppStatus(MoEAppStatus appStatus, String appId);

  void showInApp(String appId);

  void logout(String appId);

  void getSelfHandledInApp(String appId);

  void selfHandledCallback(Map<String, dynamic> payload);

  void setCurrentContext(List<String> contexts, String appId);

  void resetCurrentContext(String appId);

  void passPushToken(
      String pushToken, MoEPushService pushService, String appId);

  void optOutDataTracking(bool shouldOptOutDataTracking, String appId);

  void registerForPushNotification();

  void passPushPayload(
      Map<String, dynamic> payload, MoEPushService pushService, String appId);

  void updateSdkState(bool shouldEnableSdk, String appId);

  void onOrientationChanged();

  void updateDeviceIdentifierTrackingStatus(
      String appId, String identifierType, bool state);

  void setupNotificationChannel();

  void permissionResponse(bool isGranted, PermissionType type);

  void navigateToSettings();

  void requestPushPermissionAndroid();

  void updatePushPermissionRequestCountAndroid(int requestCount, String appId);
}
