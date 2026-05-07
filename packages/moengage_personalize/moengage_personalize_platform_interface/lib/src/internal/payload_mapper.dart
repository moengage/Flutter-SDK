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
    keyStatus: statuses.map((s) => s.value).toList(),
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
  if (campaign.payload.isEmpty) {
    Logger.w('${moduleTag}campaignToMap(): payload is empty for "${campaign.experienceKey}"');
  }
  if (campaign.experienceContext.isEmpty) {
    Logger.w('${moduleTag}campaignToMap(): experienceContext is empty for "${campaign.experienceKey}"');
  }
  return {
    keyExperienceKey: campaign.experienceKey,
    keyPayload: campaign.payload,
    keyExperienceContext: campaign.experienceContext,
    keySource: campaign.source.value
  };
}

/// Build payload for experiencesShown.
Map<String, dynamic> getTrackExperienceShownPayload(
    List<ExperienceCampaign> campaigns, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = {
    keyExperiences: campaigns.map(campaignToMap).toList(),
  };
  return payload;
}

/// Build payload for experienceClicked.
Map<String, dynamic> getTrackExperienceClickedPayload(
    ExperienceCampaign campaign, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = {
    keyExperience: campaignToMap(campaign),
  };
  return payload;
}

/// Build payload for offeringsShown.
Map<String, dynamic> getTrackOfferingShownPayload(
    List<Map<String, dynamic>> offeringPayloads, String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = {
    keyOfferingPayloads: offeringPayloads,
  };
  return payload;
}

/// Build payload for offeringClicked.
Map<String, dynamic> getTrackOfferingClickedPayload(
    ExperienceCampaign campaign,
    Map<String, dynamic> offeringPayload,
    String appId) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = {
    keyExperience: campaignToMap(campaign),
    keyOfferingPayload: offeringPayload,
  };
  return payload;
}

// --- Deserialization (JSON from native → Dart models) ---

/// Deserialize fetchExperiencesMeta response.
ExperienceCampaignsMetadata deserializeExperiencesMeta(
    dynamic responsePayload) {
  Logger.v('${moduleTag}deserializeExperiencesMeta(): $responsePayload');
  final Map<String, dynamic> response =
      json.decode(responsePayload.toString()) as Map<String, dynamic>;
  _checkForError(response);

  final dataPayload = response[keyData];
  if (dataPayload is! Map<String, dynamic>) {
    Logger.w('${moduleTag}deserializeExperiencesMeta(): missing or invalid data key');
    return ExperienceCampaignsMetadata(
        source: DataSource.network, experiences: []);
  }

  final source =
      DataSource.fromString(dataPayload[keySource]?.toString() ?? '');
  final experiencesList = dataPayload[keyExperiences] as List? ?? [];

  final experiences = experiencesList.map((exp) {
    final map = exp as Map<String, dynamic>;
    return ExperienceCampaignMeta(
      experienceKey: map[keyExperienceKey]?.toString() ?? '',
      experienceName: map[keyExperienceName]?.toString() ?? '',
      status: ExperienceStatus.fromString(map[keyStatus]?.toString() ?? ''),
    );
  }).toList();

  return ExperienceCampaignsMetadata(source: source, experiences: experiences);
}

/// Deserialize fetchExperiences response.
ExperienceCampaignsResult deserializeExperiencesResult(
    dynamic responsePayload) {
  Logger.v('${moduleTag}deserializeExperiencesResult(): $responsePayload');
  final Map<String, dynamic> response =
      json.decode(responsePayload.toString()) as Map<String, dynamic>;
  _checkForError(response);

  final dataPayload = response[keyData];
  if (dataPayload is! Map<String, dynamic>) {
    Logger.w('${moduleTag}deserializeExperiencesResult(): missing or invalid data key');
    return ExperienceCampaignsResult(experiences: [], failures: []);
  }

  final experiencesList = dataPayload[keyExperiences] as List? ?? [];
  final experiences = experiencesList.map((exp) {
    final map = exp as Map<String, dynamic>;
    return ExperienceCampaign(
      experienceKey: map[keyExperienceKey]?.toString() ?? '',
      payload: map[keyPayload] as Map<String, dynamic>? ?? {},
      experienceContext:
          (map[keyExperienceContext] as Map?)?.cast<String, String>() ?? {},
      source: DataSource.fromString(map[keySource]?.toString() ?? ''),
    );
  }).toList();

  final failuresList = dataPayload[keyFailures] as List? ?? [];
  final failures = failuresList.map((f) {
    final map = f as Map<String, dynamic>;
    return ExperienceCampaignFailure(
      reason: ExperienceFailureReason.fromString(
          map[keyReason]?.toString() ?? ''),
      experienceKeys: (map[keyExperienceKeys] as List?)
              ?.map((k) => k.toString())
              .toList() ??
          [],
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
