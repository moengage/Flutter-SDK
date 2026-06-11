import Flutter
import MoEngagePlugin<featureNameCamel>

// Only generate this file if nativeToHybrid events exist.
class MoEngage<featureNameCamel>SyncListener: MoEngage<featureNameCamel>SyncDelegate {  // TODO: verify delegate protocol name
    private let channel: FlutterMethodChannel

    init(producingOnChannel channel: FlutterMethodChannel) {
        self.channel = channel
    }

    func syncComplete(
        forEventType eventType: MoEngage<featureNameCamel>SyncEventType,  // TODO: verify event type enum name
        withData data: [String : Any]
    ) {
        let jsonStr = MoEngage<featureNameCamel>Util.serialize(data: data)
        MoEngagePlugin<featureNameCamel>Logger.debug(
            "Got sync update data \(data) for sync type \(eventType)",
            forData: data
        )
        DispatchQueue.main.async {
            self.channel.invokeMethod(eventType.mappedMethodName, arguments: jsonStr)
        }
    }
}

extension MoEngage<featureNameCamel>SyncEventType {
    var mappedMethodName: String {
        switch self {
        // case .<sdkEnumCase>:
        //     return MoEngageFlutter<featureNameCamel>Constants.NativeToFlutterMethods.<eventConstant>
        // Add one case per nativeToHybrid event type enum value
        }
    }
}
