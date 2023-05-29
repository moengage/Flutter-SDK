import 'package:moengage_cards/src/internal/cards_controller_android.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Mock Platform Interface.
class MockCardsPlatform extends MoEAndroidCardsController
    with MockPlatformInterfaceMixin {}
