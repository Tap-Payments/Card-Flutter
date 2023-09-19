import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tap_card_sdk_flutter/tap_card_sdk_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelTapCardSdkFlutter platform = MethodChannelTapCardSdkFlutter();
  const MethodChannel channel = MethodChannel('tap_card_sdk_flutter');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
