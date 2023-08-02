import '../src/internal/callback/callbacks.dart';

class Cache {
  factory Cache() => _instance;

  Cache._internal();
  static final Cache _instance = Cache._internal();

  PushTokenCallbackHandler? pushTokenCallbackHandler;
  PermissionResultCallbackHandler? permissionResultCallbackHandler;
}
