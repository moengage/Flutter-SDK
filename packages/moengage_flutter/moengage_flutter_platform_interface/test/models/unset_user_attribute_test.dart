import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

const String _appId = 'test_app_id';

void main() {
  group('UserAttributeLevel', () {
    test('fromString maps every contract value', () {
      expect(UserAttributeLevel.fromString('project'), UserAttributeLevel.project);
      expect(UserAttributeLevel.fromString('portfolio'), UserAttributeLevel.portfolio);
    });

    test('fromString defaults to project for an unmodelled value', () {
      expect(UserAttributeLevel.fromString('unknown'), UserAttributeLevel.project);
    });
  });

  group('getUnsetUserAttributePayload', () {
    test('builds the hybridToNative contract shape', () {
      final payload = getUnsetUserAttributePayload(
          'loyalty_tier', UserAttributeLevel.portfolio, _appId);

      expect(payload['accountMeta'], {'appId': _appId});
      expect(payload['data'], {
        'attributeName': 'loyalty_tier',
        'attributeLevel': 'portfolio',
      });
    });
  });

  group('unsetUserAttributeResultFromJson', () {
    test('deserializes a successful response', () {
      final response = json.encode({
        'accountMeta': {'appId': _appId},
        'data': {
          'isUnsetSuccess': true,
          'attributeName': 'loyalty_tier',
          'attributeLevel': 'portfolio',
        },
      });

      final result = unsetUserAttributeResultFromJson(response);

      expect(result.attributeName, 'loyalty_tier');
      expect(result.attributeLevel, UserAttributeLevel.portfolio);
    });

    test('throws UnsetUserAttributeFailure for a response with isUnsetSuccess false', () {
      final response = json.encode({
        'accountMeta': {'appId': _appId},
        'data': {
          'isUnsetSuccess': false,
          'attributeName': 'loyalty_tier',
          'attributeLevel': 'portfolio',
          'failure': {
            'reason': 'INVALID_INITIALISATION_CONFIGURATION',
            'message': 'Portfolio level requires a configured project id.',
          },
        },
      });

      expect(
        () => unsetUserAttributeResultFromJson(response),
        throwsA(isA<UnsetUserAttributeFailure>()
            .having((f) => f.failureReason, 'failureReason',
                CommonFailureReason.invalidInitialisationConfiguration)
            .having((f) => f.message, 'message',
                'Portfolio level requires a configured project id.')),
      );
    });

    test('falls back to unknownError for an unrecognised embedded failure reason', () {
      final response = json.encode({
        'accountMeta': {'appId': _appId},
        'data': {
          'isUnsetSuccess': false,
          'attributeName': 'trial_status',
          'attributeLevel': 'project',
          'failure': {'reason': 'SOME_NEW_REASON', 'message': ''},
        },
      });

      expect(
        () => unsetUserAttributeResultFromJson(response),
        throwsA(isA<UnsetUserAttributeFailure>().having(
            (f) => f.failureReason, 'failureReason', CommonFailureReason.unknownError)),
      );
    });
  });

  group('toUnsetUserAttributeFailure', () {
    test('passes an existing UnsetUserAttributeFailure through unchanged', () {
      final failure = UnsetUserAttributeFailure(
          failureReason: CommonFailureReason.invalidParameters, message: 'blank name');

      expect(toUnsetUserAttributeFailure(failure), same(failure));
    });

    test('maps a PlatformException code to its CommonFailureReason', () {
      final failure = toUnsetUserAttributeFailure(
          PlatformException(code: 'INVALID_INITIALISATION_CONFIGURATION', message: 'no project id'));

      expect(failure.failureReason, CommonFailureReason.invalidInitialisationConfiguration);
      expect(failure.message, 'no project id');
    });

    test('falls back to unknownError for an unrecognised PlatformException code', () {
      final failure =
          toUnsetUserAttributeFailure(PlatformException(code: 'SOME_NEW_REASON', message: 'm'));

      expect(failure.failureReason, CommonFailureReason.unknownError);
    });

    test('falls back to unknownError for a non-PlatformException error', () {
      final failure = toUnsetUserAttributeFailure(Exception('boom'));

      expect(failure.failureReason, CommonFailureReason.unknownError);
      expect(failure.message, contains('boom'));
    });
  });
}
