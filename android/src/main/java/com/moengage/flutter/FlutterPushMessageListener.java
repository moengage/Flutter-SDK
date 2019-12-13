package com.moengage.flutter;

import android.app.Activity;
import android.os.Bundle;
import com.moengage.core.Logger;
import com.moengage.pushbase.push.PushMessageListener;

/**
 * @author Umang Chamaria
 * Date: 2019-12-09
 */
public class FlutterPushMessageListener extends PushMessageListener {

  private static final String TAG = "FlutterPushMessageListener";

  @Override public void onHandleRedirection(Activity activity,final Bundle payload) {
    super.onHandleRedirection(activity, payload);
    Logger.v(TAG + " onHandleRedirection() : Received callback in flutter native");
    MoEngageFlutterPlugin.sendOrQueueCallback(Constants.METHOD_NAME_ON_PUSH_CLICK,
        Utils.bundleToMap(payload));
  }
}
