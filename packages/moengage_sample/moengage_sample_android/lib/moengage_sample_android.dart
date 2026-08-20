import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart'
    show getAccountMeta, Logger;
import 'package:moengage_sample_platform_interface/moengage_sample_platform_interface.dart';

/// The Android implementation of [MoEngageSamplePlatform].
class MoEngageSampleAndroid extends MoEngageSamplePlatform {
  final MethodChannel _channel = const MethodChannel(channelName);

  /// Registers this class as the default instance of [MoEngageSamplePlatform]
  static void registerWith() {
    Logger.v('Registering MoEngageSampleAndroid with Platform Interface');
    MoEngageSamplePlatform.instance = MoEngageSampleAndroid();
  }

  @override
  Future<String> greet(String appId) async {
    final Map<String, dynamic> payload = getAccountMeta(appId);
    final result = await _channel.invokeMethod<String>(
        methodNameGreet, json.encode(payload));
    return result ?? '';
  }
}
