package com.moengage.flutter.<featureName>

import com.moengage.core.LogLevel
import com.moengage.core.internal.logger.Logger
import com.moengage.plugin.base.<featureName>.internal.<featureNameCamel>EventEmitter
import com.moengage.plugin.base.<featureName>.internal.<featureName>SyncToJson  // verify exact import
import com.moengage.plugin.base.<featureName>.internal.model.events.<featureNameCamel>Event
import com.moengage.plugin.base.<featureName>.internal.model.events.<featureNameCamel>SyncEvent
import com.moengage.plugin.base.<featureName>.internal.model.events.<featureNameCamel>EventType

class EventEmitterImpl(private val callBack: (methodName: String, payload: String) -> Unit) :
    <featureNameCamel>EventEmitter {
    private val tag = "${MODULE_TAG}EventEmitterImpl"

    override fun emit(event: <featureNameCamel>Event) {
        try {
            when (event) {
                is <featureNameCamel>SyncEvent -> emit<featureNameCamel>SyncEvent(event)
                else -> Logger.print(LogLevel.ERROR) { "$tag emit() Unknown Event: $event" }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "emit(): $event" }
        }
    }

    private fun emit<featureNameCamel>SyncEvent(event: <featureNameCamel>SyncEvent) {
        try {
            val syncJson = <featureName>SyncToJson(event.syncData, event.accountMeta)
            val method = when (event.<featureName>EventType) {
                <featureNameCamel>EventType.EVENT_TYPE_ONE -> METHOD_ON_EVENT_TYPE_ONE
                <featureNameCamel>EventType.EVENT_TYPE_TWO -> METHOD_ON_EVENT_TYPE_TWO
                // add one case per nativeToHybrid event type
            }
            emit(method, syncJson)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emit<featureNameCamel>SyncEvent(): $event" }
        }
    }

    private fun emit(methodName: String, payload: org.json.JSONObject) {
        try {
            Logger.print { "$tag emit() : methodName: $methodName , payload: $payload" }
            callBack.invoke(methodName, payload.toString())
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emit() : " }
        }
    }
}
