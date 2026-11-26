package tap.company.card_flutter;

import android.content.Context;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.webkit.WebView;
import android.widget.FrameLayout;

import androidx.annotation.Nullable;

import java.util.Map;
import java.util.Objects;

import company.tap.tapcardformkit.open.web_wrapper.TapCardKit;

/**
 * Decides which card form ({@link TapCardKit}) the platform view shows, and holds a form
 * loaded ahead of time by {@code TapCardSDK.preload}.
 *
 * <p>Card-Android keeps the card web view in static state ({@code TapCardKit.cardWebview}), so
 * the app can only have one live card form. The platform view therefore only provides an empty
 * container, and the form is put in it once the widget starts: either the preloaded form, or a
 * new one.
 */
final class CardHost {

    private CardHost() {
    }

    /** Container of the card platform view currently on screen, if any. */
    @Nullable
    private static FrameLayout container;
    /** The form shown in {@link #container}. */
    @Nullable
    private static TapCardKit shownKit;

    /** A form loaded by preload and not shown yet. */
    @Nullable
    private static TapCardKit preloadedKit;
    /** The preload arguments: configuration, cardNumber and cardExpiry. */
    @Nullable
    private static Map<String, Object> preloadedArgs;
    /** A preload asked for while a card was on screen, started once that card is gone. */
    @Nullable
    private static Runnable deferredPreload;

    static void onContainerCreated(FrameLayout newContainer) {
        container = newContainer;
        attachShownKit();
    }

    static void onContainerDisposed(FrameLayout disposedContainer) {
        if (container != disposedContainer) return;
        // When a TapCardKit leaves the window, the SDK destroys the static web view, not the
        // TapCardKit's own one. Point it at the form being removed for the duration of the
        // removal, in case Flutter has not removed the view yet.
        WebView current = TapCardKit.Companion.getCardWebview();
        WebView leaving = webViewOf(shownKit);
        if (leaving != null) TapCardKit.Companion.setCardWebview(leaving);
        disposedContainer.removeAllViews();
        if (leaving != null && current != leaving) TapCardKit.Companion.setCardWebview(current);
        container = null;
        shownKit = null;
        Runnable preload = deferredPreload;
        deferredPreload = null;
        if (preload != null) preload.run();
    }

    /**
     * Runs {@code preload} now, or once the card on screen is gone. Flutter takes a card view out
     * of the window before disposing it, and the SDK then destroys the static web view. Creating
     * a new form before that would make it the static one, and it would be destroyed instead.
     */
    static void runPreloadWhenNoCardShown(Runnable preload) {
        cancelPreload();
        if (container != null && shownKit != null) {
            deferredPreload = preload;
        } else {
            preload.run();
        }
    }

    /** Shows {@code kit} in the platform view, now or as soon as the view exists. */
    static void show(TapCardKit kit) {
        shownKit = kit;
        attachShownKit();
    }

    /**
     * Creates a new card form. It becomes the SDK's static web view, so call this right before
     * starting the SDK on it.
     */
    static TapCardKit newKit(Context context) {
        return new TapCardKit(context);
    }

    /** Drops any previous preload and creates the form a new preload loads into. */
    static TapCardKit startPreload(Context context, Map<String, Object> args) {
        cancelPreload();
        preloadedArgs = args;
        preloadedKit = newKit(context);
        return preloadedKit;
    }

    /**
     * @return the preloaded form when it was loaded with the same arguments the widget starts
     * with, or null. A preload that does not match is dropped either way.
     */
    @Nullable
    static TapCardKit takePreload(Map<String, Object> args) {
        TapCardKit kit = preloadedKit;
        boolean matches = kit != null && preloadedArgs != null
                && Objects.equals(preloadedArgs.get("configuration"), args.get("configuration"))
                && Objects.equals(preloadedArgs.get("cardNumber"), args.get("cardNumber"))
                && Objects.equals(preloadedArgs.get("cardExpiry"), args.get("cardExpiry"));
        if (!matches) {
            cancelPreload();
            return null;
        }
        preloadedKit = null;
        preloadedArgs = null;
        return kit;
    }

    static boolean hasPreload() {
        return preloadedKit != null;
    }

    static void cancelPreload() {
        deferredPreload = null;
        TapCardKit kit = preloadedKit;
        preloadedKit = null;
        preloadedArgs = null;
        if (kit != null && kit.getParent() == null) {
            WebView webView = webViewOf(kit);
            if (webView != null) webView.destroy();
        }
    }

    private static void attachShownKit() {
        FrameLayout target = container;
        TapCardKit kit = shownKit;
        if (target == null || kit == null || kit.getParent() == target) return;
        ViewParent parent = kit.getParent();
        if (parent instanceof ViewGroup) ((ViewGroup) parent).removeView(kit);
        target.removeAllViews();
        target.addView(kit, new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT));
    }

    @Nullable
    private static WebView webViewOf(@Nullable TapCardKit kit) {
        return kit == null ? null : kit.findViewById(company.tap.tapcardformkit.R.id.webview);
    }
}
