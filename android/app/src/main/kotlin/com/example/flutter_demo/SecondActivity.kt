package com.example.flutter_demo

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.flutterplugin.FlutterPlugin
import com.example.first_plugin.FirstPlugin
import com.example.first_plugin.SMSReceiver
import com.example.img_ext.ImgExtPlugin


class SecondActivity : AppCompatActivity() {

    private val SMS_PERMISSION_CODE = 10110

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.two_activity_layout)

//        var imgExtPlugin: ImgExtPlugin;


        Log.e("xxxx", "------------- SecondActivity -----------------")
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
                Log.e("xxxx", "SecondActivity click")
            }


        if (hasPermission(Manifest.permission.READ_SMS)) {
            Log.e("xxxx", "SecondActivity 有短信读取权限")
        } else {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                Log.e("xxxx", "SecondActivity 开始申请读取短信权限")
                requestPermissions(arrayOf(Manifest.permission.READ_SMS, Manifest.permission.RECEIVE_SMS, Manifest.permission.SEND_SMS), SMS_PERMISSION_CODE)
            }
        }
    }

    private fun hasPermission(permission: String): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            permission
        ) == PackageManager.PERMISSION_GRANTED
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        Log.e("xxxx", "SecondActivity requestCode = $requestCode")
        when (requestCode) {
            SMS_PERMISSION_CODE -> {
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {// 表示用户同意授权
                    Log.e("xxxx", "SecondActivity 用户同意了读取短信权限")
                } else {
                    Toast.makeText(this, "请去设置中打开读取短信权限", Toast.LENGTH_LONG).show()
                }
            }

        }
    }

}