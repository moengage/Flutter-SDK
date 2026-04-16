import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

void main() {
  group('DataSource', () {
    test('fromString returns correct enum for valid strings', () {
      expect(DataSource.fromString('CACHE'), DataSource.cache);
      expect(DataSource.fromString('NETWORK'), DataSource.network);
    });

    test('fromString returns network as default for unknown string', () {
      expect(DataSource.fromString('unknown'), DataSource.network);
      expect(DataSource.fromString(''), DataSource.network);
    });

    test('value returns correct string for each member', () {
      expect(DataSource.cache.value, 'CACHE');
      expect(DataSource.network.value, 'NETWORK');
    });
  });
}
