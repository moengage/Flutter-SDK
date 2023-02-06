import 'custom_type.dart';

class CallbackCache {
  PushClickCallbackHandler? pushClickCallbackHandler;
  SelfHandledInAppCallbackHandler? selfHandledInAppCallbackHandler;
  InAppClickCallbackHandler? inAppClickCallbackHandler;
  InAppShownCallbackHandler? inAppShownCallbackHandler;
  InAppDismissedCallbackHandler? inAppDismissedCallbackHandler;
}
