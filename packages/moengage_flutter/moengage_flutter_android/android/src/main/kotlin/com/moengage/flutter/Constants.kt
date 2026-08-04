package com.moengage.flutter

/**
 * @author Umang Chamaria
 * Date: 2019-12-12
 */

const val MODULE_TAG = "MoEFlutter_"
const val INTEGRATION_TYPE = "flutter"
const val FLUTTER_PLUGIN_CHANNEL_NAME = "com.moengage/core"

// Method name constants
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

// Delete User
const val METHOD_NAME_DELETE_USER = "deleteUser"
const val ERROR_CODE_DELETE_USER = "DELETE_USER_ERROR"

// Non Intrusive Nudge
const val METHOD_NAME_SHOW_NUDGE = "showNudge"

// Self Handled InApps
const val METHOD_NAME_SELF_HANDLED_IN_APPS = "selfHandledInApps"
const val ERROR_CODE_SELF_HANDLED_IN_APPS = "SELF_HANDLED_IN_APPS_ERROR"

// Identify User
const val METHOD_NAME_IDENTIFY_USER = "identifyUser"
const val METHOD_NAME_GET_USER_IDENTITIES = "getUserIdentities"
const val ERROR_CODE_GET_USER_IDENTITIES = "GET_USER_IDENTITIES_ERROR"

// Design Mode Element Picker
// Dart -> Native: notify lifecycle state / report a marketer-confirmed element selection.
const val METHOD_NAME_ACTIVATE_DESIGN_MODE = "activateDesignMode"
const val METHOD_NAME_DEACTIVATE_DESIGN_MODE = "deactivateDesignMode"
const val METHOD_NAME_DESIGN_MODE_ELEMENT_SELECTED = "designModeElementSelected"

// Native -> Dart: ask the Flutter layer to start/stop the element picker overlay
// (e.g. triggered from a native debug menu).
const val CALLBACK_ACTIVATE_DESIGN_MODE = "onActivateDesignMode"
const val CALLBACK_DEACTIVATE_DESIGN_MODE = "onDeactivateDesignMode"

const val KEY_NODE_ID = "nodeId"
const val KEY_WIDGET_TYPE = "widgetType"
const val KEY_PATH = "path"
const val KEY_SCREEN_NAME = "screenName"
const val KEY_BOUNDS = "bounds"
const val KEY_BOUNDS_TOP = "top"
const val KEY_BOUNDS_LEFT = "left"
const val KEY_BOUNDS_BOTTOM = "bottom"
const val KEY_BOUNDS_RIGHT = "right"
const val KEY_ANCESTORS = "ancestors"
const val KEY_PAUSED = "paused"

// Element Tooltip
// Dart -> Native: render a tooltip anchored to a resolved element, e.g. when a
// hardcoded/backend campaign matches the currently active screen. Used only in the
// `nativeOverlay` tooltip render mode - see PLATFORM_VIEW_TYPE_ELEMENT_TOOLTIP for the
// alternative embedded rendering.
const val METHOD_NAME_SHOW_ELEMENT_TOOLTIP = "showElementTooltip"
const val METHOD_NAME_DISMISS_ELEMENT_TOOLTIP = "dismissElementTooltip"
const val KEY_TOOLTIP_MESSAGE = "message"

// Which native `com.moengage:tooltip` overlay to render for the resolved element - one of
// OVERLAY_TYPE_TOOLTIP / OVERLAY_TYPE_BEACON / OVERLAY_TYPE_SPOTLIGHT. Defaults to
// OVERLAY_TYPE_TOOLTIP when absent/unrecognised. See NativeTooltipBridge.
const val KEY_TOOLTIP_OVERLAY_TYPE = "overlayType"
const val OVERLAY_TYPE_TOOLTIP = "tooltip"
const val OVERLAY_TYPE_BEACON = "beacon"
const val OVERLAY_TYPE_SPOTLIGHT = "spotlight"

// View type id for the PlatformView factory used to embed the element tooltip directly in
// the Flutter widget tree (the `platformView` tooltip render mode).
const val PLATFORM_VIEW_TYPE_ELEMENT_TOOLTIP = "moengage_flutter/tooltip_view"