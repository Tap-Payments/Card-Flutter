import Flutter
import UIKit
import Card_iOS

public class CardFlutterPlugin: NSObject, FlutterPlugin, TapCardViewDelegate {
    var result: FlutterResult?
    var tapCardView: TapCardView = .init()
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = CardFlutterPlugin()
      let factory = FLNativeViewFactory(messenger: registrar.messenger(),cardDelegate: instance, tapCardView: instance.tapCardView)
    registrar.register(factory, withId: "plugin/tap_card_sdk")
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
        self.result?(["onReady":"OnReady Callback Executed"])
    }
    
    public func onFocus() {
        self.result?(["onFocus":"onFocus Callback Executed"])
    }
    
    public func onBinIdentification(data: String) {
        self.result?(["onBindIdentification":data])
    }
    
    public func onSuccess(data: String) {
        self.result?(["onSuccess":data])
    }
    
    public func onError(data: String) {
        
        self.result?(["onError":data])

    }
    
    public func onInvalidInput(invalid: Bool) {
        
        self.result?(["onValidInput":"\(!invalid)"])

    }
    
    
    public func onHeightChange(height: Double) {
        self.result?(["onHeightChange":"\(height)"])
    }
    
    
}
