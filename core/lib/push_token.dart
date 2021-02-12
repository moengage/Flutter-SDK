import 'package:moengage_flutter/constants.dart';

class PushToken {
  String platform;
  String token;
  String pushService;

  PushToken(this.platform, this.token, this.pushService);

  Map<String, String> toMap() {
    return {
      keyPlatform: platform,
      keyPushToken: token,
      keyPushService: pushService
    };
  }

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