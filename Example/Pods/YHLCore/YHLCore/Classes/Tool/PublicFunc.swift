//
//  PublicFunc.swift
//  Pods
//
//  Created by song on 2020/3/9.
//

import UIKit
import Toast_Swift

/// 延迟加载
/// - Parameters:
///   - seconds: 延迟秒
///   - completion: 延迟方法
public func delay(seconds: Double, completion: @escaping () -> ()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}

/// alert弹框
/// - Parameters:
///   - title: title
///   - message: message
///   - attributedTitle: attributedTitle
///   - attributedMessage: attributedMessage
///   - preferredStyle: preferredStyle
///   - actions: UIAlertAction...
public func GWAlert(title:String? = nil, message:String? = nil, attributedTitle:NSAttributedString? = nil, attributedMessage:NSAttributedString? = nil, preferredStyle: UIAlertController.Style = .alert, actions:UIAlertAction...) -> Void {
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    if let attrTitle = attributedTitle {
        alertVC.setValue(attrTitle, forKey: "attributedTitle")
    }
    if let attrMessage = attributedMessage {
        alertVC.setValue(attrMessage, forKey: "attributedMessage")
    }
    if actions.count == 0 {
        alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
    } else {
        for action in actions {
            alertVC.addAction(action)
        }
    }
    DispatchQueue.main.async {
        YHLNavigator.shared.present(alertVC)
    }
}

//VC 、 Nav 、 Tabbar 查找
public struct GWActiveControllerFinder {
    public static func rootTabBarController() -> UITabBarController? {
        let vc = UIApplication.shared.keyWindow?.rootViewController
        guard let tabVC = vc as? UITabBarController else {
            return nil
        }
        return tabVC
    }
    
    public static func activeNavigationController() -> UINavigationController? {
        
        if let rootVC = self.rootTabBarController() {
            if let nav = rootVC.selectedViewController, nav is UINavigationController {
                let navVC = nav as? UINavigationController
                return navVC?.visibleViewController?.navigationController
            }
        }else{
            let nav = UIApplication.shared.keyWindow?.rootViewController
            if nav is UINavigationController {
                let vc = nav as? UINavigationController
                return vc?.visibleViewController?.navigationController
            }
        }
        return nil
    }
    
    public static func activeTopController () -> UIViewController? {
        
        guard let topVC = self.activeNavigationController()?.topViewController else {
            return UIApplication.shared.keyWindow?.rootViewController
        }
        return topVC
    }
}
