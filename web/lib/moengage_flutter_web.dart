import 'dart:convert';
import 'dart:async';
import 'dart:js';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:moengage_flutter_web/constants.dart';


class MoEngageFlutterPlugin {
  var _moengage = JsObject.fromBrowserObject(context['Moengage']);

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
        channelName,
        const StandardMethodCodec(),
        registrar.messenger);
    final MoEngageFlutterPlugin instance = MoEngageFlutterPlugin();
    channel.setMethodCallHandler(instance.handleMethodCall);

  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case methodInitialise:
        return _initialise();
      case methodTrackEvent:
        return _trackEvent(call);
      case methodSetUserAttribute:
        return _setUserAttribute(call);
      case methodSetUserAttributeTimeStamp:
        return _setUserAttributeTimeStamp(call);
      case methodLogout:
        return _logout();
      case methodSetAlias:
        return _setAlias(call);
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The moengage_flutter_web plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }

  _initialise() {
    // this is to just suppress the warning about this method
    return null;
  }
  
  _trackEvent(MethodCall call) {
    var payload = json.decode(call.arguments);
    _moengage.callMethod(methodTrackEventSDK, [payload[keyEventName], JsObject.jsify(payload[keyEventAttributes])]);
  }

  _setUserAttribute(MethodCall call) {
    var payload = json.decode(call.arguments);
    _moengage.callMethod(methodSetUserAttributeSDK, [payload[keyAttributeName], payload[keyAttributeValue]]);
  }
  _setUserAttributeTimeStamp(MethodCall call) {
    var payload = json.decode(call.arguments);
    _moengage.callMethod(methodSetUserAttributeSDK, [payload[keyAttributeName], JsObject.jsify(payload[keyAttributeValue])]);
  }

  _setAlias(MethodCall call) {
    var payload = json.decode(call.arguments);
    _moengage.callMethod(methodSetAliasSDK, [payload[keyAlias]]);
  }

  _logout() {
    _moengage.callMethod(methodLogoutSDK);
  }

} 