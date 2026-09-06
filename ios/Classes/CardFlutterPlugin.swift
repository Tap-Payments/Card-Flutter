import Flutter
import UIKit
import Card_iOS

public class CardFlutterPlugin: NSObject, FlutterPlugin, TapCardViewDelegate,FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
                return nil
    }
    
    var eventSink: FlutterEventSink?
    
    var result: FlutterResult?
    var tapCardView: TapCardView = .init()
    private static var autoFocusEnabled = true

  public static func register(with registrar: FlutterPluginRegistrar) {
      let instance = CardFlutterPlugin()
      let factory = FLNativeViewFactory(messenger: registrar.messenger(),cardDelegate: instance, tapCardView: instance.tapCardView)
      registrar.register(factory, withId: "plugin/tap_card_sdk")
      let eventChannel = FlutterEventChannel(name: "card_flutter_event", binaryMessenger: registrar.messenger())
      eventChannel.setStreamHandler(instance)
      let channel = FlutterMethodChannel(name: "card_flutter", binaryMessenger: registrar.messenger())
   
      registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      self.result = result
    switch call.method {
    case "start":
        break
    case "start2":
        break
    case "generateToken":
        
        self.tapCardView.generateTapToken()
        
        break
    case "focusCardNumber":
        self.focusCardNumberField { focused in
            result(["focused": focused])
        }
        break
    case "setAutoFocus":
        if let args = call.arguments as? [String: Any] {
            CardFlutterPlugin.autoFocusEnabled = args["enabled"] as? Bool ?? true
        } else {
            CardFlutterPlugin.autoFocusEnabled = true
        }
        result(nil)
        break
    case "disposeCardView":
        disposeCardView()
        result(nil)
        break
    case "dismissKeyboard":
        dismissKeyboard()
        result(nil)
        break
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    public func onReady() {
        self.eventSink?(["onReady":"OnReady Callback Executed"])
        if CardFlutterPlugin.autoFocusEnabled {
            CardWebViewFocus.scheduleAutoFocus(on: self.tapCardView)
        }
    }
    
    public func onFocus() {
        self.eventSink?(["onFocus":"onFocus Callback Executed"])
    }
    
    public func onBinIdentification(data: String) {
        self.eventSink?(["onBinIdentification":data])
    }
    
    public func onSuccess(data: String) {
        self.eventSink?(["onSuccess":data])
    }
    
    public func onError(data: String) {
        
        self.eventSink?(["onError":data])

    }
    
    public func onInvalidInput(invalid: Bool) {
        
        self.eventSink?(["onValidInput":"\(!invalid)"])

    }
    
    
    public func onHeightChange(height: Double) {
        self.eventSink?(["onHeightChange":"\(height)"])
    }
    
    public func onChangeSaveCard(enabled: Bool) {
        self.eventSink?(["onChangeSaveCard":"\(enabled)"])
    }

    private func focusCardNumberField(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            CardWebViewFocus.focusCardNumber(in: self.tapCardView, completion: completion)
        }
    }

    private func dismissKeyboard() {
        DispatchQueue.main.async {
            CardWebViewFocus.cancelPendingFocus()
            self.tapCardView.endEditing(true)
            if let webView = CardWebViewFocus.webView(in: self.tapCardView) {
                webView.endEditing(true)
                webView.resignFirstResponder()
            }
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }

    private func disposeCardView() {
        DispatchQueue.main.async {
            self.dismissKeyboard()
            self.tapCardView.isHidden = true
            self.tapCardView.removeFromSuperview()
            if let webView = CardWebViewFocus.webView(in: self.tapCardView) {
                webView.load(URLRequest(url: URL(string: "about:blank")!))
            }
        }
    }
    
    
}
