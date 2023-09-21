import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tap_card_sdk_flutter/tap_card_sdk_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setupConfiguration();
    Future.delayed(const Duration(seconds: 2), () {
      getTapToken();
    });
  }

  setupConfiguration() {
    TapCardSdkFlutter.setupConfiguration(
      merchant: "",
      transactionAmount: "1",
      transactionCurrency: "SAR",
      phoneCountryCode: "+20",
      phoneNumber: "011",
      contactEmail: "test@gmail.com",
      nameFirst: "Muhammad",
      nameMiddle: "Azhar",
      nameLast: "Maqbool",
      nameLang: "en",
      customerNameOnCard: "test",
      customerEditable: "true",
      acceptanceSupportedBrands: [
        "MADA",
        "VISA2",
        "MASTERCARD",
        "AMEX",
      ],
      acceptanceSupportedCards: [
        "CREDIT",
        "DEBIT",
      ],
      fieldsCardHolder: "true",
      addonsLoader: true,
      addonsSaveCard: true,
      addonsDisplayPaymentBrands: true,
      addonsScanner: true,
      addonsNFC: true,
      referenceTransaction: "tck_LV02G1729746334Xj5469435",
      referenceOrder: "77302326303771481",
      authChannel: "PAYER_BROWSER",
      authPurpose: "PAYMENT_TRANSACTION",
      invoiceID: "",
      postID: "",
      authenticationDescription: "description",
      interfaceLocale: "en",
      interfaceTheme: "light",
      interfaceEdges: "curved",
      interfaceDirection: "ltr",
      publicKey: "pk_test_Vlk842B1EA7tDN5QbrfGjYzh",
      scope: "Authenticate",
    );
  }

  double height = 110;

  var mSDKResponse;

  Future<void> getTapToken() async {
    try {
      var tapGooglePaySDKResult = await TapCardSdkFlutter.callTest();

      setState(() {
        mSDKResponse = tapGooglePaySDKResult;
      });

      print("Tap Token Response >>>>>> $mSDKResponse");
    } catch (ex) {
      if (kDebugMode) {
        print("Exception >>>> ${ex.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: TapCardSdkFlutter.tapCardSDKView(
          height: height,
        ),
      ),
    );
  }
}
