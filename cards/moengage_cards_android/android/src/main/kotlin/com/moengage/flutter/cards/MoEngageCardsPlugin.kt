package com.moengage.flutter.cards

import android.content.Context
import com.moengage.core.LogLevel
import com.moengage.core.internal.global.GlobalResources
import com.moengage.core.internal.logger.Logger
import com.moengage.plugin.base.cards.CardsPluginHelper
import com.moengage.plugin.base.cards.internal.setCardsEventEmitter
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MoEngageCardsPlugin : FlutterPlugin, ActivityAware {

    private val tag = "${MODULE_TAG}MoEngageCardsPlugin"

    private val cardsPluginHelper: CardsPluginHelper by lazy { CardsPluginHelper() }

    lateinit var context: Context
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        try {
            context = flutterPluginBinding.applicationContext
            if (methodChannel == null) {
                initPlugin(flutterPluginBinding.binaryMessenger)
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag onAttachedToEngine()  : " }
        }
    }

    private fun initPlugin(binaryMessenger: BinaryMessenger) {
        try {
            Logger.print { "$tag initPlugin(): Initializing MoEngage Cards Plugin" }
            methodChannel = MethodChannel(binaryMessenger, CHANNEL_NAME)
            methodChannel?.setMethodCallHandler(
                PlatformMethodCallHandler(
                    context,
                    cardsPluginHelper
                )
            )
            setCardsEventEmitter(EventEmitterImpl(::emitEvent))
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag initPlugin()  : " }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        try {
            Logger.print { "$tag onDetachedFromEngine() : Detaching the Framework" }
            cardsPluginHelper.onFrameworkDetached()
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

    /**
     * Called when the plugin is attached to Flutter Activity.
     * @param binding instance of [ActivityPluginBinding]
     */
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Logger.print { "$tag onAttachedToActivity() : Attached To Activity" }
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
    }
}
