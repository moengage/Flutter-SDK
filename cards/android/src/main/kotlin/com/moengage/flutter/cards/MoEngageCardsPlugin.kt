package com.moengage.flutter.cards

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.moengage.core.LogLevel
import com.moengage.core.internal.logger.Logger
import com.moengage.plugin.base.cards.CardsPluginHelper
import com.moengage.plugin.base.cards.internal.setCardsEventEmitter
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MoEngageCardsPlugin : FlutterPlugin {

    private lateinit var channel: MethodChannel

    private val tag = "${MODULE_TAG}MoEngageCardsPlugin"

    lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        try {
            channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
            context = flutterPluginBinding.applicationContext
            initPlugin(flutterPluginBinding.binaryMessenger)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag onAttachedToEngine()  : " }
        }
    }

    private fun initPlugin(binaryMessenger: BinaryMessenger) {
        try {
            channel = MethodChannel(binaryMessenger, CHANNEL_NAME)
            channel.setMethodCallHandler(PlatformMethodCallHandler(context))
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
