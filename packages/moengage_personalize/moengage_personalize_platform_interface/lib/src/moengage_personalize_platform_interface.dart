import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_moengage_personalize.dart';
import 'model/models.dart';

/// Platform Interface for MoEngage Personalize Feature.
abstract class MoEngagePersonalizePlatform extends PlatformInterface {
  /// Constructs a MoEngagePersonalizePlatform.
  MoEngagePersonalizePlatform() : super(token: _token);

  static final Object _token = Object();

  static MoEngagePersonalizePlatform _instance =
      MethodChannelMoEngagePersonalize();

  /// The default instance of [MoEngagePersonalizePlatform] to use.
  ///
  /// Defaults to [MethodChannelMoEngagePersonalize].
  static MoEngagePersonalizePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [MoEngagePersonalizePlatform] when they register themselves.
  static set instance(MoEngagePersonalizePlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Fetches experience campaign metadata filtered by status.
  /// [statuses] - List of [ExperienceStatus] to filter by.
  /// [appId] - MoEngage App ID.
  Future<ExperienceCampaignsMetadata> fetchExperiencesMeta(
      List<ExperienceStatus> statuses, String appId);

  /// Fetches experience campaigns for the given keys and optional attributes.
  /// [experienceKeys] - List of experience keys to fetch.
  /// [attributes] - Optional attributes for targeting.
  /// [appId] - MoEngage App ID.
  Future<ExperienceCampaignsResult> fetchExperiences(
      List<String> experienceKeys,
      Map<String, String> attributes,
      String appId);

  /// Tracks impression events for one or more experience campaigns.
  /// [campaigns] - List of [ExperienceCampaign] to track.
  /// [appId] - MoEngage App ID.
  void trackExperienceShown(List<ExperienceCampaign> campaigns, String appId);

  /// Tracks a click event for a single experience campaign.
  /// [campaign] - The [ExperienceCampaign] that was clicked.
  /// [appId] - MoEngage App ID.
  void trackExperienceClicked(ExperienceCampaign campaign, String appId);

  /// Tracks impression events for one or more offerings.
  /// [offeringAttributes] - List of offering attribute maps.
  /// [appId] - MoEngage App ID.
  void trackOfferingShown(
      List<Map<String, dynamic>> offeringAttributes, String appId);

  /// Tracks a click event for a single offering.
  /// [campaign] - The [ExperienceCampaign] containing the offering.
  /// [offeringAttributes] - Attributes of the clicked offering.
  /// [appId] - MoEngage App ID.
  void trackOfferingClicked(ExperienceCampaign campaign,
      Map<String, dynamic> offeringAttributes, String appId);
}
