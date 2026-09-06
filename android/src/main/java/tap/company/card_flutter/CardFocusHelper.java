package tap.company.card_flutter;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.webkit.ValueCallback;
import android.webkit.WebView;

import androidx.annotation.Nullable;

import company.tap.tapcardformkit.open.web_wrapper.TapCardKit;

class CardFocusHelper {

    private static final String FOCUS_CARD_NUMBER_JS =
            "(function(){" +
            "function focusIn(doc){" +
            "if(!doc){return false;}" +
            "var selectors=[" +
            "'input[autocomplete=\"cc-number\"]'," +
            "'input[name*=\"card\"]'," +
            "'input[id*=\"card\"]'," +
            "'input[inputmode=\"numeric\"]'," +
            "'input[type=\"tel\"]'," +
            "'input[type=\"text\"]'," +
            "'input'" +
            "];" +
            "for(var i=0;i<selectors.length;i++){" +
            "var el=doc.querySelector(selectors[i]);" +
            "if(el){el.focus();if(typeof el.click==='function'){el.click();}return true;}" +
            "}" +
            "return false;" +
            "}" +
            "if(focusIn(document)){return 'input';}" +
            "var iframes=document.querySelectorAll('iframe');" +
            "for(var i=0;i<iframes.length;i++){" +
            "try{" +
            "iframes[i].focus();" +
            "if(focusIn(iframes[i].contentDocument||(iframes[i].contentWindow&&iframes[i].contentWindow.document))){return 'iframe-input';}" +
            "}catch(e){}" +
            "}" +
            "return iframes.length?'iframe':'none';" +
            "})();";

    private static final Handler MAIN_HANDLER = new Handler(Looper.getMainLooper());
    private static int retryGeneration = 0;

    static void cancelPendingFocus() {
        retryGeneration++;
    }

    static void scheduleAutoFocus(@Nullable Activity activity, int initialDelayMs, int maxAttempts) {
        retryGeneration++;
        final int generation = retryGeneration;
        attemptFocus(activity, generation, 0, initialDelayMs, maxAttempts);
    }

    static boolean focusCardNumber(@Nullable Activity activity) {
        WebView webView = TapCardKit.cardWebview;
        if (webView == null) {
            return false;
        }
        focusWebView(activity, webView);
        return true;
    }

    private static void attemptFocus(
            @Nullable Activity activity,
            int generation,
            int attempt,
            int delayMs,
            int maxAttempts
    ) {
        MAIN_HANDLER.postDelayed(() -> {
            if (generation != retryGeneration) {
                return;
            }
            WebView webView = TapCardKit.cardWebview;
            if (webView != null) {
                focusWebView(activity, webView);
                return;
            }
            if (attempt + 1 < maxAttempts) {
                attemptFocus(activity, generation, attempt + 1, 300, maxAttempts);
            }
        }, delayMs);
    }

    private static void focusWebView(@Nullable Activity activity, WebView webView) {
        webView.setFocusable(true);
        webView.setFocusableInTouchMode(true);
        webView.requestFocus();
        webView.requestFocusFromTouch();
        simulateTap(webView);
        webView.evaluateJavascript(FOCUS_CARD_NUMBER_JS, new ValueCallback<String>() {
            @Override
            public void onReceiveValue(String value) {
                showKeyboard(activity, webView);
                MAIN_HANDLER.postDelayed(() -> {
                    webView.evaluateJavascript(FOCUS_CARD_NUMBER_JS, null);
                    showKeyboard(activity, webView);
                }, 150);
            }
        });
    }

    private static void simulateTap(WebView webView) {
        float x = Math.max(webView.getWidth(), 1) / 2f;
        float y = Math.max(webView.getHeight(), 1) / 3f;
        long downTime = SystemClock.uptimeMillis();
        MotionEvent down = MotionEvent.obtain(
                downTime,
                downTime,
                MotionEvent.ACTION_DOWN,
                x,
                y,
                0
        );
        MotionEvent up = MotionEvent.obtain(
                downTime,
                downTime + 50,
                MotionEvent.ACTION_UP,
                x,
                y,
                0
        );
        webView.dispatchTouchEvent(down);
        webView.dispatchTouchEvent(up);
        down.recycle();
        up.recycle();
    }

    private static void showKeyboard(@Nullable Activity activity, WebView webView) {
        webView.requestFocus();
        webView.requestFocusFromTouch();
        InputMethodManager imm = null;
        if (activity != null) {
            imm = (InputMethodManager) activity.getSystemService(Context.INPUT_METHOD_SERVICE);
        }
        if (imm == null) {
            imm = (InputMethodManager) webView.getContext()
                    .getSystemService(Context.INPUT_METHOD_SERVICE);
        }
        if (imm != null) {
            imm.showSoftInput(webView, InputMethodManager.SHOW_FORCED);
            imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
        }
    }
}
