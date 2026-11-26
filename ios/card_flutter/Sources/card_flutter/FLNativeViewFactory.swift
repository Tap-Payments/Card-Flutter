import Flutter
import UIKit
import Card_iOS

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    private var cardPlugin: CardFlutterPlugin
    
    private var tapCardView: TapCardView

    init(messenger: FlutterBinaryMessenger,cardPlugin: CardFlutterPlugin, tapCardView: TapCardView) {
        self.messenger = messenger
        self.cardPlugin = cardPlugin
        self.tapCardView = tapCardView
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            cardPlugin: cardPlugin,
            tapCardView: tapCardView
        )
    }

    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var _args: [String:Any]?
    private var cardPlugin: CardFlutterPlugin


    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        cardPlugin: CardFlutterPlugin,
        tapCardView: TapCardView

    ) {
        self.cardPlugin = cardPlugin
        _view = UIView()
        self._args = args as? [String:Any]
        super.init()
        createNativeView(view: _view, tapCardView: tapCardView)
    }

    func view() -> UIView {
        return _view
    }

   // var tapCardView = TapCardView.init()

    func createNativeView(view _view: UIView,tapCardView: TapCardView){
        _view.backgroundColor = UIColor.clear
        // The card view is pinned with Auto Layout, so it follows the container
        // whenever Flutter sizes it; there is no need to wait before starting the SDK.
        _view.addSubview(tapCardView)
        _view.bringSubviewToFront(tapCardView)
        tapCardView.translatesAutoresizingMaskIntoConstraints = false
        // adjust the constraints MUST
        NSLayoutConstraint.activate([
            tapCardView.leadingAnchor.constraint(equalTo: _view.leadingAnchor, constant: 0),
            tapCardView.trailingAnchor.constraint(equalTo: _view.trailingAnchor, constant: 0),
            tapCardView.centerYAnchor.constraint(equalTo: _view.centerYAnchor)
        ])
        if cardPlugin.claimPreload(configuration: _args) {
            // Loaded (or loading) already by TapCardSDK.preload: moving it here is all it takes.
            cardPlugin.removeOffscreenHost()
        } else {
            tapCardView.initTapCardSDK(configDict: _args ?? [:], delegate: cardPlugin)
        }
    }
}
