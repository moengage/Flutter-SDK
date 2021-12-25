import 'package:moengage_flutter/sribuu/datacenter.dart';

class IosOptionBuilder {
  Map<String, Map<String, dynamic>?> setupCalls = {};

  // PROGRESS
  IosOptionBuilder setDataCenter(DataCenter dataCenter) {
    setupCalls['setDataCenter'] = {'dataCenter': dataCenter.toString().split(".").last};

    return this;
  }

  IosOptionBuilder setAppGroupId(String appGroupId) {
    setupCalls['setAppGroupId'] = {'appGroupId': appGroupId};

    return this;
  }

  IosOptionBuilder setAnalyticsDisablePeriodicFlush(bool analyticsDisablePeriodicFlush) {
    setupCalls['setAnalyticsDisablePeriodicFlush'] = {'analyticsDisablePeriodicFlush': analyticsDisablePeriodicFlush};

    return this;
  }

  IosOptionBuilder setAnalyticsPeriodicFlushDuration(int analyticsPeriodicFlushDuration) {
    setupCalls['setAnalyticsPeriodicFlushDuration'] = {'analyticsPeriodicFlushDuration': analyticsPeriodicFlushDuration};

    return this;
  }

  IosOptionBuilder setEncryptNetworkRequests(bool encryptNetworkRequests) {
    setupCalls['setEncryptNetworkRequests'] = {'encryptNetworkRequests': encryptNetworkRequests};

    return this;
  }

  IosOptionBuilder setOptOutDataTracking(bool optOutDataTracking) {
    setupCalls['setOptOutDataTracking'] = {'optOutDataTracking': optOutDataTracking};

    return this;
  }

  IosOptionBuilder setOptOutPushNotification(bool optOutPushNotification) {
    setupCalls['setOptOutPushNotification'] = {'optOutPushNotification': optOutPushNotification};

    return this;
  }

  IosOptionBuilder setOptOutInAppCampaign(bool optOutInAppCampaign) {
    setupCalls['setOptOutInAppCampaign'] = {'optOutInAppCampaign': optOutInAppCampaign};

    return this;
  }

  IosOptionBuilder setOptOutIDFATracking(bool optOutIDFATracking) {
    setupCalls['setOptOutIDFATracking'] = {'optOutIDFATracking': optOutIDFATracking};

    return this;
  }

  IosOptionBuilder setOptOutIDFVTracking(bool optOutIDFVTracking) {
    setupCalls['setOptOutIDFVTracking'] = {'optOutIDFVTracking': optOutIDFVTracking};

    return this;
  }
}
