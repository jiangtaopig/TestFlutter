import 'package:flutter/material.dart';
import 'package:flutter_demo/getx/counter_controller2.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class TestGetX extends StatefulWidget {
  const TestGetX({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TestGetXState();
  }
}

class TestGetXState extends State<TestGetX> {
  @override
  Widget build(BuildContext context) {
    final CounterController2 counter = Get.put(CounterController2());
    return Scaffold(
      appBar: AppBar(
        title: Text('getX'),
      ),
      body: Container(
        color: Colors.amber,
        width: double.infinity,
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// GetX 响应式状态管理，当数据源变化时，将自动执行刷新组件的方法
            /// GetBuilder：简单状态管理，当数据源变化时，需要手动执行刷新组件的方法，见 test_getx_binding 文件
            GetX<CounterController2>(
              init: counter,
              builder: (controller) {
                return Text(
                  "count的值为：${controller.count}",
                  style: const TextStyle(color: Colors.redAccent, fontSize: 20),
                );
              },
            ),
            ElevatedButton(
                onPressed: () {
                  counter.increase();
                },
                child: Text('counter increase')),
            ElevatedButton(
                onPressed: () {
                  Get.to(PageTwo());
                },
                child: Text('jump 2 PageTwo'))
          ],
        ),
      ),
    );
  }
}

/// PageTwo 通过 GetX 能够修改 页面1的数据
class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PageTwo"),
      ),
      body: Container(
        color: Colors.greenAccent,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetX<CounterController2>(
              autoRemove: false,
              builder: (controller) {
                return Column(
                  children: [
                    Text(
                      "count的值为：${controller.count}",
                      style: const TextStyle(
                          color: Colors.redAccent, fontSize: 20),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          controller.increase();
                        },
                        child: Text("count increase")),
                    ElevatedButton(
                        onPressed: () {
                          /// 必须要在 runApp 方法中使用 GetMaterialApp，否则报错
                          /// You are trying to use contextless navigation withouta GetMaterialApp or Get.key.
                          Get.to(PageThree());
                        },
                        child: Text("Jump 2 PageThree"))
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PageThree extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageThreeState();
  }
}

/// PageThree 通过 Get.find<CounterController2>() 获取页面1的 CounterController2
/// 然后可以使用该对象进行操作递增和获取 count
class _PageThreeState extends State<PageThree> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    CounterController2 controller2 = Get.find<CounterController2>();
    _count = controller2.count.value;

    return Scaffold(
      appBar: AppBar(
        title: Text("PageThree"),
      ),
      body: Container(
        color: Colors.greenAccent,
        width: double.infinity,
        padding: EdgeInsets.only(top: 40, bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "count的值为：$_count",
              style: const TextStyle(color: Colors.redAccent, fontSize: 20),
            ),
            ElevatedButton(
                onPressed: () {
                  controller2.increase();
                  setState(() {
                    _count = controller2.count.value;
                  });
                },
                child: Text("count increase"))
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    home: const TestGetX(),
  ));
}
