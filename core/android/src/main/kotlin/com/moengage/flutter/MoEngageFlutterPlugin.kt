package com.moengage.flutter

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.moengage.core.LogLevel
import com.moengage.core.internal.logger.Logger
import com.moengage.plugin.base.internal.PluginHelper
import com.moengage.plugin.base.internal.setEventEmitter
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class MoEngageFlutterPlugin : FlutterPlugin, MethodCallHandler {

    private val tag = "${MODULE_TAG}MoEngageFlutterPlugin"
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private val pluginHelper = PluginHelper()

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        Logger.print { "$tag onAttachedToEngine() : Registering MoEngageFlutterPlugin" }
        context = binding.applicationContext
        initPlugin(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        try {
            Logger.print { "$tag onDetachedFromEngine() : Registering MoEngageFlutterPlugin" }
            //TODO Add API in base plugin if required
//            pluginHelper.onFrameworkDetached()
            channel.setMethodCallHandler(null)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag onDetachedFromEngine() " }
        }
    }

    private fun initPlugin(binaryMessenger: BinaryMessenger) {
        try {
            channel = MethodChannel(binaryMessenger, FLUTTER_PLUGIN_CHANNEL_NAME)
            channel.setMethodCallHandler(this)
            setEventEmitter(EventEmitterImpl(::sendCallback))
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag initPlugin() : exception : " }
        }
    }

    private fun sendCallback(methodName: String, message: String) {
        try {
            Handler(Looper.getMainLooper()).post {
                try {
                    channel.invokeMethod(methodName, message)
                } catch (t: Throwable) {
                    Logger.print(LogLevel.ERROR, t) { "$tag sendCallback() " }
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag sendCallback() : " }
        }
    }

    @Suppress("SENSELESS_COMPARISON")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            if (call == null) {
                Logger.print(LogLevel.ERROR) { "$tag onMethodCall() : MethodCall instance is null cannot proceed further." }
                return
            }
            if (context == null) {
                Logger.print(LogLevel.ERROR) {
                    "$tag onMethodCall() : Context is null cannot " +
                            "proceed further."
                }
                return
            }
            Logger.print { "$tag onMethodCall() : Method ${call.method}" }
            when (call.method) {
                METHOD_NAME_INITIALISE -> onInitialised(call)
                METHOD_NAME_SET_USER_ATTRIBUTE -> setUserAttribute(call)
                METHOD_NAME_SET_USER_ATTRIBUTE_LOCATION -> setUserLocation(call)
                METHOD_NAME_TRACK_EVENT -> trackEvent(call)
                METHOD_NAME_SHOW_IN_APP -> showInApp(call)
                METHOD_NAME_LOGOUT -> logout(call)
                METHOD_NAME_SET_ALIAS -> setAlias(call)
                METHOD_NAME_SET_APP_STATUS -> setAppStatus(call)
                METHOD_NAME_SET_USER_ATTRIBUTE_TIMESTAMP -> setTimestamp(call)
                METHOD_NAME_SELF_HANDLED_INAPP -> getSelfHandledInApp(call)
                METHOD_NAME_SET_APP_CONTEXT -> setAppContext(call)
                METHOD_NAME_RESET_APP_CONTEXT -> resetAppContext(call)
                METHOD_NAME_PUSH_PAYLOAD -> passPushPayload(call)
                METHOD_NAME_PUSH_TOKEN -> passPushToken(call)
                METHOD_NAME_OPT_OUT_TRACKING -> optOutTracking(call)
                METHOD_NAME_SELF_HANDLED_CALLBACK -> selfHandledCallback(call)
                METHOD_NAME_UPDATE_SDK_STATE -> updateSdkState(call)
                METHOD_NAME_ON_ORIENTATION_CHANGED -> onOrientationChanged()
                else -> Logger.print(LogLevel.ERROR) {
                    "$tag onMethodCall() : No mapping for this" +
                            " method."
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag onMethodCall() : " }
        }
    }

    private fun logout(methodCall: MethodCall) {
        if (methodCall.arguments == null) return
        val payload = methodCall.arguments.toString()
        Logger.print { "$tag logout() : $payload" }
        pluginHelper.logout(context, payload)
    }

    private fun showInApp(methodCall: MethodCall) {
        if (methodCall.arguments == null) return
        val payload = methodCall.arguments.toString()
        Logger.print { "$tag showInApp() : $payload" }
        pluginHelper.showInApp(context, payload)
    }

    private fun onInitialised(methodCall: MethodCall) {
        if (methodCall.arguments == null) return
        val payload = methodCall.arguments.toString()
        Logger.print { "$tag onInitialised() : MoEngage Flutter plugin initialised." }
        pluginHelper.initialise(payload)
    }

    private fun setUserAttribute(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag setUserAttribute() : Arguments: $payload" }
            pluginHelper.setUserAttribute(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag setUserAttribute() : " }
        }
    }

    private fun setUserLocation(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag setUserLocation() : Argument: $payload" }
            pluginHelper.setUserAttribute(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag setUserLocation() : " }
        }
    }

    private fun trackEvent(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) {
                Logger.print(LogLevel.ERROR) {
                    "$tag trackEvent() : Arguments are null, cannot" +
                            " trackEvent"
                }
                return
            }
            val payload = methodCall.arguments as String
            Logger.print { "$tag trackEvent() : Argument :$payload" }
            pluginHelper.trackEvent(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag trackEvent() : " }
        }
    }

    private fun setAlias(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag setAlias() : Argument :$payload" }
            pluginHelper.setAlias(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag setAlias() : " }
        }
    }

    private fun setAppStatus(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag setAppStatus() : Argument :$payload" }
            pluginHelper.setAppStatus(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag setAppStatus() : " }
        }
    }

    private fun setTimestamp(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag setTimestamp() : Arguments: $payload" }
            pluginHelper.setUserAttribute(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag setTimestamp() : " }
        }
    }

    private fun getSelfHandledInApp(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag getSelfHandledInApp() : Arguments: $payload" }
            pluginHelper.getSelfHandledInApp(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag getSelfHandledInApp() : " }
        }
    }

    private fun setAppContext(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag setAppContext() : Arguments: $payload" }
            pluginHelper.setAppContext(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag setAppContext() : " }
        }
    }

    private fun resetAppContext(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag resetAppContext() : Arguments: $payload" }
            pluginHelper.resetAppContext(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag resetAppContext() : " }
        }
    }

    private fun passPushToken(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag passPushToken() : Arguments: $payload" }
            pluginHelper.passPushToken(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag passPushToken() : " }
        }
    }

    private fun passPushPayload(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag passPushPayload() : Arguments: $payload" }
            pluginHelper.passPushPayload(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag passPushPayload() : " }
        }
    }

    private fun optOutTracking(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag optOutTracking() : Arguments: $payload" }
            pluginHelper.optOutTracking(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag optOutTracking() : " }
        }
    }

    private fun selfHandledCallback(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag selfHandledCallback() : Arguments: $payload" }
            pluginHelper.selfHandledCallback(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag selfHandledCallback() : " }
        }
    }

    private fun updateSdkState(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag selfHandledCallback() : Arguments: $payload" }
            pluginHelper.storeFeatureStatus(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag selfHandledCallback() : " }
        }
    }

    private fun onOrientationChanged() {
        Logger.print { "$tag onOrientationChanged() : " }
        pluginHelper.onConfigurationChanged()
    }
}