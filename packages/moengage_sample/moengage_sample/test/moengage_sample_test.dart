import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_sample/moengage_sample.dart';

class _FakeMoEngageSamplePlatform extends MoEngageSamplePlatform {
  @override
  Future<String> greet(String appId) async => 'Hello, appId: $appId';
}

void main() {
  test('greet() delegates to MoEngageSamplePlatform.instance', () async {
    final fakePlatform = _FakeMoEngageSamplePlatform();
    MoEngageSamplePlatform.instance = fakePlatform;

    final sample = MoEngageSample('test-app-id');
    final greeting = await sample.greet();

    expect(greeting, equals('Hello, appId: test-app-id'));
  });
}
