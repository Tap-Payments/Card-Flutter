package tap.company.card_flutter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.platform.PlatformView;

import java.util.Map;


/**
 * The card platform view. It is only a container: {@link CardHost} puts the card form in it once
 * the widget starts, so the form can be one that was preloaded before the view existed.
 */
class TapCardKitViewManager implements PlatformView {

    private final FrameLayout container;

    TapCardKitViewManager(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        container = new FrameLayout(context);
        container.setLayoutParams(new ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
        ));
        CardHost.onContainerCreated(container);
    }


    @NonNull
    @Override
    public View getView() {
        return container;
    }

    @Override
    public void dispose() {
        CardHost.onContainerDisposed(container);
    }

}
