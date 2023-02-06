import 'custom_type.dart';

class Cache {
  static late Cache _instance = Cache._internal();

  Cache._internal() {}

  factory Cache() => _instance;

  PushTokenCallbackHandler? pushTokenCallbackHandler;
  PermissionResultCallbackHandler? permissionResultCallbackHandler;
}
