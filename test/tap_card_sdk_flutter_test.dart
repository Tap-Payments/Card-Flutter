import 'package:flutter_test/flutter_test.dart';
import 'package:tap_card_sdk_flutter/tap_card_sdk_flutter.dart';
import 'package:tap_card_sdk_flutter/tap_card_sdk_flutter_platform_interface.dart';
import 'package:tap_card_sdk_flutter/tap_card_sdk_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTapCardSdkFlutterPlatform
    with MockPlatformInterfaceMixin
    implements TapCardSdkFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TapCardSdkFlutterPlatform initialPlatform = TapCardSdkFlutterPlatform.instance;

  test('$MethodChannelTapCardSdkFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTapCardSdkFlutter>());
  });

  test('getPlatformVersion', () async {
  //  TapCardSdkFlutter tapCardSdkFlutterPlugin = TapCardSdkFlutter();
    MockTapCardSdkFlutterPlatform fakePlatform = MockTapCardSdkFlutterPlatform();
    TapCardSdkFlutterPlatform.instance = fakePlatform;

   // expect(await tapCardSdkFlutterPlugin.getPlatformVersion(), '42');
  });
}
