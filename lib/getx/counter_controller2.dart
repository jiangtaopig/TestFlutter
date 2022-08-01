import 'package:get/get.dart';

class CounterController2 extends GetxController {
  /// 定义了该变量为响应式变量，当该变量数值变化时，页面的刷新方法将自动刷新
  var count = 0.obs;

  void increase() => count++;

}