package com.moengage.flutter

import com.moengage.core.Logger
import com.moengage.plugin.base.EventEmitter
import com.moengage.plugin.base.inAppCampaignToJson
import com.moengage.plugin.base.model.Event
import com.moengage.plugin.base.model.EventType
import com.moengage.plugin.base.model.InAppEvent
import com.moengage.plugin.base.model.PushEvent
import com.moengage.plugin.base.pushPayloadToJson
import org.json.JSONObject
import java.util.*

/**
 * @author Arshiya Khanum
 * Date: 2020/10/21
 */
class EventEmitterImpl : EventEmitter {

    private val tag: String = "${MODULE_TAG}EventEmitterImpl"

    override fun emit(event: Event) {
        try {
            Logger.v("$tag emit() : $event")
            if (event is InAppEvent) {
                emitInAppEvent(event)
            } else if (event is PushEvent) {
                emitPushEvent(event)
            }
        } catch (e: Exception) {
            Logger.e("$tag emit() : Exception: ", e)
        }
    }

    private fun emitInAppEvent(inAppEvent: InAppEvent) {
        try {
            Logger.v("$tag emitInAppEvent() : $inAppEvent")
            val eventType =
                eventMap[inAppEvent.eventType] ?: return
            val campaign = inAppCampaignToJson(inAppEvent.inAppCampaign)
            campaign.put(KEY_TYPE, eventType)
            Logger.v("$tag emitInAppEvent() : campaignJSON: $campaign")
            emit(eventType, campaign)
        } catch (e: Exception) {
            Logger.e("$tag inAppToJSON() : Exception: ", e)
        }
    }

    private fun emitPushEvent(pushEvent: PushEvent) {
        try {
            Logger.v("$tag emitPushEvent() : $pushEvent")
            val eventType =
                eventMap[pushEvent.eventType] ?: return
            val payload = pushPayloadToJson(pushEvent.payload)
            emit(eventType, payload)
        } catch (e: Exception) {
            Logger.e("$tag inAppToJSON() : Exception: ", e)
        }
    }

    private fun emit(methodName: String, payload: JSONObject) {
        try {
            Logger.v("$tag emit() : methodName: $methodName")
            MoEngageFlutterPlugin.sendCallback(methodName, payload.toString())
        } catch (e: Exception) {
            Logger.e("$tag emit() : ", e)
        }
    }

    companion object {
        
        private val eventMap = EnumMap<EventType, String>(EventType::class.java)

        init {
            eventMap[EventType.PUSH_CLICKED] = "onPushClick"
            eventMap[EventType.INAPP_SHOWN] = "onInAppShown"
            eventMap[EventType.INAPP_NAVIGATION] = "onInAppClick"
            eventMap[EventType.INAPP_CLOSED] = "onInAppDismiss"
            eventMap[EventType.INAPP_CUSTOM_ACTION] = "onInAppCustomAction"
            eventMap[EventType.INAPP_SELF_HANDLED_AVAILABLE] = "onInAppSelfHandle"
        }
    }
}