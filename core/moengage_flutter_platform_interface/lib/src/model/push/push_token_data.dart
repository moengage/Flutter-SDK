import '../platforms.dart';
import 'moe_push_service.dart';

class PushTokenData {
  PushTokenData(this.platform, this.token, this.pushService);
  Platforms platform;
  String token;
  MoEPushService pushService;

  @override
  String toString() {
    return '{\nplatform: $platform\ntoken: $token\npushService: $pushService\n}';
  }
}
