import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tap_card_sdk_flutter_method_channel.dart';

abstract class TapCardSdkFlutterPlatform extends PlatformInterface {
  /// Constructs a TapCardSdkFlutterPlatform.
  TapCardSdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static TapCardSdkFlutterPlatform _instance = MethodChannelTapCardSdkFlutter();

  /// The default instance of [TapCardSdkFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelTapCardSdkFlutter].
  static TapCardSdkFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TapCardSdkFlutterPlatform] when
  /// they register themselves.
  static set instance(TapCardSdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
