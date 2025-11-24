import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart'
    hide
        keyAlias,
        keyEventAttributes,
        keyEventName,
        getIdentifyUserPayload;
import 'package:web/web.dart' as web;

import 'constants.dart';
import 'utils.dart' as web_utils;

/// The Web implementation of [MoEngageFlutterPlatform].
class MoEngageFlutterWeb extends MoEngageFlutterPlatform {
  /// Registers this class as the default instance of [MoEngageFlutterPlatform]
  static void registerWith([Object? registrar]) {
    MoEngageFlutterPlatform.instance = MoEngageFlutterWeb();
  }

  JSObject? _moengage;
  @override
  void initialise(MoEInitConfig moEInitConfig, String appId) {
    Logger.d('initialise() : Initialising MoEngage web SDK');
    moengageInitialiser();
  }

  // ignore: public_member_api_docs
  void moengageInitialiser() {
    _moengage = (web.window as JSObject)['Moengage'] as JSObject?;
  }

  void _callMethod(String methodName, [JSAny? arg1, JSAny? arg2]) {
    final moengage = _moengage;
    if (moengage == null) {
      return;
    }
    
    final method = moengage.getProperty(methodName.toJS);
    if (method != null && method.typeofEquals('function')) {
      final jsFunction = method as JSFunction;
      if (arg1 != null && arg2 != null) {
        jsFunction.callAsFunction(moengage, arg1, arg2);
      } else if (arg1 != null) {
        jsFunction.callAsFunction(moengage, arg1);
      } else {
        jsFunction.callAsFunction(moengage);
      }
    }
  }

  @override
  void trackEvent(
    String eventName,
    MoEProperties eventAttributes,
    String appId,
  ) {
    final Map<String, dynamic> payload =
        web_utils.getEventPayloadWeb(eventName, eventAttributes);
    final moengage = _moengage;
    if (moengage != null) {
      _callMethod(
        methodTrackEventSDK,
        eventName.toJS,
        (payload[keyEventAttributes] as Map<String, dynamic>).jsify(),
      );
    }
  }

  @override
  void logout(String appId) {
    _callMethod(methodLogoutSDK);
  }

  @override
  void setUserAttribute(
    String userAttributeName,
    dynamic userAttributeValue,
    String appId,
  ) {
    final moengage = _moengage;
    if (moengage != null) {
      final jsValue = web_utils.getUserAttributeValuePayload(userAttributeValue).toJS;

      _callMethod(
        methodSetUserAttributeSDK,
        userAttributeName.toJS,
        jsValue is JSAny ? jsValue : null,
      );
    }
  }

  @override
  void setAlias(String newUniqueId, String appId) {
    _callMethod(methodSetAliasSDK, newUniqueId.toJS);
  }

  @override
  void setBirthDate(String birthDate, String appId) {
    _callMethod(
      methodSetUserAttributeSDK,
      userAttrNameBirtdate.toJS,
      birthDate.toJS,
    );
  }

  @override
  void setEmail(String emailId, String appId) {
    _callMethod(
      methodSetUserAttributeSDK,
      userAttrNameEmailId.toJS,
      emailId.toJS,
    );
  }

  @override
  void setFirstName(String firstName, String appId) {
    _callMethod(
      methodSetUserAttributeSDK,
      userAttrNameFirstName.toJS,
      firstName.toJS,
    );
  }

  @override
  void setGender(MoEGender gender, String appId) {
    _callMethod(
      methodSetUserAttributeSDK,
      userAttrNameGender.toJS,
      genderToString(gender).toJS,
    );
  }

  @override
  void setLastName(String lastName, String appId) {
    _callMethod(
      methodSetUserAttributeSDK,
      userAttrNameLastName.toJS,
      lastName.toJS,
    );
  }

  @override
  void setPhoneNumber(String phoneNumber, String appId) {
    _callMethod(
      methodSetUserAttributeSDK,
      userAttrNamePhoneNum.toJS,
      phoneNumber.toJS,
    );
  }

  @override
  void setUniqueId(String uniqueId, String appId) {
    _callMethod(
      methodSetUniqueIdSDK,
      uniqueId.toJS,
    );
  }

  @override
  void identifyUser(dynamic identity, String appId) {
    if (!isSupportedIdentity(identity)) {
      Logger.w('$tag identifyUser(): Identity type is not supported');
      return;
    }

    final identityPayload = web_utils.getIdentifyUserPayload(identity);
    _callMethod(methodIdentifyUserSDK, identityPayload as JSAny);
  }

  @override
  Future<Map<String, String>?> getUserIdentities(String appId) async {
    try {
      final moengage = _moengage;
      if (moengage == null) {
        return null;
      }
      
      final method = moengage.getProperty(methodGetUserIdentitiesSDK.toJS);
      if (method != null && method.typeofEquals('function')) {
        final result = (method as JSFunction).callAsFunction(moengage);
        final dynamicMap = web_utils.convertJSObjectToMap(result);
        final stringMap = dynamicMap?.map((key, value) => MapEntry(key, value.toString()));
        return Future.value(stringMap);
      }
      return null;
    } catch (e) {
      Logger.e(' $tag getUserIdentities(): Error', error: e);
      return Future.error(e);
    }
  }

  @override
  void setUserName(String userName, String appId) {
    _callMethod(
      methodSetUserAttributeSDK,
      userAttrNameUserName.toJS,
      userName.toJS,
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
    final moengage = _moengage;
    if (moengage == null) {
      return;
    }
    
    final methodName = shouldEnableSdk ? methodEnableSDK : methodDisableSDK;
    _callMethod(methodName);
  }
}
