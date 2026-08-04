package com.moengage.flutter

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import com.moengage.core.MoECoreHelper
import com.moengage.core.listeners.AppBackgroundListener
import com.moengage.flutter.internal.designmode.DesignModeElementBounds
import com.moengage.flutter.internal.designmode.DesignModeElementSelection
import com.moengage.flutter.internal.designmode.DesignModeInstanceProvider
import com.moengage.flutter.internal.tooltip.MoeTooltipPlatformViewFactory
import com.moengage.flutter.internal.tooltip.NativeTooltipRenderer
import com.moengage.plugin.base.internal.PluginHelper
import com.moengage.plugin.base.internal.selfHandledInAppsToJson
import com.moengage.plugin.base.internal.setEventEmitter
import com.moengage.plugin.base.internal.userDeletionDataToJson
import com.moengage.platform.internal.logger.Logger
import com.moengage.platform.internal.logger.PlatformLogLevel
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import org.json.JSONObject

class MoEngageFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private val tag = "${MODULE_TAG}MoEngageFlutterPlugin"
    private lateinit var context: Context
    private var activity: Activity? = null
    private val pluginHelper = PluginHelper()

    private val appBackgroundListener =
        AppBackgroundListener { _, _ ->
            run {
                Logger.record { "$tag onAppBackground() : Detaching the Framework" }
                pluginHelper.onFrameworkDetached()
            }
        }

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        Logger.record { "$tag onAttachedToEngine() : Registering MoEngageFlutterPlugin" }
        context = binding.applicationContext
        flutterPluginBinding = binding
        if (methodChannel == null) {
            initPlugin(binding.binaryMessenger)
        }
        binding.platformViewRegistry.registerViewFactory(
            PLATFORM_VIEW_TYPE_ELEMENT_TOOLTIP,
            MoeTooltipPlatformViewFactory(),
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        try {
            Logger.record { "$tag onDetachedFromEngine() : Registering MoEngageFlutterPlugin" }
            pluginHelper.onFrameworkDetached()
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag onDetachedFromEngine() " }
        }
    }

    private fun initPlugin(binaryMessenger: BinaryMessenger) {
        try {
            Logger.record { "$tag initPlugin(): Initializing MoEngage Flutter Plugin" }
            methodChannel = MethodChannel(binaryMessenger, FLUTTER_PLUGIN_CHANNEL_NAME)
            methodChannel?.setMethodCallHandler(this)
            setEventEmitter(EventEmitterImpl(::sendCallback))
            if (GlobalCache.lifecycleAwareCallbackEnabled) {
                Logger.record { "$tag initPlugin()  Adding App Background Listener: " }
                MoECoreHelper.addAppBackgroundListener(appBackgroundListener)
            }
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag initPlugin()  : " }
        }
    }

    private fun sendCallback(
        methodName: String,
        message: String,
    ) {
        try {
            Handler(Looper.getMainLooper()).post {
                try {
                    methodChannel?.invokeMethod(methodName, message)
                } catch (t: Throwable) {
                    Logger.record(PlatformLogLevel.ERROR, t) { "$tag sendCallback() " }
                }
            }
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag sendCallback() : " }
        }
    }

    @Suppress("SENSELESS_COMPARISON")
    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        try {
            if (call == null) {
                Logger.record(PlatformLogLevel.ERROR) { "$tag onMethodCall() : MethodCall instance is null cannot proceed further." }
                return
            }
            if (context == null) {
                Logger.record(PlatformLogLevel.ERROR) {
                    "$tag onMethodCall() : Context is null cannot " +
                        "proceed further."
                }
                return
            }
            Logger.record { "$tag onMethodCall() : method:  ${call.method}" }
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
                METHOD_NAME_SELF_HANDLED_IN_APPS -> getSelfHandledInApps(call, result)
                METHOD_NAME_IDENTIFY_USER -> identifyUser(call)
                METHOD_NAME_GET_USER_IDENTITIES -> getUserIdentities(call, result)
                METHOD_NAME_ACTIVATE_DESIGN_MODE -> activateDesignMode()
                METHOD_NAME_DEACTIVATE_DESIGN_MODE -> deactivateDesignMode()
                METHOD_NAME_DESIGN_MODE_ELEMENT_SELECTED -> reportDesignModeElementSelected(call)
                METHOD_NAME_SHOW_ELEMENT_TOOLTIP -> showElementTooltip(call)
                METHOD_NAME_DISMISS_ELEMENT_TOOLTIP -> NativeTooltipRenderer.dismiss()
                else ->
                    Logger.record(PlatformLogLevel.ERROR) { "$tag onMethodCall() : No mapping for this method." }
            }
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag onMethodCall() : " }
        }
    }

    private fun logout(methodCall: MethodCall) {
        if (methodCall.arguments == null) return
        val payload = methodCall.arguments.toString()
        Logger.record { "$tag logout() : Arguments: $payload" }
        pluginHelper.logout(context, payload)
    }

    private fun showInApp(methodCall: MethodCall) {
        if (methodCall.arguments == null) return
        val payload = methodCall.arguments.toString()
        Logger.record { "$tag showInApp() : Arguments: $payload" }
        pluginHelper.showInApp(context, payload)
    }

    private fun onInitialised(methodCall: MethodCall) {
        if (methodCall.arguments == null) return
        val payload = methodCall.arguments.toString()
        pluginHelper.initialise(payload)
        Logger.record { "$tag onInitialised() : MoEngage Flutter plugin initialised." }
    }

    private fun setUserAttribute(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag setUserAttribute() : Arguments: $payload" }
            pluginHelper.setUserAttribute(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag setUserAttribute() : " }
        }
    }

    private fun setUserLocation(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag setUserLocation() : Argument: $payload" }
            pluginHelper.setUserAttribute(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag setUserLocation() : " }
        }
    }

    private fun trackEvent(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) {
                Logger.record(PlatformLogLevel.ERROR) {
                    "$tag trackEvent() : Arguments are null, cannot" +
                        " trackEvent"
                }
                return
            }
            val payload = methodCall.arguments as String
            Logger.record { "$tag trackEvent() : Argument :$payload" }
            pluginHelper.trackEvent(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag trackEvent() : " }
        }
    }

    private fun setAlias(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag setAlias() : Argument :$payload" }
            pluginHelper.setAlias(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag setAlias() : " }
        }
    }

    private fun setAppStatus(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag setAppStatus() : Arguments :$payload" }
            pluginHelper.setAppStatus(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag setAppStatus() : " }
        }
    }

    private fun setTimestamp(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag setTimestamp() : Arguments: $payload" }
            pluginHelper.setUserAttribute(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag setTimestamp() : " }
        }
    }

    private fun getSelfHandledInApp(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag getSelfHandledInApp() : Arguments: $payload" }
            pluginHelper.getSelfHandledInApp(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag getSelfHandledInApp() : " }
        }
    }

    private fun setAppContext(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag setAppContext() : Arguments: $payload" }
            pluginHelper.setAppContext(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag setAppContext() : " }
        }
    }

    private fun resetAppContext(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag resetAppContext() : Arguments: $payload" }
            pluginHelper.resetAppContext(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag resetAppContext() : " }
        }
    }

    private fun passPushToken(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag passPushToken() : Arguments: $payload" }
            pluginHelper.passPushToken(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag passPushToken() : " }
        }
    }

    private fun passPushPayload(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag passPushPayload() : Arguments: $payload" }
            pluginHelper.passPushPayload(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag passPushPayload() : " }
        }
    }

    private fun optOutTracking(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag optOutTracking() : Arguments: $payload" }
            pluginHelper.optOutTracking(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag optOutTracking() : " }
        }
    }

    private fun selfHandledCallback(methodCall: MethodCall) {
        try {
            Logger.record { "$tag selfHandledCallback() : Arguments: $methodCall" }
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag selfHandledCallback() : Arguments: $payload" }
            pluginHelper.selfHandledCallback(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag selfHandledCallback() : " }
        }
    }

    private fun updateSdkState(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag updateSdkState() : Arguments: $payload" }
            pluginHelper.storeFeatureStatus(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag updateSdkState() : " }
        }
    }

    private fun onOrientationChanged() {
        Logger.record { "$tag onOrientationChanged() : " }
        pluginHelper.onConfigurationChanged()
    }

    private fun updateDeviceIdentifierTrackingStatus(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag updateDeviceIdentifierTrackingStatus() : Arguments: $payload" }
            pluginHelper.deviceIdentifierTrackingStatusUpdate(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag updateDeviceIdentifierTrackingStatus() : " }
        }
    }

    private fun setupNotificationChannels() {
        try {
            pluginHelper.setUpNotificationChannels(context)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag setupNotificationChannel() :" }
        }
    }

    private fun navigateToSettings() {
        try {
            pluginHelper.navigateToSettings(context)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag navigateToSettings() :" }
        }
    }

    private fun requestPushPermission() {
        try {
            pluginHelper.requestPushPermission(context)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag requestPushPermission() :" }
        }
    }

    private fun permissionResponse(methodCall: MethodCall) {
        try {
            Logger.record { "$tag permissionResponse() : Arguments: ${methodCall.arguments}" }
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag permissionResponse() : Payload: $payload" }
            pluginHelper.permissionResponse(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag permissionResponse() :" }
        }
    }

    private fun updatePushPermissionRequestCount(methodCall: MethodCall) {
        try {
            Logger.record { "$tag updatePushPermissionRequestCount() : Arguments: ${methodCall.arguments}" }
            if (methodCall.arguments == null) return
            val payload: String = methodCall.arguments.toString()
            Logger.record { "$tag updatePushPermissionRequestCount() : Payload: $payload" }
            pluginHelper.updatePushPermissionRequestCount(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag updatePushPermissionRequestCount() :" }
        }
    }

    /**
     * API to delete the user from MoEngage Server
     * @param methodCall - Instance of [MethodCall] to get message from Flutter Method Channel
     * @param result - Instance of [MethodChannel.Result] to send result to Flutter Method Channel
     * @since 1.1.0
     */
    private fun deleteUser(
        methodCall: MethodCall,
        result: MethodChannel.Result,
    ) {
        try {
            Logger.record { "$tag deleteUser() : Arguments: ${methodCall.arguments}" }
            if (methodCall.arguments == null) {
                result.error(ERROR_CODE_DELETE_USER, "Invalid Arguments", null)
                return
            }
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag updatePushPermissionRequestCount() : Payload: $payload" }
            pluginHelper.deleteUser(context, payload) { data ->
                result.success(userDeletionDataToJson(data).toString())
            }
        } catch (t: Throwable) {
            result.error(ERROR_CODE_DELETE_USER, "Error occured while Deleting the User", null)
            Logger.record(PlatformLogLevel.ERROR, t) { "deleteUser(): " }
        }
    }

    /**
     * Called when the plugin is attached to Flutter Activity.
     * @param binding instance of [ActivityPluginBinding]
     */
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Logger.record { "$tag onAttachedToActivity() : Attached To Activity" }
        activity = binding.activity
        flutterPluginBinding?.binaryMessenger?.let {
            initPlugin(it)
        }
    }

    /**
     * Called when the plugin is Detached From Flutter Activity.
     */
    override fun onDetachedFromActivity() {
        DesignModeInstanceProvider.notifyDeactivated()
        NativeTooltipRenderer.dismiss()
        activity = null
        Logger.record { "$tag onDetachedFromActivity() : Resetting methodChannel to `null`" }
        methodChannel = null
    }

    /**
     * Called when the plugin is Detached From Flutter Activity for Config Changes
     */
    override fun onDetachedFromActivityForConfigChanges() {
        Logger.record {
            "$tag onDetachedFromActivityForConfigChanges() : Detached From Activity for Config changes"
        }
    }

    /**
     * Called when the plugin is Reattached to Flutter Activity For Config Changes.
     * @param binding instance of [ActivityPluginBinding]
     */
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Logger.record {
            "$tag onReattachedToActivityForConfigChanges() : ReAttached To Activity for Config changes"
        }
        activity = binding.activity
    }

    /**
     * Notifies the native SDK that the Dart-side Design Mode element picker (boom menu + widget
     * tree inspector) has been activated. The picker overlay itself is entirely implemented in
     * Flutter since only Dart can see individual widget bounds; native only needs to know the
     * lifecycle state, e.g. to suppress other in-apps while picking is in progress.
     */
    private fun activateDesignMode() {
        Logger.record { "$tag activateDesignMode() : Design Mode activated from Dart." }
        DesignModeInstanceProvider.notifyActivated()
    }

    /**
     * Notifies the native SDK that Design Mode has been deactivated.
     */
    private fun deactivateDesignMode() {
        Logger.record { "$tag deactivateDesignMode() : Design Mode deactivated from Dart." }
        DesignModeInstanceProvider.notifyDeactivated()
    }

    /**
     * Receives a marketer-confirmed element selection from the Dart element inspector and
     * forwards it to whichever native SDK module has registered a
     * [com.moengage.flutter.internal.designmode.DesignModeElementListener].
     */
    private fun reportDesignModeElementSelected(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = JSONObject(methodCall.arguments.toString())
            Logger.record { "$tag reportDesignModeElementSelected() : Payload: ${payload.toString(2)}" }
            val boundsJson = payload.getJSONObject(KEY_BOUNDS)
            val ancestorsJson = payload.optJSONArray(KEY_ANCESTORS)
            val ancestors = mutableListOf<String>()
            if (ancestorsJson != null) {
                for (i in 0 until ancestorsJson.length()) {
                    ancestors.add(ancestorsJson.getString(i))
                }
            }
            val selection =
                DesignModeElementSelection(
                    nodeId = payload.getString(KEY_NODE_ID),
                    widgetType = payload.optString(KEY_WIDGET_TYPE),
                    path = payload.optString(KEY_PATH),
                    screenName = payload.optString(KEY_SCREEN_NAME),
                    bounds =
                        DesignModeElementBounds(
                            top = boundsJson.getInt(KEY_BOUNDS_TOP),
                            left = boundsJson.getInt(KEY_BOUNDS_LEFT),
                            bottom = boundsJson.getInt(KEY_BOUNDS_BOTTOM),
                            right = boundsJson.getInt(KEY_BOUNDS_RIGHT),
                        ),
                    ancestors = ancestors,
                    paused = payload.optBoolean(KEY_PAUSED, false),
                )
            DesignModeInstanceProvider.notifyElementSelected(selection)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag reportDesignModeElementSelected() : " }
        }
    }

    /**
     * Receives a resolved element-anchor from Dart (matched against a hardcoded/backend campaign
     * for the active screen) and renders it via the native `com.moengage:tooltip` SDK - a
     * tooltip, beacon or spotlight per [KEY_TOOLTIP_OVERLAY_TYPE] - anchored to that element's
     * bounds. See [NativeTooltipRenderer].
     */
    private fun showElementTooltip(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = JSONObject(methodCall.arguments.toString())
            Logger.record { "$tag showElementTooltip() : Payload: ${payload.toString(2)}" }
            val boundsJson = payload.getJSONObject(KEY_BOUNDS)
            val bounds =
                DesignModeElementBounds(
                    top = boundsJson.getInt(KEY_BOUNDS_TOP),
                    left = boundsJson.getInt(KEY_BOUNDS_LEFT),
                    bottom = boundsJson.getInt(KEY_BOUNDS_BOTTOM),
                    right = boundsJson.getInt(KEY_BOUNDS_RIGHT),
                )
            when (payload.optString(KEY_TOOLTIP_OVERLAY_TYPE, OVERLAY_TYPE_TOOLTIP)) {
                OVERLAY_TYPE_BEACON -> NativeTooltipRenderer.showBeacon(activity, bounds)
                OVERLAY_TYPE_SPOTLIGHT -> NativeTooltipRenderer.showSpotlight(activity, bounds)
                else -> NativeTooltipRenderer.showTooltip(activity, bounds)
            }
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag showElementTooltip() : " }
        }
    }

    /**
     * Show Non Intrusive Nudge InApp provided the payload in [methodCall] object.
     */
    private fun showNudge(methodCall: MethodCall) {
        try {
            Logger.record { "$tag showNudge() : Arguments: ${methodCall.arguments}" }
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag showNudge() : Payload: $payload" }
            pluginHelper.showNudge(context, payload)
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag showNudge(): " }
        }
    }

    /**
     * Get Self Handled InApps provided [methodCall] object and the [result] to send the callback to Flutter.
     */
    private fun getSelfHandledInApps(
        methodCall: MethodCall,
        result: MethodChannel.Result,
    ) {
        try {
            Logger.record { "$tag getSelfHandledInApps() : Arguments: ${methodCall.arguments}" }
            if (methodCall.arguments == null) {
                result.error(ERROR_CODE_SELF_HANDLED_IN_APPS, "Invalid Arguments", null)
                return
            }
            val payload = methodCall.arguments.toString()
            Logger.record { "$tag getSelfHandledInApps() : Payload: $payload" }
            pluginHelper.getSelfHandledInApps(context, payload) { data ->
                if (data == null) {
                    result.error(ERROR_CODE_SELF_HANDLED_IN_APPS, "Error occurred", null)
                } else {
                    result.success(selfHandledInAppsToJson(data).toString())
                }
            }
        } catch (t: Throwable) {
            result.error(ERROR_CODE_SELF_HANDLED_IN_APPS, "Error occurred", null)
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag getSelfHandledInApps() : " }
        }
    }

    /**
     *  Identify the user with the given identity argument in [methodCall]
     */
    private fun identifyUser(methodCall: MethodCall) {
        try {
            val argument =
                methodCall.arguments ?: run {
                    Logger.record { "$tag identifyUser() : Invalid argument" }
                    return@run
                }
            Logger.record { "$tag identifyUser() : Arguments: $argument" }
            pluginHelper.identifyUser(context, argument.toString())
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag identifyUser() : " }
        }
    }

    /**
     *  Return Identities of the user that has been set.
     */
    private fun getUserIdentities(
        methodCall: MethodCall,
        result: MethodChannel.Result,
    ) {
        try {
            val argument =
                methodCall.arguments ?: run {
                    Logger.record { "$tag getUserIdentities() : Invalid argument" }
                    result.error(ERROR_CODE_GET_USER_IDENTITIES, "Invalid argument", null)
                    return@run
                }
            Logger.record { "$tag getUserIdentities() : $argument" }
            pluginHelper.getUserIdentities(context, argument.toString()) { identities ->
                result.success(
                    if (identities != null) {
                        JSONObject(identities).toString()
                    } else {
                        null
                    },
                )
            }
        } catch (t: Throwable) {
            Logger.record(PlatformLogLevel.ERROR, t) { "$tag getUserIdentities() : " }
            result.error(ERROR_CODE_GET_USER_IDENTITIES, "Error occurred", null)
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

        /**
         * Asks the Flutter layer to start the Design Mode element picker, e.g. from a native
         * debug menu or shake gesture. No-op if Flutter isn't attached.
         */
        fun activateDesignModeFromNative() {
            Handler(Looper.getMainLooper()).post {
                methodChannel?.invokeMethod(CALLBACK_ACTIVATE_DESIGN_MODE, null)
            }
        }

        /**
         * Asks the Flutter layer to stop the Design Mode element picker.
         */
        fun deactivateDesignModeFromNative() {
            Handler(Looper.getMainLooper()).post {
                methodChannel?.invokeMethod(CALLBACK_DEACTIVATE_DESIGN_MODE, null)
            }
        }
    }
}