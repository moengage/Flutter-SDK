package com.moengage.flutter.sribuu

import android.app.Application
import android.content.Context
import com.moengage.core.LogLevel
import com.moengage.core.MoEngage
import com.moengage.core.config.LogConfig
import com.moengage.flutter.core.MoEInitializer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class SribuuCallHandler(
        private val context: Context,
        private val sribuuChannel: MethodChannel,
        private val tag: String) : MethodChannel.MethodCallHandler {

    @Suppress("SENSELESS_COMPARISON")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        System.out.println("================================ [sribuu plugin] onMethodCall ================================")
        if (call.method.equals("configureMoEngage")) {
            configureMoEngage()
        }
    }

    private fun configureMoEngage() {
        System.out.println("================================ [sribuu plugin] configureMoEngage (start) ================================")

        val appId = "P8WBQ4TY4B5RZ6TX8129B79X"
//        val appId = "P8WBQ4TY4B5RZ6TX8129B79X"
        val moEngage = MoEngage.Builder( context as Application, appId).configureLogs(LogConfig(LogLevel.VERBOSE, true))
        MoEInitializer.initialize(context, moEngage)

        System.out.println("================================ [sribuu plugin] configureMoEngage (end) ================================")
    }
}
