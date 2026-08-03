import 'package:flutter/services.dart';
import '../../moengage_<featureName>_platform_interface.dart';
import '<featureName>_instance_provider.dart';

// Only generate this file if event listener caching is needed.
/// Common implementation of <featureNameCamel> Platform Interface
abstract class MoEngage<featureNameCamel>Platform extends MoEngage<featureNameCamel>PlatformInterface {
  /// <featureNameCamel> Method Channel
  MethodChannel methodChannel = const MethodChannel(<featureName>MethodChannel);

  // One override per event listener setter — caches listener per appId:
  @override
  void setSyncCompleteListener(<featureNameCamel>SyncListener listener, String appId) {
    <featureNameCamel>InstanceProvider()
        .getCallbackCacheForInstance(appId)
        .syncListener = listener;
  }

  // Add one override per additional event type listener if needed
}
