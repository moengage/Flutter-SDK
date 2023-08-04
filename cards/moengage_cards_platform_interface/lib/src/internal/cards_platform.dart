import 'dart:convert';

import 'package:flutter/services.dart';

import '../../moengage_cards_platform_interface.dart';
import 'cards_instance_provider.dart';

/// Common Implementation of Cards Platform Interface
abstract class MoEngageCardsPlatform extends MoEngageCardsPlatformInterface {
  static const String _tag = '${moduleTag}CardsPlatformBase';

  MethodChannel methodChannel = const MethodChannel(cardsMethodChannel);

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
