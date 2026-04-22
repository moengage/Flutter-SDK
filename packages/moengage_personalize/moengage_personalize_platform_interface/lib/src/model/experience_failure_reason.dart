import 'package:moengage_flutter/moengage_flutter.dart' show Logger;

import '../internal/constants.dart';

/// Known failure reasons for an experience campaign.
enum ExperienceFailureReason {
  /// User does not match the segment criteria.
  userNotInSegment('USER_NOT_IN_SEGMENT'),

  /// The supplied experience key is not valid.
  invalidExperienceKey('INVALID_EXPERIENCE_KEY'),

  /// A generic personalization failure occurred.
  personalizationFailed('PERSONALIZATION_FAILED');

  const ExperienceFailureReason(this.value);

  /// JSON string representation of this reason.
  final String value;

  /// Get [ExperienceFailureReason] from a JSON string value.
  ///
  /// Falls back to [ExperienceFailureReason.personalizationFailed] for unknown values.
  static ExperienceFailureReason fromString(String str) =>
      ExperienceFailureReason.values.firstWhere(
        (r) => r.value == str,
        orElse: () {
          Logger.w(
              '${moduleTag}ExperienceFailureReason fromString(): Unknown value "$str", defaulting to personalizationFailed');
          return ExperienceFailureReason.personalizationFailed;
        },
      );
}
