package com.example.flutter_demo

import android.Manifest
import android.content.Context
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.text.TextUtils
import android.util.Log
import android.widget.Toast
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.flutterplugin.FlutterPlugin
import com.example.first_plugin.FirstPlugin
import com.example.first_plugin.SMSReceiver
import com.example.first_plugin.SMSobserver
import com.example.img_ext.ImgExtPlugin

class MainActivity : FlutterActivity() {
    private lateinit var smsReceiver : SMSReceiver
    private val SMS_ACTION = "android.provider.Telephony.SMS_RECEIVED"

    private lateinit var smSobserver : SMSobserver;

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.e("xxxx", "MainActivity")
//        Toast.makeText(this, "mainactivity ", Toast.LENGTH_LONG).show()
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        FlutterPlugin.registerWith(flutterEngine, this)

        val firstPlugin = flutterEngine.plugins[FirstPlugin::class.java]
        val imgExtPlugin = flutterEngine.plugins[ImgExtPlugin::class.java]

        Log.e("xxxx", "firstPlugin = $firstPlugin , imgExtPlugin = $imgExtPlugin")
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

//        registerReceiver(this)

//         smSobserver = SMSobserver(this)
//        contentResolver.registerContentObserver(Uri.parse("content://sms"),true, smSobserver);
    }



    private fun registerReceiver(context: Context) {
        smsReceiver = SMSReceiver();
        val intentFilter = IntentFilter()
        intentFilter.addAction(SMS_ACTION)
        intentFilter.priority = Int.MAX_VALUE
        context.registerReceiver(smsReceiver, intentFilter)

        smsReceiver.setOnReceivedMessageListener {
            Log.e("FirstPlugin", "------------- onnReceivedMessage -----------------$it")
            if (!TextUtils.isEmpty(it)) {
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
//        unregisterReceiver(smsReceiver)
//        contentResolver.unregisterContentObserver(smSobserver)
    }


}
