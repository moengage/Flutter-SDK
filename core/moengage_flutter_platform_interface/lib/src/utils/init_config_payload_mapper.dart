import '../../src/model/moe_init_config.dart';
import '../../src/model/push/push_config.dart';
import '../../src/utils/utils.dart';
import '../internal/constants.dart';

/// PayloadMapper for [MoEInitConfig]
class InitConfigPayloadMapper {
  /// Convert [MoEInitConfig] to [Map] with Given [appId]
  Map<String, dynamic> getInitPayload(
      String appId, MoEInitConfig moEInitConfig) {
    final Map<String, dynamic> payload = getAccountMeta(appId);
    payload[keyInitConfig] = _initConfigToMap(moEInitConfig);
    return payload;
  }

  Map<String, dynamic> _initConfigToMap(MoEInitConfig moEInitConfig) {
    final Map<String, dynamic> initPayload = {};
    initPayload[keyPushConfig] = _pushConfigToMap(moEInitConfig.pushConfig);
    return initPayload;
  }

  Map<String, dynamic> _pushConfigToMap(PushConfig pushConfig) {
    final Map<String, dynamic> pushConfigPayload = {
      keyShouldDeliverCallbackOnForegroundClick:
          pushConfig.shouldDeliverCallbackOnForegroundClick
    };
    return pushConfigPayload;
  }
}
