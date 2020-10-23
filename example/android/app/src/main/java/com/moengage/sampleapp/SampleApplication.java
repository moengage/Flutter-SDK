package com.moengage.sampleapp;

import com.moengage.core.Logger;
import com.moengage.core.MoEngage;
import com.moengage.core.MoEngage.Builder;
import com.moengage.flutter.MoEInitializer;
import io.flutter.app.FlutterApplication;

/**
 * @author Umang Chamaria
 * Date: 2019-12-13
 */
public class SampleApplication extends FlutterApplication {

  @Override public void onCreate() {
    super.onCreate();
    MoEngage.Builder builder = new Builder(this, "DAO6UGZ73D9RTK8B5W96TPYN")
        .setLogLevel(Logger.VERBOSE)
        .setNotificationSmallIcon(R.drawable.icon)
        .setNotificationLargeIcon(R.drawable.ic_launcher)
        .optOutDefaultInAppDisplay()
        .setLogLevel(Logger.VERBOSE)
        .enablePushKitTokenRegistration();

    MoEInitializer.initialize(getApplicationContext(), builder);
  }
}
