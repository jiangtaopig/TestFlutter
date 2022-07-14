import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Counter with ChangeNotifier {
  int _count = 0;

  get count => _count;

  void add() {
    _count++;
    notifyListeners();
  }

  void subtract() {
    _count--;
    notifyListeners();
  }
}

void main() {
  runApp(ChangeNotifierProvider(
    create: (ctx) {
      return Counter();
    },
    child: MaterialApp(
      home: ChangeNotifierProviderDemo(tt: {"name" : "zhuzhu"}),
    ),
  ));
}

class ChangeNotifierProviderDemo extends StatefulWidget {
  final Map<String, String> tt;
  ChangeNotifierProviderDemo({Key? key, required this.tt}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChangeNotifierProviderState();
  }
}

class _ChangeNotifierProviderState extends State<ChangeNotifierProviderDemo> {

  @override
  Widget build(BuildContext context) {
    print('--- _ChangeNotifierProviderState --- >>>> build , name = ${widget.tt["name"]}');
    Counter counter = Provider.of<Counter>(context);


    return Scaffold(
      appBar: AppBar(
        title: Text('测试 ChangeNotifierProvider'),
      ),
      body: Container(
        color: Colors.green,
        width: 300,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                counter.add();
              },
              child: const Icon(Icons.add),
            ),
            Text('当前计数: ${counter.count}'),
            ElevatedButton(
              onPressed: () {
                counter.subtract();
              },
              child: Text('-', style: TextStyle(fontSize: 30),),
            ),

            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Page2(title: "Page2 页面");
                  }),
                );
            }, child: Text("Page2"))
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {

  String title;
  Page2({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Counter counter = Provider.of<Counter>(context);

    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: Container(
        child: Column(
          children: [
            Text('count = ${counter.count}'),
            ElevatedButton(onPressed: (){
              counter.add();
            }, child: const Icon(Icons.add))
          ],
        ),
      ),
    );
  }

}