package com.moengage.flutter.personalize

import android.content.Context
import com.moengage.campaigns.personalize.PersonalizationHelper
import com.moengage.core.LogLevel
import com.moengage.core.internal.logger.Logger
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MoEngagePersonalizePlugin : FlutterPlugin, ActivityAware {
    private val tag = "${MODULE_TAG}MoEngagePersonalizePlugin"

    private val personalizationHelper: PersonalizationHelper by lazy { PersonalizationHelper() }

    lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        try {
            Logger.print { "$tag onAttachedToEngine() : Registering MoEngagePersonalizePlugin" }
            context = binding.applicationContext
            flutterPluginBinding = binding
            if (methodChannel == null) {
                initPlugin(binding.binaryMessenger)
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag onAttachedToEngine()  : " }
        }
    }

    private fun initPlugin(binaryMessenger: BinaryMessenger) {
        try {
            Logger.print { "$tag initPlugin(): Initializing MoEngage Personalize Plugin" }
            methodChannel = MethodChannel(binaryMessenger, CHANNEL_NAME)
            methodChannel?.setMethodCallHandler(
                PlatformMethodCallHandler(
                    context,
                    personalizationHelper,
                ),
            )
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag initPlugin()  : " }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        try {
            Logger.print { "$tag onDetachedFromEngine() : Detaching the Framework" }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag onDetachedFromEngine() : " }
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
