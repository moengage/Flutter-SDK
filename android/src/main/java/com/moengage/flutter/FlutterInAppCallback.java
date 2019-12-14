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
    messageMap.put(Constants.PARAM_CAMPAIGN_ID, message.rules.campaignId);
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
      message.put(Constants.PARAM_SCREEN_NAME, screenName);
    }
    if (deepLinkUri != null) {
      message.put(Constants.PARAM_DEEP_LINK, deepLinkUri.toString());
    }
    if (extras != null) {
      message.put(Constants.PARAM_KEY_VALUE_PAIR, Utils.bundleToMap(extras));
    }
    MoEngageFlutterPlugin.sendOrQueueCallback(Constants.METHOD_NAME_ON_INAPP_CLICKED, message);
    return true;
  }
}
