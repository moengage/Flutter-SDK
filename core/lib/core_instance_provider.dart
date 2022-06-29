import 'package:moengage_flutter/callback_cache.dart';

class CoreInstanceProvider {

  static CoreInstanceProvider _instance = CoreInstanceProvider._internal();

  Map<String, CallbackCache> _caches = Map<String, CallbackCache>();

  CoreInstanceProvider._internal();

  factory CoreInstanceProvider() => _instance;

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