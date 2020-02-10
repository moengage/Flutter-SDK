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
  String METHOD_NAME_PUSH_TOKEN = "pushToken";
  String METHOD_NAME_PUSH_PAYLOAD = "pushPayload";

  String METHOD_NAME_ON_PUSH_CLICK = "onPushClick";
  String METHOD_NAME_ON_INAPP_SHOWN = "onInAppShown";
  String METHOD_NAME_ON_INAPP_CLICKED = "onInAppClick";

  String PARAM_PLATFORM = "platform";
  String PARAM_PAYLOAD = "payload";
  String PARAM_CAMPAIGN_ID = "campaignId";
  String PARAM_SCREEN_NAME = "screenName";
  String PARAM_DEEP_LINK = "deepLinkUrl";
  String PARAM_KEY_VALUE_PAIR = "kvPairs";
  String PARAM_PLATFORM_VALUE = "android";

  String INTEGRATION_TYPE = "flutter";
}
