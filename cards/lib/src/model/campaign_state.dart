import '../internal/constants.dart';

/// State of the card Campaign
class CampaignState {
  /// Number of times card shown on the current device
  final int localShowCount;

  /// True if the user has clicked the card, else false.
  bool isClicked;

  /// First Time the card was received.
  final int firstReceived;

  /// First Time the card was seen by the user.
  final int firstSeen;

  /// Total number of times campaign has been seen by the user across devices.
  final int totalShowCount;

  CampaignState(
      {required this.localShowCount,
      required this.isClicked,
      required this.firstReceived,
      required this.firstSeen,
      required this.totalShowCount});

  factory CampaignState.fromJson(Map<String, dynamic> json) {
    return CampaignState(
        localShowCount: json[keyLocalShowCount] ?? 0,
        isClicked: json[keyIsClicked] ?? false,
        firstReceived: json[keyFirstReceived] ?? -1,
        firstSeen: json[keyFirstSeen] ?? -1,
        totalShowCount: json[keyTotalShowCount] ?? 0);
  }

  Map<String, dynamic> toJson() => {
        keyLocalShowCount: localShowCount,
        keyIsClicked: isClicked,
        keyFirstReceived: firstReceived,
        keyFirstSeen: firstSeen,
        keyTotalShowCount: totalShowCount
      };
}
