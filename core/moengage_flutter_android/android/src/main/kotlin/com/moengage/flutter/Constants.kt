package com.moengage.flutter

import android.os.Build.VERSION

/**
 * @author Umang Chamaria
 * Date: 2019-12-12
 */

const val MODULE_TAG = "MoEFlutter_"
const val INTEGRATION_TYPE = "flutter"
const val FLUTTER_PLUGIN_CHANNEL_NAME = "com.moengage/core"

//Method name constants
const val METHOD_NAME_INITIALISE = "initialise"
const val METHOD_NAME_TRACK_EVENT = "trackEvent"
const val METHOD_NAME_SET_USER_ATTRIBUTE = "setUserAttribute"
const val METHOD_NAME_SET_ALIAS = "setAlias"
const val METHOD_NAME_SET_USER_ATTRIBUTE_LOCATION = "setUserAttributeLocation"
const val METHOD_NAME_SET_USER_ATTRIBUTE_TIMESTAMP = "setUserAttributeTimestamp"
const val METHOD_NAME_SET_APP_STATUS = "setAppStatus"
const val METHOD_NAME_SHOW_IN_APP = "showInApp"
const val METHOD_NAME_LOGOUT = "logout"
const val METHOD_NAME_PUSH_TOKEN = "pushToken"
const val METHOD_NAME_PUSH_PAYLOAD = "pushPayload"
const val METHOD_NAME_SELF_HANDLED_INAPP = "selfHandledInApp"
const val METHOD_NAME_SET_APP_CONTEXT = "setAppContext"
const val METHOD_NAME_RESET_APP_CONTEXT = "resetCurrentContext"
const val METHOD_NAME_OPT_OUT_TRACKING = "optOutTracking"
const val METHOD_NAME_SELF_HANDLED_CALLBACK = "selfHandledCallback"
const val METHOD_NAME_UPDATE_SDK_STATE = "updateSdkState"
const val METHOD_NAME_ON_ORIENTATION_CHANGED = "onOrientationChanged"
const val METHOD_NAME_UPDATE_DEVICE_IDENTIFIER_TRACKING_STATUS =
    "updateDeviceIdentifierTrackingStatus"
const val METHOD_NAME_SETUP_NOTIFICATION_CHANNEL = "setupNotificationChannels"
const val METHOD_NAME_NAVIGATE_TO_SETTINGS = "navigateToSettings"
const val METHOD_NAME_REQUEST_PUSH_PERMISSION = "requestPushPermission"
const val METHOD_NAME_PERMISSION_RESPONSE = "permissionResponse"

const val KEY_TYPE = "type"

const val METHOD_NAME_PUSH_PERMISSION_PERMISSION_COUNT = "updatePushPermissionRequestCount"

// Asset Location for config.json under moengage_flutter package.
const val ASSET_CONFIG_FILE_PATH = "flutter_assets/packages/moengage_flutter/config.json"
const val VERSION_KEY = "version"