package tap.company.tap_card_sdk_flutter;

import android.app.Activity;
import android.content.Intent;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import company.tap.tapcardformkit.open.TapCardStatusDelegate;
import company.tap.tapcardformkit.open.web_wrapper.TapCardConfiguration;
import company.tap.tapcardformkit.open.web_wrapper.TapCardKit;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


class TapCardKitViewManager implements PlatformView, MethodChannel.MethodCallHandler {


    private TapCardKit tapCardKit;
    private View view;

    private MethodChannel channel;

    private MethodChannel.Result pendingResult;
    Map<String, Object> params;

    TapCardKitViewManager(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams, @Nullable BinaryMessenger binaryMessenger) {
        System.out.println("Params from factory class >>>>>> " + creationParams.get("amount"));
        params = creationParams;
        view = LayoutInflater.from(context).inflate(R.layout.tap_card_kit_layout, null);
        tapCardKit = view.findViewById(R.id.tapCardForm);
        channel = new MethodChannel(binaryMessenger, "tap_card_sdk_flutter");
        channel.setMethodCallHandler(this);
        //  setupConfiguration(tapCardKit, creationParams);
        //channel.setMethodCallHandler(this);
    }

    public void sendBackResult(MethodChannel.Result result) {
        this.pendingResult = result;
        tapCardKit.generateTapToken();
        pendingResult.success("Tap Token is generated");
    }

    @NonNull
    @Override
    public View getView() {
        return view;
    }

    @Override
    public void dispose() {
    }


    public void setupConfiguration(TapCardKit tapKit, Map<String, Object> paramss, @NonNull MethodChannel.Result result) {
        this.pendingResult = result;
        System.out.println("Configuration Calls ");
        Map<String, Object> request = new HashMap<>();

        /**
         * merchant
         */
        Map<String, Object> merchant = new HashMap<>();
        merchant.put("id", paramss.get("id"));

        /**
         * transaction
         */
        Map<String, Object> transaction = new HashMap<>();

        transaction.put("amount", paramss.get("amount"));
        transaction.put("currency", paramss.get("currency"));

        /**
         * phone
         */
        Map<String, Object> phone = new HashMap<>();
        phone.put("countryCode", paramss.get("countryCode"));
        phone.put("number", paramss.get("number"));

        /**
         * contact
         */
        Map<String, Object> contact = new HashMap<>();

        contact.put("email", paramss.get("email"));
        contact.put("phone", paramss.get("phone"));

        /**
         * name
         */
        Map<String, Object> name = new HashMap<>();
        name.put("lang", paramss.get("lang"));
        name.put("first", paramss.get("first"));
        name.put("middle", paramss.get("middle"));
        name.put("last", paramss.get("last"));

        List<Map> listOfName = new ArrayList<>();
        listOfName.add(name);


        /**
         * customer
         */
        Map<String, Object> customer = new HashMap<>();


        customer.put("nameOnCard", paramss.get("nameOnCard"));
        customer.put("editable", paramss.get("editable"));
        customer.put("contact", contact);
        customer.put("name", listOfName);


        /**
         * acceptance
         */
        Map<String, Object> acceptance = new HashMap<>();

        List<String> myList;
        myList = (List<String>) paramss.get("supportedBrands");


        List<String> myList2 = new ArrayList<>();
        myList2 = (List<String>) paramss.get("supportedCards");

        acceptance.put("supportedBrands", myList);
        acceptance.put("supportedCards", myList2);

        /**
         * fields
         */
        Map<String, Object> fields = new HashMap<>();
        fields.put("cardHolder", paramss.get("cardHolder"));

        /**
         * addons
         */
        Map<String, Object> addons = new HashMap<>();

        addons.put("loader", paramss.get("loader"));
        addons.put("saveCard", paramss.get("saveCard"));
        addons.put("displayPaymentBrands", paramss.get("displayPaymentBrands"));
        addons.put("scanner", paramss.get("scanner"));
        addons.put("nfc", paramss.get("nfc"));


        /**
         * reference
         */
        Map<String, Object> reference = new HashMap<>();
        reference.put("transaction", paramss.get("transaction"));
        reference.put("order", paramss.get("order"));

        /**
         * authchanel
         */
        Map<String, Object> auth = new HashMap<>();

        auth.put("channel", paramss.get("channel"));
        auth.put("purpose", paramss.get("purpose"));


        /**
         * invoice
         */
        Map<String, Object> invoice = new HashMap<>();
        invoice.put("id", paramss.get("invoiceId"));

        /**
         * post
         */
        Map<String, Object> post = new HashMap<>();
        post.put("id", paramss.get("postId"));

        /**
         * authentication
         */
        Map<String, Object> authentication = new HashMap<>();
        authentication.put("description", paramss.get("description"));
        authentication.put("reference", reference);
        authentication.put("invoice", invoice);
        authentication.put("authentication", auth);
        authentication.put("post", post);


        /**
         * interface
         */
        Map<String, Object> interf = new HashMap<>();

        interf.put("locale", paramss.get("locale"));
        interf.put("theme", paramss.get("theme"));
        interf.put("edges", paramss.get("edges"));
        interf.put("direction", paramss.get("direction"));


        request.put("acceptance", acceptance);
        request.put("publicKey", paramss.get("publicKey"));
        request.put("merchant", merchant);
        request.put("transaction", transaction);
        request.put("customer", customer);
        request.put("interface", interf);
        request.put("addons", addons);
        request.put("fields", fields);
        request.put("scope", paramss.get("scope"));
        request.put("authentication", authentication);

        System.out.println("Request :" + request);

        TapCardConfiguration.Companion.configureWithTapCardDictionaryConfiguration(tapKit.getContext(), tapKit, (HashMap<String, Object>) request, new TapCardStatusDelegate() {
            @Override
            public void onHeightChange(@NonNull String s) {
                System.out.println("OnHeightChange Callback :" + s);

            }

            @Override
            public void onSuccess(@NonNull String s) {
                System.out.println("OnSuccess Callback :" + s);
                pendingResult.success("On Success Calls :" +s);

            }

            @Override
            public void onReady() {
                System.out.println("OnReady Callback in view manager :");
                // pendingResult.success("On Ready callbacks calls");
            }

            @Override
            public void onFocus() {
                System.out.println("OnFocus Callback :");
            }

            @Override
            public void onBindIdentification(@NonNull String s) {
                System.out.println("OnBindIdentification Callback :" + s);
                pendingResult.success("On Bind Identification Calls :" +s);

            }

            @Override
            public void onValidInput(@NonNull String s) {
                System.out.println("OnValidInput Callback :" + s);
                pendingResult.success("Valid Input Calls :" +s);


            }

            @Override
            public void onError(@NonNull String s) {
                System.out.println("OnError Callback :" + s);
                pendingResult.success("On Error Calls :" +s);

            }
        });

    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        System.out.println("Method Channel Calls ");
        HashMap<String, Object> args = call.arguments();
        System.out.println("args : " + args);
        System.out.println("onMethodCall..... started");
        // sendBackResult(result);
        //sendBackResult(result);
        setupConfiguration(tapCardKit, params, result);
        // pendingResult.success("Hey there I am Azhar");
    }
}
