package tap.company.card_flutter;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import company.tap.tapcardformkit.open.web_wrapper.TapCardKit;
import io.flutter.plugin.platform.PlatformView;

import java.util.Map;


class TapCardKitViewManager implements PlatformView {

    private TapCardKit tapCardKit;
    private View view;


    TapCardKitViewManager(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        System.out.println("Params from factory class >>>>>> " + creationParams);
        view = LayoutInflater.from(context).inflate(R.layout.tap_card_kit_layout, null);
        view.setLayoutParams(new ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
        ));
        tapCardKit = view.findViewById(R.id.tapCardForm);
        CardFlutterPlugin.registerPlatformTapCardKit(tapCardKit);
    }

    static boolean focusCardNumber(@Nullable Activity activity) {
        return CardFocusHelper.focusCardNumber(activity);
    }

    @NonNull
    @Override
    public View getView() {
        return view;
    }

    @Override
    public void dispose() {
        CardFlutterPlugin.unregisterPlatformTapCardKit(tapCardKit);
        Activity activity = null;
        if (view != null && view.getContext() instanceof Activity) {
            activity = (Activity) view.getContext();
        }
        CardViewCleanup.disposeCardView(activity);
        if (view != null) {
            view.setVisibility(View.GONE);
        }
        if (tapCardKit != null) {
            tapCardKit.setVisibility(View.GONE);
        }
    }

}
