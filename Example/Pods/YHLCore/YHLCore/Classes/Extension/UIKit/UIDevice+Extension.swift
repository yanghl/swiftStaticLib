//
//  UIDevice+Extension.swift
//  GWUtilCore
//
//  Created by 刘岩 on 2020/2/10.
//

import Foundation
import UIKit
import CoreTelephony
import SystemConfiguration.CaptiveNetwork

//暂时不知道 用哪种方法好
//方法需要继续扩充，网络请求基础参数，可能都会涉及到这个类的扩充

//MARK: - 设备信息
public extension UIDevice{
    static var isIphone: Bool{
        return current.userInterfaceIdiom == .phone
    }

    static var isIpad: Bool {
        return current.userInterfaceIdiom == .pad
    }
    
    /// 设备版本的Float类型
    static var systemVersionValue: Float{
        return (current.systemVersion as NSString).floatValue
    }
    
    /// 判断是否为刘海屏
    static var isIphoneXSeries: Bool {
        if #available(iOS 11, *) {
              guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
                  return false
              }
              
              if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
                  // GWLog(unwrapedWindow.safeAreaInsets)
                  return true
              }
        }
        return false
    }

}
 
public extension UIDevice{
    enum DeviceType:String {
        case iPhone_4
        case iPhone_4s
        case iPhone_5
        case iPhone_5c
        case iPhone_5s
        case iPhone_6
        case iPhone_6p
        case iPhone_6s
        case iPhone_6sp
        case iPhone_SE
        case iPhone_7
        case iPhone_7p
        case iPhone_8
        case iPhone_8p
        case iPhone_x
        case iPhone_xr
        case iPhone_xs
        case iPhone_xsMax
        case iPhone_11
        case iPhone_11Pro
        case iPhone_11ProMax
        case iPhone_Simulator
        case unKonwn
    }
    
    class func deviceType() -> DeviceType {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { ide, element in
            guard let v = element.value as? Int8, v != 0 else {
                return ide
            }
            return ide + String(UnicodeScalar(UInt8(v)))
        }
        switch identifier {
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            return DeviceType.iPhone_4
        case "iPhone4,1":
            return DeviceType.iPhone_4s
        case "iPhone5,1", "iPhone5,2":
            return DeviceType.iPhone_5
        case "iPhone5,3", "iPhone5,4":
            return DeviceType.iPhone_5c
        case "iPhone6,1", "iPhone6,2":
            return DeviceType.iPhone_5s
        case "iPhone7,2":
            return DeviceType.iPhone_6
        case "iPhone7,1":
            return DeviceType.iPhone_6p
        case "iPhone8,1":
            return DeviceType.iPhone_6s
        case "iPhone8,2":
            return DeviceType.iPhone_6sp
        case "iPhone8,3","iPhone8,4":
            return DeviceType.iPhone_SE
        case "iPhone9,1","iPhone9,3":
            return DeviceType.iPhone_7
        case "iPhone9,2","iPhone9,4":
            return DeviceType.iPhone_7p
        case "iPhone10,1","iPhone10,4":
            return DeviceType.iPhone_8
        case "iPhone10,2","iPhone10,5":
            return DeviceType.iPhone_8p
        case "iPhone10,3","iPhone10,6":
            return DeviceType.iPhone_x
        case "iPhone11,2":
            return DeviceType.iPhone_xs
        case "iPhone11,4","iPhone11,6":
            return DeviceType.iPhone_xsMax
        case "iPhone11,8":
            return DeviceType.iPhone_xr
        case "iPhone12,1":
            return DeviceType.iPhone_11
        case "iPhone12,3":
            return DeviceType.iPhone_11Pro
        case "iPhone12,5":
            return DeviceType.iPhone_11ProMax
        case "i386","x86_64":
            return DeviceType.iPhone_Simulator
        default:
            return DeviceType.unKonwn
        }
    }
}


// MARK: - iOS版本
extension UIDevice {
    public enum Versions: Float {
        case eight = 8.0
        case nine = 9.0
        case ten = 10.0
        case eleven = 11.0
        case twelve = 12.0
        case thirteen = 13.0
    }
    
    public class func isVersion(_ version: Versions) -> Bool {
        return systemVersionValue >= version.rawValue && systemVersionValue < (version.rawValue + 1.0)
    }
    
    public class func isVersionOrLater(_ version: Versions) -> Bool {
        return systemVersionValue >= version.rawValue
    }
    
    public class func isVersionOrEarlier(_ version: Versions) -> Bool {
        return systemVersionValue < (version.rawValue + 1.0)
    }
}

//MARK: - 屏幕尺寸
public extension UIDevice{
    public enum SizeType {
        case size4
        case size5
        case size6
        case size6P
        case sizeX
        case sizeXM
    }
    
    static var scale: CGFloat {
       return UIScreen.main.scale
    }
    
    func isSize(_ size: SizeType) -> Bool {
        switch size {
        case .size4:
            return __CGSizeEqualToSize(kScreenSize, CGSize(width: 320, height: 480))
        case .size5:
            return __CGSizeEqualToSize(kScreenSize, CGSize(width: 320, height: 568))
        case .size6:
            return __CGSizeEqualToSize(kScreenSize, CGSize(width: 375, height: 667))
        case .size6P:
            return __CGSizeEqualToSize(kScreenSize, CGSize(width: 414, height: 736))
        case .sizeX:
            return __CGSizeEqualToSize(kScreenSize, CGSize(width: 375, height: 812))
        case .sizeXM:
            return __CGSizeEqualToSize(kScreenSize, CGSize(width: 414, height: 896))
        }
    }
}

//MARK: - SIM运营商信息
public extension UIDevice{
    static var carrierName: String?{
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        return carrier?.carrierName
    }
    
    static var carrierNetworkType: String? {
        let networkInfo =  CTTelephonyNetworkInfo()
        return networkInfo.currentRadioAccessTechnology
    }
}

//MARK: - WiFi
//TODO: 需要修改Capability 支持Access WiFi Information ,且不支持模拟器
public extension UIDevice{
    static var wifiName: String? {
        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            return nil
        }
        return interfaceNames.compactMap { name in
            guard
                let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String: AnyObject],
                let ssid = info[kCNNetworkInfoKeySSID as String] as? String
                else {
                    return nil
            }
            return ssid
        }.first
    }
    
    static var wifiMac: String? {
        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            return nil
        }
        return interfaceNames.compactMap { name in
            guard
                let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String: AnyObject],
                let ssid = info[kCNNetworkInfoKeyBSSID as String] as? String
                else {
                    return nil
            }
            return ssid
        }.first
    }
}
