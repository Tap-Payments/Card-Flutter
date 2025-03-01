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
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    public func onReady() {
        self.eventSink?(["onReady":"OnReady Callback Executed"])
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
    
    
}
