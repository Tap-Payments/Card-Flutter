import ObjectiveC
import UIKit
import WebKit

/// Programmatic focus helpers for the card form, which is rendered inside a
/// `WKWebView` and therefore cannot be focused through Flutter's focus system.
enum CardWebViewFocus {

    private static let focusScript = """
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

    /// Depth first search for the card form web view inside `view`.
    static func webView(in view: UIView) -> WKWebView? {
        if let webView = view as? WKWebView {
            return webView
        }
        for subview in view.subviews {
            if let found = webView(in: subview) {
                return found
            }
        }
        return nil
    }

    /// Focuses the card number input and raises the keyboard. Calls back with
    /// `false` when the form is not loaded yet so the caller can retry.
    static func focusCardNumber(in view: UIView, completion: @escaping (Bool) -> Void) {
        WebViewKeyboardPatch.applyIfNeeded()
        guard let webView = webView(in: view) else {
            completion(false)
            return
        }
        webView.becomeFirstResponder()
        webView.evaluateJavaScript(focusScript) { result, _ in
            let value = result as? String
            completion(value == "input" || value == "iframe-input")
        }
    }

    private static var focusGeneration = 0

    /// Invalidates any in-flight auto-focus retries (used on dispose / keyboard dismiss).
    static func cancelPendingFocus() {
        focusGeneration += 1
    }

    /// Retries `focusCardNumber` until it succeeds, because `onReady` fires
    /// before the form inputs are guaranteed to be in the DOM.
    static func scheduleAutoFocus(on view: UIView, attempt: Int = 0, maxAttempts: Int = 12) {
        if attempt == 0 {
            focusGeneration += 1
        }
        let generation = focusGeneration
        let delay: DispatchTimeInterval = .milliseconds(attempt == 0 ? 500 : 300)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard generation == focusGeneration else { return }
            focusCardNumber(in: view) { focused in
                guard generation == focusGeneration else { return }
                if !focused, attempt + 1 < maxAttempts {
                    scheduleAutoFocus(on: view, attempt: attempt + 1, maxAttempts: maxAttempts)
                }
            }
        }
    }
}

/// `WKWebView` only raises the keyboard for a programmatic `focus()` when the
/// user has already interacted with the page. The patch below forwards every
/// focus event to WebKit as user initiated so `autoFocus` can open the keyboard
/// on its own. It is applied lazily, so apps that pass `autoFocus: false` never
/// reach it, and it no-ops on any OS version where the method is not found.
private enum WebViewKeyboardPatch {

    private static var applied = false

    static func applyIfNeeded() {
        guard !applied else { return }
        applied = true

        guard let contentViewClass: AnyClass = NSClassFromString("WKContentView") else { return }
        let selector = NSSelectorFromString(
            "_elementDidFocus:userIsInteracting:blurPreviousNode:activityStateChanges:userObject:"
        )
        guard let method = class_getInstanceMethod(contentViewClass, selector) else { return }

        typealias ElementDidFocus = @convention(c) (
            AnyObject, Selector, UnsafeRawPointer, Bool, Bool, UInt, AnyObject?
        ) -> Void

        let original = unsafeBitCast(method_getImplementation(method), to: ElementDidFocus.self)
        let replacement: @convention(block) (
            AnyObject, UnsafeRawPointer, Bool, Bool, UInt, AnyObject?
        ) -> Void = { receiver, element, _, blurPreviousNode, activityStateChanges, userObject in
            original(receiver, selector, element, true, blurPreviousNode, activityStateChanges, userObject)
        }

        method_setImplementation(method, imp_implementationWithBlock(replacement))
    }
}
