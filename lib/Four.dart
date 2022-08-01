import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/AppConstants.dart';
// import 'package:fluttertoast/fluttertoast.dart';

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

/// 箭头表达式：如果函数体内只有一个表达式，那么就可以使用箭头函数来简化代码
Function test = (a) => a * a;

/// 高阶函数
int add(int a, Function opt) {
  return opt(a);
}

int add2(int a, int b, Function opt) {
  return opt(a, b);
}

int f1() {
  return add2(2, 3, (a, b) {
    return a + b;
  });
}

class _FourAppPageState extends State<FourAppPage> {
  MethodChannel methodChannel =
      new MethodChannel('com.example.flutter_demo/jump_plugin');

  void _jump2NativeSecondActivity() async {
    String result = await methodChannel.invokeMethod('jump2SecondActivity');
    print("_jump2NativeSecondActivity >>> " + result);
    int v = test(3);
    print(v);
    add(4, test);
  }

  void _sendDataToNative() async {
    print('flutter 开始向 Native 传递数据');
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

    setState(() => nativeReturnString = backString); // 或者写成如下的形式

    setState(() {
      // nativeReturnString = backString;
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
    // Fluttertoast.showToast(
    //     msg: method + args,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 3,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.black,
    //     fontSize: 16);
  }

  final TextEditingController _controller =
      TextEditingController(text: "我是 TextField 设置的值");
  FocusNode _commentFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.selection = TextSelection.fromPosition(
        TextPosition(affinity: TextAffinity.downstream, offset: 3));
  }

  @override
  Widget build(BuildContext context) {
    print('-----------------=======----------------');
    methodChannel.setMethodCallHandler((handler) => Future<String>(() {
          print("Native端要调用的方法和参数是：${handler}");
          // 监听native发送的方法名及参数
          switch (handler.method) {
            case "AndroidInvokeFlutter": // Native要求Flutter调用的方法是_send（）
              _send(handler.method,
                  handler.arguments); //handler.arguments表示native传递的方法参数
              break;
          }
          return "Flutter 的确认消息";
        }));

    return Scaffold(
      appBar: AppBar(
        title: Text('测试 Native 和 Flutter 调用'),
      ),
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        /// 类似于ScrollView，可以进行滚动，且点击输入框时，输入框会随着软键盘顶起来。
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.indigo,
              width: 212,
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
                      'Pavlova features a crisp crust and soft, light inside, topped with fruit and whipped cream.'),
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
                    subtitle: Text(
                      // Text 加省略号
                      'you need study hard !!! you need study hard',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    onTap: () {
                      // Fluttertoast.showToast(
                      //     msg: 'click me',
                      //     gravity: ToastGravity.CENTER,
                      //     timeInSecForIosWeb: 3,
                      //     backgroundColor: Colors.red,
                      //     textColor: Colors.black,
                      //     fontSize: 16);

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
                      child: Text('返回第一个原生activity')),
                  TextField(
                    controller: _controller,
                    focusNode: _commentFocus,
                    decoration: new InputDecoration(
                      hintText: 'input sth',
                    ),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(6) //限制长度
                    ],
                    onChanged: (text) {
                      print("onChanged text = $text");
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _commentFocus.unfocus(); // 输入框失去焦点
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('what you input'),
                                content: Text(_controller.text),
                              );
                            });
                      },
                      child: Text('Show dialog')),
                  ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(_commentFocus);
                      },
                      child: Text('输入框获取焦点')),
                  ElevatedButton(
                      onPressed: () {
                        var sb = StringBuffer();
                        //..级联符实现链式调用
                        sb
                          ..write('aaa')
                          ..write('bbb')
                          ..write('ccc');
                        //第二个参数表示分隔符，将第一个参数列表里的数据用这个分隔符拼接起来
                        sb.writeAll(['ddd', 'eee', 'fff'], ',');
                        print('sb : $sb');

                        /// 输出结果： aaabbbcccddd,eee,fff
                        testFuture();
                        var addFunc = makeAddFunc(2);
                        print(addFunc.runtimeType);
                        int val = addFunc(3);
                        print('val = $val');
                      },
                      child: Text('测试 Dart 语法的级联操作符')),
                  ElevatedButton(
                      onPressed: () {
                        /// 把函数赋值给函数类型的变量
                        Function f = _userName;
                        f("123");
                        testFunctionInvoke(_userName,
                            "zhu"); // 或者 testFunctionInvoke(f, "zhu")

                        testFunctionInvoke((a) {
                          print('-------- testFunctionInvoke ------- a = $a');
                        }, "xxxx");
                        print(_userName("---"));

                        int vv = f1();
                        print("vv >> $vv");
                        int mul = add2(3, 4, (a, b) => a * b);
                        print("mul = $mul");
                        int div = add2(8, 2, (a, b) {
                          double v = a / b;
                          return v.toInt();
                        });
                        print("div = $div");

                        /// ... 用来拼接 集合 、map
                        List<String> l1 = ["1", "2"];
                        List<String> l2 = [...l1, "3"];
                        List<String> l3 = ["44", ...l2];
                      },
                      child: Text('函数Function使用')),
                  InkWell(
                    splashColor: Colors.red,
                    highlightColor: Colors.greenAccent,
                    onTap: () {
                      print('-----------水波纹效果点击----------');
                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      child: Text('水波纹效果'),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.red,
              padding: EdgeInsets.all(2),
              child: Image.asset(
                'images/zz.png',
                width: 86,
                height: 216,
                fit: BoxFit.fill,
                alignment: Alignment.topLeft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 函数没有显示定义返回值类型，那么默认返回 null， print(_userName('ddd')) ==> 输出 null
_userName(String name) {
  print("userName >>> name = $name");
}

/// 函数作为另一个函数的参数
testFunctionInvoke(Function opt, String name) {
  opt(name);
}

void testFuture() {
  print("----- start -------");

  /// 由于 dart 是单线程的，所以采用的是非阻塞的调用，即 getResponse 方法不会阻塞 main线程
  /// 是根据事件循环来获取网络请求或者 IO 操作的执行结果。所以下面的代码会先输出 ---- end ---
  /// 等 getResponse 执行完才会输出 value = xxx
  print(getResponse().then((value) => print('value = $value')));
  print("----- end -------");
}

/// 返回的是函数类型 (int) => int
Function makeAddFunc(int x) {
  x++;
  return (int y) => x + y;
}

Future<String> getResponse() async {
  String res = await Future.delayed(Duration(seconds: 2), () {
    return "network data";
  });
  var data = "请求结果" + res;
  print('data >>> $data');
  return data;
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
