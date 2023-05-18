import 'package:flutter_test/flutter_test.dart';
import 'package:cards/cards_platform.dart';
import 'package:cards/moengage_cards.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCardsPlatform
    with MockPlatformInterfaceMixin
    implements MoEngageCardsPlatform {

}

void main() {
  final MoEngageCardsPlatform initialPlatform = MoEngageCardsPlatform.instance;

  test('$MoEngageCards is the default instance', () {
    expect(initialPlatform, isInstanceOf<MoEngageCards>());
  });
}
