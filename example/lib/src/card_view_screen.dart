import 'package:card_flutter/card_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          TapCardViewWidget(
            sdkConfiguration: {
              "order": {
                "description": "Authentication description",
                "id": "",
                "amount": 1,
                "currency": "SAR",
                "reference": "order_ref",
                "metadata": {"key": "value"}
              },
              "purpose": "Charge",
              "scope": "Token",
              "post": {"url": ""},
              "features": {
                "customerCards": {"autoSaveCard": true, "saveCard": true},
                "alternativeCardInputs": {"cardScanner": true},
                "acceptanceBadge": true
              },
              "customer": {
                "contact": {
                  "email": "tap@tap.company",
                  "phone": {"countryCode": "+965", "number": "88888888"}
                },
                "name": [
                  {
                    "lang": "en",
                    "first": "TAP",
                    "middle": "",
                    "last": "PAYMENTS"
                  }
                ],
                "nameOnCard": "TAP PAYMENTS",
                "id": "",
                "editable": true
              },
              "acceptance": {
                "supportedSchemes": [
                  "AMERICAN_EXPRESS",
                  "VISA",
                  "MASTERCARD",
                  "OMANNET",
                  "MADA"
                ],
                "supportedFundSource": ["CREDIT", "DEBIT"],
                "supportedPaymentAuthentications": ["3DS"]
              },
              "operator": {"publicKey": "pk_test_*****************"},
              "fieldVisibility": {
                "card": {"cvv": true, "cardHolder": true}
              },
              "merchant": {"id": "*******"},
              "invoice": {"id": "inv"},
              "transaction": {
                "paymentAgreement": {
                  "id": "",
                  "contract": {"id": ""}
                },
                "reference": "trx_ref"
              },
              "interface": {
                "powered": true,
                "loader": true,
                "theme": "light",
                "cardDirection": "LTR",
                "colorStyle": "colored",
                "edges": "curved",
                "locale": "dynamic"
              }
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
