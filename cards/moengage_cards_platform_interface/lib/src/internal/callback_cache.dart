import '../../moengage_cards_platform_interface.dart';

/// Callback Cache for Cards Module
class CallbackCache {
  /// Sync Listener Cache for Card syncs performed by SDK.
  /// Currently applicable for AppOpen Sync, Card fetch on login ..
  CardsSyncListener? cardsSyncListener;

  /// Inbox Open Cards Sync Listener
  CardsSyncListener? inboxOpenSyncListener;

  /// Pull To Refresh Cards Sync Listener
  CardsSyncListener? pullToRefreshOpenSyncListener;
}
