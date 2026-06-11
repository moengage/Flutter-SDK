import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import '../../moengage_<featureName>_platform_interface.dart';
import '<featureName>_instance_provider.dart';

// Only generate this file if nativeToFlutter events exist.
/// <featureNameCamel> Method Channel Controller
class <featureNameCamel>Controller {
  factory <featureNameCamel>Controller.init() => _instance;

  <featureNameCamel>Controller._internal() {
    _channel.setMethodCallHandler(_handler);
  }

  final String _tag = '${moduleTag}<featureNameCamel>Controller';

  static final <featureNameCamel>Controller _instance = <featureNameCamel>Controller._internal();

  final MethodChannel _channel = const MethodChannel(<featureName>MethodChannel);

  Future<dynamic> _handler(MethodCall call) async {
    try {
      final arguments = call.arguments;
      if (arguments == null) return;
      final json = jsonDecode(arguments.toString());
      final AccountMeta accountMeta =
          accountMetaFromMap(json[keyAccountMeta] as Map<String, dynamic>);

      // One if-branch per nativeToHybrid event method:
      if (call.method == methodOn<EventNameCamel>) {
        final eventJson = json[keyData]?[key<EventDataField>];
        final <SyncModel>? data = (eventJson != null)
            ? <SyncModel>.fromJson(eventJson as Map<String, dynamic>)
            : null;
        <featureNameCamel>InstanceProvider()
            .getCallbackCacheForInstance(accountMeta.appId)
            .syncListener
            ?.call(data);
      }
      // else if (call.method == methodOn<OtherEventNameCamel>) { ... }
    } catch (e, stackTrace) {
      Logger.e(
        '$_tag _handler(): Error: $call has an Exception:',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
