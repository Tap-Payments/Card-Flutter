package tap.company.tap_card_sdk_flutter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.List;


import company.tap.tapcardformkit.open.TapCardStatusDelegate;
import company.tap.tapcardformkit.open.web_wrapper.TapCardConfiguration;
import company.tap.tapcardformkit.open.web_wrapper.TapCardKit;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class TapCardSDKDelegate implements PluginRegistry.ActivityResultListener,
        PluginRegistry.RequestPermissionsResultListener, TapCardStatusDelegate {

    private Activity activity;
    private TapCardConfiguration dataConfiguration;
    private MethodChannel.Result pendingResult;
    private MethodCall methodCall;



    public void setupConfiguration(TapCardKit tapCardKit) {
        Map<String, Object> request = new HashMap<>();

        /**
         * merchant
         */
        Map<String, Object> merchant = new HashMap<>();
        merchant.put("id", "");
        /**
         * transaction
         */
        Map<String, Object> transaction = new HashMap<>();

        transaction.put("amount", "1");
        transaction.put("currency", "SAR");
        /**
         * phone
         */
        Map<String, Object> phone = new HashMap<>();
        phone.put("countryCode", "+20");
        phone.put("number", "011");

        /**
         * contact
         */
        Map<String, Object> contact = new HashMap<>();

        contact.put("email", "test@gmail.com");
        contact.put("phone", phone);
        /**
         * name
         */
        Map<String, Object> name = new HashMap<>();

        name.put("lang", "en");
        name.put("first", "Ahmed");
        name.put("middle", "test");
        name.put("last", "test");

        /**
         * customer
         */
        Map<String, Object> customer = new HashMap<>();


        customer.put("nameOnCard", "test");
        customer.put("editable", "true");
        customer.put("contact", contact);
        customer.put("name", name);


        /**
         * acceptance
         */
        Map<String, Object> acceptance = new HashMap<>();

        List<String> myList = new ArrayList<>();
        myList.add("MADA");
        myList.add("VISA2");
        myList.add("MASTERCARD");
        myList.add("AMEX");

        List<String> myList2 = new ArrayList<>();
        myList2.add("CREDIT");
        myList2.add("DEBIT");

        acceptance.put("supportedBrands", myList);
        acceptance.put("supportedCards", myList2);

        /**
         * fields
         */
        Map<String, Object> fields = new HashMap<>();
        fields.put("cardHolder", "true");

        /**
         * addons
         */
        Map<String, Object> addons = new HashMap<>();

        addons.put("loader", true);
        addons.put("saveCard", true);
        addons.put("displayPaymentBrands", true);
        addons.put("scanner", true);
        addons.put("nfc", true);


        /**
         * reference
         */
        Map<String, Object> reference = new HashMap<>();
        reference.put("transaction", "tck_LV02G1729746334Xj54695435");
        reference.put("order", "77302326303711438");

        /**
         * authchanel
         */
        Map<String, Object> auth = new HashMap<>();

        auth.put("channel", "PAYER_BROWSER");
        auth.put("purpose", "PAYMENT_TRANSACTION");


        /**
         * authentication
         */
        Map<String, Object> authentication = new HashMap<>();
        authentication.put("refrence", reference);
        authentication.put("authentication", auth);


        /**
         * interface
         */
        Map<String, Object> interf = new HashMap<>();

        interf.put("locale", "en");
        interf.put("theme", "light");
        interf.put("edges", "curved");
        interf.put("direction", "ltr");


        request.put("acceptance", acceptance);
        request.put("publicKey", "pk_test_Vlk842B1EA7tDN5QbrfGjYzh");
        request.put("merchant", merchant);
        request.put("transaction", transaction);
        request.put("customer", customer);
        request.put("interface", interf);
        request.put("addons", addons);
        request.put("fields", fields);

        System.out.println("Request :" + request);

//        TapCardKit tapCardKit;
//        View view;
//        view = LayoutInflater.from(this.activity).inflate(R.layout.tap_card_kit_layout, null);
//        tapCardKit = view.findViewById(R.id.tapCardForm);
        // new TapCardKitFactory().getView()

        TapCardConfiguration.Companion.configureWithTapCardDictionaryConfiguration(this.activity, tapCardKit, (HashMap<String, Object>) request, this);
    }


    public TapCardSDKDelegate(Activity _activity) {
        this.activity = _activity;
        // this.dataConfiguration = TapCardConfiguration.INSTANCE;
        //        this.googlePayButton = new GooglePayButton(_activity.getApplicationContext());
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

    }

    @Override
    public void onError(@NonNull String s) {
        System.out.println("Error : " + s);
    }

    @Override
    public void onFocus() {

    }

    @Override
    public void onReady() {

    }

    @Override
    public void onSuccess(@NonNull String s) {
        System.out.println("Success : " + s);
    }

    @Override
    public void onValidInput(@NonNull String s) {

    }
}
