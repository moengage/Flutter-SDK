import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/model/push/moe_push_service.dart';

class PushToken {
  String token;
  MoEPushService pushService;

  PushToken(this.token, this.pushService);

  Map<String, String> toMap() {
    return {
      keyPushToken: token,
      keyPushService: pushService.asString
    };
  }

  @override
  String toString() {
    return "{\n" +
        "token: $token" +
        "\n" +
        "pushService: ${pushService.asString}" +
        "\n" +
        "}";
  }
}
