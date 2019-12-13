package com.moengage.flutter;

import android.net.Uri;
import android.os.Bundle;
import com.moengage.inapp.InAppManager;
import com.moengage.inapp.InAppMessage;
import java.util.HashMap;
import java.util.Map;

/**
 * @author Umang Chamaria
 * Date: 2019-12-12
 */
public class FlutterInAppCallback implements InAppManager.InAppMessageListener {
  @Override public void onInAppShown(InAppMessage message) {
    Map<String, Object> messageMap = new HashMap<>();
    messageMap.put("campaignId", message.rules.campaignId);
    MoEngageFlutterPlugin.sendOrQueueCallback(Constants.METHOD_NAME_ON_INAPP_SHOWN, messageMap);
  }

  @Override public boolean showInAppMessage(InAppMessage message) {
    return false;
  }

  @Override public void onInAppClosed(InAppMessage message) {

  }

  @Override public boolean onInAppClick(String screenName, Bundle extras, Uri deepLinkUri) {
    Map<String, Object> message = new HashMap<>();
    if (screenName != null) {
      message.put("screenName", screenName);
    }
    if (deepLinkUri != null) {
      message.put("deeplinkUrl", deepLinkUri.toString());
    }
    if (extras != null) {
      message.putAll(Utils.bundleToMap(extras));
    }
    MoEngageFlutterPlugin.sendOrQueueCallback(Constants.METHOD_NAME_ON_INAPP_CLICKED, message);
    return true;
  }
}
