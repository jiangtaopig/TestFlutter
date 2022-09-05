import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(FirstApp());
}

class FirstApp extends StatelessWidget {
  const FirstApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo zzz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstAppPage(
        title: 'First Page',
        content: '1234_zhu',
      ),
    );
  }
}

class FirstAppPage extends StatefulWidget {
  FirstAppPage({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final String title;
  final String content;

  final VoidCallback voidCallback = () {
    // Fluttertoast.showToast(msg: '哈哈哈',
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 3,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.black,
    //     fontSize: 16);
    print("-------------------");
    String? a = null;
    print(" a length = ${a!.length}");
  };

  @override
  State<StatefulWidget> createState() =>
      _MyFirstPageState(voidCallback: voidCallback);
}

class _MyFirstPageState extends State<FirstAppPage> {
  _MyFirstPageState({required this.voidCallback});

  int _counter = 0;
  String _title = "试试";

  final VoidCallback voidCallback;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _changeTitle() {
    setState(() {
      _title += '$_counter';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + widget.content),
      ),
      body: Container(
        color: Colors.white30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                child: Text(
                  _title,
                  style: TextStyle(color: Colors.blue, fontSize: 23),
                ),
                onTap: voidCallback,
              ),
            ),

            const Text(
              'You have pushed the button this many ---22 times:-',
            ),
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(4),
              child: Image.asset(
                'images/zz.png',
                fit: BoxFit.fill, // 填充满
                alignment: Alignment.topLeft,
                width: 180,
                height: 160,
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),

            /// 动态修改 widget
            _counter > 2 ? Text('count > 2') : Text('count <= 2'),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'hhh',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Wrap(
                  spacing: 10,
                  children: <Widget>[
                    Text(
                      'wwttoo',
                      style: Theme.of(context).textTheme.headline5,
                      maxLines: 1,
                    ),
                    const Text(
                      '小猪哥',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 23,
                          backgroundColor: Colors.blue,
                          fontWeight: FontWeight.bold,
                          height: 2,
                          //高度，文字高度倍数
                          shadows: [
                            //文字发光
                            Shadow(
                                color: Colors.yellow,
                                blurRadius: 1,
                                offset: Offset(1, 1)),
                            Shadow(
                                color: Colors.yellow,
                                blurRadius: 1,
                                offset: Offset(2, 2)),
                          ],
                          decoration: TextDecoration.underline,
                          //文字下划线，删除线等
                          decorationColor: Colors.green,
                          //文字线颜色
                          decorationStyle: TextDecorationStyle.solid,
                          //文字线样式
                          decorationThickness: 2 //文字线高度ß
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
