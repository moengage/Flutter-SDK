/// Permission Type
enum PermissionType {
  /// Push Permission Type
  PUSH
}

/// Permission Type Extension
extension PermissionTypeExtension on PermissionType {
  /// [PermissionType] From String
  static PermissionType fromString(String permissionType) {
    switch (permissionType) {
      case _permissionTypePush:
        return PermissionType.PUSH;
      default:
        throw Exception(
            'PermissionType.fromString() $permissionType not a valid platform type.');
    }
  }

  /// Convert [PermissionType] to String
  String get asString {
    switch (this) {
      case PermissionType.PUSH:
        return _permissionTypePush;
    }
  }
}

const String _permissionTypePush = 'push';
