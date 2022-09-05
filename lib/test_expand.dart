import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/test_inherit/base.dart';
import 'package:get/get.dart';

void main() {
  runApp(TestExpandWidget2(
    title: "Stack",
  ));
}

class TestExpandWidget2 extends StatefulWidget {
  final String title;

  TestExpandWidget2({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TestExpandWidgetState();
  }
}

class _TestExpandWidgetState extends State<TestExpandWidget2> {
  bool _showLoading = true;

  @override
  void initState(){
    super.initState();
    D1.show(22);
    Image.network("xxxx");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text(
          'Test Expand',
        )),
        body: Container(
          color: Colors.green,
          child: Column(
            children: [
              Expanded(
                  flex: 40,
                  child: Container(
                    color: Colors.red,
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fdingyue.ws.126.net%2F2020%2F0515%2F465567a6j00qadpfz001cc000hs00b4c.jpg&refer=http%3A%2F%2Fdingyue.ws.126.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1661939185&t=ccc675b5e4c00ef5bc32c21b3c5fa92e',
                      width: 240,
                      height: 200,
                      memCacheHeight: 200,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) {
                        print(
                            "----- downloadProgress ------ ${downloadProgress.progress}");
                        return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: downloadProgress.progress,
                              color: const Color(0xff2A9DFF).withOpacity(0.2),
                            ),
                          ),
                        );
                      },
                    ),
                  )),
              Expanded(
                  flex: 20,
                  child: Container(
                    color: Colors.black,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showLoading = false;
                        });
                      },
                      child: Text('stop loading'),
                    ),
                  )),
              Expanded(
                  flex: 20,
                  child: Container(
                    color: Colors.green,
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.deepOrange,
                        ),
                        _buildShowLoadWidget(_showLoading),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  /// 判断是否是展示 load 遮罩
  _buildShowLoadWidget(bool showLoading) {
    return showLoading
        ? Container(
            color: Color(0xffFFFFFF),
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: const Color(0xff2A9DFF).withOpacity(0.5),
            ))
        : Container();
  }
}
