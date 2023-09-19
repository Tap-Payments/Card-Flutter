
import 'tap_card_sdk_flutter_platform_interface.dart';

class TapCardSdkFlutter {
  Future<String?> getPlatformVersion() {
    return TapCardSdkFlutterPlatform.instance.getPlatformVersion();
  }
}
