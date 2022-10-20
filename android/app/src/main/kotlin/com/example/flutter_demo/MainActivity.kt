package com.example.flutter_demo

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.flutterplugin.FlutterPlugin
import com.example.first_plugin.FirstPlugin

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.e("xxxx", "MainActivity")
//        Toast.makeText(this, "mainactivity ", Toast.LENGTH_LONG).show()
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        FlutterPlugin.registerWith(flutterEngine, this)


//        FlutterPlugin.invokeFlutter();
    }


}
