import 'package:flutter_test/flutter_test.dart';
import 'package:first_plugin/first_plugin.dart';
import 'package:first_plugin/first_plugin_platform_interface.dart';
import 'package:first_plugin/first_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFirstPluginPlatform 
    with MockPlatformInterfaceMixin
    implements FirstPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FirstPluginPlatform initialPlatform = FirstPluginPlatform.instance;

  test('$MethodChannelFirstPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFirstPlugin>());
  });

  test('getPlatformVersion', () async {
    FirstPlugin firstPlugin = FirstPlugin();
    MockFirstPluginPlatform fakePlatform = MockFirstPluginPlatform();
    FirstPluginPlatform.instance = fakePlatform;
  
    expect(await firstPlugin.getPlatformVersion(), '42');
  });
}
