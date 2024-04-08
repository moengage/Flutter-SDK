import '../model/permission_type.dart';
import 'platforms.dart';

/// Permission Result Data
class PermissionResultData {
  /// [PermissionResultData] Constructor
  PermissionResultData(this.platform, this.isGranted, this.type);

  /// Type of Platform [Android/IOS]
  Platforms platform;

  /// Permission Granted Status
  bool isGranted;

  /// Permission Type
  PermissionType type;

  @override
  String toString() {
    return '{\nplatform: $platform,\nisGranted: $isGranted,\ntype: $type\n}';
  }
}
