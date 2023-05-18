import 'package:moengage_cards/src/internal/cards_platform.dart';
import 'package:moengage_flutter/internal/logger.dart';

import 'callback_cache.dart';

class MoEiOSCardsController extends MoEngageCardsPlatform {
  MoEiOSCardsController() : super();

  @override
  void setAppOpenCardsSyncListener(
      CardsSyncListener cardsSyncListener, String appId) {
    Logger.d("App Open Sync Listener Not Available for IOS ");
  }
}
