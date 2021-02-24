package com.moengage.sampleapp;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import com.moengage.core.internal.logger.Logger;
import com.moengage.plugin.base.PluginPushCallback;

/**
 * @author Umang Chamaria
 * Date: 2020/12/06
 */
public class CustomPushListener extends PluginPushCallback {

  private static final String TAG = "CustomPushListener";

  @Override public void onHandleRedirection(Activity activity, Bundle payload) {
    super.onHandleRedirection(activity, payload);
    Logger.v(TAG + " onHandleRedirection() : ");
  }

  @Override public void onNotificationReceived(Context context, Bundle payload) {
    super.onNotificationReceived(context, payload);
    Logger.v(TAG + " onNotificationReceived() : ");
  }
}
