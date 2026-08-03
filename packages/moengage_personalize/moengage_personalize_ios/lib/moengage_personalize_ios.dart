import 'package:moengage_flutter/moengage_flutter.dart' show Logger;
import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

/// iOS implementation of [MoEngagePersonalizePlatform].
///
/// Extends [MethodChannelMoEngagePersonalize] to inherit all method channel
/// logic, avoiding duplication between the platform interface and iOS layers.
class MoEngagePersonalizeIOS extends MethodChannelMoEngagePersonalize {
  /// Registers this class as the default instance of [MoEngagePersonalizePlatform].
  static void registerWith() {
    Logger.v('Registering MoEngagePersonalizeIOS with Platform Interface');
    MoEngagePersonalizePlatform.instance = MoEngagePersonalizeIOS();
  }
}
