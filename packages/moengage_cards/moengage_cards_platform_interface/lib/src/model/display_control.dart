import '../internal/constants.dart';
import 'show_time.dart';

/// Delivery Controls defined during campaign creation.
class DisplayControl {
  /// [DisplayControl] Constructor
  DisplayControl({
    required this.expireAt,
    required this.expireAfterSeen,
    required this.expireAfterDelivered,
    required this.maxCount,
    required this.isPinned,
    required this.showTime,
  });

  /// Get [DisplayControl] from Json [Map]
  factory DisplayControl.fromJson(Map<String, dynamic> json) {
    return DisplayControl(
      expireAt: (json[keyExpireAt] ?? -1) as int,
      expireAfterSeen: (json[keyExpireAfterSeen] ?? -1) as int,
      expireAfterDelivered: (json[keyExpireAfterDelivered] ?? -1) as int,
      maxCount: (json[keyMaxCount] ?? 0) as int,
      isPinned: (json[keyIsPinned] ?? false) as bool,
      showTime: ShowTime.fromJson(
        (json[keyShowTime] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }

  /// Absolute time at which the card should be expired.
  /// Value in seconds.
  final int expireAt;

  /// Time duration after which card should be expired once it is seen.
  final int expireAfterSeen;

  /// Time duration after which the card should be expired once it is delivered on the device.
  final int expireAfterDelivered;

  /// Maximum number of times a campaign should be shown to the user across devices.
  final int maxCount;

  /// True if the campaign is pinned on top, else false.
  final bool isPinned;

  /// Time during the day when the campaign should be shown.
  final ShowTime showTime;

  /// Convert [DisplayControl] to Json [Map]
  Map<String, dynamic> toJson() => {
        keyExpireAt: expireAt,
        keyExpireAfterSeen: expireAfterSeen,
        keyExpireAfterDelivered: expireAfterDelivered,
        keyMaxCount: maxCount,
        keyIsPinned: isPinned,
        keyShowTime: showTime.toJson()
      };

  @override
  String toString() {
    return 'DisplayControl{expireAt: $expireAt, expireAfterSeen: $expireAfterSeen, expireAfterDelivered: $expireAfterDelivered, maxCount: $maxCount, isPinned: $isPinned, showTime: $showTime}';    
  }
}
