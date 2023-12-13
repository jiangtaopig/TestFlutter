package com.example.img_ext;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * ImgExtPlugin
 */
public class ImgExtPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    private final static String TAG = "ImgExtPlugin";

    private MethodChannel channel;

    private Context context;

    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Log.e(TAG, "---- onAttachedToEngine -----");
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "img_ext");
        channel.setMethodCallHandler(this);
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        Log.e(TAG, "onMethodCall  ---- " + call.method);
        if (call.method.equals("getImgInfo")) {
            //解析参数
            String value = call.argument("flutter");
            String path = call.argument("path");
            String uriStr = call.argument("uriStr");

            Log.d(TAG, value + " , path = " + path + " , uriStr = " + uriStr + " , Build.VERSION.SDK_INT = " + Build.VERSION.SDK_INT);
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    if (context.checkSelfPermission(Manifest.permission.ACCESS_MEDIA_LOCATION)
                            != PackageManager.PERMISSION_GRANTED) {

                        activity.requestPermissions(new String[]{Manifest.permission.ACCESS_MEDIA_LOCATION},
                                10011);
                    } else {
                        Log.d(TAG, "有权限了");
                        Toast.makeText(context, "有权限了", Toast.LENGTH_SHORT).show();
                        Map<String, String> res = BitmapUtil.getImageLatitudeFromData(uriStr, context, null);
                        Toast.makeText(context, "结果>>>" + res.get("latitude") + " , " + res.get("longitude")
                                , Toast.LENGTH_LONG).show();
                    }
                } else {
                    Log.d(TAG, "-----------------ttttt-----------------------------");
//                    byte[] bytes = readFile(path);
                    Toast.makeText(context, "低于 Android 10", Toast.LENGTH_SHORT).show();
                    BitmapUtil.getImageLatitudeFromData("", context, path);

                }
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
            Toast.makeText(context, value, Toast.LENGTH_SHORT).show();
            //返回给flutter的参数
            result.success("success");

        } else if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else {
            result.notImplemented();
        }
    }

    private byte[] readFile(String imagePath) {
        File file = new File(imagePath);
        if (file.isFile()) {
            InputStream in = null;
            ByteArrayOutputStream os = new ByteArrayOutputStream();
            try {
                in = new FileInputStream(file);

                byte[] b = new byte[1024];
                int len;
                while ((len = in.read(b, 0, 1024)) != -1) {
                    os.write(b, 0, len);
                }
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    in.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            return os.toByteArray();
        } else {
            System.out.println("文件不存在！");
        }
        return null;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }


    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        Log.e(TAG, "---- onAttachedToActivity -----");
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }
}
