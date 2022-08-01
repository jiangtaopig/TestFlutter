import 'package:flutter/material.dart';


enum YKButtonType {
  primary,
  outlined,
  text,
  icon,
  image_text,
}

class YKButton extends StatefulWidget {
  final bool disable;
  final Function onTap;
  final YKButtonType buttonType;
  final int throttlerMilliseconds;

  /// primary&outlined
  final String? title;
  final double fontSize;
  final Color? backgroundColor;
  final Color? borderColor;

  /// icon
  final String? src;
  final double? width;
  final double? height;
  final Color? imageColor;

  /// image_text
  final double spaceing;

  /// 通用
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? color;

  YKButton({
    this.disable = false,
    required this.onTap,
    this.buttonType = YKButtonType.primary,

    ///primary&outlined
    this.title,
    this.fontSize = 16.0,
    this.backgroundColor,
    this.borderColor,

    ///icon
    this.src,
    this.width,
    this.height,
    this.imageColor,

    /// image_text
    this.spaceing = 5.0,

    ///通用
    this.margin,
    this.padding,
    this.color,
    this.throttlerMilliseconds = 500,
  });

  _YKButtonState createState() => _YKButtonState();

//
//  ///防抖动函数：在触发事件时，不立即执行目标操作，而是给出一个延迟的时间，在该时间范围内如果再次触发了事件，则重置延迟时间，直到延迟时间结束才会执行目标操作。
//  Function beBounce = (Function callBack, {Duration delay = const Duration(milliseconds: 500)}) {
////    Timer? timer;
////    Function target = () {
////      if (timer?.isActive ?? false) {
////        timer?.cancel();
////      }
////      timer = Timer(delay, () {
////        callBack?.call();
////      });
////    };
////    return target;
////  };
//
//    Timer? timer;
//    return () {
//      timer?.cancel();
//      timer = Timer(delay, () {
//        callBack.call();
//      });
//    };
//  };
}

class _YKButtonState extends State<YKButton> {
  //记录之前点击事件的时间戳
  int _time = 0;

  @override
  Widget build(BuildContext context) {
    switch (widget.buttonType) {
      case YKButtonType.primary:
        return _PrimaryButton(
          disable: widget.disable,
          onTap: () {
            _throttler(widget.onTap);
          },
          width: widget.width,
          title: widget.title,
          fontSize: widget.fontSize,
          margin: widget.margin,
          padding: widget.padding,
          color: widget.color,
          backgroundColor: widget.backgroundColor,
          borderColor: widget.borderColor,
        );

      case YKButtonType.outlined:
        return _OutlinedButton(
          disable: widget.disable,
          onTap: () {
            _throttler(widget.onTap);
          },
          title: widget.title,
          margin: widget.margin,
          padding: widget.padding,
          color: widget.color,
        );

      case YKButtonType.text:
        return _TextButton(
          disable: widget.disable,
          fontSize: widget.fontSize,
          onTap: () {
            _throttler(widget.onTap);
          },
          title: widget.title,
          color: widget.color,
        );

      case YKButtonType.icon:
        return _IconButton(
          disable: widget.disable,
          onTap: () {
            _throttler(widget.onTap);
          },
          src: widget.src,
          margin: widget.margin,
          padding: widget.padding,
          width: widget.width,
          height: widget.height,
          color: widget.color,
        );

      case YKButtonType.image_text:
        return _ImageTextButton(
          disable: widget.disable,
          onTap: () {
            _throttler(widget.onTap);
          },
          title: widget.title,
          src: widget.src,
          margin: widget.margin,
          padding: widget.padding,
          spaceing: widget.spaceing,
          width: widget.width,
          height: widget.height,
          fontSize: widget.fontSize,
          color: widget.color,
          imageColor: widget.imageColor,
        );
    }
  }

  ///函数节流：在触发事件时，立即执行目标操作，同时给出一个延迟的时间，在该时间范围内如果再次触发了事件，该次事件会被忽略，直到超过该时间范围后触发事件才会被处理。
  _throttler(Function callBack) {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _time > widget.throttlerMilliseconds) {
      _time = now;
      return callBack();
    } else {
      return callBack(timeLeft: widget.throttlerMilliseconds - (now - _time));
    }
  }
}

class _ImageTextButton extends StatelessWidget {
  final String? title;
  final String? src;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double spaceing;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? color;
  final Color? imageColor;
  final bool disable;
  final Function()? onTap;

  _ImageTextButton({
    Key? key,
    this.title,
    this.src,
    this.margin,
    this.padding,
    this.spaceing = 5.0,
    this.width,
    this.height,
    this.fontSize = 16.0,
    this.color,
    this.imageColor,
    this.disable = false,
    this.onTap,
  })  : assert(src != null, "_IconButton的src不能赋值为null！"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disable ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
          margin: margin,
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: spaceing),
                child: Text(
                  title ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: fontSize, color: color),
                ),
              ),
              Image.asset(
                src ?? "",
                width: width,
                height: height,
                color: imageColor,
              ),
            ],
          )),
    );
  }
}

class _IconButton extends StatelessWidget {
  final String? src;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Color? color;
  final bool disable;
  final Function()? onTap;

  _IconButton({
    Key? key,
    this.src,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.color,
    this.disable = false,
    this.onTap,
  })  : assert(src != null, "_IconButton的src不能赋值为null！"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disable ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: margin,
        padding: padding,
        child: Image.asset(
          src ?? "",
          width: width,
          height: height,
          color: color,
        ),
      ),
    );
  }
}

class _TextButton extends StatelessWidget {
  final double fontSize;
  final String? title;
  final Color? color;
  final bool disable;
  final Function() onTap;

  _TextButton({
    Key? key,
    this.fontSize = 14,
    this.title,
    this.color,
    this.disable = false,
    required this.onTap,
  })  : assert(title != null, "_TextButton请设置title！"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disable ? null : onTap,
      child: Text(
        title ?? "",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w300,
            color: color ?? Color(0xFF2A9DFF),
            decoration: TextDecoration.none),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final bool disable;
  final Function() onTap;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? width;
  final String? title;
  final double fontSize;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;

  _PrimaryButton({
    Key? key,
    this.disable = false,
    required this.onTap,
    this.margin,
    this.padding,
    this.width,
    this.title,
    this.fontSize = 16.0,
    this.color,
    this.backgroundColor,
    this.borderColor,
  })  : assert(title != null, "_PrimaryButton请设置title！"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: disable ? null : onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: margin,
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: width ?? double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: backgroundColor ?? Color(0xFF2A9DFF),
            border: Border.all(color: borderColor ?? Colors.transparent, width: 1),
          ),
          child: Text(
            title ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(color: color ?? Colors.white, fontSize: fontSize),
          ),
        ));
  }
}

class _OutlinedButton extends StatelessWidget {
  final bool disable;
  final Function() onTap;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final String? title;
  final double fontSize;
  final Color? color;

  _OutlinedButton({
    Key? key,
    this.disable = false,
    required this.onTap,
    this.margin,
    this.padding,
    this.title,
    this.fontSize = 14.0,
    this.color,
  })  : assert(title != null, "_OutlinedButton请设置title！"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(width: 1, color: color ?? Color(0xFF2A9DFF)),
      ),
      child: GestureDetector(
        onTap: disable ? null : onTap,
        behavior: HitTestBehavior.opaque,
        child: Text(
          title ?? "",
          textAlign: TextAlign.center,
          style: TextStyle(color: color ?? Colors.green, fontSize: fontSize),
        ),
      ),
    );
  }
}
