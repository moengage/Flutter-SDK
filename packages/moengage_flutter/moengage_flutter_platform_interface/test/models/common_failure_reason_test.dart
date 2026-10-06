import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

void main() {
  group('CommonFailureReason', () {
    test('implements MoERequestFailureReason', () {
      expect(CommonFailureReason.networkError, isA<MoERequestFailureReason>());
    });

    test('tryFromString maps every contract value', () {
      expect(CommonFailureReason.tryFromString('FEATURE_DISABLED'),
          CommonFailureReason.featureDisabled);
      expect(CommonFailureReason.tryFromString('SDK_STATE'),
          CommonFailureReason.sdkState);
      expect(CommonFailureReason.tryFromString('SERVER_ERROR'),
          CommonFailureReason.serverError);
      expect(CommonFailureReason.tryFromString('NETWORK_ERROR'),
          CommonFailureReason.networkError);
      expect(CommonFailureReason.tryFromString('PARSE_ERROR'),
          CommonFailureReason.parseError);
      expect(CommonFailureReason.tryFromString('INVALID_PARAMETERS'),
          CommonFailureReason.invalidParameters);
      expect(
          CommonFailureReason.tryFromString(
              'INVALID_INITIALISATION_CONFIGURATION'),
          CommonFailureReason.invalidInitialisationConfiguration);
      expect(CommonFailureReason.tryFromString('DUPLICATE_FUNCTION_CALL'),
          CommonFailureReason.duplicateFunctionCall);
      expect(CommonFailureReason.tryFromString('AUTHENTICATION_FAILED'),
          CommonFailureReason.authenticationFailed);
      expect(CommonFailureReason.tryFromString('UNKNOWN_ERROR'),
          CommonFailureReason.unknownError);
    });

    test('tryFromString returns null for an unmodelled value', () {
      expect(CommonFailureReason.tryFromString('INVALID_REQUEST'), isNull);
    });

    test('fromString falls back to unknownError for an unmodelled value', () {
      expect(CommonFailureReason.fromString('SOME_NEW_REASON'),
          CommonFailureReason.unknownError);
    });

    test('fromString returns the matching reason for a modelled value', () {
      expect(CommonFailureReason.fromString('NETWORK_ERROR'),
          CommonFailureReason.networkError);
    });
  });
}
