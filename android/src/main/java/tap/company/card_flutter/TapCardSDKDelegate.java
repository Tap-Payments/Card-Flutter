package tap.company.card_flutter;

import android.app.Activity;
import android.content.Intent;
import android.os.Looper;
import android.os.Handler;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Timer;
import java.util.logging.LogRecord;

import company.tap.tapcardformkit.open.CardDataConfiguration;
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
    private CardDataConfiguration dataConfiguration;
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
        this.dataConfiguration = CardDataConfiguration.INSTANCE;
        this.tapCardKit = new TapCardKit(_activity.getApplicationContext());

    }


    public void start(Activity activity1, MethodChannel.Result callback, HashMap<String, Object> params, boolean generateToken, EventChannel.EventSink event) {
        this.pendingResult = callback;
        this.eventSink = event;
        this.activity = activity1;
        try {

            initializeFirebase(activity1.getApplicationContext());
            HashMap<String, Object> tapCardConfigurations = (HashMap<String, Object>) params.get("configuration");
            String cardNumber = (String) params.get("cardNumber");
            String cardExpiry = (String) params.get("cardExpiry");

            // Log the configuration structure for debugging
            System.out.println("Tap Card Configurations " + tapCardConfigurations);
            if (tapCardConfigurations != null) {
                logConfigurationStructure(tapCardConfigurations, "");
            }

            if (generateToken) {
                System.out.println("Coming here for generate token");
                CardDataConfiguration.INSTANCE.generateToken(tapCardKit);
            } else {
                assert tapCardConfigurations != null;
                // Convert to a safer configuration format
                HashMap<String, Object> safeConfiguration = createSafeConfiguration(tapCardConfigurations);
                CardDataConfiguration.INSTANCE.initializeSDK(activity1, safeConfiguration, this, tapCardKit, cardNumber, cardExpiry);
                //  DataConfiguration.INSTANCE.addTapCardStatusDelegate(this);

            }

        } catch (Exception e) {
//            pendingResult.error(String.valueOf(500), e.toString(), new Object());
//            pendingResult = null;
        }
    }

    private void logConfigurationStructure(HashMap<String, Object> config, String prefix) {
        for (Map.Entry<String, Object> entry : config.entrySet()) {
            String key = entry.getKey();
            Object value = entry.getValue();
            String logPrefix = prefix + key;
            
            if (value == null) {
                System.out.println(logPrefix + ": null");
            } else {
                System.out.println(logPrefix + ": " + value.getClass().getSimpleName() + " = " + value);
                
                // If it's a nested HashMap, log its structure too
                if (value instanceof HashMap) {
                    logConfigurationStructure((HashMap<String, Object>) value, logPrefix + ".");
                } else if (value instanceof List) {
                    List<?> list = (List<?>) value;
                    System.out.println(logPrefix + " (List with " + list.size() + " items)");
                    for (int i = 0; i < list.size(); i++) {
                        Object item = list.get(i);
                        if (item != null) {
                            System.out.println(logPrefix + "[" + i + "]: " + item.getClass().getSimpleName() + " = " + item);
                            if (item instanceof HashMap) {
                                logConfigurationStructure((HashMap<String, Object>) item, logPrefix + "[" + i + "].");
                            }
                        }
                    }
                }
            }
        }
    }

    private HashMap<String, Object> createSafeConfiguration(HashMap<String, Object> originalConfig) {
        HashMap<String, Object> safeConfig = new HashMap<>();
        
        for (Map.Entry<String, Object> entry : originalConfig.entrySet()) {
            String key = entry.getKey();
            Object value = entry.getValue();
            
            // Recursively convert nested structures
            Object safeValue = convertToSafeType(value);
            safeConfig.put(key, safeValue);
        }
        
        return safeConfig;
    }
    
    @SuppressWarnings("unchecked")
    private Object convertToSafeType(Object value) {
        if (value == null) {
            return null;
        }
        
        // Handle different data types
        if (value instanceof String || value instanceof Number || value instanceof Boolean) {
            return value;
        } else if (value instanceof Map) {
            // Convert Map to HashMap<String, Object>
            Map<?, ?> mapValue = (Map<?, ?>) value;
            HashMap<String, Object> safeMap = new HashMap<>();
            for (Map.Entry<?, ?> mapEntry : mapValue.entrySet()) {
                if (mapEntry.getKey() instanceof String) {
                    safeMap.put((String) mapEntry.getKey(), convertToSafeType(mapEntry.getValue()));
                }
            }
            return safeMap;
        } else if (value instanceof List) {
            // Convert List to ArrayList
            List<?> listValue = (List<?>) value;
            ArrayList<Object> safeList = new ArrayList<>();
            for (Object item : listValue) {
                safeList.add(convertToSafeType(item));
            }
            return safeList;
        } else {
            // For unknown types, convert to string as fallback
            System.out.println("Unknown type encountered: " + value.getClass().getName() + ", converting to string: " + value.toString());
            return value.toString();
        }
    }

    private void initializeFirebase(android.content.Context context) {
    try {
            if (FirebaseApp.getApps(context).isEmpty()) {
                FirebaseOptions options = new FirebaseOptions.Builder()
                    .setApiKey("AIzaSyDHnW6NQ3bifZsmzGdyVLd2t6f8U1lSqlE")
                    .setApplicationId("com.example.tapcardwebsdk")
                    .setProjectId("your-project-id")
                    .build();
                FirebaseApp.initializeApp(context, options);
                System.out.println("Firebase initialized manually");
            }
        } catch (Exception e) {
            System.err.println("Error initializing Firebase: " + e.getMessage());
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
                        resultData.put("onBinIdentification", s);
                        eventSink.success(resultData);
                    }
                });
    }

    @Override
    public void onCardError(@NonNull String s) {

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
    public void onCardFocus() {
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
                        try {
                            HashMap<String, Object> resultData = new HashMap<>();
                            resultData.put("onHeightChange", s);
                            System.out.println("On Height " + new Timestamp(System.currentTimeMillis()));
                            eventSink.success(resultData);

                        } catch (IllegalStateException exception) {
                            // Output expected IllegalStateException.
                            System.out.println("Exception " + exception);
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
    public void onCardReady() {

        System.out.println("ON READY CALLED  " + onReadyCallbackTriggered);
        onReadyCallbackTriggered = false;
        if (!onReadyCallbackTriggered) {
            handler.post(
                    new Runnable() {
                        @Override
                        public void run() {

                            try {
                                HashMap<String, Object> resultData = new HashMap<>();
                                resultData.put("onReady", "On Ready Callback Is Executed");
                                eventSink.success(resultData);

                            } catch (IllegalStateException exception) {
                                // Output expected IllegalStateException.
                                System.out.println("Exception " + exception);
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
            System.out.println("ON READY NEVER FIRED ");
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
    public void onCardSuccess(@NonNull String s) {

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
    public void onChangeSaveCard(boolean b) {
        handler.post(
                new Runnable() {
                    @Override
                    public void run() {

                        try {
                            HashMap<String, Object> resultData = new HashMap<>();
                            resultData.put("onChangeSaveCard", b);
                            eventSink.success(resultData);

                        } catch (IllegalStateException exception) {
                            // Output expected IllegalStateException.
                            System.out.println("Exception " + exception);
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
    public void onValidInput(@NonNull String s) {

        handler.post(
                new Runnable() {
                    @Override
                    public void run() {

                        try {
                            HashMap<String, Object> resultData = new HashMap<>();
                            resultData.put("onValidInput", s);
                            eventSink.success(resultData);

                        } catch (IllegalStateException exception) {
                            // Output expected IllegalStateException.
                            System.out.println("Exception " + exception);
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
