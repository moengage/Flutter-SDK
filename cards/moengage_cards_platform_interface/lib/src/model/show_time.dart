import '../internal/constants.dart';

/// Time span during card can be shown
class ShowTime {
  ShowTime({required this.startTime, required this.endTime});

  factory ShowTime.fromJson(Map<String, dynamic> json) {
    return ShowTime(
      startTime: (json[keyStartTime] ?? '') as String,
      endTime: (json[keyEndTime] ?? '') as String,
    );
  }

  /// Start time for the time range.
  String startTime;

  /// End time for the time range.
  String endTime;

  Map<String, dynamic> toJson() =>
      {keyStartTime: startTime, keyEndTime: endTime};
}
