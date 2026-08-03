import 'package:moengage_flutter/moengage_flutter.dart' show Logger;

import '../internal/constants.dart';

/// Known failure reasons for an experience campaign.
enum ExperienceFailureReason {
  /// User is in the campaign-level control group.
  userInCampaignControlGroup('USER_IN_CAMPAIGN_CONTROL_GROUP'),

  /// User is in the global control group.
  userInGlobalControlGroup('USER_IN_GLOBAL_CONTROL_GROUP'),

  /// User does not match the segment criteria.
  userNotInSegment('USER_NOT_IN_SEGMENT'),

  /// The supplied experience key is not valid.
  invalidExperienceKey('INVALID_EXPERIENCE_KEY'),

  /// The maximum fetch limit has been breached.
  maxLimitBreached('MAX_LIMIT_BREACHED'),

  /// The experience is not currently active.
  experienceNotActive('EXPERIENCE_NOT_ACTIVE'),

  /// The experience has expired.
  experienceExpired('EXPERIENCE_EXPIRED'),

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
