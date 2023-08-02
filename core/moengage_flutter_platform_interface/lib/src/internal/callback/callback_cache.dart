import '../../../moengage_flutter_platform_interface.dart';

class CallbackCache {
  PushClickCallbackHandler? pushClickCallbackHandler;
  SelfHandledInAppCallbackHandler? selfHandledInAppCallbackHandler;
  InAppClickCallbackHandler? inAppClickCallbackHandler;
  InAppShownCallbackHandler? inAppShownCallbackHandler;
  InAppDismissedCallbackHandler? inAppDismissedCallbackHandler;
}
