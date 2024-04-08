import '../../internal/constants.dart';
import '../../internal/logger.dart';

/// Type of Push Notification Services
enum MoEPushService {
  /// Apple Push Notification Service
  apns,

  /// Firebase Cloud Messaging
  fcm,

  /// Huawei Push Kit
  push_kit
}

String _tag = '${TAG}MoEPushService';

/// For Converting [MoEPushService] Enum to String
extension MoEPushServiceExtention on MoEPushService {
  /// Convert [MoEPushService] to [String]
  String get asString {
    switch (this) {
      case MoEPushService.apns:
        return _pushServiceAPNS;
      case MoEPushService.fcm:
        return _pushServiceFCM;
      case MoEPushService.push_kit:
        return _pushServicePushKit;
    }
  }

  /// [MoEPushService] From string
  static MoEPushService fromString(String pushService) {
    Logger.v('$_tag fromString() : pushService: $pushService');
    switch (pushService.toUpperCase()) {
      case _pushServiceAPNS:
        return MoEPushService.apns;
      case _pushServiceFCM:
        return MoEPushService.fcm;
      case _pushServicePushKit:
        return MoEPushService.push_kit;
      default:
        throw Exception(
            'error: MoEPushService.fromString() : $pushService is not a valid pushService type.');
    }
  }
}

const String _pushServiceAPNS = 'APNS';
const String _pushServiceFCM = 'FCM';
const String _pushServicePushKit = 'PUSH_KIT';
