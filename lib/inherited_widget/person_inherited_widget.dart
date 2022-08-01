
import 'package:flutter/material.dart';

import 'Person.dart';

class PersonInheritedWidget extends InheritedWidget {

  /// 需要共享的数据
  final Person person;
  /// 我们使用回调方法来更新数据
  final Function(Person person) updateCallback;

  PersonInheritedWidget({Key? key, required this.person, required this.updateCallback, required Widget child}) : super(key: key, child: child);

  /// 定义一个静态方法获取对象，方便子树中的 widget 获取共享数据
  static PersonInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PersonInheritedWidget>();
  }

  void updatePerson(Person person) {
    updateCallback(person);
  }

  @override
  bool updateShouldNotify(covariant PersonInheritedWidget oldWidget) {
    return person != oldWidget.person;
  }

}