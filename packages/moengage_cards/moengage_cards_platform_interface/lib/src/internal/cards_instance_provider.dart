// ignore_for_file: public_member_api_docs
import 'callback_cache.dart';

class CardsInstanceProvider {
  factory CardsInstanceProvider() => _instance;
  CardsInstanceProvider._internal();
  static final CardsInstanceProvider _instance =
      CardsInstanceProvider._internal();

  final Map<String, CallbackCache> _caches = <String, CallbackCache>{};

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
