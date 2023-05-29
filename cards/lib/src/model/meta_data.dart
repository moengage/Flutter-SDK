import '../internal/constants.dart';
import 'campaign_state.dart';
import 'display_control.dart';

/// Meta data related to a campaign.
class MetaData {
  /// True if the campaign hasn't been delivered to the inbox, else false.
  final bool isNewCard;

  /// Current state of the campaign.
  final CampaignState campaignState;

  /// Time at which the campaign would be deleted from local store.
  final int deletionTime;

  /// Delivery Controls defined during campaign creation.
  final DisplayControl displayControl;

  /// Additional meta data regarding campaign used for tracking purposes.
  final Map<String, dynamic> metaData;

  /// Last time the campaign was updated.
  final int updatedTime;

  /// Campaign Created Time
  /// Note: Only Available for iOS platform
  final int createdAt;

  /// Complete Campaign payload
  final Map<String, dynamic> campaignPayload;

  MetaData(
      {required this.isNewCard,
      required this.campaignState,
      required this.deletionTime,
      required this.displayControl,
      required this.metaData,
      required this.updatedTime,
      required this.createdAt,
      required this.campaignPayload});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
        isNewCard: json[keyIsNewCard] ?? false,
        campaignState: CampaignState.fromJson(json[keyCampaignState] ?? {}),
        deletionTime: json[keyDeletionTime] ?? -1,
        displayControl: DisplayControl.fromJson(json[keyDisplayControl] ?? {}),
        campaignPayload: json[keyCampaignPayload] ?? {},
        metaData: json[keyAdditionalMetaData] ?? {},
        updatedTime: json[keyUpdatedAt] ?? -1,
        createdAt: json[keyCreatedAt] ?? -1);
  }

  Map<String, dynamic> toJson() => {
        keyIsNewCard: isNewCard,
        keyCampaignState: campaignState.toJson(),
        keyDeletionTime: deletionTime,
        keyDisplayControl: displayControl.toJson(),
        keyAdditionalMetaData: metaData,
        keyUpdatedAt: updatedTime,
        keyCreatedAt: createdAt,
        keyCampaignPayload: campaignPayload
      };
}
