// ignore_for_file: public_member_api_docs
import 'callback_cache.dart';

// Only generate this file if event listener caching is needed.
class <featureNameCamel>InstanceProvider {
  factory <featureNameCamel>InstanceProvider() => _instance;
  <featureNameCamel>InstanceProvider._internal();
  static final <featureNameCamel>InstanceProvider _instance =
      <featureNameCamel>InstanceProvider._internal();

  final Map<String, CallbackCache> _caches = <String, CallbackCache>{};

  CallbackCache getCallbackCacheForInstance(String appId) {
    final CallbackCache? cache = _caches[appId];
    if (cache != null) return cache;
    final CallbackCache instanceCache = CallbackCache();
    _caches[appId] = instanceCache;
    return instanceCache;
  }
}
