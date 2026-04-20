import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show Logger;
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

/// The Android implementation of [MoEngagePersonalizePlatform].
class MoEngagePersonalizeAndroid extends MoEngagePersonalizePlatform {
  final MethodChannel _channel = const MethodChannel(CHANNEL_NAME);

  /// Registers this class as the default instance of [MoEngagePersonalizePlatform].
  static void registerWith() {
    Logger.v('Registering MoEngagePersonalizeAndroid with Platform Interface');
    MoEngagePersonalizePlatform.instance = MoEngagePersonalizeAndroid();
  }

  @override
  Future<ExperienceCampaignsMetadata> fetchExperiencesMeta(
      List<ExperienceStatus> statuses, String appId) async {
    try {
      final Map<String, dynamic> payload =
          getFetchExperiencesMetaPayload(statuses, appId);
      final response = await _channel.invokeMethod(
          METHOD_NAME_FETCH_EXPERIENCES_META, json.encode(payload));
      return deserializeExperiencesMeta(response);
    } catch (e, stackTrace) {
      Logger.e('fetchExperiencesMeta(): Error: $e', stackTrace: stackTrace);
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
      final response = await _channel.invokeMethod(
          METHOD_NAME_FETCH_EXPERIENCES, json.encode(payload));
      return deserializeExperiencesResult(response);
    } catch (e, stackTrace) {
      Logger.e('fetchExperiences(): Error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  void trackExperienceShown(
      List<ExperienceCampaign> campaigns, String appId) {
    final Map<String, dynamic> payload =
        getTrackExperienceShownPayload(campaigns, appId);
    unawaited(
        _channel.invokeMethod(METHOD_NAME_TRACK_EXPERIENCE_SHOWN, json.encode(payload)));
  }

  @override
  void trackExperienceClicked(ExperienceCampaign campaign, String appId) {
    final Map<String, dynamic> payload =
        getTrackExperienceClickedPayload(campaign, appId);
        _channel.invokeMethod(METHOD_NAME_TRACK_EXPERIENCE_CLICKED, json.encode(payload));
  }

  @override
  void trackOfferingShown(
      List<Map<String, dynamic>> offeringAttributes, String appId) {
    final Map<String, dynamic> payload =
        getTrackOfferingShownPayload(offeringAttributes, appId);
    _channel.invokeMethod(METHOD_NAME_TRACK_OFFERING_SHOWN, json.encode(payload));
  }

  @override
  void trackOfferingClicked(
    ExperienceCampaign campaign,
    Map<String, dynamic> offeringAttributes,
    String appId,
  ) {
    final Map<String, dynamic> payload =
        getTrackOfferingClickedPayload(campaign, offeringAttributes, appId);
    _channel.invokeMethod(METHOD_NAME_TRACK_OFFERING_CLICKED, json.encode(payload));
  }
}
