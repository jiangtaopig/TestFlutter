import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/crash_handler.dart';

import 'model/crash_model.dart';

class TestException extends StatefulWidget {
  const TestException({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TestExceptionState();
  }
}

class _TestExceptionState extends State<TestException> {
  @override
  void initState() {
    super.initState();
    CrashHandler().boostReporter();
    CrashHandler().startTimer();
  }

  int count = 0;
  Timer? timer = null;

  void _startTimer() async {
    print("_testTimer  start time >> ${DateTime.now()}");
    int time = 0;
    timer = Timer.periodic(Duration(seconds: 6), (t) async {
      time++;
      print("$time, time =  ${DateTime.now()}");
    });
    print("_testTimer  end >> ${timer.hashCode}");
  }

  void _stopTimer() {
    print("_stopTimer >>> ${timer.hashCode}");
    try {
      timer?.cancel();
      print("timer cancel ...... ${DateTime.now()}");
      _startTimer();
    } catch (e) {
      print("_stopTimer error  ...... ${e.toString()}");
      print(e.toString());
    }
  }

  void _testQueue() {
    List<CrashBean> queue = [];
    queue.add(new CrashBean(errMsg: "npe1"));
    queue.add(new CrashBean(errMsg: "npe2"));
    queue.add(new CrashBean(errMsg: "npe3"));
    queue.add(new CrashBean(errMsg: "npe4"));

    String ss = json.encode(queue);
    print("queue size = ${queue.length} , ss = $ss");

    var cl = jsonDecode(ss);

    List<CrashBean> list2 = [];

    if (cl is List) {
      for (var bean in cl) {
        list2.add(CrashBean.fromJson(bean));
      }
    }
    print("list2 size = ${list2.length}");
  }

  Future testAsync() async {
    print("testAsync start");
    String ss = await Future.delayed(Duration(seconds: 4), () {
      return "延时4秒";
    });
    print("testAsync end $ss");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("日志上报"),
        ),
        body: Center(
          child: Container(
            color: Colors.greenAccent,
            width: double.infinity,
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      print(
                          "...........................................................");

                      count++;
                      String content = "\n i am zjt \n i love little pig";
                      if (count % 2 == 0) {
                        content = "\n 哈哈哈";
                      }

                      await CrashHandler().write2Local(content);
                      print(
                          "--------------- write ---------------- time >>> ${DateTime.now()}");
                    },
                    child: Text('write to file')),
                ElevatedButton(
                    onPressed: () {
                      // _readFile();
                      CrashHandler().readFile();
                    },
                    child: Text('read from file')),
                ElevatedButton(
                    onPressed: () {
                      // _deleteFile();
                      CrashHandler().deleteFile();
                    },
                    child: Text('delete  file')),
                ElevatedButton(
                    onPressed: () {
                      _startTimer();
                    },
                    child: Text('开始轮询')),
                ElevatedButton(
                    onPressed: () {
                      CrashHandler().stopTimer();
                    },
                    child: Text('停止轮询')),
                ElevatedButton(
                    onPressed: () {
                      // _testQueue();
                    },
                    child: Text('测试集合')),
                ElevatedButton(
                    onPressed: () {
                      count++;
                      if (count % 2 == 0) {
                        String? txt = null;
                        int len = txt!.length;
                      } else {
                        List list = [1];
                        int b = list[2];
                      }
                      // print("-----");
                      // testAsync();
                      // print("xxxxxxxx");
                    },
                    child: Text('测试crash')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
