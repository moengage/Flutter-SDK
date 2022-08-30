import 'package:flutter/services.dart';
import 'package:moengage_flutter/in_app_payload_mapper.dart';
import 'package:moengage_flutter/moe_android_core.dart';
import 'package:moengage_flutter/moe_ios_core.dart';
import 'package:moengage_flutter/constants.dart';
import 'package:moengage_flutter/core_instance_provider.dart';
import 'package:moengage_flutter/model/inapp/click_data.dart';
import 'package:moengage_flutter/model/inapp/inapp_data.dart';
import 'package:moengage_flutter/model/inapp/self_handled_data.dart';
import 'package:moengage_flutter/model/push/push_campaign_data.dart';
import 'package:moengage_flutter/model/push/push_token_data.dart';
import 'package:moengage_flutter/moe_cache.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_flutter/push_payload_mapper.dart';
import 'package:moengage_flutter/utils.dart';

import 'constants.dart';

class CoreController {

  String _tag = "${TAG}CoreController";
  static late CoreController _instance = CoreController._internal();
  late MethodChannel channel = MethodChannel(channelName);

  late MoEAndroidCore moEAndroid;
  late MoEiOSCore moEiOS;

  CoreController._internal() {
    moEAndroid = MoEAndroidCore(channel);
    moEiOS = MoEiOSCore(channel);
    channel.setMethodCallHandler(_handler);
  }

  factory CoreController() => _instance;


  Future<dynamic> _handler(MethodCall call) async {
    print("$_tag _handler() : Received callback. Payload " + call.method);
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
        print("$_tag _handler() : data: $data");
        if (data != null) {
          SelfHandledInAppCallbackHandler? handler = CoreInstanceProvider()
              .getCallbackCacheForInstance(data.accountMeta.appId)
              .selfHandledInAppCallbackHandler;
          print("$_tag _handler() : handler: $handler");
          if (handler != null) {
            handler.call(data);
          }
        }
      }
    } catch (exception) {
      print("$_tag MoEngageFlutter _handler() : " +
          call.toString() +
          " has an Exception: " +
          exception.toString());
    }
  }


}