import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/crash_handler.dart';
import 'package:flutter_demo/model/LessonBean.dart';
import 'package:flutter_demo/model/Person.dart';
import 'package:flutter_demo/test_json.dart';

import 'model/crash_model.dart';

class TestException extends StatefulWidget {
  const TestException({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TestExceptionState();
  }
}

class _TestExceptionState extends State<TestException> {

  // String title;

  @override
  void initState() {
    super.initState();
    // CrashHandler().boostReporter();
    // CrashHandler().startTimer();
  }

  int count = 0;
  Timer? timer = null;
  List<String> _list = ["first"];

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
    // Future.delayed(Duration(seconds: 4), () {
    //   return "延时4秒";
    // });

    await Future(() {
      print("sleep....");
      sleep(Duration(seconds: 3));
      print("sleep....end");
    });

    print("testAsync end ");
  }

  /// 正常情况下，一个 Future 异步任务的执行是相对简单的：
  /// 声明一个 Future 时，Dart会将异步任务的函数执行体放入event queue，然后立即返回，后续的代码继续同步执行；
  /// 当同步执行的代码执行完毕后，event queue会按照加入event queue的顺序（即声明顺序），依次取出事件，最后同步执行 Future 的函数体及后续的操作。
  /// 所以下面的代码的执行顺序是 "testAsync2 start" -> "testAsync2 end" -> "testAsync2 xxxxxxxxxxxxxxxxxxxx"
  Future testAsync2() async {
    print("testAsync2 start");
    Future(() => print("testAsync2 xxxxxxxxxxxxxxxxxxxx"));
    print("testAsync2 end");
  }

  Future testAsync3() async {
    print("testAsync3 start");
    String res = await Future.delayed(Duration(seconds: 2), () {
      return "3秒结束了";
    });
    print("testAsync3 end $res");
  }

  void futureQueueTest() {
    Future future1 = Future(() => null);
    future1.then((value) {
      print('6');
      scheduleMicrotask(() => print(7));
    }).then((value) => print('8'));
    Future future2 = Future(() => print('1'));
    Future(() => print('2'));
    scheduleMicrotask(() => print('3'));
    future2.then((value) => print('4'));

    print('5');
  }

  List ttt(List list, String times(String v)) {
    for (int i = 0; i < list.length; i++) {
      list[i] = times(list[i]);
    }
    return list;
  }

  int ttt2(int x, int y, {int add(int a, int b)?}) {
    return add!(x, y);
  }

  void ee() {
    List<String> ll = ["a", "b", "c"];
    print(ttt(ll, (v) {
      return v * 3;
    }));

    print(ttt2(3, 4, add: (x, y) {
      return x + y;
    }));
  }

  void testJson() {
    CrashBean crashBean = CrashBean(errMsg: "ClassNotFoundException");
    String jsonStr = jsonEncode(crashBean);
    print("jsonStr = $jsonStr");

    var data = jsonDecode(jsonStr);
    print("data = $data, ${data.runtimeType}");
    CrashBean bean = CrashBean.fromJson(data);
    print("bean msg = ${bean.errMsg}");

    List<LessonDetail> detailList = [];
    LessonDetail lessonDetail1 = LessonDetail(
        id: 1,
        name: "name1",
        picSmall: "picSmall",
        picBig: "picBig",
        description: "description");
    detailList.add(lessonDetail1);
    LessonBean lessonBean =
        LessonBean(status: 200, msg: "ok", data: detailList);

    String json = jsonEncode(lessonBean);
    print("json = $json");

    LessonBean lessonBean2 = LessonBean.fromJson(jsonDecode(json));
    print("name = ${lessonBean2.data[0].name}");

    Grade grade = Grade(className: "一年级", title: "班长");
    Address address1 = Address(street: "长宁路666号", district: "长宁区");
    Address address2 = Address(street: "淞虹路", district: "长宁区");

    List<Address> addressList = [address1, address2];

    Student student =
        Student(name: "pig", age: 7, grade: grade, addressList: addressList);

    String jsonStu = jsonEncode(student);
    print("jsonStu = $jsonStu");

    var s1 = jsonDecode(jsonStu);
    print("$s1, runType = ${s1.runtimeType}");
    Student student2 = Student.fromJson(s1);
    print(
        "class is ${student2.grade.className}, address1 = ${student2.addressList[0].district}");

    /// 使用注解类生成的，适合大型项目

    Address2 add = Address2("上海市长兴区333弄");
    Person person = Person("zzz", 33, add);
    String personStr = jsonEncode(person);
    print("personStr = $personStr");

    Person person2 = Person.fromJson(jsonDecode(personStr));
    print("address = ${person2.address.detailAddress}");
  }

  Future add() async {
    print("----add-----");
    _list.add("3");
    print("----add end-----");
  }

  Future clear() async {
    print("----delete-----${_list[0]}");
    _list.clear();
    sleep(Duration(seconds: 2));
    print("----delete end-----");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                    await CrashHandler.getInstance().write2Local(content);
                    print(
                        "--------------- write ---------------- time >>> ${DateTime.now()}");
                  },
                  child: Text('write to file')),
              ElevatedButton(
                  onPressed: () {
                    // _readFile();
                    // CrashHandler.getInstance().boostReporter();
                    CrashHandler.getInstance().readFile();
                  },
                  child: Text('read from file')),
              ElevatedButton(
                  onPressed: () {
                    // _deleteFile();
                    CrashHandler.getInstance().deleteFile();
                  },
                  child: Text('delete  file')),
              ElevatedButton(
                  onPressed: () {
                    _startTimer();
                  },
                  child: Text('开始轮询')),
              ElevatedButton(
                  onPressed: () {
                    CrashHandler.getInstance().stopTimer();
                  },
                  child: Text('停止轮询')),
              ElevatedButton(
                  onPressed: () {
                    // _testQueue();

                    // var numberPrinter = () {
                    //   int num = 0;
                    //   print("num = $num");
                    //   return () {
                    //     for (int i = 0; i < 10; i++) {
                    //       num++;
                    //     }
                    //     print(num);
                    //   };
                    // };
                    //
                    // var printer = numberPrinter();
                    // ee();
                    //
                    // testJson();
                    // add();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return TestJsonWidget();
                      }),
                    );
                  },
                  child: Text('跳转json序列化页面')),
              ElevatedButton(
                  onPressed: () async {
                    count++;
                    print(
                        "--------------------------count = $count-------------------------");
                    //
                    // if (count % 2 == 0) {
                    //   String? txt = null;
                    //   int len = txt!.length;
                    // } else {
                    //   List list = [1];
                    //   int b = list[2];
                    // }

                    List<int> ll = [1, 2, 3, 4];

                    // for (int a in ll ) {
                    //   if (a == 2) {
                    //     ll.remove(2); // 这样会报 Concurrent modification
                    //   }
                    // }

                    ll.removeWhere((element) => element == 2);

                    print("ll == $ll");

                    String phone = "188175";
                    if (phone.length >= 7) {
                      phone = phone.replaceRange(3, 7, "****");
                    } else {
                      phone = phone.replaceRange(3, phone.length, "****");
                    }

                    print("------------ phone = $phone");

                    // print("-----");
                    // testAsync();
                    // print("xxxxxxxx");

                    // await testAsync2();
                    // await testAsync2();
                    // futureQueueTest();

                    // await testAsync3();
                    // await testAsync3();

                    // clear();
                  },
                  child: Text('测试crash')),
            ],
          ),
        ),
      ),
    );
  }
}
