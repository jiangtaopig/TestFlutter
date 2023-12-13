import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_demo/crash_handler.dart';
import 'package:flutter_demo/model/crash_model.dart';
import 'package:flutter_demo/testException.dart';
import 'package:flutter_demo/test_multi_image_picker.dart';

import 'Four.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  //在规定运行zone里捕捉未处理的error
  FlutterError.onError = (FlutterErrorDetails details) async {
    FlutterError.dumpErrorToConsole(details);
    Zone.current.handleUncaughtError(details.exception, details.stack!);
    _reportError(details.exception, details.stack);
  };

  print("--------------- main -----------------------");

  initBeforeRun();


  runZonedGuarded(() {
     runApp(MaterialApp(home: TestMultiImagePicker(),));
    // FlutterBugly.postCatchedException(() {
    //   // 如果需要 ensureInitialized，请在这里运行。
    //   // WidgetsFlutterBinding.ensureInitialized();
    //   runApp(MaterialApp(
    //     home: const TestException(),
    //   ));
    //
    //   FlutterBugly.init(
    //     androidAppId: "bca16d9699",
    //     iOSAppId: "your iOS app id",
    //   ).then((value) {
    //     print("bugly 初始化 ${value.isSuccess}, ${value.message}");
    //   });
    // });

  }, (Object error, StackTrace stack) {
    // print("runZonedGuarded zjt crash start : error = $error, stack = $stack");
    _reportError(error, stack);
  });
}

void initBeforeRun() {
  Future.delayed(Duration(seconds: 2), (){
    CrashHandler.getInstance().boostReporter();
    CrashHandler.getInstance().startTimer();
  });
}

/// 一定要放这里才发送，在别的类里不行
Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  print("zjt crash start : error = $error");
  print("zjt crash end >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
  Map<String, dynamic> params = {};
  params["taskId"] = "005";
  params["errMsg"] = error.toString();

  CrashBean crashBean = CrashBean(errMsg: "$error,  >>>> $stackTrace");
  // String string = jsonEncode(crashBean);
  // if (string.contains("\\n")) {
  //   print("--------------xxx-----------------");
  //   string = string.replaceAll("\\n", "\n");
  // }
  //
  // // print(" string  = $string");
  //
  //  if (string.contains("\n")) {
  //    print("--------------xxx-----------------");
  //    string = string.replaceAll("\n", "\\n");
  //  }
  //
  // CrashBean bean = CrashBean.fromJson(jsonDecode(string));
  //
  // print("code = ${bean.taskId}, msg = ${bean.errMsg}");

  await CrashHandler.getInstance().addCrashData(crashBean);
}
