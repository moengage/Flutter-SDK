package com.moengage.sampleapp;

import com.moengage.core.LogLevel;
import com.moengage.core.MoEngage;
import com.moengage.core.MoEngage.Builder;
import com.moengage.flutter.MoEInitializer;
import com.moengage.pushbase.MoEPushHelper;
import io.flutter.app.FlutterApplication;

/**
 * @author Umang Chamaria
 * Date: 2019-12-13
 */
public class SampleApplication extends FlutterApplication {

  @Override public void onCreate() {
    super.onCreate();
    MoEngage.Builder builder = new Builder(this, "DAO6UGZ73D9RTK8B5W96TPYN")
        .setNotificationSmallIcon(R.drawable.icon)
        .setNotificationLargeIcon(R.drawable.ic_launcher)
        .optOutDefaultInAppDisplay()
        .enableLogs(LogLevel.VERBOSE)
        .enablePushKitTokenRegistration();

    MoEInitializer.initialize(getApplicationContext(), builder);
    // optional, required in-case notification customisation is required.
    MoEPushHelper.getInstance().setMessageListener(new CustomPushListener());
  }
}
