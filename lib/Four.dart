import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/AppConstants.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(FourApp());
}

class FourApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FourAppPage(),
    );
  }
}

class FourAppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FourAppPageState();
  }
}

class _FourAppPageState extends State<FourAppPage> {
  MethodChannel methodChannel =
      new MethodChannel('com.example.flutter_demo/jump_plugin');

  void _jump2NativeSecondActivity() async {
    String result = await methodChannel.invokeMethod('jump2SecondActivity');
    print("_jump2NativeSecondActivity >>> " + result);
  }

  void _sendDataToNative() async {
    Map<String, String> map = {"flutter": "我是flutter 传递过来的"};
    String result = await methodChannel.invokeMethod('mapData', map);
    print(result);
  }

  String nativeReturnString = "not return";

  void _invokeNativeAndGetResult() async {
    String backString;
    try {
      var result = await methodChannel.invokeMethod(
          'getNativeResult', {'key1': 'flutter 参数1', 'key2': 'flutter 参数2'});
      backString = 'Native return $result';
    } on PlatformException catch (e) {
      backString = "Failed to get native return: '${e.message}'.";
    }

    setState(() {
      nativeReturnString = backString;
    });
  }

  void _goBackToNative() {
    if (Navigator.canPop(context)) {
      // 返回上一页
      Navigator.of(context).pop();
    } else {
      methodChannel.invokeMethod('goBack');
    }
  }

  void _send(String method, String args) {
    print('>>>>>>>>>>>>> === ' + method + ', ' + args);
  }

  @override
  Widget build(BuildContext context) {

    print('-----------------');
    methodChannel.setMethodCallHandler((handler) => Future<String>(() {
      print("Native端要调用的方法和参数是：${handler}");
      // 监听native发送的方法名及参数
      switch (handler.method) {
        case "AndroidInvokeFlutter": // Native要求Flutter调用的方法是_send（）
          _send(handler.method , handler.arguments); //handler.arguments表示native传递的方法参数
          break;
      }
      return "Flutter确认消息";
    }));

    return Scaffold(
      appBar: AppBar(
        title: Text('测试 Native 和 Flutter 调用'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.indigo,
            width: 250,
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Strawberry Pavlova',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                    'Pavlova is meringue-based dessert named after Russian ballerine Anna Pavlova.'
                    ' Pavlova features a crisp crust and soft, light inside, topped with fruit and whipped cream'),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  decoration: AppConstants.lineAndBlack,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.red[500],
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.red[500],
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.red[500],
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.red[500],
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.red[500],
                          ),
                        ],
                      ),
                      Text(
                        '170 Reviews',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  decoration: AppConstants.lineAndBlack,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.man_outlined,
                            color: Colors.black,
                          ),
                          Text('Man :'),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('25 min'),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.man_outlined,
                            color: Colors.black,
                          ),
                          Text('Man :'),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('25 min'),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.man_outlined,
                            color: Colors.black,
                          ),
                          Text('Man :'),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('25 min'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    'jump2SecondActivity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('you need study hard !!!'),
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: 'click me',
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.red,
                        textColor: Colors.black,
                        fontSize: 16);

                    print('--------------------------------');
                    _jump2NativeSecondActivity();
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      _sendDataToNative();
                    },
                    child: Text('flutter 向原生传递数据')),
                ElevatedButton(
                    onPressed: () {
                      _invokeNativeAndGetResult();
                    },
                    child:
                        Text('调用原生方法并传参' + '\n原生传递过来的值 $nativeReturnString')),
                ElevatedButton(
                    onPressed: () {
                      _goBackToNative();
                    },
                    child:
                        Text('返回第一个原生activity')),
              ],
            ),
          ),
          Container(
            color: Colors.red,
            padding: EdgeInsets.all(2),
            child: Image.asset(
              'images/zz.png',
              width: 106,
              height: 216,
              fit: BoxFit.fill,
              alignment: Alignment.topLeft,
            ),
          ),
        ],
      ),
    );
  }
}
