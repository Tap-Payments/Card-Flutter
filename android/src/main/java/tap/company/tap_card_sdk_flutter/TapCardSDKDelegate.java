package tap.company.tap_card_sdk_flutter;

import android.app.Activity;
import android.content.Intent;
import android.os.Looper;
import android.os.Handler;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.logging.LogRecord;

import company.tap.tapcardformkit.open.DataConfiguration;
import company.tap.tapcardformkit.open.TapCardStatusDelegate;
import company.tap.tapcardformkit.open.web_wrapper.TapCardKit;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class TapCardSDKDelegate implements PluginRegistry.ActivityResultListener,
        PluginRegistry.RequestPermissionsResultListener, TapCardStatusDelegate {

    private Activity activity;
    private DataConfiguration dataConfiguration;
    private TapCardKit tapCardKit;
    public MethodChannel.Result pendingResult;
    private MethodCall methodCall;
    private MethodChannel channel;

    boolean onReadyCallbackTriggered = false;

    boolean onHeightChangeCallbackTriggered = false;

    private Handler handler = new Handler(Looper.getMainLooper());


    public TapCardSDKDelegate(Activity _activity) {
        this.activity = _activity;
        this.dataConfiguration = DataConfiguration.INSTANCE;
        this.tapCardKit = new TapCardKit(_activity.getApplicationContext());

    }


    public void start(Activity activity1, MethodChannel.Result callback, HashMap<String, Object> paramss) {
        this.pendingResult = callback;
        this.activity = activity1;
        try {


            HashMap<String, Object> configuration = (HashMap<String, Object>) paramss.get("configuration");

            System.out.println("Configuration Calls ");
            ///  channel = new MethodChannel(messenger, "tap_card_sdk_flutter");

            HashMap<String, Object> request = new HashMap<>();

            /**
             * merchant
             */
            Map<String, Object> merchant = new HashMap<>();
            merchant.put("id", configuration.get("id"));

            /**
             * transaction
             */
            Map<String, Object> transaction = new HashMap<>();

            transaction.put("amount", configuration.get("amount"));
            transaction.put("currency", configuration.get("currency"));

            /**
             * phone
             */
            Map<String, Object> phone = new HashMap<>();
            phone.put("countryCode", configuration.get("countryCode"));
            phone.put("number", configuration.get("number"));

            /**
             * contact
             */
            Map<String, Object> contact = new HashMap<>();

            contact.put("email", configuration.get("email"));
            contact.put("phone", configuration.get("phone"));

            /**
             * name
             */
            Map<String, Object> name = new HashMap<>();
            name.put("lang", configuration.get("lang"));
            name.put("first", configuration.get("first"));
            name.put("middle", configuration.get("middle"));
            name.put("last", configuration.get("last"));

            List<Map> listOfName = new ArrayList<>();
            listOfName.add(name);


            /**
             * customer
             */
            Map<String, Object> customer = new HashMap<>();


            customer.put("nameOnCard", configuration.get("nameOnCard"));
            customer.put("editable", configuration.get("editable"));
            customer.put("contact", contact);
            customer.put("name", listOfName);


            /**
             * acceptance
             */
            Map<String, Object> acceptance = new HashMap<>();

            List<String> supportedBrandList;
            supportedBrandList = (List<String>) configuration.get("supportedBrands");


            List<String> supportedCardsList = new ArrayList<>();
            supportedCardsList = (List<String>) configuration.get("supportedCards");

            acceptance.put("supportedBrands", supportedBrandList);
            acceptance.put("supportedCards", supportedCardsList);

            /**
             * fields
             */
            Map<String, Object> fields = new HashMap<>();
            fields.put("cardHolder", configuration.get("cardHolder"));

            /**
             * addons
             */
            Map<String, Object> addons = new HashMap<>();

            addons.put("loader", configuration.get("loader"));
            addons.put("saveCard", configuration.get("saveCard"));
            addons.put("displayPaymentBrands", configuration.get("displayPaymentBrands"));
            addons.put("scanner", configuration.get("scanner"));
            addons.put("nfc", configuration.get("nfc"));


            /**
             * reference
             */
            Map<String, Object> reference = new HashMap<>();
            reference.put("transaction", configuration.get("transaction"));
            reference.put("order", configuration.get("order"));

            /**
             * authchanel
             */
            Map<String, Object> auth = new HashMap<>();

            auth.put("channel", configuration.get("channel"));
            auth.put("purpose", configuration.get("purpose"));


            /**
             * invoice
             */
            Map<String, Object> invoice = new HashMap<>();
            invoice.put("id", configuration.get("invoiceId"));

            /**
             * post
             */
            Map<String, Object> post = new HashMap<>();
            post.put("id", configuration.get("postId"));

            /**
             * authentication
             */
            Map<String, Object> authentication = new HashMap<>();
            authentication.put("description", configuration.get("description"));
            authentication.put("reference", reference);
            authentication.put("invoice", invoice);
            authentication.put("authentication", auth);
            authentication.put("post", post);


            /**
             * interface
             */
            Map<String, Object> interfaces = new HashMap<>();

            interfaces.put("locale", configuration.get("locale"));
            interfaces.put("theme", configuration.get("theme"));
            interfaces.put("edges", configuration.get("edges"));
            interfaces.put("direction", configuration.get("direction"));


            request.put("acceptance", acceptance);
            request.put("publicKey", configuration.get("publicKey"));
            request.put("merchant", merchant);
            request.put("transaction", transaction);
            request.put("customer", customer);
            request.put("interface", interfaces);
            request.put("addons", addons);
            request.put("fields", fields);
            request.put("scope", configuration.get("scope"));
            request.put("authentication", authentication);

            System.out.println("Request :" + request);

            DataConfiguration.INSTANCE.initializeSDK(activity1, request, tapCardKit);
            DataConfiguration.INSTANCE.addTapCardStatusDelegate(this);
            DataConfiguration.INSTANCE.generateToken(tapCardKit);

        } catch (Exception e) {
//            pendingResult.error(String.valueOf(500), e.toString(), new Object());
//            pendingResult = null;
        }
    }

    public void generateTapToken(Activity activity1, MethodChannel.Result callback, HashMap<String, Object> paramss) {
        this.pendingResult = callback;
        this.activity = activity1;
        System.out.println("Coming here");
        DataConfiguration.INSTANCE.generateToken(tapCardKit);
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
                        pendingResult.success(resultData);
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
                        pendingResult.success(resultData);
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
                        pendingResult.success(resultData);
                    }
                });

    }

    @Override
    public void onHeightChange(@NonNull String s) {
//        if (!onHeightChangeCallbackTriggered) {
//            handler.post(
//                    new Runnable() {
//                        @Override
//                        public void run() {
//
//                            try {
//                                HashMap<String, Object> resultData = new HashMap<>();
//                                resultData.put("onHeightChange", s);
//                                pendingResult.success(resultData);
//
//                            } catch (Exception e) {
//
//                            }
//
//                        }
//                    });
//            onHeightChangeCallbackTriggered = true;
//        } else {
//            new java.util.Timer().schedule(
//                    new java.util.TimerTask() {
//                        @Override
//                        public void run() {
//                            onHeightChangeCallbackTriggered = false;
//                            // your code here
//                        }
//                    }, 500
//            );
//        }


    }


    @Override
    public void onReady() {


        if (!onReadyCallbackTriggered) {
            handler.post(
                    new Runnable() {
                        @Override
                        public void run() {

                            try {
                                HashMap<String, Object> resultData = new HashMap<>();
                                resultData.put("onReady", "On Ready Callback Is Executed");
                                pendingResult.success(resultData);

                            } catch (Exception e) {

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
                        pendingResult.success(resultData);
                    }
                });

    }

    @Override
    public void onValidInput(@NonNull String s) {

        handler.post(
                new Runnable() {
                    @Override
                    public void run() {
                        HashMap<String, Object> resultData = new HashMap<>();
                        resultData.put("onValidInput", s);
                        pendingResult.success(resultData);
                    }
                });

    }
}
