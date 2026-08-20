import 'dart:core';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart'
    show getAccountMeta, Logger;
import 'package:moengage_sample_platform_interface/moengage_sample_platform_interface.dart';

/// The iOS implementation of [MoEngageSamplePlatform].
class MoEngageSampleIOS extends MoEngageSamplePlatform {
  /// [MoEngageSampleIOS] Constructor
  MoEngageSampleIOS();

  final MethodChannel _channel = const MethodChannel(channelName);

  /// Registers this class as the default instance of [MoEngageSamplePlatform]
  static void registerWith() {
    Logger.v('Registering MoEngageSampleIOS with Platform Interface');
    MoEngageSamplePlatform.instance = MoEngageSampleIOS();
  }

  @override
  Future<String> greet(String appId) async {
    final Map<String, dynamic> payload = getAccountMeta(appId);
    final result =
        await _channel.invokeMethod<String>(methodNameGreet, payload);
    return result ?? '';
  }
}
