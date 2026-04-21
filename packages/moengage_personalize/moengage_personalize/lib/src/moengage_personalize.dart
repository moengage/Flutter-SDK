import 'dart:async';

import 'package:moengage_flutter/moengage_flutter.dart' show Logger;
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

/// Helper class to interact with MoEngage Personalize Experience APIs.
class MoEngagePersonalize {
  /// [MoEngagePersonalize] Constructor
  MoEngagePersonalize(this.appId);

  /// AppId available in MoEngage Platform.
  final String appId;

  static const String _tag = '${moduleTag}MoEngagePersonalize';

  final MoEngagePersonalizePlatform _platform =
      MoEngagePersonalizePlatform.instance;

  // --- Fetch APIs (Future-based) ---

  /// Fetches experience campaign metadata filtered by the given [statuses].
  /// Returns [ExperienceCampaignsMetadata] on success.
  /// Throws [PersonalizeError] on failure.
  Future<ExperienceCampaignsMetadata> fetchExperiencesMeta(
    List<ExperienceStatus> statuses,
  ) async {
    Logger.v('$_tag fetchExperiencesMeta(): statuses: $statuses');
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
    Logger.v('$_tag fetchExperiences(): keys: $experienceKeys');
    return _platform.fetchExperiences(experienceKeys, attributes, appId);
  }

  /// Convenience method to fetch a single experience by [experienceKey].
  Future<ExperienceCampaignsResult> fetchExperience(
    String experienceKey, {
    Map<String, String> attributes = const {},
  }) async {
    Logger.v('$_tag fetchExperience(): key: $experienceKey');
    return fetchExperiences([experienceKey], attributes: attributes);
  }

  // --- Tracking APIs (Fire-and-forget) ---

  /// Tracks impression events for one or more experience [campaigns].
  void experiencesShown(List<ExperienceCampaign> campaigns) {
    Logger.v('$_tag experiencesShown(): campaigns: ${campaigns.length}');
    _platform.experiencesShown(campaigns, appId);
  }

  /// Tracks a click event for a single experience [campaign].
  void experienceClicked(ExperienceCampaign campaign) {
    Logger.v('$_tag experienceClicked(): key: ${campaign.experienceKey}');
    _platform.experienceClicked(campaign, appId);
  }

  /// Tracks impression events for one or more offerings.
  void offeringsShown(List<Map<String, dynamic>> offeringPayloads) {
    Logger.v('$_tag offeringsShown(): count: ${offeringPayloads.length}');
    _platform.offeringsShown(offeringPayloads, appId);
  }

  /// Tracks a click event for a single offering within an experience [campaign].
  void offeringClicked(
    ExperienceCampaign campaign,
    Map<String, dynamic> offeringPayload,
  ) {
    Logger.v('$_tag offeringClicked(): key: ${campaign.experienceKey}');
    _platform.offeringClicked(campaign, offeringPayload, appId);
  }
}
