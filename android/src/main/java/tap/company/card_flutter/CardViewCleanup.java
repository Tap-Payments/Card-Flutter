package tap.company.card_flutter;

import android.app.Activity;
import android.content.Context;
import android.os.IBinder;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.webkit.WebView;

import androidx.annotation.Nullable;

import company.tap.tapcardformkit.open.web_wrapper.TapCardKit;

class CardViewCleanup {

    static void dismissKeyboard(@Nullable Activity activity) {
        CardFocusHelper.cancelPendingFocus();
        WebView webView = TapCardKit.cardWebview;
        if (webView != null) {
            webView.post(() -> {
                webView.clearFocus();
                hideKeyboard(webView.getContext(), webView.getWindowToken());
            });
        }
        if (activity == null) {
            return;
        }
        activity.runOnUiThread(() -> {
            View focus = activity.getCurrentFocus();
            if (focus != null) {
                focus.clearFocus();
                hideKeyboard(activity, focus.getWindowToken());
            }
            hideKeyboard(activity, activity.getWindow().getDecorView().getWindowToken());
        });
    }

    static void disposeCardView(@Nullable Activity activity) {
        dismissKeyboard(activity);
        WebView webView = TapCardKit.cardWebview;
        if (webView == null) {
            return;
        }
        webView.post(() -> {
            webView.stopLoading();
            webView.loadUrl("about:blank");
            webView.setVisibility(View.GONE);
            webView.clearFocus();
            hideKeyboard(webView.getContext(), webView.getWindowToken());
        });
    }

    private static void hideKeyboard(Context context, @Nullable IBinder windowToken) {
        if (windowToken == null) {
            return;
        }
        InputMethodManager imm = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
        if (imm != null) {
            imm.hideSoftInputFromWindow(windowToken, 0);
        }
    }
}
