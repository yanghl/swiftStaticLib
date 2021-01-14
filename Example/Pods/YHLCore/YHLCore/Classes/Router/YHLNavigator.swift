//
//  YHLNavigator.swift
//  YHLCore
//
//  Created by yangshiyu on 2020/7/9.
//
import URLNavigator

public typealias URLOpenHandlerAnyFactory = (_ url: URLConvertible, _ values: [String: Any], _ context: Any?) -> Any?
public typealias URLOpenHandlerAny = () -> Any?

public protocol YHLNavigatorType {
    /// 注册通讯方法
    func handleAny(_ pattern: URLPattern, _ factory: @escaping URLOpenHandlerAnyFactory)
    
    /// 获取通讯方法闭包
    func handlerAny(for url: URLConvertible, context: Any?) -> URLOpenHandlerAny?
}

extension YHLNavigatorType {
    @discardableResult
    func openURLAny(_ url: URLConvertible, context: Any?) -> Any? {
      guard let handler = self.handlerAny(for: url, context: context) else { return false }
      return handler()
    }
    
    /// 调用通讯方法
    @discardableResult
    public func openAny(_ url: URLConvertible, context: Any? = nil) -> Any? {
      return self.openURLAny(url, context: context)
    }
}

public extension YHLNavigatorType {
    func handlerAny(for url: URLConvertible) -> URLOpenHandlerAny? {
        return self.handlerAny(for: url, context: nil)
    }
}

public class YHLNavigator: Navigator, YHLNavigatorType {
    var handlerAnyFactories = [URLPattern: URLOpenHandlerAnyFactory]()
    
    public func handleAny(_ pattern: URLPattern, _ factory: @escaping URLOpenHandlerAnyFactory) {
        self.handlerAnyFactories[pattern] = factory
    }
    
    public func handlerAny(for url: URLConvertible, context: Any?) -> URLOpenHandlerAny? {
      let urlPatterns = Array(self.handlerAnyFactories.keys)
      guard let match = self.matcher.match(url, from: urlPatterns) else { return nil }
      guard let handleAny = self.handlerAnyFactories[match.pattern] else { return nil }
        return { handleAny(url, match.values, context) }
    }
    
    /// 路由单例
    public static let shared = YHLNavigator()
    
    /// 屏蔽实现方式
    private override init() {}
}

