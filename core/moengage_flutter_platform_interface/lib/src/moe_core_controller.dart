import 'package:flutter/services.dart';

import '../src/internal/callback/callbacks.dart';
import '../src/internal/logger.dart';
import '../src/model/inapp/click_data.dart';
import '../src/model/inapp/inapp_data.dart';
import '../src/model/inapp/self_handled_data.dart';
import '../src/model/permission_result.dart';
import '../src/model/push/push_campaign_data.dart';
import '../src/model/push/push_token_data.dart';
import '../src/moe_cache.dart';
import 'constants.dart';
import 'core_instance_provider.dart';
import 'utils/in_app_payload_mapper.dart';
import 'utils/push_payload_mapper.dart';
import 'utils/utils.dart';

class CoreController {
  factory CoreController() => _instance;

  CoreController._internal() {
    channel.setMethodCallHandler(_handler);
  }
  final String _tag = '${TAG}CoreController';
  static final CoreController _instance = CoreController._internal();
  late MethodChannel channel = const MethodChannel(channelName);

  Future<dynamic> _handler(MethodCall call) async {
    Logger.v('$_tag _handler() : Received callback. Payload ${call.method}');
    try {
      if (call.method == callbackPushTokenGenerated) {
        PushTokenData? data =
            PushPayloadMapper().pushTokenFromJson(call.arguments);
        if (data != null) {
          PushTokenCallbackHandler? handler = Cache().pushTokenCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackOnPushClick) {
        PushCampaignData? data =
            PushPayloadMapper().pushCampaignFromJson(call.arguments);
        if (data != null) {
          PushClickCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .pushClickCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackOnInAppClicked ||
          call.method == callbackOnInAppCustomAction) {
        ClickData? data = InAppPayloadMapper().actionFromJson(call.arguments);
        if (data != null) {
          InAppClickCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .inAppClickCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackOnInAppShown) {
        InAppData? data =
            InAppPayloadMapper().inAppDataFromJson(call.arguments);
        if (data != null) {
          InAppShownCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .inAppShownCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackOnInAppDismissed) {
        InAppData? data =
            InAppPayloadMapper().inAppDataFromJson(call.arguments);
        if (data != null) {
          InAppDismissedCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .inAppDismissedCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackOnInAppSelfHandled) {
        SelfHandledCampaignData? data =
            InAppPayloadMapper().selfHandledCampaignFromJson(call.arguments);
        Logger.i('$_tag _handler() : data: $data');
        if (data != null) {
          SelfHandledInAppCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .selfHandledInAppCallbackHandler;
          Logger.v('$_tag _handler() : handler: $handler');
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackPermissionResult) {
        PermissionResultCallbackHandler? handler =
            Cache().permissionResultCallbackHandler;
        if (handler != null) {
          PermissionResultData data = permissionResultFromMap(call.arguments);
          handler.call(data);
        }
      }
    } catch (e, stackTrace) {
      Logger.e('$_tag Error: ${call.toString()} has an Exception:',
          error: e, stackTrace: stackTrace);
    }
  }
}
