//
//  Int+Extenstion.swift
//  GWUtilCore
//
//  Created by yangshiyu on 2020/3/22.
//

import Foundation
public extension Int {
    func toString() -> String {
        return String(format: "%d", self)
    }
    func toString(format:String) -> String {
        return String(format: format, self)
    }
}
