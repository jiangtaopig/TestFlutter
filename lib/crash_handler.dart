import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'model/crash_model.dart';

class CrashHandler {
  final String TAG = "CrashHandler";
  final int MAX_SIZE = 2;
  Timer? timer;

  List<CrashBean> _crashBeanList = [];

  CrashHandler._internal();

  static final CrashHandler _singleton = CrashHandler._internal();

  factory CrashHandler() {
    return _singleton;
  }

  void startTimer() async {
    print("CrashHandler:  startTimer  start ");
    int time = 0;
    timer = Timer.periodic(Duration(seconds: 5), (t) async {
      time++;
      print(time);
      if (!_crashBeanList.isEmpty) {
        print("startTimer _crashBeanList size = ${_crashBeanList.length}");
      }
    });
    print("CrashHandler: startTimer  end >>> ${timer.hashCode}");
  }

  void stopTimer() {
    print("CrashHandler: stopTimer >>> ${timer.hashCode}");
    timer?.cancel();

    /// 取消之前轮询的任务，同时开启新一轮的轮询
    startTimer();
  }

  Future addCrashData(CrashBean crashBean) async {
    print("$TAG : addList before add size = ${_crashBeanList.length}");
    await write2Local(jsonEncode(crashBean));
    _crashBeanList.add(crashBean);
    print("$TAG : addList after add size = ${_crashBeanList.length}");
    if (_crashBeanList.length >= MAX_SIZE) {
      List<CrashBean> tmpList = List.from(_crashBeanList);
      _crashBeanList.clear();
      print(
          "_crashBeanList size = ${_crashBeanList.length},  tmpList size = ${tmpList.length}");
      for (CrashBean bean in tmpList) {
        /// 接口上报
        /// tmpList.clear();
      }
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    Directory directory = Directory("$path/crash/");
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return File('${directory.path}/crash.txt');
  }

  void deleteFile() {
    _deleteFile();
  }

  /// 接口上报之后得删除本地的文件，以免 app 再次启动时会多报
  void _deleteFile() async {
    final file = await _localFile;
    file.exists().then((value) {
      if (value) {
        file.delete();
      }
    });
    print("$TAG :delete file ......");
  }

  Future write2Local(String content) async {
    if (content.contains("\\n")) {
      print("--------------xxx-----------------");
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
    String content = await readFile();
    deleteFile();

    /// 删除 crash.txt
    List<CrashBean> crashList = parseList(content);
    int size = crashList.length;
    print("$TAG: boostReporter crashList size = $size");

    /// TODO 接口上报
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

  void test() {
    print("------ start ------, time >>> ${DateTime.now()}");
    for (int i = 0; i < 100000000; i++) {
      int a = i * 2 * 3;
    }
    print("--------end-------, time >>> ${DateTime.now()}");
  }
}
