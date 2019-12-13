package com.moengage.flutter;



/**
 * @author Umang Chamaria
 * Date: 2019-12-12
 */
public interface Constants {

  String METHOD_NAME_INITIALISE = "initialise";
  String METHOD_NAME_TRACK_EVENT = "trackEvent";
  String METHOD_NAME_SET_USER_ATTRIBUTE = "setUserAttribute";
  String METHOD_NAME_SET_ALIAS = "setAlias";
  String METHOD_NAME_SET_USER_ATTRIBUTE_LOCATION = "setUserAttributeLocation";
  String METHOD_NAME_SET_USER_ATTRIBUTE_TIMESTAMP = "setUserAttributeTimestamp";
  String METHOD_NAME_SET_APP_STATUS = "setAppStatus";
  String METHOD_NAME_SHOW_IN_APP = "showInApp";
  String METHOD_NAME_LOGOUT = "logout";

  String METHOD_NAME_ON_PUSH_CLICK = "onPushClick";
  String METHOD_NAME_ON_INAPP_SHOWN = "onInAppShown";
  String METHOD_NAME_ON_INAPP_CLICKED = "onInAppClick";

  String INTEGRATION_TYPE = "flutter";
  int SDK_VERSION = 100;
  String version = BuildConfig.LIBRARY_VERSION;
}
