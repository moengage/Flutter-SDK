// This is NOT a file to generate on its own — it illustrates the edit to make
// inside the ALREADY-EXISTING `<androidPkgDir>/lib/moengage_<featureName>_android.dart`
// and `<iosPkgDir>/lib/moengage_<featureName>_ios.dart` files whenever a method is
// added to an existing platform interface (see SKILL.md Phase 3.13).
//
// IMPORTANT: MoEngage<featureNameCamel>Android / MoEngage<featureNameCamel>IOS extend
// MoEngage<featureNameCamel>Platform (the platform_base/platform_interface abstract
// class) DIRECTLY — they do NOT extend MethodChannelMoEngage<featureNameCamel>. That
// means adding a method's body only to method_channel.dart (3.12) never runs in a real
// app; the abstract class's `throw UnimplementedError()` default is what executes
// instead, since neither registered class inherits the MethodChannel override.
// Every method added to the abstract class needs a matching @override copied into
// BOTH registered classes below, using each file's existing invocation style
// (jsonEncode(...) + String channel on Android, raw Map on iOS — copy neighboring
// methods' style exactly, do not invent a new one).

// --- <androidPkgDir>/lib/moengage_<featureName>_android.dart -----------------------
class MoEngage_featureNameCamel_Android extends MoEngage_featureNameCamel_Platform {
  // ...existing overrides above...

  @override
  void some_newMethod(String param, String appId) {
    _methodChannel.invokeMethod(
      method_NewMethod,
      jsonEncode(get_NewMethod_Payload(param, appId)),
    );
  }
}

// --- <iosPkgDir>/lib/moengage_<featureName>_ios.dart --------------------------------
class MoEngage_featureNameCamel_IOS extends MoEngage_featureNameCamel_Platform {
  // ...existing overrides above...

  @override
  void some_newMethod(String param, String appId) {
    _channel.invokeMethod(
      method_NewMethod,
      get_NewMethod_Payload(param, appId),
    );
  }
}