import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'first_plugin_method_channel.dart';

abstract class FirstPluginPlatform extends PlatformInterface {
  /// Constructs a FirstPluginPlatform.
  FirstPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FirstPluginPlatform _instance = MethodChannelFirstPlugin();

  /// The default instance of [FirstPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFirstPlugin].
  static FirstPluginPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FirstPluginPlatform] when
  /// they register themselves.
  static set instance(FirstPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
