import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'model/crash_model.dart';

class CrashHandler {
  final String TAG = "CrashHandler";
  final int MAX_SIZE = 2; /// 异常次数阈值，达到这个值就上报服务侧
  static const int LOOP_TIME_SECOND = 1 * 60; /// 10分钟轮询1次
  static const int COUNT_TYPE = 1;
  static const int LOOP_TYPE = COUNT_TYPE + 1;
  static const int BOOSTER_TYPE = LOOP_TYPE + 1;

  Timer? timer;
  List<CrashBean> _crashBeanList = [];

  static CrashHandler? _instance;

  CrashHandler._internal(); /// 私有的构造函数

  static CrashHandler getInstance() {
    if (_instance == null) {
      _instance = CrashHandler._internal();
    }
    return _instance!;
  }

  void startTimer() async {
    print("CrashHandler:  startTimer  start ");
    int time = 0;
    timer = Timer.periodic(Duration(seconds: LOOP_TIME_SECOND), (t) async {
      time++;
      print("time = $time , ${DateTime.now()}");
      if (!_crashBeanList.isEmpty) {
        print("startTimer _crashBeanList size = ${_crashBeanList.length}");
        List<CrashBean> tmpList = List.from(_crashBeanList);
        _crashBeanList.clear();
        reporterToService(LOOP_TYPE);
      }
    });
    print("CrashHandler: startTimer  end >>> ${timer.hashCode}");
  }

  /// 取消之前轮询的任务，同时开启新一轮的轮询
  void stopTimer() {
    print("CrashHandler: stopTimer >>> ${timer.hashCode}");
    timer?.cancel();
    startTimer();
  }

  Future addCrashData(CrashBean crashBean) async {
    try {
      print("$TAG : addList before add size = ${_crashBeanList.length}");
      await write2Local(jsonEncode(crashBean));
      _crashBeanList.add(crashBean);
      print("$TAG : addList after add size = ${_crashBeanList.length}");
      if (_crashBeanList.length >= MAX_SIZE) {
        List<CrashBean> tmpList = List.from(_crashBeanList);
        _crashBeanList.clear();
        print(
            "_crashBeanList size = ${_crashBeanList.length},  tmpList size = ${tmpList.length}");

        /// 接口上报
        reporterToService(COUNT_TYPE);
        print("$TAG : addCrashData  time = ${DateTime.now()}");
        stopTimer();
        for (CrashBean bean in tmpList) {
          /// tmpList.clear();
        }
      }
    } catch (e, s) {
      print(
          "$TAG: addCrashData error,  stack is >>  ${e.toString()} ,  ${s.toString()}");
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    Directory directory = Directory("$path/crash/");
    // if (!directory.existsSync()) {
    //   directory.createSync(recursive: true);
    // }
    return File('${directory.path}/crash.txt');
  }

  void deleteFile() {
    _deleteFile();
  }

  /// 接口上报之后得删除本地的文件，以免 app 再次启动时会多报
  void _deleteFile() async {
    print("$TAG :delete file start");
    final file = await _localFile;
    file.exists().then((value) {
      if (value) {
        file.delete();
      }
      print(
          "$TAG :delete file .....................................................");
    });
  }

  Future write2Local(String content) async {
    if (content.contains("\\n")) {
      content = content.replaceAll("\\n", "\n") + "&&";
    }
    print("write2Local start , time >>> ${DateTime.now()}");
    File file = await _writeFile(content);
    print("write2Local end , time >>> ${DateTime.now()}");
  }

  Future<File> _writeFile(String content) async {
    final file = await _localFile;
    print(
        "_writeFile start  content = $content, time >>> --  ${DateTime.now()}");
    Future<File> res = file.writeAsString(content, mode: FileMode.append);
    print("_writeFile end time >>> ------------------------ ${DateTime.now()}");
    return res;
  }

  Future<String> readFile() async {
    String contents = await _readFile();
    print("contents = $contents");
    return contents;
  }

  Future<String> _readFile() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        return "";
      }
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print("$TAG : " + e.toString());
      return "xxx";
    }
  }

  /// app 启动的时候，如果发现 crash.txt 文件不为空，则上报，然后删除 crash.txt
  void boostReporter() async {
    print("$TAG: boostReporter start");
    try {
      String content = await readFile();
      List<CrashBean> crashList = parseList(content);
      int size = crashList.length;
      print("$TAG: boostReporter crashList size = $size");

      /// TODO 接口上报
      if (size > 0) {
        reporterToService(BOOSTER_TYPE);
      }
    } catch(e, s) {
     print("$TAG: boostReporter error; $e,  ${s.toString()}");
    }
  }

  List<CrashBean> parseList(String content) {
    List<String> list = content.split("&&");
    int size = list.length;
    List<CrashBean> beanList = [];
    print("$TAG : readFile , size = ${size - 1}");
    for (int i = 0; i < size - 1; i++) {
      String s = list[i];
      if (s.contains("\n")) {
        s = s.replaceAll("\n", "\\n");
      }
      CrashBean bean = CrashBean.fromJson(jsonDecode(s));
      beanList.add(bean);
      print("----bean---- msg = ${bean.errMsg}");
    }
    return beanList;
  }

  Future reporterToService(int type) async {
    print("reporterToService  开始上报");
    String msg = "";
    switch (type) {
      case COUNT_TYPE:
        msg = "超过$MAX_SIZE次，所以上报";
        break;
      case LOOP_TYPE:
        msg = "超过轮询时间，所以上报";
        break;
      case BOOSTER_TYPE:
        msg = "首次启动上报";
        break;
    }
    print(" reporterToService >>>>>> $msg");
    /// 删除本地 crash.txt
    _deleteFile();
  }
}
