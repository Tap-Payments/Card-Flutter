import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TapCardSdkFlutter {
  static final Map<dynamic, dynamic> _tapCheckoutSDKResult =
      <dynamic, dynamic>{};

//  static const MethodChannel _channel = MethodChannel('samples.flutter.dev/battery');
  static const MethodChannel _channel = MethodChannel('tap_card_sdk_flutter');

  static Future<dynamic> get startTapCardSDK async {
    try {
      debugPrint("SDK Configuration >>>>>> $sdkConfigurations");
      dynamic result = await _channel.invokeMethod(
        'start',
        {
          "configuration": sdkConfigurations,
        },
      );

      debugPrint("Start SDK Response >>>>>> $result");
      return result;
    } catch (ex) {
      debugPrint("Start SDK 2 Exception >>>>>> $ex");
    }
  }

  static Future<dynamic> get startTapCardSDK2 async {
    try {
      debugPrint("SDK Configuration >>>>>> $sdkConfigurations");

      dynamic result = await _channel.invokeMethod(
        'start2',
        {
          "configuration": sdkConfigurations,
        },
      );
      debugPrint("Start SDK 2 Response >>>>>> $result");

      return result;
    } catch (ex) {
      debugPrint("Start SDK 2 Exception >>>>>> $ex");
    }
  }

  static Future<dynamic> get generateTapToken async {
    //  if (!_validateAppConfig()) return _tapCheckoutSDKResult;

    try {
      debugPrint("SDK Configuration >>>>>> $sdkConfigurations");
      dynamic result = await _channel.invokeMethod(
        'generateToken',
        {
          "configuration": sdkConfigurations,
        },
      );

      debugPrint("Generate Tap Token Response >>>>>> $result");

      return result;
    } catch (ex) {
      debugPrint("Generate Tap Token Exception >>>>>> $ex");
    }
  }

  static Map<String, dynamic> sdkConfigurations = {};

  /// App configurations
  static void setupConfiguration({
    required String merchant,
    required String transactionAmount,
    required String transactionCurrency,
    required String phoneCountryCode,
    required String phoneNumber,
    required String contactEmail,
    required String nameFirst,
    required String nameMiddle,
    required String nameLast,
    required String nameLang,
    required String customerNameOnCard,
    required String customerEditable,
    required List<String> acceptanceSupportedBrands,
    required List<String> acceptanceSupportedCards,
    required String fieldsCardHolder,
    required bool addonsLoader,
    required bool addonsSaveCard,
    required bool addonsDisplayPaymentBrands,
    required bool addonsScanner,
    required bool addonsNFC,
    required String referenceTransaction,
    required String referenceOrder,
    required String authChannel,
    required String authPurpose,
    required String invoiceID,
    required String postID,
    required String authenticationDescription,
    required String interfaceLocale,
    required String interfaceTheme,
    required String interfaceEdges,
    required String interfaceDirection,
    required String publicKey,
    required String scope,
  }) {
    sdkConfigurations = <String, dynamic>{
      "id": merchant,
      "amount": transactionAmount,
      "currency": transactionCurrency,
      "countryCode": phoneCountryCode,
      "number": phoneNumber,
      "email": contactEmail,
      "lang": nameLang,
      "first": nameFirst,
      "middle": nameMiddle,
      "last": nameLast,
      "nameOnCard": customerNameOnCard,
      "editable": customerEditable,
      "supportedBrands": acceptanceSupportedBrands,
      "supportedCards": acceptanceSupportedCards,
      "cardHolder": fieldsCardHolder,
      "loader": addonsLoader,
      "saveCard": addonsSaveCard,
      "displayPaymentBrands": addonsDisplayPaymentBrands,
      "scanner": addonsScanner,
      "nfc": addonsNFC,
      "transaction": referenceTransaction,
      "order": referenceOrder,
      "channel": authChannel,
      "purpose": authPurpose,
      "invoiceId": invoiceID,
      "postId": postID,
      "description": authenticationDescription,
      "locale": interfaceLocale,
      "theme": interfaceTheme,
      "edges": interfaceEdges,
      "direction": interfaceDirection,
      "publicKey": publicKey,
      "scope": scope,
    };
  }

  // Google pay Button Widget from TapGooglePaySDK
  static Widget tapCardSDKView({
    required double height,
  }) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return SizedBox(
        height: height,
        child: AndroidView(
          viewType: "plugin/tap_card_sdk",
          creationParams: TapCardSdkFlutter.sdkConfigurations,
          creationParamsCodec: const StandardMessageCodec(),
          layoutDirection: TextDirection.ltr,
        ),
      );
    }
    return const SizedBox();
  }
}
