package com.moengage.flutter.<featureName>

import android.content.Context
import com.moengage.core.LogLevel
import com.moengage.core.internal.global.GlobalResources
import com.moengage.core.internal.logger.Logger
import com.moengage.plugin.base.<featureName>.<featureNameCamel>PluginHelper
import com.moengage.plugin.base.<featureName>.internal.set<featureNameCamel>EventEmitter  // only if events exist
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MoEngage<featureNameCamel>Plugin : FlutterPlugin, ActivityAware {
    private val tag = "${MODULE_TAG}MoEngage<featureNameCamel>Plugin"

    private val pluginHelper: <featureNameCamel>PluginHelper by lazy { <featureNameCamel>PluginHelper() }

    lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        try {
            Logger.print { "$tag onAttachedToEngine() : Registering MoEngage<featureNameCamel>Plugin" }
            context = binding.applicationContext
            flutterPluginBinding = binding
            if (methodChannel == null) {
                initPlugin(binding.binaryMessenger)
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag onAttachedToEngine() : " }
        }
    }

    private fun initPlugin(binaryMessenger: BinaryMessenger) {
        try {
            Logger.print { "$tag initPlugin(): Initializing MoEngage <featureNameCamel> Plugin" }
            methodChannel = MethodChannel(binaryMessenger, CHANNEL_NAME)
            methodChannel?.setMethodCallHandler(
                PlatformMethodCallHandler(context, pluginHelper),
            )
            // Only include the line below if nativeToHybrid events exist:
            set<featureNameCamel>EventEmitter(EventEmitterImpl(::emitEvent))
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag initPlugin() : " }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        try {
            Logger.print { "$tag onDetachedFromEngine() : Detaching the Framework" }
            pluginHelper.onFrameworkDetached()
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag onDetachedFromEngine() : " }
        }
    }

    private fun emitEvent(methodName: String, payload: String) {
        try {
            GlobalResources.mainThread.post {
                try {
                    methodChannel?.invokeMethod(methodName, payload)
                } catch (t: Throwable) {
                    Logger.print(LogLevel.ERROR, t) { "$tag emitEvent() : " }
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag emitEvent() : " }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Logger.print { "$tag onAttachedToActivity() : Attached To Activity" }
        flutterPluginBinding?.binaryMessenger?.let { initPlugin(it) }
    }

    override fun onDetachedFromActivity() {
        Logger.print { "$tag onDetachedFromActivity() : Resetting methodChannel to `null`" }
        methodChannel = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        Logger.print { "$tag onDetachedFromActivityForConfigChanges() : Detached From Activity for Config changes" }
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Logger.print { "$tag onReattachedToActivityForConfigChanges() : ReAttached To Activity for Config changes" }
    }

    companion object {
        internal var methodChannel: MethodChannel? = null
        internal var flutterPluginBinding: FlutterPluginBinding? = null
    }
}
