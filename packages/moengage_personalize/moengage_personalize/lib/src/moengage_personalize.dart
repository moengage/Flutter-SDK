import 'dart:async';

import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

/// Helper class to interact with MoEngage Personalize Experience APIs.
class MoEngagePersonalize {
  /// [MoEngagePersonalize] Constructor
  MoEngagePersonalize(this.appId);

  /// AppId available in MoEngage Platform.
  final String appId;

  final MoEngagePersonalizePlatform _platform =
      MoEngagePersonalizePlatform.instance;

  // --- Fetch APIs (Future-based) ---

  /// Fetches experience campaign metadata filtered by the given [statuses].
  /// Returns [ExperienceCampaignsMetadata] on success.
  /// Throws [PersonalizeError] on failure.
  Future<ExperienceCampaignsMetadata> fetchExperiencesMeta(
    List<ExperienceStatus> statuses,
  ) async {
    return _platform.fetchExperiencesMeta(statuses, appId);
  }

  /// Fetches experience campaigns for the given [experienceKeys].
  /// Optional [attributes] can be provided for targeting.
  /// Returns [ExperienceCampaignsResult] on success.
  /// Throws [PersonalizeError] on failure.
  Future<ExperienceCampaignsResult> fetchExperiences(
    List<String> experienceKeys, {
    Map<String, String> attributes = const {},
  }) async {
    return _platform.fetchExperiences(experienceKeys, attributes, appId);
  }

  /// Convenience method to fetch a single experience by [experienceKey].
  Future<ExperienceCampaignsResult> fetchExperience(
    String experienceKey, {
    Map<String, String> attributes = const {},
  }) async {
    return fetchExperiences([experienceKey], attributes: attributes);
  }

  // --- Tracking APIs (Fire-and-forget) ---

  /// Tracks impression events for one or more experience [campaigns].
  void trackExperienceShown(List<ExperienceCampaign> campaigns) {
    _platform.trackExperienceShown(campaigns, appId);
  }

  /// Tracks a click event for a single experience [campaign].
  void trackExperienceClicked(ExperienceCampaign campaign) {
    _platform.trackExperienceClicked(campaign, appId);
  }

  /// Tracks impression events for one or more offerings.
  void trackOfferingShown(List<Map<String, dynamic>> offeringAttributes) {
    _platform.trackOfferingShown(offeringAttributes, appId);
  }

  /// Tracks a click event for a single offering within an experience [campaign].
  void trackOfferingClicked(
    ExperienceCampaign campaign,
    Map<String, dynamic> offeringAttributes,
  ) {
    _platform.trackOfferingClicked(campaign, offeringAttributes, appId);
  }
}
