import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart'
    show Logger, getAccountMeta, keyData;

import '../model/models.dart';
import 'constants.dart';

/// Build payload for fetchRecommendations.
///
/// [includedFields] is a set in the contract, so duplicates are dropped before the payload is
/// built. `itemId` and `includedFields` are optional — the native layer ignores them when blank
/// or empty, as does the server.
Map<String, dynamic> getFetchRecommendationsPayload(
  String recommendationId,
  String itemId,
  Set<String> includedFields,
  String appId,
) {
  final Map<String, dynamic> payload = getAccountMeta(appId);
  payload[keyData] = {
    keyRecommendationId: recommendationId,
    keyItemId: itemId,
    keyIncludedFields: includedFields.toList(),
  };
  return payload;
}

/// Deserialize the fetchRecommendations response.
///
/// Throws a [RecommendationsFailure] carrying [RecommendationsFailureReason.parseError] when the
/// response body cannot be read — the contract lists `parseError` against this method, so an
/// undecodable body must not reach the caller as `unknownError`.
RecommendedItems deserializeRecommendedItems(dynamic responsePayload) {
  Logger.v('${moduleTag}deserializeRecommendedItems(): $responsePayload');
  try {
    final Map<String, dynamic> response =
        json.decode(responsePayload.toString()) as Map<String, dynamic>;

    final dataPayload = response[keyData];
    if (dataPayload is! Map<String, dynamic>) {
      Logger.w(
          '${moduleTag}deserializeRecommendedItems(): missing or invalid data key');
      return RecommendedItems(items: []);
    }

    return RecommendedItems.fromJson(dataPayload);
  } catch (e, stackTrace) {
    Logger.e('${moduleTag}deserializeRecommendedItems(): Error: $e',
        stackTrace: stackTrace);
    throw RecommendationsFailure(
      failureReason: RecommendationsFailureReason.parseError,
      message: e.toString(),
    );
  }
}

/// Convert an error raised while fetching into a [RecommendationsFailure].
///
/// A [RecommendationsFailure] passes through unchanged — [deserializeRecommendedItems] has already
/// classified it. The native bridge reports the failure reason as the [PlatformException.code], so
/// the reason is read from there. Anything else is surfaced as
/// [RecommendationsFailureReason.unknownError] rather than leaking a platform type to the caller.
RecommendationsFailure toRecommendationsFailure(Object error) {
  if (error is RecommendationsFailure) {
    return error;
  }
  if (error is PlatformException) {
    return RecommendationsFailure(
      failureReason: RecommendationsFailureReason.fromString(error.code),
      message: error.message ?? '',
    );
  }
  return RecommendationsFailure(
    failureReason: RecommendationsFailureReason.unknownError,
    message: error.toString(),
  );
}
