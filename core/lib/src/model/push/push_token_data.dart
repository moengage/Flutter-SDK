import '../platforms.dart';
import 'moe_push_service.dart';

class PushTokenData {
  Platforms platform;
  String token;
  MoEPushService pushService;

  PushTokenData(this.platform, this.token, this.pushService);

  @override
  String toString() {
    return "{\n" +
        "platform: $platform" +
        "\n" +
        "token: $token" +
        "\n" +
        "pushService: $pushService" +
        "\n" +
        "}";
  }
}
