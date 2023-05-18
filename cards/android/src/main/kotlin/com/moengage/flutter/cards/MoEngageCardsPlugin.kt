package com.moengage.flutter.cards

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.moengage.core.LogLevel
import com.moengage.core.internal.logger.Logger
import com.moengage.flutter.cards.internal.CHANNEL_NAME
import com.moengage.flutter.cards.internal.MODULE_TAG
import com.moengage.plugin.base.cards.CardsPluginHelper
import com.moengage.plugin.base.cards.internal.setCardsEventEmitter
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MoEngageCardsPlugin : FlutterPlugin {

    private lateinit var channel: MethodChannel

    private val tag = "${MODULE_TAG}MoEngageCardsPlugin"

    lateinit var context: Context

    private val cardsPluginHelper by lazy { CardsPluginHelper() }


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        context = flutterPluginBinding.applicationContext
        initPlugin(flutterPluginBinding.binaryMessenger)
    }

    private fun initPlugin(binaryMessenger: BinaryMessenger) {
        try {
            channel = MethodChannel(binaryMessenger, CHANNEL_NAME)
            channel.setMethodCallHandler(PlatformMethodCallHandler(context,cardsPluginHelper))
            setCardsEventEmitter(EventEmitterImpl(::emitEvent))
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag initPlugin()  : " }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun emitEvent(methodName: String, payload: String) {
        Handler(Looper.getMainLooper()).post {
            try {
                channel.invokeMethod(methodName, payload)
            } catch (t: Throwable) {
                Logger.print(LogLevel.ERROR, t) { "$tag emitEvent() : " }
            }
        }
    }
}
