import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'img_ext_platform_interface.dart';

/// An implementation of [ImgExtPlatform] that uses method channels.
class MethodChannelImgExt extends ImgExtPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('img_ext');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
