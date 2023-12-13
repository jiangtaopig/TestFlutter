package com.example.first_plugin;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.telephony.SmsMessage;
import android.text.TextUtils;
import android.util.Log;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 小米手机要在权限中打卡 短信通知权限
 * 华为手机要在短信设置界面中，关闭 ‘禁止第3方获取短信验证码的功能’
 */
public class SMSReceiver extends BroadcastReceiver {

    private final String PATTERN_REGEX = "(?<!\\d)\\d{4,6}(?!\\d)";

    private MessageListener mMessageListener;

    public void setOnReceivedMessageListener(MessageListener messageListener) {
        this.mMessageListener = messageListener;

        // TODO 测试代码要移除的
        new Handler(Looper.getMainLooper()).postDelayed(() -> {
            Log.e("xxxx", "SMSReceiver test");
            mMessageListener.onReceived("123456");
        }, 3000);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        Log.e("短信内容", "--------------- onReceive -------------- ");
        //获取短信数据
        Object[] objs = (Object[]) intent.getExtras().get("pdus");
        for (Object obj : objs) {
            byte[] pdu = (byte[]) obj;
            //将字节数组封装成为smsMessage对象
            SmsMessage sms = SmsMessage.createFromPdu(pdu);
            //获得短短信内容
            String message = sms.getMessageBody();
            Log.e("短信内容", "message：" + message);
            // 短息的手机号。。+86开头？
            String from = sms.getOriginatingAddress();
            Log.e("短信来源", "from ：" + from);
            if (!TextUtils.isEmpty(from)) {
                String code = patternCode(message);
                if (!TextUtils.isEmpty(code)) {
                    mMessageListener.onReceived(code);
                }
            }
        }
    }

    /**
     * 匹配短信中间的4-6个数字（验证码等）
     */
    private String patternCode(String patternContent) {
        if (TextUtils.isEmpty(patternContent)) {
            return "";
        }
        Pattern p = Pattern.compile(PATTERN_REGEX);
        Matcher matcher = p.matcher(patternContent);
        if (matcher.find()) {
            return matcher.group();
        }
        return null;
    }

    // 回调接口
    public interface MessageListener {
        void onReceived(String message);
    }
}
