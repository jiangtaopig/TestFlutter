package com.example.first_plugin

import android.content.Context
import android.content.IntentFilter
import android.text.TextUtils
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.util.Log

/** FirstPlugin */
class FirstPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var smsReceiver : SMSReceiver
  private val SMS_ACTION = "android.provider.Telephony.SMS_RECEIVED"

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.e("FirstPlugin", "------------- onAttachedToEngine -----------------")

    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "first_plugin")
    channel.setMethodCallHandler(this)
    registerReceiver(flutterPluginBinding.applicationContext)
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
        invokeFlutterWithSMSCode(it)
      }
    }
  }

  private fun invokeFlutterWithSMSCode(smsCode : String) {
    channel.invokeMethod("AndroidInvokeFlutter2", smsCode)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    Log.e("FirstPlugin", "------------- onAttachedToEngine --------------channel---$channel")
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
//    binding.applicationContext.unregisterReceiver(smsReceiver)
  }


}
