import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show getAccountMeta;

import 'internal/constants.dart';
import 'moengage_sample_platform_interface.dart';

/// An implementation of [MoEngageSamplePlatform] that uses method channels.
class MethodChannelMoEngageSample extends MoEngageSamplePlatform {
  /// The method channel used to interact with the native platform.
  final MethodChannel _channel = const MethodChannel(channelName);

  @override
  Future<String> greet(String appId) async {
    final Map<String, dynamic> payload = getAccountMeta(appId);
    final result =
        await _channel.invokeMethod<String>(methodNameGreet, payload);
    return result ?? '';
  }
}
