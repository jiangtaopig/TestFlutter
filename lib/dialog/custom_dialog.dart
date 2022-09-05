import 'package:flutter/material.dart';

class CustomDialog extends Dialog {
  final double width; // 宽度
  final double height; // 高度
  final String title; // 顶部标题
  final String? content; // 内容
  final String cancelTxt; // 取消按钮的文本
  final String enterTxt; // 确认按钮的文本
  final Function callback; // 修改之后的回掉函数

  CustomDialog({
    this.width: 270,
    this.height: 141,
    required this.title,
    required this.content, // 根据content来，判断显示哪种类型
    this.cancelTxt: "取消",
    this.enterTxt: "确认",
    required this.callback
  });

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil(width: 375, height: 812)..init(context); // 屏幕适配
    String _inputVal = "";

    return GestureDetector( // 点击遮罩层隐藏弹框
        child: Material(
            type: MaterialType.transparency, // 配置透明度
            child: Center(
                child: GestureDetector( // 点击遮罩层关闭弹框，并且点击非遮罩区域禁止关闭
                    onTap: () {
                      print('我是非遮罩区域～');
                    },
                    child: Container(
                        width: this.width,
                        height: this.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Visibility(
                                  visible: this.content == null ? true : false,
                                  child: Positioned(
                                      top: 0,
                                      child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.fromLTRB(0, 19, 0, 19),
                                          child: Text(
                                              "${this.title}",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600
                                              )
                                          )
                                      )
                                  )
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  alignment: Alignment.center,
                                  child: this.content != null ?
                                  Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 42),
                                      alignment: Alignment.center,
                                      child: Text(
                                          "${this.content}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600
                                          )
                                      )
                                  )
                                      :
                                  TextField(
                                      textAlignVertical: TextAlignVertical.center,
                                      style: TextStyle(
                                          fontSize: 14
                                      ),
                                      textInputAction: TextInputAction.send,
                                      decoration: new InputDecoration(
                                        hintText: '${this.title}',
                                        contentPadding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
                                        enabledBorder: OutlineInputBorder( // 边框默认色
                                            borderSide: const BorderSide(color: Color(0xffC8C7CC))
                                        ),
                                        focusedBorder: OutlineInputBorder( // 聚焦之后的边框色
                                            borderSide: const BorderSide(color: Color(0xfff3187D2))
                                        ),
                                      ),
                                      onChanged: (value) {
                                        _inputVal = value;
                                      }
                                  )
                              ),
                              Container(
                                  height: 43,
                                  decoration: BoxDecoration(
                                      border: Border(top: BorderSide(width: 1,color: Color(0xffEFEFF4)))
                                  ),
                                  child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                                behavior: HitTestBehavior.opaque,
                                                child: Container(
                                                    height: double.infinity,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1,color: Color(0xffEFEFF4)))
                                                    ),
                                                    child: Text(
                                                        "${this.cancelTxt}",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(0xff007AFF),
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w400
                                                        )
                                                    )
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                }
                                            )
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                                behavior: HitTestBehavior.opaque,
                                                child: Container(
                                                    height: double.infinity, // 继承父级的高度
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        "${this.enterTxt}",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(0xff007AFF),
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w600
                                                        )
                                                    )
                                                ),
                                                onTap: () {
                                                  this.callback(_inputVal);
                                                  Navigator.pop(context); // 关闭dialog
                                                }
                                            )
                                        )
                                      ]
                                  )
                              )
                            ]
                        )
                    )
                )
            )
        ),
        onTap: () {
          Navigator.pop(context);
        }
    );
  }
}
