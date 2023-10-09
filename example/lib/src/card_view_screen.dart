import 'package:card_flutter/card_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
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
              });
            },
            onValidInput: (String? validInput) {
              setState(() {
                mCardSDKResponse = validInput.toString();
              });
            },
            onHeightChange: (String? heightChange) {
              setState(() {
                mCardSDKResponse = heightChange.toString();
              });
            },
            onBindIdentification: (String? bindIdentification) {
              debugPrint(
                  "On BInd Identification Callback >>>>> $bindIdentification");
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
              });
            },
            generateToken: generateToken,
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: showTapTokenButton,
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
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
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
          ),
        ],
      ),
    );
  }
}
