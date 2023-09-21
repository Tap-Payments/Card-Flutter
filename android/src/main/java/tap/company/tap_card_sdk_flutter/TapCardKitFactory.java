package tap.company.tap_card_sdk_flutter;

import android.content.Context;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import company.tap.tapcardformkit.open.web_wrapper.TapCardKit;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class TapCardKitFactory extends PlatformViewFactory {

    private final BinaryMessenger messenger;

    TapCardKitFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    TapCardKitViewManager tapCardKitViewManager;


    @NonNull
    @Override
    public PlatformView create(@NonNull Context context, int id, @Nullable Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        System.out.println("Configuration from example app >>>>>>>>>>" + creationParams);
        tapCardKitViewManager = new TapCardKitViewManager(context, id, creationParams, messenger);
        ;
        return tapCardKitViewManager;
    }
}