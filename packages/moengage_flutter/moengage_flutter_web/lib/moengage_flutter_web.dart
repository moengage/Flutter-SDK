import 'dart:js';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart'
    hide keyAlias, keyEventAttributes, keyEventName, getIdentifyUserPayload;
import 'constants.dart';
import 'utils.dart';

/// The Web implementation of [MoEngageFlutterPlatform].
class MoEngageFlutterWeb extends MoEngageFlutterPlatform {
  /// Registers this class as the default instance of [MoEngageFlutterPlatform]
  static void registerWith([Object? registrar]) {
    MoEngageFlutterPlatform.instance = MoEngageFlutterWeb();
  }

  JsObject? _moengage;
  @override
  void initialise(MoEInitConfig moEInitConfig, String appId) {
    Logger.d('initialise() : Initialising MoEngage web SDK');
    moengageInitialiser();
  }

  // ignore: public_member_api_docs
  void moengageInitialiser() {
    _moengage = JsObject.fromBrowserObject(context['Moengage'] as Object);
  }

  @override
  void trackEvent(
    String eventName,
    MoEProperties eventAttributes,
    String appId,
  ) {
    final Map<String, dynamic> payload =
        getEventPayloadWeb(eventName, eventAttributes);
    _moengage?.callMethod(methodTrackEventSDK, [
      payload[keyEventName],
      JsObject.jsify(payload[keyEventAttributes] as Object)
    ]);
  }

  @override
  void logout(String appId) {
    _moengage?.callMethod(methodLogoutSDK);
  }

  @override
  void setUserAttribute(
    String userAttributeName,
    dynamic userAttributeValue,
    String appId,
  ) {
    _moengage?.callMethod(
      methodSetUserAttributeSDK,
      [userAttributeName, getUserAttributeValuePayload(userAttributeValue)],
    );
  }

  @override
  void setAlias(String newUniqueId, String appId) {
    _moengage?.callMethod(methodSetAliasSDK, [newUniqueId]);
  }

  @override
  void setBirthDate(String birthDate, String appId) {
    _moengage?.callMethod(
      methodSetUserAttributeSDK,
      [userAttrNameBirtdate, birthDate],
    );
  }

  @override
  void setEmail(String emailId, String appId) {
    _moengage
        ?.callMethod(methodSetUserAttributeSDK, [userAttrNameEmailId, emailId]);
  }

  @override
  void setFirstName(String firstName, String appId) {
    _moengage?.callMethod(
      methodSetUserAttributeSDK,
      [userAttrNameFirstName, firstName],
    );
  }

  @override
  void setGender(MoEGender gender, String appId) {
    _moengage?.callMethod(
      methodSetUserAttributeSDK,
      [userAttrNameGender, genderToString(gender)],
    );
  }

  @override
  void setLastName(String lastName, String appId) {
    _moengage?.callMethod(
      methodSetUserAttributeSDK,
      [userAttrNameLastName, lastName],
    );
  }

  @override
  void setPhoneNumber(String phoneNumber, String appId) {
    _moengage?.callMethod(
      methodSetUserAttributeSDK,
      [userAttrNamePhoneNum, phoneNumber],
    );
  }

  @override
  void setUniqueId(String uniqueId, String appId) {
    _moengage?.callMethod(
      methodSetUserAttributeSDK,
      [userAttrNameUniqueId, uniqueId],
    );
  }

  @override
  void identifyUser(dynamic identity, String appId) {
    if (!isSupportedIdentity(identity)) {
      Logger.w('$tag identifyUser(): Identity type is not supported');
      return;
    }
    _moengage?.callMethod(
      methodIdentifyUser,
      [getIdentifyUserPayload(identity)],
    );
  }

  @override
  Future<Map<String, String>?> getUserIdentities(String appId) async {
    try {
      final dynamic identity = await  _moengage?.callMethod(
          methodGetUserIdentities);
      return Future.value(convertJSObjectToMap(identity) as Map<String, String>?);
    } catch (e) {
      Logger.e(' $tag getUserIdentities(): Error', error: e);
      return Future.error(e);
    }
  }

  @override
  void setUserName(String userName, String appId) {
    _moengage?.callMethod(
      methodSetUserAttributeSDK,
      [userAttrNameUserName, userName],
    );
  }

  @override
  void setUserAttributeIsoDate(
    String userAttributeName,
    String isoDateString,
    String appId,
  ) {
    Logger.v('setUserAttributeIsoDate(): Not supported in Web Platform');
  }

  @override
  void setUserAttributeLocation(
    String userAttributeName,
    MoEGeoLocation location,
    String appId,
  ) {
    Logger.v('setUserAttributeLocation(): Not supported in Web Platform');
  }

  @override
  void navigateToSettings() {
    Logger.v('navigateToSettings(): Not supported in Web Platform');
  }

  @override
  void onOrientationChanged() {
    Logger.v('onOrientationChanged(): Not supported in Web Platform');
  }

  @override
  void passPushPayload(
    Map<String, dynamic> payload,
    MoEPushService pushService,
    String appId,
  ) {
    Logger.v('passPushPayload(): Not supported in Web Platform');
  }

  @override
  void passPushToken(
    String pushToken,
    MoEPushService pushService,
    String appId,
  ) {
    Logger.v('passPushToken(): Not supported in Web Platform');
  }

  @override
  void permissionResponse(bool isGranted, PermissionType type) {
    Logger.v('permissionResponse(): Not supported in Web Platform');
  }

  @override
  void requestPushPermission() {
    Logger.v('requestPushPermission(): Not supported in Web Platform');
  }

  @override
  void setupNotificationChannel() {
    Logger.v('setupNotificationChannel(): Not supported in Web Platform');
  }

  @override
  void updateDeviceIdentifierTrackingStatus(
    String appId,
    String identifierType,
    bool state,
  ) {
    Logger.v(
      'updateDeviceIdentifierTrackingStatus(): Not supported in Web Platform',
    );
  }

  @override
  void updatePushPermissionRequestCountAndroid(int requestCount, String appId) {
    Logger.v(
      'updatePushPermissionRequestCountAndroid(): Not supported in Web Platform',
    );
  }

  @override
  void getSelfHandledInApp(String appId) {
    Logger.v(
      'updatePushPermissionRequestCountAndroid(): Not supported in Web Platform',
    );
  }

  @override
  void optOutDataTracking(bool optOutDataTracking, String appId) {
    Logger.v('optOutDataTracking(): Not supported in Web Platform');
  }

  @override
  void registerForPushNotification() {
    Logger.v('registerForPushNotification(): Not supported in Web Platform');
  }

  @override
  void resetCurrentContext(String appId) {
    Logger.v('resetCurrentContext(): Not supported in Web Platform');
  }

  @override
  void selfHandledCallback(Map<String, dynamic> payload) {
    Logger.v('selfHandledCallback(): Not supported in Web Platform');
  }

  @override
  void setAppStatus(MoEAppStatus appStatus, String appId) {
    Logger.v('setAppStatus(): Not supported in Web Platform');
  }

  @override
  void setCurrentContext(List<String> contexts, String appId) {
    Logger.v('setCurrentContext(): Not supported in Web Platform');
  }

  @override
  void setLocation(MoEGeoLocation location, String appId) {
    Logger.v('setLocation(): Not supported in Web Platform');
  }

  @override
  void showInApp(String appId) {
    Logger.v('showInApp(): Not supported in Web Platform');
  }

  @override
  void updateSdkState(bool shouldEnableSdk, String appId) {
    Logger.v('updateSdkState(): Not supported in Web Platform');
  }
}
