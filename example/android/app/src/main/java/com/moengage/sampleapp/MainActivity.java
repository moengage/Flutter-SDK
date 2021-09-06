package com.moengage.sampleapp;

import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import com.moengage.inapp.MoEInAppHelper;
import com.moengage.core.internal.logger.Logger;
import android.content.res.Configuration;
import  com.moengage.flutter.MoEFlutterHelper;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
  }

  @Override
  public void onConfigurationChanged(Configuration newConfig) {
    super.onConfigurationChanged(newConfig);
    Logger.v("MainActivity : onConfigurationChanged() : " + newConfig.orientation);
    // Checks the orientation of the screen
//    MoEFlutterHelper.getInstance().onConfigurationChanged();
  }
}
