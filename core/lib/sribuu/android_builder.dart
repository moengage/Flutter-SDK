class AndroidBuilder {
  Map<String, Map<String, dynamic>?> methodCalls = {};

  @deprecated
  AndroidBuilder setNotificationLargeIcon(int largeIcon) {
    methodCalls['setNotificationLargeIcon'] = {'largeIcon': largeIcon};
    return this;
  }

  @deprecated
  AndroidBuilder setNotificationSmallIcon(int smallIcon) {
    methodCalls['setNotificationSmallIcon'] = {'smallIcon': smallIcon};
    return this;
  }

  @deprecated
  AndroidBuilder setSenderId(String senderId) {
    methodCalls['setSenderId'] = {'senderId': senderId};
    return this;
  }

  @deprecated
  AndroidBuilder setNotificationColor(int color) {
    methodCalls['setNotificationColor'] = {'color': color};
    return this;
  }

  @deprecated
  AndroidBuilder setNotificationTone(String tone) {
    methodCalls['setNotificationTone'] = {'tone': tone};
    return this;
  }

  @deprecated
  AndroidBuilder enableMultipleNotificationInDrawer() {
    methodCalls['enableMultipleNotificationInDrawer'] = null;
    return this;
  }

  @deprecated
  AndroidBuilder optOutInAppOnActivity(List<String> inAppOptOutClassNameList) {
    methodCalls['optOutInAppOnActivity'] = {'inAppOptOutClassNameList': inAppOptOutClassNameList};
    return this;
  }

  @deprecated
  AndroidBuilder optOutBackStackBuilder() {
    methodCalls['optOutBackStackBuilder'] = null;
    return this;
  }

  @deprecated
  AndroidBuilder optOutNavBar() {
    methodCalls['optOutNavBar'] = null;
    return this;
  }

  @deprecated
  AndroidBuilder optOutTokenRegistration() {
    methodCalls['optOutTokenRegistration'] = null;
    return this;
  }

  @deprecated
  AndroidBuilder enableLogsForSignedBuild() {
    methodCalls['enableLogsForSignedBuild'] = null;
    return this;
  }

  @deprecated
  AndroidBuilder optOutNotificationLargeIcon() {
    methodCalls['optOutNotificationLargeIcon'] = null;
    return this;
  }

  @deprecated
  AndroidBuilder enableSegmentIntegration() {
    methodCalls['enableSegmentIntegration'] = null;
    return this;
  }

  @deprecated
  AndroidBuilder enablePushKitTokenRegistration() {
    methodCalls['enablePushKitTokenRegistration'] = null;
    return this;
  }

  AndroidBuilder setTokenRetryInterval(int tokenRetryInterval) {
    methodCalls['setTokenRetryInterval'] = {'tokenRetryInterval': tokenRetryInterval};
    return this;
  }

  AndroidBuilder enableEncryption() {
    methodCalls['enableEncryption'] = null;
    return this;
  }

  @deprecated
  AndroidBuilder configureMiPush(String appId, String appKey, bool enableTokenRegistration) {
    methodCalls['configureMiPush'] = {
      'appId': appId,
      'appKey': appKey,
      'enableTokenRegistration': enableTokenRegistration,
    };
    return this;
  }

  @deprecated
  AndroidBuilder enableLogs(int level) {
    methodCalls['enableLogs'] = {'level': level};
    return this;
  }

  AndroidBuilder setDataCenter(DataCenter dataCenter) {
    methodCalls['setDataCenter'] = {'dataCenter': dataCenter.toString()};
    return this;
  }

  AndroidBuilder configureFcm(FcmConfig config) {
    methodCalls['configureFcm'] = {
      'isRegistrationEnabled': config.isRegistrationEnabled,
      'senderId': config.senderId,
    };

    return this;
  }

  AndroidBuilder configureCards(CardConfig config) {
    methodCalls['configureCards'] = {
      'cardPlaceHolderImage': config.cardPlaceHolderImage,
      'inboxEmptyImage': config.inboxEmptyImage,
      'cardsDateFormat': config.cardsDateFormat,
      'isSwipeRefreshEnabled': config.isSwipeRefreshEnabled,
    };

    return this;
  }

  AndroidBuilder configureMiPushConfig(MiPushConfig config) {
    methodCalls['configureMiPush'] = {
      'appId': config.appId,
      'appKey': config.appKey,
      'isRegistrationEnabled': config.isRegistrationEnabled,
    };

    return this;
  }

  AndroidBuilder configureTrackingOptOut(TrackingOptOutConfig config) {
    methodCalls['configureTrackingOptOut'] = {
      'isGaidTrackingEnabled': config.isGaidTrackingEnabled,
      'isAndroidIdTrackingEnabled': config.isAndroidIdTrackingEnabled,
      'isCarrierTrackingEnabled': config.isCarrierTrackingEnabled,
      'isDeviceAttributeTrackingEnabled': config.isDeviceAttributeTrackingEnabled,
      'optOutActivitiesClassName': config.optOutActivitiesClassName,
    };

    return this;
  }

  AndroidBuilder configureRealTimeTrigger(RttConfig config) {
    methodCalls['configureRealTimeTrigger'] = {'isBackgroundSyncEnabled': config.isBackgroundSyncEnabled};

    return this;
  }

  AndroidBuilder configurePushKit(PushKitConfig config) {
    methodCalls['configurePushKit'] = {'isRegistrationEnabled': config.isRegistrationEnabled};

    return this;
  }

  AndroidBuilder configureNotificationMetaData(NotificationConfig config) {
    methodCalls['configureNotificationMetaData'] = {
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

  AndroidBuilder configureInAppconfig(InAppConfig config) {
    methodCalls['configureInAppconfig'] = {
      'shouldHideStatusBar': config.shouldHideStatusBar,
      'isJavascriptEnabled': config.isJavascriptEnabled,
      'optOutActivitiesClassName': config.optOutActivitiesClassName,
      'activityNames': config.activityNames,
    };

    return this;
  }

  AndroidBuilder configureLogs(LogConfig config) {
    methodCalls['configureLogs'] = {
      'level': config.level,
      'isEnabledForReleaseBuild': config.isEnabledForReleaseBuild,
    };

    return this;
  }

  AndroidBuilder configureGeofence(GeofenceConfig config) {
    methodCalls['configureGeofence'] = {
      'isGeofenceEnabled': config.isGeofenceEnabled,
      'isBackgroundSyncEnabled': config.isBackgroundSyncEnabled,
    };

    return this;
  }

  AndroidBuilder enablePartnerIntegration(IntegrationPartner integrationPartner) {
    methodCalls['enablePartnerIntegration'] = {'integrationPartner': integrationPartner.toString()};

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
