#include "include/tap_card_sdk_flutter/tap_card_sdk_flutter_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "tap_card_sdk_flutter_plugin.h"

void TapCardSdkFlutterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  tap_card_sdk_flutter::TapCardSdkFlutterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
