package com.moengage.flutter.cards

import com.moengage.core.LogLevel
import com.moengage.core.internal.logger.Logger
import com.moengage.flutter.cards.internal.METHOD_APP_OPEN_CARDS_SYNC
import com.moengage.flutter.cards.internal.METHOD_INBOX_OPEN_CARDS_SYNC
import com.moengage.flutter.cards.internal.METHOD_PULL_TO_REFRESH_CARDS_SYNC
import com.moengage.flutter.cards.internal.MODULE_TAG
import com.moengage.plugin.base.cards.cardsSyncToJson
import com.moengage.plugin.base.cards.internal.CardsEventEmitter
import com.moengage.plugin.base.cards.internal.model.events.CardsEvent
import com.moengage.plugin.base.cards.internal.model.events.CardsSyncEvent
import com.moengage.plugin.base.cards.internal.model.events.EventType
import org.json.JSONObject

class EventEmitterImpl(private val callBack: (methodName: String, payload: String) -> Unit) : CardsEventEmitter {
    private val tag = "${MODULE_TAG}EventEmitterImpl"


    override fun emit(event: CardsEvent) {
        when (event) {
            is CardsSyncEvent -> emitCardSyncEvent(event)
        }
    }

    private fun emitCardSyncEvent(event: CardsSyncEvent) {
        val syncCompleteData = event.syncCompleteData
        if (syncCompleteData == null) {
            Logger.print(LogLevel.ERROR) { "emitCardSyncEvent(): $event : Sync CompleteData is Null" }
            return
        }
        val syncCompleteJson = cardsSyncToJson(syncCompleteData)
        val method = when (event.eventType) {
            EventType.APP_OPEN_SYNC -> METHOD_APP_OPEN_CARDS_SYNC
            EventType.INBOX_OPEN_SYNC -> METHOD_INBOX_OPEN_CARDS_SYNC
            EventType.PULL_TO_REFRESH_SYNC -> METHOD_PULL_TO_REFRESH_CARDS_SYNC
        }
        emit(method, syncCompleteJson)
    }

    private fun emit(methodName: String, payload: JSONObject) {
        try {
            Logger.print { "$tag emit() : methodName: $methodName , payload: $payload" }
            callBack.invoke(methodName, payload.toString())
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emit() : " }
        }
    }

}
