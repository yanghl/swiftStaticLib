//
//  NSBundle+Extenstion.swift
//  GWUtilCore
//
//  Created by 刘岩 on 2020/2/10.
//

import Foundation

extension Bundle {
    public class var appInfo: [String: Any]? {
        return Bundle.main.infoDictionary
    }
}

class ExampleBundleClass {}

/**
 遵守这个协议的组件类, 只需要重写bundleName, 和 bundleClass就行了. 因为有命名空间的存在. 每个组件都可以写一个GWBundle类
 ⚠️:  直接用默认权限, 不要用public! 不要用public! 不要用public!
 ```
 class GWBundle: BundleResource {
     static var bundleName: String { get { "<#YourModuleName#>" } }
     // 这个是固定写法
     static var bundleClass: AnyClass { get { GWBundle.self } }
 }
 ```
 */
public protocol BundleResource {
    /// 当前组件bundle的名字
    static var bundleName: String { get }
    
    /// framework 所处的位置
    static var bundleClass: AnyClass { get }
    
    /// 获取模块内Resources内的图片
    static func image(name: String) -> UIImage?
    
    /// 获取模块内Resources内的Nib
    static func nib(name: String) -> UINib
    
    /// 获取模块内Resources内的StoryBoard
    static func storyBoard(name: String) -> UIStoryboard
    
    /// 获取模块内Resources文件夹内的资源文件
    static var currentBundle: Bundle { get }
}

public extension BundleResource {
    static var bundleName: String {
        get { "GWUtilCore" }
    }
    
    static var bundleClass: AnyClass { get { ExampleBundleClass.self } }
    
    static func image(name: String) -> UIImage? {
        UIImage(named: name, in: currentBundle, compatibleWith: nil)
    }
    
    static func nib(name: String) -> UINib {
        UINib(nibName: name, bundle: currentBundle)
    }
    
    static func storyBoard(name: String) -> UIStoryboard {
        UIStoryboard(name: name, bundle: currentBundle)
    }
    
    static var currentBundle: Bundle {
        get {
            let bundle: Bundle = Bundle(for: bundleClass)
            guard let url = bundle.url(forResource: bundleName, withExtension: "bundle") else { return bundle }
            return Bundle(url: url) ?? bundle
        }
    }
}
