import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

void main() {
  group('AuthenticationData', () {
    test('should create AuthenticationData with token and userIdentifier',
        () {
      final data =
          AuthenticationData(token: 'jwt-token', userIdentifier: 'user1234');
      expect(data.token, equals('jwt-token'));
      expect(data.userIdentifier, equals('user1234'));
    });

    test('toString returns the expected string representation', () {
      final data =
          AuthenticationData(token: 'jwt-token', userIdentifier: 'user1234');
      expect(
        data.toString(),
        equals('{token: jwt-token\nuserIdentifier: user1234}'),
      );
    });
  });
}
