
import 'package:flutter/material.dart';

void main() {
  runApp(ScrollApp());
}

class ScrollApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePage();
  }

}

class _MyHomePage extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    print("Custom MediaQuery padding: ${MediaQuery.of(context).padding} viewInsets.bottom: ${MediaQuery.of(context).viewInsets.bottom}\n  \n");
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFcccccc),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              color: Colors.black12,
              child: Center(child: Text("顶部")),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              margin: EdgeInsets.all(10),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    width: 250,
                    margin: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Color(0xffcfcccc),
                        filled: true,
                        hintText: '请输入账号',
                        contentPadding: EdgeInsets.only(left: 20),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 250,
                    margin: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Color(0xfffdfccc),
                        filled: true,
                        hintText: '请输入密码',
                        contentPadding: EdgeInsets.only(left: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
