
import 'callback_cache.dart';

class CardsInstanceProvider {
  static final CardsInstanceProvider _instance = CardsInstanceProvider._internal();

  final Map<String, CallbackCache> _caches = <String, CallbackCache>{};

  CardsInstanceProvider._internal();

  factory CardsInstanceProvider() => _instance;

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
