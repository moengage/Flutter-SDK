import 'package:flutter/services.dart';

import '../model/inapp/click_data.dart';
import '../model/inapp/inapp_data.dart';
import '../model/inapp/self_handled_data.dart';
import '../model/permission_result.dart';
import '../model/push/push_campaign_data.dart';
import '../model/push/push_token_data.dart';
import '../utils/in_app_payload_mapper.dart';
import '../utils/push_payload_mapper.dart';
import '../utils/utils.dart';
import 'callback/callbacks.dart';
import 'constants.dart';
import 'core_instance_provider.dart';
import 'logger.dart';
import 'moe_cache.dart';

/// Native to Flutter Method Channel Controller
class CoreController {
  /// Factory Constructor
  factory CoreController.init() => _instance;

  CoreController._internal() {
    _channel.setMethodCallHandler(_handler);
  }

  final String _tag = '${TAG}CoreController';
  static final CoreController _instance = CoreController._internal();
  final MethodChannel _channel = const MethodChannel(channelName);

  Future<dynamic> _handler(MethodCall call) async {
    Logger.v(
        '$_tag _handler() : Received callback. Payload ${call.method} - ${call.arguments}');
    try {
      if (call.method == callbackPushTokenGenerated) {
        final PushTokenData? data =
            PushPayloadMapper().pushTokenFromJson(call.arguments);
        if (data != null) {
          final PushTokenCallbackHandler? handler =
              Cache().pushTokenCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackOnPushClick) {
        final PushCampaignData? data =
            PushPayloadMapper().pushCampaignFromJson(call.arguments);
        if (data != null) {
          final PushClickCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .pushClickCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackOnInAppClicked ||
          call.method == callbackOnInAppCustomAction) {
        final ClickData? data =
            InAppPayloadMapper().actionFromJson(call.arguments);
        if (data != null) {
          final InAppClickCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .inAppClickCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackOnInAppShown) {
        final InAppData? data =
            InAppPayloadMapper().inAppDataFromJson(call.arguments);
        if (data != null) {
          final InAppShownCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .inAppShownCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackOnInAppDismissed) {
        final InAppData? data =
            InAppPayloadMapper().inAppDataFromJson(call.arguments);
        if (data != null) {
          final InAppDismissedCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .inAppDismissedCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackOnInAppSelfHandled) {
        final SelfHandledCampaignData? data =
            InAppPayloadMapper().selfHandledCampaignFromJson(call.arguments);
        Logger.i('$_tag _handler() : data: $data');
        if (data != null) {
          final SelfHandledInAppCallbackHandler? handler =
              CoreInstanceProvider()
                  .getCallbackCacheForInstance(data.accountMeta.appId)
                  .selfHandledInAppCallbackHandler;
          Logger.v('$_tag _handler() : handler: $handler');
          if (handler != null) {
            handler.call(data);
          }
        }
      }
      if (call.method == callbackPermissionResult) {
        final PermissionResultCallbackHandler? handler =
            Cache().permissionResultCallbackHandler;
        if (handler != null) {
          final PermissionResultData data =
              permissionResultFromMap(call.arguments);
          handler.call(data);
        }
      }
    } catch (e, stackTrace) {
      Logger.e('$_tag Error: $call has an Exception:',
          error: e, stackTrace: stackTrace);
    }
  }
}
