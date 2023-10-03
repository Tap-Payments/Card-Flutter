import 'package:card_flutter/card_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic mCardSDKResponse;

  bool generateToken = false;

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
            TapCardViewWidget(
              sdkConfiguration: const {
                "features": {
                  "customerCards": {"saveCard": true, "autoSaveCard": true},
                  "scanner": true,
                  "acceptanceBadge": true,
                  "nfc": false
                },
                "redirect": {"url": ""},
                "post": {"url": ""},
                "customer": {
                  "id": "",
                  "name": [
                    {
                      "first": "TAP",
                      "middle": "",
                      "lang": "en",
                      "last": "PAYMENTS"
                    }
                  ],
                  "editable": true,
                  "contact": {
                    "email": "tap@tap.company",
                    "phone": {"countryCode": "+965", "number": "88888888"}
                  },
                  "nameOnCard": "TAP PAYMENTS"
                },
                "fields": {
                  "card": {"cardHolder": true, "cvv": true}
                },
                "merchant": {"id": ""},
                "interface": {
                  "powered": true,
                  "colorStyle": "monochrome",
                  "theme": "light",
                  "locale": "en",
                  "edges": "curved",
                  "cardDirection": "dynamic"
                },
                "purpose": "PAYMENT_TRANSACTION",
                "operator": {"publicKey": "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7"},
                "scope": "AuthenticatedToken",
                "addons": {"loader": true},
                "order": {
                  "description": "Authentication description",
                  "currency": "KWD",
                  "amount": 1,
                  "id": ""
                },
                "transaction": {
                  "metadata": {"example": "value"},
                  "reference": "tck_LVJL1I4XCwsgIYmilBINsAKYI",
                  "paymentAgreement": {
                    "id": "",
                    "contract": {"id": ""}
                  }
                },
                "invoice": {"id": ""},
                "acceptance": {
                  "supportedPaymentAuthentications": ["3DS"],
                  "supportedFundSource": ["CREDIT", "DEBIT"],
                  "supportedSchemes": [
                    "AMERICAN_EXPRESS",
                    "VISA",
                    "MASTERCARD",
                    "OMANNET",
                    "MADA"
                  ]
                }
              },
              onReady: () {
                debugPrint(">ON READY FIRED FROM CALLBACK");
              },
              onFocus: () {
                setState(() {
                  generateToken = false;
                });
                debugPrint(">ON FOCUS FIRED FROM CALLBACK");
              },
              onSuccess: (String? success) {
                debugPrint(">ON SUCCESS FIRED FROM CALLBACK >>>>>> $success");
                setState(() {
                  mCardSDKResponse = success.toString();
                });
              },
              onValidInput: (String? validInput) {
                debugPrint(
                    ">ON VALID INPUT FIRED FROM CALLBACK >>>>>> $validInput");
                setState(() {
                  mCardSDKResponse = validInput.toString();
                });
              },
              onHeightChange: (String? heightChange) {
                debugPrint(
                    ">ON HEIGHT CHANGE FIRED FROM CALLBACK >>>>>> $heightChange");
                setState(() {
                  mCardSDKResponse = heightChange.toString();
                });
              },
              onBindIdentification: (String? bindIdentification) {
                debugPrint(
                    ">ON BIND IDENTIFICATION FIRED FROM CALLBACK >>>>>> $bindIdentification");
                setState(() {
                  mCardSDKResponse = bindIdentification.toString();
                });
              },
              onError: (String? error) {
                debugPrint(">ON ERROR FIRED FROM CALLBACK >>>>>> $error");
                setState(() {
                  mCardSDKResponse = error.toString();
                });
              },
              generateToken: generateToken,
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  generateToken = true;
                });
              },
              style: FilledButton.styleFrom(
                fixedSize: Size(MediaQuery.sizeOf(context).width * 0.96, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onHover: (bool? value) {},
              child: const Text("Get Tap Token"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                mCardSDKResponse == null
                    ? ""
                    : "SDK RESPONSE : $mCardSDKResponse}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
