import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_plugin/first_plugin_method_channel.dart';

void main() {
  MethodChannelFirstPlugin platform = MethodChannelFirstPlugin();
  const MethodChannel channel = MethodChannel('first_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
