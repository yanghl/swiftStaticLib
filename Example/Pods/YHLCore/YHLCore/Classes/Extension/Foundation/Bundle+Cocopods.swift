//
//  Bundle+Cocopods.swift
//  Pods
//
//  Created by AaronYin on 2020/3/23.
//

import Foundation

extension Bundle {
    
    public class var utilCoreBundle: Bundle? {
        return Bundle.podMainBundle(in: "GWUtilCore")
    }
    
}

private var APPBundles: [String: Bundle] = [:]

extension Bundle {
    
    /// 获取Cocopods工程Framework的Bundle
    /// - Parameter frameworkName: 工程名字，例如:GWUtilCore
    public class func podFrameworkBundle(in frameworkName: String) -> Bundle? {
        var staticFrameworkBundle = Bundle.main.bundleURL.appendingPathComponent(frameworkName)
        staticFrameworkBundle = staticFrameworkBundle.appendingPathExtension("bundle")
        if FileManager.default.fileExists(atPath: staticFrameworkBundle.path, isDirectory: nil) {
            return Bundle(url: staticFrameworkBundle)
        }
        var url = Bundle.main.url(forResource: "Frameworks", withExtension: nil)
        url = url?.appendingPathComponent(frameworkName)
        url = url?.appendingPathExtension("framework")
        guard let safeURL = url else {
            return nil
        }
        return Bundle(url: safeURL)
    }
    
    /// 获取Cocopods工程Framework的Bundle中的Bundle
    /// - Parameters:
    ///   - frameworkName: 工程名字，例如:GWUtilCore
    ///   - bundleName: 资源名称，对应podspec中resource_bundles的名称
    public class func podBundle(in frameworkName: String, resourceBundles bundleName: String) -> Bundle? {
        if frameworkName.isEmpty || bundleName.isEmpty {
            return nil
        }
        let key = "\(frameworkName)_\(bundleName)"
        if APPBundles.has(key: key) {
            return APPBundles[key]
        }
        guard let bundle = podFrameworkBundle(in: frameworkName) else { return nil }
        if bundle.bundleURL.path.hasSuffix("bundle") {
            APPBundles[key] = bundle
            return bundle
        }
        guard let url = bundle.url(forResource: bundleName, withExtension: "bundle") else { return nil }
        guard let newBundel = Bundle(url: url) else { return nil}
        APPBundles[key] = newBundel
        return newBundel
    }
    
    /// 适用于工程名称与内部Bundle名称相同的情况
    /// - Parameter frameworkName: 工程名字，例如:GWUtilCore
    public class func podMainBundle(in frameworkName: String) -> Bundle? {
        return self.podBundle(in: frameworkName, resourceBundles: frameworkName)
    }
    
}
