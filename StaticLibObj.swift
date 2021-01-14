//
//  StaticLibObj.swift
//  swiftStaticLib
//
//  Created by yangshiyu on 2021/1/14.
//

import Foundation

open class staticLib: NSObject {
    public func printInstanceFun() {
        print("printInstanceFun")
    }
    
    public static func printStaticFun() {
        print("printStaticFun")
    }
}
