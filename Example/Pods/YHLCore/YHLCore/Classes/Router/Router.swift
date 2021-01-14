//
//  Router.swift
//  YHLCore
//
//  Created by yangshiyu on 2020/7/9.
//

import Foundation

/// UI
public let UI_PREFIX = "/ui".formatScheme()
/// 商城前缀
public let MALL_PREFIX = "/mall".formatScheme()

public struct URLUI {
    /// animation
    public static let animation = URLAnimation.self
}

public struct URLAnimation {
    /// cashaplayer
    public static let CAShapLayer = UI_PREFIX + "/cashaplayer"
}

