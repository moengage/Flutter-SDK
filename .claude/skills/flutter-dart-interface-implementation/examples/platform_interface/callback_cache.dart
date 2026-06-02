import '../../moengage_<featureName>_platform_interface.dart';

// Only generate this file if event listener caching is needed.
/// Callback Cache for <featureNameCamel> Module
class CallbackCache {
  // One nullable listener field per nativeToFlutter event type:
  /// Generic sync listener
  <featureNameCamel>SyncListener? syncListener;

  // Add more fields if there are multiple event types, e.g.:
  // <featureNameCamel>SyncListener? inboxOpenSyncListener;
  // <featureNameCamel>SyncListener? pullToRefreshSyncListener;
}
