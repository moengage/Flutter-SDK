package com.moengage.sampleapp

import android.content.Intent
import android.content.res.Configuration
import android.os.Bundle
import android.util.Log
import com.moengage.flutter.MoEFlutterHelper.Companion.getInstance
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        processIntent(intent)
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        Log.d("MainActivity", " : onConfigurationChanged() : ${newConfig.orientation}")
        // Checks the orientation of the screen
        getInstance().onConfigurationChanged()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        //    GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        processIntent(intent)
    }

    private fun processIntent(intent: Intent?) {
        if (intent == null) return
        Log.d("MainActivity", " : processIntent() : ${intent.data}")
    }
}