//
//  Debug.swift
//  GWUtilCore
//
//  Created by 刘岩 on 2020/2/8.
//

import Foundation
import UIKit


/// 当前屏幕宽度
public let kScreenWidth = UIScreen.main.bounds.size.width

/// 当前屏幕高度
public let kScreenHeight = UIScreen.main.bounds.size.height

/// 屏幕大小
public let kScreenSize = UIScreen.main.bounds.size

/// 虚拟条高度
public let kDangerAreaTopHeight: CGFloat = UIDevice.isIphoneXSeries ? 44.0 : 20.0
public let kDangerAreaBottomHeight: CGFloat = UIDevice.isIphoneXSeries ? 34.0 : 0.0

/// tabBar高度
public let tabBarHeight: CGFloat = 49.0
public let kTabBarHeight = tabBarHeight + kDangerAreaBottomHeight

/// 导航栏高度
public let navBarHeight: CGFloat = 44.0
public let kNavBarHeight = navBarHeight + kDangerAreaTopHeight

/// 当前设备宽度与设计的比例
public let widthMultiple = kScreenWidth / 375
