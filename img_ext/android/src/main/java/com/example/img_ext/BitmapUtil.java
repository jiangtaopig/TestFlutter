package com.example.img_ext;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Bitmap;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.RequiresApi;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;


public class BitmapUtil {
    /**
     * 获取图片的经度
     *
     * @param path 图片绝对路径
     * @return 图片的经度
     */
    public static String getImageLongitude(String path) {
        String longitude = "";
        try {
            // 从指定路径下读取图片，并获取其EXIF信息
            ExifInterface exifInterface = new ExifInterface(path);
            // 获取图片的旋转信息
            String gpsLongitude = exifInterface.getAttribute(ExifInterface.TAG_GPS_LONGITUDE);
            String longitudeRef = exifInterface.getAttribute(ExifInterface.TAG_GPS_LONGITUDE_REF);
            longitude = StringUtils.convertRationalLatLonToFloat(gpsLongitude, longitudeRef) + "";
        } catch (Exception e) {
            e.printStackTrace();
        }

        Log.d("mrliuys 图片经度: ", longitude);
        return longitude;
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public static String getImageLongitudeFromData(byte[] data) {

        String longitude = "";

        InputStream inputStream = new ByteArrayInputStream(data);

        try {
            // 从指定路径下读取图片，并获取其EXIF信息
            ExifInterface exifInterface = new ExifInterface(inputStream);

            // 获取图片的旋转信息
            String gpsLongitude = exifInterface.getAttribute(ExifInterface.TAG_GPS_LONGITUDE);
            String longitudeRef = exifInterface.getAttribute(ExifInterface.TAG_GPS_LONGITUDE_REF);
            longitude = StringUtils.convertRationalLatLonToFloat(gpsLongitude, longitudeRef) + "";

        } catch (Exception e) {
            e.printStackTrace();
        }

        return longitude;
    }


    /**
     * 获取图片的纬度
     *
     * @param path 图片绝对路径
     * @return 图片的纬度
     */
    public static String getImageLatitude(String path) {
        String latitude = "";
        try {
            // 从指定路径下读取图片，并获取其EXIF信息
            ExifInterface exifInterface = new ExifInterface(path);
            // 获取图片的旋转信息
            String gpsLatitude = exifInterface.getAttribute(ExifInterface.TAG_GPS_LATITUDE);
            String latitudeRef = exifInterface.getAttribute(ExifInterface.TAG_GPS_LATITUDE_REF);
            latitude = StringUtils.convertRationalLatLonToFloat(gpsLatitude, latitudeRef) + "";
        } catch (Exception e) {
            e.printStackTrace();
        }

        Log.d("mrliuys 图片纬度: ", latitude);
        return latitude;
    }

    public static Map<String, String> getImageLatitudeFromData(String uriStr, Context context, String path) throws FileNotFoundException {
        String latitude = "";
        String longitude = "";

        Map<String, String> resultMap = new HashMap<>();

        try {
            ExifInterface exifInterface;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                Uri uri = MediaStore.setRequireOriginal(Uri.parse(uriStr));
                Log.e("zhu", "--------------------- 大于等于29----------------------------");
                InputStream inputStream = context.getContentResolver().openInputStream(uri);
                Log.e("zhu", "inputStream = " + inputStream);
                // 从指定路径下读取图片，并获取其EXIF信息
                exifInterface = new ExifInterface(inputStream);
            } else {
                exifInterface = new ExifInterface(path);
                Toast.makeText(context, " path = "+ path, Toast.LENGTH_LONG).show();
            }

            // 获取图片的旋转信息
            String gpsLatitude = exifInterface.getAttribute(ExifInterface.TAG_GPS_LATITUDE);
            String latitudeRef = exifInterface.getAttribute(ExifInterface.TAG_GPS_LATITUDE_REF);

            String gpsLongitude = exifInterface.getAttribute(ExifInterface.TAG_GPS_LONGITUDE);
            String longitudeRef = exifInterface.getAttribute(ExifInterface.TAG_GPS_LONGITUDE_REF);
            longitude = StringUtils.convertRationalLatLonToFloat(gpsLongitude, longitudeRef) + "";

            float[] latLong = new float[2];
            exifInterface.getLatLong(latLong);

            float lat = latLong[0];
            float lon = latLong[1];

            Toast.makeText(context, " lat = "+ lat, Toast.LENGTH_LONG).show();

            String originTime = exifInterface.getAttribute(ExifInterface.TAG_DATETIME_ORIGINAL);
            Log.d("zhujt 图片拍照时间: ", originTime + "...");

            resultMap.put("latitude", String.valueOf(lat));
            resultMap.put("longitude", String.valueOf(lon));
            resultMap.put("originTime", originTime);

            Log.e("zhujt", "gpsLatitude = " + gpsLatitude + " , latitudeRef = " + latitudeRef +
                    ", gpsLongitude = " + gpsLongitude + " , longitudeRef = " + longitudeRef
                    + " , lat = " + lat + " , lon = " + lon);
            latitude = StringUtils.convertRationalLatLonToFloat(gpsLatitude, latitudeRef) + "";
        } catch (Exception e) {
            e.printStackTrace();
        }

        Log.d("mrliuys 图片经纬度: ", longitude +" , " + latitude);
        return resultMap;
    }

    /**
     * 获取图片拍照时间
     *
     * @param path 图片绝对路径
     * @return 图片的拍照时间
     */
    public static String getImagePhotoTime(String path) {
        String photoTime = "";
        try {
            // 从指定路径下读取图片，并获取其EXIF信息
            ExifInterface exifInterface = new ExifInterface(path);
            // 获取图片的旋转信息
            String originTime = exifInterface.getAttribute(ExifInterface.TAG_DATETIME_ORIGINAL);
            Log.d("mrliuys 图片拍照时间: ", originTime + "...");
            return originTime;
//            photoTime = DateUtils.formatDate(Long.valueOf(originTime), DateUtils.TYPE_03) + "";
        } catch (Exception e) {
            photoTime = DateUtils.formatDate(new Date().getTime(), DateUtils.TYPE_03);
            e.printStackTrace();
        }
        return photoTime;
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public static String getImagePhotoTimeFromData(byte[] data) {
        String photoTime = "";
        InputStream inputStream = new ByteArrayInputStream(data);

        try {
            // 从指定路径下读取图片，并获取其EXIF信息
            ExifInterface exifInterface = new ExifInterface(inputStream);
            // 获取图片的旋转信息
            String originTime = exifInterface.getAttribute(ExifInterface.TAG_DATETIME_ORIGINAL);
            photoTime = DateUtils.getStringToDate(originTime, DateUtils.TYPE_03) + "";
        } catch (Exception e) {
            photoTime = DateUtils.formatDate(new Date().getTime(), DateUtils.TYPE_03);
            e.printStackTrace();
        }

        Log.d("mrliuys 图片拍照时间: ", photoTime);
        return photoTime;
    }

    public static Map<String, String> getImageAllInfo(String path) {
        Map<String, String> res = new HashMap<>();
        try {
            // 从指定路径下读取图片，并获取其EXIF信息
            ExifInterface exifInterface = new ExifInterface(path);
            Class<ExifInterface> cls = ExifInterface.class;
            Field[] fields = cls.getFields();
            for (int i = 0; i < fields.length; i++) {
                String fieldName = fields[i].getName();
                if (!StringUtils.isEmpty(fieldName) && fieldName.startsWith("TAG")) {
                    String fieldValue = fields[i].get(cls).toString();
                    String attribute = exifInterface.getAttribute(fieldValue);
                    if (attribute != null) {
                        res.put(fieldValue, attribute);
                    }
                }
            }
            //设置旋转角度为0
            res.put(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL + "");
        } catch (Exception e) {
            e.printStackTrace();
        }


        Log.d("mrliuys 获取图片信息: ", res.toString());

        return res;
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public static Map<String, String> getImageAllInfoFromData(byte[] data) {
        Map<String, String> res = new HashMap<>();

        InputStream inputStream = new ByteArrayInputStream(data);

        try {
            // 从指定路径下读取图片，并获取其EXIF信息
            ExifInterface exifInterface = new ExifInterface(inputStream);
            Class<ExifInterface> cls = ExifInterface.class;
            Field[] fields = cls.getFields();
            for (int i = 0; i < fields.length; i++) {
                String fieldName = fields[i].getName();
                if (!StringUtils.isEmpty(fieldName) && fieldName.startsWith("TAG")) {
                    String fieldValue = fields[i].get(cls).toString();
                    String attribute = exifInterface.getAttribute(fieldValue);
                    if (attribute != null) {
                        res.put(fieldValue, attribute);
                    }
                }
            }
            //设置旋转角度为0
            res.put(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL + "");
        } catch (Exception e) {
            e.printStackTrace();
        }


//        Log.d("mrliuys 获取图片信息: ", res.toString());

        return res;
    }


    public static boolean saveImageInfo(String path, Map<String, String> map) {
        Boolean isSave = false;
        try {
            ExifInterface newExif = new ExifInterface(path);
            for (String key : map.keySet()) {
                newExif.setAttribute(key, map.get(key));
            }
            //设置旋转角度为0
            newExif.setAttribute(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL + "");
            newExif.saveAttributes();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return isSave;
    }


    @RequiresApi(api = Build.VERSION_CODES.N)
    public static byte[] saveImageInfoFromData(byte[] data, Map<String, String> map) {

        ByteArrayOutputStream os = new ByteArrayOutputStream();
        InputStream inputStream = new ByteArrayInputStream(data);
        try {
            ExifInterface newExif = new ExifInterface(inputStream);
            for (String key : map.keySet()) {
                newExif.setAttribute(key, map.get(key));
            }
            //设置旋转角度为0
            newExif.setAttribute(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL + "");
            newExif.saveAttributes();

            os = getOutputStream(inputStream);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return os.toByteArray();


    }

    public static ByteArrayOutputStream getOutputStream(InputStream inputStream) {

        InputStream in = inputStream;
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        try {
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
        return os;

    }


////    /**
////     * 把旧的图片信息写入到压缩后的图片中去
////     * @param oldFilePath
////     * @param newFilePath
////     * @throws Exception
////     */
//    public static void saveExif(String oldFilePath, String newFilePath) throws Exception {
//        ExifInterface oldExif=new ExifInterface(oldFilePath);
//        ExifInterface newExif=new ExifInterface(newFilePath);
//        Class<ExifInterface> cls = ExifInterface.class;
//        Field[] fields = cls.getFields();
//        for (int i = 0; i < fields.length; i++) {
//            String fieldName = fields[i].getName();
//            if (!TextUtils.isEmpty(fieldName) && fieldName.startsWith("TAG")) {
//                String fieldValue = fields[i].get(cls).toString();
//                String attribute = oldExif.getAttribute(fieldValue);
//                if (attribute != null) {
////                    LogUtils.i("fieldValue--"+fieldValue+"attribute----"+attribute);
//                    newExif.setAttribute(fieldValue, attribute);
//                }
//            }
//        }
//        //设置旋转角度为0
//        newExif.setAttribute(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL+"");
//        newExif.saveAttributes();
//    }

    /* 图片质量压缩 */
    public static byte[] ImageJPEGRepresentation(Bitmap bm, double quality) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        bm.compress(Bitmap.CompressFormat.JPEG, (int) (quality * 100), baos);
        return baos.toByteArray();
    }
}
