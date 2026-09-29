import 'package:flutter_test/flutter_test.dart';
import 'package:moengage_flutter/moengage_flutter.dart';

import 'data_provider/data_provider.dart';
import 'mock_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final MockMoEngageFlutterPlatform mock = MockMoEngageFlutterPlatform();
  MoEngageFlutterPlatform.instance = mock;

  tearDown(() => {mock.clear()});

  test('User Attributes set', () async {
    final platform = MoEngageFlutter('12345');
    for (final entry in setUserAttributesData.entries) {
      platform.setUserAttribute(entry.key, entry.value);
      expect(mock.setUserAttributeLastUserAttributeName, entry.key);
      expect(mock.setUserAttributeLastUserAttributeValue, entry.value);
    }
  });

  test('User Attributes not set', () async {
    final platform = MoEngageFlutter('12345');
    for (final entry in unsetUserAttributesData.entries) {
      platform.setUserAttribute(entry.key, entry.value);
      expect(mock.setUserAttributeLastUserAttributeName, null);
      expect(mock.setUserAttributeLastUserAttributeValue, null);
    }
  });

  test('JWT Authentication details passed to platform', () async {
    final platform = MoEngageFlutter('12345');
    final AuthenticationDetailsRequest request = AuthenticationDetailsRequest(
        authenticationType: AuthenticationType.jwt,
        data: JwtAuthenticationData(
            token: 'jwt-token', userIdentifier: 'user1234'));
    platform.passAuthenticationDetails(request);
    expect(mock.passAuthenticationDetailsLastData, request);
    expect(mock.passAuthenticationDetailsLastAppId, '12345');
  });

  test('Firebase Installation Id passed to platform', () async {
    final platform = MoEngageFlutter('12345');
    platform.passFirebaseInstallationId('fid-1234');
    expect(mock.passFirebaseInstallationIdLastInstallationId, 'fid-1234');
    expect(mock.passFirebaseInstallationIdLastAppId, '12345');
  });

  test('Firebase Installation Id fetched from platform', () async {
    final platform = MoEngageFlutter('12345');
    final FirebaseInstallationIdData data = FirebaseInstallationIdData(
        accountMeta: AccountMeta('12345'),
        installationId: 'fid-1234',
        platform: Platforms.android,
        pushService: MoEPushService.fcm);
    mock.getFirebaseInstallationIdResult = data;
    final FirebaseInstallationIdData? result =
        await platform.getFirebaseInstallationId();
    expect(result?.installationId, 'fid-1234');
    expect(mock.getFirebaseInstallationIdLastAppId, '12345');
  });
}
