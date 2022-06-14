package com.example.flutter_demo

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.flutterplugin.FlutterPlugin

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.e("xxxx", "MainActivity")
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        FlutterPlugin.registerWith(flutterEngine, this)
        FlutterPlugin.invokeFlutter();
    }
}
