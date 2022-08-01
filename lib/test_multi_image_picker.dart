import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class TestMultiImagePicker extends StatefulWidget {

  const TestMultiImagePicker({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TestMultiImagePickerState();
  }
}

class _TestMultiImagePickerState extends State<TestMultiImagePicker> {
  List<Asset> images = <Asset>[];
  Uint8List? uint8list = null;
  List<Uint8List> imageBytes = <Uint8List>[];
  List<String?> _imgPathList = [];

  List<Widget> _buildWidget() {
    // List<Widget> widgets = imageBytes.map((e) => _buildImageView(e)).toList();

    List<Widget> widgets2 = _imgPathList.map((e) => _buildImageViewWithPath(e!)).toList();

    widgets2.add(_buildAddWidget());

    // Container container = Container(
    //   color: Colors.amberAccent,
    //   width: 100,
    //   height: 100,
    //   child: Image.file(File("/data/user/0/com.example.flutter_demo/files/images/mmexport1658399472760.jpg")),
    // );
    // widgets.add(container);
    return widgets2;
  }

  Widget _buildImageView(Uint8List uint8list) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      height: 30,
      color: Colors.greenAccent,
      child: Image.memory(uint8list),
    );
  }

  Widget _buildImageViewWithPath(String path) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      height: 30,
      color: Colors.greenAccent,
      child: Image.file(File(path)),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    if (!mounted) return;

    // List<Uint8List> _images = [];
    // if (resultList.isNotEmpty) {
    //   for (Asset asset in resultList) {
    //     var byteData = await asset.getByteData(quality: 100);
    //     Uint8List uint8list =
    //         await fileCompressWithUint8List(byteData.buffer.asUint8List());
    //     _images.add(uint8list);
    //   }
    // }

    List<String?> _imgLocalPathList = [];
    if (resultList.isNotEmpty) {
      for (Asset asset in resultList) {
        if (asset.name != null){
          _imgLocalPathList.add(asset?.name);
        }
      }
    }

    setState(() {
      // imageBytes.addAll(_images);
      _imgPathList.addAll(_imgLocalPathList);
    });
  }

  Future<Uint8List> fileCompressWithUint8List(Uint8List bytes) async {
    int maxCompressTimes = 5;
    int limitSize = 500;
    print("一开始。。。。${bytes.length}, time = ${DateTime.now()}");
    for (var i = 0; i < maxCompressTimes; i++) {
      if (bytes.length / 1024 > limitSize) {
        print("压缩前。。。。${bytes.length} , time = ${DateTime.now()}");
        bytes = await FlutterImageCompress.compressWithList(bytes,
            quality: 95 - i * 10);
      } else {
        break;
      }
    }
    print("压缩后。。。。${bytes.length}, time = ${DateTime.now()}");
    return bytes;
  }

  Future<Uint8List> fileCompressWithUint8List2(Uint8List bytes) async {
    int targetSize = 500;
    print("压缩前。。。。${bytes.length}, time = ${DateTime.now()}");
    // int quality = 100;
    int inSampleSize = 1;
    int byteLength = bytes.length ~/ 1024;
    if (byteLength > targetSize) {
      inSampleSize *= 2;
      // while (byteLength / 2 > targetSize) {
      //
      // }

      bytes =
          await FlutterImageCompress.compressWithList(bytes, quality: 100, inSampleSize:4);
    }
    print("压缩后。。。。${bytes.length}, time = ${DateTime.now()}");
    return bytes;
  }

  Widget _buildAddWidget() {
    return Container(
      color: Colors.white10,
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          loadAssets();
        },
        child: Text('add'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MultiImagePicker'),
      ),
      body: Container(
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: _buildWidget(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TestMultiImagePicker(),
  ));
}
