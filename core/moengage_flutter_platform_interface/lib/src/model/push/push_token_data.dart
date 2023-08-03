import '../platforms.dart';
import 'moe_push_service.dart';

/// Push Token Data
class PushTokenData {
  /// Push Token Related Data
  PushTokenData(this.platform, this.token, this.pushService);

  /// Type of Platform [Android/IOS]
  Platforms platform;

  /// Push Token
  String token;

  /// Type of Push Service
  MoEPushService pushService;

  @override
  String toString() {
    return '{\nplatform: $platform\ntoken: $token\npushService: $pushService\n}';
  }
}
