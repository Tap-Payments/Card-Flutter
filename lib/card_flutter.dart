import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// Loads the Tap card form ahead of time, so it is already loaded when a
/// [TapCardViewWidget] is shown.
///
/// Loading the form takes a few seconds (the SDK configuration, the card web page
/// and its script). Call [preload] on an earlier screen, for example the screen
/// where the payer picks the amount, with the same values you will pass to
/// [TapCardViewWidget]. When the widget is then built with an equal
/// `sdkConfiguration` (and, on Android, equal `cardNumber` and `cardExpiry`), it
/// shows the preloaded form instead of starting a new load, and `onReady` fires
/// as soon as the form is ready, right away if it already is.
///
/// If the widget is built with different values, the preloaded form is dropped
/// and the widget loads the form as usual, so a stale preload never shows the
/// wrong amount or currency.
///
/// There is one card form per app: preload while no [TapCardViewWidget] is on
/// screen, and calling [preload] again replaces the previous preload.
class TapCardSDK {
  TapCardSDK._();

  static const MethodChannel _channel = MethodChannel('card_flutter');

  /// Starts loading the card form for [sdkConfiguration] in the background.
  static Future<void> preload({
    required Map<String, dynamic> sdkConfiguration,
    String? cardNumber,
    String? cardExpiry,
  }) {
    return _channel.invokeMethod<void>('preload', {
      "configuration": sdkConfiguration,
      "cardNumber": cardNumber ?? "",
      "cardExpiry": cardExpiry ?? "",
    });
  }

  /// Drops a preloaded card form that will not be shown.
  static Future<void> cancelPreload() {
    return _channel.invokeMethod<void>('cancelPreload');
  }
}

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
  final bool showLoading;

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
    this.showLoading = false,
  });

  @override
  State<TapCardViewWidget> createState() => _TapCardViewWidgetState();
}

class _TapCardViewWidgetState extends State<TapCardViewWidget>
    with SingleTickerProviderStateMixin {
  late Function()? onReadyFunction;
  late Function()? onFocusFunction;
  late Function(String?)? onSuccessFunction;
  late Function(String?)? onErrorFunction;
  late Function(String?)? onValidInputFunction;
  late Function(String?)? onChangeSaveCardFunction;
  late Function(String?)? onBinIdentificationFunction;
  late Function(String?)? onHeightChangeFunction;

  bool tokenAlreadyInProgress = false;
  bool sdkStarted = false;
  static const MethodChannel _channel = MethodChannel('card_flutter');

  static const EventChannel _eventChannel = EventChannel('card_flutter_event');

  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  Timer? _heightDebounceTimer;
  double? _pendingHeight;
  StreamSubscription<dynamic>? _eventSubscription;

  void streamTimeFromNative() {
    _eventSubscription = _eventChannel
        .receiveBroadcastStream()
        .listen(_onEvent, onError: _onError);
  }

  void _onEvent(dynamic event) {
    handleCallbacks(event);
  }

  void _onError(dynamic event) {}

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.linear,
    ));

    Future.delayed(const Duration(seconds: 0), () {
      streamTimeFromNative();
      startTapCardSDK();
    });
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
    if (!mounted) return;
    if (result.containsKey("onHeightChange")) {
      _pendingHeight = double.parse(result["onHeightChange"].toString()) + 10;

      _heightDebounceTimer?.cancel();
      _heightDebounceTimer = Timer(const Duration(milliseconds: 50), () {
        if (_pendingHeight != null && mounted) {
          setState(() {
            height = _pendingHeight!;
            isHeightSet = true;
          });
        }
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
      setState(() {
        sdkStarted = true;
      });
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
  bool isHeightSet = false;

  @override
  void dispose() {
    // Stop listening, so events of a later card form (or of a preload) never
    // reach this widget once it is gone.
    _eventSubscription?.cancel();
    _shimmerController.dispose();
    _heightDebounceTimer?.cancel();
    super.dispose();
  }

  Widget _buildShimmerOverlay(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final shimmerColors = isDarkMode
        ? [
            const Color(0xFF6B6B6B),
            const Color(0xFF5F5F5F),
            const Color(0xFF6B6B6B),
          ]
        : [
            const Color(0xFFF2F2F2),
            const Color(0xFFE9E9E9),
            const Color(0xFFF2F2F2),
          ];

    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        double shimmerHeight = height;
        if (!isHeightSet) {
          bool? acceptanceBadge =
              widget.sdkConfiguration['features']?['acceptanceBadge'];
          shimmerHeight =
              (acceptanceBadge == null || acceptanceBadge == true) ? 105 : 74;
        }

        return Container(
          height: shimmerHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: shimmerColors,
              stops: const [0.0, 0.5, 1.0],
              transform: GradientRotation(0),
            ),
          ),
          child: FractionallySizedBox(
            widthFactor: 1.0,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment(_shimmerAnimation.value - 1, 0),
                  end: Alignment(_shimmerAnimation.value, 0),
                  colors: shimmerColors,
                  stops: const [0.0, 0.5, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
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

    Widget platformView;
    if (Theme.of(context).platform == TargetPlatform.android) {
      platformView = PlatformViewLink(
        viewType: 'plugin/tap_card_sdk',
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (params) {
          return PlatformViewsService.initExpensiveAndroidView(
            id: params.id,
            viewType: 'plugin/tap_card_sdk',
            layoutDirection: TextDirection.ltr,
            creationParams: widget.sdkConfiguration,
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () => params.onFocusChanged(true),
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create();
        },
      );
    } else {
      platformView = UiKitView(
        viewType: "plugin/tap_card_sdk",
        creationParams: widget.sdkConfiguration,
        layoutDirection: TextDirection.ltr,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutCubicEmphasized,
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            platformView,
            if (widget.showLoading)
              IgnorePointer(
                ignoring: sdkStarted,
                child: AnimatedOpacity(
                  opacity: sdkStarted ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutQuart,
                  child: _buildShimmerOverlay(context),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
