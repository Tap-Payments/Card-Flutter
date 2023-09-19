#ifndef FLUTTER_PLUGIN_TAP_CARD_SDK_FLUTTER_PLUGIN_H_
#define FLUTTER_PLUGIN_TAP_CARD_SDK_FLUTTER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace tap_card_sdk_flutter {

class TapCardSdkFlutterPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  TapCardSdkFlutterPlugin();

  virtual ~TapCardSdkFlutterPlugin();

  // Disallow copy and assign.
  TapCardSdkFlutterPlugin(const TapCardSdkFlutterPlugin&) = delete;
  TapCardSdkFlutterPlugin& operator=(const TapCardSdkFlutterPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace tap_card_sdk_flutter

#endif  // FLUTTER_PLUGIN_TAP_CARD_SDK_FLUTTER_PLUGIN_H_
