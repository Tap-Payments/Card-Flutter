package tap.company.card_flutter;

import android.app.Activity;
import android.content.Intent;
import android.os.Looper;
import android.os.Handler;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

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

    private Handler handler = new Handler(Looper.getMainLooper());

    /**
     * While a preloaded form is not shown yet, its events (onReady, onHeightChange, onError...)
     * are kept here and replayed once the widget starts listening.
     */
    private boolean bufferingEvents = false;
    private final List<HashMap<String, Object>> bufferedEvents = new ArrayList<>();


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
                TapCardKit preloadedKit = CardHost.takePreload(params);
                if (preloadedKit != null) {
                    // Loaded (or loading) already: show it and hand over what happened so far.
                    CardHost.show(preloadedKit);
                    flushBufferedEvents();
                } else {
                    bufferingEvents = false;
                    bufferedEvents.clear();
                    // Convert to a safer configuration format
                    HashMap<String, Object> safeConfiguration = createSafeConfiguration(tapCardConfigurations);
                    TapCardKit kit = CardHost.newKit(activity1);
                    CardHost.show(kit);
                    CardDataConfiguration.INSTANCE.initializeSDK(activity1, safeConfiguration, this, kit, cardNumber, cardExpiry);
                }
            }

        } catch (Exception e) {
//            pendingResult.error(String.valueOf(500), e.toString(), new Object());
//            pendingResult = null;
        }
    }

    /**
     * Starts loading the card form for {@code params} before the widget is shown. The widget
     * picks it up in {@link #start} when it starts with the same arguments.
     */
    public void preload(Activity activity1, MethodChannel.Result callback, HashMap<String, Object> params) {
        this.activity = activity1;
        try {
            initializeFirebase(activity1.getApplicationContext());
            HashMap<String, Object> tapCardConfigurations = (HashMap<String, Object>) params.get("configuration");
            if (tapCardConfigurations == null) {
                callback.error("invalid_arguments", "preload needs a configuration", null);
                return;
            }
            String cardNumber = (String) params.get("cardNumber");
            String cardExpiry = (String) params.get("cardExpiry");
            HashMap<String, Object> safeConfiguration = createSafeConfiguration(tapCardConfigurations);
            CardHost.runPreloadWhenNoCardShown(() -> {
                // Hold events until a widget shows this form; drop those of an earlier preload.
                bufferingEvents = true;
                bufferedEvents.clear();
                TapCardKit kit = CardHost.startPreload(activity1, params);
                CardDataConfiguration.INSTANCE.initializeSDK(activity1, safeConfiguration, this, kit, cardNumber, cardExpiry);
            });
            callback.success(null);
        } catch (Exception e) {
            CardHost.cancelPreload();
            bufferingEvents = false;
            bufferedEvents.clear();
            callback.error("preload_failed", e.toString(), null);
        }
    }

    public void cancelPreload() {
        CardHost.cancelPreload();
        bufferingEvents = false;
        bufferedEvents.clear();
    }

    /** Sends an event to the widget, or keeps it while a preloaded form is not shown yet. */
    private void sendEvent(String key, Object value) {
        handler.post(() -> {
            HashMap<String, Object> resultData = new HashMap<>();
            resultData.put(key, value);
            if (bufferingEvents) {
                bufferedEvents.add(resultData);
                return;
            }
            if (eventSink == null) return;
            try {
                eventSink.success(resultData);
            } catch (Throwable throwable) {
                System.out.println("Exception sending " + key + ": " + throwable);
            }
        });
    }

    /** Replays the events of the preloaded form, in order, then sends new ones directly. */
    private void flushBufferedEvents() {
        handler.post(() -> {
            bufferingEvents = false;
            List<HashMap<String, Object>> events = new ArrayList<>(bufferedEvents);
            bufferedEvents.clear();
            if (eventSink == null) return;
            for (HashMap<String, Object> resultData : events) {
                try {
                    eventSink.success(resultData);
                } catch (Throwable throwable) {
                    System.out.println("Exception replaying event: " + throwable);
                }
            }
        });
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
        sendEvent("onBinIdentification", s);
    }

    @Override
    public void onCardError(@NonNull String s) {
        sendEvent("onError", s);
    }

    @Override
    public void onCardFocus() {
        sendEvent("onFocus", "On Focus Callback Is Executed");
    }

    @Override
    public void onHeightChange(@NonNull String s) {
        sendEvent("onHeightChange", s);
    }

    @Override
    public void onCardReady() {
        sendEvent("onReady", "On Ready Callback Is Executed");
    }

    @Override
    public void onCardSuccess(@NonNull String s) {
        sendEvent("onSuccess", s);
    }

    @Override
    public void onChangeSaveCard(boolean b) {
        sendEvent("onChangeSaveCard", b);
    }

    @Override
    public void onValidInput(@NonNull String s) {
        // Not forwarded: onInValidInput reports the same state.
    }

    @Override
    public void onInValidInput(boolean b) {
        sendEvent("onValidInput", !b);
    }
}
