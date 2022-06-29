import 'package:flutter/services.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/core_instance_provider.dart';
import 'package:moengage_flutter/model/inapp/click_data.dart';
import 'package:moengage_flutter/model/inapp/inapp_data.dart';
import 'package:moengage_flutter/model/inapp/self_handled_data.dart';
import 'package:moengage_flutter/model/push/push_campaign_data.dart';
import 'package:moengage_flutter/model/push/push_token_data.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_flutter/push_payload_mapper.dart';
import 'package:moengage_flutter/utils.dart';

import 'in_app_payload_mapper.dart';

class CallbackHandler {
  Future<dynamic> _handler(MethodCall call) async {
    print("Received callback in dart. Payload" + call.toString());
    try {
      if (call.method == callbackPushTokenGenerated) {
        PushTokenData? data =
            PushPayloadMapper().pushTokenFromJson(call.arguments);
        if (data != null) {
          // PushTokenCallbackHandler? handler = CoreInstanceProvider()
          //     .getCallbackCacheForInstance()
          //     .pushTokenCallbackHandler;
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
        if (data != null) {
          SelfHandledInAppCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .selfHandledInAppCallbackHandler;
          if (handler != null) {
            handler.call(data);
          }
        }
      }
    } catch (exception) {
      print("MoEngageFlutter _handler() : " +
          call.toString() +
          " has an Exception: " +
          exception.toString());
    }
  }
}
