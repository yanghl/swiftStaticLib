//
//  APIManager.swift
//  YHLCore
//
//  Created by yangshiyu on 2020/7/9.
//
import UIKit
import URLNavigator

public enum YHLAPPScheme : String {
    case common = "common"//项目1
    case project = "YHLLearn"//项目1
}

public protocol YHLNavProtocol {
    static var scheme:String{get set}
}

extension YHLNavigator: YHLNavProtocol {
    /**
     用于缓存scheme
     */
    public static var scheme = "common"
}

extension String {
    // 为字符串添加scheme
    public func formatScheme() -> String {
        return "\(YHLNavigator.scheme)://app\(self)"
    }
}

public struct APIManager {
    @discardableResult
    public init(scheme: YHLAPPScheme) {
        YHLNavigator.scheme = scheme.rawValue
    }
    
    /// 提供方法以供拷贝
    func distributeRouterYourModuleName(_ navigator: YHLNavigatorType & NavigatorType) {
        // 路由注册写这里
        fatalError("这个方法无需调用")
    }
    
    /// 提供方法以供拷贝(重写该方法注册所有路由)
    func registAllRouter() {
        fatalError("请在extension重写我")
    }
}
