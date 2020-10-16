package com.moengage.flutter;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import androidx.annotation.NonNull;
import com.moe.pushlibrary.MoEHelper;
import com.moe.pushlibrary.PayloadBuilder;
import com.moe.pushlibrary.models.GeoLocation;
import com.moengage.core.Logger;
import com.moengage.core.MoEUtils;
import com.moengage.core.model.AppStatus;
import com.moengage.inapp.MoEInAppHelper;
import com.moengage.push.PushManager;
import com.moengage.pushbase.MoEPushHelper;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;

public class MoEngageFlutterPlugin implements FlutterPlugin, MethodCallHandler {

  private static final String TAG = "MoEngageFlutterPlugin";
  private static Context context;
  private static final Map<String, Map<String, Object>> messageQueue =
      Collections.synchronizedMap(new LinkedHashMap<String, Map<String, Object>>());
  private static boolean isInitialised;
  private static MethodChannel channel;

  public static void registerWith(Registrar registrar) {
    Logger.v(TAG + " registerWith() : Registering MoEngageFlutterPlugin");
    channel =
        new MethodChannel(registrar.messenger(), "flutter_moengage_plugin");
    MoEngageFlutterPlugin plugin = new MoEngageFlutterPlugin();
    channel.setMethodCallHandler(plugin);
    context = registrar.context();
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    try {
      if (call == null) {
        Logger.e(TAG + " onMethodCall() : MethodCall instance is null cannot proceed further.");
        return;
      }
      if (context == null) {
        Logger.e(TAG + " onMethodCall() : Context is null cannot proceed further.");
        return;
      }

      Logger.v(TAG + " onMethodCall() : Method " + call.method);

      switch (call.method) {
        case Constants.METHOD_NAME_INITIALISE:
          onInitialised();
          break;

        case Constants.METHOD_NAME_ENABLE_SDK_LOGS:
          enableSDKLogs();
          break;
        case Constants.METHOD_NAME_SET_USER_ATTRIBUTE:
          setUserAttribute(call);
          break;
        case Constants.METHOD_NAME_SET_USER_ATTRIBUTE_LOCATION:
          setUserLocation(call);
          break;
        case Constants.METHOD_NAME_TRACK_EVENT:
          trackEvent(call);
          break;
        case Constants.METHOD_NAME_SHOW_IN_APP:
          MoEInAppHelper.getInstance().showInApp(context);
          break;
        case Constants.METHOD_NAME_LOGOUT:
          MoEHelper.getInstance(context).logoutUser();
          break;
        case Constants.METHOD_NAME_SET_ALIAS:
          setAlias(call);
          break;
        case Constants.METHOD_NAME_SET_APP_STATUS:
          setAppStatus(call);
          break;
        case Constants.METHOD_NAME_SET_USER_ATTRIBUTE_TIMESTAMP:
          setTimestamp(call);
          break;
        case Constants.METHOD_NAME_SELF_HANDLED_INAPP:
          getSelfHandledInAPP(call);
          break;
        case Constants.METHOD_NAME_SET_APP_CONTEXT:
          setAppContext(call);
          break;
        case Constants.METHOD_NAME_RESET_APP_CONTEXT:
          resetAppContext();
          break;
        case Constants.METHOD_NAME_PUSH_PAYLOAD:
          passPushPayload(call);
          break;
        case Constants.METHOD_NAME_PUSH_TOKEN:
          passPushToken(call);
          break;
        default:
          Logger.e(TAG + " onMethodCall() : No mapping for this method.");
      }
    } catch (Exception e) {
      Logger.e(TAG + " onMethodCall() : ", e);
    }
  }

  private void onInitialised() {
    Logger.v(TAG + " onInitialised() : MoEngage Flutter plugin initialised.");
    Logger.v(TAG + " onInitialised() : Message queue: " + messageQueue);
    isInitialised = true;
    synchronized (messageQueue) {
      // Handle all the messages received before the Dart isolate was
      // initialized, then clear the queue.
      for (Entry<String, Map<String, Object>> entry : messageQueue.entrySet()) {
        sendCallback(entry.getKey(), entry.getValue());
      }
      messageQueue.clear();
    }
  }

  private void enableSDKLogs() {
    MoEHelper.getInstance(context).enableSDKLogs();
  }

  private void setUserAttribute(MethodCall methodCall) {
    if (methodCall.arguments == null) return;
    Logger.v(TAG + " setUserAttribute() : Arguments: " + methodCall.arguments.toString());
    if (!methodCall.hasArgument(ARGUMENT_ATTRIBUTE_NAME) || !methodCall.hasArgument(
        ARGUMENT_ATTRIBUTE_VALUE)) return;
    if (!(methodCall.argument(ARGUMENT_ATTRIBUTE_NAME) instanceof String)) return;
    String attributeName = methodCall.argument(ARGUMENT_ATTRIBUTE_NAME);
    Object attributeValue = methodCall.argument(ARGUMENT_ATTRIBUTE_VALUE);
    if (MoEUtils.isEmptyString(attributeName)) {
      Logger.e(TAG + " setUserAttribute() : Attribute name cannot be null or empty.");
      return;
    }
    if (attributeValue instanceof Integer) {
      MoEHelper.getInstance(context).setUserAttribute(attributeName, (int) attributeValue);
    } else if (attributeValue instanceof Double) {
      MoEHelper.getInstance(context).setUserAttribute(attributeName, (double) attributeValue);
    } else if (attributeValue instanceof Float) {
      MoEHelper.getInstance(context).setUserAttribute(attributeName, (float) attributeValue);
    } else if (attributeValue instanceof Boolean) {
      MoEHelper.getInstance(context).setUserAttribute(attributeName, (boolean) attributeValue);
    } else if (attributeValue instanceof Long) {
      MoEHelper.getInstance(context).setUserAttribute(attributeName, (long) attributeValue);
    } else if (attributeValue instanceof String) {
      MoEHelper.getInstance(context).setUserAttribute(attributeName,
          String.valueOf(attributeValue));
    }
  }

  private void setUserLocation(MethodCall methodCall) {
    if (methodCall.arguments == null) return;
    Logger.v(TAG + " setUserLocation() : Argument: " + methodCall.arguments.toString());
    if (!methodCall.hasArgument(ARGUMENT_ATTRIBUTE_NAME)) return;
    if (!methodCall.hasArgument(ARGUMENT_LATITUDE) || !methodCall.hasArgument(ARGUMENT_LONGITUDE))
      return;
    if (!(methodCall.argument(ARGUMENT_ATTRIBUTE_NAME) instanceof String)) return;
    String attributeName = methodCall.argument(ARGUMENT_ATTRIBUTE_NAME);
    if (MoEUtils.isEmptyString(attributeName)) {
      Logger.e(TAG + " setUserLocation() : Attribute name cannot be empty.");
      return;
    }
    MoEHelper.getInstance(context).setUserAttribute(attributeName,
        new GeoLocation((double) methodCall.argument(ARGUMENT_LATITUDE),
            (double) methodCall.argument(ARGUMENT_LONGITUDE)));
  }

  private void trackEvent(MethodCall methodCall) {
    if (methodCall.arguments == null) {
      Logger.e(TAG + " trackEvent() : Arguments are null, cannot trackEvent");
      return;
    }
    Logger.v(TAG + " trackEvent() : Argument :" + methodCall.arguments.toString());
    if (!methodCall.hasArgument(ARGUMENT_EVENT_NAME)) {
      Logger.e(TAG + " trackEvent() : Event name missing, cannot track event.");
      return;
    }
    if (!methodCall.hasArgument(ARGUMENT_EVENT_ATTRIBUTES)) {
      Logger.e(TAG + " trackEvent() : Event attributes missing cannot track event");
      return;
    }
    if (!(methodCall.argument(ARGUMENT_EVENT_NAME) instanceof String)) {
      Logger.e(TAG + " trackEvent() : Event name should be a string. Cannot track event "
          + "otherwise.");
      return;
    }
    String eventName = methodCall.argument(ARGUMENT_EVENT_NAME);
    if (MoEUtils.isEmptyString(eventName)) {
      Logger.e(TAG + " trackEvent() : Event name cannot be empty, cannot track event.");
      return;
    }
    if (!methodCall.hasArgument(ARGUMENT_EVENT_ATTRIBUTES)) {
      Logger.e(TAG + " trackEvent() : Event attributes missing. Cannot track attributes.");
      return;
    }
    if (!(methodCall.argument(ARGUMENT_EVENT_ATTRIBUTES) instanceof HashMap)) {
      Logger.e(TAG + " trackEvent() : Event attributes should be of type HashMap. Cannot track "
          + "event without that.");
      return;
    }
    PayloadBuilder builder = new PayloadBuilder();
    HashMap<String, Object> attributes = methodCall.argument(ARGUMENT_EVENT_ATTRIBUTES);
    if (attributes == null) {
      Logger.e(TAG + " trackEvent() : Attributes are null. cannot track event.");
      return;
    }
    appendGeneralAttributes(attributes.get(ARGUMENT_GENERAL_EVENT_ATTRIBUTES), builder);
    appendTimeStampAttributes(attributes.get(ARGUMENT_TIMESTAMP_EVENT_ATTRIBUTES), builder);
    appendLocationAttributes(attributes.get(ARGUMENT_LOCATION_EVENT_ATTRIBUTES), builder);
    if (methodCall.hasArgument(ARGUMENT_IS_NON_INTERACTIVE_EVENT) && (boolean) methodCall.argument(
        ARGUMENT_IS_NON_INTERACTIVE_EVENT)) {
      builder.setNonInteractive();
    }
    MoEHelper.getInstance(context).trackEvent(eventName, builder);
  }

  private void appendGeneralAttributes(Object attributes, PayloadBuilder builder) {
    if (attributes == null) return;
    if (!(attributes instanceof HashMap)) return;
    @SuppressWarnings("unchecked")
    HashMap<String, Object> attributesMap = (HashMap) attributes;
    if (attributesMap.size() == 0) return;
    for (Entry entry : attributesMap.entrySet()) {
      builder.putAttrObject(String.valueOf(entry.getKey()), entry.getValue());
    }
  }

  private void appendTimeStampAttributes(Object attributes, PayloadBuilder builder) {
    if (attributes == null) return;
    if (!(attributes instanceof HashMap)) return;
    @SuppressWarnings("unchecked")
    HashMap<String, String> attributesMap = (HashMap) attributes;
    if (attributesMap.size() == 0) return;
    for (Entry<String, String> entry : attributesMap.entrySet()) {
      builder.putAttrISO8601Date(entry.getKey(), entry.getValue());
    }
  }

  private void appendLocationAttributes(Object attributes, PayloadBuilder builder) {
    if (attributes == null) return;
    if (!(attributes instanceof HashMap)) return;
    @SuppressWarnings("unchecked")
    HashMap<String, Map<String, Double>> attributesMap = (HashMap) attributes;
    if (attributesMap.size() == 0) return;
    for (Entry<String, Map<String, Double>> entry : attributesMap.entrySet()) {
      Map<String, Double> location = entry.getValue();
      builder.putAttrLocation(entry.getKey(),
          new GeoLocation(location.get(ARGUMENT_LATITUDE), location.get(ARGUMENT_LONGITUDE)));
    }
  }

  private void setAlias(MethodCall methodCall) {
    if (methodCall.arguments == null) return;
    Logger.v(TAG + " setAlias() : Arguments: " + methodCall.arguments);
    if (!methodCall.hasArgument(ARGUMENT_ATTRIBUTE_VALUE)) return;
    if (!(methodCall.argument(ARGUMENT_ATTRIBUTE_VALUE) instanceof String)) return;
    MoEHelper.getInstance(context)
        .setAlias(String.valueOf(methodCall.argument(ARGUMENT_ATTRIBUTE_VALUE)));
  }

  private void setAppStatus(MethodCall methodCall) {
    if (methodCall.arguments == null) return;
    if (!methodCall.hasArgument(ARGUMENT_ATTRIBUTE_VALUE)) return;
    if (!(methodCall.argument(ARGUMENT_ATTRIBUTE_VALUE) instanceof String)) return;
    String appStatus = methodCall.argument(ARGUMENT_ATTRIBUTE_VALUE);
    if (MoEUtils.isEmptyString(appStatus)) {
      Logger.e(TAG + " setAppStatus() : App Status cannot be null or empty, cannot track app "
          + "status.");
      return;
    }
    MoEHelper.getInstance(context).setAppStatus(AppStatus.valueOf(appStatus.trim().toUpperCase()));
  }


  private void setTimestamp(MethodCall methodCall) {
    if (methodCall.arguments == null) return;
    Logger.v(TAG + " setTimestamp() : Arguments: " + methodCall.arguments);
    if (!methodCall.hasArgument(ARGUMENT_ATTRIBUTE_NAME) || !methodCall.hasArgument(
        ARGUMENT_ATTRIBUTE_VALUE)) return;
    if (!(methodCall.argument(ARGUMENT_ATTRIBUTE_NAME) instanceof String)) return;
    if (!(methodCall.argument(ARGUMENT_ATTRIBUTE_VALUE) instanceof String)) return;
    String attributeName = methodCall.argument(ARGUMENT_ATTRIBUTE_NAME);
    String attributeValue = methodCall.argument(ARGUMENT_ATTRIBUTE_VALUE);
    if (MoEUtils.isEmptyString(attributeName) || MoEUtils.isEmptyString(attributeValue)) return;
    MoEHelper.getInstance(context).setUserAttributeISODate(attributeName, attributeValue);
  }

  private void getSelfHandledInAPP(MethodCall methodCall) {

  }

  private void setAppContext(MethodCall methodCall) {

  }

  private void resetAppContext() {

  }

  private void passPushToken(MethodCall methodCall) {
    if (methodCall.arguments == null) return;
    Logger.v(TAG + " passPushToken() : Arguments: " + methodCall.arguments);
    if (!methodCall.hasArgument(ARGUMENT_PUSH_TOKEN)) return;
    if (!(methodCall.argument(ARGUMENT_PUSH_TOKEN) instanceof String)) return;
    String pushToken = methodCall.argument(ARGUMENT_PUSH_TOKEN);
    PushManager.getInstance().refreshToken(context, pushToken);
  }

  private void passPushPayload(MethodCall methodCall) {
    if (methodCall.arguments == null) return;
    Logger.v(TAG + " passPushPayload() : Arguments: " + methodCall.arguments);
    if (!methodCall.hasArgument(ARGUMENT_PUSH_PAYLOAD)) return;
    if (!(methodCall.argument(ARGUMENT_PUSH_PAYLOAD) instanceof HashMap)) return;
    HashMap<String, String> payload = methodCall.argument(ARGUMENT_PUSH_PAYLOAD);
    if (payload == null) return;
    MoEPushHelper.getInstance().handlePushPayload(context, payload);
  }

  static void sendOrQueueCallback(String methodName, Map<String, Object> message) {
    if (isInitialised) {
      Logger.v(TAG + " sendOrQueueCallback() : Flutter Engine initialised will send message");
      sendCallback(methodName, message);
    } else {
      Logger.v(TAG + " sendOrQueueCallback() : Flutter Engine not initialised adding message to "
          + "queue");
      messageQueue.put(methodName, message);
    }
  }

  static void  sendCallback(final String methodName, final Map<String, Object> message){
    final Map<String, Object> messagePayload = new HashMap<>();
    messagePayload.put(Constants.PARAM_PLATFORM, Constants.PARAM_PLATFORM_VALUE);
    messagePayload.put(Constants.PARAM_PAYLOAD, message);
    new Handler(Looper.getMainLooper()).post(new Runnable() {
      @Override public void run() {
        channel.invokeMethod(methodName, messagePayload);
      }
    });
  }

  private static final String ARGUMENT_ATTRIBUTE_NAME = "attributeName";
  private static final String ARGUMENT_ATTRIBUTE_VALUE = "attributeValue";
  private static final String ARGUMENT_PUSH_TOKEN = "pushToken";
  private static final String ARGUMENT_PUSH_PAYLOAD = "pushPayload";

  private static final String ARGUMENT_EVENT_NAME = "eventName";
  private static final String ARGUMENT_EVENT_ATTRIBUTES = "eventAttributes";
  private static final String ARGUMENT_GENERAL_EVENT_ATTRIBUTES = "generalAttributes";
  private static final String ARGUMENT_LOCATION_EVENT_ATTRIBUTES = "locationAttributes";
  private static final String ARGUMENT_TIMESTAMP_EVENT_ATTRIBUTES = "dateTimeAttributes";
  private static final String ARGUMENT_IS_NON_INTERACTIVE_EVENT = "isNonInteractive";
  private static final String ARGUMENT_LATITUDE = "latitude";
  private static final String ARGUMENT_LONGITUDE = "longitude";

  @Override public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {

  }

  @Override public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

  }
}