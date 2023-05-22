import 'package:moengage_cards/src/internal/contants.dart';

/// Time span during card can be shown
class ShowTime {
  /// Start time for the time range.
  String startTime;

  /// End time for the time range.
  String endTime;

  ShowTime({required this.startTime, required this.endTime});

  factory ShowTime.fromJson(Map<String, dynamic> json) {
    return ShowTime(
        startTime: json[keyStartTime] ?? "", endTime: json[keyEndTime] ?? "");
  }

  Map<String, dynamic> toJson() =>
      {keyStartTime: startTime, keyEndTime: endTime};
}
