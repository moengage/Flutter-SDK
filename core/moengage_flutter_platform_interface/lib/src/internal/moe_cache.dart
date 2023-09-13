import 'callback/callbacks.dart';

/// Core Cache
class Cache {
  /// Factory Constructor
  factory Cache() => _instance;

  Cache._internal();

  static final Cache _instance = Cache._internal();

  /// Push Token Result Callback
  PushTokenCallbackHandler? pushTokenCallbackHandler;

  /// Permission Result Callback
  PermissionResultCallbackHandler? permissionResultCallbackHandler;
}
