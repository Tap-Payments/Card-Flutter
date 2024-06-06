import 'card_flutter_platform_interface.dart';

/// An implementation of [CardFlutterPlatform] that uses method channels.
class MethodChannelCardFlutter extends CardFlutterPlatform {
  /// The method channel used to interact with the native platform.
  // @visibleForTesting
  // final methodChannel = const MethodChannel('card_flutter');

  // @override
  // Future<String?> getPlatformVersion() async {
  //   final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
  //   return version;
  // }
}
