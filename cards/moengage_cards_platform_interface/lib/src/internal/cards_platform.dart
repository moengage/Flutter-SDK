import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_flutter_platform_interface/src/internal/logger.dart';
import 'package:moengage_flutter_platform_interface/src/model/account_meta.dart';

import '../../moengage_cards_platform_interface.dart';
import 'cards_instance_provider.dart';

/// Common Implementation of Cards Platform Interface
abstract class MoEngageCardsPlatform extends MoEngageCardsPlatformInterface {
  MoEngageCardsPlatform() : super() {
    methodChannel.setMethodCallHandler(_handler);
  }
  static const String _tag = '${moduleTag}CardsPlatformBase';

  MethodChannel methodChannel = const MethodChannel(cardsMethodChannel);

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
        final syncJson = json[keyData]?[keySyncCompleteData];
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
        '$_tag _handler(): Error: ${call.toString()} has an Exception:',
        error: err,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void refreshCards(String appId, CardsSyncListener cardsSyncListener) {
    CardsInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .pullToRefreshOpenSyncListener = cardsSyncListener;
  }

  @override
  void onCardsSectionLoaded(String appId, CardsSyncListener cardsSyncListener) {
    CardsInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .inboxOpenSyncListener = cardsSyncListener;
  }

  @override
  void setAppOpenCardsSyncListener(
    CardsSyncListener cardsSyncListener,
    String appId,
  ) {
    CardsInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .appOpenSyncListener = cardsSyncListener;
  }
}
