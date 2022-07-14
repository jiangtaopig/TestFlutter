import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/**
 * 日常开发中会遇到一种模型嵌套另一种模型、或一种模型的参数用到另一种模型的值、或是需要几种模型的值组合成一个新的模型的情况，
 * 在这种情况下，就可以使用 ProxyProvider 。它能够将多个 provider 的值聚合为一个新对象，
 * 将结果传递给 Provider（注意是Provider而不是  ChangeNotifierProvider），
 * 这个新对象会在其依赖的任意一个 provider 更新后同步更新值。
 *   https://juejin.cn/post/7067356022272163847
 */
class Person with ChangeNotifier {
  String name;

  Person({required this.name});

  void changeName(String newName) {
    this.name = newName;
    notifyListeners();
  }
}

class EatModel {
  String name;

  EatModel({required this.name});

  get whoEat => "$name eat now ";
}

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx) => Person(name: "zhupig")),
      ProxyProvider<Person, EatModel>(
          update: (ctx, person, eatModel) => EatModel(name: person.name))
    ],
    child: MaterialApp(
      home: ProxyProviderDemo(),
    ),
  ));
}

class ProxyProviderDemo extends StatefulWidget {
  const ProxyProviderDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProxyProviderState2();
  }
}

class _ProxyProviderState extends State<ProxyProviderDemo> {
  @override
  Widget build(BuildContext context) {
    print("---- _ProxyProviderState ----- build invoke");
    EatModel model = Provider.of<EatModel>(context);
    Person person = Provider.of<Person>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("ProxyProvider"),
      ),
      body: Container(
        color: Colors.green,
        width: double.infinity,
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Text(model.whoEat,
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  person.changeName("hello pig ");
                },
                child: Text("change name"))
          ],
        ),
      ),
    );
  }
}

/// 使用 Consumer 来消费数据
class _ProxyProviderState2 extends State<ProxyProviderDemo> {
  List<int> list = [2, 3, 6, 9, 1];

  void sort() {
    list.sort((a, b) { /// list 递增排序
      return a - b;
    });

    print(" list => $list");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ProxyProvider"),
        ),
        body: Column(
          children: [
            Consumer(
              /// 后面很多的 Text 组件没有用到模型数据且不需要更新状态的，但是因为被Consumer 包裹，导致每次数据改变都会重新构建！严重影响性能且不优雅！
              /// 使用 Widget? child 将不需要更新状态的组件包裹起来，大大提升了性能
              builder:
                  (BuildContext context, EatModel eatModel, Widget? child) {
                return Column(
                  children: [Text("${eatModel.whoEat}"), child!],/// 要加上 child
                );
              },

              child: Column(
                children: [
                  Text("其他更多组件"),
                  Text("其他更多组件"),
                  Text("其他更多组件"),
                  Text("其他更多组件"),
                  Text("其他更多组件"),
                ],
              ),
            ),
            Consumer(
                builder: (BuildContext context, Person person, Widget? child) {
              return ElevatedButton(
                  onPressed: () {
                    person.changeName("hhh");
                    sort();
                  },
                  child: Text("change name"));
            }),
          ],
        ));
  }
}
