package tap.company.card_flutter;

import android.app.Activity;
import android.content.Intent;
import android.os.Looper;
import android.os.Handler;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Timer;
import java.util.logging.LogRecord;

import company.tap.tapcardformkit.open.DataConfiguration;
import company.tap.tapcardformkit.open.TapCardStatusDelegate;
import company.tap.tapcardformkit.open.web_wrapper.TapCardConfiguration;
import company.tap.tapcardformkit.open.web_wrapper.TapCardKit;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class TapCardSDKDelegate implements PluginRegistry.ActivityResultListener,
        PluginRegistry.RequestPermissionsResultListener, TapCardStatusDelegate {

    private Activity activity;
    private DataConfiguration dataConfiguration;
    private TapCardKit tapCardKit;
    public MethodChannel.Result pendingResult;

    public EventChannel.EventSink eventSink;

    private MethodCall methodCall;
    private MethodChannel channel;

    boolean onReadyCallbackTriggered = false;

    boolean onHeightChangeCallbackTriggered = true;

    private Handler handler = new Handler(Looper.getMainLooper());


    public TapCardSDKDelegate(Activity _activity) {
        this.activity = _activity;
        this.dataConfiguration = DataConfiguration.INSTANCE;
        this.tapCardKit = new TapCardKit(_activity.getApplicationContext());

    }


    public void start(Activity activity1, MethodChannel.Result callback, HashMap<String, Object> params, boolean generateToken,EventChannel.EventSink event ) {
        this.pendingResult = callback;
        this.eventSink = event;
        this.activity = activity1;
        try {


            HashMap<String, Object> tapCardConfigurations = (HashMap<String, Object>) params.get("configuration");
            String cardNumber = (String) params.get("cardNumber");
            String cardExpiry = (String) params.get("cardExpiry");

            System.out.println("Tap Card Configurations " + tapCardConfigurations);

            if (generateToken) {
                System.out.println("Coming here for generate token");
                DataConfiguration.INSTANCE.generateToken(tapCardKit);
            } else {
                assert tapCardConfigurations != null;
                DataConfiguration.INSTANCE.initializeSDK(activity1, tapCardConfigurations, tapCardKit, cardNumber,cardExpiry);
                DataConfiguration.INSTANCE.addTapCardStatusDelegate(this);
            }

        } catch (Exception e) {
//            pendingResult.error(String.valueOf(500), e.toString(), new Object());
//            pendingResult = null;
        }
    }


    @Override
    public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        return false;
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        return false;
    }

    @Override
    public void onBindIdentification(@NonNull String s) {


        handler.post(
                new Runnable() {
                    @Override
                    public void run() {
                        HashMap<String, Object> resultData = new HashMap<>();
                        resultData.put("onBindIdentification", s);
                        eventSink.success(resultData);
                    }
                });
    }

    @Override
    public void onError(@NonNull String s) {

        handler.post(
                new Runnable() {
                    @Override
                    public void run() {
                        HashMap<String, Object> resultData = new HashMap<>();
                        resultData.put("onError", s);
                        eventSink.success(resultData);
                    }
                });
    }

    @Override
    public void onFocus() {
        handler.post(
                new Runnable() {
                    @Override
                    public void run() {
                        HashMap<String, Object> resultData = new HashMap<>();
                        resultData.put("onFocus", "On Focus Callback Is Executed");
                        eventSink.success(resultData);
                    }
                });

    }

    @Override
    public void onHeightChange(@NonNull String s) {
        handler.post(
                new Runnable() {
                    @Override
                    public void run() {
                        try{
                            HashMap<String, Object> resultData = new HashMap<>();
                            resultData.put("onHeightChange", s);
                            System.out.println("On Height " + new Timestamp(System.currentTimeMillis()));
                            eventSink.success(resultData);

                        }catch (IllegalStateException exception) {
                            // Output expected IllegalStateException.
                            System.out.println("Exception " +exception);
                            // Logging.log(exception);
                        } catch (Throwable throwable) {
                            // Output unexpected Throwables.
                            System.out.println("Exception throwable");
                            // Logging.log(throwable, false);
                        }

                    }
                });



    }


    @Override
    public void onReady() {


        if (!onReadyCallbackTriggered) {
            handler.post(
                    new Runnable() {
                        @Override
                        public void run() {

                            try{
                                HashMap<String, Object> resultData = new HashMap<>();
                                resultData.put("onReady", "On Ready Callback Is Executed");
                                eventSink.success(resultData);

                            }catch (IllegalStateException exception) {
                                // Output expected IllegalStateException.
                                System.out.println("Exception " +exception);
                                // Logging.log(exception);
                            } catch (Throwable throwable) {
                                // Output unexpected Throwables.
                                System.out.println("Exception throwable");
                                // Logging.log(throwable, false);
                            }

                        }
                    });
            onReadyCallbackTriggered = true;
        } else {
            new java.util.Timer().schedule(
                    new java.util.TimerTask() {
                        @Override
                        public void run() {
                            onReadyCallbackTriggered = false;
                        }
                    }, 1000
            );
        }


    }

    @Override
    public void onSuccess(@NonNull String s) {

        handler.post(
                new Runnable() {
                    @Override
                    public void run() {
                        HashMap<String, Object> resultData = new HashMap<>();
                        resultData.put("onSuccess", s);
                        eventSink.success(resultData);
                    }
                });

    }


    @Override
    public void onValidInput(@NonNull String s) {

        handler.post(
                new Runnable() {
                    @Override
                    public void run() {

                        try{
                            HashMap<String, Object> resultData = new HashMap<>();
                            resultData.put("onValidInput", s);
                            eventSink.success(resultData);

                        }catch (IllegalStateException exception) {
                            // Output expected IllegalStateException.
                            System.out.println("Exception " +exception);
                            // Logging.log(exception);
                        } catch (Throwable throwable) {
                            // Output unexpected Throwables.
                            System.out.println("Exception throwable");
                            // Logging.log(throwable, false);
                        }


                    }
                });

    }


}
