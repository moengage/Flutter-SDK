import '../../moengage_cards_platform_interface.dart';

/// Callback Cache for Cards Module
class CallbackCache {
  /// Set cards sync complete callback listener
  /// Currently applicable for AppOpen Sync, fetching cards when unique id is set.
  CardsSyncListener? cardsSyncListener;

  /// Inbox Open Cards Sync Listener
  CardsSyncListener? inboxOpenSyncListener;

  /// Pull To Refresh Cards Sync Listener
  CardsSyncListener? pullToRefreshOpenSyncListener;
}
