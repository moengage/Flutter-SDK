package com.moengage.sampleapp

import android.content.res.Configuration
import android.os.Bundle
import android.util.Log
import com.moengage.flutter.MoEFlutterHelper.Companion.getInstance
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        Log.d("MainActivity", " : onConfigurationChanged() : " + newConfig.orientation)
        // Checks the orientation of the screen
        getInstance().onConfigurationChanged()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        //    GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}