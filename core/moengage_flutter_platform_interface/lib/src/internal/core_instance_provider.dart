import 'callback/callback_cache.dart';

/// Instance Specific Cache for Callbacks
class CoreInstanceProvider {
  /// [CoreInstanceProvider] Constructor
  factory CoreInstanceProvider() => _instance;

  CoreInstanceProvider._internal();
  static final CoreInstanceProvider _instance =
      CoreInstanceProvider._internal();

  final Map<String, CallbackCache> _caches = <String, CallbackCache>{};

  /// Get [CallbackCache] instance For provided MoEngage App Id
  CallbackCache getCallbackCacheForInstance(String appId) {
    final CallbackCache? cache = _caches[appId];
    if (cache != null) {
      return cache;
    } else {
      final CallbackCache instanceCache = CallbackCache();
      _caches[appId] = instanceCache;
      return instanceCache;
    }
  }
}
