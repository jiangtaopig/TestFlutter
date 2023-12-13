import 'package:flutter/material.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'data_shared_instance.dart';

class ZhuBridge implements JavascriptChannel {

  BuildContext context; //来源于当前widget, 便于操作UI
  Future<WebViewController> _controller; //当前webView 的 controller

  ZhuBridge(this.context, this._controller);


  @override
  String get name => "zhuBridge";

  @override
  JavascriptMessageHandler get onMessageReceived => (msg) async {
    var message = msg.message;
    var v = DataSharedInstance().getMyData();
    debugPrint("-------------- ZhuBridge === v = $v, message = $message");

    /// 将数据回调给 js
    invokeJs("flutter 数据返回token", v);
  };

  void invokeJs(var title, var content) {
    _controller
        .then((value) => value
        .runJavascriptReturningResult("flutterInvokeJs('$title', '$content')"));
  }

}