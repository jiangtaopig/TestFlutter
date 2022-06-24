package com.example.flutter_demo

import android.os.Bundle
import android.util.Log
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.flutterplugin.FlutterPlugin

class SecondActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.two_activity_layout)

        val result: MethodChannel.Result = object : MethodChannel.Result {
            override fun success(result: Any?) {
                Log.e("xxxx", "result = $result")
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {

            }
            override fun notImplemented() {

            }
        }

        findViewById<Button>(R.id.btn_jump2)
            .setOnClickListener {
                FlutterPlugin.invokeFlutter(result)
            }
    }
}