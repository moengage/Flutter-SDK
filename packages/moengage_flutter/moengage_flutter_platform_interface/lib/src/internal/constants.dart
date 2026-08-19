// ignore_for_file: public_member_api_docs
// Plugin Channel
const String TAG = 'Core_';

// Plugin Channel
const String channelName = 'com.moengage/core';

// Method Names
const String methodInitialise = 'initialise';
const String methodSetAppStatus = 'setAppStatus';
const String methodTrackEvent = 'trackEvent';
const String methodSetUserAttribute = 'setUserAttribute';
const String methodSetAlias = 'setAlias';
const String methodiOSRegisterPush = 'registerForPush';
const String methodPushToken = 'pushToken';
const String methodPushPayLoad = 'pushPayload';
const String methodShowInApp = 'showInApp';
const String methodSelfHandledInApp = 'selfHandledInApp';
const String methodSelfHandledCallback = 'selfHandledCallback';
const String methodSetAppContext = 'setAppContext';
const String methodResetAppContext = 'resetCurrentContext';
const String methodOptOutTracking = 'optOutTracking';
const String methodLogout = 'logout';
const String methodUpdateSdkState = 'updateSdkState';
const String methodOnOrientationChanged = 'onOrientationChanged';
const String methodDeviceIdentifierTracking = 'deviceIdentifierTracking';
const String methodUpdateDeviceIdentifierTrackingStatus =
    'updateDeviceIdentifierTrackingStatus';
const String methodSetupNotificationChannelAndroid =
    'setupNotificationChannels';
const String methodNavigateToSettingsAndroid = 'navigateToSettings';
const String methodRequestPushPermissionAndroid = 'requestPushPermission';
const String methodUpdatePushPermissionRequestCount =
    'updatePushPermissionRequestCount';
const String methodPermissionResponse = 'permissionResponse';
const String methodiOSRegisterProvisionalPush = 'registerForProvisionalPush';

// Callback Names
const String callbackOnPushClick = 'onPushClick';
const String callbackOnInAppShown = 'onInAppShown';
const String callbackOnInAppClicked = 'onInAppClick';
const String callbackOnInAppDismissed = 'onInAppDismiss';
const String callbackOnInAppCustomAction = 'onInAppCustomAction';
const String callbackOnInAppSelfHandled = 'onInAppSelfHandle';
const String callbackPushTokenGenerated = 'onPushTokenGenerated';
const String callbackPermissionResult = 'onPermissionResult';
const String callbackOnLogoutComplete = 'onLogoutComplete';

// Gender Value Constants
const String genderMale = 'male';
const String genderFemale = 'female';
const String genderOther = 'other';

// AppStatus Value Constants
const String appStatusInstall = 'INSTALL';
const String appStatusUpdate = 'UPDATE';

// Default User Attribute Names
const String userAttrNameUniqueId = 'USER_ATTRIBUTE_UNIQUE_ID';
const String userAttrNameUserName = 'USER_ATTRIBUTE_USER_NAME';
const String userAttrNameFirstName = 'USER_ATTRIBUTE_USER_FIRST_NAME';
const String userAttrNameLastName = 'USER_ATTRIBUTE_USER_LAST_NAME';
const String userAttrNameEmailId = 'USER_ATTRIBUTE_USER_EMAIL';
const String userAttrNamePhoneNum = 'USER_ATTRIBUTE_USER_MOBILE';
const String userAttrNameGender = 'USER_ATTRIBUTE_USER_GENDER';
const String userAttrNameBirtdate = 'USER_ATTRIBUTE_USER_BDAY';
const String userAttrNameLocation = 'USER_ATTRIBUTE_USER_LOCATION';

// Keys Constants
const String keyEventName = 'eventName';
const String keyEventAttributes = 'eventAttributes';
const String keyAttributeValue = 'attributeValue';
const String keyAttributeName = 'attributeName';
const String keyAttrLatitudeName = 'latitude';
const String keyAttrLongitudeName = 'longitude';
const String keyPushToken = 'token';
const String keyPushPayload = 'pushPayload';
const String keyService = 'service';
const String keyAttributeType = 'type';
const String keyAlias = 'alias';
const String keyLocationAttribute = 'locationAttribute';
const String keyState = 'state';
const String keyAppStatus = 'appStatus';
const String keyContexts = 'contexts';
const String keyPushService = 'pushService';

const String keyPayload = 'payload';
const String keyKvPair = 'kvPair';

//InApp Campaign Constants
const String keyPlatform = 'platform';
const String keyCampaignId = 'campaignId';
const String keyCampaignName = 'campaignName';
const String keyNavigation = 'navigation';
const String keySelfHandled = 'selfHandled';
const String keyCustomAction = 'customAction';
const String keyCampaignContext = 'campaignContext';
const String keyFormattedCampaignId = 'cid';
const String keyActionType = 'actionType';
const String keyType = 'type';

// Navigation action Constants
const String keyNavigationType = 'navigationType';
const String keyValue = 'value';

// SelHandled InApp Constants
const String keyDismissInterval = 'dismissInterval';

//PushPayload Constants
const String keyIsDefaultAction = 'isDefaultAction';
const String keyClickedAction = 'clickedAction';

// User Attribute Type value Constants
const String userAttrTypeGeneral = 'general';
const String userAttrTypeTimestamp = 'timestamp';
const String userAttrTypeLocation = 'location';

// GDPR Opt-Outs Constants
const String gdprOptOutTypeData = 'data';

// SelfHandled Callback Action Types
const String selfHandledActionShown = 'impression';
const String selfHandledActionClick = 'click';
const String selfHandledActionDismissed = 'dismissed';

// SDK Status update
const String keyIsSdkEnabled = 'isSdkEnabled';

const String keyAppId = 'appId';
const String keyAccountMeta = 'accountMeta';
const String keyData = 'data';
const String keyInitConfig = 'initConfig';
const String keyPushConfig = 'pushConfig';
const String keyAnalyticsConfig = 'analyticsConfig';

const String keyAndroidId = 'isAndroidIdTrackingEnabled';
const String keyAdId = 'isAdIdTrackingEnabled';
const String keyDeviceId = 'isDeviceIdTrackingEnabled';

// permission
const String keyIsPermissionGranted = 'isGranted';
const String keyPermissionType = 'type';

const String keyUpdatePushPermissionCount = 'pushOptinInAttemptCount';

//Push Config Keys

/// Key for Registering for sdk to send only callback on Push Click on App Foreground.
/// MoEngage SDK will not handle the redirection in this case
const String keyShouldDeliverCallbackOnForegroundClick =
    'shouldDeliverCallbackOnForegroundClick';

// Analytics Config Keys

/// Key for whether to track boolean user-attributes as 0/1 in iOS.
const String keyShouldTrackUserAttributeBooleanAsNumber =
    'shouldTrackUserAttributeBooleanAsNumber';

/// Key for Self handled push redirection. If self handled push direction is true,
/// Client is responsible for push redirection on Push Click
const String keySelfHandledPushRedirection = 'selfHandledPushRedirection';

/// User Deletion
const String methodNameDeleteUser = 'deleteUser';
const String keyUserDeletionStatus = 'isUserDeletionSuccess';

/// Non Intrusive Nudges
const String methodNameShowNudge = 'showNudge';
const String keyNudgePosition = 'position';

/// SelfHandled InApp
const String methodSelfHandledInApps = 'selfHandledInApps';
const String keyDisplayRules = 'displayRules';
const String keyScreenName = 'screenName';
const String keyCampaigns = 'campaigns';
const String keyScreenNames = 'screenNames';

/// Identify User
const String keyUserIdentity = 'identity';
const String keyUniqueUserIdentity = 'uid';
const String methodIdentifyUser = 'identifyUser';
const String methodGetUserIdentities = 'getUserIdentities';

const String keyAccessibilityText = 'text';
const String keyAccessibilityHint = 'hint';
const String keyAccessibility = 'accessibility';

/// Design Mode Element Picker.
/// Dart -> Native: notify lifecycle state / report a marketer-confirmed element selection.
const String methodActivateDesignMode = 'activateDesignMode';
const String methodDeactivateDesignMode = 'deactivateDesignMode';
const String methodDesignModeElementSelected = 'designModeElementSelected';

/// Native -> Dart: ask the Flutter layer to start/stop the element picker overlay
/// (e.g. triggered from a native debug menu).
const String callbackActivateDesignMode = 'onActivateDesignMode';
const String callbackDeactivateDesignMode = 'onDeactivateDesignMode';

const String keyNodeId = 'nodeId';
const String keyWidgetType = 'widgetType';
const String keyPath = 'path';
const String keyBounds = 'bounds';
const String keyBoundsTop = 'top';
const String keyBoundsLeft = 'left';
const String keyBoundsBottom = 'bottom';
const String keyBoundsRight = 'right';
const String keyAncestors = 'ancestors';
const String keyPaused = 'paused';

/// Element Tooltip.
/// Dart -> Native: ask native to render a tooltip anchored to a resolved
/// element, e.g. when a hardcoded/backend campaign matches the active screen.
/// Used only in the `nativeOverlay` tooltip render mode - see
/// [platformViewTypeElementTooltip] for the alternative embedded rendering.
const String methodShowElementTooltip = 'showElementTooltip';
const String methodDismissElementTooltip = 'dismissElementTooltip';
const String keyTooltipMessage = 'message';

/// Dart -> Native: re-report the anchor element's bounds for a tooltip that is
/// already showing, so it follows the element as it scrolls. Carries
/// [keyBounds] and the [keyNodeId] identifying which tooltip to move.
///
/// Needed because native cannot track a Flutter widget by itself: its own
/// scroll-follow watches a live `UIView`/`View`, and a Flutter widget has
/// neither - only Dart knows the element moved.
const String methodUpdateElementTooltipAnchor = 'updateElementTooltipAnchor';

/// Coach marks.
/// Dart -> Native: highlight every element in [keyCoachMarkSteps] on one dimmed
/// overlay. Takes a list rather than a single anchor because a coach mark is a
/// multi-target walkthrough; each step carries its own [keyBounds] and copy.
const String methodShowElementCoachMarks = 'showElementCoachMarks';
const String methodDismissElementCoachMarks = 'dismissElementCoachMarks';

/// List of `MoECoachMarkStep.toMap()` entries in a
/// [methodShowElementCoachMarks] payload.
const String keyCoachMarkSteps = 'steps';

/// Copy shown beside one highlighted element.
const String keyCoachMarkText = 'text';

/// Corner radius of the hole punched around a coach mark target, in logical
/// pixels. Should match the widget's real radius - the cutout reveals the actual
/// widget, not a copy of it.
const String keyCoachMarkCutoutCornerRadius = 'cutoutCornerRadius';

/// Padding added around a coach mark target before punching its hole, in logical
/// pixels. `0` keeps the hole flush with the element.
const String keyCoachMarkCutoutPadding = 'cutoutPadding';

/// Which native `com.moengage:tooltip` overlay to render - one of
/// [overlayTypeTooltip] / [overlayTypeBeacon] / [overlayTypeSpotlight].
/// Sent alongside [methodShowElementTooltip]; defaults to [overlayTypeTooltip]
/// on the native side when absent.
const String keyTooltipOverlayType = 'overlayType';
const String overlayTypeTooltip = 'tooltip';
const String overlayTypeBeacon = 'beacon';
const String overlayTypeSpotlight = 'spotlight';

/// View type id for the native `PlatformView` factory registered by the
/// Android plugin, used to embed the element tooltip directly in the
/// Flutter widget tree as an alternative to [methodShowElementTooltip].
const String platformViewTypeElementTooltip = 'moengage_flutter/tooltip_view';
