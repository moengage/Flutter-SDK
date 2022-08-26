package com.moengage.flutter

import com.moengage.core.LogLevel
import com.moengage.core.internal.logger.Logger
import com.moengage.plugin.base.internal.EventEmitter
import com.moengage.plugin.base.internal.clickDataToJson
import com.moengage.plugin.base.internal.inAppDataToJson
import com.moengage.plugin.base.internal.model.events.Event
import com.moengage.plugin.base.internal.model.events.EventType
import com.moengage.plugin.base.internal.model.events.inapp.InAppActionEvent
import com.moengage.plugin.base.internal.model.events.inapp.InAppLifecycleEvent
import com.moengage.plugin.base.internal.model.events.inapp.InAppSelfHandledEvent
import com.moengage.plugin.base.internal.model.events.push.PushClickedEvent
import com.moengage.plugin.base.internal.model.events.push.TokenEvent
import com.moengage.plugin.base.internal.pushPayloadToJson
import com.moengage.plugin.base.internal.selfHandledDataToJson
import com.moengage.plugin.base.internal.tokenEventToJson
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
            Logger.print { "$tag emit() : $event" }
            when (event) {
                is InAppActionEvent -> {
                    this.emitInAppActionEvent(event)
                }
                is InAppLifecycleEvent -> {
                    this.emitInAppLifeCycleEvent(event)
                }
                is InAppSelfHandledEvent -> {
                    this.emitInAppSelfHandledEvent(event)
                }
                is PushClickedEvent -> {
                    emitPushEvent(event)
                }
                is TokenEvent -> {
                    emitPushTokenEvent(event)
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emit() : Exception: " }
        }
    }

    private fun emitInAppActionEvent(inAppActionEvent: InAppActionEvent) {
        try {
            Logger.print { "$tag emitInAppActionEvent() : $inAppActionEvent" }
            val eventType = eventMap[inAppActionEvent.eventType] ?: return
            val campaign: JSONObject = clickDataToJson(inAppActionEvent.clickData)
            campaign.put(KEY_TYPE, eventType)
            emit(eventType, campaign)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emitInAppActionEvent() : Exception: " }
        }
    }

    private fun emitInAppLifeCycleEvent(inAppLifecycleEvent: InAppLifecycleEvent) {
        try {
            Logger.print { "$tag emitInAppLifeCycleEvent() : $inAppLifecycleEvent" }
            val eventType = eventMap[inAppLifecycleEvent.eventType] ?: return
            val campaign = inAppDataToJson(inAppLifecycleEvent.inAppData)
            campaign.put(KEY_TYPE, eventType)
            emit(eventType, campaign)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emitInAppLifeCycleEvent() : Exception: " }
        }
    }

    private fun emitInAppSelfHandledEvent(inAppSelfHandledEvent: InAppSelfHandledEvent) {
        try {
            Logger.print { "$tag emitInAppSelfHandledEvent() : $inAppSelfHandledEvent" }
            val eventType = eventMap[inAppSelfHandledEvent.eventType]
                ?: return
            val campaign: JSONObject =
                selfHandledDataToJson(inAppSelfHandledEvent.data)
            campaign.put(KEY_TYPE, eventType)
            emit(eventType, campaign)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emitInAppSelfHandledEvent() : Exception: " }
        }
    }

    private fun emitPushEvent(pushEvent: PushClickedEvent) {
        try {
            Logger.print { "$tag emitPushEvent() : $pushEvent" }
            val eventType = eventMap[pushEvent.eventType] ?: return
            val payload = pushPayloadToJson(pushEvent.payload)
            payload.put(KEY_TYPE, eventType)
            emit(eventType, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emitPushEvent() : Exception: " }
        }
    }

    private fun emitPushTokenEvent(tokenEvent: TokenEvent) {
        try {
            Logger.print { "$tag emitPushTokenEvent() : $tokenEvent" }
            val eventType = eventMap[tokenEvent.eventType] ?: return
            val payload = tokenEventToJson(tokenEvent)
            //payload.put(MoEConstants.KEY_TYPE, eventType);
            emit(eventType, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emitPushTokenEvent() : Exception: " }
        }
    }

    private fun emit(methodName: String, payload: JSONObject) {
        try {
            Logger.print { "$tag emit() : methodName: $methodName" }
            onEvent(methodName, payload.toString())
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emit() : Exception: " }
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