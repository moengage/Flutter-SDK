import Foundation

enum MoEngageFlutter<featureNameCamel>Constants {
    static let pluginChannelName = "com.moengage/<featureName>"

    enum FlutterToNativeMethods {
        static let initialize = "initialize"
        // static let <methodName> = "<methodName>"  — one per hybridToNative contract file
    }

    // Omit NativeToFlutterMethods section entirely if no nativeToHybrid events
    enum NativeToFlutterMethods {
        // static let <eventName> = "on<EventName>"  — one per nativeToHybrid event
    }
}
