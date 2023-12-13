import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageWaterMarkUtils {
  //拿到图片的字节数组
  static  Future<ui.Image> loadImageByFile(String path) async {
    var list = await File(path).readAsBytes();
    return loadImageByUint8List(list);
  }

//通过[Uint8List]获取图片
  static Future<ui.Image> loadImageByUint8List(Uint8List list) async {
    ui.Codec codec = await ui.instantiateImageCodec(list);
    ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }


  /**
   * imagePath ：图片的路径
   * content ：水印的文字
   */
  static imageAddWaterMark(String imagePath, String content) async {
    double width, height;

    //拿到Canvas
    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Canvas canvas = new Canvas(recorder);

    //拿到Image对象
    ui.Image image = await loadImageByFile(imagePath);
    width = image.width!.toDouble();
    height = image.height!.toDouble();


    // 绘制图片
    canvas.drawImage(image, Offset(0, 0), Paint());
    canvas.saveLayer(Rect.fromLTWH(0, 0, image.width!.toDouble(), image.height!.toDouble()), Paint()..blendMode = BlendMode.multiply);

    double backGroundWidth = 300;

    Rect rectBg = Rect.fromLTWH(0, height- backGroundWidth , width, backGroundWidth);
    Paint paint =Paint()
      ..color = const Color(0x66000000)
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    canvas.drawRect(rectBg, paint);
    canvas.restore();

    // /// 1.生成 ParagraphStyle，可设置文本的基本信息
    final paragraphStyle = ui.ParagraphStyle();
    /// 2.根据 ParagraphStyle 生成 ParagraphBuilder
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle);
    /// 3.添加样式和文字
    paragraphBuilder
      ..pushStyle(ui.TextStyle(color: Colors.white, fontSize:60))
      ..addText('拍照时间:2023-12-09 13:25:12\n')
      ..pushStyle(ui.TextStyle(color: Colors.white, fontSize:60))
      ..addText(content)
    ;
    /// 4.通过 build 取到 Paragraph
    final paragraph = paragraphBuilder.build();
    /// 5.根据宽高进行布局layout
    paragraph.layout(ui.ParagraphConstraints(width: width));
    /// 6.绘制文字， 设置左上边距
    double leftMargin = 40;
    double topMargin = 60;
    canvas.drawParagraph(paragraph,  Offset(leftMargin, height - backGroundWidth + topMargin));

    // canvas.restore();
    ui.Picture picture = recorder.endRecording();
    final img = await picture.toImage(width.toInt(), height.toInt());
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    final Directory directory = await getTemporaryDirectory();
    final Directory imageDirectory = await Directory('${directory.path}/image/').create(recursive: true);
    String targetPath = imageDirectory.path;

    File file = File('${targetPath}watermark${DateTime.now().millisecondsSinceEpoch}.png');
    file.writeAsBytesSync(pngBytes!.buffer.asInt8List());

    // 图片压缩
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 95,
      rotate: 0,
    );
    file.writeAsBytesSync(result as List<int>);
    return file;
  }
}