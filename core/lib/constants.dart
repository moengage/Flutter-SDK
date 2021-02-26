// Plugin Channel
const String channelName = "com.moengage/core";

// Method Names
const String methodInitialise = "initialise";
const String methodSetAppStatus = "setAppStatus";
const String methodTrackEvent = "trackEvent";
const String methodSetUserAttribute = "setUserAttribute";
const String methodSetAlias = "setAlias";
const String methodiOSRegisterPush = "registerForPush";
const String methodiOSStartGeofence = "startGeofenceMonitoring";
const String methodPushToken = "pushToken";
const String methodPushPayLoad = "pushPayload";
const String methodShowInApp = "showInApp";
const String methodSelfHandledInApp = "selfHandledInApp";
const String methodSelfHandledCallback = "selfHandledCallback";
const String methodSetAppContext = "setAppContext";
const String methodResetAppContext = "resetCurrentContext";
const String methodOptOutTracking = "optOutTracking";
const String methodEnableSDKLogs = "enableSDKLogs";
const String methodLogout = "logout";
const String methodUpdateSdkState = "updateSdkState";

// Callback Names
const String callbackOnPushClick = "onPushClick";
const String callbackOnInAppShown = "onInAppShown";
const String callbackOnInAppClicked = "onInAppClick";
const String callbackOnInAppDismissed = "onInAppDismiss";
const String callbackOnInAppCustomAction = "onInAppCustomAction";
const String callbackOnInAppSelfHandled = "onInAppSelfHandle";
const String callbackPushTokenGenerated = "onPushTokenGenerated";

// Gender Value Constants
const String genderMale = "male";
const String genderFemale = "female";
const String genderOther = "other";

// AppStatus Value Constants
const String appStatusInstall = "INSTALL";
const String appStatusUpdate = "UPDATE";

// Default User Attribute Names
const String userAttrNameUniqueId = "USER_ATTRIBUTE_UNIQUE_ID";
const String userAttrNameUserName = "USER_ATTRIBUTE_USER_NAME";
const String userAttrNameFirstName = "USER_ATTRIBUTE_USER_FIRST_NAME";
const String userAttrNameLastName = "USER_ATTRIBUTE_USER_LAST_NAME";
const String userAttrNameEmailId = "USER_ATTRIBUTE_USER_EMAIL";
const String userAttrNamePhoneNum = "USER_ATTRIBUTE_USER_MOBILE";
const String userAttrNameGender = "USER_ATTRIBUTE_USER_GENDER";
const String userAttrNameBirtdate = "USER_ATTRIBUTE_USER_BDAY";
const String userAttrNameLocation = "USER_ATTRIBUTE_USER_LOCATION";

// Keys Constants
const String keyEventName = "eventName";
const String keyEventAttributes = "eventAttributes";
const String keyAttributeValue = "attributeValue";
const String keyAttributeName = "attributeName";
const String keyAttrLatitudeName = "latitude";
const String keyAttrLongitudeName = "longitude";
const String keyPushToken = "token";
const String keyPushPayload = "pushPayload";
const String keyService = "service";
const String keyAttributeType = "type";
const String keyAlias = "alias";
const String keyLocationAttribute = "locationAttribute";
const String keyState = "state";
const String keyAppStatus = "appStatus";
const String keyContexts = "contexts";
const String keyPushService = "pushService";

const String keyPayload = "payload";
const String keyKvPair = "kvPair";

//InApp Campaign Constants
const String keyPlatform = "platform";
const String keyCampaignId = "campaignId";
const String keyCampaignName = "campaignName";
const String keyNavigation = "navigation";
const String keySelfHandled = "selfHandled";
const String keyCustomAction = "customAction";

// Navigation action Constants
const String keyNavigationType = "navigationType";
const String keyValue = "value";

// SelHandled InApp Constants
const String keyDismissInterval = "dismissInterval";
const String keyIsCancellable = "isCancellable";

//PushPayload Constants
const String keyIsDefaultAction = "isDefaultAction";
const String keyClickedAction = "clickedAction";

// User Attribute Type value Constants
const String userAttrTypeGeneral = "general";
const String userAttrTypeTimestamp = "timestamp";
const String userAttrTypeLocation = "location";

// GDPR Opt-Outs Constants
const String gdprOptOutTypeData = "data";
const String gdprOptOutTypePush = "push";
const String gdprOptOutTypeInApp = "inapp";

// SelfHandled Callback Action Types
const String selfHandledActionShown = "impression";
const String selfHandledActionPrimaryClicked = "primary_clicked";
const String selfHandledActionClick = "click";
const String selfHandledActionDismissed = "dismissed";

// SDK Status update
const String keyIsSdkEnabled = "isSdkEnabled";
