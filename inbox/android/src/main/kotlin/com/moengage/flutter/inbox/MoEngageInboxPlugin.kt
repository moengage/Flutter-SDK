package com.moengage.flutter.inbox

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.moengage.core.LogLevel
import com.moengage.core.internal.logger.Logger
import com.moengage.flutter.inbox.BuildConfig.MOENGAGE_INBOX_FLUTTER_LIBRARY_VERSION
import com.moengage.plugin.base.inbox.internal.InboxPluginHelper
import com.moengage.plugin.base.inbox.internal.inboxDataToJson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.Executors

/** MoengageInboxPlugin */
class MoEngageInboxPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private val tag = "MoEngageInboxPlugin"
    private lateinit var context: Context
    private val executorService = Executors.newCachedThreadPool()
    private val mainThread = Handler(Looper.getMainLooper())
    private val inboxHelper = InboxPluginHelper()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        inboxHelper.logPluginMeta(INTEGRATION_TYPE, MOENGAGE_INBOX_FLUTTER_LIBRARY_VERSION)
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    @Suppress("SENSELESS_COMPARISON")
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        try {
            if (call == null) {
                Logger.print(LogLevel.ERROR) {
                    "$tag onMethodCall() : MethodCall instance is null " +
                            "cannot proceed further."
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
                METHOD_NAME_UN_CLICKED_COUNT -> getUnClickedCount(call, result)
                METHOD_NAME_FETCH_MESSAGES -> fetchMessages(call, result)
                METHOD_NAME_DELETE_MESSAGE -> deleteMessage(call, result)
                METHOD_NAME_TRACK_CLICKED -> trackMessageClicked(call, result)
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag onMethodCall() : " }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getUnClickedCount(c: MethodCall, result: Result) {
        try {
            if (c.arguments == null) return
            val payload: String = c.arguments.toString()
            Logger.print { "$tag getUnClickedCount() : Will fetch unclicked count" }
            executorService.submit {
                val countJson = inboxHelper.getUnClickedMessagesCount(context, payload)
                Logger.print { "$tag getUnClickedCount() : Count: $countJson" }
                mainThread.post {
                    try {
                        result.success(countJson)
                    } catch (t: Throwable) {
                        Logger.print(LogLevel.ERROR, t) { "$tag getUnClickedCount() : " }
                    }
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag getUnClickedCount() : " }
        }
    }

    private fun fetchMessages(call: MethodCall, result: Result) {
        try {
            if (call.arguments == null) return
            val payload: String = call.arguments.toString()
            val inboxData = inboxHelper.fetchAllMessages(context, payload) ?: return
            executorService.submit {
                val serialisedMessages = inboxDataToJson(inboxData)
                mainThread.post {
                    try {
                        Logger.print { "$tag fetchMessages() : serialisedMessages: $serialisedMessages" }
                        result.success(serialisedMessages.toString())
                    } catch (t: Throwable) {
                        Logger.print(LogLevel.ERROR, t) { "$tag fetchMessages() : " }
                    }
                }
            }
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag fetchMessages() : " }
        }
    }

    private fun deleteMessage(call: MethodCall, result: Result) {
        try {
            if (call.arguments == null) return
            val payload = call.arguments.toString()
            Logger.print { "$tag deleteMessage() : Argument :$payload" }
            inboxHelper.deleteMessage(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag deleteMessage() : " }
        }
    }

    private fun trackMessageClicked(call: MethodCall, result: Result) {
        try {
            if (call.arguments == null) return
            val payload = call.arguments.toString()
            Logger.print { "$tag trackMessageClicked() : Argument :$payload" }
            inboxHelper.trackMessageClicked(context, payload)
        } catch (t: Throwable) {
            Logger.print(LogLevel.ERROR, t) { "$tag trackMessageClicked() : " }
        }
    }
}
