
import 'img_ext_platform_interface.dart';

class ImgExt {
  Future<String?> getPlatformVersion() {
    return ImgExtPlatform.instance.getPlatformVersion();
  }
}
