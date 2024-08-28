package com.moengage.flutter.geofence

import android.content.Context
import androidx.annotation.NonNull
import com.moengage.core.LogLevel
import com.moengage.core.internal.logger.Logger
import com.moengage.plugin.base.geofence.internal.GeofencePluginHelper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** MoEngage Geofence Plugin */
class MoEngageGeofencePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    private val tag = "MoEngageGeofencePlugin"
    private lateinit var context: Context
    private val geofenceHelper = GeofencePluginHelper()

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    @Suppress("SENSELESS_COMPARISON")
    override fun onMethodCall(
        call: MethodCall,
        result: Result,
    ) {
        try {
            if (call == null) {
                Logger.print(LogLevel.ERROR) {
                    "$tag onMethodCall() : MethodCall instance is null cannot proceed further."
                }
                return
            }
            if (context == null) {
                Logger.print(LogLevel.ERROR) {
                    "$tag onMethodCall() : Context is null cannot proceed further."
                }
                return
            }
            Logger.print { "$tag onMethodCall() : Method: ${call.method}" }
            when (call.method) {
                METHOD_NAME_START_GEOFENCE_MONITORING -> startGeofenceMonitoring(call)
                METHOD_NAME_STOP_GEOFENCE_MONITORING -> stopGeofenceMonitoring(call)
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag onMethodCall() : " }
        }
    }

    override fun onDetachedFromEngine(
        @NonNull binding: FlutterPlugin.FlutterPluginBinding,
    ) {
        channel.setMethodCallHandler(null)
    }

    private fun startGeofenceMonitoring(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag startGeofenceMonitoring() : $payload" }
            geofenceHelper.startGeofenceMonitoring(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) {
                "$tag startGeofenceMonitoring() : "
            }
        }
    }

    private fun stopGeofenceMonitoring(methodCall: MethodCall) {
        try {
            if (methodCall.arguments == null) return
            val payload = methodCall.arguments.toString()
            Logger.print { "$tag stopGeofenceMonitoring() : $payload" }
            geofenceHelper.stopGeofenceMonitoring(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) {
                "$tag stopGeofenceMonitoring() : "
            }
        }
    }
}