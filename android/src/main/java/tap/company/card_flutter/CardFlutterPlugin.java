package tap.company.card_flutter;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;
import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import company.tap.tapcardformkit.open.web_wrapper.TapCardConfiguration;
import company.tap.tapcardformkit.open.web_wrapper.TapCardKit;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;

/**
 * CardFlutterPlugin
 */
public class CardFlutterPlugin implements MethodChannel.MethodCallHandler, FlutterPlugin, ActivityAware, EventChannel.StreamHandler {

    private EventChannel.EventSink eventSink;

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        this.eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        this.eventSink = null;
    }

    /**
     * LifeCycleObserver
     */
    private class LifeCycleObserver
            implements Application.ActivityLifecycleCallbacks, DefaultLifecycleObserver {
        private final Activity thisActivity;

        LifeCycleObserver(Activity activity) {
            this.thisActivity = activity;
        }

        @Override
        public void onCreate(@NonNull LifecycleOwner owner) {
        }

        @Override
        public void onStart(@NonNull LifecycleOwner owner) {
        }

        @Override
        public void onResume(@NonNull LifecycleOwner owner) {
        }

        @Override
        public void onPause(@NonNull LifecycleOwner owner) {
        }

        @Override
        public void onStop(@NonNull LifecycleOwner owner) {
            onActivityStopped(thisActivity);
        }

        @Override
        public void onDestroy(@NonNull LifecycleOwner owner) {
            onActivityDestroyed(thisActivity);
        }

        @Override
        public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
        }

        @Override
        public void onActivityStarted(Activity activity) {
        }

        @Override
        public void onActivityResumed(Activity activity) {
        }

        @Override
        public void onActivityPaused(Activity activity) {
        }

        @Override
        public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
        }

        @Override
        public void onActivityDestroyed(Activity activity) {
            if (thisActivity == activity && activity.getApplicationContext() != null) {
                ((Application) activity.getApplicationContext())
                        .unregisterActivityLifecycleCallbacks(
                                this); // Use getApplicationContext() to avoid casting failures
            }
        }

        @Override
        public void onActivityStopped(Activity activity) {
            if (thisActivity == activity) {
//                delegate.saveStateBeforeResult();
            }
        }
    }

    /**
     * class properties
     */
    private MethodChannel channel;

    private EventChannel eventChannel;
    private TapCardSDKDelegate delegate;
    private FlutterPluginBinding pluginBinding;
    private ActivityPluginBinding activityBinding;
    private Application application;
    private Activity activity;
    // This is null when not using v2 embedding;
    private Lifecycle lifecycle;
    private LifeCycleObserver observer;
    // private static final String CHANNEL = "card_flutter";

    /**
     * Register with
     *
     * @param registrar
     */

    public static void registerWith(PluginRegistry.Registrar registrar) {
        if (registrar.activity() == null) {
            // If a background flutter view tries to register the plugin, there will be no activity from the registrar,
            // we stop the registering process immediately because the SDK requires an activity.
            return;
        }
        Activity activity = registrar.activity();
        Application application = null;
        if (registrar.context() != null) {
            application = (Application) (registrar.context().getApplicationContext());
        }
        CardFlutterPlugin plugin = new CardFlutterPlugin();
        plugin.setup(registrar.messenger(), application, activity, registrar, null);
    }


    /**
     * Default constructor for the plugin.
     *
     * <p>Use this constructor for production code.
     */
    public CardFlutterPlugin() {
    }


    /**
     * @param binding
     */
    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        pluginBinding = binding;
        System.out.println("View Type ID >>>>>>>");
        pluginBinding.getPlatformViewRegistry()
                .registerViewFactory("plugin/tap_card_sdk", new TapCardKitFactory());
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        pluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        activityBinding = binding;
        setup(
                pluginBinding.getBinaryMessenger(),
                (Application) pluginBinding.getApplicationContext(),
                activityBinding.getActivity(),
                null,
                activityBinding);
    }

    @Override
    public void onDetachedFromActivity() {
        tearDown();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }


    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    /**
     * setup
     */

    private void setup(
            final BinaryMessenger messenger,
            final Application application,
            final Activity activity,
            final PluginRegistry.Registrar registrar,
            final ActivityPluginBinding activityBinding) {
        this.activity = activity;
        this.application = application;
        this.delegate = constructDelegate(activity);
        channel = new MethodChannel(messenger, "card_flutter");
        channel.setMethodCallHandler(this);
        eventChannel = new EventChannel(messenger, "card_flutter_event");
        eventChannel.setStreamHandler(this);

        observer = new LifeCycleObserver(activity);
        if (registrar != null) {
            // V1 embedding setup for activity listeners.
            application.registerActivityLifecycleCallbacks(observer);
            registrar.addActivityResultListener(delegate);
            registrar.addRequestPermissionsResultListener(delegate);
        } else {
            // V2 embedding setup for activity listeners.
            activityBinding.addActivityResultListener(delegate);
            activityBinding.addRequestPermissionsResultListener(delegate);
//            lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(activityBinding);
//            lifecycle.addObserver(observer);
        }
    }


    /**
     * tearDown()
     */
    private void tearDown() {
        activityBinding.removeActivityResultListener(delegate);
        activityBinding.removeRequestPermissionsResultListener(delegate);
        activityBinding = null;
        if (lifecycle != null)
            lifecycle.removeObserver(observer);
        lifecycle = null;
        delegate = null;
        channel.setMethodCallHandler(null);
        channel = null;
        application.unregisterActivityLifecycleCallbacks(observer);
        application = null;
    }


    /**
     * construct delegate
     */

    private TapCardSDKDelegate constructDelegate(final Activity setupActivity) {
        return new TapCardSDKDelegate(setupActivity);
    }

    /**
     * MethodChannel.Result wrapper that responds on the platform thread.
     */

    private static class MethodResultWrapper implements MethodChannel.Result {
        private MethodChannel.Result methodResult;
        private Handler handler;



        MethodResultWrapper(MethodChannel.Result result) {
            methodResult = result;

            handler = new Handler(Looper.getMainLooper());
        }

        @Override
        public void success(final Object result) {

            System.out.println("success coming from delegate : " + result);

            handler.post(
                    new Runnable() {
                        @Override
                        public void run() {
                            methodResult.success(result);
//                            methodResult.success(result);
                        }
                    });
        }

        @Override
        public void error(
                final String errorCode, final String errorMessage, final Object errorDetails) {
            System.out.println("error encountered................." + errorCode);

            handler.post(
                    () -> methodResult.error(errorCode, errorMessage, errorDetails));
        }

        @Override
        public void notImplemented() {
            System.out.println("Not implemented.................");
            handler.post(
                    () -> methodResult.notImplemented());
        }
    }

    MethodChannel.Result result;



    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result rawResult) {
        HashMap<String, Object> args = call.arguments();

        System.out.println("args : " + args);
        System.out.println("onMethodCall..... started >>>>>>> " + call.method);
        if (activity == null) {
            rawResult.error("no_activity", "SDK plugin requires a foreground activity.", null);
            return;
        }
        if (call.method.equals("terminate_session")) {
            System.out.println("terminate session!");
            //  delegate.terminateSDKSession();
            return;
        }

        result = new MethodResultWrapper(rawResult);
        boolean generateToken = false;
        if (call.method.equals("generateToken")) {
            generateToken = true;
            delegate.start(activity, result, args, generateToken, eventSink);
            //  delegate.generateTapToken(activity, result, args);
        }

        if (call.method.equals("start")) {
            delegate.start(activity, result, args, generateToken, eventSink);

        } else {
            delegate.pendingResult = result;
            delegate.eventSink = eventSink;

        }


    }

}