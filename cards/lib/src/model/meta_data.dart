
import '../internal/contants.dart';
import 'campaign_state.dart';
import 'display_control.dart';

class MetaData {
  final bool isNewCard;
  final CampaignState campaignState;
  final int deletionTime;
  final DisplayControl displayControl;
  final Map<String, dynamic> metaData;
  final int updatedTime;
  final int createdAt;
  final Map<String, dynamic> campaignPayload;

  MetaData({required this.isNewCard,
    required this.campaignState,
    required this.deletionTime,
    required this.displayControl,
    required this.metaData,
    required this.updatedTime,
    required this.createdAt,
    required this.campaignPayload});

  factory MetaData.fromJson(Map<String, dynamic> json){
    return MetaData(
        isNewCard: json[keyIsNewCard] ?? false,
        campaignState: CampaignState.fromJson(json[keyCampaignState] ?? {}),
        deletionTime: json[keyDeletionTime]??-1,
        displayControl: DisplayControl.fromJson(json[keyDisplayControl]??{}),
        campaignPayload: json[keyCampaignPayload],
        metaData: json[keyMetaData1],
        updatedTime: json[keyUpdatedAt],
        createdAt: json[keyCreatedAt] ?? -1
    );
  }


  Map<String,dynamic> toJson() => {
    keyIsNewCard : isNewCard,
    keyCampaignState: campaignState.toJson(),
    keyDeletionTime: deletionTime,
    keyDisplayControl: displayControl.toJson(),
    keyMetaData1: metaData,
    keyUpdatedAt: updatedTime,
    keyCreatedAt: createdAt,
    keyCampaignPayload: campaignPayload
  };
}
