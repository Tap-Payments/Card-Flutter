import 'package:card_flutter/card_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'config_settings_screen.dart';

class CardViewScreen extends StatefulWidget {
  final Map<String, dynamic> dictionaryMap;

  const CardViewScreen({
    super.key,
    required this.dictionaryMap,
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
    debugPrint("SHOW TAP TOKEN BUTTON >>> $showTapTokenButton");
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
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConfigSettingsScreen(),
                ),
                (route) => false);
          },
          icon: const Icon(
            CupertinoIcons.back,
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TapCardViewWidget(
            sdkConfiguration: widget.dictionaryMap,
            onReady: () {
              debugPrint("onReady Callback >>>>>");

              setState(() {
                showTapTokenButton = true;
              });
            },
            onFocus: () {
              debugPrint("onFocus Callback >>>>>");

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
            onBinIdentification: (String? bindIdentification) {
              debugPrint(
                  "onBindIdentification Callback >>>>> $bindIdentification");
              setState(() {
                mCardSDKResponse = bindIdentification.toString();
              });
            },
            onChangeSaveCard: (String? saveCard) {
              setState(() {
                mCardSDKResponse = saveCard.toString();
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
                child: Text(
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
