
import 'package:flutter/material.dart';

import 'Person.dart';

class PersonInheritedWidget extends InheritedWidget {

  /// 需要共享的数据
  final Person person;
  /// 我们使用回调方法来更新数据
  final Function(Person person) updateCallback;

  PersonInheritedWidget({Key? key, required this.person, required this.updateCallback, required Widget child}) : super(key: key, child: child);

  /// 定义一个便捷方法，获取对象，方便子树中的widget获取共享数据
  static PersonInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PersonInheritedWidget>();
  }


  @override
  bool updateShouldNotify(covariant PersonInheritedWidget oldWidget) {
    return person != oldWidget;
  }

}