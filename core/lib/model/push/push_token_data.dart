import 'package:moengage_flutter/model/platforms.dart';
import 'package:moengage_flutter/model/push/push_token.dart';

class PushTokenData {
  Platforms platform;
  PushToken token;

  PushTokenData(this.platform, this.token);
}
