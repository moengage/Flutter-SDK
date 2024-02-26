package com.moengage.flutter

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.moengage.core.LogLevel
import com.moengage.core.MoECoreHelper
import com.moengage.core.internal.logger.Logger
import com.moengage.core.listeners.AppBackgroundListener
import com.moengage.plugin.base.internal.PluginHelper
import com.moengage.plugin.base.internal.setEventEmitter
import com.moengage.plugin.base.internal.userDeletionDataToJson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class MoEngageFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private val tag = "${MODULE_TAG}MoEngageFlutterPlugin"
    private lateinit var context: Context
    private val pluginHelper = PluginHelper()

    private val appBackgroundListener = AppBackgroundListener { _, _ ->
        run {
            Logger.print { "$tag onAppBackground() : Detaching the Framework" }
            pluginHelper.onFrameworkDetached()
        }
    }

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        Logger.print { "$tag onAttachedToEngine() : Registering MoEngageFlutterPlugin" }
        context = binding.applicationContext
        flutterPluginBinding = binding
        if (methodChannel == null) {
            initPlugin(binding.binaryMessenger)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        try {
            Logger.print { "$tag onDetachedFromEngine() : Registering MoEngageFlutterPlugin" }
            pluginHelper.onFrameworkDetached()
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag onDetachedFromEngine() " }
        }
    }

    private fun initPlugin(binaryMessenger: BinaryMessenger) {
        try {
            Logger.print { "$tag initPlugin(): Initializing MoEngage Flutter Plugin" }
            methodChannel = MethodChannel(binaryMessenger, FLUTTER_PLUGIN_CHANNEL_NAME)
            methodChannel?.setMethodCallHandler(this)
            setEventEmitter(EventEmitterImpl(::sendCallback))
            if (GlobalCache.lifecycleAwareCallbackEnabled) {
                Logger.print { "$tag initPlugin()  Adding App Background Listener: " }
                MoECoreHelper.addAppBackgroundListener(appBackgroundListener)
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag initPlugin()  : " }
        }
    }

    private fun sendCallback(methodName: String, message: String) {
        try {
            Handler(Looper.getMainLooper()).post {
                try {
                    methodChannel?.invokeMethod(methodName, message)
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
            Logger.print { "$tag onMethodCall() : method:  ${call.method}" }
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
                METHOD_NAME_UPDATE_DEVICE_IDENTIFIER_TRACKING_STATUS ->
                    updateDeviceIdentifierTrackingStatus(call)
                METHOD_NAME_SETUP_NOTIFICATION_CHANNEL -> setupNotificationChannels()
                METHOD_NAME_NAVIGATE_TO_SETTINGS -> navigateToSettings()
                METHOD_NAME_REQUEST_PUSH_PERMISSION -> requestPushPermission()
                METHOD_NAME_PERMISSION_RESPONSE -> permissionResponse(call)
                METHOD_NAME_PUSH_PERMISSION_PERMISSION_COUNT ->
                    updatePushPermissionRequestCount(call)
                METHOD_NAME_DELETE_USER -> deleteUser(call, result)
                METHOD_NAME_SHOW_NUDGE -> showNudge(call)
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
        Logger.print { "$tag logout() : Arguments: $payload" }
        pluginHelper.logout(context, payload)
    }

    private fun showInApp(methodCall: MethodCall) {
        if (methodCall.arguments == null) return
        val payload = methodCall.arguments.toString()
        Logger.print { "$tag showInApp() : Arguments: $payload" }
        pluginHelper.showInApp(context, payload)
    }

    private fun onInitialised(methodCall: MethodCall) {
        if (methodCall.arguments == null) return
        val payload = methodCall.arguments.toString()
        pluginHelper.initialise(payload)
        Logger.print { "$tag onInitialised() : MoEngage Flutter plugin initialised." }
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
            Logger.print { "$tag setAppStatus() : Arguments :$payload" }
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
            Logger.print { "$tag selfHandledCallback() : Arguments: $methodCall" }
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
            Logger.print { "$tag updateSdkState() : Arguments: $payload" }
            pluginHelper.storeFeatureStatus(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag updateSdkState() : " }
        }
    }

    private fun onOrientationChanged() {
        Logger.print { "$tag onOrientationChanged() : " }
        pluginHelper.onConfigurationChanged()
    }

    private fun updateDeviceIdentifierTrackingStatus(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag updateDeviceIdentifierTrackingStatus() : Arguments: $payload" }
            pluginHelper.deviceIdentifierTrackingStatusUpdate(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag updateDeviceIdentifierTrackingStatus() : " }
        }
    }

    private fun setupNotificationChannels() {
        try {
            pluginHelper.setUpNotificationChannels(context)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag setupNotificationChannel() :" }
        }
    }

    private fun navigateToSettings() {
        try {
            pluginHelper.navigateToSettings(context)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag navigateToSettings() :" }
        }
    }

    private fun requestPushPermission() {
        try {
            pluginHelper.requestPushPermission(context)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag requestPushPermission() :" }
        }
    }

    private fun permissionResponse(methodCall: MethodCall) {
        try {
            Logger.print { "$tag permissionResponse() : Arguments: ${methodCall.arguments}" }
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag permissionResponse() : Payload: $payload" }
            pluginHelper.permissionResponse(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag permissionResponse() :" }
        }
    }

    private fun updatePushPermissionRequestCount(methodCall: MethodCall) {
        try {
            Logger.print { "$tag updatePushPermissionRequestCount() : Arguments: ${methodCall.arguments}" }
            if (methodCall.arguments == null) return
            val payload: String = methodCall.arguments.toString()
            Logger.print { "$tag updatePushPermissionRequestCount() : Payload: $payload" }
            pluginHelper.updatePushPermissionRequestCount(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag updatePushPermissionRequestCount() :" }
        }
    }

    /**
     * API to delete the user from MoEngage Server
     * @param methodCall - Instance of [MethodCall] to get message from Flutter Method Channel
     * @param result - Instance of [MethodChannel.Result] to send result to Flutter Method Channel
     * @since 1.1.0
     */
    private fun deleteUser(methodCall: MethodCall, result: MethodChannel.Result) {
        try {
            Logger.print { "$tag deleteUser() : Arguments: ${methodCall.arguments}" }
            if (methodCall.arguments == null) {
                result.error(ERROR_CODE_DELETE_USER, "Invalid Arguments", null)
                return
            }
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag updatePushPermissionRequestCount() : Payload: $payload" }
            pluginHelper.deleteUser(context, payload) { data ->
                result.success(userDeletionDataToJson(data).toString())
            }
        } catch (t: Throwable) {
            result.error(ERROR_CODE_DELETE_USER, "Error occured while Deleting the User", null)
            Logger.print(LogLevel.ERROR, t) { "deleteUser(): " }
        }
    }


    /**
     * Called when the plugin is attached to Flutter Activity.
     * @param binding instance of [ActivityPluginBinding]
     */
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Logger.print { "$tag onAttachedToActivity() : Attached To Activity" }
        flutterPluginBinding?.binaryMessenger?.let {
            initPlugin(it)
        }
    }


    /**
     * Called when the plugin is Detached From Flutter Activity.
     */
    override fun onDetachedFromActivity() {
        Logger.print { "$tag onDetachedFromActivity() : Resetting methodChannel to `null`" }
        methodChannel = null
    }

    /**
     * Called when the plugin is Detached From Flutter Activity for Config Changes
     */
    override fun onDetachedFromActivityForConfigChanges() {
        Logger.print {
            "$tag onDetachedFromActivityForConfigChanges() : Detached From Activity for Config changes"
        }
    }

    /**
     * Called when the plugin is Reattached to Flutter Activity For Config Changes.
     * @param binding instance of [ActivityPluginBinding]
     */
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Logger.print {
            "$tag onReattachedToActivityForConfigChanges() : ReAttached To Activity for Config changes"
        }
    }

    /**
     * Show Non Intrusive Nudge InApp provided the payload in [methodCall] object.
     */
    private fun showNudge(methodCall: MethodCall) {
        try {
            Logger.print { "$tag showNudge() : Arguments: ${methodCall.arguments}" }
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag showNudge() : Payload: $payload" }
            pluginHelper.showNudge(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag showNudge(): " }
        }
    }

    companion object {
        /**
         * Static MethodChannel instance to avoid plugin reinitializing from Background Isolate
         */
        internal var methodChannel: MethodChannel? = null

        /**
         * Instance of [FlutterPluginBinding] to reinitialize the Method Channel on [onAttachedToActivity]
         */
        internal var flutterPluginBinding: FlutterPluginBinding? = null
    }
}