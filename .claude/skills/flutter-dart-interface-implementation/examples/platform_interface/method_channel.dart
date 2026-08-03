import 'dart:convert';

import 'package:moengage_flutter/moengage_flutter.dart' show getAccountMeta;

import '../../moengage_<featureName>_platform_interface.dart';

/// MethodChannel implementation of [MoEngage<featureNameCamel>PlatformInterface]
class MethodChannelMoEngage<featureNameCamel> extends MoEngage<featureNameCamel>Platform {
  // Fire-and-forget example:
  @override
  void initialize(String appId) {
    methodChannel.invokeMethod(
      methodInitialize,
      jsonEncode(getAccountMeta(appId)),
    );
  }

  // Future result example:
  @override
  Future<<ResultModel>> get<ResultName>(String appId) async {
    final result = await methodChannel.invokeMethod(
      method<ResultName>,
      jsonEncode(getAccountMeta(appId)),
    );
    return deSerialize<ResultModel>(result as String);
  }

  // Method with extra data payload example:
  @override
  Future<<ResultModel>> get<ResultNameWithData>(String param, String appId) async {
    final result = await methodChannel.invokeMethod(
      method<ResultNameWithData>,
      jsonEncode(get<ResultNameWithData>Payload(param, appId)),
    );
    return deSerialize<ResultModel>(result as String);
  }
}
