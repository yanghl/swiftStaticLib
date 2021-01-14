//
//  GWBridge.swift
//  superora_ios
//
//  Created by yangshiyu on 2020/2/9.
//  Copyright © 2020 xue. All rights reserved.
//

import UIKit
import WebKit
import WKWebViewJavascriptBridge

public class GWBridge: NSObject {
    var bridge:WKWebViewJavascriptBridge!
    var viewController:UIViewController!
    var webview:WKWebView!
    
    init(bridge:WKWebViewJavascriptBridge,viewController:UIViewController,webview:WKWebView) {
        self.bridge = bridge
        self.viewController = viewController
        self.webview = webview
    }
    
    public func register(handlerName: String, handler: @escaping WKWebViewJavascriptBridgeBase.Handler) {
        bridge.register(handlerName: handlerName) { (paramters, callback) in
            //解析一下
            if let content = paramters!["data"] as? String {
                do{
                    let json = try JSONSerialization.jsonObject(with: content.data(using: String.Encoding.utf8)!, options:.allowFragments)
                    handler(["data":json], callback)
                }catch {
                    handler(nil, callback)
                }
            }else{
                handler(nil, callback)
            }
        }
    }
    
    public func injectJS(path:String){
        do {
            let content = try String.init(contentsOfFile: path, encoding: String.Encoding.utf8)
            let userVC = webview.configuration.userContentController
            let script = WKUserScript(source: content, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
            userVC.addUserScript(script)
        } catch  {
            
        }
    }
}
