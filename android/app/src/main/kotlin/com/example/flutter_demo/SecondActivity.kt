package com.example.flutter_demo

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import io.flutter.plugins.flutterplugin.FlutterPlugin

class SecondActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.two_activity_layout)

        findViewById<Button>(R.id.btn_jump2)
            .setOnClickListener {
                FlutterPlugin.invokeFlutter()
            }
    }
}