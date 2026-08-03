package com.moengage.flutter.<featureName>

import android.content.Context
import com.moengage.core.LogLevel
import com.moengage.core.internal.global.GlobalResources
import com.moengage.core.internal.logger.Logger
import com.moengage.plugin.base.<featureName>.<featureNameCamel>PluginHelper
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PlatformMethodCallHandler(
    private val context: Context,
    private val pluginHelper: <featureNameCamel>PluginHelper,
) : MethodChannel.MethodCallHandler {
    private val tag = "${MODULE_TAG}PlatformMethodCallHandler"

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            if (call.arguments == null) {
                Logger.print(LogLevel.ERROR) { "$tag onMethodCall() ${call.method}: Arguments null" }
                return
            }
            Logger.print { "$tag onMethodCall() : Method: ${call.method}" }
            when (call.method) {
                METHOD_INITIALIZE -> initialize(call)
                // Fire-and-forget: METHOD_<NAME> -> <methodName>(call)
                // Result method:   METHOD_<NAME> -> <methodName>(call, result)
                else -> {
                    Logger.print(LogLevel.ERROR) { "$tag onMethodCall() : Method Not supported : ${call.method}" }
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag onMethodCall() : " }
        }
    }

    // Fire-and-forget example
    private fun initialize(call: MethodCall) {
        try {
            val payload = call.arguments.toString()
            Logger.print { "$tag initialize() : $payload" }
            pluginHelper.initialise(payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR) { "$tag initialize() : " }
        }
    }

    // Result method example (runs on executor, posts result on main thread)
    private fun getExampleResult(call: MethodCall, result: MethodChannel.Result) {
        try {
            val payload = call.arguments.toString()
            Logger.print { "$tag getExampleResult() : $payload" }
            GlobalResources.executor.submit {
                val data = pluginHelper.getExampleResult(context, payload)
                GlobalResources.mainThread.post {
                    try {
                        Logger.print { "$tag getExampleResult(): Result : $data" }
                        result.success(data)
                    } catch (t: Throwable) {
                        Logger.print(LogLevel.ERROR, t) { "$tag getExampleResult() : " }
                    }
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag getExampleResult() : " }
        }
    }
}
