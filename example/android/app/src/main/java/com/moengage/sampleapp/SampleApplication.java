package com.moengage.sampleapp;

import com.moengage.core.LogLevel;
import com.moengage.core.MoEngage;
import com.moengage.core.MoEngage.Builder;
import com.moengage.core.config.FcmConfig;
import com.moengage.core.config.LogConfig;
import com.moengage.core.config.MiPushConfig;
import com.moengage.core.config.NotificationConfig;
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
    MoEngage.Builder moEngage = new MoEngage.Builder(this, "DAO6UGZ73D9RTK8B5W96TPYN")
        .configureNotificationMetaData(new NotificationConfig(R.drawable.icon, R.drawable.ic_launcher, -1, null, true,false, true))
        .configureLogs(new LogConfig(LogLevel.VERBOSE, true))
        .configureFcm(new FcmConfig(true))
        .configureMiPush(new MiPushConfig("2882303761518042309", "5601804211309", true));

    MoEInitializer.initialize(getApplicationContext(), moEngage);
    // optional, required in-case notification customisation is required.
    MoEPushHelper.getInstance().setMessageListener(new CustomPushListener());
  }
}
