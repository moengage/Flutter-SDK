package com.moengage.sampleapp;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import androidx.annotation.NonNull;
import com.moengage.core.internal.logger.Logger;
import com.moengage.plugin.base.push.PluginPushCallback;

/**
 * @author Umang Chamaria
 * Date: 2020/12/06
 */
public class CustomPushListener extends PluginPushCallback {

  private static final String TAG = "CustomPushListener";

  public CustomPushListener() {
    super();
  }

  @Override public void handleCustomAction(@NonNull Context context, @NonNull String payload) {
    super.handleCustomAction(context, payload);
    Logger.print(() -> TAG + " handleCustomAction() : ");
  }

  @Override public void onNotificationClick(@NonNull Activity activity, @NonNull Bundle payload) {
    super.onNotificationClick(activity, payload);
    Logger.print(() -> TAG + " onNotificationClick() : ");
  }
}
