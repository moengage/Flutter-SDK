package com.moengage.flutter.inbox

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.moengage.core.internal.logger.Logger

import io.flutter.embedding.engine.plugins.FlutterPlugin
import com.moengage.flutter.inbox.BuildConfig.MOENGAGE_INBOX_FLUTTER_LIBRARY_VERSION
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.moengage.plugin.base.inbox.InboxPluginHelper
import java.util.concurrent.Executors

/** MoengageInboxPlugin */
class MoEngageInboxPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

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
    try{
      if (call == null) {
        Logger.e("$tag onMethodCall() : MethodCall instance is null cannot proceed further.")
        return
      }
      if (context == null) {
        Logger.e("$tag onMethodCall() : Context is null cannot proceed further.")
        return
      }
      Logger.v("$tag onMethodCall() : Method: ${call.method}")
      when(call.method){
        METHOD_NAME_UN_CLICKED_COUNT -> getUnClickedCount(call, result)
        METHOD_NAME_FETCH_MESSAGES -> fetchMessages(result)
        METHOD_NAME_DELETE_MESSAGE -> deleteMessage(call, result)
        METHOD_NAME_TRACK_CLICKED -> trackMessageClicked(call, result)
      }
    }catch(e: Exception){
        Logger.e("$tag onMethodCall() : ", e)
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun getUnClickedCount(call: MethodCall, result: Result){
    Logger.v("$tag getUnClickedCount() : Will fetch unclicked count")
    executorService.submit {
      val count = inboxHelper.getUnClickedMessagesCount(context)
      Logger.v("$tag getUnClickedCount() : Count: $count")
      mainThread.post {
        try {
          result.success(count)
        } catch (e: Exception) {
          Logger.e("$tag getUnClickedCount() : ", e)
        }
      }
    }
  }

  private fun fetchMessages(result: Result){
    executorService.submit {
      val messages = inboxHelper.fetchAllMessages(context)
      Logger.v("$tag fetchMessages() : Messages: $messages")
      val serialisedMessages = inboxHelper.serialiseInboxMessages(messages)
      if (serialisedMessages != null){
        mainThread.post {
          try {
            result.success(serialisedMessages.toString())
          } catch (e: Exception) {
            Logger.e("$tag fetchMessages() : ", e)
          }
        }
      }
    }
  }

  private fun deleteMessage(call: MethodCall, result: Result){
    try {
      if (call.arguments == null) return
      val payload: String = call.arguments as String
      inboxHelper.deleteMessage(context, payload)
    } catch (e: Exception) {
      Logger.e("$tag deleteMessage() : ", e)
    }
  }

  private fun trackMessageClicked(call: MethodCall, result: Result) {
    try{
      if (call.arguments == null) return
      val payload: String = call.arguments as String
      inboxHelper.trackMessageClicked(context, payload)
    }catch(e: Exception){
        Logger.e("$tag trackMessageClicked() : ", e)
    }
  }
}
