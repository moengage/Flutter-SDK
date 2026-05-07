import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_personalize_ios/moengage_personalize_ios.dart';
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('registerWith sets MoEngagePersonalizeIOS as platform instance', () {
    MoEngagePersonalizeIOS.registerWith();
    expect(
      MoEngagePersonalizePlatform.instance,
      isA<MoEngagePersonalizeIOS>(),
    );
  });
}
