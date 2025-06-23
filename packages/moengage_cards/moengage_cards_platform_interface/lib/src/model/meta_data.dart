import '../internal/constants.dart';
import 'campaign_state.dart';
import 'display_control.dart';

/// Meta data related to a campaign.
class MetaData {
  /// [MetaData] Constructor
  MetaData({
    required this.isNewCard,
    required this.campaignState,
    required this.deletionTime,
    required this.displayControl,
    required this.metaData,
    required this.updatedTime,
    required this.createdAt,
    required this.campaignPayload,
    required this.isPinned,
  });

  /// Get [MetaData] from Json [Map]
  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      isNewCard: (json[keyIsNewCard] ?? false) as bool,
      campaignState: CampaignState.fromJson(
        (json[keyCampaignState] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      deletionTime: (json[keyDeletionTime] ?? -1) as int,
      displayControl: DisplayControl.fromJson(
        (json[keyDisplayControl] ?? <String, dynamic>{})
            as Map<String, dynamic>,
      ),
      campaignPayload: (json[keyCampaignPayload] ?? <String, dynamic>{})
          as Map<String, dynamic>,
      metaData: (json[keyAdditionalMetaData] ?? <String, dynamic>{})
          as Map<String, dynamic>,
      updatedTime: (json[keyUpdatedAt] ?? -1) as int,
      createdAt: (json[keyCreatedAt] ?? -1) as int,
      isPinned: (json[keyDisplayControl]?[keyIsPinned] ?? false) as bool,
    );
  }

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

  /// Check Card is Pinned
  final bool isPinned;

  /// Convert [MetaData] to Json [Map]
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

  @override
  String toString() {
    return 'MetaData{isNewCard: $isNewCard, campaignState: $campaignState, deletionTime: $deletionTime, displayControl: $displayControl, metaData: $metaData, updatedTime: $updatedTime, createdAt: $createdAt, campaignPayload: $campaignPayload, isPinned: $isPinned}';
  }
}
