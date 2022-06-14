import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'TestBean.dart';

class LoadJson{

  Future<String> _loadAssets() async {
    return await rootBundle.loadString('assets/Test.json');
  }

  Future loadData() async {
    String jsonString = await _loadAssets();
    final jsonResponse = json.decode(jsonString);
    TestBean entity = TestBean.fromJson(jsonResponse);
    if (kDebugMode) {
      print("loadData : ${entity.name}");
      print("loadData : ${entity.contents[0].content}");
    }

    Map<String, dynamic> map = entity.toJson();
    String name = map['name'];

    if (kDebugMode) {
      print('loadData === name === ${name}');
    }
    return entity;
  }
}


