import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/crash_handler.dart';
import 'package:flutter_demo/model/LessonBean.dart';
import 'package:flutter_demo/model/Person.dart';

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
    String ss = await Future.delayed(Duration(seconds: 4), () {
      return "延时4秒";
    });
    print("testAsync end $ss");
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

                      await CrashHandler.getInstance().write2Local(content);
                      print(
                          "--------------- write ---------------- time >>> ${DateTime.now()}");
                    },
                    child: Text('write to file')),
                ElevatedButton(
                    onPressed: () {
                      // _readFile();
                      CrashHandler.getInstance().boostReporter();
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

                      add();
                    },
                    child: Text('测试集合')),
                ElevatedButton(
                    onPressed: () {
                      count++;
                      // if (count % 2 == 0) {
                      //   String? txt = null;
                      //   int len = txt!.length;
                      // } else {
                      //   List list = [1];
                      //   int b = list[2];
                      // }
                      // print("-----");
                      // testAsync();
                      // print("xxxxxxxx");

                      clear();
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

/// json convert 嵌套类的解析
class Student {
  String name;
  int age;
  Grade grade;
  List<Address> addressList;

  Student(
      {required this.name,
      required this.age,
      required this.grade,
      required this.addressList});

  factory Student.fromJson(Map<String, dynamic> parsedJson) {
    /// addressList 是列表 和 grade 的处理方式不一样
    /// 方式 1
    List<Address> addressL = [];
    var list = parsedJson['addressList'];
    for (var address in list) {
      addressL.add(Address.fromJson(address));
    }

    /// 方式 2，显然方式2的更加优雅
    List<Address> addressL2 = (parsedJson['addressList'] as List<dynamic>)
        .map((e) => Address.fromJson(e))
        .toList();

    return Student(
      name: parsedJson['name'],
      age: parsedJson['age'],
      grade: Grade.fromJson(parsedJson['grade']),
      addressList: addressL2,
    );
  }

  Map toJson() {
    Map map = Map();
    map["name"] = this.name;
    map["age"] = this.age;
    map["grade"] = this.grade;
    map['addressList'] = this.addressList;
    return map;
  }
}

class Grade {
  String className;
  String title;

  Grade({required this.className, required this.title});

  factory Grade.fromJson(Map<String, dynamic> parsedJson) {
    return Grade(
      className: parsedJson['className'],
      title: parsedJson['title'],
    );
  }

  Map toJson() {
    Map map = Map();
    map["className"] = this.className;
    map["title"] = this.title;
    return map;
  }
}

class Address {
  String street;
  String district;

  Address({required this.street, required this.district});

  factory Address.fromJson(Map<String, dynamic> parsedJson) {
    return Address(
      street: parsedJson['street'],
      district: parsedJson['district'],
    );
  }

  Map toJson() {
    Map map = Map();
    map["street"] = this.street;
    map["district"] = this.district;
    return map;
  }
}
