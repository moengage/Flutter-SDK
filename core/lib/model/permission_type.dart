enum PermissionType { PUSH }

extension PermissionTypeExtension on PermissionType {

  static PermissionType fromString(String permissionType) {
    switch (permissionType) {
      case _permissionTypePush:
        return PermissionType.PUSH;
      default:
        throw Exception(
            "PermissionType.fromString() $permissionType not a valid platform type.");
    }
  }

  String get asString {
    switch (this) {
      case PermissionType.PUSH:
        return _permissionTypePush;
    }
  }

}

const String _permissionTypePush = "push";