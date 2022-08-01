import 'package:flutter/material.dart';

class TestGridView extends StatefulWidget {
  const TestGridView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TestGridViewState();
  }
}

class TestGridViewState extends State<TestGridView> {
  List<String> dataList = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 7; i++) {
      dataList.add("数据$i");
    }
  }

  Container _buildItem(String data) => Container(
        alignment: Alignment.center,
        width: 100,
        height: 30,
        color: Colors.greenAccent,
        child: Text(
          data,
          style: TextStyle(color: Colors.white, shadows: [
            Shadow(color: Colors.black, offset: Offset(.5, .5), blurRadius: 2)
          ]),
        ),
      );

  int _count = 0;

  List<Widget> _buildWidgets() {
    List<Widget> widgets = dataList.map((data) => _buildItem(data)).toList();

    Text addTxt = Text(
      'add',
      style: TextStyle(color: Colors.red, fontSize: 30),
    );
    widgets.add(Container(
      color: Colors.amber,
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            dataList.add("我是新增的数据${_count++}");
          });
        },
        child: addTxt,
      ),
    ));
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GridView"),
      ),
      body: Container(
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: _buildWidgets(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TestGridView(),
  ));
}
