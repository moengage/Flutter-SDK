import '../../moengage_cards_platform_interface.dart';

/// Callback Cache for Cards Module
class CallbackCache {
  CardsSyncListener? appOpenSyncListener;
  CardsSyncListener? inboxOpenSyncListener;
  CardsSyncListener? pullToRefreshOpenSyncListener;
}
