import '../account_meta.dart';
import '../platforms.dart';
import 'moe_push_service.dart';

/// Firebase Installation Id Data
class FirebaseInstallationIdData {
  /// [FirebaseInstallationIdData] Constructor
  FirebaseInstallationIdData(
      {required this.accountMeta,
      required this.installationId,
      required this.platform,
      required this.pushService});

  /// Instance of [AccountMeta]
  AccountMeta accountMeta;

  /// Firebase Installation Id
  String installationId;

  /// Type of Platform [Android/IOS]
  Platforms platform;

  /// Type of Push Service
  MoEPushService pushService;

  @override
  String toString() {
    return '{\naccountMeta: $accountMeta\ninstallationId: $installationId\nplatform: ${platform.asString}\npushService: $pushService\n}';
  }
}
