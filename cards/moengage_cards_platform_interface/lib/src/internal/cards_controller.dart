import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart'
    hide keyData, keyAccountMeta, accountMetaFromMap;
import '../../moengage_cards_platform_interface.dart';
import 'cards_instance_provider.dart';

/// Cards Method Channel Controller
class CardsController {
  /// Factory Constructor
  factory CardsController.init() => _instance;

  CardsController._internal() {
    _channel.setMethodCallHandler(_handler);
  }

  final String _tag = '${TAG}CoreController';
  static final CardsController _instance = CardsController._internal();

  final MethodChannel _channel = const MethodChannel(cardsMethodChannel);

  Future<dynamic> _handler(MethodCall call) async {
    try {
      final arguments = call.arguments;
      if (arguments == null) {
        return;
      }
      final json = jsonDecode(arguments.toString());
      final AccountMeta accountMeta =
          accountMetaFromMap(json[keyAccountMeta] as Map<String, dynamic>);
      if (call.method == methodPullToRefreshCardsSync) {
        final syncJson = json[keyData]?[keySyncCompleteData];
        final SyncCompleteData? data = (syncJson != null)
            ? SyncCompleteData.fromJson(syncJson as Map<String, dynamic>)
            : null;
        CardsInstanceProvider()
            .getCallbackCacheForInstance(accountMeta.appId)
            .pullToRefreshOpenSyncListener
            ?.call(data);
      } else if (call.method == methodOnAppOpenCardsSync) {
        final syncJson = json[keyData]?[keySyncCompleteData];
        final SyncCompleteData? data = (syncJson != null)
            ? SyncCompleteData.fromJson(syncJson as Map<String, dynamic>)
            : null;
        CardsInstanceProvider()
            .getCallbackCacheForInstance(accountMeta.appId)
            .appOpenSyncListener
            ?.call(data);
      } else if (call.method == methodOnInboxOpenCardsSync) {
        final syncJson = json?[keyData]?[keySyncCompleteData];
        final SyncCompleteData? data = (syncJson != null)
            ? SyncCompleteData.fromJson(syncJson as Map<String, dynamic>)
            : null;
        CardsInstanceProvider()
            .getCallbackCacheForInstance(accountMeta.appId)
            .inboxOpenSyncListener
            ?.call(data);
      }
    } catch (err, stackTrace) {
      Logger.e(
        '$_tag _handler(): Error: ${call} has an Exception:',
        error: err,
        stackTrace: stackTrace,
      );
    }
  }
}
