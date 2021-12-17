package com.moengage.flutter.sribuu

import android.app.Application
import android.content.Context
import com.moengage.core.LogLevel
import com.moengage.core.MoEngage
import com.moengage.core.config.LogConfig
import com.moengage.core.internal.logger.Logger
import com.moengage.flutter.core.MoEInitializer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class SribuuCallHandler(
        private val context: Context,
        private val sribuuChannel: MethodChannel,
        private val tag: String) : MethodChannel.MethodCallHandler {

    @Suppress("SENSELESS_COMPARISON")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            if (call == null) {
                Logger.e(
                        "$tag onMethodCall() : MethodCall instance is null cannot proceed "
                                + "further."
                )
                return
            }
            if (context == null) {
                Logger.e("$tag onMethodCall() : Context is null cannot proceed further.")
                return
            }
            Logger.v(tag + " onMethodCall() : Method " + call.method)
            when (call.method) {
                METHOD_NAME_CONFIGURE_MOENGAGE -> configureMoEngage(call)
                else -> Logger.e("$tag onMethodCall() : No mapping for this method.")
            }
        } catch (e: Exception) {
            Logger.e("$tag onMethodCall() : exception: ", e)
        }
    }

    private fun configureMoEngage(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null || methodCall.argument<String>("appId") == null) return
            val appId = methodCall.argument<String>("appId")

            val moEngage = MoEngage.Builder( context as Application, appId!!).configureLogs(LogConfig(LogLevel.VERBOSE, true))
            MoEInitializer.initialize(context, moEngage)
        } catch (e: Exception) {
            Logger.e("$tag setUserAttribute() : exception: ", e)
        }
    }
}
