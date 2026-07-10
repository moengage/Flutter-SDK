package com.moengage.flutter.cards

import com.moengage.plugin.base.cards.internal.CardsEventEmitter
import com.moengage.plugin.base.cards.internal.cardsSyncToJson
import com.moengage.plugin.base.cards.internal.model.events.CardEventType
import com.moengage.plugin.base.cards.internal.model.events.CardsEvent
import com.moengage.plugin.base.cards.internal.model.events.CardsSyncEvent
import com.moengage.platform.internal.logger.Logger
import com.moengage.platform.internal.logger.PlatformLogLevel
import org.json.JSONObject

class EventEmitterImpl(private val callBack: (methodName: String, payload: String) -> Unit) :
    CardsEventEmitter {
    private val tag = "${MODULE_TAG}EventEmitterImpl"

    override fun emit(event: CardsEvent) {
        try {
            when (event) {
                is CardsSyncEvent -> emitCardSyncEvent(event)
                else -> Logger.record(PlatformLogLevel.ERROR) { "$tag emit() Unknown Event: $event" }
            }
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "emit(): $event" }
        }
    }

    private fun emitCardSyncEvent(event: CardsSyncEvent) {
        try {
            val syncCompleteData = event.syncCompleteData
            if (syncCompleteData == null) {
                Logger.record(PlatformLogLevel.ERROR) { "emitCardSyncEvent(): $event : Sync CompleteData is null" }
            }
            val syncCompleteJson = cardsSyncToJson(syncCompleteData, event.accountMeta)
            val method =
                when (event.cardEventType) {
                    CardEventType.GENERIC_SYNC -> METHOD_GENERIC_CARDS_SYNC
                    CardEventType.INBOX_OPEN_SYNC -> METHOD_INBOX_OPEN_CARDS_SYNC
                    CardEventType.PULL_TO_REFRESH_SYNC -> METHOD_PULL_TO_REFRESH_CARDS_SYNC
                }
            emit(method, syncCompleteJson)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag emitCardSyncEvent(): $event" }
        }
    }

    private fun emit(
        methodName: String,
        payload: JSONObject,
    ) {
        try {
            Logger.record { "$tag emit() : methodName: $methodName , payload: $payload" }
            callBack.invoke(methodName, payload.toString())
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag emit() : " }
        }
    }
}