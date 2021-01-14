//
//  GWWebViewController.swift
//  superora_ios
//
//  Created by yangshiyu on 2020/2/9.
//  Copyright © 2020 xue. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import WKWebViewJavascriptBridge

open class GWWebViewController: UIViewController {
    let webView = WKWebView(frame: CGRect(), configuration: WKWebViewConfiguration())
    var bridge: GWBridge!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
        
        //初始化桥接文件
        bridge = GWBridge(bridge: WKWebViewJavascriptBridge(webView: webView), viewController: self, webview: webView)
        
        //注入框架JS文件
        bridge.injectJS(path: Bundle.main.path(forResource: "GWBridge", ofType: "js")!)
        
        //注册每个模块的 原生API 和 JS文件
        for obj in bridgeManager.modules {
            if let b = obj as? JSBridgeModuleProtocol {
                //注册原生API
                b.attachToJSBridge(bridge: bridge)
                //注入JS文件
                if let filePath = b.moduleSourceFile() {
                    bridge.injectJS(path: filePath)
                }
            }
        }
        
//        //主动调用JS函数 dome
//        bridge.call(handlerName: "testJavascriptHandler", data: ["foo": "before ready"], callback: nil)
    }

}

extension GWWebViewController {
    convenience init(urlString:String) {
        self.init(url: URL(string: urlString)!)
    }
    
    convenience init(url:URL) {
        self.init(request:URLRequest(url: url))
    }
    
    convenience init(request:URLRequest) {
        self.init()
        self.openRequest(request: request)
    }
   
    open func openURL(urlString:String) {
        self.openURL(url: URL(string: urlString)!)
    }
    
    open func openURL(url:URL) {
        let request = URLRequest(url: url)
        self.openRequest(request: request)
    }
    
    open func openRequest(request:URLRequest) {
        self.webView.load(request)
    }
    
    open func openHTMLString(htmlString:String,baseURL:URL) {
        self.webView.loadHTMLString(htmlString, baseURL: baseURL)
    }
    
    open func doRefresh(){
        
    }
    
    open func reload() {
        self.webView.reload()
    }
    
    open func goBack() {
        self.webView.goBack()
    }
    
    open func goForwad() {
        self.webView.goForward()
    }
}

extension GWWebViewController: WKNavigationDelegate,WKUIDelegate {
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }

    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController.init(title: "提示", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: { (action) in
            completionHandler();
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
}
