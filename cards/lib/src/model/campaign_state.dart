
import '../internal/contants.dart';

class CampaignState{
  final int localShowCount;
  bool isClicked;
  final int firstReceived;
  final int firstSeen;
  final int totalShowCount;

  CampaignState({required this.localShowCount, required this.isClicked, required this.firstReceived,
      required this.firstSeen, required this.totalShowCount});

  factory CampaignState.fromJson(Map<String,dynamic> json){
    return CampaignState(
      localShowCount: json[keyLocalShowCount],
      isClicked: json[keyIsClicked],
      firstReceived: json[keyFirstReceived],
      firstSeen: json[keyFirstSeen],
      totalShowCount: json[keyTotalShowCount]
    );
  }

  Map<String, dynamic> toJson() =>
      {
        keyLocalShowCount: localShowCount,
        keyIsClicked: isClicked,
        keyFirstReceived: firstReceived,
        keyFirstSeen: firstSeen,
        keyTotalShowCount: totalShowCount
      };

}