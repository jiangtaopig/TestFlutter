import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'first_plugin_platform_interface.dart';

/// An implementation of [FirstPluginPlatform] that uses method channels.
class MethodChannelFirstPlugin extends FirstPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('first_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
