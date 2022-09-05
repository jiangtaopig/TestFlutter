import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class KeyboardButtonWidget extends StatelessWidget {
  KeyboardButtonWidget({
    Key? key,
    required this.pressCallback,
    this.iconSrc,
    this.textLabel,
  }) : super(key: key);
  final ValueNotifier<bool> highlightValueNotifier = ValueNotifier(false);

  ///包含了长按和点击
  final Function pressCallback;

  ///icon的图片资源
  final String? iconSrc;

  ///text的文字
  final String? textLabel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTapCancel: () {
          if (kDebugMode) {
            print("拖拽或者轻微滑动都算取消");
          }
        },
        onTapDown: (TapDownDetails what) {
          pressCallback();
        },
        onHighlightChanged: (highlight) {
          highlightValueNotifier.value = highlight;
        },
        child: ValueListenableBuilder(
          valueListenable: highlightValueNotifier,
          builder: (BuildContext context, bool value, Widget? child) {
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(1.5), /// 如果不加 margin ,那么下面设置的 boxShadow 会有部分被裁减
              height: 41.5,
              decoration: BoxDecoration(
                  color: value ? Color(0xff2A9DFF) : Color(0xffFFFFFF),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  // border: Border.all(color: Color(0xff333333), width: 0.2),
                  boxShadow: [
                    BoxShadow(color: Color(0xff333333), blurRadius: 0.2, offset: Offset(1.1, 1.1))
                  ],
              ),
              child: _buildInsideBox(value),
            );
          },
        ));
  }

  Widget _buildInsideBox(bool value) {
    if (iconSrc != null && textLabel == null) {
      return Container(
        alignment: Alignment.center,
        child: Image.asset(
          "images/icon/$iconSrc.png",
          width: 18,
          height: 16.2,
        ),
      );
    } else if (iconSrc == null && textLabel != null) {
      return Text(
        textLabel ?? "",
        textAlign: TextAlign.center,
        style: TextStyle(color: value ? Color(0xffFFFFFF) : Color(0xff333333)),
      );
    }
    return const Text("errorType");
  }
}
