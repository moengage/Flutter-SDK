enum MoEPushService { fcm, push_kit, mi_push }

extension MoEPushServiceExt on MoEPushService {

  String get asString {
    switch (this) {
      case MoEPushService.fcm:
        return _pushServiceFCM;
      case MoEPushService.push_kit:
        return _pushServicePushKit;
      case MoEPushService.mi_push:
        return _pushServiceMiPush;
    }
    return "";
  }

  static MoEPushService fromString(String pushService) {
    print("MoEPushServiceExt: fromString() :: $pushService");
    switch (pushService.toUpperCase()) {
      case _pushServiceFCM:
        return MoEPushService.fcm;
      case _pushServicePushKit:
        return MoEPushService.push_kit;
      case _pushServiceMiPush:
        return MoEPushService.mi_push;
    }
  }
}
const String _pushServiceFCM = "FCM";
const String _pushServicePushKit = "PUSH_KIT";
const String _pushServiceMiPush = "MI_PUSH";