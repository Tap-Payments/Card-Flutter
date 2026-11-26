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
    
    //MARK: - Preload state
    /// The configuration a preload started with, until a card view claims it or it is dropped
    private var preloadedConfiguration: NSDictionary?
    /// True once a card view took over the preloaded form
    private var preloadClaimed = false
    /// True once the widget asked to start after the preload began, so it is listening to events
    private var startRequested = false
    /// While a preloaded form is not shown yet, its events are kept here and replayed later
    private var isBufferingEvents = false
    private var bufferedEvents: [[String: Any]] = []
    /// Keeps the preloading card in the window, out of sight, so WebKit keeps rendering it
    private var offscreenHost: UIView?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
      let instance = CardFlutterPlugin()
      let factory = FLNativeViewFactory(messenger: registrar.messenger(),cardPlugin: instance, tapCardView: instance.tapCardView)
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
        // The card view starts the SDK itself when it is created; the widget only starts
        // listening to events here, which is when the events of a preload can be replayed.
        startRequested = true
        flushPreloadEventsIfPossible()
        break
    case "start2":
        break
    case "preload":
        guard let args = call.arguments as? [String: Any],
              let configuration = args["configuration"] as? [String: Any] else {
            result(FlutterError(code: "invalid_arguments", message: "preload needs a configuration", details: nil))
            return
        }
        preload(configuration: configuration)
        result(nil)
    case "cancelPreload":
        dropPreload()
        result(nil)
    case "generateToken":
        
        self.tapCardView.generateTapToken()
        
        break
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    //MARK: - Preload
    
    /// Starts loading the card form before the widget is shown.
    /// iOS does not prefill the card number in either path, so only the configuration is matched.
    private func preload(configuration: [String: Any]) {
        dropPreload()
        preloadedConfiguration = NSDictionary(dictionary: configuration)
        preloadClaimed = false
        startRequested = false
        isBufferingEvents = true
        bufferedEvents = []
        let window = hostWindow()
        if let window = window {
            // A WKWebView outside any window is not rendered, so the form would not finish
            // loading. Keep it in the window, to the right of the screen.
            let host = UIView(frame: CGRect(x: window.bounds.width + 100, y: 0, width: window.bounds.width, height: 400))
            host.isUserInteractionEnabled = false
            host.clipsToBounds = true
            window.addSubview(host)
            host.addSubview(tapCardView)
            tapCardView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tapCardView.leadingAnchor.constraint(equalTo: host.leadingAnchor),
                tapCardView.trailingAnchor.constraint(equalTo: host.trailingAnchor),
                tapCardView.centerYAnchor.constraint(equalTo: host.centerYAnchor)
            ])
            offscreenHost = host
        }
        tapCardView.initTapCardSDK(configDict: configuration, delegate: self, presentScannerIn: window?.rootViewController)
    }
    
    /// Called by a new card view. Returns true when it should show the preloaded form as is,
    /// false when it has to start the SDK itself (no preload, or one with another configuration).
    func claimPreload(configuration: [String: Any]?) -> Bool {
        guard let preloadedConfiguration = preloadedConfiguration, !preloadClaimed else { return false }
        guard let configuration = configuration,
              preloadedConfiguration.isEqual(to: configuration) else {
            dropPreload()
            return false
        }
        preloadClaimed = true
        flushPreloadEventsIfPossible()
        return true
    }
    
    /// Called once the card view moved the preloaded form out of the offscreen host.
    func removeOffscreenHost() {
        offscreenHost?.removeFromSuperview()
        offscreenHost = nil
    }
    
    /// Stops holding events and forgets the preload. A load in progress is not stopped: the next card view loads over it.
    private func dropPreload() {
        if tapCardView.superview != nil, tapCardView.superview === offscreenHost {
            tapCardView.removeFromSuperview()
        }
        removeOffscreenHost()
        preloadedConfiguration = nil
        preloadClaimed = false
        isBufferingEvents = false
        bufferedEvents = []
    }
    
    /// Replays the preload's events once a card view shows the form and the widget listens.
    private func flushPreloadEventsIfPossible() {
        guard preloadClaimed, startRequested, let eventSink = eventSink else { return }
        let events = bufferedEvents
        bufferedEvents = []
        isBufferingEvents = false
        preloadedConfiguration = nil
        preloadClaimed = false
        events.forEach { eventSink($0) }
    }
    
    private func hostWindow() -> UIWindow? {
        let windows = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
        return windows.first(where: { $0.isKeyWindow }) ?? windows.first
    }
    
    /// Sends an event to the widget, or keeps it while a preloaded form is not shown yet.
    private func send(_ event: [String: Any]) {
        if isBufferingEvents {
            bufferedEvents.append(event)
        } else {
            eventSink?(event)
        }
    }
    
    //MARK: - TapCardViewDelegate
    
    public func onReady() {
        send(["onReady":"OnReady Callback Executed"])
    }
    
    public func onFocus() {
        send(["onFocus":"onFocus Callback Executed"])
    }
    
    public func onBinIdentification(data: String) {
        send(["onBinIdentification":data])
    }
    
    public func onSuccess(data: String) {
        send(["onSuccess":data])
    }
    
    public func onError(data: String) {
        send(["onError":data])
    }
    
    public func onInvalidInput(invalid: Bool) {
        send(["onValidInput":"\(!invalid)"])
    }
    
    
    public func onHeightChange(height: Double) {
        send(["onHeightChange":"\(height)"])
    }
    
    public func onChangeSaveCard(enabled: Bool) {
        send(["onChangeSaveCard":"\(enabled)"])
    }
    
    
}
