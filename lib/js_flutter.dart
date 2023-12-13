import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_demo/data_shared_instance.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NativeBridge implements JavascriptChannel {
  BuildContext context; //来源于当前widget, 便于操作UI
  Future<WebViewController> _controller; //当前webView 的 controller

  NativeBridge(this.context, this._controller);

  // api 与具体函数的映射表，可通过 _functions[key](data) 调用函数
  get _functions => <String, Function>{"getToken": _getToken};

  @override
  String get name =>
      "nativeBridge"; // js 通过 nativeBridge.postMessage(msg); 调用flutter

  // 处理js请求
  @override
  get onMessageReceived => (msg) async {
    // flutter_web_02 中的 main.dart 调用 获取token的方法,
        // 将收到的string数据转为json
        Map<String, dynamic> message = json.decode(msg.message);
        // 异步是因为有些api函数实现可能为异步，如inputText，等待UI相应
        // 根据 api 字段，调用具体函数

        debugPrint("js 传递过来的参数 >>>> ${msg.message}");

        final data = await _functions[message["api"]](message["data"]);
        debugPrint("data >>>> ${data}");
      };

  //拿token
  Future<String> _getToken(data) async {
    handlerCallback(data);
    invokeJsWithReturn("flutter 调用 js, js 的返回结果 >> ")
    .then((value) => debugPrint("value = $value"));

    // 这里的返回值其实是没必要的
    return Future(() => "ssss");
  }

  handlerCallback(data) {
    if (data['needCallback']) {
      var args = data['callbackArgs'];
      if (data['needToken']) {
        args = "'${data['callbackArgs']}','ttttttoken'";
      }
      doCallback(data['callbackName'], args);
    }
  }

  doCallback(name, args) {
    _controller
        .then((value) => value.runJavascriptReturningResult("$name($args)"));
  }

  Future<String> invokeJsWithReturn(msg) {
    Future<String> f = _controller
        .then((value) => value
            .runJavascriptReturningResult("flutterInvokeJsWithReturn('$msg')")) /// 调用js代码， flutterInvokeJsWithReturn
        .then((value) => value); /// 箭头函数内只能写一条语句，并且语句后面没有分号(;)

    return f;
  }
}
