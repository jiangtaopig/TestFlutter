import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/keyboard/yk_button.dart';

import 'keyboard_button_widget.dart';

void main() {
  runApp(MaterialApp(home: Scaffold(
    body: PhoneKeyboard(),
  ),));
}

class PhoneKeyboard extends StatelessWidget {
  const PhoneKeyboard();

  final List<String> _numberArray = const [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "",
    "0"
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double itemHeight = (mediaQuery.size.width - 32) / 3 / 2.3;
    double backHeight = (itemHeight + 8) * 4;
    
    print("--- backHeight = $backHeight");
    return Material(
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Expanded(
                  flex: 45,
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.only(right: 10),
                      color: Colors.deepOrange,)),
              Expanded(
                  flex: backHeight.toInt(),
                  child: Padding(
                    //给按键border一定的空间展示
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _numberArray.length + 1,
                        //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                //横轴元素个数
                                crossAxisCount: 3,
                                //纵轴间距
                                mainAxisSpacing: 8.0,
                                //横轴间距
                                crossAxisSpacing: 8.0,
                                //子组件宽高长度比例
                                childAspectRatio: 2),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == _numberArray.length) {
                            // 删除按键
                            return Text('删除');
                          } else {
                            if (_numberArray[index] == "") {
                              return const SizedBox.shrink();
                            }
                            return KeyboardButtonWidget(
                              textLabel: _numberArray[index],
                              pressCallback: () {
                                HapticFeedback.heavyImpact();
                                String value = _numberArray[index];
                              },
                            );
                          }
                        }),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  /// 输入按钮

  _getItemBackColor(int index) {
    String itemTitle = _numberArray[index];
    if (itemTitle == '') {
      return const Color(0xffE5E5E5);
    } else {
      return Color(0xffFFFFFF);
    }
  }
}
