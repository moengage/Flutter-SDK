import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show Logger;
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

/// The Android implementation of [MoEngagePersonalizePlatform].
class MoEngagePersonalizeAndroid extends MoEngagePersonalizePlatform {
  final String _tag = '${moduleTag}MoEngagePersonalizeAndroid';
  final MethodChannel _channel = const MethodChannel(channelName);

  /// Registers this class as the default instance of [MoEngagePersonalizePlatform].
  static void registerWith() {
    Logger.v('${moduleTag}MoEngagePersonalizeAndroid registerWith(): Registering MoEngagePersonalizeAndroid with Platform Interface');
    MoEngagePersonalizePlatform.instance = MoEngagePersonalizeAndroid();
  }

  @override
  Future<ExperienceCampaignsMetadata> fetchExperiencesMeta(
      List<ExperienceStatus> statuses, String appId) async {
    try {
      final Map<String, dynamic> payload =
          getFetchExperiencesMetaPayload(statuses, appId);
      Logger.v('$_tag fetchExperiencesMeta(): $payload');
      final response = await _channel.invokeMethod(
          methodFetchExperiencesMeta, json.encode(payload));
      return deserializeExperiencesMeta(response);
    } catch (e, stackTrace) {
      Logger.e('$_tag fetchExperiencesMeta(): Error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<ExperienceCampaignsResult> fetchExperiences(
      List<String> experienceKeys,
      Map<String, String> attributes,
      String appId) async {
    try {
      final Map<String, dynamic> payload =
          getFetchExperiencesPayload(experienceKeys, attributes, appId);
      Logger.v('$_tag fetchExperiences(): $payload');
      final response = await _channel.invokeMethod(
          methodFetchExperiences, json.encode(payload));
      return deserializeExperiencesResult(response);
    } catch (e, stackTrace) {
      Logger.e('$_tag fetchExperiences(): Error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  void experiencesShown(List<ExperienceCampaign> campaigns, String appId) {
    final Map<String, dynamic> payload =
        getTrackExperienceShownPayload(campaigns, appId);
    Logger.v('$_tag experiencesShown(): $payload');
    unawaited(
        _channel.invokeMethod(methodExperiencesShown, json.encode(payload)));
  }

  @override
  void experienceClicked(ExperienceCampaign campaign, String appId) {
    final Map<String, dynamic> payload =
        getTrackExperienceClickedPayload(campaign, appId);
    _channel.invokeMethod(methodExperienceClicked, json.encode(payload));
  }

  @override
  void offeringsShown(
      List<Map<String, dynamic>> offeringPayloads, String appId) {
    final Map<String, dynamic> payload =
        getTrackOfferingShownPayload(offeringPayloads, appId);
    _channel.invokeMethod(methodOfferingsShown, json.encode(payload));
  }

  @override
  void offeringClicked(
    ExperienceCampaign campaign,
    Map<String, dynamic> offeringPayload,
    String appId,
  ) {
    final Map<String, dynamic> payload =
        getTrackOfferingClickedPayload(campaign, offeringPayload, appId);
    _channel.invokeMethod(methodOfferingClicked, json.encode(payload));
  }
}
