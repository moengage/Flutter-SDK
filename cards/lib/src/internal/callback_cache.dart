
import 'package:moengage_cards/src/model/sync_data.dart';

class CallbackCache {
  CardsSyncListener? appOpenSyncListener;
  CardsSyncListener? inboxOpenSyncListener;
  CardsSyncListener? pullToRefreshOpenSyncListener;
}

typedef CardsSyncListener = void Function(SyncCompleteData data);
