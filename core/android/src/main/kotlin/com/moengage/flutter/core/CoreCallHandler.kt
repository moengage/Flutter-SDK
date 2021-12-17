package com.moengage.flutter.core

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.moengage.core.internal.logger.Logger
import com.moengage.plugin.base.PluginHelper
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CoreCallHandler(
        private val context: Context,
        private val moEngageChannel: MethodChannel,
        private val pluginHelper: PluginHelper,
        private val tag: String) : MethodChannel.MethodCallHandler {

    fun init() {
        pluginHelper.setEventCallback(EventEmitterImpl(::sendCoreCallback))
    }

    private fun sendCoreCallback(methodName: String, message: String) {
        try {
            Handler(Looper.getMainLooper()).post {
                try {
                    moEngageChannel.invokeMethod(methodName, message)
                } catch (e: Exception) {
                    Logger.e("$tag sendCallback() ", e)
                }
            }
        } catch (ex: Exception) {
            Logger.e("$tag sendCallback() : exception: ", ex)
        }
    }

    @Suppress("SENSELESS_COMPARISON")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            if (call == null) {
                Logger.e(
                        "$tag onMethodCall() : MethodCall instance is null cannot proceed "
                                + "further."
                )
                return
            }
            if (context == null) {
                Logger.e("$tag onMethodCall() : Context is null cannot proceed further.")
                return
            }
            Logger.v(tag + " onMethodCall() : Method " + call.method)
            when (call.method) {
                METHOD_NAME_INITIALISE -> onInitialised()
                METHOD_NAME_ENABLE_SDK_LOGS -> enableSDKLogs()
                METHOD_NAME_SET_USER_ATTRIBUTE -> setUserAttribute(call)
                METHOD_NAME_SET_USER_ATTRIBUTE_LOCATION -> setUserLocation(call)
                METHOD_NAME_TRACK_EVENT -> trackEvent(call)
                METHOD_NAME_SHOW_IN_APP -> showInApp()
                METHOD_NAME_LOGOUT -> logout()
                METHOD_NAME_SET_ALIAS -> setAlias(call)
                METHOD_NAME_SET_APP_STATUS -> setAppStatus(call)
                METHOD_NAME_SET_USER_ATTRIBUTE_TIMESTAMP -> setTimestamp(call)
                METHOD_NAME_SELF_HANDLED_INAPP -> getSelfHandledInApp()
                METHOD_NAME_SET_APP_CONTEXT -> setAppContext(call)
                METHOD_NAME_RESET_APP_CONTEXT -> resetAppContext()
                METHOD_NAME_PUSH_PAYLOAD -> passPushPayload(call)
                METHOD_NAME_PUSH_TOKEN -> passPushToken(call)
                METHOD_NAME_OPT_OUT_TRACKING -> optOutTracking(call)
                METHOD_NAME_SELF_HANDLED_CALLBACK -> selfHandledCallback(call)
                METHOD_NAME_UPDATE_SDK_STATE -> updateSdkState(call)
                METHOD_NAME_ON_ORIENTATION_CHANGED -> onOrientationChanged()
                else -> Logger.e("$tag onMethodCall() : No mapping for this method.")
            }
        } catch (e: Exception) {
            Logger.e("$tag onMethodCall() : exception: ", e)
        }
    }

    private fun logout() {
        pluginHelper.logout(context)
    }

    private fun showInApp() {
        pluginHelper.showInApp(context)
    }

    private fun onInitialised() {
        Logger.v("$tag onInitialised() : MoEngage Flutter plugin initialised.")
        pluginHelper.initialize()
    }

    private fun enableSDKLogs() {
        pluginHelper.enableSDKLogs()
    }

    private fun setUserAttribute(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.v("$tag setUserAttribute() : Arguments: $payload")
            pluginHelper.setUserAttribute(context, payload)
        } catch (e: Exception) {
            Logger.e("$tag setUserAttribute() : exception: ", e)
        }
    }

    private fun setUserLocation(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.v("$tag setUserLocation() : Argument: $payload")
            pluginHelper.setUserAttribute(context, payload)
        } catch (e: Exception) {
            Logger.e("$tag setUserLocation() : exception: ", e)
        }
    }

    private fun trackEvent(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) {
                Logger.e("$tag trackEvent() : Arguments are null, cannot trackEvent")
                return
            }
            val payload = methodCall.arguments as String
            Logger.v("$tag trackEvent() : Argument :$payload")
            pluginHelper.trackEvent(context, payload)
        } catch (e: Exception) {
            Logger.e("$tag trackEvent() : exception: ", e)
        }
    }

    private fun setAlias(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.v("$tag setAlias() : Argument :$payload")
            pluginHelper.setAlias(context, payload)
        } catch (e: Exception) {
            Logger.e("$tag setAlias() : exception: ", e)
        }
    }

    private fun setAppStatus(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.v("$tag setAppStatus() : Argument :$payload")
            pluginHelper.setAppStatus(context, payload)
        } catch (e: Exception) {
            Logger.e("$tag setAppStatus() : exception: ", e)
        }
    }

    private fun setTimestamp(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.v("$tag setTimestamp() : Arguments: $payload")
            pluginHelper.setUserAttribute(context, payload)
        } catch (e: Exception) {
            Logger.e("$tag setTimestamp() : exception: ", e)
        }
    }

    private fun getSelfHandledInApp() {
        pluginHelper.getSelfHandledInApp(context)
    }

    private fun setAppContext(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.v("$tag setAppContext() : Arguments: $payload")
            pluginHelper.setAppContext(context, payload)
        } catch (e: Exception) {
            Logger.e("$tag setAppContext() : exception: ", e)
        }
    }

    private fun resetAppContext() {
        pluginHelper.resetAppContext(context)
    }

    private fun passPushToken(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.v("$tag passPushToken() : Arguments: $payload")
            pluginHelper.passPushToken(context, payload)
        } catch (e: Exception) {
            Logger.e("$tag passPushToken() : exception: ", e)
        }
    }

    private fun passPushPayload(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.v("$tag passPushPayload() : Arguments: $payload")
            pluginHelper.passPushPayload(context, payload)
        } catch (e: Exception) {
            Logger.e("$tag passPushPayload() : exception: ", e)
        }
    }

    private fun optOutTracking(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.v("$tag optOutTracking() : Arguments: $payload")
            pluginHelper.optOutTracking(context, payload)
        } catch (e: Exception) {
            Logger.e("$tag optOutTracking() : exception: ", e)
        }
    }

    private fun selfHandledCallback(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.v("$tag selfHandledCallback() : Arguments: $payload")
            pluginHelper.selfHandledCallback(context, payload)
        } catch (e: Exception) {
            Logger.e("$tag selfHandledCallback() : ", e)
        }
    }

    private fun updateSdkState(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.v("$tag selfHandledCallback() : Arguments: $payload")
            pluginHelper.storeFeatureStatus(context, payload);
        } catch (e: Exception) {
            Logger.e("$tag selfHandledCallback() : ", e)
        }
    }

    private fun onOrientationChanged() {
        Logger.v("$tag onOrientationChanged() : ")
        pluginHelper.onConfigurationChanged()
    }
}