package tap.company.tap_card_sdk_flutter;

import io.flutter.embedding.engine.plugins.FlutterPlugin;


/**
 * TapCardSdkFlutterPlugin
 */
public class TapCardSdkFlutterPlugin implements FlutterPlugin {


    private FlutterPluginBinding pluginBinding;


    /**
     * @param binding
     */
    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        TapCardKitFactory tapCardKitFactory;
        tapCardKitFactory = new TapCardKitFactory(binding.getBinaryMessenger());
        FlutterPluginBinding pluginBinding = binding;
        pluginBinding.getPlatformViewRegistry()
                .registerViewFactory("plugin/tap_card_sdk", tapCardKitFactory);
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        pluginBinding = null;
    }
}
