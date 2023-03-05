import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/model/moe_init_config.dart';
import 'package:moengage_flutter/model/push/push_config.dart';

import '../utils.dart';

class InitConfigPayloadMapper {
  Map<String, dynamic> getInitPayload(
      String appId, MoEInitConfig moEInitConfig) {
    Map<String, dynamic> payload = getAccountMeta(appId);
    payload[keyConfig] = _initConfigToMap(moEInitConfig);
    return payload;
  }

  Map<String, dynamic> _initConfigToMap(MoEInitConfig moEInitConfig) {
    Map<String, dynamic> initPayload = {};
    initPayload[keyPushConfig] = _pushConfigToMap(moEInitConfig.pushConfig);
    return initPayload;
  }

  Map<String, dynamic> _pushConfigToMap(PushConfig pushConfig) {
    Map<String, dynamic> pushConfigPayload = {
      keyShouldDeliverCallbackOnForegroundClick:
          pushConfig.shouldDeliverCallbackOnForegroundClick
    };
    return pushConfigPayload;
  }
}
