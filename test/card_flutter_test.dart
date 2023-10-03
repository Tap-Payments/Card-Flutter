import 'package:card_flutter/card_flutter_method_channel.dart';
import 'package:card_flutter/card_flutter_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCardFlutterPlatform
    with MockPlatformInterfaceMixin
    implements CardFlutterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CardFlutterPlatform initialPlatform = CardFlutterPlatform.instance;

  test('$MethodChannelCardFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCardFlutter>());
  });

  test('getPlatformVersion', () async {
    // CardFlutter cardFlutterPlugin = CardFlutter();
    MockCardFlutterPlatform fakePlatform = MockCardFlutterPlatform();
    CardFlutterPlatform.instance = fakePlatform;

    // expect(await cardFlutterPlugin.getPlatformVersion(), '42');
  });
}
