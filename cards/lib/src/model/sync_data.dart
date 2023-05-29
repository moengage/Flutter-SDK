import 'package:moengage_cards/src/internal/constants.dart';
import 'package:moengage_cards/src/model/sync_type.dart';
import 'package:moengage_cards/src/internal/payload_mapper.dart';

/// Sync Complete Data
class SyncCompleteData {
  /// Indicating if there were any updates in the cards post sync. true if there are any new
  /// updates present else false. This value is true even if card(s) are deleted.
  bool hasUpdates;

  /// Condition under which sync was triggered. Refer to [SyncType]
  SyncType syncType;

  SyncCompleteData({required this.hasUpdates, required this.syncType});

  factory SyncCompleteData.fromJson(Map<String, dynamic> data) {
    return SyncCompleteData(
        hasUpdates: data[keyHasUpdates] ?? false,
        syncType: syncTypeFromString(data[keySyncType]));
  }

  Map<String, dynamic> toJson() =>
      {keySyncType: syncType.name, keyHasUpdates: hasUpdates};

  @override
  String toString() {
    return 'SyncCompleteData{hasUpdates: $hasUpdates, syncType: $syncType}';
  }
}
