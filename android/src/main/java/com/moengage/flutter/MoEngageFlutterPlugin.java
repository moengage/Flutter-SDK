package com.moengage.flutter;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import androidx.annotation.NonNull;
import com.moe.pushlibrary.MoEHelper;
import com.moengage.core.Logger;
import com.moengage.inapp.MoEInAppHelper;
import com.moengage.plugin.base.PluginHelper;
import com.moengage.plugin.base.model.PushService;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;

import static com.moengage.flutter.ConstantsKt.METHOD_NAME_ENABLE_SDK_LOGS;
import static com.moengage.flutter.ConstantsKt.METHOD_NAME_INITIALISE;
import static com.moengage.flutter.ConstantsKt.METHOD_NAME_LOGOUT;
import static com.moengage.flutter.ConstantsKt.METHOD_NAME_OPT_OUT_TRACKING;
import static com.moengage.flutter.ConstantsKt.METHOD_NAME_PUSH_PAYLOAD;
import static com.moengage.flutter.ConstantsKt.METHOD_NAME_PUSH_TOKEN;
import static com.moengage.flutter.ConstantsKt.METHOD_NAME_RESET_APP_CONTEXT;
import static com.moengage.flutter.ConstantsKt.METHOD_NAME_SELF_HANDLED_INAPP;
import static com.moengage.flutter.ConstantsKt.METHOD_NAME_SET_ALIAS;
import static com.moengage.flutter.ConstantsKt.METHOD_NAME_SET_APP_CONTEXT;
import static com.moengage.flutter.ConstantsKt.METHOD_NAME_SET_APP_STATUS;
import static com.moengage.flutter.ConstantsKt.METHOD_NAME_SET_USER_ATTRIBUTE;
import static com.moengage.flutter.ConstantsKt.METHOD_NAME_SET_USER_ATTRIBUTE_LOCATION;
import static com.moengage.flutter.ConstantsKt.METHOD_NAME_SET_USER_ATTRIBUTE_TIMESTAMP;
import static com.moengage.flutter.ConstantsKt.METHOD_NAME_SHOW_IN_APP;
import static com.moengage.flutter.ConstantsKt.METHOD_NAME_TRACK_EVENT;

public class MoEngageFlutterPlugin implements FlutterPlugin, MethodCallHandler {

  private static final String TAG = "MoEngageFlutterPlugin";
  private static Context context;
  private static final Map<String,String> messageQueue =
      Collections.synchronizedMap(new LinkedHashMap<String, String>());
  private static boolean isInitialised;
  private static MethodChannel channel;
  private static final PluginHelper pluginHelper = new PluginHelper();

  public static void registerWith(Registrar registrar) {
    Logger.v(TAG + " registerWith() : Registering MoEngageFlutterPlugin");
    context = registrar.context();
    initPlugin(registrar.messenger());
  }

  @Override public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    Logger.v(TAG + " onAttachedToEngine() : Registering MoEngageFlutterPlugin");
    context = binding.getApplicationContext();
    initPlugin(binding.getBinaryMessenger());
  }

  @Override public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    Logger.v(TAG + " onDetachedFromEngine() : Registering MoEngageFlutterPlugin");
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    try {
      if (call == null) {
        Logger.e(TAG + " onMethodCall() : MethodCall instance is null cannot proceed "
            + "further.");
        return;
      }
      if (context == null) {
        Logger.e(TAG + " onMethodCall() : Context is null cannot proceed further.");
        return;
      }

      Logger.v(TAG + " onMethodCall() : Method " + call.method);

      switch (call.method) {
        case METHOD_NAME_INITIALISE:
          onInitialised();
          pluginHelper.initialize();
          break;
        case METHOD_NAME_ENABLE_SDK_LOGS:
          enableSDKLogs();
          break;
        case METHOD_NAME_SET_USER_ATTRIBUTE:
          setUserAttribute(call);
          break;
        case METHOD_NAME_SET_USER_ATTRIBUTE_LOCATION:
          setUserLocation(call);
          break;
        case METHOD_NAME_TRACK_EVENT:
          trackEvent(call);
          break;
        case METHOD_NAME_SHOW_IN_APP:
          MoEInAppHelper.getInstance().showInApp(context);
          break;
        case METHOD_NAME_LOGOUT:
          MoEHelper.getInstance(context).logoutUser();
          break;
        case METHOD_NAME_SET_ALIAS:
          setAlias(call);
          break;
        case METHOD_NAME_SET_APP_STATUS:
          setAppStatus(call);
          break;
        case METHOD_NAME_SET_USER_ATTRIBUTE_TIMESTAMP:
          setTimestamp(call);
          break;
        case METHOD_NAME_SELF_HANDLED_INAPP:
          getSelfHandledInAPP(call);
          break;
        case METHOD_NAME_SET_APP_CONTEXT:
          setAppContext(call);
          break;
        case METHOD_NAME_RESET_APP_CONTEXT:
          resetAppContext();
          break;
        case METHOD_NAME_PUSH_PAYLOAD:
          passPushPayload(call);
          break;
        case METHOD_NAME_PUSH_TOKEN:
          passPushToken(call);
          break;
        case METHOD_NAME_OPT_OUT_TRACKING:
          optOutTracking(call);

        default:
          Logger.e(TAG + " onMethodCall() : No mapping for this method.");
      }
    } catch (Exception e) {
      Logger.e(TAG + " onMethodCall() : ", e);
    }
  }

  private static void initPlugin(BinaryMessenger binaryMessenger) {
    channel = new MethodChannel(binaryMessenger, "flutter_moengage_plugin");
    MoEngageFlutterPlugin plugin = new MoEngageFlutterPlugin();
    channel.setMethodCallHandler(plugin);
    pluginHelper.setEventCallback(new EventEmitterImpl());
  }

  private void onInitialised() {
    Logger.v(TAG + " onInitialised() : MoEngage Flutter plugin initialised.");
    Logger.v(TAG + " onInitialised() : Message queue: " + messageQueue);
    isInitialised = true;
    synchronized (messageQueue) {
      // Handle all the messages received before the Dart isolate was
      // initialized, then clear the queue.
      for (Entry<String, String> entry : messageQueue.entrySet()) {
        sendCallback(entry.getKey(), entry.getValue());
      }
      messageQueue.clear();
    }
  }

  private void enableSDKLogs() {
    pluginHelper.enableSDKLogs();
  }

  private void setUserAttribute(MethodCall methodCall) {
    try {
      if (methodCall.arguments == null) return;

      String payload =  methodCall.arguments.toString();
      Logger.v(TAG + " setUserAttribute() : Arguments: " + payload);

      pluginHelper.setUserAttribute(context, payload);
    } catch (Exception e) {
      Logger.e(TAG + " setUserAttribute() : exception: ", e);
    }
  }

  private void setUserLocation(MethodCall methodCall) {
    try {
      if (methodCall.arguments == null) return;

      String payload =  methodCall.arguments.toString();
      Logger.v(TAG + " setUserLocation() : Argument: " + payload);

      pluginHelper.setUserAttribute(context, payload);
    } catch (Exception e) {
      Logger.e(TAG + " setUserLocation() : exception: ", e);
    }
  }

  private void trackEvent(MethodCall methodCall) {
    try {
      if (methodCall.arguments == null) {
        Logger.e(TAG + " trackEvent() : Arguments are null, cannot trackEvent");
        return;
      }
      String payload =  (String) methodCall.arguments;
      Logger.v(TAG + " trackEvent() : Argument :" + payload);

      pluginHelper.trackEvent(context, payload);
    } catch (Exception e) {
      Logger.e(TAG + " trackEvent() : exception: ", e);
    }
  }

  private void setAlias(MethodCall methodCall) {
    try {
      if (methodCall.arguments == null) return;

      String payload =  methodCall.arguments.toString();
      Logger.v(TAG + " setAlias() : Argument :" + payload);

      pluginHelper.setAlias(context, payload);
    } catch (Exception e) {
      Logger.e(TAG + " setAlias() : exception: ", e);
    }
  }

  private void setAppStatus(MethodCall methodCall) {
    try {
      if (methodCall.arguments == null) return;

      String payload =  methodCall.arguments.toString();
      Logger.v(TAG + " setAppStatus() : Argument :" + payload);

      pluginHelper.setAppStatus(context, payload);
    } catch (Exception e) {
      Logger.e(TAG + " setAppStatus() : exception: ", e);
    }
  }

  private void setTimestamp(MethodCall methodCall) {
    try {
      if (methodCall.arguments == null) return;

      String payload =  methodCall.arguments.toString();
      Logger.v(TAG + " setTimestamp() : Arguments: " + payload);

      pluginHelper.setUserAttribute(context, payload);
    } catch (Exception e) {
      Logger.e(TAG + " setTimestamp() : exception: ", e);
    }
  }

  private void getSelfHandledInAPP(MethodCall methodCall) {
    pluginHelper.getSelfHandledInApp(context);
  }

  private void setAppContext(MethodCall methodCall) {
    try {
      if (methodCall.arguments == null) return;

      String payload =  methodCall.arguments.toString();
      Logger.v(TAG + " setAppContext() : Arguments: " + payload);

      pluginHelper.setAppContext(context, payload);
    } catch (Exception e) {
      Logger.e(TAG + " setAppContext() : exception: ", e);
    }
  }

  private void resetAppContext() {
    pluginHelper.resetAppContext(context);
  }

  private void passPushToken(MethodCall methodCall) {
    try {
      if (methodCall.arguments == null) return;

      String payload =  methodCall.arguments.toString();
      Logger.v(TAG + " passPushToken() : Arguments: " + payload);

      pluginHelper.passPushToken(context, payload, PushService.FCM);
    } catch (Exception e) {
      Logger.e(TAG + " passPushToken() : exception: ", e);
    }
  }

  private void passPushPayload(MethodCall methodCall) {
    try {
      if (methodCall.arguments == null) return;

      String payload =  methodCall.arguments.toString();
      Logger.v(TAG + " passPushPayload() : Arguments: " + payload);

      pluginHelper.passPushPayload(context, payload,
          PushService.FCM);
    } catch (Exception e) {
      Logger.e(TAG + " passPushPayload() : exception: ", e);
    }
  }

  private void optOutTracking(MethodCall methodCall) {
    try {
      if (methodCall.arguments == null) return;

      String payload =  methodCall.arguments.toString();
      Logger.v(TAG + " optOutTracking() : Arguments: " + payload);

      pluginHelper.optOutTracking(context, payload);
    } catch (Exception e) {
      Logger.e(TAG + " optOutTracking() : exception: ", e);
    }
  }

  static void sendOrQueueCallback(String methodName, String message) {
    if (isInitialised) {
      Logger.v(TAG + " sendOrQueueCallback() : Flutter Engine initialised will send message");
      sendCallback(methodName, message);
    } else {
      Logger.v(TAG + " sendOrQueueCallback() : Flutter Engine not initialised adding message to "
          + "queue");
      messageQueue.put(methodName, message);
    }
  }

  private static void sendCallback(final String methodName, final String message) {
    new Handler(Looper.getMainLooper()).post(new Runnable() {
      @Override public void run() {
        channel.invokeMethod(methodName, message);
      }
    });
  }

}