import 'dart:convert';

import 'package:moengage_flutter/moengage_flutter.dart'
    show Logger, getAccountMeta, keyData;

import '../model/models.dart';
import 'constants.dart';

// --- Serialization (Dart → JSON payload for native) ---

/// Build payload for fetchExperiencesMeta.
Map<String, dynamic> getFetchExperiencesMetaPayload(
    List<ExperienceStatus> statuses, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = {
    keyStatus: statuses.map((s) => s.asString).toList(),
  };
  return payload;
}

/// Build payload for fetchExperiences.
Map<String, dynamic> getFetchExperiencesPayload(
    List<String> experienceKeys,
    Map<String, String> attributes,
    String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = {
    keyExperienceKeys: experienceKeys,
    keyAttributes: attributes,
  };
  return payload;
}

/// Serialize an [ExperienceCampaign] to a JSON map.
Map<String, dynamic> campaignToMap(ExperienceCampaign campaign) {
  return {
    keyExperienceKey: campaign.experienceKey,
    keyPayload: campaign.payload,
    keyExperienceContext: campaign.experienceContext,
  };
}

/// Build payload for trackExperienceShown.
Map<String, dynamic> getTrackExperienceShownPayload(
    List<ExperienceCampaign> campaigns, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = {
    keyExperiences: campaigns.map(campaignToMap).toList(),
  };
  return payload;
}

/// Build payload for trackExperienceClicked.
Map<String, dynamic> getTrackExperienceClickedPayload(
    ExperienceCampaign campaign, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = {
    keyExperience: campaignToMap(campaign),
  };
  return payload;
}

/// Build payload for trackOfferingShown.
Map<String, dynamic> getTrackOfferingShownPayload(
    List<Map<String, dynamic>> offeringAttributes, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = {
    keyOfferingAttributes: offeringAttributes,
  };
  return payload;
}

/// Build payload for trackOfferingClicked.
Map<String, dynamic> getTrackOfferingClickedPayload(
    ExperienceCampaign campaign,
    Map<String, dynamic> offeringAttributes,
    String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = {
    keyExperience: campaignToMap(campaign),
    keyOfferingAttributes: offeringAttributes,
  };
  return payload;
}

// --- Deserialization (JSON from native → Dart models) ---

/// Deserialize fetchExperiencesMeta response.
ExperienceCampaignsMetadata deserializeExperiencesMeta(
    dynamic responsePayload) {
  final Map<String, dynamic> response =
      json.decode(responsePayload.toString()) as Map<String, dynamic>;
  _checkForError(response);

  final Map<String, dynamic> dataPayload =
      response[keyData] as Map<String, dynamic>;
  final source =
      DataSourceExt.fromString(dataPayload[keySource]?.toString() ?? '');
  final experiencesList = dataPayload[keyExperiences] as List? ?? [];

  final experiences = experiencesList.map((exp) {
    final map = exp as Map<String, dynamic>;
    return ExperienceCampaignMeta(
      experienceKey: map[keyExperienceKey]?.toString() ?? '',
      experienceName: map[keyExperienceName]?.toString() ?? '',
      status:
          ExperienceStatusExt.fromString(map[keyStatus]?.toString() ?? ''),
    );
  }).toList();

  return ExperienceCampaignsMetadata(source: source, experiences: experiences);
}

/// Deserialize fetchExperiences response.
ExperienceCampaignsResult deserializeExperiencesResult(
    dynamic responsePayload) {
  final Map<String, dynamic> response =
      json.decode(responsePayload.toString()) as Map<String, dynamic>;
  _checkForError(response);

  final Map<String, dynamic> dataPayload =
      response[keyData] as Map<String, dynamic>;

  final experiencesList = dataPayload[keyExperiences] as List? ?? [];
  final experiences = experiencesList.map((exp) {
    final map = exp as Map<String, dynamic>;
    return ExperienceCampaign(
      experienceKey: map[keyExperienceKey]?.toString() ?? '',
      payload: map[keyPayload] as Map<String, dynamic>? ?? {},
      experienceContext:
          map[keyExperienceContext] as Map<String, dynamic>? ?? {},
      source:
          DataSourceExt.fromString(map[keySource]?.toString() ?? ''),
    );
  }).toList();

  final failuresList = dataPayload[keyFailures] as List? ?? [];
  final failures = failuresList.map((f) {
    final map = f as Map<String, dynamic>;
    return ExperienceCampaignFailure(
      reason: map[keyReason]?.toString() ?? '',
      experienceKeys: (map[keyExperienceKeys] as List?)
              ?.map((k) => k.toString())
              .toList() ??
          [],
      message: map[keyMessage]?.toString(),
    );
  }).toList();

  return ExperienceCampaignsResult(
      experiences: experiences, failures: failures);
}

/// Check if response contains an error and throw [PersonalizeError] if so.
void _checkForError(Map<String, dynamic> response) {
  if (response.containsKey(keyError)) {
    final errorMap = response[keyError] as Map<String, dynamic>;
    throw PersonalizeError(
      code: errorMap[keyCode]?.toString() ?? 'UNKNOWN',
      message: errorMap[keyMessage]?.toString() ?? '',
    );
  }
}
