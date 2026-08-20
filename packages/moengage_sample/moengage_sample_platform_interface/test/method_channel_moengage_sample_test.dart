import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_sample_platform_interface/moengage_sample_platform_interface.dart';
import 'package:moengage_sample_platform_interface/src/method_channel_moengage_sample.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel(channelName);
  final platform = MethodChannelMoEngageSample();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == methodNameGreet) {
        return 'Hello from mock native, appId: '
            '${(methodCall.arguments as Map)['accountMeta']['appId']}';
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('greet() invokes the method channel and returns the native result',
      () async {
    final result = await platform.greet('test-app-id');
    expect(result, contains('test-app-id'));
  });
}
