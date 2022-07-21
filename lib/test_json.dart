import 'dart:convert';

import 'package:flutter/material.dart';

void main() {
  runApp(TestJsonWidget());
}

class TestJsonWidget extends StatefulWidget {
  // const TestJsonWidget(Key? key) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TestJsonWidgetState();
  }
}

class _TestJsonWidgetState extends State<TestJsonWidget> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("test json"),
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {

                    },
                    child: Text("对象转json")),
                ElevatedButton(
                    onPressed: () {
                      Grade grade = Grade(className: "一年级", title: "班长");
                      Address address1 =
                          Address(street: "长宁路666号", district: "长宁区");
                      Address address2 =
                          Address(street: "淞虹路", district: "长宁区");

                      List<Address> addressList = [address1, address2];

                      Student student = Student(
                          name: "pig",
                          age: 7,
                          grade: grade,
                          addressList: addressList);

                      String jsonStu = jsonEncode(student);
                      print("jsonStu = $jsonStu");

                      var s1 = jsonDecode(jsonStu);
                      print("$s1, runType = ${s1.runtimeType}");
                      Student student2 = Student.fromJson(s1);
                      print(
                          "class is ${student2.grade.className}, address1 = ${student2.addressList[0].district}");

                    },
                    child: Text("json 转对象")),
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
    print("list = $list, runtimeType = ${list.runtimeType}");
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
