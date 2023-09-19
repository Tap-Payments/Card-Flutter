package tap.company.tap_card_sdk_flutter;

import android.app.Activity;
import android.content.ContextWrapper;
import android.content.MutableContextWrapper;
import android.graphics.Color;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import company.tap.tapcardformkit.open.TapCardStatusDelegate;
import company.tap.tapcardformkit.open.web_wrapper.TapCardConfiguration;
import company.tap.tapcardformkit.open.web_wrapper.TapCardKit;
import io.flutter.plugin.platform.PlatformView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


class TapCardKitViewManager implements PlatformView {


    private TapCardKit tapCardKit;
    private View view;


    TapCardKitViewManager(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        view = LayoutInflater.from(context).inflate(R.layout.tap_card_kit_layout, null);
        tapCardKit = view.findViewById(R.id.tapCardForm);
        setupConfiguration(tapCardKit);
    }


    public void setupConfiguration(TapCardKit tapKit) {
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

        List<Map> listOfName = new ArrayList<>();
        listOfName.add(name);




        /**
         * customer
         */
        Map<String, Object> customer = new HashMap<>();


        customer.put("nameOnCard", "test");
        customer.put("editable", "true");
        customer.put("contact", contact);
        customer.put("name", listOfName);


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
         * invoice
         */
        Map<String, Object> invoice = new HashMap<>();
        invoice.put("id", "");

        /**
         * post
         */
        Map<String, Object> post = new HashMap<>();
        post.put("id", "");

        /**
         * authentication
         */
        Map<String, Object> authentication = new HashMap<>();
        authentication.put("description", "description");
        authentication.put("reference", reference);
        authentication.put("invoice", invoice);
        authentication.put("authentication", auth);
        authentication.put("post", post);


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
        request.put("scope", "Authenticate");
        request.put("authentication", authentication);

        System.out.println("Request :" + request);

        TapCardConfiguration.Companion.configureWithTapCardDictionaryConfiguration(tapKit.getContext(), tapKit, (HashMap<String, Object>) request, new TapCardStatusDelegate() {
            @Override
            public void onSuccess(@NonNull String s) {
                System.out.println("OnSuccess :" + s);
            }

            @Override
            public void onReady() {
                System.out.println("OnReady :");
            }

            @Override
            public void onFocus() {
                System.out.println("OnFocus :");
            }

            @Override
            public void onBindIdentification(@NonNull String s) {
                System.out.println("OnBindIdentification :" + s);
            }

            @Override
            public void onValidInput(@NonNull String s) {
                tapKit.generateTapToken();
                System.out.println("OnValidInput :" + s);
            }

            @Override
            public void onError(@NonNull String s) {
                System.out.println("OnError :" + s);
            }
        });
    }


    @NonNull
    @Override
    public View getView() {
        return view;
    }

    @Override
    public void dispose() {
    }

    public TapCardKit getTapCardKit() {
        return tapCardKit;
    }

}
