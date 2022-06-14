import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/Lesson.dart';
import 'package:flutter_demo/LessonBean.dart';
import 'package:flutter_demo/TestAwait.dart';
import 'package:flutter_demo/model/TestStatic.dart';
import 'package:http/http.dart' as http;

import 'LoadJson.dart';

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Http Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List<LessonWarp> widgets = [];

  @override
  void initState() {
    super.initState();
    print('-------------------- initState -------------');
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    print('-------------------- build ----------- -- --');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Http Sample App'),
      ),
      body: ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (BuildContext context, int position) {
          return getRow(position);
        },
      ),
    );
  }

  Widget getRow(int i) {
    return GestureDetector(
      // padding: EdgeInsets.all(10.0),
      child: SizedBox(
        height: 120, // 设置 ListView 的 item 高度为 100
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // 使用 Container 设置边距
              padding: const EdgeInsets.all(8),
              child: Text("Row >>>  ${widgets[i].name}"),
            ),

            Container(
              padding: const EdgeInsets.only(left: 8),
              child: ClipRRect(
                // 圆角图片
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  image: NetworkImage(widgets[i].picSmall),
                  width: 60,
                  height: 60,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),

            // Image( image: NetworkImage(widgets[i].picSmall),
            //   width: 60,
            //   height: 60,
            //   fit: BoxFit.fitHeight,)
            Text(
              widgets[i].description,
              style: const TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),

      onTap: () {
        // listview 的点击事件
        setState(() {
          onItemClick(i);
        });
      },
    );
  }

  void onItemClick(int index) {
    print("----click---- ${index}");
    LoadJson loadJson = new LoadJson();
    loadJson.loadData();

    Cat.showName();
    requestByDio();

    Future future = new TestAwait().test2();
    print('----- future ---- $future');
  }

  /**
   * 使用 dio 的方式获取数据
   */
  void requestByDio() async {
    Dio dio = new Dio();
    var result = await dio.get("http://www.imooc.com/api/teacher?type=4&num=4");
    LessonBean lessonBean = LessonBean.fromJson(jsonDecode(result.data));
    print(' dio ====${lessonBean.data[0].description}');
  }

  Future<void> loadData() async {
    var dataURL = Uri.parse('http://www.imooc.com/api/teacher?type=4&num=4');
    http.Response response = await http.get(dataURL);
    setState(() {
      print("---${response.body}");
      Lesson lesson = Lesson.fromJson(jsonDecode(response.body));
      print("lesson ${lesson.data.length}, name = ${lesson.data[0].name}");
      widgets = lesson.data;

      // 第二种解析方式，使用 json_serial 框架
      LessonBean lessonBean = LessonBean.fromJson(jsonDecode(response.body));
      List<LessonDetail> lessonDetail = lessonBean.data;
      print('lessonDetail  ${lessonDetail[0].description}');
    });
  }
}
