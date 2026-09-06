import WebKit
import ObjectiveC

private var keyboardWithoutUserActionSwizzled = false

@objc private class WKWebViewKeyboardSwizzler: NSObject {
    @objc func swizzled_elementDidFocus(
        _ element: UnsafeMutableRawPointer,
        userIsInteracting: Bool,
        blurSuppressionToken: UnsafeMutableRawPointer,
        activityStateChanges: UnsafeMutableRawPointer,
        userIsChangingFocus: Bool
    ) {
        swizzled_elementDidFocus(
            element,
            userIsInteracting: true,
            blurSuppressionToken: blurSuppressionToken,
            activityStateChanges: activityStateChanges,
            userIsChangingFocus: userIsChangingFocus
        )
    }

    @objc func swizzled_startAssistingNode(
        _ node: UnsafeMutableRawPointer,
        userIsInteracting: Bool,
        blurSuppressionToken: UnsafeMutableRawPointer,
        userInteraction: Bool
    ) {
        swizzled_startAssistingNode(
            node,
            userIsInteracting: true,
            blurSuppressionToken: blurSuppressionToken,
            userInteraction: userInteraction
        )
    }
}

extension WKWebView {
    static func allowDisplayingKeyboardWithoutUserAction() {
        guard !keyboardWithoutUserActionSwizzled else { return }
        keyboardWithoutUserActionSwizzled = true

        guard let contentViewClass: AnyClass = NSClassFromString("WKContentView") else {
            return
        }

        swizzle(
            on: contentViewClass,
            original: "_elementDidFocus:userIsInteracting:blurSuppressionToken:activityStateChanges:userIsChangingFocus:",
            swizzled: #selector(
                WKWebViewKeyboardSwizzler.swizzled_elementDidFocus(
                    userIsInteracting:blurSuppressionToken:activityStateChanges:userIsChangingFocus:
                )
            )
        )

        swizzle(
            on: contentViewClass,
            original: "_startAssistingNode:userIsInteracting:blurSuppressionToken:userInteraction:",
            swizzled: #selector(
                WKWebViewKeyboardSwizzler.swizzled_startAssistingNode(
                    userIsInteracting:blurSuppressionToken:userInteraction:
                )
            )
        )
    }

    private static func swizzle(on targetClass: AnyClass, original: String, swizzled: Selector) {
        let originalSelector = NSSelectorFromString(original)
        guard let originalMethod = class_getInstanceMethod(targetClass, originalSelector) else {
            return
        }
        guard let swizzledMethod = class_getInstanceMethod(WKWebViewKeyboardSwizzler.self, swizzled) else {
            return
        }

        let didAddMethod = class_addMethod(
            targetClass,
            swizzled,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )

        if didAddMethod, let addedMethod = class_getInstanceMethod(targetClass, swizzled) {
            method_exchangeImplementations(originalMethod, addedMethod)
        } else if let existingSwizzledMethod = class_getInstanceMethod(targetClass, swizzled) {
            method_exchangeImplementations(originalMethod, existingSwizzledMethod)
        }
    }

    func focusCardNumberInput(completion: ((Bool) -> Void)? = nil) {
        let script = """
        (function(){
          function focusIn(doc){
            if(!doc){return false;}
            var selectors=[
              'input[autocomplete="cc-number"]',
              'input[name*="card"]',
              'input[id*="card"]',
              'input[inputmode="numeric"]',
              'input[type="tel"]',
              'input[type="text"]',
              'input'
            ];
            for(var i=0;i<selectors.length;i++){
              var el=doc.querySelector(selectors[i]);
              if(el){el.focus(); if(typeof el.click==='function'){el.click();} return true;}
            }
            return false;
          }
          if(focusIn(document)){return 'input';}
          var iframes=document.querySelectorAll('iframe');
          for(var i=0;i<iframes.length;i++){
            try{
              iframes[i].focus();
              if(focusIn(iframes[i].contentDocument||(iframes[i].contentWindow&&iframes[i].contentWindow.document))){return 'iframe-input';}
            }catch(e){}
          }
          return iframes.length?'iframe':'none';
        })();
        """

        evaluateJavaScript(script) { result, _ in
            if let value = result as? String {
                completion?(value == "input" || value == "iframe-input")
            } else {
                completion?(false)
            }
        }
    }
}

func findWebView(in view: UIView) -> WKWebView? {
    if let webView = view as? WKWebView {
        return webView
    }
    for subview in view.subviews {
        if let found = findWebView(in: subview) {
            return found
        }
    }
    return nil
}

func scheduleCardNumberAutoFocus(on view: UIView, attempt: Int = 0, maxAttempts: Int = 12) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(attempt == 0 ? 500 : 300)) {
        guard let webView = findWebView(in: view) else {
            if attempt + 1 < maxAttempts {
                scheduleCardNumberAutoFocus(on: view, attempt: attempt + 1, maxAttempts: maxAttempts)
            }
            return
        }

        webView.becomeFirstResponder()
        webView.focusCardNumberInput { focused in
            if !focused, attempt + 1 < maxAttempts {
                scheduleCardNumberAutoFocus(on: view, attempt: attempt + 1, maxAttempts: maxAttempts)
            }
        }
    }
}
