package com.moengage.sampleapp;

import com.moengage.core.LogLevel;
import com.moengage.core.MoEngage;
import com.moengage.core.MoEngage.Builder;
import com.moengage.core.config.FcmConfig;
import com.moengage.core.config.LogConfig;
import com.moengage.core.config.MiPushConfig;
import com.moengage.core.config.PushKitConfig;
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
        .configureNotificationMetaData(
            new NotificationConfig(
                R.drawable.icon,
                R.drawable.ic_launcher,
                -1,
                false,
                true,
                true))
        .configureLogs(new LogConfig(LogLevel.VERBOSE, true))
        .configureFcm(new FcmConfig(true))
        .configurePushKit(new PushKitConfig(true))
        .configureMiPush(new MiPushConfig("MI_APP_ID", "MI_APP_KEY", true));

    MoEInitializer.initialiseDefaultInstance(moEngage);
    // optional, required in-case notification customisation is required.
    MoEPushHelper.getInstance().registerMessageListener(new CustomPushListener());
  }
}
