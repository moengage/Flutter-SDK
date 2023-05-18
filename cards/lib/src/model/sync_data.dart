

import 'package:moengage_cards/src/internal/contants.dart';
import 'package:moengage_cards/src/model/sync_type.dart';
import 'package:moengage_cards/src/internal/payload_mapper.dart';

class SyncCompleteData {

  bool hasUpdates;
  SyncType syncType;
  SyncCompleteData({required this.hasUpdates,required this.syncType});

  factory SyncCompleteData.fromJson(Map<String,dynamic> data){
    return SyncCompleteData(
      hasUpdates: data[keyHasUpdates]??false,
      syncType: syncTypeFromString(data[keySyncType])
    );
  }

  @override
  String toString() {
    return 'SyncCompleteData{hasUpdates: $hasUpdates, syncType: $syncType}';
  }
}
