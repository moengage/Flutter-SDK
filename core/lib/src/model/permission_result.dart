import 'permission_type.dart';
import 'platforms.dart';

class PermissionResultData {
  Platforms platform;
  bool isGranted;
  PermissionType type;

  PermissionResultData(this.platform, this.isGranted, this.type);

  @override
  String toString() {
    return "{\n" +
        "platform: $platform," +
        "\n" +
        "isGranted: $isGranted," +
        "\n" +
        "type: $type" +
        "\n" +
        "}";
  }
}
