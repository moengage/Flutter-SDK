import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

/// A standalone implementer, distinct from [CommonFailureReason] - proves
/// [MoERequestFailureReason] is a genuine reusable contract that any feature module can
/// implement, not just an implementation detail of [CommonFailureReason].
class _TestFailureReason implements MoERequestFailureReason {
  const _TestFailureReason(this.value);

  @override
  final String value;
}

void main() {
  group('MoERequestFailureReason', () {
    test('CommonFailureReason satisfies the interface', () {
      expect(CommonFailureReason.networkError, isA<MoERequestFailureReason>());
    });

    test('an independent type can implement the interface', () {
      const MoERequestFailureReason reason =
          _TestFailureReason('CUSTOM_REASON');
      expect(reason, isA<MoERequestFailureReason>());
      expect(reason.value, 'CUSTOM_REASON');
    });

    test('value is accessible polymorphically regardless of the concrete type',
        () {
      final List<MoERequestFailureReason> reasons = [
        CommonFailureReason.sdkState,
        CommonFailureReason.networkError,
        const _TestFailureReason('CUSTOM_REASON'),
      ];

      expect(reasons.map((r) => r.value),
          ['SDK_STATE', 'NETWORK_ERROR', 'CUSTOM_REASON']);
    });
  });
}
