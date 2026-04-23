import 'dart:async';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart' show Logger;

import 'internal/constants.dart';
import 'internal/payload_mapper.dart';
import 'model/models.dart';
import 'moengage_personalize_platform_interface.dart';

/// An implementation of [MoEngagePersonalizePlatform] that uses method channels.
class MethodChannelMoEngagePersonalize extends MoEngagePersonalizePlatform {
  /// The method channel used to interact with the native platform.
  final MethodChannel _channel = const MethodChannel(channelName);

  static const String _tag =
      '${moduleTag}MethodChannelMoEngagePersonalize';

  @override
  Future<ExperienceCampaignsMetadata> fetchExperiencesMeta(
      List<ExperienceStatus> statuses, String appId) async {
    try {
      final Map<String, dynamic> payload =
          getFetchExperiencesMetaPayload(statuses, appId);
      final response = await _channel.invokeMethod(
          methodFetchExperiencesMeta, payload);
      return deserializeExperiencesMeta(response);
    } catch (e, stackTrace) {
      Logger.e('$_tag fetchExperiencesMeta(): Error: $e',
          stackTrace: stackTrace);
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
          methodFetchExperiences, payload);
      return deserializeExperiencesResult(response);
    } catch (e, stackTrace) {
      Logger.e('$_tag fetchExperiences(): Error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  void experiencesShown(
      List<ExperienceCampaign> campaigns, String appId) {
    final Map<String, dynamic> payload =
        getTrackExperienceShownPayload(campaigns, appId);
    unawaited(_channel.invokeMethod(methodExperiencesShown, payload)
        .catchError((Object e, StackTrace st) {
      Logger.e('$_tag experiencesShown(): Error: $e', stackTrace: st);
    }));
  }

  @override
  void experienceClicked(ExperienceCampaign campaign, String appId) {
    final Map<String, dynamic> payload =
        getTrackExperienceClickedPayload(campaign, appId);
    unawaited(_channel.invokeMethod(methodExperienceClicked, payload)
        .catchError((Object e, StackTrace st) {
      Logger.e('$_tag experienceClicked(): Error: $e', stackTrace: st);
    }));
  }

  @override
  void offeringsShown(
      List<Map<String, dynamic>> offeringPayloads, String appId) {
    final Map<String, dynamic> payload =
        getTrackOfferingShownPayload(offeringPayloads, appId);
    unawaited(_channel.invokeMethod(methodOfferingsShown, payload)
        .catchError((Object e, StackTrace st) {
      Logger.e('$_tag offeringsShown(): Error: $e', stackTrace: st);
    }));
  }

  @override
  void offeringClicked(ExperienceCampaign campaign,
      Map<String, dynamic> offeringPayload, String appId) {
    final Map<String, dynamic> payload =
        getTrackOfferingClickedPayload(campaign, offeringPayload, appId);
    unawaited(_channel.invokeMethod(methodOfferingClicked, payload)
        .catchError((Object e, StackTrace st) {
      Logger.e('$_tag offeringClicked(): Error: $e', stackTrace: st);
    }));
  }
}
