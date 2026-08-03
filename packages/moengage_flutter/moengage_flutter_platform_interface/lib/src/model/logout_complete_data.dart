import 'account_meta.dart';
import 'platforms.dart';

/// Logout Complete Data
class LogoutCompleteData {
  /// [LogoutCompleteData] Constructor
  LogoutCompleteData({required this.platform, required this.accountMeta});

  /// Type of Platform [Android/IOS]
  Platforms platform;

  /// Instance of [AccountMeta]
  AccountMeta accountMeta;

  @override
  String toString() {
    return '{\nplatform: ${platform.asString}\naccountMeta: $accountMeta\n}';
  }
}
