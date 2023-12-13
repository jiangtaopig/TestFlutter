import 'package:flutter_test/flutter_test.dart';
import 'package:img_ext/img_ext.dart';
import 'package:img_ext/img_ext_platform_interface.dart';
import 'package:img_ext/img_ext_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockImgExtPlatform
    with MockPlatformInterfaceMixin
    implements ImgExtPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ImgExtPlatform initialPlatform = ImgExtPlatform.instance;

  test('$MethodChannelImgExt is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelImgExt>());
  });

  test('getPlatformVersion', () async {
    ImgExt imgExtPlugin = ImgExt();
    MockImgExtPlatform fakePlatform = MockImgExtPlatform();
    ImgExtPlatform.instance = fakePlatform;

    expect(await imgExtPlugin.getPlatformVersion(), '42');
  });
}
