//
//  ModuleTool.swift
//  swiftStaticLib
//
//  Created by 272789124@qq.com on 01/14/2021.
//  Copyright (c) 2021 272789124@qq.com. All rights reserved.
//


import Foundation
import YHLCore

class GWBundle: BundleResource {
    
    static var bundleName: String { get { "swiftStaticLib" } }
    // 这个是固定写法
    static var bundleClass: AnyClass { get { GWBundle.self } }
    
    static func gw_loadXib(xibName: String) -> [Any]? {
        return GWBundle.currentBundle.loadNibNamed(xibName, owner: nil, options: nil)
    }
}
