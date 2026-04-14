import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show Logger;

import 'internal/constants.dart';
import 'internal/payload_mapper.dart';
import 'model/models.dart';
import 'moengage_personalize_platform_interface.dart';

/// An implementation of [MoEngagePersonalizePlatform] that uses method channels.
class MethodChannelMoEngagePersonalize extends MoEngagePersonalizePlatform {
  /// The method channel used to interact with the native platform.
  final MethodChannel _channel = const MethodChannel(CHANNEL_NAME);

  @override
  Future<ExperienceCampaignsMetadata> fetchExperiencesMeta(
      List<ExperienceStatus> statuses, String appId) async {
    try {
      final Map<String, dynamic> payload =
          getFetchExperiencesMetaPayload(statuses, appId);
      final response = await _channel.invokeMethod(
          METHOD_NAME_FETCH_EXPERIENCES_META, payload);
      return deserializeExperiencesMeta(response);
    } catch (e, stackTrace) {
      Logger.e('$TAG fetchExperiencesMeta(): $e', stackTrace: stackTrace);
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
          METHOD_NAME_FETCH_EXPERIENCES, payload);
      return deserializeExperiencesResult(response);
    } catch (e, stackTrace) {
      Logger.e('$TAG fetchExperiences(): $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  void trackExperienceShown(
      List<ExperienceCampaign> campaigns, String appId) {
    final Map<String, dynamic> payload =
        getTrackExperienceShownPayload(campaigns, appId);
    _channel.invokeMethod(METHOD_NAME_TRACK_EXPERIENCE_SHOWN, payload);
  }

  @override
  void trackExperienceClicked(ExperienceCampaign campaign, String appId) {
    final Map<String, dynamic> payload =
        getTrackExperienceClickedPayload(campaign, appId);
    _channel.invokeMethod(METHOD_NAME_TRACK_EXPERIENCE_CLICKED, payload);
  }

  @override
  void trackOfferingShown(
      List<Map<String, dynamic>> offeringAttributes, String appId) {
    final Map<String, dynamic> payload =
        getTrackOfferingShownPayload(offeringAttributes, appId);
    _channel.invokeMethod(METHOD_NAME_TRACK_OFFERING_SHOWN, payload);
  }

  @override
  void trackOfferingClicked(ExperienceCampaign campaign,
      Map<String, dynamic> offeringAttributes, String appId) {
    final Map<String, dynamic> payload =
        getTrackOfferingClickedPayload(campaign, offeringAttributes, appId);
    _channel.invokeMethod(METHOD_NAME_TRACK_OFFERING_CLICKED, payload);
  }
}
