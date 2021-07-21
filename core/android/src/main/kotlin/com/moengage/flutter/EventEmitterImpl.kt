package com.moengage.flutter

import android.content.ContentValues.TAG
import com.moengage.core.internal.logger.Logger
import com.moengage.plugin.base.EventEmitter
import com.moengage.plugin.base.inAppCampaignToJson
import com.moengage.plugin.base.model.*
import com.moengage.plugin.base.pushPayloadToJson
import com.moengage.plugin.base.pushTokenToJson
import org.json.JSONObject
import java.util.*


/**
 * @author Arshiya Khanum
 * Date: 2020/10/21
 */
class EventEmitterImpl(private val onEvent: (methodName: String, payload: String) -> Unit) :
    EventEmitter {

    private val tag: String = "${MODULE_TAG}EventEmitterImpl"

    override fun emit(event: Event) {
        try {
            Logger.v("$tag emit() : $event")
            when (event) {
                is InAppEvent -> {
                    emitInAppEvent(event)
                }
                is PushEvent -> {
                    emitPushEvent(event)
                }
                is TokenEvent -> {
                    emitPushTokenEvent(event)
                }
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

    private fun emitPushTokenEvent(tokenEvent: TokenEvent) {
        try {
            Logger.v("$TAG emitPushTokenEvent() : $tokenEvent")
            val eventType =
                eventMap[tokenEvent.eventType] ?: return
            val payload = pushTokenToJson(tokenEvent.pushToken)
            emit(eventType, payload)
        } catch (e: Exception) {
            Logger.e("$TAG emitPushTokenEvent() : ", e)
        }
    }

    private fun emit(methodName: String, payload: JSONObject) {
        try {
            Logger.v("$tag emit() : methodName: $methodName")
            onEvent(methodName, payload.toString())
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
            eventMap[EventType.PUSH_TOKEN_GENERATED] = "onPushTokenGenerated"
        }
    }
}
