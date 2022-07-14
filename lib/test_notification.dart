import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.greenAccent,
          margin: EdgeInsets.only(top: 40),
          padding: EdgeInsets.all(10),
          child: MyNotificationState(),
        ),
      ),
    ),
  );
}

class MyNotificationState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyState();
  }
}

class Acc extends InheritedWidget{
  Acc({required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    throw UnimplementedError();
  }
  
}

class _MyState extends State<MyNotificationState> {
  String _msg = "xx";

  
  @override
  Widget build(BuildContext context) {
    print('build ---- context = $context');
    return NotificationListener<MyNotification>(
      onNotification: (notification) {
        print('msg = ${notification.msg}');
        setState(() {
          _msg += notification.msg;
        });
        return true;
      },
      child: NotificationListener<MyNotification>(
        onNotification: (no) {
          print("---- child notification  -----");
          return true; /// true 表示子通知消费了，父通知就收不到了， 跟 android 的事件分发有点相似
        },
        child: Container(
          width: double.infinity, /// Container 宽度撑满屏幕
          color: Colors.greenAccent,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min, /// Column 主轴 相当于 wrap_content
            children: [
              Builder(builder: (context) {
                /// 如果不加  Builder 而是把 ElevatedButton 直接放在外面；不能正常工作的，
                /// 因为这个context是根Context，而NotificationListener是监听的子树，所以我们通过Builder来构建
                return ElevatedButton(
                    onPressed: () {
                      print("context == $context");
                      MyNotification(msg: "hello world").dispatch(context);
                    },
                    child: Text("notification"));
              }),
              Text(
                _msg,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyNotification extends Notification {
  String msg;

  MyNotification({required this.msg});
}
