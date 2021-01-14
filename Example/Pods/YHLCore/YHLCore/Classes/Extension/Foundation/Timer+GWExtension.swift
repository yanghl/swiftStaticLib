//
//  GWProxy.swift
//  Test
//
//  Created by yan on 2020/1/7.
//  Copyright © 2020 All rights reserved.
//

import UIKit
///有效的防止由Time引起的循环引用问题
extension Timer{
    //类方法效仿系统的书写方式,不知道取得名字好听吗 public /*not inherited*/ init(timeInterval ti: TimeInterval, target aTarget: Any, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool)
    static func gw_Timer(timeInterval ti: TimeInterval, target aTarget: NSObjectProtocol, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool) -> Timer {
        let proxy = GWProxy.init(target: aTarget, sel: aSelector)
        let timer = Timer(timeInterval: ti, target: proxy, selector: aSelector, userInfo: userInfo, repeats: yesOrNo)
        proxy.timer = timer
        return timer
    }
}

public class GWProxy: NSObject {
    weak var target: NSObjectProtocol?
    var sel: Selector?
    var timer: Timer?
    
    public init(target: NSObjectProtocol? ,sel: Selector?) {
        super.init()
        self.target = target
        self.sel = sel
        
        guard target?.responds(to: sel) == true else {
            return
        }
        let method = class_getInstanceMethod(object_getClass(self), #selector(redirectionMethod))!
        class_replaceMethod(object_getClass(self), sel!, method_getImplementation(method), method_getTypeEncoding(method))
    }

    @objc private func redirectionMethod () {
        if target != nil {
            target!.perform(self.sel)
        } else {
            // target释放了，则释放timer
            timer?.invalidate()
//            timer = nil
//            GWLog("GWProxy: invalidate timer.")
        }
    }
}

extension Timer {
    
    public convenience init(safeWithTimeInterval ti: TimeInterval, target aTarget: NSObjectProtocol, selector aSelector: Selector, userInfo: Any? = nil, repeats yesOrNo: Bool = true) {
        let proxy = Proxy(target: aTarget)
        self.init(timeInterval: ti, target: proxy, selector: aSelector, userInfo: userInfo, repeats: yesOrNo)
        proxy.timer = self
    }
    
}

extension CADisplayLink {
    
    public convenience init(safeWithTarget target: NSObjectProtocol, selector sel: Selector) {
        let proxy = Proxy(target: target)
        self.init(target: proxy, selector: sel)
        proxy.timer = self
    }
    
}

public class Proxy: NSObject {
    
    private(set) weak var target: NSObjectProtocol?
    
    weak var timer: NSObject?
    
    private lazy var safeProxy = DeinitProxy(timer)
    
    public init(target: NSObjectProtocol?) {
        self.target = target
        super.init()
    }
    
    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        #if DEBUG
        print("消息转发")
        #endif
        if let target = target, target.responds(to: aSelector) {
            return target
        }
        return safeProxy
    }
    
    deinit {
        #if DEBUG
        print("😊代理被释放了!")
        #endif
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        target?.isEqual(object) ?? false
    }
    
    public override var hash: Int {
        target?.hash ?? 0
    }
    
    public override var superclass: AnyClass? {
        target?.superclass
    }
    
    public override func isKind(of aClass: AnyClass) -> Bool {
        target?.isKind(of: aClass) ?? false
    }
    
    public override func conforms(to protocol: Protocol) -> Bool {
        target?.conforms(to: `protocol`) ?? false
    }
    
    public override func isProxy() -> Bool {
        true
    }
    
    public override var description: String {
        target?.description ?? ""
    }
    
    public override var debugDescription: String {
        target?.debugDescription ?? ""
    }
    
}

extension Proxy {
    
    fileprivate class DeinitProxy: NSObject {
        
        weak var timer: NSObject?
        
        init(_ timer: NSObject?) {
            self.timer = timer
            super.init()
        }
        
        override class func resolveInstanceMethod(_ sel: Selector!) -> Bool {
            let method = class_getInstanceMethod(self, #selector(proxyMethod))!
            class_addMethod(self, sel, method_getImplementation(method), method_getTypeEncoding(method))
            return true
        }
        
        @objc private func proxyMethod() {
            #if DEBUG
            print("代理方法")
            #endif
            if (timer is Timer) || (timer is CADisplayLink) {
                timer?.perform(#selector(NSFileProviderEnumerator.invalidate))
            }
        }
        
        deinit {
            #if DEBUG
            print("😊😊安全代理被释放了!")
            #endif
        }
        
    }
    
}
