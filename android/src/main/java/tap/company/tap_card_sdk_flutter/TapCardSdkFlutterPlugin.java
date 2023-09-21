package tap.company.tap_card_sdk_flutter;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;
import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
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
 * TapCardSdkFlutterPlugin
 */
public class TapCardSdkFlutterPlugin implements FlutterPlugin, ActivityAware {


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
            System.out.println("On Create >>>>>>>");
        }

        @Override
        public void onStart(@NonNull LifecycleOwner owner) {
            System.out.println("On Start >>>>>>>");

        }

        @Override
        public void onResume(@NonNull LifecycleOwner owner) {
            System.out.println("On Resume >>>>>>>");
        }

        @Override
        public void onPause(@NonNull LifecycleOwner owner) {
            System.out.println("On Pause >>>>>>>");
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
            System.out.println("On Activity Created >>>>>>>");
        }

        @Override
        public void onActivityStarted(Activity activity) {
            System.out.println("On Activity Started >>>>>>>");
        }

        @Override
        public void onActivityResumed(Activity activity) {
            System.out.println("On Activity Resumed >>>>>>>");
        }

        @Override
        public void onActivityPaused(Activity activity) {
            System.out.println("On Activity Paused >>>>>>>");
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

    private FlutterPluginBinding pluginBinding;
    private ActivityPluginBinding activityBinding;
    private Application application;
    private Activity activity;
    // This is null when not using v2 embedding;
    private Lifecycle lifecycle;
    private LifeCycleObserver observer;
    private static final String CHANNEL = "tap_card_sdk_flutter";
//    private static final String CHANNEL = "samples.flutter.dev/battery";


    /**
     * Register with
     *
     * @param registrar
     */


    /**
     * Default constructor for the plugin.
     *
     * <p>Use this constructor for production code.
     */
    public TapCardSdkFlutterPlugin() {
    }


    /**
     * @param binding
     */
    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        TapCardKitFactory tapCardKitFactory;
        tapCardKitFactory = new TapCardKitFactory(binding.getBinaryMessenger());
        pluginBinding = binding;

        System.out.println("View Type ID >>>>>>>");
        pluginBinding.getPlatformViewRegistry()
                .registerViewFactory("plugin/tap_card_sdk", tapCardKitFactory);


    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        pluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        activityBinding = binding;
    }

    @Override
    public void onDetachedFromActivity() {
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
            handler.post(
                    () -> methodResult.notImplemented());
        }
    }

//    @Override
//    public void onMethodCall(MethodCall call, MethodChannel.Result rawResult) {
//        HashMap<String, Object> args = call.arguments();
//        System.out.println("args : " + args);
//        System.out.println("onMethodCall..... started");
//        if (activity == null) {
//            rawResult.error("no_activity", "SDK plugin requires a foreground activity.", null);
//            return;
//        }
//
//        if (call.method.equals("terminate_session")) {
//            System.out.println("terminate session!");
//            //  delegate.terminateSDKSession();
//            return;
//        }
//        MethodChannel.Result result = new MethodResultWrapper(rawResult);
//       // result.success("Success");
//        delegate.start(activity, result, args);
//
//        // delegate.setupConfiguration();
//
//    }

//    private int getBatteryLevel() {
//        int batteryLevel = -1;
//        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
//            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
//            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
//        } else {
//            Intent intent = new ContextWrapper(activity).
//                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
//            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
//                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
//        }
//
//        return batteryLevel;
//    }
}


//package tap.company.tap_card_sdk_flutter;
//
//import androidx.annotation.NonNull;
//
//import io.flutter.embedding.engine.plugins.FlutterPlugin;
//import io.flutter.plugin.common.MethodCall;
//import io.flutter.plugin.common.MethodChannel;
//import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
//import io.flutter.plugin.common.MethodChannel.Result;
//
///** TapCardSdkFlutterPlugin */
//public class TapCardSdkFlutterPlugin implements FlutterPlugin, MethodCallHandler {
//  /// The MethodChannel that will the communication between Flutter and native Android
//  ///
//  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
//  /// when the Flutter Engine is detached from the Activity
//  private MethodChannel channel;
//
//  @Override
//  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
//    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "tap_card_sdk_flutter");
//    channel.setMethodCallHandler(this);
//  }
//
//  @Override
//  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
//    if (call.method.equals("getPlatformVersion")) {
//      result.success("Android " + android.os.Build.VERSION.RELEASE);
//    } else {
//      result.notImplemented();
//    }
//  }
//
//  @Override
//  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
//    channel.setMethodCallHandler(null);
//  }
//}
