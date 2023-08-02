import '../internal/constants.dart';
import '../internal/payload_mapper.dart';
import 'sync_type.dart';

/// Sync Complete Data
class SyncCompleteData {
  SyncCompleteData({required this.hasUpdates, required this.syncType});

  factory SyncCompleteData.fromJson(Map<String, dynamic> data) {
    return SyncCompleteData(
      hasUpdates: (data[keyHasUpdates] ?? false) as bool,
      syncType: syncTypeFromString(data[keySyncType] as String),
    );
  }

  /// Indicating if there were any updates in the cards post sync. true if there are any new
  /// updates present else false. This value is true even if card(s) are deleted.
  bool hasUpdates;

  /// Condition under which sync was triggered. Refer to [SyncType]
  SyncType syncType;

  Map<String, dynamic> toJson() =>
      {keySyncType: syncTypeToString(syncType), keyHasUpdates: hasUpdates};

  @override
  String toString() {
    return 'SyncCompleteData{hasUpdates: $hasUpdates, syncType: $syncType}';
  }
}
