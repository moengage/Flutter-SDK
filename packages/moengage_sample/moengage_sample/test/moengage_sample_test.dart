import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_sample/moengage_sample.dart';

void main() {
  test('greet() returns a message containing the appId', () {
    final sample = MoEngageSample('test-app-id');
    expect(sample.greet(), contains('test-app-id'));
  });
}
