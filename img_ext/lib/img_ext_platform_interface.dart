import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'img_ext_method_channel.dart';

abstract class ImgExtPlatform extends PlatformInterface {
  /// Constructs a ImgExtPlatform.
  ImgExtPlatform() : super(token: _token);

  static final Object _token = Object();

  static ImgExtPlatform _instance = MethodChannelImgExt();

  /// The default instance of [ImgExtPlatform] to use.
  ///
  /// Defaults to [MethodChannelImgExt].
  static ImgExtPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ImgExtPlatform] when
  /// they register themselves.
  static set instance(ImgExtPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
