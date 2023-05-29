import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_cards/src/internal/cards_platform_interface.dart';
import 'package:moengage_cards/src/internal/constants.dart';
import 'package:moengage_cards/src/internal/payload_mapper.dart';
import 'package:moengage_flutter/internal/logger.dart';
import '../../moengage_cards.dart';
import 'cards_instance_provider.dart';

/// Common Implementation of Cards Platform Interface
abstract class MoEngageCardsPlatform extends MoEngageCardsPlatformInterface {
  static const String _tag = "${MODULE_TAG}CardsPlatformBase";

  MethodChannel methodChannel = const MethodChannel(cardsMethodChannel);

  MoEngageCardsPlatform() : super() {
    methodChannel.setMethodCallHandler(_handler);
  }

  Future<dynamic> _handler(MethodCall call) async {
    try {
      final arguments = call.arguments;
      if (arguments == null) {
        return;
      }
      final json = jsonDecode(arguments.toString());
      final accountMeta = accountMetaFromMap(json[keyAccountMeta]);
      if (call.method == methodPullToRefreshCardsSync) {
        final syncJson = json[keyData]?[keySyncCompleteData];
        SyncCompleteData? data =
            (syncJson != null) ? SyncCompleteData.fromJson(syncJson) : null;
        CardsInstanceProvider()
            .getCallbackCacheForInstance(accountMeta.appId)
            .pullToRefreshOpenSyncListener
            ?.call(data);
      } else if (call.method == methodOnAppOpenCardsSync) {
        final syncJson = json[keyData]?[keySyncCompleteData];
        SyncCompleteData? data =
            (syncJson != null) ? SyncCompleteData.fromJson(syncJson) : null;
        CardsInstanceProvider()
            .getCallbackCacheForInstance(accountMeta.appId)
            .appOpenSyncListener
            ?.call(data);
      } else if (call.method == methodOnInboxOpenCardsSync) {
        final syncJson = json[keyData]?[keySyncCompleteData];
        SyncCompleteData? data =
            (syncJson != null) ? SyncCompleteData.fromJson(syncJson) : null;
        CardsInstanceProvider()
            .getCallbackCacheForInstance(accountMeta.appId)
            .inboxOpenSyncListener
            ?.call(data);
      }
    } catch (err, stackTrace) {
      Logger.e("$_tag Error: ${call.toString()} has an Exception:",
          error: err, stackTrace: stackTrace);
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
      CardsSyncListener cardsSyncListener, String appId) {
    CardsInstanceProvider()
        .getCallbackCacheForInstance(appId)
        .appOpenSyncListener = cardsSyncListener;
  }
}
