package io.flutter.plugins.flutterplugin;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import com.example.flutter_demo.SecondActivity;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.img_ex.BitmapUtil;

public class FlutterPlugin implements MethodChannel.MethodCallHandler {

    public static final String CHANNEL = "com.example.flutter_demo/jump_plugin";
    static MethodChannel channel;

    private Activity activity;


    private FlutterPlugin(Activity activity) {
        this.activity = activity;
    }

    public static void registerWith(FlutterEngine flutterEngine, FlutterActivity activity) {
        channel = new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL);
        FlutterPlugin instance = new FlutterPlugin(activity);
        //setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);
    }

    /**
     * native 调用 flutter 的方法，有返回值
     */
    public static void invokeFlutter(MethodChannel.Result result) {
        // Native告诉Flutter要调用的方法是send（）
        Log.e("xxxxx", "invokeFlutter");
        channel.invokeMethod("AndroidInvokeFlutter", "我是native传递过来的参数", result);
    }

    /**
     * native 调用 flutter 的方法，无返回值
     */
    public static void invokeFlutter() {
        // Native告诉Flutter要调用的方法是send（）
        Log.e("xxxxx", "invokeFlutter");
        channel.invokeMethod("AndroidInvokeFlutter", "我是native传递过来的参数");
    }

    @RequiresApi(api = Build.VERSION_CODES.Q)
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        //通过MethodCall可以获取参数和方法名，然后再寻找对应的平台业务
        //接收来自flutter的指令，jump2SecondActivity 跳转到原生的第二个页面
        if (call.method.equals("jump2SecondActivity")) {
            //跳转到指定Activity
            Intent intent = new Intent(activity, SecondActivity.class);
            activity.startActivity(intent);

            //返回给flutter的参数
            result.success("success");
        }
        //接收来自flutter的指令，获取flutter传递过来的参数
        else if (call.method.equals("mapData")) {
            //解析参数
            String value = call.argument("flutter");
            String path = call.argument("path");
            String uriStr = call.argument("uriStr");

            Log.v("debug", value + " , path = "+ path + " , uriStr = " + uriStr);
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    if (activity.checkSelfPermission(Manifest.permission.ACCESS_MEDIA_LOCATION)
                            != PackageManager.PERMISSION_GRANTED) {

                        activity.requestPermissions(new String[]{Manifest.permission.ACCESS_MEDIA_LOCATION},
                                10011);
                    } else {
                        Log.d("zhu", "有权限了");
                        Map<String, String> res = BitmapUtil.getImageLatitudeFromData(uriStr, activity, null);
                        Toast.makeText(activity, "结果>>>"+res.get("latitude")+" , " + res.get("longitude")
                                , Toast.LENGTH_LONG).show();
                    }
                } else {
                    byte[] bytes = readFile(value);
                    BitmapUtil.getImageLatitudeFromData(path, activity, bytes);
                }

            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }

            Toast.makeText(activity, value, Toast.LENGTH_SHORT).show();
            //返回给flutter的参数
            result.success("success");
        }
        //接收来自flutter的指令，flutter调用原生方法传多个参数并取得返回值
        else if (call.method.equals("getNativeResult")) {
            //解析参数
            String value1 = call.argument("key1");
            String value2 = call.argument("key2");
            Log.v("debug", value1 + value2);

            //返回给flutter的参数
            result.success("success");
        } else if (call.method.equals("goBack")) {
            //flutter返回到上一页原生界面
            Toast.makeText(activity, activity.getClass().getName(), Toast.LENGTH_SHORT).show();
            activity.finish();
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
}
