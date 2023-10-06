import Flutter
import UIKit
import Card_iOS

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    private var cardDelegate: TapCardViewDelegate
    
    private var tapCardView: TapCardView

    init(messenger: FlutterBinaryMessenger,cardDelegate:TapCardViewDelegate, tapCardView: TapCardView) {
        self.messenger = messenger
        self.cardDelegate = cardDelegate
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
            cardDelegate: cardDelegate,
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
    private var cardDelegate: TapCardViewDelegate


    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        cardDelegate: TapCardViewDelegate,
        tapCardView: TapCardView

    ) {
        self.cardDelegate = cardDelegate
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
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)){
           // self.tapCardView = TapCardView(frame: .init(x: 0, y: 0, width: self._view.frame.width, height: self._view.frame.height))
            self._view.addSubview(tapCardView)
            self._view.bringSubviewToFront(tapCardView)
            tapCardView.initTapCardSDK(configDict: self._args ??  [:],delegate: self.cardDelegate )
            
            print(tapCardView.frame)
            }
    }
}
