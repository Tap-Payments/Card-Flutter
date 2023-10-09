import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'card_flutter_method_channel.dart';

abstract class CardFlutterPlatform extends PlatformInterface {
  /// Constructs a CardFlutterPlatform.
  CardFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static CardFlutterPlatform _instance = MethodChannelCardFlutter();

  /// The default instance of [CardFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelCardFlutter].
  static CardFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CardFlutterPlatform] when
  /// they register themselves.
  static set instance(CardFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
