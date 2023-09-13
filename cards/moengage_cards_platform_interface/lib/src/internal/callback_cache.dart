import '../../moengage_cards_platform_interface.dart';

/// Callback Cache for Cards Module
class CallbackCache {
  /// App Open Cards Sync Listener
  CardsSyncListener? appOpenSyncListener;

  /// Inbox Open Cards Sync Listener
  CardsSyncListener? inboxOpenSyncListener;

  /// Pull To Refresh Cards Sync Listener
  CardsSyncListener? pullToRefreshOpenSyncListener;
}
