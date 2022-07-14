import 'package:flutter/material.dart';

class CounterInheritedWidget extends InheritedWidget {
  /// 需要共享的数据
  int count;

  CounterInheritedWidget({required this.count, required super.child});

  /// 默认的约定：如果状态是希望暴露出的，应当提供一个`of`静态方法来获取其对象，开发者便可直接通过该方法来获取
  /// 返回实例对象，方便子树中的widget获取共享数据
  static CounterInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterInheritedWidget>();
  }

  /// 是否通知widget树中依赖该共享数据的子widget
  /// 这里当count发生变化时，是否通知子树中所有依赖count的Widget重新build
  /// 这里判断注意：是值改变还是内存地址改变。
  @override
  bool updateShouldNotify(covariant CounterInheritedWidget oldWidget) {
    return count != oldWidget.count;
  }
}
