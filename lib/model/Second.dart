import 'package:flutter/material.dart';

import '../AppConstants.dart';

void main() {
  runApp(SecondApp());
}

class SecondApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SecondAppPage(title: "小猪哥"),
    );
    return SecondAppPage(title: "小猪哥");
  }
}

class SecondAppPage extends StatefulWidget {
  SecondAppPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _SecondAppPageState();
}

class _SecondAppPageState extends State<SecondAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: BackButton(onPressed: () {
          Navigator.pop(context); // 因为是 MaterialApp ，所以点击返回键会黑屏
        }),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 60),
        padding: EdgeInsets.all(32),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                // color: Colors.brown,
                padding: EdgeInsets.all(10),
                decoration: AppConstants.lineAndConor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Oeschinen Lake Campground 111',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      'Kandersteg, Switzerland',
                      style: TextStyle(color: Colors.grey[500]),
                    )
                  ],
                ),
              ),
            ),
            Icon(
              Icons.star,
              color: Colors.red[500],
            ),
            const Text('41'),
          ],
        ),
      ),
    );
  }
}
