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
