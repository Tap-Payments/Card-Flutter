package tap.company.tap_card_sdk_flutter;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import company.tap.tapcardformkit.open.web_wrapper.TapCardKit;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class TapCardKitFactory extends PlatformViewFactory {
    TapCardKitFactory() {
        super(StandardMessageCodec.INSTANCE);
    }

    TapCardKitViewManager tapCardKitViewManager;

    @NonNull
    @Override
    public PlatformView create(@NonNull Context context, int id, @Nullable Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        System.out.println("Tap card sdk factory >>>>>>>>>>" + creationParams);
        tapCardKitViewManager = new TapCardKitViewManager(context, id, creationParams);
        return tapCardKitViewManager;
    }

    public TapCardKit getView() {
        return tapCardKitViewManager.getTapCardKit();
    }


}

