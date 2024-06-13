import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TapCardViewWidget extends StatefulWidget {
  final Function()? onReady, onFocus;
  final Function(String?)? onSuccess,
      onError,
      onValidInput,
      onBinIdentification,
      onHeightChange,
      onChangeSaveCard;
  final bool generateToken;
  final Map<String, dynamic> sdkConfiguration;
  final String? cardNumber, cardExpiry;

  const TapCardViewWidget({
    super.key,
    this.onReady,
    this.onSuccess,
    this.onError,
    this.onValidInput,
    this.onBinIdentification,
    this.onHeightChange,
    this.onFocus,
    this.onChangeSaveCard,
    this.cardNumber,
    this.cardExpiry,
    required this.generateToken,
    required this.sdkConfiguration,
  });

  @override
  State<TapCardViewWidget> createState() => _TapCardViewWidgetState();
}

class _TapCardViewWidgetState extends State<TapCardViewWidget> {
  late Function()? onReadyFunction;
  late Function()? onFocusFunction;
  late Function(String?)? onSuccessFunction;
  late Function(String?)? onErrorFunction;
  late Function(String?)? onValidInputFunction;
  late Function(String?)? onChangeSaveCardFunction;
  late Function(String?)? onBinIdentificationFunction;
  late Function(String?)? onHeightChangeFunction;

  bool tokenAlreadyInProgress = false;

  static const MethodChannel _channel = MethodChannel('card_flutter');

  static const EventChannel _eventChannel = EventChannel('card_flutter_event');

  void streamTimeFromNative() {
    _eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void _onEvent(dynamic event) {
    handleCallbacks(event);
  }

  void _onError(dynamic event) {}

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0), () {
      streamTimeFromNative();
      startTapCardSDK();
    });
    super.initState();
  }

  Future<dynamic> startTapCardSDK() async {
    try {
      dynamic result = await _channel.invokeMethod(
        'start',
        {
          "configuration": widget.sdkConfiguration,
          "cardNumber": widget.cardNumber ?? "",
          "cardExpiry": widget.cardExpiry ?? "",
        },
      );
      handleCallbacks(result);
      _startTapCardSDK2();
    } catch (ex) {
      //  debugPrint("Start SDK Exception >>>>>> $ex");
    }
  }

  Future<dynamic> _startTapCardSDK2() async {
    try {
      dynamic result = await _channel.invokeMethod(
        'start2',
        {
          "configuration": widget.sdkConfiguration,
          "cardNumber": widget.cardNumber ?? "",
          "cardExpiry": widget.cardExpiry ?? "",
        },
      );

      handleCallbacks(result);
      _startTapCardSDK2();
    } catch (ex) {
      // debugPrint("Exception >>>>>> $ex");
    }
  }

  Future<dynamic> generateTapToken() async {
    try {
      dynamic result = await _channel.invokeMethod(
        'generateToken',
        {
          "configuration": widget.sdkConfiguration,
          "cardNumber": widget.cardNumber ?? "",
          "cardExpiry": widget.cardExpiry ?? "",
        },
      );

      handleCallbacks(result);
      _startTapCardSDK2();
    } catch (ex) {
      // debugPrint("Exception >>>>>> $ex");
    }
  }

  handleCallbacks(dynamic result) {
    if (result.containsKey("onHeightChange")) {
      setState(() {
        height = double.parse(result["onHeightChange"].toString());
        height = height + 10;
      });
    }

    if (result.containsKey("onBinIdentification")) {
      /// onBindIdentification Callbacks Triggered From SDK
      var resultOfBindIdentification = result["onBinIdentification"].toString();

      onBinIdentificationFunction = widget.onBinIdentification;
      onBinIdentificationFunction!(resultOfBindIdentification.toString());
    }

    if (result.containsKey("onError")) {
      /// onError Callbacks Triggered From SDK
      onErrorFunction = widget.onError;
      onErrorFunction!(result["onError"].toString());
    }

    if (result.containsKey("onFocus")) {
      /// onFocus Callbacks Triggered From SDK
      onFocusFunction = widget.onFocus;
      onFocusFunction!();
    }

    if (result.containsKey("onReady")) {
      onReadyFunction = widget.onReady;
      onReadyFunction!();
    }

    if (result.containsKey("onSuccess")) {
      /// onSuccess Callbacks Triggered From SDK
      var resultOfSuccess = result["onSuccess"].toString();
      onSuccessFunction = widget.onSuccess;
      onSuccessFunction!(resultOfSuccess.toString());
    }

    if (result.containsKey("onValidInput")) {
      /// onValidInput Callbacks Triggered From SDK
      var resultOfValidInput = result["onValidInput"].toString();
      onValidInputFunction = widget.onValidInput;
      onValidInputFunction!(resultOfValidInput.toString());
    }

    if (result.containsKey("onChangeSaveCard")) {
      /// onValidInput Callbacks Triggered From SDK
      var resultOfOnChangeSaveCard = result["onChangeSaveCard"].toString();
      onChangeSaveCardFunction = widget.onChangeSaveCard;
      onChangeSaveCardFunction!(resultOfOnChangeSaveCard.toString());
    }
  }

  double height = 95;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.generateToken) {
      if (tokenAlreadyInProgress == false) {
        generateTapToken();
        tokenAlreadyInProgress = true;
      }
    } else {
      tokenAlreadyInProgress = false;
    }

    if (Theme.of(context).platform == TargetPlatform.android) {
      return SizedBox(
        height: height,
        child: AndroidView(
          viewType: "plugin/tap_card_sdk",
          creationParams: widget.sdkConfiguration,
          creationParamsCodec: const StandardMessageCodec(),
          layoutDirection: TextDirection.ltr,
        ),
      );
    } else {
      return SizedBox(
        height: height,
        child: UiKitView(
          viewType: "plugin/tap_card_sdk",
          creationParams: widget.sdkConfiguration,
          layoutDirection: TextDirection.ltr,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    }
  }
}
