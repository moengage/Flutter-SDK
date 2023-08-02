import '../model/permission_type.dart';
import '../model/platforms.dart';

class PermissionResultData {
  PermissionResultData(this.platform, this.isGranted, this.type);
  Platforms platform;
  bool isGranted;
  PermissionType type;

  @override
  String toString() {
    return '{\nplatform: $platform,\nisGranted: $isGranted,\ntype: $type\n}';
  }
}
