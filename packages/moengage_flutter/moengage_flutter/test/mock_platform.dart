import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';
import 'package:moengage_flutter_platform_interface/src/internal/method_channel_moengage_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Mock Platform Interface.
class MockMoEngageFlutterPlatform extends MethodChannelMoEngageFlutter
    with MockPlatformInterfaceMixin {
  String? setUserAttributeLastUserAttributeName;
  dynamic setUserAttributeLastUserAttributeValue;
  String? setUserAttributeLastAppId;

  AuthenticationDetailsRequest? passAuthenticationDetailsLastData;
  String? passAuthenticationDetailsLastAppId;

  @override
  void setUserAttribute(
      String userAttributeName, userAttributeValue, String appId) {
    setUserAttributeLastUserAttributeName = userAttributeName;
    setUserAttributeLastUserAttributeValue = userAttributeValue;
    setUserAttributeLastAppId = appId;
  }

  @override
  void passAuthenticationDetails(
      AuthenticationDetailsRequest request, String appId) {
    passAuthenticationDetailsLastData = request;
    passAuthenticationDetailsLastAppId = appId;
  }

  void clear() {
    setUserAttributeLastUserAttributeName = null;
    setUserAttributeLastUserAttributeValue = null;
    setUserAttributeLastAppId = null;
    passAuthenticationDetailsLastData = null;
    passAuthenticationDetailsLastAppId = null;
  }
}
