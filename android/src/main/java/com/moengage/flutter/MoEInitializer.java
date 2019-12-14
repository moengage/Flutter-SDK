package com.moengage.flutter;

import com.moengage.core.ConfigurationCache;
import com.moengage.core.MoEngage;
import com.moengage.inapp.InAppManager;
import com.moengage.push.PushManager;

/**
 * @author Umang Chamaria
 * Date: 2019-12-03
 */
public class MoEInitializer{

  public static void initialize(MoEngage moEngage) {
    MoEngage.initialise(moEngage);
    ConfigurationCache.getInstance().setIntegrationType(Constants.INTEGRATION_TYPE);
    ConfigurationCache.getInstance().setIntegrationVersion(BuildConfig.MOENGAGE_FLUTTER_LIBRARY_VERSION);
    PushManager.getInstance().setMessageListener(new FlutterPushMessageListener());
    InAppManager.getInstance().setInAppListener(new FlutterInAppCallback());
  }
}
