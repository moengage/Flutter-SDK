import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'moengage_<featureName>_platform_interface.dart';
import 'src/internal/method_channel_moengage_<featureName>.dart';

export 'src/internal/<featureName>_controller.dart';   // only if events exist
export 'src/internal/<featureName>_platform.dart';     // only if listener caching needed
export 'src/internal/constants.dart';
export 'src/internal/payload_mapper.dart';
export 'src/model/model.dart';

/// Listener typedef — only include if nativeToFlutter events exist
typedef <featureNameCamel>SyncListener = void Function(<SyncModel>? data);

/// Platform Interface for <featureNameCamel> Plugin
abstract class MoEngage<featureNameCamel>PlatformInterface extends PlatformInterface {
  MoEngage<featureNameCamel>PlatformInterface() : super(token: _token);

  static MoEngage<featureNameCamel>PlatformInterface _instance =
      MethodChannelMoEngage<featureNameCamel>();

  static final Object _token = Object();

  static MoEngage<featureNameCamel>PlatformInterface get instance => _instance;

  static set instance(MoEngage<featureNameCamel>PlatformInterface instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  // Fire-and-forget example:
  /// Initialize the <featureName> module
  void initialize(String appId) => throw UnimplementedError();

  // Future result example:
  /// Fetch <featureName> data
  /// Returns [<ResultModel>] as [Future]
  Future<<ResultModel>> get<ResultName>(String appId) async =>
      throw UnimplementedError();

  // Event listener setter example (only if events exist):
  /// Set sync complete listener
  void setSyncCompleteListener(<featureNameCamel>SyncListener listener, String appId) =>
      throw UnimplementedError();
}
