import 'package:moengage_cards/src/model/show_time.dart';

import '../internal/contants.dart';

class DisplayControl {
  final int expireAt;
  final int expireAfterSeen;
  final int expireAfterDelivered;
  final int maxCount;
  final bool isPinned;
  final ShowTime showTime;

  DisplayControl(
      {required this.expireAt,
      required this.expireAfterSeen,
      required this.expireAfterDelivered,
      required this.maxCount,
      required this.isPinned,
      required this.showTime});

  factory DisplayControl.fromJson(Map<String, dynamic> json) {
    return DisplayControl(
        expireAt: json[keyExpireAt] ?? -1,
        expireAfterSeen: json[keyExpireAfterSeen] ?? -1,
        expireAfterDelivered: json[keyExpireAfterDelivered] ?? -1,
        maxCount: json[keyMaxCount] ?? 0,
        isPinned: json[keyIsPinned] ?? false,
        showTime: ShowTime.fromJson(json[keyShowTime]));
  }

  Map<String,dynamic> toJson() => {
    keyExpireAt: expireAt,
    keyExpireAfterSeen: expireAfterSeen,
    keyExpireAfterDelivered: expireAfterDelivered,
    keyMaxCount: maxCount,
    keyIsPinned: isPinned,
    keyShowTime: showTime.toJson()
  };
}
