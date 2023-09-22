import 'dart:convert';

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
      startTapCardSDK();
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
      addonsSaveCard: false,
      addonsDisplayPaymentBrands: true,
      addonsScanner: true,
      addonsNFC: true,
      referenceTransaction: "tck_LV02G1722741334Xj5418431",
      referenceOrder: "77300324303271889",
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

  double height = 120;

  Map<dynamic, dynamic>? mCardSDKResponse;

  Future<void> startTapCardSDK() async {
    try {
      var tapGooglePaySDKResult = await TapCardSdkFlutter.startTapCardSDK;

      handleCallbacks(tapGooglePaySDKResult);

      debugPrint("Tap Token2 Response >>>>>> $mCardSDKResponse");

      startTapCardSDK2();
    } catch (ex) {
      if (kDebugMode) {
        print("Exception >>>> ${ex.toString()}");
      }
    }
  }

  Future<void> startTapCardSDK2() async {
    try {
      var tapGooglePaySDKResult2 = await TapCardSdkFlutter.startTapCardSDK2;

      handleCallbacks(tapGooglePaySDKResult2!);
      debugPrint("Tap Token2 Response >>>>>> $mCardSDKResponse");
      startTapCardSDK2();
    } catch (ex) {
      if (kDebugMode) {
        print("Exception >>>> ${ex.toString()}");
      }
    }
  }

  Future<void> generateTapToken() async {
    try {
      var tapGooglePaySDKResult2 = await TapCardSdkFlutter.generateTapToken;
      debugPrint("Tap generateToken Response >>>>>> $tapGooglePaySDKResult2");

      handleCallbacks(tapGooglePaySDKResult2);
    } catch (ex) {
      if (kDebugMode) {
        print("Exception >>>> ${ex.toString()}");
      }
    }
  }

  handleCallbacks(Map<dynamic, dynamic> response) {
    if (response.containsKey("onHeightChange")) {
      /// onHeight Callbacks Triggered From SDK
      debugPrint("onHeightChange Key Contains");
      // setState(
      //   () {
      //     height = double.parse(
      //       response["onHeightChange"].toString(),
      //     );
      //   },
      // );
    }

    if (response.containsKey("onBindIdentification")) {
      /// onBindIdentification Callbacks Triggered From SDK
      debugPrint("onBindIdentification Key Contains");
      // setState(() {
      //   mCardSDKResponse = response["onBindIdentification"];
      // });
    }

    if (response.containsKey("onError")) {
      /// onError Callbacks Triggered From SDK
      debugPrint("onError Key Contains");
      // setState(() {
      //   mCardSDKResponse = response["onError"];
      // });
    }

    if (response.containsKey("onFocus")) {
      /// onFocus Callbacks Triggered From SDK
      debugPrint("onFocus Key Contains");
    }

    if (response.containsKey("onReady")) {
      /// onReady Callbacks Triggered From SDK
      debugPrint("onReady Key Contains");
    }

    if (response.containsKey("onSuccess")) {
      /// onSuccess Callbacks Triggered From SDK
      debugPrint("onSuccess Key Contains");
      debugPrint("onHeightChange Key Contains");
      var result = jsonDecode(response["onSuccess"]);
      setState(() {
        mCardSDKResponse = result;
      });
    }

    if (response.containsKey("onValidInput")) {
      /// onValidInput Callbacks Triggered From SDK
      debugPrint("onValidInput Key Contains");
      // setState(() {
      //   mCardSDKResponse = response["onValidInput"];
      // });
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
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TapCardSdkFlutter.tapCardSDKView(height: height),
            FilledButton(
              onPressed: () {
                generateTapToken();
              },
              child: const Text("Get Tap Token"),
            ),
            const SizedBox(height: 10),
            Text(
              mCardSDKResponse == null
                  ? ""
                  : "SDK RESPONSE : $mCardSDKResponse}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
