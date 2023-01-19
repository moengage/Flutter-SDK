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
import com.moengage.plugin.base.internal.model.events.push.PermissionEvent
import com.moengage.plugin.base.internal.model.events.push.PushClickedEvent
import com.moengage.plugin.base.internal.model.events.push.TokenEvent
import com.moengage.plugin.base.internal.permissionResultToJson
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
            Logger.print { "$tag emit() : event: $event" }
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
                is PermissionEvent -> {
                    emitPermissionEvent(event)
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emit() : " }
        }
    }

    private fun emitInAppActionEvent(inAppActionEvent: InAppActionEvent) {
        try {
            Logger.print {
                "$tag emitInAppActionEvent() : inAppActionEvent: ${inAppActionEvent.eventType} , ${inAppActionEvent.clickData}"
            }
            val eventType = eventMap[inAppActionEvent.eventType] ?: return
            val campaign: JSONObject = clickDataToJson(inAppActionEvent.clickData)
            emit(eventType, campaign)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emitInAppActionEvent() : " }
        }
    }

    private fun emitInAppLifeCycleEvent(inAppLifecycleEvent: InAppLifecycleEvent) {
        try {
            Logger.print { "$tag emitInAppLifeCycleEvent() : inAppLifecycleEvent: $inAppLifecycleEvent" }
            val eventType = eventMap[inAppLifecycleEvent.eventType] ?: return
            val campaign = inAppDataToJson(inAppLifecycleEvent.inAppData)
            emit(eventType, campaign)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emitInAppLifeCycleEvent() : " }
        }
    }

    private fun emitInAppSelfHandledEvent(inAppSelfHandledEvent: InAppSelfHandledEvent) {
        try {
            Logger.print {
                "$tag emitInAppSelfHandledEvent() : inAppSelfHandledEvent: " + "${inAppSelfHandledEvent.data}"
            }
            val eventType = eventMap[inAppSelfHandledEvent.eventType]
                ?: return
            val campaign: JSONObject =
                selfHandledDataToJson(inAppSelfHandledEvent.data)
            emit(eventType, campaign)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emitInAppSelfHandledEvent() : " }
        }
    }

    private fun emitPushEvent(pushEvent: PushClickedEvent) {
        try {
            Logger.print { "$tag emitPushEvent() : pushEvent: $pushEvent" }
            val eventType = eventMap[pushEvent.eventType] ?: return
            val payload = pushPayloadToJson(pushEvent.payload)
            emit(eventType, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emitPushEvent() : " }
        }
    }

    private fun emitPushTokenEvent(tokenEvent: TokenEvent) {
        try {
            Logger.print { "$tag emitPushTokenEvent() : tokenEvent: $tokenEvent" }
            val eventType = eventMap[tokenEvent.eventType] ?: return
            val payload = tokenEventToJson(tokenEvent)
            emit(eventType, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emitPushTokenEvent() : " }
        }
    }

    private fun emit(methodName: String, payload: JSONObject) {
        try {
            Logger.print { "$tag emit() : methodName: $methodName , payload: $payload" }
            onEvent(methodName, payload.toString())
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emit() : " }
        }
    }

    private fun emitPermissionEvent(event: PermissionEvent) {
        try {
            Logger.print { "$tag emitPermissionEvent() permission event: $event:" }
            val eventType = eventMap[event.eventType] ?: return
            val payload = permissionResultToJson(event.result)
            emit(eventType, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emitPermissionEvent() : " }
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
            eventMap[EventType.PERMISSION] = "onPermissionResult"
            eventMap[EventType.REQUEST_NOTIFICATION_PERMISSION] = "requestNotificationPermission"
        }
    }
}
