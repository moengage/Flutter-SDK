package com.moengage.flutter.sample

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

/**
 * MoEngageSamplePlugin - Android bridge for the `moengage_sample` reference/scaffold module.
 */
class MoEngageSamplePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(
        @NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding,
    ) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        @NonNull call: MethodCall,
        @NonNull result: Result,
    ) {
        when (call.method) {
            METHOD_NAME_GREET -> greet(call, result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(
        @NonNull binding: FlutterPlugin.FlutterPluginBinding,
    ) {
        channel.setMethodCallHandler(null)
    }

    private fun greet(
        call: MethodCall,
        result: Result,
    ) {
        val payload = call.arguments as? String ?: return
        val appId = JSONObject(payload).getJSONObject(KEY_ACCOUNT_META).getString(KEY_APP_ID)
        result.success("Hello from MoEngage Sample (Android), appId: $appId")
    }
}
