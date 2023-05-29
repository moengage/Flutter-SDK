import 'package:moengage_cards/moengage_cards.dart';

/// Callback Cache for Cards Module
class CallbackCache {
  CardsSyncListener? appOpenSyncListener;
  CardsSyncListener? inboxOpenSyncListener;
  CardsSyncListener? pullToRefreshOpenSyncListener;
}
