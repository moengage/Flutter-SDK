import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'moengage_geofence_platform_interface.dart';

/// An implementation of [MoengageGeofencePlatform] that uses method channels.
class MethodChannelMoengageGeofence extends MoengageGeofencePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('moengage_geofence');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
