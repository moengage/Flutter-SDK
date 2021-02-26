import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/moe_push_service.dart';

class PushToken {
  String platform;
  String token;
  MoEPushService pushService;

  PushToken(this.platform, this.token, this.pushService);

  Map<String, String> toMap() {
    return {
      keyPlatform: platform,
      keyPushToken: token,
      keyPushService: pushService.asString
    };
  }

  @override
  String toString() {
    return "{\n" +
        "platform: $platform" +
        "\n" +
        "token: $token" +
        "\n" +
        "pushService: ${pushService.asString}" +
        "\n" +
        "}";
  }
}
