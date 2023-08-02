import 'internal/callback/callback_cache.dart';

class CoreInstanceProvider {
  factory CoreInstanceProvider() => _instance;

  CoreInstanceProvider._internal();
  static final CoreInstanceProvider _instance =
      CoreInstanceProvider._internal();

  final Map<String, CallbackCache> _caches = <String, CallbackCache>{};

  CallbackCache getCallbackCacheForInstance(String appId) {
    CallbackCache? cache = _caches[appId];
    if (cache != null) {
      return cache;
    } else {
      CallbackCache instanceCache = CallbackCache();
      _caches[appId] = instanceCache;
      return instanceCache;
    }
  }
}
