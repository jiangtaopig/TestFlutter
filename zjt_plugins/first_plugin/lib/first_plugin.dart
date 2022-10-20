
import 'first_plugin_platform_interface.dart';

class FirstPlugin {
  Future<String?> getPlatformVersion() {
    return FirstPluginPlatform.instance.getPlatformVersion();
  }
}
