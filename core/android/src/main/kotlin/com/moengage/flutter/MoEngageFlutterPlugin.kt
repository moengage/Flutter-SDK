package com.moengage.flutter

import android.content.Context
import com.moengage.core.internal.logger.Logger
import com.moengage.flutter.core.CORE_MODULE_TAG
import com.moengage.flutter.core.CoreCallHandler
import com.moengage.flutter.core.FLUTTER_PLUGIN_CORE_CHANNEL_NAME
import com.moengage.flutter.sribuu.FLUTTER_PLUGIN_SRIBUU_CHANNEL_NAME
import com.moengage.flutter.sribuu.SRIBUU_MODULE_TAG
import com.moengage.flutter.sribuu.SribuuCallHandler
import com.moengage.plugin.base.PluginHelper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MoEngageFlutterPlugin : FlutterPlugin {
    private val coreTag = "${CORE_MODULE_TAG}MoEngageFlutterPlugin"
    private val sribuuTag = "${SRIBUU_MODULE_TAG}MoEngageFlutterPlugin"

    private lateinit var context: Context
    private lateinit var coreChannel: MethodChannel
    private lateinit var sribuuChannel: MethodChannel
    private val corePluginHelper = PluginHelper()

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        Logger.v("onAttachedToEngine() : Registering MoEngageFlutterPlugin")
        context = binding.applicationContext
        initPlugins(binding)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        try {
            Logger.v("onDetachedFromEngine() : Registering MoEngageFlutterPlugin")
            removePlugins()
        } catch (e: Exception) {
            Logger.e("onDetachedFromEngine() ", e)
        }
    }

    private fun initPlugins(binding: FlutterPluginBinding) {
        initSribuuPlugin(binding.binaryMessenger)
        initCorePlugin(binding.binaryMessenger)
    }

    private fun removePlugins() {
        removeCorePlugin()
        removeSribuuPlugin()
    }

    private fun initCorePlugin(binaryMessenger: BinaryMessenger) {
        try {
            coreChannel = MethodChannel(binaryMessenger, FLUTTER_PLUGIN_CORE_CHANNEL_NAME)
            val coreCallHandler = CoreCallHandler(context, coreChannel, corePluginHelper, coreTag)
            coreChannel.setMethodCallHandler(coreCallHandler)
            coreCallHandler.init();
        } catch (ex: Exception) {
            Logger.e("$coreTag initCorePlugin() : exception : ", ex)
        }
    }

    private fun removeCorePlugin() {
        corePluginHelper.onFrameworkDetached()
        coreChannel.setMethodCallHandler(null)
    }

    private fun initSribuuPlugin(binaryMessenger: BinaryMessenger) {
        try {
            sribuuChannel = MethodChannel(binaryMessenger, FLUTTER_PLUGIN_SRIBUU_CHANNEL_NAME)
            val sribuuCallHandler = SribuuCallHandler(context, sribuuChannel, sribuuTag)
            sribuuChannel.setMethodCallHandler(sribuuCallHandler)
        } catch (ex: Exception) {
            Logger.e("$sribuuTag initSribuuPlugin() : exception : ", ex)
        }
    }

    private fun removeSribuuPlugin() {
        sribuuChannel.setMethodCallHandler(null)
    }
}
