//
//  String+Externsion.swift
//  ShopApp
//
//  Created by eme on 16/7/18.
//  Copyright © 2016年 eme. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift
import KeychainAccess
import CommonCrypto
import MoyaMapper
import SwiftyUserDefaults

extension String {
    
    //返回第一次出现的指定子字符串在此字符串中的索引
    //（如果backwards参数设置为true，则返回最后出现的位置）
    public func positionOf(subStr:String, backwards:Bool = false)->Int {
        var pos = -1
        if let range = range(of:subStr, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    
    /// 截取 subStr 之后的字符串 到结尾
    /// GWLog("https://common.ofo.com/about/openbike/?http://ofo.so/plate/36237472".subStringAfter(subStr: "plate/")) //36237472
    /// - Parameters:
    ///   - subStr: 固定的字符串之后
    ///   - backwards: 知否从字符串尾部开始搜索
    /// - Returns: 返回截取之后的字符串
    public func subStringAfter(subStr:String, backwards:Bool = false ) -> String {
        let startPos = self.positionOf(subStr: subStr ,backwards: backwards)
        //没有找到就返回全部字符串
        if startPos == -1 {
            return self
        }
        return String(self[(startPos+subStr.count)...])
    }
    /// 从开头截取字符串到  subStr 之前的字符串
    ///
    ///GWLog("https://common.ofo.com/about/openbike/?http://ofo.so/plate/36237472".subStringBefore(subStr: "plate/")) //https://common.ofo.com/about/openbike/?http://ofo.so/
    /// - Parameters:
    ///   - subStr: 固定的字符串之后
    ///   - backwards: 知否从字符串尾部开始搜索
    /// - Returns: 返回截取之后的字符串
    public func subStringBefore(subStr:String, backwards:Bool = false ) -> String {
        let startPos = self.positionOf(subStr: subStr ,backwards: backwards)
        //没有找到就返回全部字符串
        if startPos == -1 {
            return self
        }
        return String(self[..<(startPos)])
    }
    
}

/*
 let text = "Hello world"
 text[...3] // "Hell"
 text[6..<text.count] // world
 text[NSRange(location: 6, length: 3)] // wor
 */
extension String {
    
    /*
     非闭合截取
     let str00 = "hello world"
     let str01 = str00[..<str00.count]
     */
    public subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            guard let index = index(at: value.upperBound) else{
                return self[..<self.endIndex]
            }
            return self[..<index]
        }
    }
    /*
     闭合截取
     let str00 = "hello world"
     let str01 = str00[...str00.count]
     */
    public subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            guard let index = index(at: value.upperBound) else{
                return self[..<self.endIndex]
            }
            return self[...index]
        }
    }
    /*
     闭合截取
     let str00 = "hello world"
     let str01 = str00[3...]
     */
    public  subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            guard let index = index(at: value.lowerBound) else{
                return self[self.startIndex...]
            }
            /// 这块表示 截取最后一个字母
            if index >= self.endIndex{
                return self[self.startIndex...]
            }
            return self[index...]
        }
    }
    func index(at offset: Int) -> String.Index? {
        if self.count < offset {
            return nil
        }
        return index(startIndex, offsetBy: offset)
        
    }
}
///字符串的处理
extension String {
    
    public func indexOf(_ target: String) -> Int? {
        
        let range = (self as NSString).range(of: target)
        return range.location
    }
    public func lastIndexOf(target: String) -> Int? {
        
        let range = (self as NSString).range(of: target, options: NSString.CompareOptions.backwards)
        return self.count - range.location - 1
        
    }
}
// MARK: - 根据文字计算高度
extension String {
    public func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
// MARK: -转换汉字为拼音
extension String{
    public func transformToPinYin()->String {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        return string.replacingOccurrences(of: " ", with: "")
    }
}

// MARK: - 新写的计算文字Size,后期会改形式 支持NSString，String by yan
protocol CalculateString: ExpressibleByStringLiteral {
    func getSize(font: UIFont, maxSize: CGSize) -> CGSize
}

extension NSString: CalculateString {
    public func getSize(font: UIFont, maxSize: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let op = NSStringDrawingOptions.usesLineFragmentOrigin
        return boundingRect(with: maxSize, options: op, attributes: attributes, context: nil).size
    }
}

extension String: CalculateString {
    public func getSize(font: UIFont, maxSize: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let op = NSStringDrawingOptions.usesLineFragmentOrigin
        return self.boundingRect(with: maxSize, options: op, attributes: attributes, context: nil).size
    }
    
    public func width(font: UIFont) -> CGFloat {
        return getSize(font: font).width
    }
}


//
//  Tools.swift
//  Mayoo
//
//  Created by wang on 2019/11/29.
//  Copyright © 2019 wang. All rights reserved.
//
public extension String {
    
    var utf8Encoded: Data {return data(using: .utf8)!}
    
    var md5 :String {
        let str = cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return String(format: hash as String)
    }
    var sha256 :String {
        let str = cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA256(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return String(format: hash as String)
    }
    
    static func uuid() -> String {
        let keychain = Keychain(service: "uuid")
        guard let uuid = keychain["uuid"] else {
            let uuidString = UUID().uuidString.replacingOccurrences(of: "-", with: "")
            keychain["uuid"] = uuidString
            return uuidString
        }
        return uuid
    }
    
    
    static func getLocalIPAddressForCurrentWiFi() -> String? {
        var address: String?
        
        // get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            
            let interface = ifptr.pointee
            
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return address
    }
}


public extension String  {
    func gw_substring(start:Int,length:Int) -> String {
        assert(start>=0, "起始位置不能小于0")
        assert(start<=self.count, "起始位置不能大于字符串长度")
        assert((start+length)<=self.count, "截取的字符串超出边界")
        let index = self.index(self.startIndex, offsetBy: start)
        let end = self.index(self.startIndex, offsetBy: start+length)
        let subStr = self[index..<end]
        return String(subStr)
    }
   
    subscript(start:Int,end:Int) ->String{
        return self.gw_substring(start: start, length: end-start)
    }
    
    func toDictionary() -> [String:Any]? {
        return try! JSONSerialization.jsonObject(with: self.data(using: String.Encoding.utf8)!, options: .allowFragments) as?  [String:Any]
    }
    func toArray() -> [Any] {
        return try! JSONSerialization.jsonObject(with: self.data(using: String.Encoding.utf8)!, options: .allowFragments) as! [Any]
    }
    
    func AttributedStringConvertible(keys:Array<String> , color:UIColor) -> NSMutableAttributedString {
        let att = NSMutableAttributedString(string: self)
        for key in keys {
            let ranges = self.findsubString(subStr: key)
            for rangeString in ranges {
                let attribute = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)] as [NSAttributedString.Key : Any]
                att.addAttributes(attribute, range:rangeString)
            }
        }
        return att;
    }
    
    func findsubString(subStr:String) -> Array<NSRange> {
        
        var rangeArray:Array<NSRange> = []
        let string1 = self+subStr;
        var temp:String;
        for index in 0 ..< self.count {
            temp = string1.gw_substring(start: index, length: subStr.count)
            if temp == subStr {
                let range = NSRange(location: index, length: subStr.count)
                rangeArray.append(range)
            }
        }
        return rangeArray;
    }
}


public extension String  {
    /// 默认用户名
    static func gwmodule_nickName(name: String?) -> String {
        guard let nick = name else { return "该用户很神秘" }
        if nick.count == 0 || nick == " " {
            return "该用户很神秘"
        } else {
            return nick
        }
    }
    
    /// 默认用户名
    func gwmodule_nickName() -> String {
        if self.count == 0 || self == " " {
            return "该用户很神秘"
        } else {
            return self
        }
    }
    
    
    /// 默认用户名
    var gwmoduleNickName: String {
        if self.count == 0 || self == " " {
            return "该用户很神秘"
        } else {
            return self
        }
    }
    
}


