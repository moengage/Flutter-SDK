import 'package:moengage_flutter/moengage_flutter.dart';

class CallbackCache {
  PushTokenCallbackHandler? pushTokenCallbackHandler;
  PushClickCallbackHandler? pushClickCallbackHandler;
  SelfHandledInAppCallbackHandler? selfHandledInAppCallbackHandler;
  InAppClickCallbackHandler? inAppClickCallbackHandler;
  InAppShownCallbackHandler? inAppShownCallbackHandler;
  InAppDismissedCallbackHandler? inAppDismissedCallbackHandler;
}