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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const CardViewScreen(),
    );
  }
}

class CardViewScreen extends StatefulWidget {
  const CardViewScreen({
    super.key,
  });

  @override
  State<CardViewScreen> createState() => _CardViewScreenState();
}

class _CardViewScreenState extends State<CardViewScreen> {
  dynamic mCardSDKResponse;

  bool generateToken = false;

  bool showTapTokenButton = false;

  @override
  void initState() {
    showTapTokenButton = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("hoo hook,"),
          TapCardViewWidget(
            sdkConfiguration: const {
              'operator': {
                'publicKey': 'pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7',
              },
              'scope': 'Token',
              'order': {
                'reference': '',
                'amount': 1,
                'description': '',
                'currency': 'KWD',
                'id': '',
              },
              'customer': {
                'nameOnCard': '',
                'editable': true,
                'contact': {
                  'phone': {
                    'number': '011',
                    'countryCode': '+20',
                  },
                  'email': 'test@gmail.com',
                },
                'name': [
                  {
                    'middle': 'middle',
                    'last': 'last',
                    'lang': 'en',
                    'first': 'first',
                  }
                ],
              },
              'purpose': 'CHARGE',
              'transaction': {
                'metadata': {
                  'id': '',
                },
                'paymentAgreement': {
                  'contract': {
                    'id': '',
                  },
                  'id': '',
                },
              },
              'invoice': {
                'id': '',
              },
              'merchant': {
                'id': '1124340',
              },
              'features': {
                'customerCards': {
                  'saveCard': true,
                  'autoSaveCard': true,
                },
                'alternativeCardInputs': {
                  'cardScanner': true,
                  'cardNFC': true,
                },
                'acceptanceBadge': true,
              },
              'acceptance': {
                'supportedSchemes': [],
                'supportedFundSource': [],
                'supportedPaymentAuthentications': ['3DS'],
              },
              'fieldVisibility': {
                'card': {
                  'cvv': true,
                  'cardHolder': true,
                },
              },
              'interface': {
                'powered': true,
                'loader': true,
                'edges': 'flat',
                'colorStyle': 'colored',
                'theme': 'light',
                'cardDirection': 'dynamic',
                'locale': 'en',
              },
              'redirect': {
                'url': '',
              },
              'post': {
                'url': '',
              },
            },
            onReady: () {
              setState(() {
                showTapTokenButton = true;
              });
            },
            onFocus: () {
              setState(() {
                generateToken = false;
              });
            },
            onSuccess: (String? success) {
              setState(() {
                mCardSDKResponse = success.toString();
                generateToken = false;
              });
            },
            onValidInput: (String? validInput) {
              setState(() {
                mCardSDKResponse = validInput.toString();
                generateToken = false;
              });
            },
            onHeightChange: (String? heightChange) {
              setState(() {
                mCardSDKResponse = heightChange.toString();
              });
            },
            onBinIdentification: (String? binIdentification) {
              setState(() {
                mCardSDKResponse = binIdentification.toString();
              });
            },
            onChangeSaveCard: (String? saveCard) {
              setState(() {
                mCardSDKResponse = "saveCard $saveCard ".toString();
              });
            },
            onError: (String? error) {
              setState(() {
                mCardSDKResponse = error.toString();
                generateToken = false;
              });
            },
            generateToken: generateToken,
            cardNumber: "5123450000000008",
            cardExpiry: "01/39",
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: showTapTokenButton,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: FilledButton(
                onPressed: () {
                  setState(() {
                    generateToken = true;
                  });
                },
                style: FilledButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.sizeOf(context).width * 0.96,
                    50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onHover: (bool? value) {},
                child: const Text(
                  "Get Tap Token",
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: SelectableText(
                  mCardSDKResponse == null
                      ? ""
                      : "SDK RESPONSE : $mCardSDKResponse",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
