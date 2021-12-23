class AndroidOptionBuilder {
  Map<String, Map<String, dynamic>?> setupCalls = {};

  @deprecated
  AndroidOptionBuilder setNotificationLargeIcon(int largeIcon) {
    setupCalls['setNotificationLargeIcon'] = {'largeIcon': largeIcon};
    return this;
  }

  @deprecated
  AndroidOptionBuilder setNotificationSmallIcon(int smallIcon) {
    setupCalls['setNotificationSmallIcon'] = {'smallIcon': smallIcon};
    return this;
  }

  @deprecated
  AndroidOptionBuilder setSenderId(String senderId) {
    setupCalls['setSenderId'] = {'senderId': senderId};
    return this;
  }

  @deprecated
  AndroidOptionBuilder setNotificationColor(int color) {
    setupCalls['setNotificationColor'] = {'color': color};
    return this;
  }

  @deprecated
  AndroidOptionBuilder setNotificationTone(String tone) {
    setupCalls['setNotificationTone'] = {'tone': tone};
    return this;
  }

  @deprecated
  AndroidOptionBuilder enableMultipleNotificationInDrawer() {
    setupCalls['enableMultipleNotificationInDrawer'] = null;
    return this;
  }

  @deprecated
  AndroidOptionBuilder optOutInAppOnActivity(List<String> inAppOptOutClassNameList) {
    setupCalls['optOutInAppOnActivity'] = {'inAppOptOutClassNameList': inAppOptOutClassNameList};
    return this;
  }

  @deprecated
  AndroidOptionBuilder optOutBackStackBuilder() {
    setupCalls['optOutBackStackBuilder'] = null;
    return this;
  }

  @deprecated
  AndroidOptionBuilder optOutNavBar() {
    setupCalls['optOutNavBar'] = null;
    return this;
  }

  @deprecated
  AndroidOptionBuilder optOutTokenRegistration() {
    setupCalls['optOutTokenRegistration'] = null;
    return this;
  }

  @deprecated
  AndroidOptionBuilder enableLogsForSignedBuild() {
    setupCalls['enableLogsForSignedBuild'] = null;
    return this;
  }

  @deprecated
  AndroidOptionBuilder optOutNotificationLargeIcon() {
    setupCalls['optOutNotificationLargeIcon'] = null;
    return this;
  }

  @deprecated
  AndroidOptionBuilder enableSegmentIntegration() {
    setupCalls['enableSegmentIntegration'] = null;
    return this;
  }

  @deprecated
  AndroidOptionBuilder enablePushKitTokenRegistration() {
    setupCalls['enablePushKitTokenRegistration'] = null;
    return this;
  }

  AndroidOptionBuilder setTokenRetryInterval(int tokenRetryInterval) {
    setupCalls['setTokenRetryInterval'] = {'tokenRetryInterval': tokenRetryInterval};
    return this;
  }

  AndroidOptionBuilder enableEncryption() {
    setupCalls['enableEncryption'] = null;
    return this;
  }

  @deprecated
  AndroidOptionBuilder configureMiPush(String appId, String appKey, bool enableTokenRegistration) {
    setupCalls['configureMiPush'] = {
      'appId': appId,
      'appKey': appKey,
      'enableTokenRegistration': enableTokenRegistration,
    };
    return this;
  }

  @deprecated
  AndroidOptionBuilder enableLogs(int level) {
    setupCalls['enableLogs'] = {'level': level};
    return this;
  }

  AndroidOptionBuilder setDataCenter(DataCenter dataCenter) {
    setupCalls['setDataCenter'] = {'dataCenter': dataCenter.toString().split(".").last};
    return this;
  }

  AndroidOptionBuilder configureFcm(FcmConfig config) {
    setupCalls['configureFcm'] = {
      'isRegistrationEnabled': config.isRegistrationEnabled,
      'senderId': config.senderId,
    };

    return this;
  }

  AndroidOptionBuilder configureCards(CardConfig config) {
    setupCalls['configureCards'] = {
      'cardPlaceHolderImage': config.cardPlaceHolderImage,
      'inboxEmptyImage': config.inboxEmptyImage,
      'cardsDateFormat': config.cardsDateFormat,
      'isSwipeRefreshEnabled': config.isSwipeRefreshEnabled,
    };

    return this;
  }

  AndroidOptionBuilder configureMiPushConfig(MiPushConfig config) {
    setupCalls['configureMiPushConfig'] = {
      'appId': config.appId,
      'appKey': config.appKey,
      'isRegistrationEnabled': config.isRegistrationEnabled,
    };

    return this;
  }

  AndroidOptionBuilder configureTrackingOptOut(TrackingOptOutConfig config) {
    setupCalls['configureTrackingOptOut'] = {
      'isGaidTrackingEnabled': config.isGaidTrackingEnabled,
      'isAndroidIdTrackingEnabled': config.isAndroidIdTrackingEnabled,
      'isCarrierTrackingEnabled': config.isCarrierTrackingEnabled,
      'isDeviceAttributeTrackingEnabled': config.isDeviceAttributeTrackingEnabled,
      'optOutActivitiesClassName': config.optOutActivitiesClassName,
    };

    return this;
  }

  AndroidOptionBuilder configureRealTimeTrigger(RttConfig config) {
    setupCalls['configureRealTimeTrigger'] = {'isBackgroundSyncEnabled': config.isBackgroundSyncEnabled};

    return this;
  }

  AndroidOptionBuilder configurePushKit(PushKitConfig config) {
    setupCalls['configurePushKit'] = {'isRegistrationEnabled': config.isRegistrationEnabled};

    return this;
  }

  AndroidOptionBuilder configureNotificationMetaData(NotificationConfig config) {
    setupCalls['configureNotificationMetaData'] = {
      'smallIcon': config.smallIcon,
      'largeIcon': config.largeIcon,
      'notificationColor': config.notificationColor,
      'tone': config.tone,
      'isMultipleNotificationInDrawerEnabled': config.isMultipleNotificationInDrawerEnabled,
      'isBuildingBackStackEnabled': config.isBuildingBackStackEnabled,
      'isLargeIconDisplayEnabled': config.isLargeIconDisplayEnabled,
    };

    return this;
  }

  AndroidOptionBuilder configureInAppConfig(InAppConfig config) {
    setupCalls['configureInAppConfig'] = {
      'shouldHideStatusBar': config.shouldHideStatusBar,
      'isJavascriptEnabled': config.isJavascriptEnabled,
      'optOutActivitiesClassName': config.optOutActivitiesClassName,
      'activityNames': config.activityNames,
    };

    return this;
  }

  AndroidOptionBuilder configureLogs(LogConfig config) {
    setupCalls['configureLogs'] = {
      'level': config.level,
      'isEnabledForReleaseBuild': config.isEnabledForReleaseBuild,
    };

    return this;
  }

  AndroidOptionBuilder configureGeofence(GeofenceConfig config) {
    setupCalls['configureGeofence'] = {
      'isGeofenceEnabled': config.isGeofenceEnabled,
      'isBackgroundSyncEnabled': config.isBackgroundSyncEnabled,
    };

    return this;
  }

  AndroidOptionBuilder enablePartnerIntegration(IntegrationPartner integrationPartner) {
    setupCalls['enablePartnerIntegration'] = {'integrationPartner': integrationPartner.toString().split(".").last};

    return this;
  }
}

enum DataCenter {
  DATA_CENTER_1,
  DATA_CENTER_2,
  DATA_CENTER_3
}

class FcmConfig {
  bool isRegistrationEnabled;

  String senderId;

  FcmConfig({required this.isRegistrationEnabled, this.senderId = ''});
}

class CardConfig {
  int cardPlaceHolderImage;

  int inboxEmptyImage;

  String cardsDateFormat;

  bool isSwipeRefreshEnabled;

  CardConfig({
    this.cardPlaceHolderImage = -1,
    this.inboxEmptyImage = -1,
    this.cardsDateFormat = 'MMM dd, hh:mm a',
    this.isSwipeRefreshEnabled = true,
  });
}

class MiPushConfig {
  String appId;

  String appKey;

  bool isRegistrationEnabled;

  MiPushConfig({
    this.appId = '',
    this.appKey = '',
    this.isRegistrationEnabled = false,
  });
}

class TrackingOptOutConfig {
  bool isGaidTrackingEnabled;

  bool isAndroidIdTrackingEnabled;

  bool isCarrierTrackingEnabled;

  bool isDeviceAttributeTrackingEnabled;

  List<String>? optOutActivitiesClassName;

  TrackingOptOutConfig({
    this.isGaidTrackingEnabled = true,
    this.isAndroidIdTrackingEnabled = true,
    this.isCarrierTrackingEnabled = true,
    this.isDeviceAttributeTrackingEnabled = true,
    this.optOutActivitiesClassName,
  }) {
    if(optOutActivitiesClassName == null) optOutActivitiesClassName = List.empty(growable: true);
  }
}

class RttConfig {
  bool isBackgroundSyncEnabled;

  RttConfig({this.isBackgroundSyncEnabled = true,});
}

class PushKitConfig {
  bool isRegistrationEnabled;

  PushKitConfig({this.isRegistrationEnabled = false,});
}

class NotificationConfig{
  int smallIcon;

  int largeIcon;

  int notificationColor;

  String? tone;

  bool isMultipleNotificationInDrawerEnabled;

  bool isBuildingBackStackEnabled;

  bool isLargeIconDisplayEnabled;

  NotificationConfig({
    this.smallIcon = -1,
    this.largeIcon = -1,
    this.notificationColor = -1,
    this.tone,
    this.isMultipleNotificationInDrawerEnabled = false,
    this.isBuildingBackStackEnabled = true,
    this.isLargeIconDisplayEnabled = true,
  });
}

class InAppConfig {
  bool shouldHideStatusBar;

  bool isJavascriptEnabled;

  List<String>? optOutActivitiesClassName;

  List<String> activityNames = List.empty(growable: true);

  InAppConfig({
    this.shouldHideStatusBar = true,
    this.isJavascriptEnabled = true,
    this.optOutActivitiesClassName,
  }) {
    if(optOutActivitiesClassName == null) {
      optOutActivitiesClassName = [
        "com.moengage.pushbase.activities.PushTracker",
        "com.moengage.pushbase.activities.SnoozeTracker",
        "com.moengage.integrationverifier.internal.IntegrationVerificationActivity"
      ];
    }
  }

  void addScreenName(String activityName) {
    activityNames.add(activityName);
  }

  void addScreenNames(List<String> activityNames) {
    this.activityNames.addAll(activityNames);
  }

  List<String> getOptedOutScreenName() {
    return activityNames;
  }
}

class DataSyncConfig {
  bool isPeriodicSyncEnabled;

  int periodicSyncInterval;

  bool isBackgroundSyncEnabled;

  DataSyncConfig({
    this.isPeriodicSyncEnabled = true,
    this.periodicSyncInterval = -1,
    this.isBackgroundSyncEnabled = true,
  });
}

class LogConfig {
  int level;

  bool isEnabledForReleaseBuild;

  LogConfig({
    this.level = 3,
    this.isEnabledForReleaseBuild = false,
  });
}

class GeofenceConfig {
  bool isGeofenceEnabled;

  bool isBackgroundSyncEnabled;

  GeofenceConfig({
    this.isGeofenceEnabled = false,
    this.isBackgroundSyncEnabled = false,
  });
}

enum IntegrationPartner {
  SEGMENT
}

class LogLevel {
  static const int NO_LOG = 0;

  static const int ERROR = 1;

  static const int WARN = 2;

  static const int INFO = 3;

  static const int DEBUG = 4;

  static const int VERBOSE = 5;
}
