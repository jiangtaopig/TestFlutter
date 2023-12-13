import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() =>
    runApp(MaterialApp(
        home: WebViewPage(
            url: 'http://10.118.14.48:9890/my.html',
            isLocalUrl: false,
            title: 'web 页面')));

class WebViewPage extends StatefulWidget {
  String url;
  final String title;
  final bool isLocalUrl;

  WebViewController? _webViewController;

  WebViewPage(
      {required this.url, this.isLocalUrl = false, required this.title});

  @override
  _WebViewPage createState() => _WebViewPage();
}

class _WebViewPage extends State<WebViewPage> {
  JavascriptChannel jsBridge(BuildContext context) =>
      JavascriptChannel(
          name: 'jsbridge', // 与h5 端的一致 不然收不到消息
          onMessageReceived: (JavascriptMessage message) async {
            debugPrint(message.message);
          });

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(), body: _buildBody());
  }

  _buildAppbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Color(0xccd0d7),
      title: Text(
        widget.title,
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF23ADE5),
          ),
          onPressed: () async {
            var canGoBack = await widget._webViewController?.canGoBack();
            debugPrint(">>>>>>>>>> canGoBack = $canGoBack");
            if (canGoBack != null && canGoBack) {
              widget._webViewController?.goBack();
            }
          }),
      actions: [
        IconButton(
          onPressed: () async {
            var canGoForward = await widget._webViewController?.canGoForward();
            debugPrint(">>>>>>>>>> canGoForward = $canGoForward");
            if (canGoForward != null && canGoForward) {
              widget._webViewController?.goForward();
            }
          },
          icon: Icon(Icons.arrow_forward),
          color: Color(0xFF23ADE5),
        )
      ],
    );
  }

  _buildBody() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 1,
          width: double.infinity,
          child: const DecoratedBox(
              decoration: BoxDecoration(color: Color(0xFFEEEEEE))),
        ),
        ElevatedButton(
            onPressed: () {
              // Flutter 调用 js 且有返回值
              Future<String>? res = widget._webViewController?.
              runJavascriptReturningResult("flutterCallJsMethod('Flutter调用了JS，点击确定收到返回值并Toast')");
              res?.then((value) => {
                print("flutter 调用 js后，js 的返回值为：" + value)
              });
            },
            child:Text('Flutter 调用 js'),
        ),

        ElevatedButton(onPressed: (){
          widget._webViewController?.
          runJavascript("flutterCallJsMethod2('flutter 调用 js，且展示在页面上')");
        }, child: Text('Flutter 调用 js2')),

        Expanded(
          flex: 1,
          child: WebView(
            initialUrl: widget.isLocalUrl
                ? Uri.dataFromString(widget.url,
                mimeType: 'text/html',
                encoding: Encoding.getByName('utf-8'))
                .toString()
                : widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: {
              JavascriptChannel(
                /// js 调用 Flutter 的代码， ZhuToast 是在 js 文件中定义的
                  name: "ZhuToast",
                  onMessageReceived: (message) {
                    var data = message.message;
                    print("ZhuToast data = $data, runtimeType = ${data.runtimeType}");

                    // String ss = '{"name":"zjt", "age":23 }';
                    var dd = jsonDecode(data);
                    print("dd = $dd, runtimeType = ${dd.runtimeType}");
                  }),

              JavascriptChannel(
                name: "jscomm",
                onMessageReceived: (msg) {
                  var data = msg.message;
                  print("jscomm  data = $data, runtimeType = ${data.runtimeType}");
                  // flutter 调用 js 的方法，把结果回调给 js
                  widget._webViewController?.
                  runJavascript("flutterCallJsMethod2('js 调用 flutter 后，flutter 把结果回调给 js')");
                }
              ),
            },
            onWebViewCreated: (WebViewController controller) {
              widget._webViewController = controller;
              if (widget.isLocalUrl) {
                _loadHtmlAssets(controller);
              } else {
                print("------------ not local url ------------------");
                controller.loadUrl(widget.url);
              }
              controller
                  .canGoBack()
                  .then((value) => debugPrint(value.toString()));
              controller
                  .canGoForward()
                  .then((value) => debugPrint(value.toString()));
              controller.currentUrl().then((value) => debugPrint(value));
            },
            onPageFinished: (String value) {
              if (widget._webViewController != null) {
                widget._webViewController!
                    .runJavascriptReturningResult('document.title')
                    .then(
                        (title) => debugPrint("=========== title = ${title}"));
              }
            },
          ),
        )
      ],
    );
  }

//加载本地文件
  _loadHtmlAssets(WebViewController controller) async {
    String htmlPath = await rootBundle.loadString(widget.url);
    controller.loadUrl(Uri.dataFromString(htmlPath,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
