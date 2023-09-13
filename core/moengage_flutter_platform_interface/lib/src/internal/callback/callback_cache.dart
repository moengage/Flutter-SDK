import '../../../moengage_flutter_platform_interface.dart';

/// Native to Flutter Callback Cache
class CallbackCache {
  /// Push Click Callback
  PushClickCallbackHandler? pushClickCallbackHandler;

  /// SelfHandledInApp Callback
  SelfHandledInAppCallbackHandler? selfHandledInAppCallbackHandler;

  /// InApp Click Callback
  InAppClickCallbackHandler? inAppClickCallbackHandler;

  /// InApp Shown Callback
  InAppShownCallbackHandler? inAppShownCallbackHandler;

  /// InApp Dismiss Callback
  InAppDismissedCallbackHandler? inAppDismissedCallbackHandler;
}
