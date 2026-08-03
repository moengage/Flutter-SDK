import 'package:moengage_<featureName>_platform_interface/moengage_<featureName>_platform_interface.dart';
import 'package:moengage_flutter/moengage_flutter.dart';

/// Helper Class to interact with MoEngage <featureNameCamel> Feature
class MoEngage<featureNameCamel> {
  /// [MoEngage<featureNameCamel>] Constructor
  MoEngage<featureNameCamel>(this._appId) {
    // Only include below line if nativeToFlutter events exist:
    <featureNameCamel>Controller.init();
  }

  static const String _tag = '${moduleTag}MoEngage<featureNameCamel>';

  final String _appId;

  final MoEngage<featureNameCamel>PlatformInterface _platform =
      MoEngage<featureNameCamel>PlatformInterface.instance;

  // Fire-and-forget example:
  /// Initialize the <featureName> module
  void initialize() {
    Logger.v('$_tag initialize(): Initializing <featureNameCamel> Module');
    _platform.initialize(_appId);
  }

  // Future result example:
  /// Fetch <featureName> data
  /// Returns [<ResultModel>] as [Future]
  Future<<ResultModel>> get<ResultName>() {
    Logger.v('$_tag get<ResultName>():');
    return _platform.get<ResultName>(_appId);
  }

  // Event listener setter example (only if events exist):
  /// Set sync complete listener
  /// [listener] - Callback of type [<featureNameCamel>SyncListener]
  void setSyncCompleteListener(<featureNameCamel>SyncListener listener) {
    _platform.setSyncCompleteListener(listener, _appId);
  }
}
