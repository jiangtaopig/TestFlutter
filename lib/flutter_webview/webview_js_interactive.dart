import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text(
          "flutter 和 js 交互",
          textDirection: TextDirection.ltr,
        )),
        body: const Web(),
      ),
    );
  }
}

class Web extends StatefulWidget {
  const Web({Key? key}) : super(key: key);

  @override
  _WebState createState() => _WebState();
}

class _WebState extends State<Web> {
  String _url = "assets/my_local.html";
  WebViewController? _controller;

  _loadHtmlFromAssets() async {
    String fileHtmlContents = await rootBundle.loadString(_url);
    _controller?.loadUrl(Uri.dataFromString(fileHtmlContents,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      ///JS显示弹窗使用
      WebView.platform = SurfaceAndroidWebView();
    }
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            if (_controller != null) {
              _controller!
                  .runJavascriptReturningResult(
                      "flutterCallJsMethod('Flutter调用了JS，点击确定收到返回值并Toast')")
                  .then((value) {
                // Fluttertoast.showToast(msg: value.toString());
              });
            }
          },
          child: Text("Flutter 调用 JS 有返回值"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller != null) {
              _controller!
                  .runJavascript("flutterCallJsMethodNoResult('Flutter调用了JS')");
            }
          },
          child: Text("Flutter 调用 JS 无返回值"),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Flexible(
            child: WebView(
          initialUrl: "",
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: {
            JavascriptChannel( /// js 调用 Flutter 的代码， ZhuToast 是在 js 文件中定义的
                name: "ZhuToast",
                onMessageReceived: (message) {
                  var data = message.message;
                  print("data = $data, runtimeType = ${data.runtimeType}");

                  // String ss = '{"name":"zjt", "age":23 }';
                  var dd = jsonDecode(data);
                  print("dd = $dd, runtimeType = ${dd.runtimeType}");

                }),
            JavascriptChannel(
                name: "jscomm",

                /// 这个需要修改 JavaScriptChannel.java 文件，所以这里无法运行
                onMessageReceived: (message) {
                  dynamic result = json.decode(message.message);
                  String event = result["event"];
                  String data = result["data"];
                  print("webview_js_interactive >>> event ");
                }),
          },
          onWebViewCreated: (controller) {
            _controller = controller;
            _loadHtmlFromAssets();
          },
        ))
      ],
    );
  }
}
