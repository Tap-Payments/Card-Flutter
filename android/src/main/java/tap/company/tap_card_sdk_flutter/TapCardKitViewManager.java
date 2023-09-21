package tap.company.tap_card_sdk_flutter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import company.tap.tapcardformkit.open.web_wrapper.TapCardKit;
import io.flutter.plugin.platform.PlatformView;

import java.util.Map;


class TapCardKitViewManager implements PlatformView {


    private TapCardKit tapCardKit;
    private View view;


    TapCardKitViewManager(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        System.out.println("Params from factory class >>>>>> " + creationParams.get("amount"));
        view = LayoutInflater.from(context).inflate(R.layout.tap_card_kit_layout, null);
        tapCardKit = view.findViewById(R.id.tapCardForm);
    }


    @NonNull
    @Override
    public View getView() {
        return view;
    }

    @Override
    public void dispose() {
    }

}
