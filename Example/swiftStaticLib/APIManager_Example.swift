//
//  APIManager_Example.swift
//  swiftStaticLib
//
//  Created by 272789124@qq.com on 01/14/2021.
//  Copyright (c) 2021 272789124@qq.com. All rights reserved.
//
import UIKit
import URLNavigator
import YHLCore
import swiftStaticLib

/// 这里是给Example工程的调用示例
extension APIManager {
    func registAllRouter() {
        distributeRouterswiftStaticLibService(YHLNavigator.shared)
        distributeRouterswiftStaticLibServiceExample(YHLNavigator.shared)
    }
}
