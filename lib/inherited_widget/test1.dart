import 'package:flutter/material.dart';
import 'package:flutter_demo/inherited_widget/counter_inherited_widget.dart';

void main() {
  runApp(MyHomePage());
}

class CounterOneWidget extends StatelessWidget {
  const CounterOneWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.greenAccent,
      alignment: Alignment.center,
      child: Text(CounterInheritedWidget.of(context)!.count.toString()),
    );
  }
}

class CounterTwoWidget extends StatefulWidget {
  const CounterTwoWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CounterTwoWidgetState();
  }
}

class _CounterTwoWidgetState extends State<CounterTwoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.green,
      alignment: Alignment.center,
      child: Text(CounterInheritedWidget.of(context)!.count.toString()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("InheritedWidget"),
        ),
        body: CounterInheritedWidget( /// 父节点使用
          count: _count,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [ /// 所有子节点均可以共享数据
                CounterOneWidget(),
                CounterTwoWidget(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!mounted) return;
            setState(() {
              _count += 1;
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
