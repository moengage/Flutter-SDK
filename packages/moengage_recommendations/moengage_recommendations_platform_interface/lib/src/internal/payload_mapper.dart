import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart'
    show CommonFailureReason, Logger, getAccountMeta, keyData;

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
/// Throws a [RecommendationsFailure] carrying [CommonFailureReason.parseError] when the
/// response body cannot be read, or the decoded body is missing its `data` block — the contract
/// lists `parseError` against this method, so a malformed body must not reach the caller
/// disguised as a successful empty result.
RecommendedItems deserializeRecommendedItems(dynamic responsePayload) {
  Logger.v('${moduleTag}deserializeRecommendedItems(): $responsePayload');
  final Map<String, dynamic> response;
  try {
    response = json.decode(responsePayload.toString()) as Map<String, dynamic>;
  } catch (e, stackTrace) {
    Logger.e('${moduleTag}deserializeRecommendedItems(): Error: $e',
        stackTrace: stackTrace);
    throw RecommendationsFailure(
      failureReason: CommonFailureReason.parseError,
      message: e.toString(),
    );
  }

  final dataPayload = response[keyData];
  if (dataPayload is! Map<String, dynamic>) {
    const message = 'missing or invalid data key';
    Logger.e('${moduleTag}deserializeRecommendedItems(): $message');
    throw RecommendationsFailure(
      failureReason: CommonFailureReason.parseError,
      message: message,
    );
  }

  return RecommendedItems.fromJson(dataPayload);
}

/// Convert an error raised while fetching into a [RecommendationsFailure].
///
/// A [RecommendationsFailure] passes through unchanged — [deserializeRecommendedItems] has already
/// classified it. The native bridge reports the failure reason as the [PlatformException.code], so
/// the reason is read from there. Anything else is surfaced as [CommonFailureReason.unknownError]
/// rather than leaking a platform type to the caller.
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
    failureReason: CommonFailureReason.unknownError,
    message: error.toString(),
  );
}
