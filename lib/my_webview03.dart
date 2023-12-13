import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_demo/zhu_js_channel.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import 'js_flutter.dart';

void main() => runApp( MaterialApp(home: WebViewPage('http://10.118.14.48:9890?a=4&b=4')));

class WebViewPage extends StatefulWidget {
  static String routeName = "/web_view";
  String url;

  WebViewPage(this.url, {Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final _webViewController = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: WebView(
        javascriptChannels:
        [
          NativeBridge(context, _webViewController.future),
          ZhuBridge(context, _webViewController.future)
        ].toSet(),
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted, // 使用JS没限制
        onWebViewCreated: (WebViewController webViewController) async {
          // 在WebView创建完成后会产生一个 webViewController
          _webViewController.complete(webViewController);

          var url = await webViewController.currentUrl();
          debugPrint(" ====== current url is : $url");
          if (url != null) {
            var uri = Uri.parse(url);
            Map<String, String> params = uri.queryParameters;
            var pp = jsonEncode(uri.queryParameters);
            var query = uri.query;
            var path = uri.path;
            debugPrint(" ====== current url params : $params, query = $query, path = $path, pp = $pp");
          }
        },
      ),
    );
  }
}