//
//  UIFont+PingFang.swift
//  GWUtilCore
//
//  Created by AaronYin on 2020/3/31.
//

import Foundation

extension UIFont {
    
    public convenience init?(regularFontWithSize size: CGFloat) {
        self.init(name: "PingFang-SC-Regular", size: size)
    }
    
    public convenience init?(mediumFontWithSize size: CGFloat) {
        self.init(name: "PingFang-SC-Medium", size: size)
    }
    
    public convenience init?(lightFontWithSize size: CGFloat) {
        self.init(name: "PingFang-SC-Light", size: size)
    }
    
    public convenience init?(boldFontWithSize size: CGFloat) {
        self.init(name: "PingFang-SC-Semibold", size: size)
    }
    
    public class func regular(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(regularFontWithSize: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    public class func medium(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(mediumFontWithSize: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    public class func light(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(lightFontWithSize: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    public class func bold(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(boldFontWithSize: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
}
