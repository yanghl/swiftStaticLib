//
//  GWBridgeManager.swift
//  superora_ios
//
//  Created by yangshiyu on 2020/2/9.
//  Copyright © 2020 xue. All rights reserved.
//

import UIKit
import WKWebViewJavascriptBridge

//管理多个库注册的客户端函数
let bridgeManager = GWBridgeManager()

public protocol JSBridgeModuleProtocol {
    /**
     * 返回js文件路径
     * 原生客户端需要向页面注册的js写到这个文件里
     **/
    func moduleSourceFile() -> String?
    
    //初始化原生客户端开放给js的api
    func attachToJSBridge(bridge:GWBridge)
    
}

 class GWBridgeManager: NSObject {
    var modules:Array<Any> = []
    
    public func addModule<T:JSBridgeModuleProtocol>(module:T) {
        //判断对象是否相等 没有实现
        modules.append(module)
    }
}


