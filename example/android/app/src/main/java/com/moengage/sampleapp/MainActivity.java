package com.moengage.sampleapp;

import android.os.Bundle;
import android.util.Log;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import com.moengage.inapp.MoEInAppHelper;
import com.moengage.core.internal.logger.Logger;
import android.content.res.Configuration;
import  com.moengage.flutter.MoEFlutterHelper;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
  }

  @Override
  public void onConfigurationChanged(Configuration newConfig) {
    super.onConfigurationChanged(newConfig);
    Log.d("MainActivity", " : onConfigurationChanged() : " + newConfig.orientation);
    // Checks the orientation of the screen
//    MoEFlutterHelper.getInstance().onConfigurationChanged();
  }

  @Override public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    GeneratedPluginRegistrant.registerWith(flutterEngine);
  }
}
