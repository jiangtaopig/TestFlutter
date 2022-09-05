import 'package:flutter/material.dart';
import 'package:flutter_demo/getx/person_model.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class XPageOne extends StatelessWidget {
  const XPageOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CounterController counterController = Get.find<CounterController>();
    print("---------------------- XPageOne build -----------------------counterController = ${counterController.hashCode}");

    return Scaffold(
      appBar: AppBar(
        title: Text('GetXBinding PageOne'),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(30),
        height: 300,
        color: Colors.green,
        child: Column(
          children: [
            /// 使用 GetBuilder 可以在点击增加次数的时候更新 ui
            /// 当数据源变化时，需要手动执行刷新组件的方法，即 CounterController 中的 increase() 方法中需要调用 update() 方法；
            /// 此状态管理器内部实际上是对 StatefulWidget 的封装，占用资源极少！
            GetBuilder<CounterController>(builder: (controller) {
              print("---------------------- GetBuilder build -----------------------");
              return Text("点击次数 ${controller.count}", );
            }),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
                onPressed: () {
                  counterController.increase();
                },
                child: Text("增加点击次数")),

            ElevatedButton(
                onPressed: () {
                  /// 页面跳转
                  Get.toNamed(RouterConfig.twoPage);
                },
                child: Text("跳转 XPageTwo")),
          ],
        ),
      ),
    );
  }
}

class XPageTwo extends StatelessWidget {
  const XPageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersonController personController = Get.find<PersonController>();
    final CounterController counterController = Get.find<CounterController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('GetXBinding PageTwo'),
      ),
      body: Container(
        width: 300,
        height: 300,
        color: Colors.amber,
        child: Column(
          children: [
            GetBuilder<PersonController>(builder: (personController) {
              return Text(
                  "name = ${personController.person.name}, age = ${personController.person.age}");
            }),
            ElevatedButton(
                onPressed: () {
                  var person = Person(name: "刘诗诗", age: 34);
                  personController.changePerson(person);
                },
                child: Text("change person")),

            ElevatedButton(
                onPressed: () {
                  counterController.increase();
                },
                child: Text("add "))
          ],
        ),
      ),
    );
  }
}

class CounterController extends GetxController {
  var count = 0;

  /// 自增方法
  void increase() {
    count++;
    update();
  }
}

class PageOneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CounterController());
  }
}

class PersonController extends GetxController {
  var person = Person(name: "pig", age: 32);
  var age = 32;

  void changePerson(Person person) {
    this.person = person;
    update(); // 手动刷新
  }
}

class RouterConfig {
  static const String onePage = "/onePage";
  static const String twoPage = "/twoPage";

  static final List<GetPage> getPages = [
    GetPage(
      name: onePage,
      page: () => XPageOne(),
      binding: PageOneBinding(),
    ),
    GetPage(
      name: twoPage,
      page: () => XPageTwo(),

      /// 不需要新建Bindings类来进行单独的绑定(class PageOneBinding extends Bindings)，
      /// 直接使用构建器BindingsBuilder。
      binding: BindingsBuilder(() => Get.lazyPut(() => PersonController())),
    ),
  ];
}

/// 入口类
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 这里使用 GetMaterialApp 初始化路由
    return GetMaterialApp(
      initialRoute: RouterConfig.onePage,
      getPages: RouterConfig.getPages,
    );
  }
}

void main() {
  runApp(MyApp());
}
