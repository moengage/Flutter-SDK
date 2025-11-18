//
//  MoEngageCardSyncListner.swift
//  moengage_cards
//
//  Created by Soumya Mahunt on 22/06/23.
//

import Flutter
import MoEngagePluginCards

class MoEngageCardSyncListner: MoEngageCardSyncDelegate {
    private let channel: FlutterMethodChannel

    init(producingOnChannel channel: FlutterMethodChannel) {
        self.channel = channel
    }

    func syncComplete(
        forEventType eventType: MoEngageCardsSyncEventType,
        withData data: [String : Any]
    ) {
        let jsonStr = MoEngageCardsUtil.serialize(data: data)
        MoEngagePluginCardsLogger.debug(
            "Got sync update data \(data) for sync type \(eventType)",
            forData: data
        )
        DispatchQueue.main.async {
            self.channel.invokeMethod(eventType.mappedMethodName, arguments: jsonStr)
        }
    }
}

extension MoEngageCardsSyncEventType {
    var mappedMethodName: String {
        switch self {
        case .pullToRefresh:
            return MoEngageFlutterCardsConstants.NativeToFlutterMethods.pullToRefreshCardsSync
        case .inboxOpen:
            return MoEngageFlutterCardsConstants.NativeToFlutterMethods.inboxOpenCardsSync
        case .appOpen,
             .immediate: 
            return MoEngageFlutterCardsConstants.NativeToFlutterMethods.cardGenericSync
        }
    }
}
