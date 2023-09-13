import '../internal/constants.dart';

/// State of the card Campaign
class CampaignState {
  /// [CampaignState] Constructor
  CampaignState({
    required this.localShowCount,
    required this.isClicked,
    required this.firstReceived,
    required this.firstSeen,
    required this.totalShowCount,
  });

  /// Get [CampaignState] from Json [Map]
  factory CampaignState.fromJson(Map<String, dynamic> json) {
    return CampaignState(
      localShowCount: (json[keyLocalShowCount] ?? 0) as int,
      isClicked: (json[keyIsClicked] ?? false) as bool,
      firstReceived: (json[keyFirstReceived] ?? -1) as int,
      firstSeen: (json[keyFirstSeen] ?? -1) as int,
      totalShowCount: (json[keyTotalShowCount] ?? 0) as int,
    );
  }

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

  /// Convert [CampaignState] to Json [Map]
  Map<String, dynamic> toJson() => {
        keyLocalShowCount: localShowCount,
        keyIsClicked: isClicked,
        keyFirstReceived: firstReceived,
        keyFirstSeen: firstSeen,
        keyTotalShowCount: totalShowCount
      };
}
