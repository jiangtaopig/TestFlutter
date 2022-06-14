import 'package:flutter/material.dart';

class AppConstants {
  static BoxDecoration myBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red, Colors.blue]));

  static BoxDecoration lineAndConor = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.indigo,
    border: Border.all(color: Colors.black, width: 1), // 边框的颜色和宽度
  );

  static BoxDecoration decoration = BoxDecoration(
    /// 这个不能和下边的一起用，否则会报错：A borderRadius can only be given for a uniform Border.
    /// 可以参考 https://blog.csdn.net/qq_42351033/article/details/122338552
    // borderRadius: BorderRadius.only(
    //     topLeft: Radius.circular(10), topRight: Radius.circular(10)),
    border: Border(
        left: BorderSide(color: Colors.green, width: 3),
        right: BorderSide(color: Colors.green, width: 3),
        top: BorderSide(color: Colors.red, width: 1),
        bottom: BorderSide(color: Colors.red, width: 1)),
  );

  static BoxDecoration decoration2 = BoxDecoration(
    color: Colors.green,
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10), topRight: Radius.circular(10)),
  );

  static BoxDecoration lineAndBlack = BoxDecoration(
    borderRadius: BorderRadius.circular(1),
    border: Border.all(color: Colors.black, width: 2), // 边框的颜色和宽度
  );
}
